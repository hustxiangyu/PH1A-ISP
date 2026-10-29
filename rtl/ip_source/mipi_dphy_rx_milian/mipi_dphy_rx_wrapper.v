


module mipi_dphy_rx_wrapper #(
    parameter LANE_NUM = 4
)(
    input wire        I_rst_n,

	input wire[8:0]   I_clk_lane_idelay,
	input wire[8:0]   I_data_lane0_idelay,
	input wire[8:0]   I_data_lane1_idelay,
	input wire[8:0]   I_data_lane2_idelay,
	input wire[8:0]   I_data_lane3_idelay,

    output wire       O_hs_rx_clk,
    output wire       O_hs_rx_valid,
    output wire[31:0] O_hs_rx_data,

    input wire        I_lp_rx_clk,
    output wire       O_lp_rx_valid,
    output wire[7:0]  O_lp_rx_data,    
    
	output wire[3:0]  O_lane_error
);


    wire       S_hs_rx_valid;  
    wire[31:0] S_hs_rx_data;   
    
    wire       S_aligner_ch0_valid;
    wire[7:0]  S_aligner_ch0_data; 
    wire       S_aligner_ch1_valid;
    wire[7:0]  S_aligner_ch1_data; 
    wire       S_aligner_ch2_valid;
    wire[7:0]  S_aligner_ch2_data; 
    wire       S_aligner_ch3_valid;
    wire[7:0]  S_aligner_ch3_data; 
    
    wire       S_lane_error_0;     //synthesis keep;
    wire       S_lane_error_1;     //synthesis keep;
    wire       S_lane_error_2;     //synthesis keep;
    wire       S_lane_error_3;     //synthesis keep;
        
    channel_aligner_4 u_channel_aligner_4(
        .I_clk       ( O_hs_rx_clk         ),
        .I_rst_n     ( I_rst_n             ),

        .I_ch0_valid ( S_aligner_ch0_valid ),
        .I_ch0_data  ( S_aligner_ch0_data  ),

        .I_ch1_valid ( S_aligner_ch1_valid ),
        .I_ch1_data  ( S_aligner_ch1_data  ),

        .I_ch2_valid ( S_aligner_ch2_valid ),
        .I_ch2_data  ( S_aligner_ch2_data  ),

        .I_ch3_valid ( S_aligner_ch3_valid ),
        .I_ch3_data  ( S_aligner_ch3_data  ),

        .O_hs_valid  ( O_hs_rx_valid       ),
        .O_hs_data   ( O_hs_rx_data        )
    );
    

    bit_aligner_wrapper u_bit_aligner_wrapper(
        .I_clk               ( O_hs_rx_clk         ),
        .I_rst_n             ( I_rst_n             ),
        
        .I_hs_valid          ( S_hs_rx_valid       ),
        .I_hs_data           ( S_hs_rx_data        ),

        .O_aligner_ch0_valid ( S_aligner_ch0_valid ),
        .O_aligner_ch0_data  ( S_aligner_ch0_data  ),

        .O_aligner_ch1_valid ( S_aligner_ch1_valid ),
        .O_aligner_ch1_data  ( S_aligner_ch1_data  ), 

        .O_aligner_ch2_valid ( S_aligner_ch2_valid ),
        .O_aligner_ch2_data  ( S_aligner_ch2_data  ), 

        .O_aligner_ch3_valid ( S_aligner_ch3_valid ),
        .O_aligner_ch3_data  ( S_aligner_ch3_data  ), 

        .O_lane_0_error      ( S_lane_error_0      ),
        .O_lane_1_error      ( S_lane_error_1      ),
        .O_lane_2_error      ( S_lane_error_2      ),
        .O_lane_3_error      ( S_lane_error_3      )
    );


    PH1A90_MIPIIO_RX u_PH1A90_MIPIIO_RX(
		.I_lp_clk            ( I_lp_rx_clk         ),
        .I_rst_n             ( I_rst_n             ),

		.I_data_lane3_idelay ( I_data_lane3_idelay ), 
		.I_data_lane1_idelay ( I_data_lane1_idelay ), 
		.I_data_lane2_idelay ( I_data_lane2_idelay ), 
		.I_data_lane0_idelay ( I_data_lane0_idelay ), 
		.I_clk_lane_idelay 	 ( I_clk_lane_idelay   ), 

        .I_lane_0_lptx_valid ( 1'b0                ),
        .I_lane_0_lptx_p     ( 1'b0                ),
        .I_lane_0_lptx_n     ( 1'b0                ),

        .O_lane_0_lprx_p     (                     ),
        .O_lane_0_lprx_n     (                     ),

        .O_mipiio_hs_clk     ( O_hs_rx_clk         ),
        .O_mipiio_hs_valid   ( S_hs_rx_valid       ),
        .O_mipiio_hs_data    ( S_hs_rx_data        )
    );


    
endmodule