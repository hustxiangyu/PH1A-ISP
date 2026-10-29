`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 晴空-Tiso（B站同名）
// 
// Create Date: 2024/07/01 01:39:49
// Design Name: 
// Module Name: sdio_cmd_driver
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
    sdio_cmd_driver SDIO_CMD(
        .cmd_io(),
        .response_data(),
        .timeout(),
        .check_result(),
        .idle(),
        .done(),
        .cmd_index(),
        .cmd_arg(),
        .response_type(),
        .start(),
        .clk(),
        .rst()
        );
*/

//SDIO CMD线驱动
//需要给入六位cmd_index和cmd_arg参数以及预先设置response_type
//发送和接收的crc7校验会自动进行，无需填写
//应答设置查看localparam参数配置部分，如果无需应答，只需要检测done标志位
//如果在接收应答过程中超时了，timeout就会设置为1
//如果有应答内容，接收done信号后同时需要检测check_result标志位
//接收应答后，如果无需进行crc7校验或者需要进行crc7校验且crc7校验通过，则check_result为1
//如果需要进行crc7校验且crc7校验不通过，则check_result为0
//应答的所有内容可以通过response_data读取，R2应答为136位，其他应答为48位
module sdio_cmd_driver(
    inout cmd_io,
    output[135:0] response_data,
    output reg timeout,
    output reg check_result,
    output idle,
    output reg done,
    input[5:0] cmd_index,
    input[31:0] cmd_arg,
    input[2:0] response_type,
    input start,
    input clk,
    input rst
    );
    
    localparam IDLE = 0,
               SEND_CMD = 1,
               WAIT_RESPONCE = 2,
               REC_RESPONCE = 3;
               
    localparam NO_RESPONSE = 0,
               R1 = 1,
               R1b = 1,
               R2 = 2,
               R3 = 3,
               R4 = 4,
               R5 = 5,
               R6 = 6,
               R7 = 7;
    
    wire cmd_out;
    wire cnt_done;
    wire piso_done;
    wire sipo_done;
    wire time_cnt_done;
    wire[6:0] crc7_out;
    wire[6:0] cnt_value;
    wire[38:0] cmd_out_crc7;
    wire[134:0] cmd_responce;
    
    reg[7:0] cnt_var;
    reg[7:0] sipo_bit_nums;
    reg[1:0] state;
    reg done_buf;
    reg cmd_ctr;
    reg begin_signal;
    reg piso_start,sipo_start;
    reg time_cnt_rst,sipo_load;
    reg crc7_in,crc7_en,crc7_rst,cnt_load;
    
    assign cmd_io = cmd_ctr ? 1'bz : cmd_out;
    assign response_data = {1'b0,cmd_responce};
    assign cmd_out_crc7 = {1'b1,cmd_index,cmd_arg};
    assign time_cnt_en = state == WAIT_RESPONCE;
    assign idle = state == IDLE;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            state <= IDLE;
        else begin
            case(state)
                IDLE:
                    if(start)
                        state <= SEND_CMD;
                
                SEND_CMD:
                    if(piso_done) begin
                        if(response_type == 0)
                            state <= IDLE;
                        else
                            state <= WAIT_RESPONCE;
                    end
                
                WAIT_RESPONCE:
                    if(!cmd_io)
                        state <= REC_RESPONCE;
                    else if(time_cnt_done)
                        state <= IDLE;
                
                REC_RESPONCE:
                    if(sipo_done)
                        state <= IDLE;
            endcase
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            cmd_ctr <= 0;
        else begin
            case(state)
                IDLE: cmd_ctr <= 0;
                SEND_CMD: cmd_ctr <= 0;
                default: cmd_ctr <= 1;
            endcase
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            begin_signal <= 0;
        else if(state == IDLE && start)
            begin_signal <= 1;
        else
            begin_signal <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            piso_start <= 0;
        else if(begin_signal)
            piso_start <= 1;
        else
            piso_start <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            sipo_start <= 0;
        else if(state == WAIT_RESPONCE && !cmd_io)
            sipo_start <= 1;
        else
            sipo_start <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            crc7_en <= 0;
        else if(begin_signal || state == WAIT_RESPONCE && !cmd_io)
            crc7_en <= 1;
        else if(cnt_done)
            crc7_en <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            crc7_rst <= 1;
        else if(state == SEND_CMD && piso_done || done || cnt_value > 120)
            crc7_rst <= 1;
        else
            crc7_rst <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            time_cnt_rst <= 1;
        else if(state == IDLE)
            time_cnt_rst <= 1;
        else
            time_cnt_rst <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            sipo_load <= 0;
        else if(state == SEND_CMD)
            sipo_load <= 1;
        else
            sipo_load <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            check_result <= 0;
        else if(sipo_done) begin
            if(response_type == R3 || response_type == R4) //R3 R4无需进行校验
                check_result <= 1;
            else if(crc7_out == cmd_responce[7:1]) begin
                if(response_type == R1) begin //R1额外校验
                    if(cmd_index == cmd_responce[45:40])
                        check_result <= 1;
                    else
                        check_result <= 0;
                end
                else
                    check_result <= 1;
            end
            else
                check_result <= 0; 
        end
        else if(state == IDLE && start)
            check_result <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            done <= 0;
        else if(state == SEND_CMD && piso_done && response_type == 0)
            done <= 1;
        else if(state == REC_RESPONCE && sipo_done)
            done <= 1;
        else
            done <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            timeout <= 0;
        else if(time_cnt_done)
            timeout <= 1;
        else
            timeout <= 0;
    end
    
    always@(*) begin
        if(state == SEND_CMD)
            crc7_in <= cmd_out_crc7[cnt_value];
        else
            crc7_in <= cmd_io;
    end
    
    always@(*) begin
        if(response_type == R2)
            sipo_bit_nums <= 135;
        else
            sipo_bit_nums <= 47;
    end
    
    always@(*) begin
        if(state == IDLE) begin
            cnt_load <= 1;
            cnt_var <= 39;
        end
        else if(state == SEND_CMD && piso_done) begin
            cnt_load <= 1;
            if(response_type == R2)
                cnt_var <= 127;
            else
                cnt_var <= 39;
        end
        else begin
            cnt_load <= 0;
            cnt_var <= 39;
        end
    end
    
    piso_sdio_cmd #(.max_pi_width(48),.default_level(1)) PISO(
        .so(cmd_out),
        .idle(piso_idle),
        .done(piso_done),
        .pi({2'b01,cmd_index,cmd_arg,crc7_out,1'b1}),
        .var_bit_nums(48),
        .start(piso_start),
        .clk(clk),
        .rst(rst)
        );
        
    sipo #(.max_pi_width(135),.var(1)) SIPO(
        .po(cmd_responce),
        .idle(sipo_idle),
        .done(sipo_done),
        .var_bit_nums(sipo_bit_nums),
        .load_var(sipo_load),
        .si(cmd_io),
        .start(sipo_start),
        .clk(clk),
        .rst(rst)
        );
        
    crc7_serial CRC7(
        .crc_out(crc7_out),
        .data_in(crc7_in),
        .en(crc7_en),
        .clk(clk),
        .rst(crc7_rst)
        );
    
    cnt #(
        .dir(1),
        .en(1),
        .var(1),
        .max_value(128)
        ) CNT0
        (
        .cnt_value(cnt_value),
        .done(cnt_done),
        .var_value(cnt_var),
        .load_value(cnt_var-1),
        .load(cnt_load),
        .cnt_en(crc7_en),
        .clk(clk),
        .rst(rst)
        );
    
    cnt #(
        .dir(0),
        .en(1),
        .max_value(65535)
        ) CNT1
        (
        .done(time_cnt_done),
        .cnt_en(time_cnt_en),
        .clk(clk),
        .rst(time_cnt_rst)
        );
    
endmodule
