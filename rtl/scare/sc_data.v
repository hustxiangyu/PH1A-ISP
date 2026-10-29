module sc_data(
	input wire clk,
    input wire rst,
    input wire [10:0] xpix,
    input wire [10:0] ypix,
    input wire vtc_de,
    input wire i_sc_de,
    input wire [23:0] i_sc_di,
    output wire o_sc_de,
    output wire [23:0] o_sc_dout
 );
 
reg [10:0] r_cnt;
reg [10:0] h_cnt;
always @(posedge clk) begin
	if(rst) begin
    	r_cnt <= 1'b0;
        h_cnt <= 1'b0;
    end else begin 
    	if (r_cnt < 11'd1920)
        	if (vtc_de)
        		r_cnt <= r_cnt + 1'b1;
        	else
            	r_cnt <= r_cnt;
        else
        	r_cnt <= 1'b0;
        if (h_cnt < 11'd1080)
        	if (r_cnt == 11'd1920)
            	h_cnt <= h_cnt + 1'b1;
            else 
            	h_cnt <= h_cnt;
        else
        	h_cnt <= 1'b0;
    end
end
assign o_sc_de    = r_cnt < xpix && h_cnt < ypix ? i_sc_de : 1'd0;
assign o_sc_dout = r_cnt < xpix && h_cnt < ypix ? i_sc_di : 1'b0;

endmodule
