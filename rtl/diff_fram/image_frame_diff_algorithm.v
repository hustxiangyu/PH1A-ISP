`timescale 1ns / 1ps
//********************************************************************** 
// -------------------------------------------------------------------
// Copyright Notice
// ------------------------------------------------------------------- 
// Author: Geeker_FPGA 
// Email:geeker_fpga@163.com 
// Email:geeker_fpga@uisrc.com v
// Date:2021/04/05
// Description: 
// image_frame_diff_algorithm
//
// 
// Web:http://www.uisrc.com
//------------------------------------------------------------------- 
//*********************************************************************/
module image_frame_diff_algorithm
(
	input   wire				i_clk,
	input   wire				i_rst_n,

	input	wire				i_hsyn,
	input	wire				i_vsyn,
	input	wire				i_de,
	input	wire [23:0]			i_data_0,	
	input	wire [23:0]			i_data_1,		
	
	output	reg					o_hs,
	output	reg					o_vs,
	output	reg					o_de,	
	output  reg	 [7:0]			o_data
);
parameter THRESHOLD = 75;// 20~100

reg			i_hsyn_d0;
reg			i_vsyn_d0;
reg			i_de_d0;
reg [7:0] 	data_d0;

reg 		frame_diff_begin;
reg [2:0]   frame_cnt;

always@(posedge i_clk) 
begin
	i_hsyn_d0 <= i_hsyn;
	i_vsyn_d0 <= i_vsyn;
	i_de_d0   <= i_de;
	data_d0   <= i_data_0[7:0];
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		frame_cnt <= 0;
    end
    else if(~i_vsyn & i_vsyn_d0)
	begin
		if(frame_cnt == 5)
			frame_cnt <= 5;
		else
			frame_cnt <= frame_cnt + 1;
    end
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		frame_diff_begin <= 0;
    end
    else if(frame_cnt == 5)
	begin
		frame_diff_begin <= 1;      	
    end
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		o_data <= 8'h00;
    end
    else if(frame_diff_begin == 1 && i_de_d0 == 1)
	begin
      	if(i_data_0[7:0] <= i_data_1[7:0])
		begin
			if(i_data_1[7:0] - i_data_0[7:0] >= THRESHOLD)
				o_data <= 8'hff;
			else
				o_data <= 8'h00;
		end
		else
		begin
			if(i_data_0[7:0] - i_data_1[7:0] >= THRESHOLD)
				o_data <= 8'hff;
			else
				o_data <= 8'h00;		
		end
    end
end

always@(posedge i_clk ) 
begin
	o_hs  <= i_hsyn_d0;
	o_vs  <= i_vsyn_d0;
	o_de  <= i_de_d0  ;
end

endmodule