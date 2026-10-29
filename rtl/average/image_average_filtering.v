module image_average_filtering
(
	input   wire				i_clk,
	input   wire				i_rst_n,
	input	wire				switch,
	input	wire				i_hsyn,
	input	wire				i_vsyn,
	input	wire				i_en,
	input	wire [7:0]			i_r,
	input	wire [7:0] 			i_g,
	input	wire [7:0] 			i_b,		
	
	output	reg 				o_hs,
	output	reg 				o_vs,
	output	reg 				o_en,	
	output  reg  [7:0]			o_r,
	output  reg  [7:0]			o_g,
	output  reg  [7:0]			o_b	
);

reg	[2:0]		i_hsyn_d;
reg	[2:0]		i_vsyn_d;
reg	[2:0]		i_en_d;

reg [11:0]		sum_r;
reg [11:0]		sum_g;
reg [11:0]		sum_b;

wire [23:0]		avg_r;
wire [23:0]		avg_g;
wire [23:0]		avg_b;
wire 			avg_r_valid;
wire 			avg_g_valid;
wire 			avg_b_valid;

wire [7:0]	r_temp_11;
wire [7:0]	r_temp_12;
wire [7:0]	r_temp_13;
wire [7:0]	r_temp_21;
wire [7:0]	r_temp_22;
wire [7:0]	r_temp_23;
wire [7:0]	r_temp_31;
wire [7:0]	r_temp_32;
wire [7:0]	r_temp_33;

wire [7:0]	g_temp_11;
wire [7:0]	g_temp_12;
wire [7:0]	g_temp_13;
wire [7:0]	g_temp_21;
wire [7:0]	g_temp_22;
wire [7:0]	g_temp_23;
wire [7:0]	g_temp_31;
wire [7:0]	g_temp_32;
wire [7:0]	g_temp_33;

wire [7:0]	b_temp_11;
wire [7:0]	b_temp_12;
wire [7:0]	b_temp_13;
wire [7:0]	b_temp_21;
wire [7:0]	b_temp_22;
wire [7:0]	b_temp_23;
wire [7:0]	b_temp_31;
wire [7:0]	b_temp_32;
wire [7:0]	b_temp_33;

always@(posedge i_clk )begin
	if(switch)begin
	  o_r	<= sum_r[7:0];
	  o_g	<= sum_g[7:0];
	  o_b	<= sum_b[7:0];
	  o_hs <=i_hsyn_d[2]; 
      o_vs <=i_vsyn_d[2]; 
      o_en <=i_en_d[2]	;  
	end else begin
	  o_r	<=i_r ;
	  o_g	<=i_g ;
	  o_b	<=i_b ;
	  o_hs <=i_hsyn;
      o_vs <=i_vsyn;
      o_en <=i_en;  
	end
end
always@(posedge i_clk ) 
begin
	i_hsyn_d <=	{i_hsyn_d[1:0],i_hsyn};
	i_vsyn_d <=	{i_vsyn_d[1:0],i_vsyn};
	i_en_d	 <=	{i_en_d[1:0],i_en};
     	
end

image_template u_r_template
(
	.i_clk			(i_clk				),
	.i_rst_n		(i_rst_n			),
	.i_en			(i_en				),
	.i_data			(i_r				),
	.o_en			(					),
	.o_temp_11		(r_temp_11			),
	.o_temp_12		(r_temp_12			),
	.o_temp_13		(r_temp_13			),	
	.o_temp_21		(r_temp_21			),
	.o_temp_22		(r_temp_22			),
	.o_temp_23		(r_temp_23			),		
	.o_temp_31		(r_temp_31			),
	.o_temp_32		(r_temp_32			),
	.o_temp_33		(r_temp_33			)
);

image_template u_g_template
(
	.i_clk			(i_clk				),
	.i_rst_n		(i_rst_n			),
	.i_en			(i_en				),
	.i_data			(i_g				),
	.o_en			(					),
	.o_temp_11		(g_temp_11			),
	.o_temp_12		(g_temp_12			),
	.o_temp_13		(g_temp_13			),	
	.o_temp_21		(g_temp_21			),
	.o_temp_22		(g_temp_22			),
	.o_temp_23		(g_temp_23			),		
	.o_temp_31		(g_temp_31			),
	.o_temp_32		(g_temp_32			),
	.o_temp_33		(g_temp_33			)
);

image_template u_b_template
(
	.i_clk			(i_clk				),
	.i_rst_n		(i_rst_n			),
	.i_en			(i_en				),
	.i_data			(i_b				),
	.o_en			(					),
	.o_temp_11		(b_temp_11			),
	.o_temp_12		(b_temp_12			),
	.o_temp_13		(b_temp_13			),	
	.o_temp_21		(b_temp_21			),
	.o_temp_22		(b_temp_22			),
	.o_temp_23		(b_temp_23			),		
	.o_temp_31		(b_temp_31			),
	.o_temp_32		(b_temp_32			),
	.o_temp_33		(b_temp_33			)
);

always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n) 
	begin
        sum_r <= 12'd0;
        sum_g <= 12'd0;
        sum_b <= 12'd0;
    end
    else 
	begin
        sum_r <= (r_temp_11 +
		         r_temp_12 +
		         r_temp_13 +
		         r_temp_21 +
		         r_temp_22 +
		         r_temp_23 +
		         r_temp_31 +
		         r_temp_32 +
		         r_temp_33)*7>>>6;
        sum_g <= (g_temp_11 +
		         g_temp_12 +
		         g_temp_13 +
		         g_temp_21 +
		         g_temp_22 +
		         g_temp_23 +
		         g_temp_31 +
		         g_temp_32 +
		         g_temp_33)*7>>>6;
        sum_b <= (b_temp_11 +
		         b_temp_12 +
		         b_temp_13 +
		         b_temp_21 +
		         b_temp_22 +
		         b_temp_23 +
		         b_temp_31 +
		         b_temp_32 +
		         b_temp_33)*7>>>6;
    end
end

endmodule