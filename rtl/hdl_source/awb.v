//  by CrazyBird
module awb
(
    input  wire                 I_clk             ,
    input  wire                 I_rst_n           ,
    
    input  wire     [ 7:0]      I_red_gain        ,
    input  wire     [ 7:0]      I_green_gain      ,
    input  wire     [ 7:0]      I_blue_gain       ,
    
    input  wire                 I_awb_vs      ,
    input  wire                 I_awb_hs      ,
    input  wire                 I_awb_de      ,
    input  wire     [23:0]      I_awb_rgb     ,
    
    output reg                  O_awb_vs     ,
    output reg                  O_awb_hs     ,
    output reg                  O_awb_de     ,
    output reg      [23:0]      O_awb_rgb    
);
//----------------------------------------------------------------------
reg                             I_awb_vs_dly;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
        I_awb_vs_dly <= 1'b0;
    else
        I_awb_vs_dly <= I_awb_vs;
end

wire                            lcd_vs_neg;
assign lcd_vs_neg = I_awb_vs_dly & ~I_awb_vs;

//	Hold up to 1920*1080. 
reg             [28:0]          acc_red_data_tmp;
reg             [28:0]          acc_green_data_tmp;
reg             [28:0]          acc_blue_data_tmp;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
    begin
        acc_red_data_tmp   <= 29'b0;
        acc_green_data_tmp <= 29'b0;
        acc_blue_data_tmp  <= 29'b0;
    end
    else
    begin
        if(lcd_vs_neg == 1'b1)
        begin
            acc_red_data_tmp   <= 29'b0;
            acc_green_data_tmp <= 29'b0;
            acc_blue_data_tmp  <= 29'b0;
        end
	  
	  //	Accumulate when hs && de (for DVP timing). 
        else if(I_awb_hs && I_awb_de)
        begin
            acc_red_data_tmp   <= acc_red_data_tmp + I_awb_rgb[23:16];
            acc_green_data_tmp <= acc_green_data_tmp + I_awb_rgb[15:8];
            acc_blue_data_tmp  <= acc_blue_data_tmp + I_awb_rgb[7:0];
        end
        else
        begin
            acc_red_data_tmp   <= acc_red_data_tmp;
            acc_green_data_tmp <= acc_green_data_tmp;
            acc_blue_data_tmp  <= acc_blue_data_tmp;
        end
    end
end

reg             [28:0]          acc_red_data;
reg             [28:0]          acc_green_data;
reg             [28:0]          acc_blue_data;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
    begin
        acc_red_data   <= 29'h0000_0001;
        acc_green_data <= 29'h0000_0001;
        acc_blue_data  <= 29'h0000_0001;
    end
    else
    begin
        if(lcd_vs_neg == 1'b1)
        begin
            acc_red_data   <= acc_red_data_tmp;
            acc_green_data <= acc_green_data_tmp;
            acc_blue_data  <= acc_blue_data_tmp;
        end
        else
        begin
            acc_red_data   <= acc_red_data;
            acc_green_data <= acc_green_data;
            acc_blue_data  <= acc_blue_data;
        end
    end
end

//	Hold sum of 1920*1080 max. 
reg             [30:0]          acc_data;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
        acc_data <= 31'h0000_0003;
    else
        acc_data <= acc_red_data + acc_green_data + acc_blue_data;
end

reg             [32:0]          acc_red_data_x3;
reg             [32:0]          acc_green_data_x3;
reg             [32:0]          acc_blue_data_x3;

always @(posedge I_clk)
begin
    acc_red_data_x3   <= {acc_red_data,1'b0} + acc_red_data;
    acc_green_data_x3 <= {acc_green_data,1'b0} + acc_green_data;
    acc_blue_data_x3  <= {acc_blue_data,1'b0} + acc_blue_data;
end

//----------------------------------------------------------------------
//  c1
reg             [38:0]          red_data_c1;
reg             [38:0]          green_data_c1;
reg             [38:0]          blue_data_c1;

always @(posedge I_clk)
begin
    red_data_c1   <= I_awb_rgb[23:16] * acc_data;
    green_data_c1 <= I_awb_rgb[15:8] * acc_data;
    blue_data_c1  <= I_awb_rgb[7:0] * acc_data;
end

reg                             lcd_vs_c1;
reg                             lcd_hs_c1;
reg                             lcd_de_c1;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
    begin
        lcd_vs_c1 <= 1'b0;
        lcd_hs_c1 <= 1'b0;
        lcd_de_c1 <= 1'b0;
    end
    else
    begin
        lcd_vs_c1 <= I_awb_vs;
        lcd_hs_c1 <= I_awb_hs;
        lcd_de_c1 <= I_awb_de;
    end
end

//----------------------------------------------------------------------
//  c2 : delay 41 clock
wire            [38:0]          red_quo_c2;
wire            [38:0]          green_quo_c2;
wire            [38:0]          blue_quo_c2;

wire                            lcd_vs_c2;
wire                            lcd_hs_c2;
wire                            lcd_de_c2;

div_u39_u33 u0_div_u39_u33
(
    .I_clk    (I_clk            ),
    .den    (acc_red_data_x3   ),
    .num    (red_data_c1    ),
    .rst    (~I_rst_n         ),
    .start  ({lcd_vs_c1, lcd_hs_c1, lcd_de_c1}           ),
    .done   ({lcd_vs_c2, lcd_hs_c2, lcd_de_c2}               ),
    .quo    (red_quo_c2     ),
    .rem    (               )
);

div_u39_u33 u1_div_u39_u33
(
    .I_clk    (I_clk            ),
    .den    (acc_green_data_x3 ),
    .num    (green_data_c1  ),
    .rst    (~I_rst_n         ),
    .start  (1'b1           ),
    .done   (               ),
    .quo    (green_quo_c2   ),
    .rem    (               )
);

div_u39_u33 u2_div_u39_u33
(
    .I_clk    (I_clk            ),
    .den    (acc_blue_data_x3  ),
    .num    (blue_data_c1   ),
    .rst    (~I_rst_n         ),
    .start  (1'b1           ),
    .done   (               ),
    .quo    (blue_quo_c2    ),
    .rem    (               )
);

//reg             [40:0]          lcd_vs_tmp2;
//reg             [40:0]          lcd_hs_tmp2;
//reg             [40:0]          lcd_de_tmp2;
//
//always @(posedge I_clk or negedge I_rst_n)
//begin
//    if(I_rst_n == 1'b0)
//    begin
//        lcd_vs_tmp2 <= 41'b0;
//        lcd_hs_tmp2 <= 41'b0;
//        lcd_de_tmp2 <= 41'b0;
//    end
//    else
//    begin
//        lcd_vs_tmp2 <= {lcd_vs_tmp2[39:0],lcd_vs_c1};
//        lcd_hs_tmp2 <= {lcd_hs_tmp2[39:0],lcd_hs_c1};
//        lcd_de_tmp2 <= {lcd_de_tmp2[39:0],lcd_de_c1};
//    end
//end
//
//wire                            lcd_vs_c2;
//wire                            lcd_hs_c2;
//wire                            lcd_de_c2;
//
//assign lcd_vs_c2 = lcd_vs_tmp2[40];
//assign lcd_hs_c2 = lcd_hs_tmp2[40];
//assign lcd_de_c2 = lcd_de_tmp2[40];

//----------------------------------------------------------------------
//  c3
reg             [7:0]           red_data_c3;
reg             [7:0]           green_data_c3;
reg             [7:0]           blue_data_c3;

always @(posedge I_clk)
begin
    if(red_quo_c2[38:8] == 31'b0)
        red_data_c3 <= red_quo_c2[7:0];
    else
        red_data_c3 <= 8'd255;
    if(green_quo_c2[38:8] == 31'b0)
        green_data_c3 <= green_quo_c2[7:0];
    else
        green_data_c3 <= 8'd255;
    if(blue_quo_c2[38:8] == 31'b0)
        blue_data_c3 <= blue_quo_c2[7:0];
    else
        blue_data_c3 <= 8'd255;
end

reg                             lcd_vs_c3;
reg                             lcd_hs_c3;
reg                             lcd_de_c3;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
    begin
        lcd_vs_c3 <= 1'b0;
        lcd_hs_c3 <= 1'b0;
        lcd_de_c3 <= 1'b0;
    end
    else
    begin
        lcd_vs_c3 <= lcd_vs_c2;
        lcd_hs_c3 <= lcd_hs_c2;
        lcd_de_c3 <= lcd_de_c2;
    end
end

//----------------------------------------------------------------------
//  c4
reg             [9:0]           red_data_c4;
reg             [9:0]           green_data_c4;
reg             [9:0]           blue_data_c4;

always @(posedge I_clk)
begin
    red_data_c4   <= {2'b0,red_data_c3} + {{2{I_red_gain[7]}},I_red_gain};
    green_data_c4 <= {2'b0,green_data_c3} + {{2{I_green_gain[7]}},I_green_gain};
    blue_data_c4  <= {2'b0,blue_data_c3} + {{2{I_blue_gain[7]}},I_blue_gain};
end

reg                             lcd_vs_c4;
reg                             lcd_hs_c4;
reg                             lcd_de_c4;

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
    begin
        lcd_vs_c4 <= 1'b0;
        lcd_hs_c4 <= 1'b0;
        lcd_de_c4 <= 1'b0;
    end
    else
    begin
        lcd_vs_c4 <= lcd_vs_c3;
        lcd_hs_c4 <= lcd_hs_c3;
        lcd_de_c4 <= lcd_de_c3;
    end
end

//----------------------------------------------------------------------
always @(posedge I_clk)
begin
    if(red_data_c4[9] == 1'b1)
        O_awb_rgb[23:16] <= 8'd0;
    else if(red_data_c4[8] == 1'b0)
        O_awb_rgb[23:16] <= red_data_c4[7:0];
    else
        O_awb_rgb[23:16] <= 8'd255;
    if(green_data_c4[9] == 1'b1)
        O_awb_rgb[15:8] <= 8'd0;
    else if(green_data_c4[8] == 1'b0)
        O_awb_rgb[15:8] <= green_data_c4[7:0];
    else
        O_awb_rgb[15:8] <= 8'd255;
    if(blue_data_c4[9] == 1'b1)
        O_awb_rgb[7:0] <= 8'd0;
    else if(blue_data_c4[8] == 1'b0)
        O_awb_rgb[7:0] <= blue_data_c4[7:0];
    else
        O_awb_rgb[7:0] <= 8'd255;
end

always @(posedge I_clk or negedge I_rst_n)
begin
    if(I_rst_n == 1'b0)
    begin
        O_awb_vs <= 1'b0;
        O_awb_hs <= 1'b0;
        O_awb_de <= 1'b0;
    end
    else
    begin
        O_awb_vs <= lcd_vs_c4;
        O_awb_hs <= lcd_hs_c4;
        O_awb_de <= lcd_de_c4;
    end
end

endmodule
