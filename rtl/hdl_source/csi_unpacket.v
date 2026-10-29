


module csi_unpacket (
    input wire       I_clk,
    input wire       I_rst_n,

    input wire       I_hs_valid,
    input wire[31:0] I_hs_data,

    output reg       O_csi_frame_start,
    output reg       O_csi_frame_end,
    output reg 		 O_csi_rx_vsync0,
    output reg		 O_csi_rx_hsync0,
    output reg       O_csi_valid,
    output reg[31:0] O_csi_data
);


    localparam FRAME_DATA_DT  = 8'h2B;   ///RAW10
    localparam FRAME_START_DT = 8'h00;
    localparam FRAME_END_DT   = 8'h01;

    reg        S_hs_valid_1d;          
    reg[31:0]  S_hs_data_1d;               
    wire       S_packet_head_en;       
    wire[31:0] S_packet_head_data;     
    reg[15:0]  S_data_length;          
    reg        S_data_en;              
    reg[15:0]  S_data_en_cnt;  
    
    reg		   S_start_flag;      
    
    reg[31:0]  S_linecnt;//synthesis keep  

    always @(posedge I_clk) begin
        S_hs_valid_1d        <= I_hs_valid;
        S_hs_data_1d         <= I_hs_data;
    end

    assign S_packet_head_en = ~S_hs_valid_1d & I_hs_valid;


    assign S_packet_head_data = S_packet_head_en ? I_hs_data : 'd0;


    always @(posedge I_clk) begin
        if(S_packet_head_en && S_packet_head_data[31:24] == FRAME_START_DT)
            O_csi_frame_start <= 1'b1;
        else    
            O_csi_frame_start <= 1'b0;
    end


    always @(posedge I_clk) begin
        if(S_packet_head_en && S_packet_head_data[31:24] == FRAME_END_DT)
            O_csi_frame_end <= 1'b1;
        else    
            O_csi_frame_end <= 1'b0;
    end
     
    always @(posedge I_clk) begin
    	   if(O_csi_frame_start)
                S_linecnt <= 'd0;
            else if(S_packet_head_en && S_packet_head_data[31:24] == FRAME_DATA_DT)
                S_linecnt <= S_linecnt + 'd1;
            else
                S_linecnt <= S_linecnt;
    end
     
    always @(posedge I_clk) begin
    	if(!I_rst_n)
        	S_start_flag <= 1'b0;
    	else
        	if(O_csi_frame_start)
        		S_start_flag <= 1'b1;
        	else
                if(S_start_flag && S_packet_head_en) begin
        			O_csi_rx_vsync0 <= 1'b1;
                    S_start_flag <= 1'b0;
                end
                else begin
        			S_start_flag <= S_start_flag;
                    O_csi_rx_vsync0 <= 1'b0;
                end
    end


    always @(posedge I_clk) begin 
        if(I_hs_valid)
            begin
                if(S_packet_head_en && S_packet_head_data[31:24] == FRAME_DATA_DT) begin
                    S_data_length <= {S_packet_head_data[15:8],S_packet_head_data[23:16]} >> 2;
                    O_csi_rx_hsync0<=1'b1;
                end
                else begin
                	O_csi_rx_hsync0<=1'b0;    
                    S_data_length <= S_data_length;
                end
            end
        else    
            S_data_length <= 'd0;
    end

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_data_en <= 1'b0;
        else    
            if(S_packet_head_en && S_packet_head_data[31:24] == FRAME_DATA_DT)
                S_data_en <= 1'b1;
            else if(S_data_en_cnt == S_data_length-1)
                S_data_en <= 1'b0;
            else    
                S_data_en <= S_data_en;
    end

    always @(posedge I_clk) begin
        if(S_data_en)
            S_data_en_cnt <= S_data_en_cnt + 'd1;
        else
            S_data_en_cnt <= 'd0;
    end


    always @(posedge I_clk) begin
        if(S_data_en)
            begin
                O_csi_valid <= 1'b1;
                O_csi_data  <= I_hs_data;
            end
        else
            begin
                O_csi_valid <= 1'b0;
                O_csi_data  <= 'd0;
            end
    end

    
endmodule