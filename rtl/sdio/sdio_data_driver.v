`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 晴空-Tiso（B站同名）
// 
// Create Date: 2024/07/22 23:55:01
// Design Name: 
// Module Name: sdio_data_driver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    sdio_data_driver SDIO_DATA(
        .data_io(),
        .rec_data(),
        .check_result(),
        .data_ready(),
        .idle(),
        .done(),
        .sector_done(),
        .send_data(),
        .loop_times(),
        .loop_en(),
        .mode(),
        .start(),
        .clk(),
        .rst()
        );
*/

//SDIO DATA线驱动
//通过mode端口来控制DATA线的发送和接收，0：发送，1：接收
//发送过程会自动计算CRC16值并附到最后发送
//接收过程会自动计算CRC16值并与接收到的CRC16数值进行核验
//发送过程中，首个发送内容在start拉高时设置send_data，后续在接收到data_ready高电平时更新
//接收过程中，收到data_ready高电平即可取出rec_data
//通过loop_en打开多扇区连续写/连续读功能，当loop_en设置为1时，loop_times为连续读写扇区数量
//如果loop_en为0，则只读写一个扇区。
//每读写完一次扇区，都会返回一个时钟周期的sector_done信号
//如果是读取过程，且CRC16核验通过，则check_result会和sector_done一起设置一个时钟周期高电平
//写入/读取完指定loop_times扇区后，会返回一个done高电平，并返回IDLE状态
module sdio_data_driver (
    inout[3:0] data_io,
    output[7:0] rec_data,
    output reg check_result,
    output reg data_ready,
    output idle,
    output reg done,
    output reg sector_done,
    input[7:0] send_data,
    input[15:0] loop_times,
    input loop_en,
    input mode,
    input start,
    input clk,
    input rst
    );
    
    localparam IDLE = 0,
               SEND_BEGIN = 1,
               SEND_DATA = 2,
               SEND_CRC16 = 3,
               SEND_WAIT = 4,
               WAIT_BUSY = 5,
               REC_BEGIN = 6,
               REC_DATA = 7,
               REC_CRC16 = 8;
    
    integer i;
    
    wire piso_done;
    wire sipo_done;
    wire crc_cnt_done;
    wire crc_rst_rise;
    wire data_cnt_done;
    wire loop_cnt_done;
    wire part_cnt_value;
    wire[3:0] crc_cnt_value;
    wire[3:0] data_out;
    wire[7:0] sipo_po;
    wire[15:0] crc_out0;
    wire[15:0] crc_out1;
    wire[15:0] crc_out2;
    wire[15:0] crc_out3;
    
    reg[3:0] state;
    reg[3:0] crc_in;
    reg[3:0] data_buf;
    reg[7:0] piso_pi;
    reg[7:0] sipo_buf;
    reg[63:0] crc_buf;
    reg[63:0] crc_out;
    reg check_buf;
    reg loop_cnt_en,piso_start,piso_next,sipo_start,sipo_next;
    reg crc_en,crc_cnt_en,crc_rst,crc_rst_begin,data_ctr,data_cnt_en;
    
    assign data_io = data_ctr ? 4'bzzzz : data_out;
    assign rec_data = sipo_po;
    assign idle = state == IDLE;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            state <= IDLE;
        else begin
            case(state)
                IDLE:
                    if(start) begin
                        if(mode) begin
                            if((data_buf == 4'b1111 && data_io == 4'b0000))
                                state <= REC_DATA;
                            else
                                state <= REC_BEGIN;
                        end
                        else
                            state <= SEND_BEGIN;
                    end
                
                SEND_BEGIN:
                    if(piso_done)
                        state <= SEND_DATA;
                
                SEND_DATA:
                    if(data_cnt_done)
                        state <= SEND_CRC16;
                
                SEND_CRC16:
                    if(crc_cnt_done) begin
                        if(loop_en && !loop_cnt_done)
                            state <= SEND_WAIT;
                        else
                            state <= IDLE;
                    end
                
                SEND_WAIT: begin
                    if(data_io[0] == 0)
                        state <= WAIT_BUSY;
                end
                
                WAIT_BUSY: begin
                    if(data_io[0] == 1 && data_buf[0] == 1)
                        state <= SEND_BEGIN;
                end
                
                REC_BEGIN:
                    if(data_buf == 4'b1111 && data_io == 4'b0000)
                        state <= REC_DATA;
                
                REC_DATA:
                    if(data_cnt_done)
                        state <= REC_CRC16;
                
                REC_CRC16:
                    if(crc_cnt_done) begin
                        if(loop_en && !loop_cnt_done)
                            state <= REC_BEGIN;
                        else
                            state <= IDLE;
                    end
                
            endcase
        end    
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            data_ctr <= 0;
        else begin
            case(state)
                SEND_BEGIN: begin
                    data_ctr <= 0;
                end
                
                SEND_DATA,SEND_CRC16: begin
                    data_ctr <= 0;
                end
                
                default: begin
                    data_ctr <= 1;
                end
                
            endcase
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            sipo_buf <= 0;
        else if(sipo_done)
            sipo_buf <= sipo_po;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            data_buf <= 0;
        else
            data_buf <= data_io;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            crc_buf <= 0;
        else if(data_cnt_done || state == SEND_CRC16 && crc_rst_rise)
            crc_buf <= crc_out;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            crc_rst_begin <= 1;
        else begin
            if(state == SEND_CRC16 || state == REC_CRC16)
                crc_rst_begin <= 1;
            else
                crc_rst_begin <= 0;
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            crc_rst <= 1;
        else
            crc_rst <= crc_rst_rise;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            check_buf <= 0;
        else if(state == REC_DATA && data_cnt_done)
            check_buf <= 1;
        else if(state == REC_CRC16 && check_buf == 1)
        begin
            if(crc_cnt_value[1:0] == 2'b11) begin
                if(crc_buf[(4-crc_cnt_value[3:2])*16-1-:16] == {sipo_buf,sipo_po})
                    check_buf <= 1;
                else
                    check_buf <= 0;
            end
            else
                check_buf <= 1;
        end
        else
             check_buf <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            check_result <= 1;
        else if(state == REC_CRC16 && crc_cnt_done) begin
            if(check_buf == 1)
                check_result <= 1;
            else
                check_result <= 0;
        end
        else
            check_result <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst) begin
            done <= 0;
            sector_done <= 0;
        end
        else if((state == SEND_CRC16 || state == REC_CRC16) && crc_cnt_done) begin
            if(loop_en && !loop_cnt_done)
                done <= 0;
            else
                done <= 1;
            sector_done <= 1;
        end
        else begin
            done <= 0;
            sector_done <= 0;
        end
    end
    
    always@(*) begin
        for(i = 0;i < 64;i = i + 1)
        begin
            case(i[1:0])
                2'b00:
                    crc_out[i] = crc_out0[i[5:2]];
                
                2'b01:
                    crc_out[i] = crc_out1[i[5:2]];
                
                2'b10:
                    crc_out[i] = crc_out2[i[5:2]];
                    
                2'b11:
                    crc_out[i] = crc_out3[i[5:2]];
            endcase
        end
    end
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            piso_pi = 8'hff;
            piso_start = 0;
            piso_next = 0;
        end
        else begin
            case(state)
                SEND_BEGIN: begin
                    piso_pi = 8'hf0;
                    piso_start = 1;
                    piso_next = 1;
                end
                
                SEND_DATA: begin
                    piso_pi = send_data;
                    piso_start = 0;
                    piso_next = 1;
                end
                
                SEND_CRC16: begin
                    if(crc_cnt_value <= 1)
                        piso_pi = crc_out[63-:8];
                    else
                        piso_pi = crc_buf[(16-crc_cnt_value+1)/2*8-1-:8];
                    piso_start = 0;
                    piso_next = 1;
                end
                
                default: begin
                    piso_pi = 0;
                    piso_start = 0;
                    piso_next = 0;
                end
            endcase
        end
    end
    
    always@(*)
    begin
        if(rst) begin
            sipo_start = 0;
            sipo_next = 0;
        end
        else begin
            case(state)
                REC_DATA: begin
                    sipo_start = 1;
                    sipo_next = 1;
                end
                
                REC_CRC16: begin
                    sipo_start = 0;
                    sipo_next = 1;
                end
                
                default: begin
                    sipo_start = 0;
                    sipo_next = 0;
                end
            endcase
        end
    end
    
    always@(*) begin
        case(state)
            SEND_DATA:
                data_cnt_en = piso_done;
                
            REC_DATA:
                data_cnt_en = sipo_done;
            
            default:
                data_cnt_en = 0;
            
        endcase
    end
    
    always@(*) begin
        case(state)
            SEND_CRC16: begin
                if(loop_en)
                    loop_cnt_en = crc_cnt_done;
                else
                    loop_cnt_en = 0;
            end
            
            REC_CRC16: begin
                if(loop_en)
                    loop_cnt_en = crc_cnt_done;
                else
                    loop_cnt_en = 0;
            end
            
            default:
                loop_cnt_en = 0;
            
        endcase
    end
    
    always@(*) begin
        case(state)
            SEND_CRC16:
                crc_cnt_en <= 1;
                
            REC_CRC16:
                crc_cnt_en <= 1;
            
            default:
                crc_cnt_en <= 0;
        endcase
    end
    
    always@(*) begin
        case(state)
            SEND_DATA: begin
                if(part_cnt_value)
                    crc_in = send_data[3:0];
                else
                    crc_in = send_data[7:4];
                crc_en = 1;
            end
            
            REC_DATA: begin
                crc_in = data_io;
                crc_en = 1;
            end
            
            default: begin
                crc_in = 0;
                crc_en = 0;
            end
        endcase
    end
    
    always@(*) begin
        case(state) 
            SEND_DATA: begin
                if(data_cnt_done)
                    data_ready = 0;
                else if(piso_done)
                    data_ready = 1;
                else
                    data_ready = 0;
            end
            
            SEND_CRC16: begin
                if(crc_cnt_done) 
                    data_ready = 1;
                else
                    data_ready = 0;
            end
            
            REC_DATA: begin
                if(sipo_done)
                    data_ready = 1;
                else
                    data_ready = 0;
            end
            
            default:
                data_ready = 0;
            
        endcase
    end
    
    piso_4bit_sdio_data #(.max_pi_width(8),.default_level(4'b1111)) PISO(
        .so(data_out),
        .idle(piso_idle),
        .done(piso_done),
        .pi(piso_pi),
        .start(piso_start),
        .next(piso_next),
        .clk(clk),
        .rst(rst)
        );
    
    sipo_4bit #(.max_pi_width(8)) SIPO(
        .po(sipo_po),
        .idle(sipo_idle),
        .done(sipo_done),
        .si(data_io),
        .start(sipo_start),
        .next(sipo_next),
        .clk(clk),
        .rst(rst)
        );
    
    crc16_serial CRC16_0(
        .crc_out(crc_out0),
        .data_in(crc_in[0]),
        .en(crc_en),
        .clk(clk),
        .rst(crc_rst)
        );
        
    crc16_serial CRC16_1(
        .crc_out(crc_out1),
        .data_in(crc_in[1]),
        .en(crc_en),
        .clk(clk),
        .rst(crc_rst)
        );
        
    crc16_serial CRC16_2(
        .crc_out(crc_out2),
        .data_in(crc_in[2]),
        .en(crc_en),
        .clk(clk),
        .rst(crc_rst)
        );
        
    crc16_serial CRC16_3(
        .crc_out(crc_out3),
        .data_in(crc_in[3]),
        .en(crc_en),
        .clk(clk),
        .rst(crc_rst)
        );
    
    sequence_comparator #(.width(2),.filt_sequence(2'b01)) SC0(
        .result(crc_rst_rise),
        .sequence_in(crc_rst_begin),
        .clk(clk),
        .rst(rst)
        );
    
    cnt #(
        .dir(0),
        .en(1),
        .max_value(512)
        ) CNT0
        (
        .cnt_value(),
        .done(data_cnt_done),
        .cnt_en(data_cnt_en),
        .clk(clk),
        .rst(rst)
        );
    
    cnt #(
        .dir(0),
        .en(1),
        .max_value(16)
        ) CNT1
        (
        .cnt_value(crc_cnt_value),
        .done(crc_cnt_done),
        .cnt_en(crc_cnt_en),
        .clk(clk),
        .rst(rst)
        );
    
    cnt #(
        .dir(0),
        .en(1),
        .var(1),
        .max_value(65536)
        ) CNT2
        (
        .cnt_value(),
        .done(loop_cnt_done),
        .var_value(loop_times),
        .cnt_en(loop_cnt_en),
        .clk(clk),
        .rst(rst)
        );
        
    cnt #(
        .dir(0),
        .en(1),
        .max_value(2)
        ) CNT4
        (
        .cnt_value(part_cnt_value),
        .cnt_en(crc_en),
        .clk(clk),
        .rst(crc_rst)
        );
    
endmodule
