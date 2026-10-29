

module hs_detect (
    input wire     I_clk,
    input wire     I_rst_n,

    input wire     I_lp_p,
    input wire     I_lp_n,

    output reg     O_hs_en
);


    localparam  IDLE      = 3'd0;
    localparam  LP_11     = 3'd1;
    localparam  LP_01     = 3'd2;
    localparam  LP_00     = 3'd3;
    localparam  HS_ACTIVE = 3'd4;


    reg[2:0]  S_lp_state;
    reg       S_mipi_lp_p_1d;
    reg       S_mipi_lp_p_2d;
    reg       S_mipi_lp_p_3d;
    reg       S_mipi_lp_n_1d;
    reg       S_mipi_lp_n_2d;
    reg       S_mipi_lp_n_3d;
    wire[1:0] S_mipi_lp_data;



    always @(posedge I_clk) begin
        S_mipi_lp_p_1d <= I_lp_p;
        S_mipi_lp_p_2d <= S_mipi_lp_p_1d;
        S_mipi_lp_p_3d <= S_mipi_lp_p_2d;

        S_mipi_lp_n_1d <= I_lp_n;
        S_mipi_lp_n_2d <= S_mipi_lp_n_1d;
        S_mipi_lp_n_3d <= S_mipi_lp_n_2d;
    end

    assign S_mipi_lp_data = {S_mipi_lp_p_3d,S_mipi_lp_n_3d};

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_lp_state <= IDLE;
        else
            case(S_lp_state)
                IDLE:
                           if(S_mipi_lp_data == 2'b11)
                               S_lp_state <= LP_11;
                           else
                               S_lp_state <= IDLE;
                LP_11:   
                           if(S_mipi_lp_data == 2'b01)
                               S_lp_state <= LP_01; 
                           else if(S_mipi_lp_data == 2'b11)
                               S_lp_state <= LP_11; 
                           else
                               S_lp_state <= IDLE; 
                LP_01:   
                           if(S_mipi_lp_data == 2'b00)
                               S_lp_state <= LP_00;
                           else if(S_mipi_lp_data == 2'b01)
                               S_lp_state <= LP_01;
                           else
                               S_lp_state <= IDLE; 
                LP_00:   
                           if(S_mipi_lp_data == 2'b00)
                               S_lp_state <= HS_ACTIVE;
                           else
                               S_lp_state <= IDLE;
                HS_ACTIVE:
                           if(S_mipi_lp_data == 2'b00)
                               S_lp_state <= HS_ACTIVE;
                           else
                               S_lp_state <= IDLE;
                default:
                            S_lp_state <= IDLE;
            endcase
    end

    always @(posedge I_clk) begin
        if(S_lp_state == HS_ACTIVE)
            O_hs_en <= 1'b1;
        else
            O_hs_en <= 1'b0;
    end
    
endmodule