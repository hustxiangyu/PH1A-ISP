

module PH1A90_MIPIIO_RX (
	input wire        I_lp_clk,
    input wire        I_rst_n,

	input wire[8:0]   I_clk_lane_idelay,
	input wire[8:0]   I_data_lane0_idelay,
	input wire[8:0]   I_data_lane1_idelay,
	input wire[8:0]   I_data_lane2_idelay,
	input wire[8:0]   I_data_lane3_idelay,

    input wire        I_lane_0_lptx_valid,
    input wire        I_lane_0_lptx_p,
    input wire        I_lane_0_lptx_n,

    output wire       O_lane_0_lprx_p,
    output wire       O_lane_0_lprx_n,

    output wire       O_mipiio_hs_clk,
    output reg        O_mipiio_hs_valid,
    output wire[31:0] O_mipiio_hs_data
);


    wire       S_clk_lane_lp_p;
    wire       S_clk_lane_lp_n;
    wire       S_data_0_lane_lp_p;
    wire       S_data_0_lane_lp_n;

    wire       S_data_lane_hs_en;
    wire       S_clk_lane_hs_en;

    wire       S_fifo_empty;
    reg        S_mipiio_hs_valid_1d;
    reg        S_mipiio_hs_valid_2d;

    assign O_lane_0_lprx_p = S_data_0_lane_lp_p;
    assign O_lane_0_lprx_n = S_data_0_lane_lp_n;


	always @ (posedge O_mipiio_hs_clk) begin
    	S_mipiio_hs_valid_1d <= ~S_fifo_empty;
        S_mipiio_hs_valid_2d <= S_mipiio_hs_valid_1d;
        O_mipiio_hs_valid    <= S_mipiio_hs_valid_2d;
    end



    hs_detect u_data_hs_detect(
        .I_clk   ( I_lp_clk           ),
        .I_rst_n ( I_rst_n            ),

        .I_lp_p  ( S_data_0_lane_lp_p ),
        .I_lp_n  ( S_data_0_lane_lp_n ),

        .O_hs_en ( S_data_lane_hs_en  )
    );


//    hs_detect u_clk_hs_detect(
//        .I_clk   ( I_lp_clk         ),
//        .I_rst_n ( I_rst_n          ),

//        .I_lp_p  ( S_clk_lane_lp_p  ),
//        .I_lp_n  ( S_clk_lane_lp_n  ),

//        .O_hs_en ( S_clk_lane_hs_en )
//    );


    ph1_mipiio u_mipiio(
        .hsrx_clk_detect            ( ),
        .hsrx_byteclk_to_fabric     ( O_mipiio_hs_clk      ),

        .lprx_ch0_cd_dn             ( ),
        .lprx_ch0_cd_dp             ( ),
        .lprx_ch0_dn                ( S_data_0_lane_lp_n   ),
        .lprx_ch0_dp                ( S_data_0_lane_lp_p   ),
        .lprx_ch0_en                ( ~I_lane_0_lptx_valid ),
        .lptx_ch0_dn                ( I_lane_0_lptx_n      ),
        .lptx_ch0_dp                ( I_lane_0_lptx_p      ),
        .lptx_ch0_en                ( I_lane_0_lptx_valid  ),
        .lprx_ch1_cd_dn             (),
        .lprx_ch1_cd_dp             (),
        .lprx_ch1_dn                (),
        .lprx_ch1_dp                (),
        .lprx_ch1_en                (1'b1),
        .lprx_ch2_cd_dn             (),
        .lprx_ch2_cd_dp             (),
        .lprx_ch2_dn                (),
        .lprx_ch2_dp                (),
        .lprx_ch2_en                (1'b1),
        .lprx_ch3_cd_dn             (),
        .lprx_ch3_cd_dp             (),
        .lprx_ch3_dn                (),
        .lprx_ch3_dp                (),
        .lprx_ch3_en                (1'b1),
        .lprx_chc_cd_dn             (),
        .lprx_chc_cd_dp             (),
        .lprx_chc_dn                ( S_clk_lane_lp_n   ),
        .lprx_chc_dp                ( S_clk_lane_lp_p   ),
        .lprx_chc_en                (1'b1),

        .hsrx_ch0_rstn              ( I_rst_n           ),
        .hsrx_ch0_en                ( S_data_lane_hs_en ),
        .rterm_ch0_en               ( S_data_lane_hs_en ),
        .hsrx_ch1_rstn              ( I_rst_n           ),
        .hsrx_ch1_en                ( S_data_lane_hs_en ),
        .rterm_ch1_en               ( S_data_lane_hs_en ),
        .hsrx_ch2_rstn              ( I_rst_n           ),
        .hsrx_ch2_en                ( S_data_lane_hs_en ),
        .rterm_ch2_en               ( S_data_lane_hs_en ),
        .hsrx_ch3_rstn              ( I_rst_n           ),
        .hsrx_ch3_en                ( S_data_lane_hs_en ),
        .rterm_ch3_en               ( S_data_lane_hs_en ),
        .hsrx_chc_rstn              ( I_rst_n           ),
        .hsrx_chc_en                ( 1'b1  ),
        .rterm_chc_en               ( 1'b1  ),

        .fifo_ch0_read_1al_empty    (),
        .fifo_ch0_read_3al_empty    (),
        .fifo_ch0_read_empty        ( S_fifo_empty      ),
        .fifo_ch0_write_full        (),
        .fifo_ch0_write_afull       (),
        .fifo_ch1_read_1al_empty    (),
        .fifo_ch1_read_3al_empty    (),
        .fifo_ch1_read_empty        (),
        .fifo_ch1_write_full        (),
        .fifo_ch1_write_afull       (),
        .fifo_ch2_read_1al_empty    (),
        .fifo_ch2_read_3al_empty    (),
        .fifo_ch2_read_empty        (),
        .fifo_ch2_write_full        (),
        .fifo_ch2_write_afull       (),
        .fifo_ch3_read_1al_empty    (),
        .fifo_ch3_read_3al_empty    (),
        .fifo_ch3_read_empty        (),
        .fifo_ch3_write_full        (),
        .fifo_ch3_write_afull       (),

        .fifo_ch0_data_low          ( O_mipiio_hs_data[31:24] ),
        .fifo_ch1_data_low          ( O_mipiio_hs_data[23:16] ),
        .fifo_ch2_data_low          ( O_mipiio_hs_data[15:8]  ),
        .fifo_ch3_data_low          ( O_mipiio_hs_data[7:0]   ),

        .fifo_write_rstn            ( I_rst_n       ),
        .fifo_read_rstn             ( I_rst_n       ),
        .fifo_write_enable          ( S_data_lane_hs_en       ),
        .fifo_read_8bit_enable      ( ~S_fifo_empty           ),
        .fifo_read_clk              ( O_mipiio_hs_clk         ),

		.I_data_lane3_idelay        ( I_data_lane3_idelay     ), 
		.I_data_lane1_idelay        ( I_data_lane1_idelay     ), 
		.I_data_lane2_idelay        ( I_data_lane2_idelay     ), 
		.I_data_lane0_idelay        ( I_data_lane0_idelay     ), 
		.I_clk_lane_idelay 	        ( I_clk_lane_idelay       ), 

        .mipi_pd                    ( 1'b0 ),

        .dn_0                       (d0_n),
        .dp_0                       (d0_p),
        .dn_1                       (d1_n),
        .dp_1                       (d1_p),
        .dn_2                       (d2_n),
        .dp_2                       (d2_p),
        .dn_3                       (d3_n),
        .dp_3                       (d3_p),
        .cn                         (ck_n),
        .cp                         (ck_p)
    );




    
endmodule