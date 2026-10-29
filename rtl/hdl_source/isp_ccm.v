/*************************************************************************
    > File Name: isp_ccm.v
    > Author: bxq
    > Mail: 544177215@qq.com
    > Created Time: Thu 21 Jan 2021 21:50:04 GMT
 ************************************************************************/
`timescale 1 ns / 1 ps

/*
 * ISP - Color Correction Matrix
 */

module isp_ccm
#(
	parameter BITS = 8,
	parameter WIDTH = 1920,
	parameter HEIGHT = 1080
)
(
	input pclk,
	input rst_n,
    input switch,
    input signed [11:0] ccm_rr, ccm_rg,ccm_rb, //format S4.4
	input signed [11:0] ccm_gr, ccm_gg,ccm_gb,
	input signed [11:0] ccm_br, ccm_bg,ccm_bb,

	input in_href,
    input in_hsync,
	input in_vsync,
	input [BITS-1:0] in_r,
	input [BITS-1:0] in_g,
	input [BITS-1:0] in_b,

	output 	reg					out_href,
    output 	reg					out_hsync,
	output 	reg					out_vsync,
	output 	reg		[BITS-1:0] 	out_r,
	output 	reg		[BITS-1:0] 	out_g,
	output 	reg		[BITS-1:0] 	out_b
);

	// [Rout]   [Mrr, Mrg, Mrb]   [Rin]
	// [Gout] = [Mgr, Mgg, Mgb] * [Gin]
	// [Bout]   [Mbr, Mbg, Mbb]   [Bin]

	reg signed [BITS:0] in_r_1, in_g_1, in_b_1;
	always @ (posedge pclk or negedge rst_n) begin
		if (!rst_n) begin
			in_r_1 <= 0;
			in_g_1 <= 0;
			in_b_1 <= 0;
		end
		else begin
			in_r_1 <= {1'b0, in_r};
			in_g_1 <= {1'b0, in_g};
			in_b_1 <= {1'b0, in_b};
		end
	end

	reg signed [BITS+12:0] data_rr, data_rg, data_rb;
	reg signed [BITS+12:0] data_gr, data_gg, data_gb;
	reg signed [BITS+12:0] data_br, data_bg, data_bb;
	always @ (posedge pclk or negedge rst_n) begin
		if (!rst_n) begin
			data_rr <= 0;
			data_rg <= 0;
			data_rb <= 0;
			data_gr <= 0;
			data_gg <= 0;
			data_gb <= 0;
			data_br <= 0;
			data_bg <= 0;
			data_bb <= 0;
		end
		else begin
			data_rr <= ccm_rr * in_r_1;
			data_rg <= ccm_rg * in_g_1;
			data_rb <= ccm_rb * in_b_1;
			data_gr <= ccm_gr * in_r_1;
			data_gg <= ccm_gg * in_g_1;
			data_gb <= ccm_gb * in_b_1;
			data_br <= ccm_br * in_r_1;
			data_bg <= ccm_bg * in_g_1;
			data_bb <= ccm_bb * in_b_1;
		end
	end

	reg signed [BITS+12:0] data_r, data_g, data_b;
	always @ (posedge pclk or negedge rst_n) begin
		if (!rst_n) begin
			data_r <= 0;
			data_g <= 0;
			data_b <= 0;
		end
		else begin
			data_r <= (data_rr + data_rg + data_rb) >> 10;
			data_g <= (data_gr + data_gg + data_gb) >> 10;
			data_b <= (data_br + data_bg + data_bb) >> 10;
		end
	end

		reg [BITS-1:0] data_r_1, data_g_1, data_b_1;
	always @ (posedge pclk or negedge rst_n) begin
		if (!rst_n) begin
			data_r_1 <= 0;
			data_g_1 <= 0;
			data_b_1 <= 0;
		end
		else begin
			data_r_1 <= data_r < 8'sd0 ? {BITS{1'b0}} : (data_r > {8{1'b1}} ? {8{1'b1}} : data_r[BITS-1:0]);
			data_g_1 <= data_g < 8'sd0 ? {BITS{1'b0}} : (data_g > {8{1'b1}} ? {8{1'b1}} : data_g[BITS-1:0]);
			data_b_1 <= data_b < 8'sd0 ? {BITS{1'b0}} : (data_b > {8{1'b1}} ? {8{1'b1}} : data_b[BITS-1:0]);
		end
	end


	localparam DLY_CLK = 4;
	reg [DLY_CLK-1:0] href_dly;
    reg [DLY_CLK-1:0] hsync_dly;
	reg [DLY_CLK-1:0] vsync_dly;
	always @ (posedge pclk or negedge rst_n) begin
		if (!rst_n) begin
			href_dly <= 0;
            hsync_dly <= 0;
			vsync_dly <= 0;
		end
		else begin
			href_dly <= {href_dly[DLY_CLK-2:0], in_href};
            hsync_dly <= {hsync_dly[DLY_CLK-2:0], in_hsync};
			vsync_dly <= {vsync_dly[DLY_CLK-2:0], in_vsync};
		end
	end


    reg					o_out_href 	;
    reg					o_out_hsync ;
    reg					o_out_vsync ;
    reg		[BITS-1:0] 	o_out_r     ;
    reg		[BITS-1:0] 	o_out_g     ;
    reg		[BITS-1:0] 	o_out_b     ;
    
    	always @ (posedge pclk or negedge rst_n) begin
    	if (!rst_n) begin
        	o_out_href 		<= 	0;
            o_out_hsync 	<= 	0;
            o_out_vsync		<= 	0;
            o_out_r 		<= 	0;
            o_out_g 		<= 	0;
            o_out_b 		<= 	0;
        end
        else begin
    		o_out_href 		<= 	href_dly[DLY_CLK-1];
    		o_out_hsync 	<= 	hsync_dly[DLY_CLK-1];
			o_out_vsync		<= 	vsync_dly[DLY_CLK-1];
			o_out_r 		<= 	out_href ? data_r_1 : {BITS{1'b0}};
			o_out_g 		<= 	out_href ? data_g_1 : {BITS{1'b0}};
			o_out_b 		<= 	out_href ? data_b_1 : {BITS{1'b0}};
    	end
    end
    
    
    always @ (posedge pclk or negedge rst_n) begin
    	if (!rst_n) begin
        	out_href 	<= 	0;
            out_hsync 	<= 	0;
            out_vsync	<= 	0;
            out_r 		<= 	0;
            out_g 		<= 	0;
            out_b 		<= 	0;
        end
        else if(switch)begin
    		out_href 	<= 	o_out_href 	;
    		out_hsync 	<=  o_out_hsync ;
			out_vsync	<=  o_out_vsync	;
			out_r 		<=  o_out_r 	;
			out_g 		<=  o_out_g 	;
			out_b 		<=  o_out_b 	;
    	end else begin
    		out_href 	<= 	in_href 	;
    		out_hsync 	<=  in_hsync ;
			out_vsync	<=  in_vsync	;
			out_r 		<=  in_r 	;
			out_g 		<=  in_g 	;
			out_b 		<=  in_b 	;			
		end
    end
 
    	
endmodule
