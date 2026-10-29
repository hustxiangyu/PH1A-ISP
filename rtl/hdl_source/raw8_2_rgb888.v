
/*********raw8_2_rgb888 RAW8 转 RGB888***********
通过先实现3*3的RAW矩阵，然后计算RGB
--版本号1.0
*********************************************************************/

`timescale 1ns/1ns

module raw8_2_rgb888#(
parameter   [13:0]  H_SIZE = 1920,    //640*480
parameter   [13:0]  V_SIZE = 1080
)
(
    //global clock
input   wire        I_clk,            //cmos video pixel clock
input   wire        I_rst_n,          //global reset
input   wire        I_raw_vs,          //Prepared Image data vsync valid signal
input   wire        I_raw_de,          //Prepared Image data href vaild  signal
input   wire[7:0]   I_raw_data,        //Prepared Image data 8 Bit RAW Data
input   wire		switch	,

output  reg        O_rgb_vs,   //Processed Image data vsync valid signal
output  reg        O_rgb_de,    //Processed Image data href vaild  signal
output  reg[7:0]   O_rgb_r,       //Prepared Image green data to be processed 
output  reg[7:0]   O_rgb_g,     //Prepared Image green data to be processed
output  reg[7:0]   O_rgb_b       //Prepared Image blue data to be processed
);

wire [7:0]raw_v_1_d0;//frame data of the 1th row
wire [7:0]raw_v_2_d0;//frame data of the 2th row
reg  [7:0]raw_v_3_d0;//frame data of the 3th row
reg  [7:0]raw_v_1_d1,raw_v_1_d2;
reg  [7:0]raw_v_2_d1,raw_v_2_d2;
reg  [7:0]raw_v_3_d1,raw_v_3_d2;
reg  raw_de_d1,raw_de_d2,raw_de_d3,raw_de_d4;  
reg  raw_vs_d1,raw_vs_d2,raw_vs_d3,raw_vs_d4;

wire  shift_clk_en = I_raw_de;

Line_Shift_RAM_8Bit#(
.DATA_WIDTH (8          ),
.ADDR_WIDTH (11         ),
.DATA_DEPTH (H_SIZE     ),
.DELAY_NUM  (0          )
)
u0_Line_Shift_RAM_8Bit
(
.clk    (I_clk          ),
.rst_n  (I_rst_n        ),
.clken  (shift_clk_en   ),
.din    (I_raw_data     ),   
.dout   (raw_v_2_d0     )
);

Line_Shift_RAM_8Bit#(
.DATA_WIDTH (8          ),
.ADDR_WIDTH (11         ),
.DATA_DEPTH (H_SIZE     ),
.DELAY_NUM  (1          )
)
u1_Line_Shift_RAM_8Bit
(
.clk    (I_clk          ),
.rst_n  (I_rst_n        ),
.clken  (shift_clk_en   ),
.din    (raw_v_2_d0     ),   
.dout   (raw_v_1_d0     )
);

always@(posedge I_clk)begin
    raw_v_3_d0 <= I_raw_de ? I_raw_data : raw_v_3_d0; 

    raw_v_3_d1 <= raw_v_3_d0;
    raw_v_3_d2 <= raw_v_3_d1;
    raw_v_1_d1 <= raw_v_1_d0;
    raw_v_1_d2 <= raw_v_1_d1;
    raw_v_2_d1 <= raw_v_2_d0;
    raw_v_2_d2 <= raw_v_2_d1;


    raw_de_d1  <= I_raw_de;
    raw_de_d2  <= raw_de_d1;
    raw_de_d3  <= raw_de_d2;
    raw_de_d4  <= raw_de_d3;

    raw_vs_d1  <= I_raw_vs;
    raw_vs_d2  <= raw_vs_d1;
    raw_vs_d3  <= raw_vs_d2;
    raw_vs_d4  <= raw_vs_d3;
end

reg  [7:0]raw_v_h_11,raw_v_h_12,raw_v_h_13;
reg  [7:0]raw_v_h_21,raw_v_h_22,raw_v_h_23;
reg  [7:0]raw_v_h_31,raw_v_h_32,raw_v_h_33;
reg     [13:0]  pixel_cnt;
//第1列，最后1列简单处理
always@(posedge I_clk)begin
  if(raw_de_d1|raw_de_d2)begin 
     pixel_cnt <=  (pixel_cnt < H_SIZE) ? pixel_cnt + 1'b1 : 10'd0;   //Point Counter  
    if(pixel_cnt == 0)begin //初始化，以raw_de_d2为高电平的0像素初始化
        {raw_v_h_11,raw_v_h_12,raw_v_h_13} <= {8'd0,8'd0,8'd0};
        {raw_v_h_21,raw_v_h_22,raw_v_h_23} <= {8'd0,8'd0,8'd0};
        {raw_v_h_31,raw_v_h_32,raw_v_h_33} <= {8'd0,8'd0,8'd0};
    end  
    else if(pixel_cnt == 1)begin//用已经有的2个像素点计算
        {raw_v_h_11,raw_v_h_12,raw_v_h_13} <= {raw_v_1_d0,raw_v_1_d1,raw_v_1_d0};
        {raw_v_h_21,raw_v_h_22,raw_v_h_23} <= {raw_v_2_d0,raw_v_2_d1,raw_v_2_d0};
        {raw_v_h_31,raw_v_h_32,raw_v_h_33} <= {raw_v_3_d0,raw_v_3_d1,raw_v_3_d0};    
    end
    else if(pixel_cnt == H_SIZE)begin//最后一个像素，raw_de_d2=0，最后一个像素，raw_de_d3=1，用最后的2个像素点计算
        {raw_v_h_11,raw_v_h_12,raw_v_h_13} <= {raw_v_1_d2,raw_v_1_d0,raw_v_1_d2};
        {raw_v_h_21,raw_v_h_22,raw_v_h_23} <= {raw_v_2_d2,raw_v_1_d0,raw_v_1_d2};
        {raw_v_h_31,raw_v_h_32,raw_v_h_33} <= {raw_v_3_d2,raw_v_1_d0,raw_v_1_d2};   
    end
    else begin
        {raw_v_h_11,raw_v_h_12,raw_v_h_13} <= {raw_v_1_d2,raw_v_1_d1,raw_v_1_d0};
        {raw_v_h_21,raw_v_h_22,raw_v_h_23} <= {raw_v_2_d2,raw_v_2_d1,raw_v_2_d0};
        {raw_v_h_31,raw_v_h_32,raw_v_h_33} <= {raw_v_3_d2,raw_v_3_d1,raw_v_3_d0};   
    end
  end
  else begin
        pixel_cnt <= 0;
        {raw_v_h_11,raw_v_h_12,raw_v_h_13} <= {8'd0,8'd0,8'd0};
        {raw_v_h_21,raw_v_h_22,raw_v_h_23} <= {8'd0,8'd0,8'd0};
        {raw_v_h_31,raw_v_h_32,raw_v_h_33} <= {8'd0,8'd0,8'd0};
  end
end


//----------------------------------------
//Count the frame lines
reg [10:0]  v_cnt;
reg [13:0]  h_cnt;
always@(posedge I_clk or negedge I_rst_n)begin
    if(!I_rst_n || I_raw_vs == 0)
        v_cnt <= 0;
    else if((raw_de_d3 == 1) && (raw_de_d2 == 0)) //Frame valid
        v_cnt <= (v_cnt < V_SIZE - 1'b1) ? v_cnt + 1'b1 : 11'd0;
    else 
        v_cnt <= v_cnt;
end

always@(posedge I_clk or negedge I_rst_n)begin
    if(!I_rst_n )
        h_cnt <= 0;
    else if(raw_de_d3 == 1'b1)  //以raw_de_d2开始计数
        h_cnt <= (h_cnt < H_SIZE - 1'b1) ? h_cnt + 1'b1 : 11'd0;
    else
        h_cnt <= 0;
end

//Convet RAW 2 RGB888 Format
reg [9:0]   rgb_r,rgb_g,rgb_b;
always@(posedge I_clk or negedge I_rst_n)begin
    if(!I_rst_n)begin
        rgb_r  <=  0;
        rgb_g  <=  0;
        rgb_b  <=  0; 
    end else begin
        case({v_cnt[0], h_cnt[0]})
        2'b11: begin  //odd lines + odd point  //Center Green
            rgb_r  <=  (raw_v_h_12 + raw_v_h_32)>>1;
            rgb_g  <=   raw_v_h_22;     
            rgb_b  <=  (raw_v_h_21 + raw_v_h_23)>>1;
         end
        2'b10: begin  //odd lines + even point //Center Blue
            rgb_r  <=  (raw_v_h_11 + raw_v_h_13 + raw_v_h_31 + raw_v_h_33)>>2;
            rgb_g  <=  (raw_v_h_12 + raw_v_h_21 + raw_v_h_23 + raw_v_h_32)>>2;
            rgb_b  <=   raw_v_h_22;
        end
        2'b01: begin  //even lines + odd point //Center Red
            rgb_r  <=   raw_v_h_22;
            rgb_g  <=  (raw_v_h_12 + raw_v_h_21 + raw_v_h_23 + raw_v_h_32)>>2;
            rgb_b  <=  (raw_v_h_11 + raw_v_h_13 + raw_v_h_31 + raw_v_h_33)>>2;
        end
        2'b00: begin//even lines + even point  //Center Green        
            rgb_r  <=  (raw_v_h_21 + raw_v_h_23)>>1;
            rgb_g  <=   raw_v_h_22;
            rgb_b  <=  (raw_v_h_12 + raw_v_h_32)>>1;
        end 
        endcase
    end
end

always@(posedge I_clk)begin
	if(switch)begin
		O_rgb_r   <= rgb_r[7:0];
		O_rgb_g   <= rgb_g[7:0];
		O_rgb_b   <= rgb_b[7:0];
		O_rgb_de  <= raw_de_d4;
		O_rgb_vs  <= raw_vs_d4;
	end else begin
		O_rgb_r   <= I_raw_data;
		O_rgb_g   <= I_raw_data;
		O_rgb_b   <= I_raw_data;
		O_rgb_de  <= I_raw_de;
		O_rgb_vs  <= I_raw_vs;		
	end
end


endmodule
