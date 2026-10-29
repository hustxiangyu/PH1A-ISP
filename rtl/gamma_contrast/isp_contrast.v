module isp_contrast
(
	  input		  			clk				,
      input 		[7:0] 	i_data_r		,
      input 		[7:0] 	i_data_g		,
      input 		[7:0] 	i_data_b		,
      input  	 	 		switch1			,
      input		  			light			,
	  input		  			dark			,
      input  	  			i_data_valid	,
      input  	 		 	i_href			,
      input  	  			i_vsync			,
      output	reg  		o_vsync			,
      output	reg	[7:0]	o_data_r		,
      output	reg [7:0]   o_data_g		,
      output	reg [7:0]   o_data_b		,
      output	reg         o_data_valid
 );

wire [7:0]   o_data_r_1p2;
wire [7:0]   o_data_g_1p2;
wire [7:0]   o_data_b_1p2;
 
wire [7:0]   o_data_r_1p3;
wire [7:0]   o_data_g_1p3;
wire [7:0]   o_data_b_1p3;
 
wire [7:0]   o_data_r_1p4;
wire [7:0]   o_data_g_1p4;
wire [7:0]   o_data_b_1p4; 

wire [7:0]   o_data_r_0p6;
wire [7:0]   o_data_g_0p6;
wire [7:0]   o_data_b_0p6; 
                     
wire [7:0]   o_data_r_0p7;
wire [7:0]   o_data_g_0p7;
wire [7:0]   o_data_b_0p7; 
                      
wire [7:0]   o_data_r_0p8;
wire [7:0]   o_data_g_0p8;
wire [7:0]   o_data_b_0p8; 

reg light1,dark1,switch;
wire pos_light,pos_dark,pos_switch;
always@(posedge clk)begin
	light1<=light;
	dark1 <=dark;
	switch<=switch1;
end
assign 			pos_light 	= light&(!light1);
assign 			pos_dark 	= dark&(!dark1);
assign 			pos_switch 	= switch1&(!switch);
reg 	[3:0] 	light_cnt 	= 3'd4;

always@(posedge clk)begin
	if(pos_switch)begin
		light_cnt<=3'd4;
	end
	if(pos_light)begin
		if(light_cnt==3'd7)begin
			light_cnt<=light_cnt;
		end else begin
			light_cnt<=light_cnt+1'b1;
		end
	end 
    else if(pos_dark)begin
		if(light_cnt==3'd1)begin
				light_cnt<=light_cnt;
		end else begin
				light_cnt<=light_cnt-1'b1;
		end
	end
end
always@(*)begin
	if(switch1)begin
		case(light_cnt)
			3'd1:begin
        		o_data_r<=o_data_r_0p6 ;
        		o_data_g<=o_data_g_0p6 ;
        		o_data_b<=o_data_b_0p6 ;
        		o_vsync <= i_vsync;         
    			o_data_valid <= i_data_valid; 	
			 end
			3'd2:begin
        		o_data_r<=o_data_r_0p7 ;
        		o_data_g<=o_data_g_0p7 ;
        		o_data_b<=o_data_b_0p7 ;
        		o_vsync <= i_vsync;      
    			o_data_valid <= i_data_valid;
         		
			 end
			3'd3:begin
        
        		o_data_r<=o_data_r_0p8 ;
        		o_data_g<=o_data_g_0p8 ;
        		o_data_b<=o_data_b_0p8 ;
        		o_vsync <= i_vsync;         
    			o_data_valid <= i_data_valid;
			 end
             3'd6:begin
        		o_data_r<=o_data_r_1p3 ;
        		o_data_g<=o_data_g_1p3 ;
        		o_data_b<=o_data_b_1p3 ;
        		o_vsync <= i_vsync;         
    			o_data_valid <= i_data_valid;	
			 end
			3'd4:begin
				o_data_r<=i_data_r;
        		o_data_g<=i_data_g;
        		o_data_b<=i_data_b;
        		o_vsync <= i_vsync;         
    			o_data_valid <= i_data_valid;
			 end
			3'd5:begin
				o_data_r<=o_data_r_1p2 ;
        		o_data_g<=o_data_g_1p2 ;
        		o_data_b<=o_data_b_1p2 ;
        		o_vsync <= i_vsync;         
    			o_data_valid <= i_data_valid;
			 end

			3'd7:begin
        		o_data_r<=o_data_r_1p4 ;
        		o_data_g<=o_data_g_1p4 ;
        		o_data_b<=o_data_b_1p4 ;
        		o_vsync <= i_vsync;         
    			o_data_valid <= i_data_valid;
			 end	
		default:begin
			o_data_r<=i_data_r;
        	o_data_g<=i_data_r;
        	o_data_b<=i_data_r;
        	o_vsync <= i_vsync;         
    		o_data_valid <= i_data_valid;
			end
		endcase
	end else begin
		o_data_r<=i_data_r;
        o_data_g<=i_data_r;
        o_data_b<=i_data_r;
        o_vsync <= i_vsync;         
    	o_data_valid <= i_data_valid;
	end
end

contrast_0point6 contrast_0point6_inst_r
(
   .Pre_Data	(i_data_r	)	,
   .Post_Data	(o_data_r_0p6	)
);
contrast_0point6 contrast_0point6_inst_g
(
   .Pre_Data	(i_data_g	)	,
   .Post_Data	(o_data_g_0p6	)
);
contrast_0point6 contrast_0point6_inst_b
(
   .Pre_Data	(i_data_b	)	,
   .Post_Data	(o_data_b_0p6	)
);

contrast_0point7 contrast_0point7_inst_r
(
   .Pre_Data	(i_data_r	)	,
   .Post_Data	(o_data_r_0p7	)
);
contrast_0point7 contrast_0point7_inst_g
(
   .Pre_Data	(i_data_g	)	,
   .Post_Data	(o_data_g_0p7	)
);
contrast_0point7 contrast_0point7_inst_b
(
   .Pre_Data	(i_data_b	)	,
   .Post_Data	(o_data_b_0p7	)
);

contrast_0point8 contrast_0point8_inst_r
(
   .Pre_Data	(i_data_r	)	,
   .Post_Data	(o_data_r_0p8	)
);
contrast_0point8 contrast_0point8_inst_g
(
   .Pre_Data	(i_data_g	)	,
   .Post_Data	(o_data_g_0p8	)
);
contrast_0point8 contrast_0point8_inst_b
(
   .Pre_Data	(i_data_b	)	,
   .Post_Data	(o_data_b_0p8	)
);

contrast_1point2 contrast_1point2_inst_r
(
   .Pre_Data	(i_data_r	)	,
   .Post_Data	(o_data_r_1p2	)
);
contrast_1point2 contrast_1point2_inst_g
(
   .Pre_Data	(i_data_g	)	,
   .Post_Data	(o_data_g_1p2	)
);
contrast_1point2 contrast_1point2_inst_b
(
   .Pre_Data	(i_data_b	)	,
   .Post_Data	(o_data_b_1p2	)
);

contrast_1point3 contrast_1point3_inst_r
(
   .Pre_Data	(i_data_r	)	,
   .Post_Data	(o_data_r_1p3	)
);
contrast_1point3 contrast_1point3_inst_g
(
   .Pre_Data	(i_data_g	)	,
   .Post_Data	(o_data_g_1p3	)
);
contrast_1point3 contrast_1point3_inst_b
(
   .Pre_Data	(i_data_b	)	,
   .Post_Data	(o_data_b_1p3	)
);

contrast_1point4 contrast_1point4_inst_r
(
   .Pre_Data	(i_data_r	)	,
   .Post_Data	(o_data_r_1p4	)
);
contrast_1point4 contrast_1point4_inst_g
(
   .Pre_Data	(i_data_g	)	,
   .Post_Data	(o_data_g_1p4	)
);
contrast_1point4 contrast_1point4_inst_b
(
   .Pre_Data	(i_data_b	)	,
   .Post_Data	(o_data_b_1p4	)
);

endmodule
