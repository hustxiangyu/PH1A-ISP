module ispline(
	input vtc_clk,
    input vtc_rstn,
    input vtc_vs,
    input vtc_de,
    input [7:0] vtc_data,
    output o_csc_vs,
    output o_csc_de,
    output [7:0] o_csc_y
 );

    wire 			w_rgb_vsync, w_rgb_href; //synthesis keep
    wire 	[7:0] 	w_rgb_r, w_rgb_g, w_rgb_b; //synthesis keep
raw8_2_rgb888 #(
    .H_SIZE(1920), 
    .V_SIZE(1080)
    )u_raw8_2_rgb888 
    (
    .I_clk	        (vtc_clk),                //cmos video pixel clock
    .I_rst_n	    (vtc_rstn),              //global reset
            
    //CMOS YCbCr444 data output
    .I_raw_vs	    (vtc_vs),    //Prepared Image data vsync valid signal. Reset on falling edge. 
    .I_raw_de	    (vtc_de),     //Prepared Image data href vaild  signal
    .I_raw_data	    (vtc_data),        //Prepared Image data 8 Bit RAW Data
	.switch			(1)	 ,
    .O_rgb_vs	    (w_rgb_vsync),   //Processed Image data vsync valid signal
    .O_rgb_de	    (w_rgb_href),    //Processed Image data href vaild  signal
    .O_rgb_r		(w_rgb_r),       //Prepared Image green data to be processed 
    .O_rgb_g	    (w_rgb_g),     //Prepared Image green data to be processed
    .O_rgb_b		(w_rgb_b)       //Prepared Image blue data to be processed
    );
    
    wire 			w_awb_vs, w_awb_hs, w_awb_de; //synthesis keep
    wire 	[7:0] 	w_awb_r, w_awb_g, w_awb_b;//synthesis keep
    awb u_awb 
    (
    .I_clk          (vtc_clk),
    .I_rst_n        (vtc_rstn),

    .I_red_gain     (0),
    .I_green_gain   (0),
    .I_blue_gain    (0),
	.switch			(1),
    .I_awb_vs       (w_rgb_vsync),
    .I_awb_hs       (w_rgb_href),
    .I_awb_de       (w_rgb_href),
    .I_awb_rgb      ({w_rgb_r, w_rgb_g, w_rgb_b}),

    .O_awb_vs       (w_awb_vs),
    .O_awb_hs       (w_awb_hs),
    .O_awb_de       (w_awb_de),
    .O_awb_rgb      ({w_awb_r, w_awb_g, w_awb_b})
    );
    
    wire	[7:0]	w_ccm_r, w_ccm_g, w_ccm_b;//synthesis keep
    wire 			w_ccm_vs, w_ccm_hs, w_ccm_de; //synthesis keep
 isp_ccm u_isp_ccm
 (
     
     .pclk    		 (vtc_clk),                         
	 .rst_n          (vtc_rstn),                 
     .switch		 (1),
	 .ccm_rr         (12'b0101_0000_1010),
     .ccm_rg         (12'b1110_0011_0011),
     .ccm_rb         (12'b0000_1100_0011),
	 .ccm_gr         (12'b1110_1011_1000),
     .ccm_gg         (12'b0011_1110_1000),
     .ccm_gb         (12'b0001_0110_0001),
	 .ccm_br         (12'b1110_1110_1111),
     .ccm_bg         (12'b1110_0110_1011),
     .ccm_bb         (12'b0110_1010_0111),
/*
	 .pclk    		 (vtc_clk),                         
	 .rst_n          (vtc_rstn),                 
     .switch		 (data[2]),
	 .ccm_rr         (12'b0010_0000_0000),
     .ccm_rg         (12'b1111_1111_1011),
     .ccm_rb         (12'b0000_0001_0011),
	 .ccm_gr         (12'b1111_1010_1110),
     .ccm_gg         (12'b0011_00001_1001),
     .ccm_gb         (12'b1111_1111_1010),
	 .ccm_br         (12'b1111_1111_0000),
     .ccm_bg         (12'b0100_0110_0110),
     .ccm_bb         (12'b0001_1010_1101),
*/
	 .in_href        (w_awb_de),                   
	 .in_hsync       (w_awb_hs),                   
	 .in_vsync       (w_awb_vs),                   
	 .in_r           (w_awb_r),       
	 .in_g           (w_awb_g),       
	 .in_b           (w_awb_b),        
     
	 .out_href       (w_ccm_de),                  
	 .out_hsync      (w_ccm_hs),                  
	 .out_vsync      (w_ccm_vs),                  
	 .out_r          (w_ccm_r),       
	 .out_g          (w_ccm_g),       
	 .out_b          (w_ccm_b)      
 );
wire gamma_de,gamma_vs,gamma_hf;//synthesis keep
wire[7:0]gamma_r,gamma_g,gamma_b;//synthesis keep
isp_gamma isp_gamma_inst
(
	  .clk	   (vtc_clk		),
      .i_data_r(w_ccm_r	),
      .i_data_g(w_ccm_g	),
      .i_data_b(w_ccm_b	),
      .switch1 (1	),
      .light (0),
      .dark  (0),
      .i_data_valid	(w_ccm_de	)	,
      .i_href		(w_ccm_hs	)	,
      .i_vsync		(w_ccm_vs	)	,
      .o_vsync		(gamma_vs	)	,
      .o_data_r		(gamma_r	)	,
      .o_data_g		(gamma_g	)	,
      .o_data_b		(gamma_b	)	,
      .o_data_valid (gamma_de	)
 );
//contrast
wire contrast_vs,contrast_de;//synthesis keep
wire [7:0]contrast_r,contrast_g,contrast_b;//synthesis keep
isp_contrast isp_contrast_inst
(
      .clk               (vtc_clk    ),
      .i_data_r        (gamma_r    )        ,
      .i_data_g        (gamma_g    )        ,
      .i_data_b        (gamma_b    )        ,
      .switch1        (1    )        ,
      .light         (0    ),
      .dark          (0   ),                         
      .i_data_valid    (gamma_de    )        ,
      .i_href        (gamma_de    )        ,
      .i_vsync        (gamma_vs    )        ,
      .o_vsync        (contrast_vs)        ,
      .o_data_r        (contrast_r    )        ,
      .o_data_g        (contrast_g    )        ,
      .o_data_b        (contrast_b    )        ,
      .o_data_valid (contrast_de)
 );
 
 wire o_csc_de,o_csc_hs,o_csc_vs;//synthesis keep
wire [7:0] o_csc_y;//synthesis keep
wire [7:0] o_csc_u;//synthesis keep
wire [7:0] o_csc_v;//synthesis keep

isp_rgb2yuv #(
    .WIDTH(1920),
    .HEIGHT(1080)
)u_rgb_yuv(
    .pclk(vtc_clk),
    .rst_n(vtc_rstn),
    .switch(1),//**************************************
    
    .in_href(contrast_de),
    .in_vsync(contrast_vs),
    .in_r(contrast_r),
    .in_g(contrast_g),
    .in_b(contrast_b),
    
    .out_href(o_csc_de),
    .out_vsync(o_csc_vs),
    .out_y(o_csc_y),
    .out_u(o_csc_u),
    .out_v(o_csc_v)
);

endmodule
