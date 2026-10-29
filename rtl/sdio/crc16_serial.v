`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 晴空-Tiso（B站同名）
// 
// Create Date: 2024/07/08 04:32:56
// Design Name: 
// Module Name: crc16_serial
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
    crc16_serial CRC16(
        .crc_out(),
        .data_in(),
        .en(),
        .clk(),
        .rst()
        );
*/

//crc16校验，串行输入
module crc16_serial(
    output[15:0] crc_out,
    input data_in,
    input en,
    input clk,
    input rst
    );
    
    localparam POLY = 16'h1021;
    
    reg[15:0] crc_now,crc_next;
    
    assign crc_out = crc_now;
    
    always@(posedge rst or posedge clk)
    begin
        if(rst)
            crc_now <= 0;
        else if(en) begin
            crc_now <= crc_next; 
        end
    end
    
    always@(*) begin
        crc_next = crc_now << 1;
        if(crc_now[15] ^ data_in)
            crc_next = crc_next ^ POLY;
    end
    
endmodule