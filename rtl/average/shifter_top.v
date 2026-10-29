`timescale 1ns / 1ps
//********************************************************************** 
// -------------------------------------------------------------------
// Copyright Notice
// ------------------------------------------------------------------- 
// Author: Geeker_FPGA 
// Email:geeker_fpga@163.com 
// Email:geeker_fpga@uisrc.com 
// Date:2021/02/21 
// Description: 
// shift_top
//
// 
// Web:http://www.uisrc.com
//------------------------------------------------------------------- 
//*********************************************************************/
module shift_top#(
	parameter DATA_WIDTH = 8,
	parameter DATA_DEPTH = TAPS_NUM * DIST_TAPS,
	parameter TAPS_NUM	 = 2,
	parameter DIST_TAPS  = 10	
)
(
	i_clk,
	i_en, 
	i_datain, 
	i_rst,
	o_dataout,
	o_taps_0,
	o_taps_1,
	o_taps_2,
	o_taps_3	
);
input                                i_clk;
input                                i_en;
input        [DATA_WIDTH-1:0]        i_datain;
input                     			 i_rst;
output       [DATA_WIDTH-1:0]        o_dataout;
output       [DATA_WIDTH-1:0]        o_taps_0;
output       [DATA_WIDTH-1:0]        o_taps_1;
output       [DATA_WIDTH-1:0]        o_taps_2;
output       [DATA_WIDTH-1:0]        o_taps_3;


reg [DATA_WIDTH-1:0]  datain_reg[0:DATA_DEPTH-1];

always@(posedge i_clk or posedge i_rst)
begin
	if(i_rst)
		datain_reg[0] <= 'd0;	
	else if(i_en)
		datain_reg[0] <= i_datain;    
	else
		datain_reg[0] <= 'd0;        
end

genvar i;
generate
	for(i=1;i<DATA_DEPTH;i=i+1)
	begin:SHFTER_MODULE
		always@(posedge i_clk or posedge i_rst)
		begin
			if(i_rst)
				datain_reg[i] <= 'd0;	
			else if(i_en)
				datain_reg[i] <= datain_reg[i-1];
			else
				datain_reg[i] <= 'd0;
		end
	end

endgenerate

assign o_dataout= datain_reg[DATA_DEPTH - 1];

assign o_taps_0	= (TAPS_NUM >= 1)? datain_reg[DIST_TAPS - 1]: o_dataout;
assign o_taps_1	= (TAPS_NUM >= 2)? datain_reg[2*DIST_TAPS - 1]: o_dataout;
assign o_taps_2	= (TAPS_NUM >= 3)? datain_reg[3*DIST_TAPS - 1]: o_dataout;
assign o_taps_3	= (TAPS_NUM >= 4)? datain_reg[4*DIST_TAPS - 1]: o_dataout;

endmodule