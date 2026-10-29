`timescale 1ns / 1ps
//********************************************************************** 
// -------------------------------------------------------------------
// Copyright Notice
// ------------------------------------------------------------------- 
// Author: Geeker_FPGA 
// Email:geeker_fpga@163.com 
// Email:geeker_fpga@uisrc.com v
// Date:2021/02/08 
// Description: 
// rgb2gray_algorithm
//
// 
// Web:http://www.uisrc.com
//------------------------------------------------------------------- 
//*********************************************************************/
module rgb2gray_algorithm
(
	input   wire				i_clk,	
	input   wire				i_rst_n,	
	input   wire				i_hsyn,		
	input   wire				i_vsyn,		
	input	wire [7:0]			i_r,
	input	wire [7:0] 			i_g,
	input	wire [7:0] 			i_b,	
	input   wire				i_de,		
	output	reg 				o_gray_hsyn,	
	output  reg 				o_gray_vsyn,	
	output  reg  [23:0]			o_gray_data,	
	output  reg 				o_gray_de
);


// gray1 =  0.299 * image_in_r + 0.587 * image_in_g + 0.114 * image_in_b;

// gray1 =  256*(0.299 * image_in_r + 0.587 * image_in_g + 0.114 * image_in_b)>>8;

// gray1 =  (77 * image_in_r + 150 * image_in_g + 29 * image_in_b)>>8;


reg [15:0] r_d0;
reg [15:0] g_d0;
reg [15:0] b_d0;

reg [15:0] gray_d0;

reg [1:0] hsyn;
reg [1:0] vsyn;
reg [1:0] de;

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        r_d0 <= 16'd0;
        g_d0 <= 16'd0;
        b_d0 <= 16'd0;
    end
    else 
	begin
        r_d0 <= 77  * i_r;
        g_d0 <= 150 * i_g;
        b_d0 <= 29  * i_b;        	
    end
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		gray_d0 <= 16'd0;
    end
    else 
	begin
		gray_d0 <= r_d0 + g_d0 + b_d0;  	
    end
end

always@(posedge i_clk ) 
begin
	hsyn	<= {hsyn[0],i_hsyn};
	vsyn	<= {vsyn[0],i_vsyn};
	de		<= {de[0],i_de};
end

always@(posedge i_clk)begin
	o_gray_hsyn <= hsyn[1];
	o_gray_vsyn <= vsyn[1];
	o_gray_data <= {gray_d0[15:8],gray_d0[15:8],gray_d0[15:8]};
	o_gray_de   <= de[1];
end


//红色分量灰度图
// assign o_gray_data = {i_r,i_r,i_r};
// assign o_gray_hsyn	= i_hsyn;
// assign o_gray_vsyn	= i_vsyn;
// assign o_gray_de	= i_de;
//绿色分量灰度图
// assign o_gray_data = {i_g,i_g,i_g};
// assign o_gray_hsyn	= i_hsyn;
// assign o_gray_vsyn	= i_vsyn;
// assign o_gray_de	= i_de;
//蓝色分量灰度图
// assign o_gray_data = {i_b,i_b,i_b};
// assign o_gray_hsyn	= i_hsyn;
// assign o_gray_vsyn	= i_vsyn;
// assign o_gray_de	= i_de;

endmodule