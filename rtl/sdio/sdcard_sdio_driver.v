`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 晴空-Tiso（B站同名）
// 
// Create Date: 2024/07/25 22:49:56
// Design Name: 
// Module Name: sdcard_sdio_driver
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
    sdcard_sdio_driver SD_DR(
        .cmd_io(),
        .data_io(),
        .sdio_clk(),
        .capacity(),
        .sdhc_vaild(),
        .data_ready(),
        .sector_done(),
        .sector_check(),
        .rd_data(),
        .idle(),
        .done(),
        .sector_addr(),
        .sector_nums(),
        .wr_data(),
        .mode(),
        .start(),
        .clk(),
        .rst()
        );
*/

//sdio_clk频率 = 输入clk的时钟频率，如clk频率为50M，sdio_clk就为50M
//由于大部分开发板都是使用的3V3给SD卡供电，所以这里运行的是高速模式（50M）
//通常来说，任何小于等于50M的时钟频率都应该能正常运行，这里不考虑UHS-I，因为那需要SD卡供电1.8V
//capacity为SD卡的容量，sdhc_vaild为是否SDHC（高容量卡）/SDXC（超高容量卡）标志位
//sdhc_vaild为1则为SDHC/SDXC,为0则为SDSC（低容量卡，2G及以下）
//capacity和sdhc_vaild都是在进行初始化之后就会默认读取的内容，初始化后可以直接读取这两个端口
//mode为功能设置，目前可以设置为五个参数0~4，其中0为初始化，1为单扇区写入，2为单扇区读取
//3为多扇区写入，4为多扇区读取。
//sector_addr在SDHC/SDXC情况下为要开始写入或者读取的扇区地址，如果是SDSC则为数据地址
//sector_nums为要读写的扇区数量，仅在多扇区读写情况下需要给定，单扇区读写可以忽略该端口

//在写入时，wr_data为要写入的数据，先设置为首个要写入的数据，然后在接收到data_ready为1后的下一个时钟周期
//去更新wr_data为下一个要写入的数据，写入满一个扇区后，sector_done会到来一个高电平
//写入全部完成后，会返回done标志位一个高电平

//在读取时，rd_data为读取出来的数据，rd_data就绪会返回一个data_ready高电平
//上层可以在每获取到一次data_ready高电平时就读取一次rd_data数据
//读取完成一个扇区后，sector_done会到来一个高电平，同时，
//如果该扇区的数据通过了crc16校验，则sector_check也会为和sector_done一样为高电平
module sdcard_sdio_driver(
    inout cmd_io,                   //双向命令端口
    inout[3:0] data_io,             //双向数据端口
    output sdio_clk,                //SDIO时钟端口
    output reg[63:0] capacity,      //SD卡容量显示
    output reg sdhc_vaild,          //SD卡是否为SDHC/SDXC标志位
    output data_ready,              //数据就绪标志位
    output sector_done,             //SD卡扇区操作完成信号
    output sector_check,            //操作完成的扇区在读取时是否通过了CRC16校验信号
    output[7:0] rd_data,            //读取出的数据流端口
    output idle,                    //模块空闲标志位
    output reg done,                //模块完成信号
    input[31:0] sector_addr,        //开始操作的扇区地址
    input[15:0] sector_nums,        //要操作的扇区数量
    input[7:0] wr_data,             //要写入的数据流端口
    input[2:0] mode,                //模式控制位
    input start,                    //开始信号
    input clk,                      //输入时钟
    input rst                       //复位信号
    );
    
    localparam IDLE = 0,
               SEND_CMD0 = 1,
               WAIT_SD = 2,
               SEND_CMD8 = 3,
               SEND_A41_CMD55 = 4,
               SEND_ACMD41 = 5,
               SEND_CMD2 = 6,
               SEND_CMD3 = 7,
               SEND_CMD9 = 8,
               SEND_CMD7 = 9,
               SEND_A6_CMD55 = 10,
               SEND_ACMD6 = 11,
               SEND_CMD6 = 12,
               SEND_CMD13 = 13,
               SEND_CMD24 = 14,
               WR_SINGLE_BLOCK = 15,
               SEND_A23_CMD55 = 16,
               SEND_ACMD23 = 17,
               SEND_CMD25 = 18,
               WR_MULT_BLOCK = 19,
               SEND_CMD17 = 20,
               RD_SINGLE_BLOCK = 21,
               SEND_CMD18 = 22,
               RD_MULT_BLOCK = 23,
               SEND_CMD12 = 24,
               FINISH = 25;
    
    localparam CMD0 = 0,
               CMD8 = 1,
               CMD55_INIT = 2,
               ACMD41 = 3,
               CMD2 = 4,
               CMD3 = 5,
               CMD9 = 6,
               CMD7 = 7,
               CMD55_RCA = 8,
               ACMD6 = 9,
               CMD6 = 10,
               CMD13 = 11,
               CMD24 = 12,
               CMD17 = 13,
               ACMD23 = 14,
               CMD25 = 15,
               CMD18 = 16,
               CMD12 = 17;
    
    localparam NO_RESPONSE = 0,
               R1 = 1,
               R1b = 1,
               R2 = 2,
               R3 = 3,
               R4 = 4,
               R5 = 5,
               R6 = 6,
               R7 = 7;
    
    wire timeout;
    wire cmd_done;
    wire cmd_idle;
    wire cmd_check;
    wire wait_done;
    wire data_idle;
    wire data_done;
    wire[135:0] response_data;
    
    reg[4:0] state;
    reg wait_en;
    reg cmd_start;
    reg[5:0] cmd_index;
    reg[2:0] response_type;
    reg[15:0] rca;
    reg[31:0] cmd_arg;
    reg data_start,data_mode;
    reg loop_en;
    
    assign sdio_clk = clk;
    assign idle = state == IDLE;
    
    task cmd_set_val;
        input[4:0] cmd_value;
        begin
            case(cmd_value)
                CMD0: begin
                    cmd_index = 0;
                    cmd_arg = 0;
                    response_type = NO_RESPONSE;
                end
                
                CMD8: begin
                    cmd_index = 8;
                    cmd_arg = 32'h1AA;
                    response_type = R7;
                end
                
                CMD55_INIT: begin
                    cmd_index = 55;
                    cmd_arg = 0;
                    response_type = R1;
                end
                
                ACMD41: begin
                    cmd_index = 41;
                    if(sdhc_vaild)
                        cmd_arg = 32'hC0100000;
                    else
                        cmd_arg = 32'h80100000;
                    response_type = R3;
                end
                
                CMD2: begin
                    cmd_index = 2;
                    cmd_arg = 0;
                    response_type = R2;
                end
                
                CMD3: begin
                    cmd_index = 3;
                    cmd_arg = 0;
                    response_type = R6;
                end
                
                CMD9: begin
                    cmd_index = 9;
                    cmd_arg = {rca,16'b0};
                    response_type = R2;
                end
                
                CMD7: begin
                    cmd_index = 7;
                    cmd_arg = {rca,16'b0};
                    response_type = R1;
                end
                
                CMD55_RCA: begin
                    cmd_index = 55;
                    cmd_arg = {rca,16'b0};
                    response_type = R1;
                end
                
                ACMD6: begin
                    cmd_index = 6;
                    cmd_arg = 2;
                    response_type = R1;
                end
                
                CMD6: begin
                    cmd_index = 6;
                    cmd_arg = 32'h80FFFFF1;
                    response_type = R1;
                end
                
                CMD13: begin
                    cmd_index = 13;
                    cmd_arg = {rca,16'b0};
                    response_type = R1;
                end
                
                CMD24: begin
                    cmd_index = 24;
                    cmd_arg = sector_addr;
                    response_type = R1;
                end
                
                CMD17: begin
                    cmd_index = 17;
                    cmd_arg = sector_addr;
                    response_type = R1;
                end
                
                ACMD23: begin
                    cmd_index = 23;
                    cmd_arg = sector_nums;
                    response_type = R1;
                end
                
                CMD25: begin
                    cmd_index = 25;
                    cmd_arg = sector_addr;
                    response_type = R1;
                end
                
                CMD18: begin
                    cmd_index = 18;
                    cmd_arg = sector_addr;
                    response_type = R1;
                end
                
                CMD12: begin
                    cmd_index = 12;
                    cmd_arg = 0;
                    response_type = R1;
                end
                
            endcase
        end
    endtask
    
    always@(*) begin
        case(state)
            SEND_CMD0: cmd_set_val(CMD0);
            SEND_CMD8: cmd_set_val(CMD8);
            SEND_A41_CMD55: cmd_set_val(CMD55_INIT);
            SEND_ACMD41: cmd_set_val(ACMD41);
            SEND_CMD2: cmd_set_val(CMD2);
            SEND_CMD3: cmd_set_val(CMD3);
            SEND_CMD9: cmd_set_val(CMD9);
            SEND_CMD7: cmd_set_val(CMD7);
            SEND_A6_CMD55: cmd_set_val(CMD55_RCA);
            SEND_ACMD6: cmd_set_val(ACMD6);
            SEND_CMD6: cmd_set_val(CMD6);
            SEND_CMD13: cmd_set_val(CMD13);
            SEND_CMD24: cmd_set_val(CMD24);
            SEND_CMD17: cmd_set_val(CMD17);
            SEND_A23_CMD55: cmd_set_val(CMD55_RCA);
            SEND_ACMD23: cmd_set_val(ACMD23);
            SEND_CMD25: cmd_set_val(CMD25);
            SEND_CMD18: cmd_set_val(CMD18);
            SEND_CMD12: cmd_set_val(CMD12);
            default: cmd_set_val(CMD0);
        endcase
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            state <= IDLE;
        else begin
            case(state)
                IDLE: begin
                    if(start) begin
                        if(mode>0)
                            state <= SEND_CMD13;
                        else
                            state <= SEND_CMD0;
                    end
                end
                
                SEND_CMD0: begin
                    if(cmd_done)
                        state <= WAIT_SD;
                end
                
                WAIT_SD: begin
                    if(wait_done)
                        state <= SEND_CMD8;
                end
                
                SEND_CMD8: begin
                    if(cmd_done) begin
                        if(cmd_check)
                            state <= SEND_A41_CMD55;
                        else
                            state <= SEND_CMD8;
                    end
                    else if(timeout)
                        state <= SEND_A41_CMD55;
                end
                
                SEND_A41_CMD55: begin
                    if(cmd_done && cmd_check)
                        state <= SEND_ACMD41;
                end
                
                SEND_ACMD41: begin
                    if(cmd_done) begin
                        if(cmd_check && response_data[39] == 1)
                            state <= SEND_CMD2;
                        else
                            state <= SEND_A41_CMD55;
                    end
                    else if(timeout)
                        state <= SEND_A41_CMD55;
                end
                
                SEND_CMD2: begin
                    if(cmd_done && cmd_check)
                        state <= SEND_CMD3;
                end
                
                SEND_CMD3: begin
                    if(cmd_done && cmd_check)
                        state <= SEND_CMD9;
                end
                
                SEND_CMD9: begin
                    if(cmd_done && cmd_check)
                        state <= SEND_CMD7;
                end
                
                SEND_CMD7: begin
                    if(cmd_done && cmd_check)
                        state <= SEND_A6_CMD55;
                end
                
                SEND_A6_CMD55: begin
                    if(cmd_done && cmd_check)
                        state <= SEND_ACMD6;
                end
                
                SEND_ACMD6: begin
                    if(cmd_done) begin
                        if(cmd_check)
                            state <= SEND_CMD6;
                        else
                            state <= SEND_A6_CMD55;
                    end
                end
                
                SEND_CMD6: begin
                    if(cmd_done) begin
                        if(cmd_check)
                            state <= RD_SINGLE_BLOCK;
                    end
                end
                
                SEND_CMD13: begin
                    if(cmd_done) begin
                        if(cmd_check && response_data[20:16] == 5'b1001) begin
                            case(mode)
                                1: state <= SEND_CMD24;
                                2: state <= SEND_CMD17;
                                3: state <= SEND_A23_CMD55;
                                4: state <= SEND_A23_CMD55;
                                default: state <= FINISH;
                            endcase
                        end
                    end
                end
                
                SEND_CMD24: begin
                    if(cmd_done && cmd_check)
                        state <= WR_SINGLE_BLOCK;
                end
                
                WR_SINGLE_BLOCK: begin
                    if(data_done)
                        state <= FINISH;
                end
                
                SEND_CMD17: begin
                    if(cmd_done && cmd_check)
                        state <= RD_SINGLE_BLOCK;
                end
                
                RD_SINGLE_BLOCK: begin
                    if(data_done)
                        state <= FINISH;
                end
                
                SEND_A23_CMD55: begin
                    if(cmd_done && cmd_check)
                        state <= SEND_ACMD23;
                end
                
                SEND_ACMD23: begin
                    if(cmd_done && cmd_check) begin
                        if(mode == 3)
                            state <= SEND_CMD25;
                        else if(mode == 4)
                            state <= SEND_CMD18;
                    end
                end
                
                SEND_CMD25: begin
                    if(cmd_done && cmd_check)
                        state <= WR_MULT_BLOCK;
                end
                
                WR_MULT_BLOCK: begin
                    if(data_done)
                        state <= SEND_CMD12;
                end
                
                SEND_CMD18: begin
                    if(cmd_done && cmd_check)
                        state <= RD_MULT_BLOCK;
                end
                
                RD_MULT_BLOCK: begin
                    if(data_done)
                        state <= SEND_CMD12;
                end
                
                SEND_CMD12: begin
                    if(cmd_done && cmd_check)
                        state <= FINISH;
                end
                
                FINISH:
                    state <= IDLE;
                
                default:
                    state <= IDLE;
            endcase
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            done <= 0;
        else if(state == FINISH)
            done <= 1;
        else
            done <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            cmd_start <= 0;
        else begin
            case(state)
                IDLE: 
                    if(start)
                        cmd_start <= 1;
                
                SEND_CMD0: begin
                    if(!cmd_idle)
                        cmd_start <= 0;
                end
                
                WAIT_SD: begin
                    if(wait_done)
                        cmd_start <= 1;
                end
                
                SEND_CMD8,SEND_A41_CMD55,SEND_ACMD41,SEND_CMD2,SEND_CMD3,SEND_CMD9: begin
                    if(cmd_done | timeout)
                        cmd_start <= 1;
                    else if(!cmd_idle)
                        cmd_start <= 0;
                end
                
                SEND_CMD13,SEND_CMD7,SEND_A6_CMD55,SEND_A23_CMD55,SEND_ACMD23,SEND_ACMD6: begin
                    if(cmd_done | timeout)
                        cmd_start <= 1;
                    else if(!cmd_idle)
                        cmd_start <= 0;
                end
                
                SEND_CMD6,SEND_CMD12: begin
                    if((cmd_done && !cmd_check) | timeout)
                        cmd_start <= 1;
                    else if(!cmd_idle)
                        cmd_start <= 0;
                end
                
                SEND_CMD24,SEND_CMD17,SEND_CMD25,SEND_CMD18: begin
                    if(cmd_done && !cmd_check | timeout)
                        cmd_start <= 1;
                    else if(!cmd_idle)
                        cmd_start <= 0;
                end
                
                WR_MULT_BLOCK,RD_MULT_BLOCK: begin
                    if(data_done)
                        cmd_start <= 1;
                end
                
                default: cmd_start <= 0;
            endcase
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            sdhc_vaild <= 0;
        else if(state == SEND_CMD8)
        begin
            if(cmd_done && cmd_check && response_data[16:8] == 9'h1AA)
                sdhc_vaild <= 1;
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            rca <= 0;
        else if(state == SEND_CMD3 && cmd_done && cmd_check)
            rca <= response_data[39:24];
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            capacity <= 0;
        else if(state == SEND_CMD9 && cmd_done && cmd_check)
            capacity <= {response_data[69:48]+1,19'b0};
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            data_start <= 0;
        else begin
            case(state)
                SEND_CMD24,SEND_CMD17,SEND_CMD25,SEND_CMD18,SEND_CMD6: begin
                    if(cmd_done && cmd_check)
                        data_start <= 1;
                end
                
                WR_SINGLE_BLOCK,RD_SINGLE_BLOCK,WR_MULT_BLOCK,RD_MULT_BLOCK: begin
                    if(!data_idle)
                        data_start <= 0;
                end
                
                default:
                    data_start <= 0;
            endcase
        end 
    end
    
    always@(*) begin
        if(state == WR_MULT_BLOCK || state == RD_MULT_BLOCK)
            loop_en = 1;
        else
            loop_en = 0;
    end
    
    always@(*) begin
        case(state)
            SEND_CMD17,SEND_CMD18,SEND_CMD6:
                data_mode <= 1;
                
            RD_SINGLE_BLOCK,RD_MULT_BLOCK:
                data_mode <= 1;
            
            default:
                data_mode <= 0;
        endcase
    end
    
    always@(*) begin
        if(state == WAIT_SD)
            wait_en = 1;
        else
            wait_en = 0;
    end
    
    sdio_cmd_driver SDIO_CMD(
        .cmd_io(cmd_io),
        .response_data(response_data),
        .timeout(timeout),
        .check_result(cmd_check),
        .idle(cmd_idle),
        .done(cmd_done),
        .cmd_index(cmd_index),
        .cmd_arg(cmd_arg),
        .response_type(response_type),
        .start(cmd_start),
        .clk(clk),
        .rst(rst)
        );
        
    sdio_data_driver SDIO_DATA(
        .data_io(data_io),
        .rec_data(rd_data),
        .check_result(sector_check),
        .data_ready(data_ready),
        .idle(data_idle),
        .done(data_done),
        .sector_done(sector_done),
        .send_data(wr_data),
        .loop_times(sector_nums),
        .loop_en(loop_en),
        .mode(data_mode),
        .start(data_start),
        .clk(clk),
        .rst(rst)
        );
        
    cnt #(
        .dir(0),
        .en(1),
        .max_value(75)
        ) CNT0
        (
        .cnt_value(),
        .done(wait_done),
        .cnt_en(wait_en),
        .clk(clk),
        .rst(rst)
        );
        
endmodule