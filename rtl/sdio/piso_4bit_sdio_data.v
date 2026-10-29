`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 晴空-Tiso（B站同名）
// 
// Create Date: 2024/10/04 04:40:29
// Design Name: 
// Module Name: piso_4bit_sdio_data
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

//针对SDIO DATA专门优化的PISO模块
module piso_4bit_sdio_data #(parameter max_pi_width = 8,default_level = 0,var_option = 0,var = var_option,cnt_width = (max_pi_width / 4) > 0 ? clog2(max_pi_width / 4) : 1)(
    output reg[3:0] so,
    output idle,
    output done,
    input[max_pi_width-1:0] pi,
    input[cnt_width-1:0] var_cnt_times,
    input load_var,
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
    
    assign idle = state == IDLE;
    assign done = cnt_done;
    assign cnt_en = state == IDLE && start || state == TRANS;
    
    always@(negedge clk or posedge rst)
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
    
    always@(negedge clk or posedge rst)
    begin
        if(rst)
            so <= default_level;
        else if((state == IDLE) && start || state == TRANS)
            so <= pi[(cnt_value+1)*4-1-:4];
        else
            so <= default_level;
    end
    
    cnt_negedge #(
        .dir(1),
        .en(1),
        .var(var),
        .max_value(max_pi_width/4)
        ) CNT0
        (
        .cnt_value(cnt_value),
        .done(cnt_done),
        .empty(cnt_empty),
        .var_value(var_cnt_times),
        .load_value(var_cnt_times-1),
        .load(load_var),
        .cnt_en(cnt_en),
        .clk(clk),
        .rst(rst)
        );
    
endmodule
