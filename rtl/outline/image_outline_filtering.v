`timescale 1ns / 1ps
//********************************************************************** 
// -------------------------------------------------------------------
// Copyright Notice
// ------------------------------------------------------------------- 
// Author: Geeker_FPGA 
// Email:geeker_fpga@163.com 
// Email:geeker_fpga@uisrc.com v
// Date:2021/03/06
// Description: 
// image_outline_filtering
//
// 
// Web:http://www.uisrc.com
//------------------------------------------------------------------- 
//*********************************************************************/
module image_outline_filtering
(
	input   wire				i_clk,
	input   wire				i_rst_n,

	input	wire				i_hsyn,
	input	wire				i_vsyn,
	input	wire				i_en,
	input	wire [7:0]			i_binary,
	
	output	reg 				o_hs,
	output	reg 				o_vs,
	output	reg 				o_en,	
	output  reg [7:0]			o_binary
);

reg	[2:0]	i_hsyn_d;
reg	[2:0]	i_vsyn_d;
reg	[2:0]	i_en_d;

reg         outline_en;
reg  [7:0]	binary_reg;

wire [7:0]	r_temp_11;
wire [7:0]	r_temp_12;
wire [7:0]	r_temp_13;
wire [7:0]	r_temp_21;
wire [7:0]	r_temp_22;
wire [7:0]	r_temp_23;
wire [7:0]	r_temp_31;
wire [7:0]	r_temp_32;
wire [7:0]	r_temp_33;

always@(posedge i_clk)begin
	o_hs 		<= i_hsyn_d[2];
	o_vs 		<= i_vsyn_d[2];
	o_en 		<= i_en_d[2];
	o_binary	<= binary_reg;
end
always@(posedge i_clk ) 
begin
	i_hsyn_d <=	{i_hsyn_d[1:0],i_hsyn};
	i_vsyn_d <=	{i_vsyn_d[1:0],i_vsyn};
	i_en_d	 <=	{i_en_d[1:0],i_en};
end

image_template u_r_template
(
	.i_clk			(i_clk				),
	.i_rst_n		(i_rst_n			),
	.i_en			(i_en				),
	.i_data			(i_binary			),
	.o_en			(					),
	.o_temp_11		(r_temp_11			),
	.o_temp_12		(r_temp_12			),
	.o_temp_13		(r_temp_13			),	
	.o_temp_21		(r_temp_21			),
	.o_temp_22		(r_temp_22			),
	.o_temp_23		(r_temp_23			),		
	.o_temp_31		(r_temp_31			),
	.o_temp_32		(r_temp_32			),
	.o_temp_33		(r_temp_33			)
);


always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n) 
	begin
        outline_en <= 'd0;
    end
    else 
	begin
		if(((r_temp_11[0] &&
		     r_temp_12[0] &&
		     r_temp_13[0] &&
		     r_temp_21[0] &&
		     r_temp_22[0] &&
		     r_temp_23[0] &&
		     r_temp_31[0] &&
		     r_temp_32[0] &&
		     r_temp_33[0]) == 1)
			 ||((
			 r_temp_11[0] ||
		     r_temp_12[0] ||
		     r_temp_13[0] ||
		     r_temp_21[0] ||
		     r_temp_22[0] ||
		     r_temp_23[0] ||
		     r_temp_31[0] ||
		     r_temp_32[0] ||
		     r_temp_33[0]) == 0)
			 )	   
			outline_en <= 1; 	
		else
			outline_en <= 0; 	
    end
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n) 
	begin
        binary_reg <= 'd0;
    end
    else if(outline_en)
	begin
		binary_reg <= 'd0;
    end
    else 
	begin
		binary_reg <= 'd255;
    end	
end


endmodule