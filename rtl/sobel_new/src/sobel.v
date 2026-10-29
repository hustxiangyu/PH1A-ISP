`timescale 1ns / 1ps
module sobel(
	input   wire                i_clk, 	
	input   wire                i_rst_n, 
	input	wire				i_hsyn,	
	input	wire				i_vsyn,	
	input	wire 				switch,
	input	wire [7:0]			threshold,
	input	wire [7:0]			i_r,
	input	wire [7:0] 			i_g,
	input	wire [7:0] 			i_b,	
	input	wire				i_de,	
	 		
	output	reg 				o_gray_hsyn,	
	output  reg 				o_gray_vsyn,	
	output  reg 	[23:0]		o_gray_data,	
	output  reg 				o_gray_de
);



wire gray_hsyn;
wire gray_vsyn;
wire [23:0] gray_data;
wire gray_de;



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
wire o_gray_hsyn1,o_gray_vsyn1,o_gray_de1;
wire [23:0]o_gray_data1;
image_sobel_filtering u_image_sobel_filtering
(
	.i_clk			(i_clk				),
	.i_rst_n		(i_rst_n			),
	.i_hsyn		    (gray_hsyn			),
	.i_vsyn		    (gray_vsyn			),
	.i_en		    (gray_de			),
	.i_r		    (gray_data[7:0]		),
	.i_g		    (					),
	.i_b		    (					),	
	.threshold		(75					),
	.o_hs		    (o_gray_hsyn1		),
	.o_vs		    (o_gray_vsyn1		),
	.o_en		    (o_gray_de1			),	
	.o_r		    (o_gray_data1[23:16]	),
	.o_g		    (o_gray_data1[15:8]	),
	.o_b		    (o_gray_data1[7:0]	)	
);

always@(posedge i_clk)begin
	if(switch)begin
		o_gray_hsyn <=o_gray_hsyn1;
        o_gray_vsyn <=o_gray_vsyn1;
        o_gray_data <=o_gray_data1;
        o_gray_de   <=o_gray_de1  ;
	end else begin
		o_gray_hsyn <=i_hsyn;
        o_gray_vsyn <=i_vsyn;
        o_gray_data <={i_r,i_g,i_b};
        o_gray_de   <=i_de  ;
	end

end




endmodule