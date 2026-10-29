`timescale 1ns / 1ps
module watermark_logo
(
	input   wire				i_clk,
	input   wire				i_rst_n,
	input	wire				switch ,
	input	wire				i_hsyn,
	input	wire				i_vsyn,
	input	wire				i_en_pos,
	input	wire [7:0]			i_r,
	input	wire [7:0] 			i_g,
	input	wire [7:0] 			i_b,		
	input   wire 				water_select0,	
	output	reg					o_hs,
	output	reg					o_vs,
	output	reg					o_en,	
	output reg [7:0]			o_r,
	output reg [7:0]			o_g,
	output reg [7:0]			o_b	
);

parameter  H_ACTIVE 		= 234; //水印区域宽度                              
parameter  V_ACTIVE 		= 153;  //水印区域高度
/*
reg water_select1;
always@(posedge i_clk or negedge i_rst_n)begin
	if(!i_rst_n)begin
		water_select1<=water_select0;
	end
end

reg	flag;
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        flag <= 1'd0;
    end else begin
        flag <= (~water_select1) && (water_select0);
    end
end

reg [1:0]	water_select;
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        water_select <= 2'd0;
    end else if (flag) begin
        if (water_select == 2'd1) begin
            water_select <= 2'd0;
        end else begin
            water_select <= water_select + 2'd1;
        end
    end
end
*/
reg [10:0] BEGIN_X,BEGIN_Y;
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        BEGIN_X <= 11'd50;
        BEGIN_Y <= 11'd20;
    /*
    end else begin
        case (water_select)
            2'd0: begin
                BEGIN_X <= 11'd50;
                BEGIN_Y <= 11'd20;
            end
            2'd1: begin
                BEGIN_X <= 11'd100;
                BEGIN_Y <= 11'd50;
            end
	       	2'd2: begin
                BEGIN_X <= 11'd150;
                BEGIN_Y <= 11'd100;
            end
        endcase
        */
    end
end


reg  [10:0] 	    h_cnt;
reg  [10:0] 	    v_cnt;
reg  [10:0] 	    x_pos;
reg  [10:0] 	    y_pos;
reg  [18:0] 		rd_addr;
reg					o_de;
reg					o_de1;
reg 				hsyn_d0;
reg					vsyn_d0;
reg					en_pos_d0;
reg 				hsyn_d1;
reg					vsyn_d1;
reg					en_pos_d1;


reg  [7:0]  		r_d;
reg  [7:0]  		g_d;
reg  [7:0]  		b_d;

reg  [7:0]  		r_d1;
reg  [7:0]  		g_d1;
reg  [7:0]  		b_d1;

wire [7:0]  		r_d0;
wire [7:0]  		g_d0;
wire [7:0]  		b_d0;
wire   				de_d0;//显示区域使能信号


// assign o_r   = o_de ? r_d0 : 8'hff;
// assign o_g   = o_de ? g_d0 : 8'hff;
// assign o_b   = o_de ? b_d0 : 8'hff;
//r_d1为视频数据，r_d0为水印数据
always@(*)begin
	if(switch)begin 
/*		if(water_select==2'd0)begin
			if(de_d0)begin
				if({r_first,g_first,b_first}==1'b0)begin
					o_r<=r_d1;
					o_g<=g_d1;
					o_b<=b_d1;			
				end else begin
					o_r<=r_first;
    		        o_g<=g_first;
    		        o_b<=b_first;
				end	
			end else begin
				o_r<=r_d1;	
    		    o_g<=g_d1;
    		    o_b<=b_d1;
				end	
/*		end else if(water_select==2'd1)begin
			if(de_d0)begin
				if({r_second,g_second,b_second}==1'b0)begin
					o_r<=r_d1;
					o_g<=g_d1;
					o_b<=b_d1;			
				end else begin
					o_r<=r_second;
    		        o_g<=g_second;
    		        o_b<=b_second;
				end	
			end else begin
				o_r<=r_d1;	
    		    o_g<=g_d1;
    		    o_b<=b_d1;
			end	
*/	
//	end else if(water_select==2'd1)begin 
			if(de_d0)begin
				if({r_al,g_al,b_al}==1'b0)begin
					o_r<=r_d1;
					o_g<=g_d1;
					o_b<=b_d1;			
				end else begin
					o_r<=r_al;
    		        o_g<=g_al;
    		        o_b<=b_al;
				end	
			end else begin
				o_r<=r_d1;	
    		    o_g<=g_d1;
    		    o_b<=b_d1;
				end	
               
	end else begin
			o_r<=i_r;	
    	    o_g<=i_g;
    	    o_b<=i_b;		
	end
//	end
end
always@( *)begin
	if(switch)begin
		o_hs  <= hsyn_d1;
		o_vs  <= vsyn_d1;
		o_en  <= en_pos_d1;
	end else begin
		o_hs  <= i_hsyn;
		o_vs  <= i_vsyn;
		o_en  <= i_en_pos;
	end
end


assign de_d0 = i_en_pos && (x_pos >= BEGIN_X)&&(x_pos < BEGIN_X + H_ACTIVE)&&
                           (y_pos >= BEGIN_Y)&&(y_pos < BEGIN_Y + V_ACTIVE) ? 1'b1:1'b0;

//同步输出使能信号
always@(posedge i_clk ) 
begin	
	hsyn_d0		<= i_hsyn;
	vsyn_d0		<= i_vsyn;
	en_pos_d0	<= i_en_pos;
	hsyn_d1		<= hsyn_d0;	
	vsyn_d1		<= vsyn_d0;	
	en_pos_d1	<= en_pos_d0;	
	r_d			<= i_r;
	g_d			<= i_g;
	b_d			<= i_b;
	r_d1		<= r_d;
	g_d1		<= g_d;
	b_d1		<= b_d;	
end

//x计数
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        x_pos <= 11'd0;
    end
    else if(i_en_pos)
	begin
		if(x_pos == 1920 - 1'b1)
			x_pos <= 11'd0;
		else 
			x_pos <= x_pos + 11'd1;
    end
end

//y计数
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        y_pos <= 11'd0;
    end
    else if(!i_en_pos && en_pos_d0)	
	begin
		if(y_pos == 1080 - 1'b1)
			y_pos <= 11'd0;
		else 
			y_pos <= y_pos + 11'd1;
    end
end
//显示区域行计数
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        h_cnt <= 11'd0;
    end
    else if(de_d0)
	begin
		if(h_cnt == H_ACTIVE - 1'b1)
			h_cnt <= 11'd0;
		else 
			h_cnt <= h_cnt + 11'd1;
    end
end

//显示区域场计数
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        v_cnt <= 11'd0;
    end
    else if(h_cnt == H_ACTIVE - 1'b1)
	begin
		if(v_cnt == V_ACTIVE - 1'b1)
			v_cnt <= 11'd0;
		else 
			v_cnt <= v_cnt + 11'd1;
    end
end
/*
wire [7:0] r_first,g_first,b_first;
first first_inst
(
    .clka(i_clk),
    .ocea(o_de),
    .addra(rd_addr),
    .doa({r_first,g_first,b_first})	
);
*/
/*
wire [7:0] r_second,g_second,b_second;
second second_inst
(
    .clka(i_clk),
    .ocea(o_de),
    .addra(rd_addr),
    .doa({r_second,g_second,b_second})	
);
*/

wire [7:0] r_al,g_al,b_al;
watermark_anlogic watermark_anlogic_inst
(
    .clka(i_clk),
    .ocea(o_de),
    .addra(rd_addr),
    .doa({r_al,g_al,b_al})	
);

//读取地址更新
always@(posedge i_clk or negedge i_rst_n) 
begin
    if(!i_rst_n)
	begin
        rd_addr <= 'd0;
    end
    else if(de_d0)
	begin
		rd_addr <= v_cnt * H_ACTIVE + h_cnt;
    end
end

//同步输出使能信号
always@(posedge i_clk ) 
begin
	o_de 	<= de_d0;
	o_de1 	<= o_de;	
end

endmodule