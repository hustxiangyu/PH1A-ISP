module sc_control(
    input wire clk,
	input wire vs,
    input wire rst_n,
    input wire sc_key_up,
    input wire sc_key_down,
    input wire wid_up,
    input wire wid_down,
    input wire hei_up,
    input wire hei_down,
    input wire sc_open,
    output reg sc_en,
    output reg [10:0] xpix,
    output reg [10:0] ypix,
    output reg [7:0]  xdiv,
    output reg [7:0]  ydiv,
    output reg change
 );
 
reg vs_r,up_r,down_r,wup_r,wdown_r,hup_r,hdown_r;
reg work_up,work_down,w_up,w_down,h_up,h_down;
wire vs_neg,key_reg_up,key_reg_down,wup_reg,wdo_reg,hup_reg,hdo_reg;
 
always @(posedge clk) begin
 	vs_r <= vs;
    up_r <= sc_key_up;
    down_r <= sc_key_down;
    wup_r <= wid_up;
    wdown_r <= wid_down;
    hup_r <= hei_up;
    hdown_r <= hei_down;
end

assign vs_neg = !vs && vs_r;
assign key_neg_up = sc_key_up && !up_r;
assign key_neg_down = sc_key_down && !down_r;
assign wup_reg = !wid_up && wup_r;
assign wdo_reg = !wid_down && wdown_r;
assign hup_reg = !hei_up && hup_r;
assign hdo_reg = !hei_down && hdown_r;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
    	work_up <= 1'b0;
        work_down <= 1'b0;
        w_up <= 1'b0;
        w_down <= 1'b0;
        h_up <= 1'b0;
        h_down <= 1'b0;
    end else begin
    	if (key_neg_up)
        	work_up <= 1'b1;
        else if (key_neg_down)
        	work_down <= 1'b1;
        else if (wup_reg)
        	w_up <= 1'b1;
        else if (wdo_reg)
        	w_down <= 1'b1;
        else if (hup_reg)
        	h_up <= 1'b1;
        else if (hdo_reg) 
        	h_down <= 1'b1;
        else if (change) begin
        	work_up <= 1'b0;
        	work_down <= 1'b0;
        	w_up <= 1'b0;
        	w_down <= 1'b0;
        	h_up <= 1'b0;
        	h_down <= 1'b0;
        end else begin
        	work_up <= work_up;
            work_down <= work_down;
            w_up <= w_up;
        	w_down <= w_down;
        	h_up <= h_up;
        	h_down <= h_down;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
    	change <= 1'b0;
        xpix <= 11'd960;
        ypix <= 11'd540;
    end else begin
    	if (vs_neg && work_down) begin
        	change <= 1'b1;
            if (xpix > 11'd672 && ypix > 11'd378) begin
            	xpix <= xpix - 11'd96;
                ypix <= ypix - 11'd54;
            end else begin
            	xpix <= xpix;
                ypix <= ypix;
            end
        end else if (vs_neg && work_up) begin
        	change <= 1'b1;
            if (xpix < 11'd1920 && ypix < 11'd1080) begin
            	xpix <= xpix + 11'd96;
                ypix <= ypix + 11'd54;
            end else begin
            	xpix <= xpix;
                ypix <= ypix;
            end
        end else if (vs_neg && w_up) begin
        	change <= 1'b1;
            if (xpix < 11'd1920) begin
            	xpix <= xpix + 11'd96;
            end else begin
            	xpix <= xpix;
            end
        end else if (vs_neg && w_down) begin
        	change <= 1'b1;
            if (xpix > 11'd672) begin
            	xpix <= xpix - 11'd96;
            end else begin
            	xpix <= xpix;
            end
        end else if (vs_neg && h_up) begin
        	change <= 1'b1;
            if (ypix < 11'd1080) begin
            	ypix <= ypix + 11'd54;
            end else begin
            	ypix <= ypix;
            end
        end else if (vs_neg && h_down) begin
        	change <= 1'b1;
            if (ypix > 11'd378) begin
            	ypix <= ypix - 11'd54;
            end else begin
            	ypix <= ypix;
            end
        end else begin
        	change <= 1'b0;
            xpix <= xpix;
            ypix <= ypix;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
    	sc_en <= 1'b0;
    end else if (vs_neg) begin
    	sc_en <= sc_open;
	end else begin
    	sc_en <= sc_en;
    end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
    	xdiv <= 8'd1;
        ydiv <= 8'd1;
    end else if (xpix <= 672) begin
    	xdiv <= 8'd1;
        ydiv <= 8'd1;
    end else begin
    	xdiv <= 8'd2;
        ydiv <= 8'd2;
    end 
end
endmodule
