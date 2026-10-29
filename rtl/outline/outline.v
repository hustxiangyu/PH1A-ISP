
module outline(
	input   wire                i_clk		, 	
	input   wire                i_rst_n		, 
	input	wire				i_hsyn		,	
	input	wire				i_vsyn		,
	input	wire [7:0]			i_r			,
	input	wire [7:0] 			i_g			,
	input	wire [7:0] 			i_b			,	
	input	wire				i_de		,
	input	wire				switch		,			 		
	output	reg					o_hsyn		,	
	output  reg					o_vsyn		,	
	output  reg	[7:0]			o_data_y	,
	output  reg	[7:0]			o_data_u	,
	output  reg	[7:0]			o_data_v	,	
	output  reg					o_de
);

	
wire 				gray_hsyn;
wire 				gray_vsyn;
wire [23:0] 		gray_data;
wire 				gray_de;
wire				o_hsyn1;
wire                o_vsyn1;
wire [7:0]          o_data1;
wire                o_de1  ;

reg [7:0] 			binary;

always@(*)begin
	if(gray_data[7:0] > 90)
		binary<=8'd255;
	else 
	    binary <= 8'd0;
end


rgb2gray_algorithm u_algorithm
(
	.i_clk			(i_clk			),	
	.i_rst_n        (i_rst_n		),
	.i_hsyn			(i_hsyn			),		
	.i_vsyn			(i_vsyn			),		
	.i_r			(i_r			),
	.i_g			(i_g			),
	.i_b			(i_b			),	
	.i_de			(i_de			),		
	.o_gray_hsyn	(gray_hsyn		),	
	.o_gray_vsyn	(gray_vsyn		),	
	.o_gray_data	(gray_data		),	
	.o_gray_de		(gray_de	    )
);

image_outline_filtering u_image_outline_filtering
(
	.i_clk			(i_clk				),
	.i_rst_n		(i_rst_n			),
	.i_hsyn		    (gray_hsyn			),
	.i_vsyn		    (gray_vsyn			),
	.i_en		    (gray_de			),
	.i_binary		(binary				),
	.o_hs		    (o_hsyn1				),
	.o_vs		    (o_vsyn1				),
	.o_en		    (o_de1				),	
	.o_binary		(o_data1				)
);
always@(posedge i_clk )begin
	if(switch)begin
		o_hsyn	<= o_hsyn1;
    	o_vsyn  <= o_vsyn1;
    	o_data_y  <= o_data1;
    	o_data_u  <= o_data1;
    	o_data_v  <= o_data1;
    	o_de      <= o_de1  ;
	end else begin
		o_hsyn	  <= i_hsyn		;
    	o_vsyn    <= i_vsyn		;
    	o_data_y  <= i_r		;
    	o_data_u  <= i_g		;
    	o_data_v  <= i_b		;
    	o_de      <= i_de		;
	end
end
endmodule