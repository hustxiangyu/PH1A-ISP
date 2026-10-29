`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 晴空-Tiso（B站同名）
// 
// Create Date: 2024/07/02 06:20:38
// Design Name: 
// Module Name: crc7_serial
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
    crc7_serial CRC7(
        .crc_out(),
        .data_in(),
        .en(),
        .clk(),
        .rst()
        );
*/

//crc7校验，串行输入
module crc7_serial(
    output[6:0] crc_out,
    input data_in,
    input en,
    input clk,
    input rst
    );
    
    localparam POLY = 7'b000_1001;
    
    reg[6:0] crc_now,crc_next;
    
    assign crc_out = crc_now;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            crc_now <= 0;
        else if(en) begin
            crc_now <= crc_next; 
        end
    end
    
    always@(*) begin
        crc_next = crc_now << 1;
        if(crc_now[6] ^ data_in)
            crc_next = crc_next ^ POLY;
    end
    
endmodule
