module gamma(

      input [7:0] i_data_r	,
      input [7:0] i_data_g	,
      input [7:0] i_data_b	,
      input  	   switch1	,
      input  i_data_valid,
      input  i_href,
      input  i_vsync,
      output reg o_vsync,
      output reg [7:0]   o_data_r,
      output reg [7:0]   o_data_g,
      output reg [7:0]   o_data_b,
      output reg         o_data_valid
 );
wire [7:0]   o_data_r_day;
wire [7:0]   o_data_g_day;
wire [7:0]   o_data_b_day; 
wire [7:0]   o_data_r_night;
wire [7:0]   o_data_g_night;
wire [7:0]   o_data_b_night; 




always@(*)begin         
	if(switch1)begin
		o_data_r<=o_data_r_night		 ;
        o_data_g<=o_data_g_night 		 ;
        o_data_b<=o_data_b_night 		 ;
        o_vsync <= i_vsync				;         
    	o_data_valid <= i_data_valid;
	end else begin
		o_data_r<=i_data_r;
        o_data_g<=i_data_r;
        o_data_b<=i_data_r;
        o_vsync <= i_vsync;         
    	o_data_valid <= i_data_valid;
	end

end

Curve_Gamma_0P5 Curve_Gamma_r_night
(
   .Pre_Data        (i_data_r),
   .Post_Data       (o_data_r_night)
);

Curve_Gamma_0P5 Curve_Gamma_g_night
(
   .Pre_Data        (i_data_g),
   .Post_Data       (o_data_g_night)
);

Curve_Gamma_0P5 Curve_Gamma_b_night
(
   .Pre_Data        (i_data_b),
   .Post_Data       (o_data_b_night)
);

Curve_Gamma_1P2 Curve_Gamma_r_day
(
   .Pre_Data        (i_data_r),
   .Post_Data       (o_data_r_day)
);


Curve_Gamma_1P2 Curve_Gamma_g_day
(
   .Pre_Data        (i_data_g),
   .Post_Data       (o_data_g_day)
);

Curve_Gamma_1P2 Curve_Gamma_b_day
(
   .Pre_Data        (i_data_b),
   .Post_Data       (o_data_b_day)
);



endmodule
