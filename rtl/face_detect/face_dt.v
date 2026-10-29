module face_dt
#(
	parameter COL = 1920,
	parameter ROW = 1080
)
(
	input rst_n							,
	input switch						,//0时关闭算法，1打开算法
	input switch1						,
	input video_pclk					,
	input video_valid					,
	input [23:0] video_data				,  					
	                          					
                              					
	input i_h_sync						,           					
	input i_v_sync						,           				
	
	output out_pclk						,
	output reg out_valid				,
	output reg [23:0] out_data			, 				
	

	output reg o_h_sync					,       	  			
	output reg o_v_sync        	  		,
	output	reg	[2:0]	face_sel	
);  

wire button_out; 
reg  button_out1;
wire button_out_flag;                         	  			
key_delay key_delay_inst
(
    .clk		(video_pclk	)	,        // 50MHz时钟输入
    .rst_n		(rst_n	)		,        // 复位信号，低电平有效
    .button_in	(switch1	)	,  		 // 按键输入信号
    .button_out (button_out	) 			 // 消抖后的按键输出信号
);
always@(posedge video_pclk)begin
	button_out1<=button_out;
end
assign button_out_flag = button_out&(~button_out1);
reg flag;
always @(posedge video_pclk or negedge rst_n) begin
	if(~rst_n)begin
		flag<=1'b0;
	end else if(button_out_flag)begin
		flag<=~flag;
	end else begin
		flag<=flag;
	end
end
wire [7:0] Cb2;
wire [7:0] Cr2;
wire [7:0] o_y_8b;
wire o_data_en;//synthesis keep

reg [7:0] face_data;
reg face_valid;
reg o_v_sync_valid;
reg o_h_sync_valid;
assign out_pclk = video_pclk;

wire o_h_sync1,o_v_sync1;
rgb_to_ycbcr u_rgb_to_ycbcr // 延迟3个时钟
(
	.clk(video_pclk),
    .rst_n(rst_n),
	.rgb888(video_data),
	.i_v_sync(i_v_sync),         // 输入场同步信号
	.i_data_en(video_valid),
	.i_h_sync(i_h_sync),         // 输入行同步信号

	.o_h_sync(o_h_sync1),         // 输出行同步信号
	.o_y_8b(o_y_8b),                   // 输出Y通道
	.o_cb_8b(Cb2),
	.o_cr_8b(Cr2),
	.o_v_sync(o_v_sync1),         // 输出场同步信号
	.o_data_en(o_data_en)
);


always @(posedge video_pclk or negedge rst_n) begin
	if(!rst_n) begin
		face_valid <= 1'd0;
		o_v_sync_valid <= 1'd0;
		o_h_sync_valid <= 1'b0;
	end
	else begin
		face_valid <= o_data_en;
		o_v_sync_valid <=o_v_sync1;
        o_h_sync_valid <=o_h_sync1;
	end
end
always @(posedge video_pclk or negedge rst_n) begin
	if(!rst_n) begin
		face_mask <= 8'h0;
	end else if((cnt_l> 550 )&&(cnt_l< 1319 )&& (cnt_h> 250 )&&(cnt_h< 900 ))begin
 		if((Cb2 > 77) && (Cb2 < 127) && (Cr2 > 133) && (Cr2 < 173)) begin
			face_mask <= 8'hFF; // 检测到人脸部分设置为255（白色）
		end else begin
			face_mask <= 8'h0;
		end
	end else begin
			face_mask <= 8'h0;
	end
end
wire o_en ,o_hs,o_vs;
wire [7:0] o_data;//synthesis keep
face_average face_average_inst
(
	.i_clk	(video_pclk	)			,
	.i_rst_n(rst_n		)			,
	.i_hsyn	(o_h_sync_valid	)			,
	.i_vsyn	(o_v_sync_valid	)			,
	.i_en	(face_valid		)			,
	.i_data	(face_mask	)			,
	     
	.o_hs	(o_hs	)			,
	.o_vs	(o_vs	)			,
	.o_en	(o_en	)			,	
	.o_data (o_data	)
);
wire post_img_vsync,post_img_href;
wire [7:0] post_img_bit;
isp_dilation isp_dilation_inst2
(
    
    .pclk			(video_pclk	)	 ,
	.rst_n			(rst_n	)	 ,
	.switch			(1'b1	)	 ,
	.per_img_href	(o_en	)	 ,
	.per_img_vsync	(o_vs	)	 ,
	.per_img_bit	(o_data	)	 ,
    .per_img_u		(o_data	)	 ,
    .per_img_v		(o_data	)	 ,
                   
    .post_img_vsync (post_img_vsync	)	 ,       
    .post_img_href  (post_img_href	) 	 , 
    .post_img_bit   (post_img_bit	)	 ,
   	.post_img_u   	(	)     			 ,
    .post_img_v   	(	)     
);

reg [7:0] face_mask;
reg [13:0] cnt_l;
reg [13:0] cnt_h;
always @(posedge video_pclk or negedge rst_n) begin
	if(rst_n == 1'b0)
		cnt_l <= 16'd0;
	else if(cnt_l == COL-1 && post_img_href == 1'b1)
		cnt_l <= 16'd0;
	else if(post_img_href == 1'b1)
		cnt_l <= cnt_l + 1'b1;
	else
		cnt_l <= cnt_l;
end
always @(posedge video_pclk or negedge rst_n) begin
	if(rst_n == 1'b0)
		cnt_h <= 16'd0;
	else if(cnt_h == ROW-1 && cnt_l == COL-1 && post_img_href == 1'b1)
		cnt_h <= 16'd0;
	else if(cnt_l == COL-1 && post_img_href == 1'b1) 
		cnt_h <= cnt_h + 1'b1;
	else
		cnt_h <= cnt_h;
end



reg [2:0]face_size;
reg [19:0]cnt;//synthesis keep
reg [19:0]cnt1;//synthesis keep
reg [5:0] vs;
reg o_v_sync2;//synthesis keep
reg o_v_sync3;//synthesis keep
reg o_v_sync4;//synthesis keep
reg o_v_sync2_1;//synthesis keep
reg o_v_sync3_1;//synthesis keep
reg o_v_sync4_1;//synthesis keep
wire o_v_sync2_flag;//synthesis keep
wire o_v_sync3_flag;//synthesis keep
wire o_v_sync4_flag;//synthesis keep

always@(posedge video_pclk)begin
	o_v_sync2<=o_v_sync1;
	o_v_sync3<=o_v_sync2;
	o_v_sync4<=o_v_sync3;
end
always@(posedge video_pclk)begin
    o_v_sync2_1<=o_v_sync2;
    o_v_sync3_1<=o_v_sync3;
    o_v_sync4_1<=o_v_sync4;
end
assign o_v_sync2_flag = (~o_v_sync2)&o_v_sync2_1;
assign o_v_sync3_flag = (~o_v_sync3)&o_v_sync3_1;
assign o_v_sync4_flag = (~o_v_sync4)&o_v_sync4_1;
always @(posedge video_pclk or negedge rst_n) begin
	if(!rst_n)begin
		cnt<=1'b0;
	end else if(o_v_sync2_flag)begin
		if(cnt<=13'd5000)begin
			cnt<=1'b0;
		end else begin
			cnt<=cnt-13'd5000;
		end
	end else if(o_v_sync4_flag)begin
		cnt<=1'b0;
	end else if(post_img_bit==8'hff)begin
		cnt<=cnt+1'b1;
	end else begin
		cnt<=cnt;
	end
end
always @(posedge video_pclk or negedge rst_n) begin
	if(~rst_n)begin
		face_size<=3'b0;
	end else if(o_v_sync3_flag)begin
		if(cnt<16'd50000)begin
			face_size<=3'b0;
		end else if(cnt>=16'd50000&&cnt<=17'd110000)begin
			face_size<=3'b01;			
		end else if(cnt>=17'd110000&&cnt<=18'd140000)begin
			face_size<=3'b10;				
		end else if (cnt>=18'd140000) begin
			face_size<=3'b100;				
		end
	end
end

reg [20:0] cnt_time;
reg [5:0] cnt_flag_p;
always @(posedge video_pclk or negedge rst_n) begin
	if(~rst_n)begin
		cnt_time<=20'd0;
		cnt_flag_p<=1'b0;
	end else if(cnt_time==21'd2048574)begin
		cnt_time<=20'd0;
		if(cnt_flag_p == 6'd60)begin
			cnt_flag_p<=6'd0;
		end	else begin
			cnt_flag_p<=cnt_flag_p+1'b1;
		end	
	end else begin
		cnt_time<=cnt_time+1'b1;
	end
end
reg [9:0] cnt_state0;
reg [9:0] cnt_state1;
reg [9:0] cnt_state2;
reg [9:0] cnt_state3;
always @(posedge video_pclk or negedge rst_n) begin
	if(!rst_n)begin
	 	cnt_state0<=1'b0;
        cnt_state1<=1'b0;
        cnt_state2<=1'b0;
        cnt_state3<=1'b0;
	end else if(cnt_flag_p==6'd60)begin
	 	cnt_state0<=1'b0;
        cnt_state1<=1'b0;
        cnt_state2<=1'b0;
        cnt_state3<=1'b0;
	end else if(o_v_sync4_flag)begin
		if(face_size==3'b0)begin
			cnt_state0<=cnt_state0+1'b1;
		end else if(face_size==3'b1)begin
			cnt_state1<=cnt_state1+1'b1;
		end else if(face_size==3'b10)begin
			cnt_state2<=cnt_state2+1'b1;
		end else if(face_size==3'b100)begin
			cnt_state3<=cnt_state3+1'b1;
		end
	end
end
reg[2:0]face_size_r;
always @(posedge video_pclk or negedge rst_n) begin
	if(!rst_n)begin
		face_size_r<=3'b0;
	end else if(cnt_flag_p==6'd59)begin
		if((cnt_state0>=cnt_state1)&&(cnt_state0>=cnt_state2)&&(cnt_state0>=cnt_state3))begin
			face_size_r<=3'b0;
		end else if((cnt_state1>=cnt_state0)&&(cnt_state1>=cnt_state2)&&(cnt_state1>=cnt_state3))begin
			face_size_r<=3'b1;
		end else if((cnt_state2>=cnt_state0)&&(cnt_state2>=cnt_state1)&&(cnt_state2>=cnt_state3))begin
			face_size_r<=3'b10;
		end else if((cnt_state3>=cnt_state0)&&(cnt_state3>=cnt_state1)&&(cnt_state3>=cnt_state2))begin
			face_size_r<=3'b100;
		end
	end
end

always@(*)begin
	if(cnt_flag_p==6'd60)begin
		face_sel<=face_size_r;
	end
end


always @(posedge video_pclk or negedge rst_n) begin
	if(!rst_n) begin
		out_valid <= 1'd0;
		out_data <= 24'd0; // RGB888输出
	end
	else if(switch)begin
		out_valid <=flag?video_valid: o_en;
		out_data <= flag?video_data:{3{o_data}};
		o_h_sync<=flag?i_h_sync:o_hs;	
        o_v_sync<=flag?i_v_sync:o_vs;
	end else begin
		out_valid <= video_valid;                                    
	    out_data <= video_data;   
        o_h_sync<=i_h_sync;	                                     
		o_v_sync<=i_v_sync;                                             
	end
end 
	
endmodule
