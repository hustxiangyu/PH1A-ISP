`timescale 1ns / 1ps
//********************************************************************** 
// -------------------------------------------------------------------
// Copyright Notice 
// ------------------------------------------------------------------- 
// Author: Geeker_FPGA 
// Email:geeker_fpga@163.com 
// Email:geeker_fpga@uisrc.com 
// Date:2021/02/22 
// Description: 
// 
//
// 
// Web:http://www.uisrc.com
//------------------------------------------------------------------- 
//*********************************************************************/
module average(
	input   wire                i_clk, 	
	input   wire                i_rst_n, 	 		
	output	wire				o_gray_hsyn,	
	output  wire				o_gray_vsyn,	
	output  wire	[23:0]		o_gray_data,	
	output  wire				o_gray_de
);

wire				i_hsyn;	
wire				i_vsyn;	
wire [7:0]			i_r;
wire [7:0] 			i_g;
wire [7:0] 			i_b;	
wire				i_de;	

wire				i_gray_hsyn;	
wire				i_gray_vsyn;	
wire	[23:0]		i_gray_data;	
wire				i_gray_de;

sim_image_tpg u_tpg(
	.i_clk			(i_clk				),	
	.o_hsyn			(i_hsyn				),
	.o_vsyn			(i_vsyn				),
	.o_en			(i_de				),
	.o_r			(i_r				),
	.o_g			(i_g				),
	.o_b			(i_b				)	
);

image_average_filtering u_image_average_filtering
(
	.i_clk			(i_clk				),
	.i_rst_n		(i_rst_n			),
	.i_hsyn		    (i_hsyn				),
	.i_vsyn		    (i_vsyn				),
	.i_en		    (i_de				),
	.i_r		    (i_r				),
	.i_g		    (i_g				),
	.i_b		    (i_b				),		
	.o_hs		    (o_gray_hsyn		),
	.o_vs		    (o_gray_vsyn		),
	.o_en		    (o_gray_de			),	
	.o_r		    (o_gray_data[23:16]	),
	.o_g		    (o_gray_data[15:8]	),
	.o_b		    (o_gray_data[7:0]	)	
);

endmodule