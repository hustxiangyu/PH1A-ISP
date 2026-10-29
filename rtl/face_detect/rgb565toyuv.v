module rgb_to_ycbcr(
 input clk,
 input rst_n,
 input [23 : 0] rgb888,
 
 input i_h_sync,
 input i_v_sync,
 input i_data_en,
 
 output o_y_clk,
 
 output reg [7 : 0] o_y_8b,
 output reg [7 : 0]o_cb_8b,
 output reg [7 : 0]o_cr_8b,
        
 output reg o_h_sync,
 output reg o_v_sync, 
 output reg o_data_en 
);


assign o_y_clk = clk;

reg [15:0] R1;
reg [15:0] R2;
reg [15:0] R3;
reg [15:0] G1;
reg [15:0] G2;
reg [15:0] G3;
reg [15:0] B1;
reg [15:0] B2;
reg [15:0] B3;
reg [15:0] Y1 ;
reg [15:0] Cb1;
reg [15:0] Cr1;

reg [7:0] Y2 ;
reg [7:0] Cb2;
reg [7:0] Cr2;

//clk 1
//---------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        {R1,G1,B1} <= {16'd0, 16'd0, 16'd0};
        {R2,G2,B2} <= {16'd0, 16'd0, 16'd0};
        {R3,G3,B3} <= {16'd0, 16'd0, 16'd0};
    end
    else begin
        {R1,G1,B1} <= { {rgb888[23:16] * 16'd77},  {rgb888[15:8] * 16'd150}, {rgb888[7:0] * 16'd29 } };
        {R2,G2,B2} <= { {rgb888[23:16] * 16'd43},  {rgb888[15:8] * 16'd85},  {rgb888[7:0] * 16'd128} };
        {R3,G3,B3} <= { {rgb888[23:16] * 16'd128}, {rgb888[15:8] * 16'd107}, {rgb888[7:0] * 16'd21 } };
    end
end

//clk 2
//---------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        Y1  <= 16'd0;
        Cb1 <= 16'd0;
        Cr1 <= 16'd0;
    end
    else begin
        Y1  <= R1 + G1 + B1+7'd30;
        Cb1 <= B2 - R2 - G2 + 16'd32768; //128扩大256倍
        Cr1 <= R3 - G3 - B3 + 16'd32768-3'd9; //128扩大256倍
    end
end

//clk 3，除以256即右移8位，即取高8位
//---------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        Y2  <= 8'd0;
        Cb2 <= 8'd0;
        Cr2 <= 8'd0;
    end
    else begin
        Y2  <= Y1[15:8];  
        Cb2 <= Cb1[15:8];
        Cr2 <= Cr1[15:8];
    end
end

//assign o_y_8b = Y2; //只取Y分量给RGB565格式
//assign o_cb_8b = Cb2;
//assign o_cr_8b = Cr2;

always@(posedge clk)begin
	o_y_8b  <= Y2; 
    o_cb_8b <= Cb2;
    o_cr_8b <= Cr2;
end

//==========================================================================
//==    信号同步
//==========================================================================
reg [2:0] RGB_de_r	 ;
reg [2:0] RGB_hsync_r;
reg [2:0] RGB_vsync_r;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        RGB_de_r    <= 3'b0;
        RGB_hsync_r <= 3'b0;
        RGB_vsync_r <= 3'b0;
    end
    else begin  
        RGB_de_r    <= {RGB_de_r[1:0],    i_data_en};
        RGB_hsync_r <= {RGB_hsync_r[1:0], i_h_sync};
        RGB_vsync_r <= {RGB_vsync_r[1:0], i_v_sync};
    end
end

//assign o_data_en = RGB_de_r	  [2];
//assign o_h_sync  = RGB_hsync_r[2];
//assign o_v_sync  = RGB_vsync_r[2];

always@(posedge clk)begin
	o_data_en <= RGB_de_r	[2]; 
    o_h_sync  <= RGB_hsync_r[2];   
    o_v_sync  <= RGB_vsync_r[2];   
end

endmodule