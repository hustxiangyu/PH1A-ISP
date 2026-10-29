

module bit_aligner_wrapper (
    input wire        I_clk,
    input wire        I_rst_n,
    
    input wire        I_hs_valid,
    input wire[31:0]  I_hs_data,

    output wire       O_aligner_ch0_valid,
    output wire[7:0]  O_aligner_ch0_data,    

    output wire       O_aligner_ch1_valid,
    output wire[7:0]  O_aligner_ch1_data,    

    output wire       O_aligner_ch2_valid,
    output wire[7:0]  O_aligner_ch2_data,    

    output wire       O_aligner_ch3_valid,
    output wire[7:0]  O_aligner_ch3_data,    
    
	output wire       O_lane_0_error,
    output wire       O_lane_1_error,
    output wire       O_lane_2_error,
    output wire       O_lane_3_error
);


    bit_aligner u0_bit_aligner(
        .I_clk           ( I_clk               ),
        .I_rst           ( ~I_rst_n            ),
    
        .I_hs_valid      ( I_hs_valid          ),
        .I_hs_data       ( I_hs_data[7:0]      ),

        .O_aligner_valid ( O_aligner_ch0_valid ),
        .O_aligner_data  ( O_aligner_ch0_data  ),

        .O_lane_error    ( O_lane_0_error      )
    );


    bit_aligner u1_bit_aligner(
        .I_clk           ( I_clk                ),
        .I_rst           ( ~I_rst_n             ),
    
        .I_hs_valid      ( I_hs_valid           ),
        .I_hs_data       ( I_hs_data[15:8]      ),

        .O_aligner_valid ( O_aligner_ch1_valid ),
        .O_aligner_data  ( O_aligner_ch1_data  ),

        .O_lane_error    ( O_lane_1_error       )
    );


    bit_aligner u2_bit_aligner(
        .I_clk           ( I_clk                 ),
        .I_rst           ( ~I_rst_n              ),
    
        .I_hs_valid      ( I_hs_valid            ),
        .I_hs_data       ( I_hs_data[23:16]      ),

        .O_aligner_valid ( O_aligner_ch2_valid ),
        .O_aligner_data  ( O_aligner_ch2_data  ),

        .O_lane_error    ( O_lane_2_error        )
    );


    bit_aligner u3_bit_aligner(
        .I_clk           ( I_clk                 ),
        .I_rst           ( ~I_rst_n              ),
    
        .I_hs_valid      ( I_hs_valid            ),
        .I_hs_data       ( I_hs_data[31:24]      ),

        .O_aligner_valid ( O_aligner_ch3_valid ),
        .O_aligner_data  ( O_aligner_ch3_data  ),

        .O_lane_error    ( O_lane_3_error        )
    );

endmodule