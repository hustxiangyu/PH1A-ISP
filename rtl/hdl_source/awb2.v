
/*********awb  °×Æ½ºâËã·¨***********
*********************************************************************/

module awb
(
    input  wire                 I_clk             ,
    input  wire                 I_rst_n           ,
    input  wire					switch			  ,
    input  wire     [ 7:0]      I_red_gain        ,
    input  wire     [ 7:0]      I_green_gain      ,
    input  wire     [ 7:0]      I_blue_gain       ,
    
    input  wire                 I_awb_vs          ,
    input  wire                 I_awb_hs          ,
    input  wire                 I_awb_de          ,
    input  wire     [23:0]      I_awb_rgb         ,
    
    output reg                  O_awb_vs          ,
    output reg                  O_awb_hs          ,
    output reg                  O_awb_de          ,
    output reg      [23:0]      O_awb_rgb    
);
//----------------------------------------------------------------------
reg                             awb_vs_dly;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
        awb_vs_dly <= 1'b0;
    else
        awb_vs_dly <= I_awb_vs;
end

wire                            lcd_vs_neg;
assign lcd_vs_neg = awb_vs_dly & ~I_awb_vs;

//	Hold up to 1920*1080. 
reg             [28:0]          acc_red_data_tmp;
reg             [28:0]          acc_green_data_tmp;
reg             [28:0]          acc_blue_data_tmp;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
    begin
        acc_red_data_tmp   <= 29'b0;
        acc_green_data_tmp <= 29'b0;
        acc_blue_data_tmp  <= 29'b0;
    end
    else
    begin
        if(lcd_vs_neg == 1'b1)
        begin
            acc_red_data_tmp   <= 29'b0;
            acc_green_data_tmp <= 29'b0;
            acc_blue_data_tmp  <= 29'b0;
        end
	  
	  //	Accumulate when hs && de (for DVP timing). 
        else if(I_awb_hs && I_awb_de)
        begin
            acc_red_data_tmp   <= acc_red_data_tmp + I_awb_rgb[23:16];
            acc_green_data_tmp <= acc_green_data_tmp + I_awb_rgb[15:8];
            acc_blue_data_tmp  <= acc_blue_data_tmp + I_awb_rgb[7:0];
        end
        else
        begin
            acc_red_data_tmp   <= acc_red_data_tmp;
            acc_green_data_tmp <= acc_green_data_tmp;
            acc_blue_data_tmp  <= acc_blue_data_tmp;
        end
    end
end

reg             [28:0]          acc_red_data;
reg             [28:0]          acc_green_data;
reg             [28:0]          acc_blue_data;
reg 					  r_acc_raw_valid = 0; 

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
    begin
        acc_red_data   <= 29'h0000_0001;
        acc_green_data <= 29'h0000_0001;
        acc_blue_data  <= 29'h0000_0001;
	  r_acc_raw_valid <= 0; 
    end
    else
    begin
	r_acc_raw_valid <= 0; 
        if(lcd_vs_neg == 1'b1)
        begin
            acc_red_data   <= acc_red_data_tmp;
            acc_green_data <= acc_green_data_tmp;
            acc_blue_data  <= acc_blue_data_tmp;
		r_acc_raw_valid <= 1; 
        end
        else
        begin
            acc_red_data   <= acc_red_data;
            acc_green_data <= acc_green_data;
            acc_blue_data  <= acc_blue_data;
        end
    end
end

//	Get acc gain
wire 	[41:0] 	w_acc_r, w_acc_b; 
wire 			w_acc_done; 
div_u42_u30 u_div_u42_u30_r
(
	.clk		(I_clk),
	.den		({acc_red_data, 1'b1}),
	.num		({acc_green_data, 13'b0}),		//	Add by 1 to avoid divide by 0. Quotient [11:0] is digit. 
	.rst		(~I_rst_n),
	.start	    (r_acc_raw_valid),
	.done		(w_acc_done),
	.quo		(w_acc_r),
	.rem		()
);
div_u42_u30 u_div_u42_u30_b
(
	.clk		(I_clk),
	.den		({acc_blue_data, 1'b1}),
	.num		({acc_green_data, 13'b0}),		//	Add by 1 to avoid divide by 0. 
	.rst		(~I_rst_n),
	.start	    (r_acc_raw_valid),
	.done		(),
	.quo		(w_acc_b),
	.rem		()
);
reg 	[15:0] 	r_acc_r = 16'h1000, r_acc_b = 16'h1000; 	//	4.12 fixed point

always @(posedge I_clk or negedge I_rst_n) begin
	if(~I_rst_n) begin
		r_acc_r <= 16'h1000;
		r_acc_b <= 16'h1000;
	end else begin
		if(w_acc_done) begin
			//	Overflow. 
			if(|w_acc_r[41:16])
				r_acc_r <= 16'hFFFF;
			else
				r_acc_r <= w_acc_r; 
			
			if(|w_acc_b[41:16])
				r_acc_b <= 16'hFFFF;
			else
				r_acc_b <= w_acc_b; 
		end else begin
		end
	end
end



reg 	[7:0] 	r_in_r = 0, r_in_g = 0, r_in_b = 0; 
reg 			r_in_vs = 0, r_in_hs = 0, r_in_de = 0; 

wire 	[23:0] 	w_in_r = (r_in_r * r_acc_r)*275>>>8; 
wire 	[23:0] 	w_in_g = (r_in_g * 16'h1000)*225>>>8; 
wire 	[23:0] 	w_in_b = (r_in_b * r_acc_b)*285>>>8; 

always @(posedge I_clk) begin
 	if(switch)begin
		r_in_r <= I_awb_rgb[23:16]; 
		r_in_g <= I_awb_rgb[15: 8]; 
		r_in_b <= I_awb_rgb[ 7: 0]; 
		r_in_vs <= I_awb_vs; 
		r_in_hs <= I_awb_hs; 
		r_in_de <= I_awb_de; 
		
		O_awb_vs <= r_in_vs; 
		O_awb_hs <= r_in_hs; 
		O_awb_de <= r_in_de; 
		O_awb_rgb[23:16] <= (|w_in_r[23:20]) ? 8'hFF : w_in_r[19:12]; 
		O_awb_rgb[15: 8] <= (|w_in_g[23:20]) ? 8'hFF : w_in_g[19:12]; 
		O_awb_rgb[ 7: 0] <= (|w_in_b[23:20]) ? 8'hFF : w_in_b[19:12]; 
 	end else begin
		O_awb_vs <= I_awb_vs; 
		O_awb_hs <= I_awb_hs; 
		O_awb_de <= I_awb_de; 
		O_awb_rgb<=I_awb_rgb;		
	end
end
endmodule
