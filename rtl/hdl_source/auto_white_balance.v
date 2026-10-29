

module auto_white_balance (
    input wire       I_clk,
    input wire       I_rst_n,

	input wire[19:0] I_r_gain,
    input wire[19:0] I_g_gain,
    input wire[19:0] I_b_gain,

    input wire       I_rgb888_frame_start,
    input wire       I_rgb888_frame_end,
    input wire       I_rgb888_valid,
    input wire[95:0] I_rgb888_data,

    output reg       O_awb_frame_start,
    output reg       O_awb_frame_end,
    output reg       O_awb_valid,
    output reg[95:0] O_awb_data
);


    reg        S_rgb888_valid_1d;
    reg        S_rgb888_valid_2d;

    wire[7:0]  S_r_data_p0;  
    wire[7:0]  S_g_data_p0;
    wire[7:0]  S_b_data_p0;
    wire[7:0]  S_r_data_p1;
    wire[7:0]  S_g_data_p1;
    wire[7:0]  S_b_data_p1;
    wire[7:0]  S_r_data_p2;
    wire[7:0]  S_g_data_p2;
    wire[7:0]  S_b_data_p2;
    wire[7:0]  S_r_data_p3;
    wire[7:0]  S_g_data_p3;
    wire[7:0]  S_b_data_p3;

    reg[27:0]  S_awb_r_data_p0;  ///fi(0,28,12)
    reg[27:0]  S_awb_g_data_p0;  ///fi(0,28,12)
    reg[27:0]  S_awb_b_data_p0;  ///fi(0,28,12)
    reg[27:0]  S_awb_r_data_p1;  ///fi(0,28,12)
    reg[27:0]  S_awb_g_data_p1;  ///fi(0,28,12)
    reg[27:0]  S_awb_b_data_p1;  ///fi(0,28,12)
    reg[27:0]  S_awb_r_data_p2;  ///fi(0,28,12)
    reg[27:0]  S_awb_g_data_p2;  ///fi(0,28,12)
    reg[27:0]  S_awb_b_data_p2;  ///fi(0,28,12)
    reg[27:0]  S_awb_r_data_p3;  ///fi(0,28,12)
    reg[27:0]  S_awb_g_data_p3;  ///fi(0,28,12)
    reg[27:0]  S_awb_b_data_p3;  ///fi(0,28,12)

    reg[7:0]   S_awb_r_data_p0_limit;   
    reg[7:0]   S_awb_g_data_p0_limit;  
    reg[7:0]   S_awb_b_data_p0_limit;  
    reg[7:0]   S_awb_r_data_p1_limit;  
    reg[7:0]   S_awb_g_data_p1_limit;  
    reg[7:0]   S_awb_b_data_p1_limit;  
    reg[7:0]   S_awb_r_data_p2_limit;  
    reg[7:0]   S_awb_g_data_p2_limit;  
    reg[7:0]   S_awb_b_data_p2_limit;  
    reg[7:0]   S_awb_r_data_p3_limit;  
    reg[7:0]   S_awb_g_data_p3_limit;  
    reg[7:0]   S_awb_b_data_p3_limit;  

 
    reg[31:0]  S_r_sum;  
    reg[31:0]  S_g_sum;  
    reg[31:0]  S_b_sum; 

    wire       S_r_div_out_valid; 
    wire[43:0] S_r_div_out;         
    reg[19:0]  S_r_gain;          ///fi(0,20,12)

    wire       S_g_div_out_valid; 
    wire[43:0] S_g_div_out;     
    reg[19:0]  S_g_gain;          ///fi(0,20,12)

    wire       S_b_div_out_valid; 
    wire[43:0] S_b_div_out;       
    reg[19:0]  S_b_gain;          ///fi(0,20,12)


    assign S_r_data_p0 = I_rgb888_data[95:88];
    assign S_g_data_p0 = I_rgb888_data[87:80];
    assign S_b_data_p0 = I_rgb888_data[79:72];

    assign S_r_data_p1 = I_rgb888_data[71:64];
    assign S_g_data_p1 = I_rgb888_data[63:56];
    assign S_b_data_p1 = I_rgb888_data[55:48];

    assign S_r_data_p2 = I_rgb888_data[47:40];
    assign S_g_data_p2 = I_rgb888_data[39:32];
    assign S_b_data_p2 = I_rgb888_data[31:24];

    assign S_r_data_p3 = I_rgb888_data[23:16];
    assign S_g_data_p3 = I_rgb888_data[15:8];
    assign S_b_data_p3 = I_rgb888_data[7:0];


    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_r_sum <= 'd0;
        else
            if(I_rgb888_frame_start)
                S_r_sum <= 'd0;
            else if(I_rgb888_valid)
                S_r_sum <= S_r_sum + S_r_data_p0 + S_r_data_p1 + S_r_data_p2 + S_r_data_p3;
            else    
                S_r_sum <= S_r_sum;
    end

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_g_sum <= 'd0;
        else
            if(I_rgb888_frame_start)
                S_g_sum <= 'd0;
            else if(I_rgb888_valid)
                S_g_sum <= S_g_sum + S_g_data_p0 + S_g_data_p1 + S_g_data_p2 + S_g_data_p3;
            else    
                S_g_sum <= S_g_sum;
    end

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_b_sum <= 'd0;
        else
            if(I_rgb888_frame_start)
                S_b_sum <= 'd0;
            else if(I_rgb888_valid)
                S_b_sum <= S_b_sum + S_b_data_p0 + S_b_data_p1 + S_b_data_p2 + S_b_data_p3;
            else    
                S_b_sum <= S_b_sum;
    end

    /*
        求R通道增益
        r_average = r_sum / (1920*1080)

        r_gain    = 100 / r_average 
                  = 100 / (r_sum / (1920*1080)) 
                  = (100*1920*1080) / r_sum
                  = 207,360,000 / r_sum
                  = 32'hC5C1000 / r_sum
        
        由于除法器无法计算得到小数，因此将分子左移12位扩大，然后得到的商低12位即为小数位，
        因此：
        r_gain = 44'hC5C1000000 / r_sum
    */
    unsigned32_unsigned32_divider ur_unsigned32_unsigned32_divider(
        .clk         ( I_clk              ),
        .rst         ( ~I_rst_n           ),

        .start       ( I_rgb888_frame_end ),
        .numerator   ( 44'hC5C1000000    ),
        .denominator ( S_r_sum            ),

        .done        ( S_r_div_out_valid  ),
        .quotient    ( S_r_div_out        ),
        .remainder   ( )
    );

    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_r_gain <= 'd0;
        else
            if(S_r_div_out_valid)
                S_r_gain <= S_r_div_out[19:0];
            else
                S_r_gain <= S_r_gain;
    end

    /*
        求G通道增益
        g_average = g_sum / (3840*2160)

        g_gain    = 100 / g_average 
                  = 100 / (g_sum / (3840*2160)) 
                  = (100*3840*2160) / g_sum
                  = 829440000 / g_sum
                  = 32'h31704000 / g_sum
        
        由于除法器无法计算得到小数，因此将分子左移12位扩大，然后得到的商低12位即为小数位，
        因此：
        g_gain = 44'h31704000000 / g_sum
    */
    unsigned32_unsigned32_divider ug_unsigned32_unsigned32_divider(
        .clk         ( I_clk              ),
        .rst         ( ~I_rst_n           ),

        .start       ( I_rgb888_frame_end ),
        .numerator   ( 44'hC5C1000000    ),
        .denominator ( S_g_sum            ),

        .done        ( S_g_div_out_valid  ),
        .quotient    ( S_g_div_out        ),
        .remainder   ( )
    );


    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_g_gain <= 'd0;
        else
            if(S_g_div_out_valid)
                S_g_gain <= S_g_div_out[19:0];
            else
                S_g_gain <= S_g_gain;
    end

    /*
        求B通道增益
        b_average = b_sum / (3840*2160)

        b_gain    = 100 / b_average 
                  = 100 / (b_sum / (3840*2160)) 
                  = (100*3840*2160) / b_sum
                  = 829440000 / b_sum
                  = 32'h31704000 / b_sum
        
        由于除法器无法计算得到小数，因此将分子左移12位扩大，然后得到的商低12位即为小数位，
        因此：
        b_gain = 44'h31704000000 / b_sum
    */
    unsigned32_unsigned32_divider ub_unsigned32_unsigned32_divider( 
        .clk         ( I_clk              ),
        .rst         ( ~I_rst_n           ),

        .start       ( I_rgb888_frame_end ),
        .numerator   ( 44'hC5C1000000    ),
        .denominator ( S_b_sum            ),

        .done        ( S_b_div_out_valid  ),
        .quotient    ( S_b_div_out        ),
        .remainder   ( )
    );


    always @(posedge I_clk or negedge I_rst_n) begin
        if(!I_rst_n)
            S_b_gain <= 'd0;
        else
            if(S_b_div_out_valid)
                S_b_gain <= S_b_div_out[19:0];
            else
                S_b_gain <= S_b_gain;
    end


//    always @(posedge I_clk) begin
//        if(I_rgb888_valid)
//            begin
//                S_awb_r_data_p0 <= S_r_data_p0 * S_r_gain; 
//                S_awb_g_data_p0 <= S_g_data_p0 * S_g_gain;
//                S_awb_b_data_p0 <= S_b_data_p0 * S_b_gain;

//                S_awb_r_data_p1 <= S_r_data_p1 * S_r_gain;
//                S_awb_g_data_p1 <= S_g_data_p1 * S_g_gain;
//                S_awb_b_data_p1 <= S_b_data_p1 * S_b_gain;

//                S_awb_r_data_p2 <= S_r_data_p2 * S_r_gain;
//                S_awb_g_data_p2 <= S_g_data_p2 * S_g_gain;
//                S_awb_b_data_p2 <= S_b_data_p2 * S_b_gain;

//                S_awb_r_data_p3 <= S_r_data_p3 * S_r_gain;
//                S_awb_g_data_p3 <= S_g_data_p3 * S_g_gain;
//                S_awb_b_data_p3 <= S_b_data_p3 * S_b_gain;
//            end
//        else
//            begin
//                S_awb_r_data_p0 <= 'd0; 
//                S_awb_g_data_p0 <= 'd0;
//                S_awb_b_data_p0 <= 'd0;

//                S_awb_r_data_p1 <= 'd0;
//                S_awb_g_data_p1 <= 'd0;
//                S_awb_b_data_p1 <= 'd0;

//                S_awb_r_data_p2 <= 'd0;
//                S_awb_g_data_p2 <= 'd0;
//                S_awb_b_data_p2 <= 'd0;

//                S_awb_r_data_p3 <= 'd0;
//                S_awb_g_data_p3 <= 'd0;
//                S_awb_b_data_p3 <= 'd0;
//            end
//    end

	always @(posedge I_clk) begin
        if(I_rgb888_valid)
            begin
//                S_awb_r_data_p0 <= S_r_data_p0 * 20'h00C00; 
//                S_awb_g_data_p0 <= S_g_data_p0 * 20'h00C00;
//                S_awb_b_data_p0 <= S_b_data_p0 * 20'h01000;

//                S_awb_r_data_p1 <= S_r_data_p1 * 20'h00C00;
//                S_awb_g_data_p1 <= S_g_data_p1 * 20'h00C00;
//                S_awb_b_data_p1 <= S_b_data_p1 * 20'h01000;

//                S_awb_r_data_p2 <= S_r_data_p2 * 20'h00C00;
//                S_awb_g_data_p2 <= S_g_data_p2 * 20'h00C00;
//                S_awb_b_data_p2 <= S_b_data_p2 * 20'h01000;

//                S_awb_r_data_p3 <= S_r_data_p3 * 20'h00C00;
//                S_awb_g_data_p3 <= S_g_data_p3 * 20'h00C00;
//                S_awb_b_data_p3 <= S_b_data_p3 * 20'h01000;
                S_awb_r_data_p0 <= S_r_data_p0 * I_r_gain; 
                S_awb_g_data_p0 <= S_g_data_p0 * I_g_gain;
                S_awb_b_data_p0 <= S_b_data_p0 * I_b_gain;

                S_awb_r_data_p1 <= S_r_data_p1 * I_r_gain;
                S_awb_g_data_p1 <= S_g_data_p1 * I_g_gain;
                S_awb_b_data_p1 <= S_b_data_p1 * I_b_gain;

                S_awb_r_data_p2 <= S_r_data_p2 * I_r_gain;
                S_awb_g_data_p2 <= S_g_data_p2 * I_g_gain;
                S_awb_b_data_p2 <= S_b_data_p2 * I_b_gain;

                S_awb_r_data_p3 <= S_r_data_p3 * I_r_gain;
                S_awb_g_data_p3 <= S_g_data_p3 * I_g_gain;
                S_awb_b_data_p3 <= S_b_data_p3 * I_b_gain;
            end
        else
            begin
                S_awb_r_data_p0 <= 'd0; 
                S_awb_g_data_p0 <= 'd0;
                S_awb_b_data_p0 <= 'd0;

                S_awb_r_data_p1 <= 'd0;
                S_awb_g_data_p1 <= 'd0;
                S_awb_b_data_p1 <= 'd0;

                S_awb_r_data_p2 <= 'd0;
                S_awb_g_data_p2 <= 'd0;
                S_awb_b_data_p2 <= 'd0;

                S_awb_r_data_p3 <= 'd0;
                S_awb_g_data_p3 <= 'd0;
                S_awb_b_data_p3 <= 'd0;
            end
    end


    always @(posedge I_clk) begin
        S_awb_r_data_p0_limit <= (S_awb_r_data_p0[27:12] >= 16'd255) ? 8'd255 : S_awb_r_data_p0[19:12]; 
        S_awb_g_data_p0_limit <= (S_awb_g_data_p0[27:12] >= 16'd255) ? 8'd255 : S_awb_g_data_p0[19:12]; 
        S_awb_b_data_p0_limit <= (S_awb_b_data_p0[27:12] >= 16'd255) ? 8'd255 : S_awb_b_data_p0[19:12]; 

        S_awb_r_data_p1_limit <= (S_awb_r_data_p1[27:12] >= 16'd255) ? 8'd255 : S_awb_r_data_p1[19:12]; 
        S_awb_g_data_p1_limit <= (S_awb_g_data_p1[27:12] >= 16'd255) ? 8'd255 : S_awb_g_data_p1[19:12]; 
        S_awb_b_data_p1_limit <= (S_awb_b_data_p1[27:12] >= 16'd255) ? 8'd255 : S_awb_b_data_p1[19:12]; 

        S_awb_r_data_p2_limit <= (S_awb_r_data_p2[27:12] >= 16'd255) ? 8'd255 : S_awb_r_data_p2[19:12]; 
        S_awb_g_data_p2_limit <= (S_awb_g_data_p2[27:12] >= 16'd255) ? 8'd255 : S_awb_g_data_p2[19:12]; 
        S_awb_b_data_p2_limit <= (S_awb_b_data_p2[27:12] >= 16'd255) ? 8'd255 : S_awb_b_data_p2[19:12]; 

        S_awb_r_data_p3_limit <= (S_awb_r_data_p3[27:12] >= 16'd255) ? 8'd255 : S_awb_r_data_p3[19:12]; 
        S_awb_g_data_p3_limit <= (S_awb_g_data_p3[27:12] >= 16'd255) ? 8'd255 : S_awb_g_data_p3[19:12]; 
        S_awb_b_data_p3_limit <= (S_awb_b_data_p3[27:12] >= 16'd255) ? 8'd255 : S_awb_b_data_p3[19:12]; 
    end

    always @(posedge I_clk) begin
        S_rgb888_valid_1d <= I_rgb888_valid;
        S_rgb888_valid_2d <= S_rgb888_valid_1d;
        O_awb_valid       <= S_rgb888_valid_2d;

        O_awb_frame_start <= I_rgb888_frame_start;
        O_awb_frame_end   <= I_rgb888_frame_end;

        O_awb_data        <= {S_awb_r_data_p0_limit,S_awb_g_data_p0_limit,S_awb_b_data_p0_limit,
                              S_awb_r_data_p1_limit,S_awb_g_data_p1_limit,S_awb_b_data_p1_limit,
                              S_awb_r_data_p2_limit,S_awb_g_data_p2_limit,S_awb_b_data_p2_limit,
                              S_awb_r_data_p3_limit,S_awb_g_data_p3_limit,S_awb_b_data_p3_limit};
    end


    
endmodule