`timescale 1 ns / 1 ps

/*
 * VIP - YUV convert RGB
 * BUG not support 10bit
 */

module isp_yuv2rgb
#(
	parameter BITS = 8,
	parameter WIDTH = 1920,
	parameter HEIGHT = 1080
)
(
	input 	wire				pclk,
	input 	wire				rst_n,

	input 	wire				switch,

	input  	wire				in_href,
	input 	wire				in_vsync,
	input 	wire	[BITS-1:0] 	in_y,
	input 	wire	[BITS-1:0] 	in_u,
	input  	wire	[BITS-1:0] 	in_v,

	output 	reg					out_href,
	output 	reg					out_vsync,
	output 	reg		[BITS-1:0] 	out_r,
	output 	reg		[BITS-1:0] 	out_g,
	output 	reg		[BITS-1:0] 	out_b,
    output 	reg					 yuv2rgb_data_valid
);

	reg	signed [BITS-1:0]	in_y_reg;
	reg	signed [BITS-1:0]	in_u_reg; 
	reg	signed [BITS-1:0]	in_v_reg;
	always @ (posedge pclk or negedge rst_n) begin
		if(!rst_n) begin
			in_y_reg <= 0;
			in_u_reg <= 0;
			in_v_reg <= 0;
		end
		else begin
			in_y_reg <= in_y;
			in_u_reg <= in_u;
			in_v_reg <=	in_v;
		end
	end

	//--------------------------------------------
	/*********************************************
		R = 1.164(Y-16) + 1.596(Cr-128)
		G = 1.164(Y-16) - 0.391(Cb-128) - 0.813(Cr-128)
		B = 1.164(Y-16) + 2.018(Cb-128)
		->
		R = 1.164Y + 1.596Cr - 222.912
		G = 1.164Y - 0.391Cb - 0.813Cr + 135.488
		B = 1.164Y + 2.018Cb - 276.928
		->
		R << 9 = 596Y				+ 	817Cr	-	114131
		G << 9 = 596Y	-	200Cb	-	416Cr	+	69370
		B << 9 = 596Y	+	1033Cb				-	141787
	**********************************************/
	reg	signed [BITS-1+12:0]	img_Y_r1; 				//8 + 9 + 1 = 18Bit
	reg	signed [BITS-1+12:0]	img_Cb_r1, img_Cb_r2; 
	reg	signed [BITS-1+12:0]	img_Cr_r1, img_Cr_r2;
	always @ (posedge pclk or negedge rst_n) begin
		if(!rst_n) begin
			img_Y_r1 <= 0;
			img_Cb_r1 <= 0;	img_Cb_r2 <= 0;	
			img_Cr_r1 <= 0; img_Cr_r2 <= 0;
		end
		else begin
			img_Y_r1	<= 	in_y_reg * 12'd596;
			img_Cb_r1 	<= 	in_u_reg * 12'd200;	
			img_Cb_r2	<=	in_u_reg * 12'd1033;	
			img_Cr_r1 	<= 	in_v_reg * 12'd817;	
			img_Cr_r2	<=	in_v_reg * 12'd416;
		end
	end

	//--------------------------------------------
	/**********************************************
		R << 9 = 596Y				+ 	817Cr	-	114131
		G << 9 = 596Y	-	200Cb	-	416Cr	+	69370
		B << 9 = 596Y	+	1033Cb				-	141787
	**********************************************/
	reg	signed [BITS-1+12:0]	XOUT; 	
	reg	signed [BITS-1+12:0]	YOUT; 
	reg	signed [BITS-1+12:0]	ZOUT;
	always @ (posedge pclk or negedge rst_n) begin
		if(!rst_n) begin
			XOUT <= 0; 	
			YOUT <= 0; 
			ZOUT <= 0;
		end
		else begin
			XOUT <= (img_Y_r1 + img_Cr_r1 - (19'sd114131<<(BITS-8)))>>>9; 	
			YOUT <= (img_Y_r1 - img_Cb_r1 - img_Cr_r2 + (19'sd69370<<(BITS-8)))>>>9; 
			ZOUT <= (img_Y_r1 + img_Cb_r2 - (19'sd141787<<(BITS-8)))>>>9;
		end
	end

	//------------------------------------------
	//Divide 512 and get the result
	//{xx[19:11], xx[10:0]}
	reg	[BITS-1:0]	R, G, B;
	always @ (posedge pclk or negedge rst_n) begin
		if(!rst_n) begin
			R <= 0;
			G <= 0;
			B <= 0;
		end
		else begin
			R <= XOUT < 4'sd0 ? {BITS{1'b0}} : (XOUT > {BITS{1'b1}}) ? {BITS{1'b1}} : XOUT[BITS-1:0];
			G <= YOUT < 4'sd0 ? {BITS{1'b0}} : (YOUT > {BITS{1'b1}}) ? {BITS{1'b1}} : YOUT[BITS-1:0];
			B <= ZOUT < 4'sd0 ? {BITS{1'b0}} : (ZOUT > {BITS{1'b1}}) ? {BITS{1'b1}} : ZOUT[BITS-1:0];
		end
	end

	//------------------------------------------
	//lag n clocks signal sync  	 

	reg [BITS-1:0] in_rr [3:0];
    reg [BITS-1:0] in_gg [3:0];
    reg [BITS-1:0] in_bb [3:0];


	reg	[3:0]	vsync_r;
	reg	[3:0]	href_r;
	always @ (posedge pclk or negedge rst_n) begin
		if(!rst_n) begin
			vsync_r <= 0;
			href_r <= 0;
			in_rr[0] <= 0;
            in_gg[0] <= 0;
            in_bb[0] <= 0;

            in_rr[1] <= 0;
            in_gg[1] <= 0;
            in_bb[1] <= 0;

            in_rr[2] <= 0;
            in_gg[2] <= 0;
            in_bb[2] <= 0;

            in_rr[3] <= 0;
            in_gg[3] <= 0;
            in_bb[3] <= 0;
		end
		else begin
			vsync_r <= {vsync_r[2:0], in_vsync};
			href_r <= {href_r[2:0], in_href};
			in_rr[0] <= in_y;
            in_gg[0] <= in_u;
            in_bb[0] <= in_v;

            in_rr[1] <= in_rr[0];
            in_gg[1] <= in_gg[0];
            in_bb[1] <= in_bb[0];

            in_rr[2] <= in_rr[1];
            in_gg[2] <= in_gg[1];
            in_bb[2] <= in_bb[1];

            in_rr[3] <= in_rr[2];
            in_gg[3] <= in_gg[2];
            in_bb[3] <= in_bb[2];
		end
	end
	always @ (posedge pclk or negedge rst_n) begin
		if(!rst_n) begin
        	out_vsync			<=	0	;
            out_href			<=	0	;
            out_r				<=	0	;
            out_g				<=	0	;
            out_b				<=	0	;
            yuv2rgb_data_valid	<=	0	;
            
        end else if(switch)begin
        	out_vsync			<=	vsync_r[3]											;
            out_href			<=	href_r[3]											;     
            out_r				<=	out_href ? (0 ? in_rr[3] : R) : {BITS{1'b0}}	;  
            out_g				<=	out_href ? (0 ? in_gg[3] : G) : {BITS{1'b0}}	;            
            out_b				<=	out_href ? (0 ? in_bb[3] : B) : {BITS{1'b0}}	;            
            yuv2rgb_data_valid	<=	out_href ? pclk :1'b0;  
      	end else begin
        	out_vsync			<=	in_vsync;
            out_href			<=	in_href	;     
            out_r				<=	in_y	;  
            out_g				<=	in_u	;            
            out_b				<=	in_v	;            
            yuv2rgb_data_valid	<=	in_href;  
		end
    end        

endmodule

