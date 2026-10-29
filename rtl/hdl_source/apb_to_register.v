


module apd_to_register (
    input wire        I_clk,
    input wire        I_rst_n,

    input wire[19:0]  I_apb_paddr,
    input wire        I_apb_psel,
    input wire        I_apb_penable,
    input wire        I_apb_pwrite,
    input wire[31:0]  I_apb_pwdata,
    output wire       O_apb_pready,
    output reg[31:0]  O_apb_prdata,
    output wire       O_apb_pslverror,
    output wire       O_apb_int,

    input wire[31:0]  I_pl_version,
    input wire[9:0]	I_ts_tempture,
    output wire[19:0] O_awb_r_gain,
    output wire[19:0] O_awb_g_gain,
    output wire[19:0] O_awb_b_gain,
    output wire[8:0]  O_data_lane3_idelay,
    output wire[8:0]  O_data_lane1_idelay,
    output wire[8:0]  O_data_lane2_idelay,
    output wire[8:0]  O_data_lane0_idelay,
    output wire[8:0]  O_clk_lane_idelay,
    output wire[9:0]  O_camera_black_level,
    output wire       O_hdmi_dp159_oe,
    output wire       O_hdmi_tpg_en
    
);


    wire      S_apb_wr_trig;
    reg       S_apb_wr_trig_1d;
    reg[19:0] S_apb_wr_addr;
    reg[31:0] S_apb_wr_data;
    
    wire      S_apb_rd_trig;

    reg[31:0] S_reg_0;
    reg[31:0] S_reg_1;
    reg[31:0] S_reg_2;
    reg[31:0] S_reg_3;
    reg[31:0] S_reg_4;
    reg[31:0] S_reg_5;
    reg[31:0] S_reg_6;
    reg[31:0] S_reg_7;
	reg[31:0] S_reg_8;
	reg[31:0] S_reg_9;
	reg[31:0] S_reg_10;
	reg[31:0] S_reg_11;
    wire[31:0] S_reg_12;

    assign O_apb_pready = 1'b1;
    assign O_apb_pslverror = 1'b0;
    assign O_apb_int = 1'b0;

    assign S_apb_wr_trig = I_apb_penable && I_apb_psel && I_apb_pwrite && (I_apb_paddr >= 20'h10000) ? 1'b1 : 1'b0;

    always @(posedge I_clk) begin
        S_apb_wr_trig_1d <= S_apb_wr_trig;
    end

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            begin
                S_apb_wr_addr <= 'd0;
                S_apb_wr_data <= 'd0;
            end
        else
            if(S_apb_wr_trig)
                begin
                    S_apb_wr_addr <= I_apb_paddr;
                    S_apb_wr_data <= I_apb_pwdata;
                end
            else
                begin
                    S_apb_wr_addr <= S_apb_wr_addr;
                    S_apb_wr_data <= S_apb_wr_data;
                end
    end



    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            begin
                S_reg_0  <= 'd0;
                S_reg_1  <= 'd0;
                S_reg_2  <= 'd0;
                S_reg_3  <= 'd0;
                S_reg_4  <= 'd0;
                S_reg_5  <= 'd0;
                S_reg_6  <= 'd0;
                S_reg_7  <= 'd0;
				S_reg_8  <= 'd0;
				S_reg_9  <= 'd0;
				S_reg_10 <= 'd0;
				S_reg_11 <= 'd0;
            end
        else
            begin
                if(S_apb_wr_trig_1d)
                    begin
                        case(S_apb_wr_addr[7:0])
                            8'h00: S_reg_0  <= S_apb_wr_data;
                            8'h04: S_reg_1  <= S_apb_wr_data;
                            8'h08: S_reg_2  <= S_apb_wr_data;
                            8'h0C: S_reg_3  <= S_apb_wr_data;
                            8'h10: S_reg_4  <= S_apb_wr_data;
                            8'h14: S_reg_5  <= S_apb_wr_data;
                            8'h18: S_reg_6  <= S_apb_wr_data;
                            8'h1C: S_reg_7  <= S_apb_wr_data;
                            8'h20: S_reg_8  <= S_apb_wr_data;
                            8'h24: S_reg_9  <= S_apb_wr_data;
                            8'h28: S_reg_10 <= S_apb_wr_data;
							8'h2c: S_reg_11 <= S_apb_wr_data;
                        endcase
                    end
                else
                    begin
                        S_reg_0  <= S_reg_0;
                        S_reg_1  <= S_reg_1;
                        S_reg_2  <= S_reg_2;
                        S_reg_3  <= S_reg_3;
                        S_reg_4  <= S_reg_4;
                        S_reg_5  <= S_reg_5;
                        S_reg_6  <= S_reg_6;
                        S_reg_7  <= S_reg_7;
                        S_reg_8  <= S_reg_8 ;
                        S_reg_9  <= S_reg_9 ;
                        S_reg_10 <= S_reg_10;
						S_reg_11 <= S_reg_11;
                    end
            end
    end

    assign S_apb_rd_trig = (~I_apb_penable) && I_apb_psel && (~I_apb_pwrite) && (I_apb_paddr >= 20'h10000) ? 1'b1 : 1'b0;

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            O_apb_prdata <= 'd0;
        else
            begin
                if(S_apb_rd_trig)
                    begin
                        case(I_apb_paddr[7:0])
                            8'h00: O_apb_prdata <= I_pl_version;
                            8'h04: O_apb_prdata <= S_reg_1;
                            8'h08: O_apb_prdata <= S_reg_2;
                            8'h0C: O_apb_prdata <= S_reg_3;
                            8'h10: O_apb_prdata <= S_reg_4;
                            8'h14: O_apb_prdata <= S_reg_5;
                            8'h18: O_apb_prdata <= S_reg_6;
                            8'h1C: O_apb_prdata <= S_reg_7;
                            8'h20: O_apb_prdata <= S_reg_8;
                            8'h24: O_apb_prdata <= S_reg_9;
                            8'h28: O_apb_prdata <= S_reg_10;
							8'h2c: O_apb_prdata <= S_reg_11;
                            8'h30: O_apb_prdata <= S_reg_12;
                        endcase
                    end
                else
                    O_apb_prdata <= O_apb_prdata;
            end
    end 


    assign O_awb_r_gain        = S_reg_1[19:0];
    assign O_awb_g_gain        = S_reg_2[19:0];
    assign O_awb_b_gain        = S_reg_3[19:0];
	assign O_data_lane3_idelay = S_reg_4[8:0];
	assign O_data_lane1_idelay = S_reg_5[8:0];  
	assign O_data_lane2_idelay = S_reg_6[8:0];  
	assign O_data_lane0_idelay = S_reg_7[8:0];  
	assign O_clk_lane_idelay   = S_reg_8[8:0];  
    assign O_camera_black_level= S_reg_9[8:0];  
	assign O_hdmi_dp159_oe     = S_reg_10[0];
	assign O_hdmi_tpg_en       = S_reg_11[0];
    
    assign S_reg_12[9:0]	   = I_ts_tempture;

endmodule