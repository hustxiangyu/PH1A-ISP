`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Çç¿Õ-Tiso£¨BÕ¾Í¬Ãû£©
// 
// Create Date: 2024/07/08 20:34:54
// Design Name: 
// Module Name: sipo_4bit
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
    sipo_4bit #(.max_pi_width()) SIPO(
        .po(),
        .idle(),
        .done(),
        .var_cnt_times(),
        .load_var(),
        .si(),
        .start(),
        .next(),
        .clk(),
        .rst()
        );
*/

module sipo_4bit #(parameter max_pi_width = 8,var_option = 0,var = var_option,cnt_width = (max_pi_width / 4) > 0 ? clog2(max_pi_width / 4) : 1)(
    output reg[max_pi_width-1:0] po,
    output idle,
    output reg done,
    input[cnt_width-1:0] var_cnt_times,
    input load_var,
    input[3:0] si,
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
    
    integer i;
    
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
        begin
            for(i = 0;i < max_pi_width/4;i = i + 1) 
            begin
                if(i == cnt_value)
                    po_buf[(i+1)*4-1-:4] <= si;
            end
        end
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
            po <= {po_buf[max_pi_width-1:4],si};
            done <= 1;
        end
        else
            done <= 0;
    end
    
    cnt #(
        .dir(1),
        .en(1),
        .var(var),
        .max_value(max_pi_width/4)
        ) CNT0
        (
        .cnt_value(cnt_value),
        .done(cnt_done),
        .var_value(var_cnt_times),
        .load_value(var_cnt_times-1),
        .load(load_var),
        .cnt_en(cnt_en),
        .clk(clk),
        .rst(rst)
        );
    
endmodule
