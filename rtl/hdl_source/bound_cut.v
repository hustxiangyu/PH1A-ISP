
/*********bound_cut R 边界切除，变为黑色，在RAW转RGB过程中，边界的颜色难以计算，所以切除，显示黑色***********
--版本号1.0
*********************************************************************/

`timescale 1ns / 1ps

module bound_cut #(
parameter 	DATA_WIDTH 	= 24,
			CNT_BITS 	= 12, 
			SKIP_ROWS 	= 2, 
			SKIP_COLS 	= 2,
			H_SIZE   	= 1920, 
			V_SIZE  	= 1080
)(
input 	wire			I_clk,
//	Data Input
input 	wire			I_awb_vs,
input 	wire			I_awb_hs,
input 				    I_awb_de,
input 	wire [DATA_WIDTH-1:0] 	I_awb_data,
	
//	Data Output
output reg				O_awb_vs,
output reg				O_awb_hs,
output reg				O_awb_de,
output reg	[DATA_WIDTH-1:0] 	O_awb_data
);
	
	
reg 	[CNT_BITS-1:0] 	rc_w = 0, rc_h = 0; 
reg 	[1:0] 		r_vs = 0, r_hs = 0, r_de = 0; 
	
wire  w_skip = (rc_w < SKIP_COLS) || (rc_w >= H_SIZE - SKIP_COLS) || (rc_h < SKIP_ROWS) || (rc_h >= V_SIZE - SKIP_ROWS); 
	
always @(posedge I_clk) begin
	r_vs <= {r_vs, I_awb_vs}; 
	r_hs <= {r_hs, I_awb_hs}; 
	r_de <= {r_de, I_awb_de}; 
	//	On HS_R clear all counters. On DE_F increment h counter. On DE increment w counter. 
	//	It's required that DE be stable throughout a line. 
	rc_h <= (r_de == 2'b10) ? rc_h + 1 :
		    (r_vs == 2'b01) ? 0 : rc_h; 
	//	Count on DE. 
	rc_w      <= I_awb_de ? rc_w + 1 : 0; 
	O_awb_vs  <= I_awb_vs; 
	O_awb_hs  <= I_awb_hs; 
	O_awb_de  <= I_awb_de; 
	//	Set boundary to 0. 
	O_awb_data <= w_skip ? {DATA_WIDTH{1'b0}} : I_awb_data; 
	end
	
	
endmodule
