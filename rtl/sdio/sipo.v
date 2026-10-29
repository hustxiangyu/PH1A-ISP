`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 晴空-Tiso（B站同名）
// 
// Create Date: 2024/06/12 02:09:40
// Design Name: 
// Module Name: sipo
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
    sipo #(.max_pi_width()) SIPO(
        .po(),
        .idle(),
        .done(),
        .var_bit_nums(),
        .load_var(),
        .si(),
        .start(),
        .next(),
        .clk(),
        .rst()
        );
*/

//串入并出模块
//max_pi_width为最大并行输入宽度
//po端口为并行输出端口，si为串行输入端口
//如果var设置为1（在SV环境下设置var_option）,则var_bit_nums为串行可变输出次数
//修改var_bit_nums时应同时拉高load_var端口一次。
//start，idle，done为一组TMC控制接口，分别表示启动模块，空闲标志位和完成信号
module sipo #(parameter max_pi_width = 8,var_option = 0,var = var_option,cnt_width = max_pi_width > 0 ? clog2(max_pi_width) : 1)(
    output reg[max_pi_width-1:0] po,
    output idle,
    output reg done,
    input[cnt_width-1:0] var_bit_nums,
    input load_var,
    input si,
    input start,
    input next,
    input clk,
    input rst
    );
    
    function integer clog2;
    input integer value;
    begin
        value = value - 1;
        for (clog2 = 0; value > 0; clog2 = clog2 + 1) begin
            value = value >> 1;
        end
    end
    endfunction
    
    localparam IDLE = 0,
               TRANS = 1;
    
    wire cnt_done;
    wire[cnt_width-1:0] cnt_value;
    
    reg state;
    reg[max_pi_width-1:0] po_buf;
    
    assign idle = state == IDLE;
    assign cnt_en = state == IDLE && start || state == TRANS;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            state <= IDLE;
        else if(state == IDLE) begin
            if(start)
                state <= TRANS;
        end
        else if(cnt_done) begin
            if(next)
                state <= TRANS;
            else
                state <= IDLE;
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            po_buf <= 0;
        else if((state == IDLE) && start || state == TRANS)
            po_buf[cnt_value] <= si;
        else if(done)
            po_buf <= 0;
    end
    
    always@(posedge clk or posedge rst)
    begin
        if(rst) begin
            po <= 0;
            done <= 0;
        end
        else if(cnt_done) begin
            po <= {po_buf[max_pi_width-1:1],si};
            done <= 1;
        end
        else
            done <= 0;
    end
    
    cnt #(
        .dir(1),
        .en(1),
        .var(var),
        .max_value(max_pi_width)
        ) CNT0
        (
        .cnt_value(cnt_value),
        .done(cnt_done),
        .var_value(var_bit_nums),
        .load_value(var_bit_nums-1),
        .load(load_var),
        .cnt_en(cnt_en),
        .clk(clk),
        .rst(rst)
        );
    
endmodule
