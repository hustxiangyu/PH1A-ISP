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
// image_box_select
//
// 
// Web:http://www.uisrc.com
//------------------------------------------------------------------- 
//*********************************************************************/
module image_box_select
(
	input   wire				i_clk,
	input   wire				i_rst_n,

	input	wire				i_hsyn,
	input	wire				i_vsyn,
	input	wire				i_de,
	input	wire [7:0]			i_data,
	
	input	wire				i_hsyn_original,
	input	wire				i_vsyn_original,
	input	wire				i_de_original,	
	input	wire [7:0]			i_r_original,
	input	wire [7:0]			i_g_original,
	input	wire [7:0]			i_b_original,
	
	output	reg					o_hsyn,
	output	reg					o_vsyn,
	output	reg					o_de,
	output  reg  [7:0]			o_r,
	output  reg  [7:0]			o_g,
	output  reg  [7:0]			o_b	
);
parameter  H_ACTIVE 		= 1920; //显示区域宽度                              
parameter  V_ACTIVE 		= 1080;  //显示区域高度
parameter  R_VALUE			= 8'hFF;//显示选框颜色
parameter  G_VALUE			= 8'h00;//显示选框颜色
parameter  B_VALUE			= 8'h00;//显示选框颜色

reg  [10:0] 	    h_cnt;
reg  [10:0] 	    v_cnt;
reg 				i_vsyn_d;

reg  [10:0] 	    h_min;
reg  [10:0] 	    h_max;
reg  [10:0] 	    v_min;
reg  [10:0] 	    v_max;

reg  [10:0] 	    h_min_d;
reg  [10:0] 	    h_max_d;
reg  [10:0] 	    v_min_d;
reg  [10:0] 	    v_max_d;

reg  [10:0] 	    ori_h_cnt;
reg  [10:0] 	    ori_v_cnt;


always@(posedge i_clk ) 
begin
	i_vsyn_d <= i_vsyn;
end

//显示区域行计数
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        h_cnt <= 11'd0;
    end
    else if(i_de)
	begin
		if(h_cnt == H_ACTIVE - 1'b1)
			h_cnt <= 11'd0;
		else 
			h_cnt <= h_cnt + 11'd1;
    end
end

//显示区域场计数
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        v_cnt <= 11'd0;
    end
    else if(h_cnt == H_ACTIVE - 1'b1)
	begin
		if(v_cnt == V_ACTIVE - 1'b1)
			v_cnt <= 11'd0;
		else 
			v_cnt <= v_cnt + 11'd1;
    end
end

//查找H最小值
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		h_min  <= H_ACTIVE;
    end
    else if(~i_vsyn_d & i_vsyn)
	begin
    	h_min  <= H_ACTIVE;
    end	
    else if(i_data == 8'hff && h_min > h_cnt) 
	begin
    	h_min  <= h_cnt;
    end
end

//查找H最大值
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		h_max  <= 8'h00;
    end
    else if(~i_vsyn_d & i_vsyn)
	begin
    	h_max  <= 8'h00;
    end	
    else if(i_data == 8'hff && h_max < h_cnt) 
	begin
    	h_max  <= h_cnt;
    end
end

//查找V最小值
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		v_min  <= V_ACTIVE;
    end
    else if(~i_vsyn_d & i_vsyn)
	begin
    	v_min  <= V_ACTIVE;
    end	
    else if(i_data == 8'hff && v_min > v_cnt) 
	begin
    	v_min  <= v_cnt;
    end
end

//查找V最大值
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		v_max  <= 8'h00;
    end
    else if(~i_vsyn_d & i_vsyn)
	begin
    	v_max  <= 8'h00;
    end	
    else if(i_data == 8'hff && v_max < v_cnt) 
	begin
    	v_max  <= v_cnt;
    end
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		h_min_d <= 'd0;
		h_max_d <= 'd0;
		v_min_d <= 'd0;
		v_max_d <= 'd0;
    end
    else if(~i_vsyn & i_vsyn_d)
	begin
		h_min_d <= h_min;
		h_max_d <= h_max;
		v_min_d <= v_min;
		v_max_d <= v_max;   	
    end
end

//显示区域行计数
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        ori_h_cnt <= 11'd0;
    end
    else if(i_de_original)
	begin
		if(ori_h_cnt == H_ACTIVE - 1'b1)
			ori_h_cnt <= 11'd0;
		else 
			ori_h_cnt <= ori_h_cnt + 11'd1;
    end
end

//显示区域场计数
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        ori_v_cnt <= 11'd0;
    end
    else if(ori_h_cnt == H_ACTIVE - 1'b1)
	begin
		if(ori_v_cnt == V_ACTIVE - 1'b1)
			ori_v_cnt <= 11'd0;
		else 
			ori_v_cnt <= ori_v_cnt + 11'd1;
    end
end

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
		o_r <= 'd0;
		o_g <= 'd0;
		o_b <= 'd0;
    end
    else if((((ori_h_cnt >= h_min_d && ori_h_cnt <= h_min_d + 3) || (ori_h_cnt >= h_max_d && ori_h_cnt <= h_max_d + 3) ) && ori_v_cnt >= v_min_d && ori_v_cnt <= v_max_d)||
			((ori_v_cnt == v_min_d || ori_v_cnt == v_max_d ) && ori_h_cnt >= h_min_d && ori_h_cnt <= h_max_d))			
	begin
		o_r <= R_VALUE;
		o_g <= G_VALUE;
		o_b <= B_VALUE;	
    end
    else 
	begin
		o_r <= i_r_original;
		o_g <= i_g_original;
		o_b <= i_b_original;	
    end	
end

always@(posedge i_clk ) 
begin
	o_hsyn	<= i_hsyn_original;
	o_vsyn	<= i_vsyn_original;
	o_de	<= i_de_original;
end


endmodule