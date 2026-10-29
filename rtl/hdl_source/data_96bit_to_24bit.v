


module data_96bit_to_24bit(
    
    input  wire   I_rst_n,
    
    input  wire   I_hs_rx_clk,
    input  wire   I_rbg888_frame_start,
    input  wire   I_rbg888_frame_end,
    input  wire   I_rbg888_valid,
    input  wire[95:0]   I_rbg888_data,

    input  wire   I_hdmi_clk,
    output wire    O_video_rd_en,
    output wire    O_video_frame_start,
    output reg [23:0]   O_video_data

);


    reg         S_fifo_rst; 
    wire        S_fifo_rd_en;  
    wire[95:0]  S_fifo_rd_data;
    wire        S_video_frame_start;  
    wire[8:0]   S_fifo_wr_num;       //synthesis keep
    reg[1:0]    S_fifo_rd_cnt;
    // reg[2:0]    S_fifo_rd_cnt_1d;
    reg[7:0]    S_fifo_rst_cnt;

    assign S_video_frame_start = I_rbg888_frame_start;
    assign O_video_frame_start = S_video_frame_start;

    always @(posedge I_hs_rx_clk or negedge I_rst_n) begin
        if (!I_rst_n) 
            S_fifo_rst <= 1'b0;
        else 
            if(S_video_frame_start)
                S_fifo_rst <= 1'b1;
                else if(S_fifo_rst_cnt == 'd10)
                    S_fifo_rst <= 1'b0;
                else
                    S_fifo_rst <= S_fifo_rst;
    end

    always @(posedge I_hs_rx_clk) begin
        if(S_fifo_rst)
            S_fifo_rst_cnt <= S_fifo_rst_cnt + 'd1;
        else
            S_fifo_rst_cnt <= 'd0;
    end

    w96_d512_fifo U_w96_d512_fifo(
        .rst        ( S_fifo_rst         ),   

        .clkw       ( I_hs_rx_clk           ),     
        .we         ( I_rbg888_valid ),
        .di         ( I_rbg888_data  ),
        .wrusedw    ( S_fifo_wr_num       ),
        .afull      (),
        .full_flag  (),

        .clkr       ( I_hdmi_clk         ),
        .re         ( S_fifo_rd_en       ), 
        .dout       ( S_fifo_rd_data     ),  
        .rdusedw    (),
        .valid      (), 
        .empty_flag ( S_fifo_emtpy       ),
        .aempty     ()
    );

    always @(posedge I_hdmi_clk) begin
        S_fifo_rd_cnt <= S_fifo_rd_cnt + 'd1;
    end

    assign S_fifo_rd_en = (S_fifo_rd_cnt == 'd0) ? 1'b1 : 1'b0;
    assign O_video_rd_en = S_fifo_rd_en;//1'b1;

    // always @(posedge I_dfi_clk) begin
    //     S_video_rd_en_1d  <= I_video_rd_en;
    //     S_fifo_rd_cnt_1d  <= S_fifo_rd_cnt;
    //     S_fifo_rd_data_1d <= S_fifo_rd_data;
    // end

    always @(posedge I_hdmi_clk) begin
        if(S_fifo_rd_en)
            begin
                case(S_fifo_rd_cnt)
                    'd0: O_video_data <= S_fifo_rd_data[95:72];
                    'd1: O_video_data <= S_fifo_rd_data[71:48];
                    'd2: O_video_data <= S_fifo_rd_data[47:24];
                    'd3: O_video_data <= S_fifo_rd_data[23:0];
                endcase
            end
        else
            O_video_data <= 'd0;
    end    

endmodule