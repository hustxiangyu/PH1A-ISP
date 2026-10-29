module face_average
(
	input   wire				i_clk,
	input   wire				i_rst_n,
	input	wire				i_hsyn,
	input	wire				i_vsyn,
	input	wire				i_en,
	input	wire [7:0]			i_data,
	
	
	output	reg 				o_hs,
	output	reg 				o_vs,
	output	reg 				o_en,	
	output  reg  [7:0]			o_data

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


always@(posedge i_clk )begin
	if(sum_r[11:0]>11'd1019)begin
		o_data	<= 8'hff;
	end else begin
		o_data	<= 8'h0;
	end
	o_hs <=i_hsyn_d[2]; 
    o_vs <=i_vsyn_d[2]; 
    o_en <=i_en_d[2]	;  
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
	.i_data			(i_data				),
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


always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n) 
	begin
        sum_r <= 12'd0;
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
		         r_temp_33);
    end
end

endmodule
