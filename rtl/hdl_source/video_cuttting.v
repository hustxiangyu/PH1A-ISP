


module video_cutting (
    input wire       I_clk,
    input wire       I_rst_n,

    input wire       I_raw8_frame_start,
    input wire       I_raw8_frame_end,
    input wire       I_raw8_valid,
    input wire[31:0] I_raw8_data,

    output reg       O_raw8_frame_start,
    output reg       O_raw8_frame_end,
//    output reg 		 O_raw8_vsync0,
//    output reg		 O_raw8_hsync0,
    output reg       O_raw8_valid,
    output reg[31:0] O_raw8_data
);


    reg[11:0] S_col_cnt;
    reg[11:0] S_line_cnt;//synthesis keep
    reg       S_raw8_valid_1d;
    wire      S_raw8_valid_n_edge;
    reg       S_line_en;

    always @(posedge I_clk) begin
        S_raw8_valid_1d <= I_raw8_valid;
    end

    assign S_raw8_valid_n_edge = ~I_raw8_valid & S_raw8_valid_1d;

//	always @(posedge I_clk) begin
//    	if(!I_rst_n)
//        	O_raw8_hsync0 <= 1'b0;
//    	else	
//            if(S_raw8_valid_n_edge) 
//        		O_raw8_hsync0 <= 1'b1;
//        	else 
//        		O_raw8_hsync0 <= 1'b0;
//    end

    always @(posedge I_clk) begin
        if(I_raw8_valid)
            S_col_cnt <= S_col_cnt + 'd1;
        else
            S_col_cnt <= 'd0;
    end

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_line_cnt <= 'd0;
        else
            if(I_raw8_frame_start)
                S_line_cnt <= 'd0;
            else if(S_raw8_valid_n_edge)
                S_line_cnt <= S_line_cnt + 'd1;
            else
                S_line_cnt <= S_line_cnt;
    end


    always @(posedge I_clk) begin
        if(S_line_cnt >= 'd0 && S_line_cnt <= 'd1079)//if(S_line_cnt >= 'd5 && S_line_cnt <= 'd2166)
            S_line_en <= 1'b1;
        else
            S_line_en <= 1'b0; 
    end 

    always @(posedge I_clk) begin
        if(I_raw8_valid && S_col_cnt >= 'd0 && S_col_cnt <= 'd479 && S_line_en)
            begin
//            if(S_line_cnt >= 'd0 && S_line_cnt<='d540)
//            begin
                O_raw8_valid <= 1'b1;
                O_raw8_data  <= I_raw8_data;
//                O_raw8_data[31:24] <= I_raw8_data[31:24] - 8'd25;
//                O_raw8_data[23:16] <= I_raw8_data[23:16] - 8'd25;
//                O_raw8_data[15:8]  <= I_raw8_data[15:8]  - 8'd25;
//                O_raw8_data[7:0]   <= I_raw8_data[7:0]   - 8'd25;
//				O_raw8_data  <= {8'd127,8'd127,8'd127,8'd127};
//            end
//            else
//            begin
//            	O_raw8_valid <= 1'b1;
//                O_raw8_data  <= 0;
//            end
        end
        else    
            begin
                O_raw8_valid <= 1'b0;
                O_raw8_data  <= 'd0;
            end
    end

    always @(posedge I_clk) begin
        O_raw8_frame_start <= I_raw8_frame_start;
        O_raw8_frame_end   <= I_raw8_frame_end;
    end

    
endmodule