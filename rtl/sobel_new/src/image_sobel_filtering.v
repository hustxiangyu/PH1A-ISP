`timescale 1ns / 1ps
//********************************************************************** 
// -------------------------------------------------------------------
// Copyright Notice
// ------------------------------------------------------------------- 
// Author: Geeker_FPGA 
// Email:geeker_fpga@163.com 
// Email:geeker_fpga@uisrc.com v
// Date:2021/02/25
// Description: 
// image_sobel_filtering
//
// 
// Web:http://www.uisrc.com
//------------------------------------------------------------------- 
//*********************************************************************/
module image_sobel_filtering
(
	input   wire				i_clk,
	input   wire				i_rst_n,

	input	wire				i_hsyn,
	input	wire				i_vsyn,
	input	wire				i_en,
	input	wire [7:0]			i_r,
	input	wire [7:0] 			i_g,
	input	wire [7:0] 			i_b,
	input	wire [7:0] 			threshold,	
	
	output	reg 				o_hs,
	output	reg 				o_vs,
	output	reg 				o_en,	
	output  reg [7:0]			o_r,
	output  reg [7:0]			o_g,
	output  reg [7:0]			o_b	
);

reg	[2:0]		i_hsyn_d;
reg	[2:0]		i_vsyn_d;
reg	[2:0]		i_en_d;

reg [11:0]		r_x1;
reg [11:0]		r_x2;
reg [11:0]		r_y1;
reg [11:0]		r_y2;

reg [11:0]		sobel_x;
reg [11:0]		sobel_y;

wire [7:0]	r_temp_11;
wire [7:0]	r_temp_12;
wire [7:0]	r_temp_13;
wire [7:0]	r_temp_21;
wire [7:0]	r_temp_22;
wire [7:0]	r_temp_23;
wire [7:0]	r_temp_31;
wire [7:0]	r_temp_32;
wire [7:0]	r_temp_33;
always@(*)begin
	o_hs 	<= i_hsyn_d[2];
	o_vs 	<= i_vsyn_d[2];
	o_en 	<= i_en_d[2];
	o_r 	<= (sobel_x + sobel_y) > threshold ? 255 : 0;
	o_g	 	<= (sobel_x + sobel_y) > threshold ? 255 : 0;
	o_b 	<= (sobel_x + sobel_y) > threshold ? 255 : 0;
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
	.i_data			(i_r				),
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
        r_x1 <= 12'd0;
        r_x2 <= 12'd0;
    end
    else 
	begin
        r_x1 <= r_temp_11 + r_temp_21 + r_temp_21 + r_temp_31;
        r_x2 <= r_temp_13 + r_temp_23 + r_temp_23 + r_temp_33;
    end
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n) 
	begin
        r_y1 <= 12'd0;
		r_y2 <= 12'd0;
    end
    else 
	begin
        r_y1 <= r_temp_11 + r_temp_12 + r_temp_12 + r_temp_13;
		r_y2 <= r_temp_31 + r_temp_32 + r_temp_32 + r_temp_33;
    end
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n) 
	begin
        sobel_x <= 'd0;
    end
    else if(r_x1 >= r_x2)
	begin
        sobel_x <= r_x1 - r_x2;
    end
	else
	begin
        sobel_x <= r_x2 - r_x1;
    end	
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n) 
	begin
        sobel_y <= 'd0;
    end
    else if(r_y1 >= r_y2)
	begin
        sobel_y <= r_y1 - r_y2;
    end
	else
	begin
        sobel_y <= r_y2 - r_y1;
    end	
end

endmodule