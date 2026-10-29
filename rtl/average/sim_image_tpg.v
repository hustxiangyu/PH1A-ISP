`timescale 1ns / 1ps
//********************************************************************** 
// -------------------------------------------------------------------
// Copyright Notice
// ------------------------------------------------------------------- 
// Author: Geeker_FPGA 
// Email:geeker_fpga@163.com 
// Email:geeker_fpga@uisrc.com 
// Date:2021/02/01 
// Description: 
// Test Pattern Generator Timing
//
//1920x1080 60Hz	148.5Mhz
//1680x1050 60Hz	119Mhz
//1280x1024 60Hz	108Mhz
//1280X720 	60Hz	74.25MHZ
//1024x768 	60Hz	65Mhz
//800x600 	60Hz	40Mhz
//640x480 	60Hz	25.175Mhz
// 
// Web:http://www.uisrc.com
//------------------------------------------------------------------- 
//*********************************************************************/
// `define VIDEO_1920_1080
// `define VIDEO_1680_1050
// `define VIDEO_1280_1024
`define VIDEO_1280_720
// `define VIDEO_1024_768
// `define VIDEO_800_600
// `define VIDEO_640_480
module sim_image_tpg(
	input	wire		i_clk,	
	output	reg			o_hsyn,
	output	reg			o_vsyn,
	output	reg			o_en,
	output	reg [7:0]	o_r,
	output	reg [7:0] 	o_g,
	output	reg [7:0] 	o_b	
);

//1920x1080 148.5Mhz
`ifdef  VIDEO_1920_1080
parameter  H_ACTIVE 		= 1920;// 行数据有效时间
parameter  H_FRONT_PORCH 	= 88;  // 行消隐前肩时间
parameter  H_SYNC_TIME 		= 44;  // 行同步信号时间
parameter  H_BACK_PORCH 	= 148; // 行消隐后肩时间 
                                   
parameter  V_ACTIVE 		= 1080;// 列数据有效时间
parameter  V_FRONT_PORCH 	= 4;   // 列消隐前肩时间
parameter  V_SYNC_TIME  	= 5;   // 列同步信号时间
parameter  V_BACK_PORCH 	= 36;  // 列消隐后肩时间
`endif

//1680x1050 119Mhz
`ifdef  VIDEO_1680_1050
parameter  H_ACTIVE 		= 1680;// 行数据有效时间
parameter  H_FRONT_PORCH 	= 48;  // 行消隐前肩时间
parameter  H_SYNC_TIME 		= 32;  // 行同步信号时间
parameter  H_BACK_PORCH 	= 80;  // 行消隐后肩时间
                                   
parameter  V_ACTIVE 		= 1050;// 列数据有效时间
parameter  V_FRONT_PORCH 	= 3;   // 列消隐前肩时间
parameter  V_SYNC_TIME  	= 6;   // 列同步信号时间
parameter  V_BACK_PORCH 	= 21;  // 列消隐后肩时间
`endif

//1280x1024 108Mhz
`ifdef  VIDEO_1280_1024
parameter  H_ACTIVE 		= 1280;// 行数据有效时间
parameter  H_FRONT_PORCH 	= 48;  // 行消隐前肩时间
parameter  H_SYNC_TIME 		= 112; // 行同步信号时间
parameter  H_BACK_PORCH 	= 248; // 行消隐后肩时间 
                                   
parameter  V_ACTIVE 		= 1024;// 列数据有效时间
parameter  V_FRONT_PORCH 	= 1;   // 列消隐前肩时间
parameter  V_SYNC_TIME  	= 3;   // 列同步信号时间
parameter  V_BACK_PORCH 	= 38;  // 列消隐后肩时间
`endif

//1280X720 74.25MHZ
`ifdef  VIDEO_1280_720
parameter  H_ACTIVE 		= 1280;// 行数据有效时间
parameter  H_FRONT_PORCH 	= 110; // 行消隐前肩时间
parameter  H_SYNC_TIME 		= 40;  // 行同步信号时间
parameter  H_BACK_PORCH 	= 220; // 行消隐后肩时间    
                                    
parameter  V_ACTIVE 		= 720; // 列数据有效时间
parameter  V_FRONT_PORCH 	= 5;   // 列消隐前肩时间
parameter  V_SYNC_TIME  	= 5;   // 列同步信号时间
parameter  V_BACK_PORCH 	= 20;  // 列消隐后肩时间
`endif

//1024x768 65Mhz
`ifdef  VIDEO_1024_768
parameter  H_ACTIVE 		= 1024;// 行数据有效时间
parameter  H_FRONT_PORCH 	= 24;  // 行消隐前肩时间
parameter  H_SYNC_TIME 		= 136; // 行同步信号时间
parameter  H_BACK_PORCH 	= 160; // 行消隐后肩时间   
                                    
parameter  V_ACTIVE 		= 768; // 列数据有效时间
parameter  V_FRONT_PORCH 	= 3;   // 列消隐前肩时间
parameter  V_SYNC_TIME  	= 6;   // 列同步信号时间
parameter  V_BACK_PORCH 	= 29;  // 列消隐后肩时间

`endif

//800x600 40Mhz
`ifdef  VIDEO_800_600
parameter  H_ACTIVE 		= 800;// 行数据有效时间
parameter  H_FRONT_PORCH 	= 40 ;// 行消隐前肩时间 
parameter  H_SYNC_TIME 		= 128;// 行同步信号时间
parameter  H_BACK_PORCH 	= 88 ;// 行消隐后肩时间    
                                    
parameter  V_ACTIVE 		= 600;// 列数据有效时间
parameter  V_FRONT_PORCH 	= 1  ;// 列消隐前肩时间  
parameter  V_SYNC_TIME  	= 4  ;// 列同步信号时间  
parameter  V_BACK_PORCH 	= 23 ;// 列消隐后肩时间 

`endif

//640x480 25.175Mhz
`ifdef  VIDEO_640_480
parameter H_ACTIVE 			= 640; // 行数据有效时间
parameter H_FRONT_PORCH 	= 16 ; // 行消隐前肩时间
parameter H_SYNC_TIME 		= 96 ; // 行同步信号时间
parameter H_BACK_PORCH 		= 48 ; // 行消隐后肩时间
								 
parameter V_ACTIVE 			= 480; // 列数据有效时间
parameter V_FRONT_PORCH 	= 10 ; // 列消隐前肩时间
parameter V_SYNC_TIME 		= 2	 ; // 列同步信号时间
parameter V_BACK_PORCH 		= 33 ; // 列消隐后肩时间
`endif

parameter  H_TOTAL_TIME 	= H_ACTIVE + H_FRONT_PORCH + H_SYNC_TIME + H_BACK_PORCH; 
parameter  V_TOTAL_TIME 	= V_ACTIVE + V_FRONT_PORCH + V_SYNC_TIME + V_BACK_PORCH;


reg 		en;
reg [12:0] 	h_syn_cnt = 'd0;
reg [12:0] 	v_syn_cnt = 'd0;
reg [23:0] 	image [0 : H_ACTIVE*V_ACTIVE-1];
reg [31:0] 	image_cnt = 'd0;

//读取txt文件到image数组中
initial begin
	$readmemh("image_720_1280_3.txt", image);
end

// 行扫描计数器
always@(posedge i_clk)
begin
	if(h_syn_cnt == H_TOTAL_TIME-1)
        h_syn_cnt <= 0;
    else
        h_syn_cnt <= h_syn_cnt + 1;
end

// 列扫描计数器
always@(posedge i_clk)
begin
	if(h_syn_cnt == H_TOTAL_TIME-1)
	begin
        if(v_syn_cnt == V_TOTAL_TIME-1)
            v_syn_cnt <= 0;
        else
            v_syn_cnt <= v_syn_cnt + 1;
	end
end

// 行同步控制
always@(posedge i_clk)
begin
    if(h_syn_cnt < H_SYNC_TIME)
        o_hsyn <= 0;
    else
        o_hsyn <= 1;
end

// 场同步控制
always@(posedge i_clk)
begin
    if(v_syn_cnt < V_SYNC_TIME)
        o_vsyn <= 0;
    else
        o_vsyn <= 1;
end

// 坐标使能.
always@(posedge i_clk)
begin
    if(v_syn_cnt >= V_SYNC_TIME + V_BACK_PORCH && v_syn_cnt < V_SYNC_TIME + V_BACK_PORCH + V_ACTIVE)
    begin
        if(h_syn_cnt >= H_SYNC_TIME + H_BACK_PORCH && h_syn_cnt < H_SYNC_TIME + H_BACK_PORCH + H_ACTIVE)
            en <= 1;
        else
            en <= 0;
    end
    else
        en <= 0;
end

always@(posedge i_clk)
begin
    if(en)
	begin
		o_r 		<= image[image_cnt][23:16];
		o_g 		<= image[image_cnt][15:8];
		o_b 		<= image[image_cnt][7:0];
	    image_cnt 	<= image_cnt + 1;
	end
	else if(image_cnt == H_ACTIVE*V_ACTIVE)
	begin
		o_r 		<= 8'h00;
		o_g 		<= 8'h00;
		o_b 		<= 8'h00;
	    image_cnt 	<= 'd0;
	end	
    else
	begin
		o_r 		<= 8'h00;
		o_g 		<= 8'h00;
		o_b 		<= 8'h00;
	    image_cnt 	<= image_cnt;
	end	
end

always@(posedge i_clk)
begin
	o_en <= en;
end


endmodule
