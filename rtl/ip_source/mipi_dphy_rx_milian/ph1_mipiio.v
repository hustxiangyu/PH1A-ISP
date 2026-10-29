`timescale 1ns / 100ps
// Author: Anlogic
// 
// Description:
//
//		mipiio 
// 
// Web: www.anlogic.com
// 
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2022/03/24   |Initial ver
// --------------------------------------------------------------------
// `define LVCMOS_ENABLE
// `define LVDS_MODE
`define FIFO_ENABLE
`define MIPIIO_LANE0_EN //
`define MIPIIO_LANE1_EN
`define MIPIIO_LANE2_EN
`define MIPIIO_LANE3_EN


module ph1_mipiio(

	input wire[8:0] I_clk_lane_idelay,
	input wire[8:0] I_data_lane0_idelay,
	input wire[8:0] I_data_lane1_idelay,
	input wire[8:0] I_data_lane2_idelay,
	input wire[8:0] I_data_lane3_idelay,
`ifdef LVCMOS_ENABLE
`ifdef MIPIIO_LANE0_EN
	output 	wire		sgcc_lvcmos_n_0 			,
	output 	wire 		sgcc_lvcmos_p_0 			,
`endif
`ifdef MIPIIO_LANE1_EN
	output 	wire		sgcc_lvcmos_n_1 			,
	output 	wire 		sgcc_lvcmos_p_1 			,
`endif
`ifdef MIPIIO_LANE2_EN
	output 	wire		sgcc_lvcmos_n_2 			,
	output 	wire 		sgcc_lvcmos_p_2 			,
`endif
`ifdef MIPIIO_LANE3_EN
	output 	wire		sgcc_lvcmos_n_3 			,
	output 	wire 		sgcc_lvcmos_p_3 			,
`endif
	output 	wire		sgcc_lvcmos_n_c 			,
	output 	wire 		sgcc_lvcmos_p_c 			,
`else
	output 	wire 		hsrx_clk_detect 			,
	output 	wire 		hsrx_byteclk_to_fabric		,
`ifdef LVDS_MODE
	output 	wire 		lvds_clk_to_gpll 			,
	input 	wire 		lvds_clk_from_gpll 			,
`else
`ifdef MIPIIO_LANE0_EN
	output 	wire 		lprx_ch0_cd_dn 				,
	output 	wire 		lprx_ch0_cd_dp 				,
	output 	wire 		lprx_ch0_dn 				,
	output 	wire 		lprx_ch0_dp 				,
	input 	wire 		lprx_ch0_en					,
	input 	wire 		lptx_ch0_dn					,
	input 	wire 		lptx_ch0_dp					,
	input 	wire 		lptx_ch0_en					,
`endif
`ifdef MIPIIO_LANE1_EN
	output 	wire 		lprx_ch1_cd_dn 				,
	output 	wire 		lprx_ch1_cd_dp 				,
	output 	wire 		lprx_ch1_dn 				,
	output 	wire 		lprx_ch1_dp 				,
	input 	wire 		lprx_ch1_en					,
`endif
`ifdef MIPIIO_LANE2_EN
	output 	wire 		lprx_ch2_cd_dn 				,
	output 	wire 		lprx_ch2_cd_dp 				,
	output 	wire 		lprx_ch2_dn 				,
	output 	wire 		lprx_ch2_dp 				,
	input 	wire 		lprx_ch2_en					,
`endif
`ifdef MIPIIO_LANE3_EN
	output 	wire 		lprx_ch3_cd_dn 				,
	output 	wire 		lprx_ch3_cd_dp 				,
	output 	wire 		lprx_ch3_dn 				,
	output 	wire 		lprx_ch3_dp 				,
	input 	wire 		lprx_ch3_en					,
`endif
	output 	wire 		lprx_chc_cd_dn 				,
	output 	wire 		lprx_chc_cd_dp 				,
	output 	wire 		lprx_chc_dn 				,
	output 	wire 		lprx_chc_dp 				,
	input 	wire 		lprx_chc_en					,
`endif
`ifdef MIPIIO_LANE0_EN
	input 	wire 		hsrx_ch0_rstn 				,
	input 	wire 		hsrx_ch0_en					,
	input 	wire 		rterm_ch0_en				,
`endif
`ifdef MIPIIO_LANE1_EN
	input 	wire 		hsrx_ch1_rstn 				,
	input 	wire 		hsrx_ch1_en					,
	input 	wire 		rterm_ch1_en				,
`endif
`ifdef MIPIIO_LANE2_EN
	input 	wire 		hsrx_ch2_rstn 				,
	input 	wire 		hsrx_ch2_en					,
	input 	wire 		rterm_ch2_en				,
`endif
`ifdef MIPIIO_LANE3_EN
	input 	wire 		hsrx_ch3_rstn 				,
	input 	wire 		hsrx_ch3_en					,
	input 	wire 		rterm_ch3_en				,
`endif
	input 	wire 		hsrx_chc_rstn 				,
	input 	wire 		hsrx_chc_en					,
	input 	wire 		rterm_chc_en				,
`ifdef FIFO_ENABLE 
`ifdef MIPIIO_LANE0_EN
	output 	wire 		fifo_ch0_read_1al_empty 	,
	output 	wire 		fifo_ch0_read_3al_empty 	,
	output 	wire 		fifo_ch0_read_empty 		,
	output 	wire 		fifo_ch0_write_full 		,
	output 	wire 		fifo_ch0_write_afull 		,
`endif
`ifdef MIPIIO_LANE1_EN
	output 	wire 		fifo_ch1_read_1al_empty		,
	output 	wire 		fifo_ch1_read_3al_empty		,
	output 	wire 		fifo_ch1_read_empty			,
	output 	wire 		fifo_ch1_write_full 		,
	output 	wire 		fifo_ch1_write_afull 		,
`endif
`ifdef MIPIIO_LANE2_EN
	output 	wire 		fifo_ch2_read_1al_empty 	,
	output 	wire 		fifo_ch2_read_3al_empty 	,
	output 	wire 		fifo_ch2_read_empty 		,
	output 	wire 		fifo_ch2_write_full 		,
	output 	wire 		fifo_ch2_write_afull 		,
`endif
`ifdef MIPIIO_LANE3_EN
	output 	wire 		fifo_ch3_read_1al_empty 	,
	output 	wire 		fifo_ch3_read_3al_empty 	,
	output 	wire 		fifo_ch3_read_empty 		,
	output 	wire 		fifo_ch3_write_full 		,
	output 	wire 		fifo_ch3_write_afull 		,
`endif
`ifdef MIPIIO_LANE0_EN
	output 	wire [7:0]	fifo_ch0_data_low 			,
`endif
`ifdef MIPIIO_LANE1_EN
	output 	wire [7:0]	fifo_ch1_data_low 			,
`endif
`ifdef MIPIIO_LANE2_EN
	output 	wire [7:0]	fifo_ch2_data_low 			,
`endif
`ifdef MIPIIO_LANE3_EN
	output 	wire [7:0]	fifo_ch3_data_low 			,
`endif
`ifdef FIFO_WIDTH_16
`ifdef MIPIIO_LANE0_EN
	output 	wire [7:0]	fifo_ch0_data_high			,
`endif
`ifdef MIPIIO_LANE1_EN
	output 	wire [7:0]	fifo_ch1_data_high			,
`endif
`ifdef MIPIIO_LANE2_EN
	output 	wire [7:0]	fifo_ch2_data_high			,
`endif
`ifdef MIPIIO_LANE3_EN
	output 	wire [7:0]	fifo_ch3_data_high			,
`endif
`endif
	input 	wire 		fifo_write_rstn				,
	input 	wire 		fifo_read_rstn 				,
	input 	wire 		fifo_write_enable 			,
`ifdef FIFO_WIDTH_16
	input 	wire 		fifo_read_16bit_enable 		,
`else 
	input 	wire 		fifo_read_8bit_enable 		,
`endif
	input 	wire 		fifo_read_clk 				,
`else 
`ifdef MIPIIO_LANE0_EN
	output 	wire [7:0]	fifo_ch0_data_low 			,
`endif
`ifdef MIPIIO_LANE1_EN
	output 	wire [7:0]	fifo_ch1_data_low 			,
`endif
`ifdef MIPIIO_LANE2_EN
	output 	wire [7:0]	fifo_ch2_data_low 			,
`endif
`ifdef MIPIIO_LANE3_EN
	output 	wire [7:0]	fifo_ch3_data_low 			,
`endif
`endif
`endif
	input 	wire 		mipi_pd 					,

`ifdef MIPIIO_LANE0_EN
	inout 	wire		dn_0 						,
	inout 	wire		dp_0 						,
`endif
`ifdef MIPIIO_LANE1_EN
	inout 	wire		dn_1 						,
	inout 	wire		dp_1 						,
`endif
`ifdef MIPIIO_LANE2_EN
	inout 	wire		dn_2 						,
	inout 	wire		dp_2 						,
`endif
`ifdef MIPIIO_LANE3_EN
	inout 	wire		dn_3 						,
	inout 	wire		dp_3						,
`endif
	inout 	wire		cn 							,
	inout 	wire		cp
);	

`ifdef LVCMOS_ENABLE
`ifdef MIPIIO_LANE0_EN
	parameter MC1_LVCMOS_EN_0 = "ENABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
`else                             
	parameter MC1_LVCMOS_EN_0 = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
`endif                            
`ifdef MIPIIO_LANE1_EN            
	parameter MC1_LVCMOS_EN_1 = "ENABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
`else                             
	parameter MC1_LVCMOS_EN_1 = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
`endif                            
`ifdef MIPIIO_LANE2_EN            
	parameter MC1_LVCMOS_EN_2 = "ENABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
`else                             
	parameter MC1_LVCMOS_EN_2 = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
`endif                            
`ifdef MIPIIO_LANE3_EN            
	parameter MC1_LVCMOS_EN_3 = "ENABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
`else                             
	parameter MC1_LVCMOS_EN_3 = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
`endif                            
	parameter MC1_LVCMOS_EN_C = "ENABLE" ;	// "0", "1": [mc1_lvcmos_en_c]
`else                             
	parameter MC1_LVCMOS_EN_0 = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_0]
	parameter MC1_LVCMOS_EN_1 = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_1]
	parameter MC1_LVCMOS_EN_2 = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_2]
	parameter MC1_LVCMOS_EN_3 = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_3]
	parameter MC1_LVCMOS_EN_C = "DISABLE" ;	// "0", "1": [mc1_lvcmos_en_c]
`endif

	wire	clkin ;
    wire	clkout;
	PH1_PHY_IOCLK u_ioclk(.clkin(clkin),.clkout(clkout));

	PH1_PHY_MIPIIO #(
		.LVCMOS_EN_0			(MC1_LVCMOS_EN_0 			),
		.LVCMOS_EN_1 			(MC1_LVCMOS_EN_1 			),
		.LVCMOS_EN_2			(MC1_LVCMOS_EN_2 			),
		.LVCMOS_EN_3 			(MC1_LVCMOS_EN_3 			),
		.LVCMOS_EN_C 			(MC1_LVCMOS_EN_C 			)
	)
	u_PH1_PHY_MIPIIO(
	`ifdef LVCMOS_ENABLE
		`ifdef MIPIIO_LANE0_EN
			.sgcc_lvcmos_n_0 			(sgcc_lvcmos_n_0 			),
			.sgcc_lvcmos_p_0 			(sgcc_lvcmos_p_0 			),
		`else
			.sgcc_lvcmos_n_0 			(),
			.sgcc_lvcmos_p_0 			(),
		`endif
		`ifdef MIPIIO_LANE1_EN
			.sgcc_lvcmos_n_1 			(sgcc_lvcmos_n_1 			),
			.sgcc_lvcmos_p_1 			(sgcc_lvcmos_p_1 			),
		`else
			.sgcc_lvcmos_n_1 			(),
			.sgcc_lvcmos_p_1 			(),
		`endif
		`ifdef MIPIIO_LANE2_EN
			.sgcc_lvcmos_n_2 			(sgcc_lvcmos_n_2 			),
			.sgcc_lvcmos_p_2 			(sgcc_lvcmos_p_2 			),
		`else
			.sgcc_lvcmos_n_2 			(),
			.sgcc_lvcmos_p_2 			(),
		`endif
		`ifdef MIPIIO_LANE3_EN
			.sgcc_lvcmos_n_3 			(sgcc_lvcmos_n_3 			),
			.sgcc_lvcmos_p_3 			(sgcc_lvcmos_p_3 			),
		`else
			.sgcc_lvcmos_n_3 			(),
			.sgcc_lvcmos_p_3 			(),
		`endif
			.sgcc_lvcmos_n_c 			(sgcc_lvcmos_n_c 			),
			.sgcc_lvcmos_p_c 			(sgcc_lvcmos_p_c 			),
	`else
		.sgcc_lvcmos_n_0 			(),
		.sgcc_lvcmos_p_0 			(),
		.sgcc_lvcmos_n_1 			(),
		.sgcc_lvcmos_p_1 			(),
		.sgcc_lvcmos_n_2 			(),
		.sgcc_lvcmos_p_2 			(),
		.sgcc_lvcmos_n_3 			(),
		.sgcc_lvcmos_p_3 			(),
		.sgcc_lvcmos_n_c 			(),
		.sgcc_lvcmos_p_c 			(),
	`endif
	`ifdef LVCMOS_ENABLE
		.fifo_ch0_read_1al_empty	(),
		.fifo_ch1_read_1al_empty	(),
		.fifo_ch2_read_1al_empty	(),
		.fifo_ch3_read_1al_empty	(),
		.fifo_ch0_read_3al_empty	(),
		.fifo_ch1_read_3al_empty	(),
		.fifo_ch2_read_3al_empty	(),
		.fifo_ch3_read_3al_empty	(),
		.fifo_ch0_read_empty		(),
		.fifo_ch1_read_empty		(),
		.fifo_ch2_read_empty		(),
		.fifo_ch3_read_empty		(),
		.fifo_ch0_write_full		(),
		.fifo_ch1_write_full		(),
		.fifo_ch2_write_full		(),
		.fifo_ch3_write_full		(),
		.fifo_ch0_write_alfull		(),
		.fifo_ch1_write_alfull		(),
		.fifo_ch2_write_alfull		(),
		.fifo_ch3_write_alfull		(),

		.sgcc_lvds_mode 			(1'b0 						),
	    .lvds_clk_to_gpll			(),
	    .lvds_clk_from_gpll 		(),

		.hsrx_clk_detect 			(),
		.hsrx_byteclk_to_fabric		(),

		.lprx_ch0_cd_dn 			(),
		.lprx_ch1_cd_dn 			(),
		.lprx_ch2_cd_dn 			(),
		.lprx_ch3_cd_dn 			(),
		.lprx_chc_cd_dn 			(),
		.lprx_ch0_cd_dp 			(),
		.lprx_ch1_cd_dp 			(),
		.lprx_ch2_cd_dp 			(),
		.lprx_ch3_cd_dp 			(),
		.lprx_chc_cd_dp 			(),
		.lprx_ch0_dn 				(),
		.lprx_ch1_dn 				(),
		.lprx_ch2_dn 				(),
		.lprx_ch3_dn 				(),
		.lprx_chc_dn 				(),
		.lprx_ch0_dp 				(),
		.lprx_ch1_dp 				(),
		.lprx_ch2_dp 				(),
		.lprx_ch3_dp 				(),
		.lprx_chc_dp 				(),

		.lprx_ch0_en				(1'b0 		 				),
	    .lprx_ch1_en				(1'b0 		 				),
	    .lprx_ch2_en				(1'b0 		 				),
	    .lprx_ch3_en				(1'b0 		 				),
	    .lprx_chc_en				(1'b0 		 				),
	    .lptx_ch0_dn				(1'b0 		 				),
	    .lptx_ch0_dp				(1'b0 		 				),
	    .lptx_ch0_en				(1'b0 		 				),

	    .hsrx_ch0_en				(1'b0 						),
	    .hsrx_ch1_en				(1'b0 						),
	    .hsrx_ch2_en				(1'b0 						),
	    .hsrx_ch3_en				(1'b0 						),
	    .hsrx_chc_en				(1'b0 						),
	    .hsrx_ch0_rstn				(1'b0 		 				),
	    .hsrx_ch1_rstn				(1'b0 		 				),
	    .hsrx_ch2_rstn				(1'b0 		 				),
	    .hsrx_ch3_rstn				(1'b0 		 				),
	    .hsrx_chc_rstn				(1'b0 		 				),
	    .rterm_ch0_en				(1'b0 						),
	    .rterm_ch1_en				(1'b0 						),
	    .rterm_ch2_en				(1'b0 						),
	    .rterm_ch3_en				(1'b0 						),
	    .rterm_chc_en				(1'b0 						),

		.sgcc_byte_16 				(1'b0 						),
		.fifo_read_8bit_enable 		(1'b0 				 		),
	    .fifo_read_16bit_enable 	(1'b0 					 	),

		.fifo_ch0_data_low 			(),
		.fifo_ch1_data_low 			(),
		.fifo_ch2_data_low 			(),
		.fifo_ch3_data_low 			(),

		.fifo_ch0_data_high			(),
	    .fifo_ch1_data_high 		(),
	    .fifo_ch2_data_high 		(),
	    .fifo_ch3_data_high			(),

		.fifo_bypass 				(1'b1 						),
		.fifo_read_clk 				(1'b0 						),
	    .fifo_write_enable 			(1'b0 						),
	    .fifo_read_rstn 			(1'b0 						),
	    .fifo_write_rstn 			(1'b0 						),
	`else
		`ifdef FIFO_ENABLE
			`ifdef MIPIIO_LANE0_EN
				.fifo_ch0_read_1al_empty	(fifo_ch0_read_1al_empty 	),
				.fifo_ch0_read_3al_empty	(fifo_ch0_read_3al_empty 	),
				.fifo_ch0_read_empty		(fifo_ch0_read_empty 		),
				.fifo_ch0_write_full		(fifo_ch0_write_full 		),
				.fifo_ch0_write_alfull		(fifo_ch0_write_alfull 		),
			`else 
				.fifo_ch0_read_1al_empty	(),
				.fifo_ch0_read_3al_empty	(),
				.fifo_ch0_read_empty		(),
				.fifo_ch0_write_full		(),
				.fifo_ch0_write_alfull		(),
			`endif
			`ifdef MIPIIO_LANE1_EN
				.fifo_ch1_read_1al_empty	(fifo_ch1_read_1al_empty 	),
				.fifo_ch1_read_3al_empty	(fifo_ch1_read_3al_empty 	),
				.fifo_ch1_read_empty		(fifo_ch1_read_empty 		),
				.fifo_ch1_write_full		(fifo_ch1_write_full 		),
				.fifo_ch1_write_alfull		(fifo_ch1_write_alfull 		),
			`else 
				.fifo_ch1_read_1al_empty	(),
				.fifo_ch1_read_3al_empty	(),
				.fifo_ch1_read_empty		(),
				.fifo_ch1_write_full		(),
				.fifo_ch1_write_alfull		(),
			`endif
			`ifdef MIPIIO_LANE2_EN
				.fifo_ch2_read_1al_empty	(fifo_ch2_read_1al_empty 	),
				.fifo_ch2_read_3al_empty	(fifo_ch2_read_3al_empty 	),
				.fifo_ch2_read_empty		(fifo_ch2_read_empty 		),
				.fifo_ch2_write_full		(fifo_ch2_write_full 		),
				.fifo_ch2_write_alfull		(fifo_ch2_write_alfull 		),
			`else 
				.fifo_ch2_read_1al_empty	(),
				.fifo_ch2_read_3al_empty	(),
				.fifo_ch2_read_empty		(),
				.fifo_ch2_write_full		(),
				.fifo_ch2_write_alfull		(),
			`endif
			`ifdef MIPIIO_LANE3_EN
				.fifo_ch3_read_1al_empty	(fifo_ch3_read_1al_empty 	),
				.fifo_ch3_read_3al_empty	(fifo_ch3_read_3al_empty 	),
				.fifo_ch3_read_empty		(fifo_ch3_read_empty 		),
				.fifo_ch3_write_full		(fifo_ch3_write_full 		),
				.fifo_ch3_write_alfull		(fifo_ch3_write_alfull 		),
			`else 
				.fifo_ch2_read_1al_empty	(),
				.fifo_ch2_read_3al_empty	(),
				.fifo_ch2_read_empty		(),
				.fifo_ch2_write_full		(),
				.fifo_ch2_write_alfull		(),
			`endif
		`else
        	.fifo_ch0_read_1al_empty	(),
			.fifo_ch1_read_1al_empty	(),
			.fifo_ch2_read_1al_empty	(),
			.fifo_ch3_read_1al_empty	(),
			.fifo_ch0_read_3al_empty	(),
			.fifo_ch1_read_3al_empty	(),
			.fifo_ch2_read_3al_empty	(),
			.fifo_ch3_read_3al_empty	(),
			.fifo_ch0_read_empty		(),
			.fifo_ch1_read_empty		(),
			.fifo_ch2_read_empty		(),
			.fifo_ch3_read_empty		(),
			.fifo_ch0_write_full		(),
			.fifo_ch1_write_full		(),
			.fifo_ch2_write_full		(),
			.fifo_ch3_write_full		(),
			.fifo_ch0_write_alfull		(),
			.fifo_ch1_write_alfull		(),
			.fifo_ch2_write_alfull		(),
			.fifo_ch3_write_alfull		(),
		`endif
	
		`ifdef LVDS_MODE
			.sgcc_lvds_mode 			(1'b1 						),
		    .lvds_clk_to_gpll			(lvds_clk_to_gpll 			),
		    .lvds_clk_from_gpll 		(lvds_clk_from_gpll 		),
		`else
			.sgcc_lvds_mode 			(1'b0 						),
		    .lvds_clk_to_gpll			(),
		    .lvds_clk_from_gpll 		(							),
		`endif
	
			.hsrx_clk_detect 			(hsrx_clk_detect 			),
			.hsrx_byteclk_to_fabric		(hsrx_byteclk_to_fabric 	),
	
		`ifndef LVDS_MODE
			`ifdef MIPIIO_LANE0_EN
				.lprx_ch0_cd_dn 			(lprx_ch0_cd_dn 			),
				.lprx_ch0_cd_dp 			(lprx_ch0_cd_dp 			),
				.lprx_ch0_dn 				(lprx_ch0_dn				),
				.lprx_ch0_dp 				(lprx_ch0_dp				),
				.lprx_ch0_en				(lprx_ch0_en 				),
				.lptx_ch0_dn				(lptx_ch0_dn 				),
			    .lptx_ch0_dp				(lptx_ch0_dp 				),
			    .lptx_ch0_en				(lptx_ch0_en 				),
			`else 
				.lprx_ch0_cd_dn 			(),
				.lprx_ch0_cd_dp 			(),
				.lprx_ch0_dn 				(),
				.lprx_ch0_dp 				(),
				.lprx_ch0_en				(1'b0),
				.lptx_ch0_dn				(1'b0 		 				),
				.lptx_ch0_dp				(1'b0 		 				),
				.lptx_ch0_en				(1'b0 		 				),
			`endif
			`ifdef MIPIIO_LANE1_EN
				.lprx_ch1_cd_dn 			(lprx_ch1_cd_dn 			),
				.lprx_ch1_cd_dp 			(lprx_ch1_cd_dp 			),
				.lprx_ch1_dn 				(lprx_ch1_dn				),
				.lprx_ch1_dp 				(lprx_ch1_dp				),
				.lprx_ch1_en				(lprx_ch1_en 				),
			`else 
				.lprx_ch1_cd_dn 			(),
				.lprx_ch1_cd_dp 			(),
				.lprx_ch1_dn 				(),
				.lprx_ch1_dp 				(),
				.lprx_ch1_en				(1'b0 						),
			`endif
			`ifdef MIPIIO_LANE2_EN
				.lprx_ch2_cd_dn 			(lprx_ch2_cd_dn 			),
				.lprx_ch2_cd_dp 			(lprx_ch2_cd_dp 			),
				.lprx_ch2_dn 				(lprx_ch2_dn				),
				.lprx_ch2_dp 				(lprx_ch2_dp				),
				.lprx_ch2_en				(lprx_ch2_en 				),
			`else 
				.lprx_ch2_cd_dn 			(),
				.lprx_ch2_cd_dp 			(),
				.lprx_ch2_dn 				(),
				.lprx_ch2_dp 				(),
				.lprx_ch2_en				(1'b0 		 				),
			`endif
			`ifdef MIPIIO_LANE3_EN
				.lprx_ch3_cd_dn 			(lprx_ch3_cd_dn 			),
				.lprx_ch3_cd_dp 			(lprx_ch3_cd_dp 			),
				.lprx_ch3_dn 				(lprx_ch3_dn				),
				.lprx_ch3_dp 				(lprx_ch3_dp				),
				.lprx_ch3_en				(lprx_ch3_en 				),
			`else 
				.lprx_ch3_cd_dn 			(),
				.lprx_ch3_cd_dp 			(),
				.lprx_ch3_dn 				(),
				.lprx_ch3_dp 				(),
				.lprx_ch3_en				(1'b0 		 				),
			`endif
				.lprx_chc_cd_dn 			(lprx_chc_cd_dn 			),
				.lprx_chc_cd_dp 			(lprx_chc_cd_dp 			),
				.lprx_chc_dn 				(lprx_chc_dn				),
				.lprx_chc_dp 				(lprx_chc_dp				),
		    	.lprx_chc_en				(lprx_chc_en 				),
		`else 
			.lprx_ch0_cd_dn 			(),
			.lprx_ch1_cd_dn 			(),
			.lprx_ch2_cd_dn 			(),
			.lprx_ch3_cd_dn 			(),
			.lprx_chc_cd_dn 			(),
			.lprx_ch0_cd_dp 			(),
			.lprx_ch1_cd_dp 			(),
			.lprx_ch2_cd_dp 			(),
			.lprx_ch3_cd_dp 			(),
			.lprx_chc_cd_dp 			(),
			.lprx_ch0_dn 				(),
			.lprx_ch1_dn 				(),
			.lprx_ch2_dn 				(),
			.lprx_ch3_dn 				(),
			.lprx_chc_dn 				(),
			.lprx_ch0_dp 				(),
			.lprx_ch1_dp 				(),
			.lprx_ch2_dp 				(),
			.lprx_ch3_dp 				(),
			.lprx_chc_dp 				(),
	
			.lprx_ch0_en				(1'b0 		 				),
		    .lprx_ch1_en				(1'b0 		 				),
		    .lprx_ch2_en				(1'b0 		 				),
		    .lprx_ch3_en				(1'b0 		 				),
		    .lprx_chc_en				(1'b0 		 				),
		    .lptx_ch0_dn				(1'b0 		 				),
		    .lptx_ch0_dp				(1'b0 		 				),
		    .lptx_ch0_en				(1'b0 		 				),
		`endif
		`ifdef MIPIIO_LANE0_EN
		    .hsrx_ch0_en				(hsrx_ch0_en 				),
		    .hsrx_ch0_rstn				(hsrx_ch0_rstn 				),
		    .rterm_ch0_en				(rterm_ch0_en				),
		`else 
			.hsrx_ch0_en				(1'b0						),
		    .hsrx_ch0_rstn				(1'b0 						),
		    .rterm_ch0_en				(1'b0						),
		`endif
		`ifdef MIPIIO_LANE1_EN
		    .hsrx_ch1_en				(hsrx_ch1_en 				),
		    .hsrx_ch1_rstn				(hsrx_ch1_rstn 				),
		    .rterm_ch1_en				(rterm_ch1_en				),
		`else 
			.hsrx_ch1_en				(1'b0 						),
		    .hsrx_ch1_rstn				(1'b0 		 				),
		    .rterm_ch1_en				(1'b0 						),
		`endif
		`ifdef MIPIIO_LANE2_EN
		    .hsrx_ch2_en				(hsrx_ch2_en 				),
		    .hsrx_ch2_rstn				(hsrx_ch2_rstn 				),
		    .rterm_ch2_en				(rterm_ch2_en				),
		`else 
			.hsrx_ch2_en				(1'b0 						),
		    .hsrx_ch2_rstn				(1'b0 		 				),
		    .rterm_ch2_en				(1'b0 						),
		`endif
		`ifdef MIPIIO_LANE3_EN
		    .hsrx_ch3_en				(hsrx_ch3_en 				),
		    .hsrx_ch3_rstn				(hsrx_ch3_rstn 				),
		    .rterm_ch3_en				(rterm_ch3_en				),
		`else 
			.hsrx_ch3_en				(1'b0 						),
		    .hsrx_ch3_rstn				(1'b0 		 				),
		    .rterm_ch3_en				(1'b0 						),
		`endif
		    .hsrx_chc_en				(hsrx_chc_en 				),
		    .hsrx_chc_rstn				(hsrx_chc_rstn 				),
		    .rterm_chc_en				(rterm_chc_en				),
	
		`ifdef FIFO_ENABLE
			`ifdef FIFO_WIDTH_16
				.sgcc_byte_16 				(1'b1 						),
				.fifo_read_8bit_enable 		(1'b0 				 		),
			    .fifo_read_16bit_enable 	(fifo_read_16bit_enable 	),
			`else 
				.sgcc_byte_16 				(1'b0 						),
				.fifo_read_8bit_enable 		(fifo_read_8bit_enable 		),
			    .fifo_read_16bit_enable 	(1'b0 					 	),
			`endif
		`else 
			.sgcc_byte_16 				(1'b0 						),
			.fifo_read_8bit_enable 		(1'b0 				 		),
		    .fifo_read_16bit_enable 	(1'b0 					 	),
		`endif
		`ifdef MIPIIO_LANE0_EN
			.fifo_ch0_data_low 			(fifo_ch0_data_low 			),
		`else 
			.fifo_ch0_data_low 			(),
		`endif
		`ifdef MIPIIO_LANE1_EN
		    .fifo_ch1_data_low 			(fifo_ch1_data_low 			),
		`else 
			.fifo_ch1_data_low 			(),
		`endif
		`ifdef MIPIIO_LANE2_EN
		    .fifo_ch2_data_low 			(fifo_ch2_data_low 			),
		`else 
			.fifo_ch2_data_low 			(),
		`endif
		`ifdef MIPIIO_LANE3_EN
		    .fifo_ch3_data_low 			(fifo_ch3_data_low 			),
		`else 
			.fifo_ch3_data_low 			(),
		`endif
    	
    	`ifdef FIFO_ENABLE
			`ifdef FIFO_WIDTH_16
				`ifdef MIPIIO_LANE0_EN
				    .fifo_ch0_data_high			(fifo_ch0_data_high 		),
				`else 
					.fifo_ch0_data_high			(),
				`endif
				`ifdef MIPIIO_LANE1_EN
				    .fifo_ch1_data_high 		(fifo_ch1_data_high 		),
				`else 
					.fifo_ch1_data_high			(),
				`endif
				`ifdef MIPIIO_LANE2_EN
				    .fifo_ch2_data_high 		(fifo_ch2_data_high 		),
				`else 
					.fifo_ch2_data_high			(),
				`endif
				`ifdef MIPIIO_LANE3_EN
				    .fifo_ch3_data_high			(fifo_ch3_data_high 		),
				`else 
					.fifo_ch3_data_high			(),
				`endif
			`else
				.fifo_ch0_data_high			(),
			    .fifo_ch1_data_high 		(),
			    .fifo_ch2_data_high 		(),
			    .fifo_ch3_data_high			(),
			`endif
    	`else 
    		.fifo_ch0_data_high			(),
		    .fifo_ch1_data_high 		(),
		    .fifo_ch2_data_high 		(),
		    .fifo_ch3_data_high			(),
    	`endif
	
		     // Inputs
		`ifdef FIFO_ENABLE
		    .fifo_bypass 				(1'b0 						),
		    .fifo_read_clk 				(fifo_read_clk 				),
		    .fifo_write_enable 			(fifo_write_enable 			),
		    .fifo_read_rstn 			(fifo_read_rstn 			),
		    .fifo_write_rstn 			(fifo_write_rstn 			),
		`else 
			.fifo_bypass 				(1'b1 						),
			.fifo_read_clk 				(1'b0 						),
		    .fifo_write_enable 			(1'b0 						),
		    .fifo_read_rstn 			(1'b0 						),
		    .fifo_write_rstn 			(1'b0 						),
		`endif
    
	`endif
	    .mipi_pd 					(mipi_pd 					),

	    .hsrx_ch0_deskew_enb		(1'b0 						),
	    .hsrx_ch1_deskew_enb		(1'b0 						),
	    .hsrx_ch2_deskew_enb		(1'b0 						),
	    .hsrx_ch3_deskew_enb		(1'b0 						),
	    .hsrx_chc_deskew_enb		(1'b0 						),
	    .hsrx_ch3_deskew_ctl		(I_data_lane3_idelay		),
	    .hsrx_ch1_deskew_ctl		(I_data_lane1_idelay		),
	    .hsrx_ch2_deskew_ctl		(I_data_lane2_idelay		),
	    .hsrx_ch0_deskew_ctl		(I_data_lane0_idelay 	    ),
	    .hsrx_chc_deskew_ctl		(I_clk_lane_idelay 		    ),
		.hsrx_ch0_eqrn				(2'b11 						),
        .hsrx_ch1_eqrn				(2'b11 						),
        .hsrx_ch2_eqrn				(2'b11 						),
        .hsrx_ch3_eqrn				(2'b11 						),
        .hsrx_chc_eqrn				(2'b11 						),
		.hsrx_ch0_eqcn				(1'b1 						),
        .hsrx_ch1_eqcn				(1'b1 						),
		.hsrx_ch2_eqcn				(1'b1 						),
        .hsrx_ch3_eqcn				(1'b1 						),
        .hsrx_chc_eqcn				(1'b1 						),
		.hsrx_ch0_att_ctl			(4'b0100					),
		.hsrx_ch1_att_ctl			(4'b0100 					),
		.hsrx_ch2_att_ctl			(4'b0100 					),
		.hsrx_ch3_att_ctl			(4'b0100 					),
		.hsrx_chc_att_ctl			(4'b0100 					),

		// Inout
	`ifdef MIPIIO_LANE0_EN
	    .dn_0 						(dn_0 						),
	    .dp_0 						(dp_0 						),
	`else 
		.dn_0 						(),
		.dp_0 						(),
	`endif
	`ifdef MIPIIO_LANE1_EN
	    .dn_1 						(dn_1 						),
	    .dp_1 						(dp_1 						),
	`else 
		.dn_1 						(),
		.dp_1 						(),
	`endif
	`ifdef MIPIIO_LANE2_EN
	    .dn_2 						(dn_2 						),
	    .dp_2 						(dp_2 						),
	`else 
		.dn_2 						(),
		.dp_2 						(),
	`endif
	`ifdef MIPIIO_LANE3_EN
	    .dn_3 						(dn_3 						),
	    .dp_3 						(dp_3 						),
	`else 
		.dn_3 						(),
		.dp_3 						(),
	`endif
	    .cn							(cn 						),
	    .cp							(cp 						)
	);
endmodule