
`define DRAM_BYTE_NUM 4
`define ALC_MC_32B
`define AXI
//`define STG 
`define APP_ADDR_WIDTH   27



module design_top_wrapper (
    /*
        input 25MHz system clock
    */
    input wire       I_sys_clk_25m,


    /*
        external key trig input 
    */
    input wire       I_key_in,
 	input wire		 I_key_select,
     
    output wire         	 sdio_clk,
    inout                    cmd_io,
    inout  wire    [3:0]     data_io,
    /*
        soft mcu jtag interface
    */
    /*
    input wire       I_mcu_jtag_tms,
    input wire       I_mcu_jtag_tdi,
    output wire      O_mcu_jtag_tdo,
    input wire       I_mcu_jtag_tck,
    */

    /*
        soft mcu uart
    */
    output wire      O_mcu_uart_tx,
    input wire       I_mcu_uart_rx,
    
	output wire      O_mcu_crtl_tx,
    input wire       I_mcu_crtl_rx,
    /*
        camera sc2210 iic configure interface
    */
    inout wire       IO_sc2210_scl,
    inout wire       IO_sc2210_sda,
 
    /*
        camera sc2210 24mhz clk
    */
	output wire      O_sc2210_clk_27m,

	output wire      O_sc2210_rst_n,

	inout wire       IO_led,
    ///hdmi tmds channel signal N
	output [2:0]O_hdmi_tx_p, //HDMI输出数据P端
	output [2:0]O_hdmi_tx_n,  //HDMI输出数据N端
    output O_hdmi_clk_p,     //HDMI输出时钟P端
	output O_hdmi_clk_n,     //HDMI输出时钟N端
    
    
    output wire 	 fan_pwm,
	output	wire LED_INIT

);
assign led = cnn_valid;
	wire        S_sys_clk;
    wire        S_hdmi_clk;//synthesis keep
    wire		S_serial_clk;
    wire 		I_ddr_clk;
 
    wire[19:0]  S_user_apb_PADDR;      
    wire        S_user_apb_PSEL;       
    wire        S_user_apb_PENABLE;    
    wire        S_user_apb_PWRITE;     
    wire[31:0]  S_user_apb_PWDATA;     
    wire        S_user_apb_PREADY;    
    wire[31:0]  S_user_apb_PRDATA;    
    wire        S_user_apb_PSLVERROR; 
    wire        S_user_apb_int;       
 
    wire[31:0]  S_mcu_gpio_in;
    wire[31:0]  S_mcu_gpio_out;
    wire[31:0]  S_mcu_gpio_out_en;

    wire        S_clk_70m;

    wire        S_configure_load_en;                
    wire        S_configure_done;                   
    wire[13:0]  S_HTOTAL;                           
    wire[13:0]  S_HSA;                              
    wire[13:0]  S_HFP;                              
    wire[13:0]  S_HBP;                              
    wire[13:0]  S_HACTIVE;                          
    wire[13:0]  S_VTOTAL;                           
    wire[13:0]  S_VSA;                              
    wire[13:0]  S_VFP;                              
    wire[13:0]  S_VBP;                              
    wire[13:0]  S_VACTIVE;                          
    wire        S_hdcp_en;                          
    wire        S_video_test_source_en;                         
    wire[6:0]   S_video_VIC;                               
    wire[1:0]   S_pixel_color_deep;                        
    wire[2:0]   S_video_format;                            
    wire[1:0]   S_pixel_num_per_clock;                 
    wire        S_data_over_sample_en;    
    wire[19:0]  S_audio_clock_regeneration_CTS;            
    wire[19:0]  S_audio_clock_regeneration_N;               
    wire[2:0]   S_audio_channel_number;                    
    wire[2:0]   S_audio_sample_rate;                       

    wire        S_serdes_config_load_en;                 
    wire[1:0]   S_serdes_data_width_sel;                 
    wire[2:0]   S_serdes_tx_rate;                        
    wire[23:0]  S_serdes_ref_clk_freq;                   
    wire[15:0]  S_serdes_line_rate;                      
    wire        S_serdes_mpll_sel;                       
    wire[1:0]   S_serdes_mpll_tx_clk_div;                
    wire[7:0]   S_serdes_mpll_multiplier;                
    wire        S_serdes_config_done;      

    wire        S_serdes_configure_load_en;         
 
	wire        S_pll_lock;

    wire[19:0]  S_awb_r_gain;
    wire[19:0]  S_awb_g_gain;
    wire[19:0]  S_awb_b_gain;
 
    wire[8:0]   S_data_lane3_idelay;
    wire[8:0]   S_data_lane1_idelay;
    wire[8:0]   S_data_lane2_idelay;
    wire[8:0]   S_data_lane0_idelay;
    wire[8:0]   S_clk_lane_idelay;  
    wire[9:0]   S_camera_black_level;
    wire        S_hdmi_tpg_en;

    wire        S_hs_rx_clk;           //synthesis keep  
    wire        S_hs_rx_valid;         //synthesis keep  
    wire[31:0]  S_hs_rx_data;          //synthesis keep
 
    wire        S_csi_frame_start;  //synthesis keep      
    wire        S_csi_frame_end;  //synthesis keep         
    wire        S_csi_valid;  //synthesis keep           
    wire[31:0]  S_csi_data;          
 
    wire        S_raw8_frame_start; 
    wire        S_raw8_frame_end;   
    wire        S_raw8_valid;   //synthesis keep    
    wire[31:0]  S_raw8_data;   //synthesis keep     
 
    wire        S_raw8_cut_frame_start;  
    wire        S_raw8_cut_frame_end;    
    wire        S_raw8_cut_valid;        
    wire[31:0]  S_raw8_cut_data;       
 
    wire        S_rgb888_frame_start;
    wire        S_rgb888_frame_end;
    wire        S_rgb888_valid;      
    wire[95:0]  S_rgb888_data;        

    wire        S_awb_frame_start;    //synthesis keep
    wire        S_awb_frame_end;      //synthesis keep
    wire        S_awb_valid;          //synthesis keep
    wire[95:0]  S_awb_data;           //synthesis keep

    wire        S_mipi_rx_error;         //synthesis keep

    wire        S_vi_256b_frame_start;   //synthesis keep
    wire        S_vi_256b_valid;         //synthesis keep
    wire[255:0] S_vi_256b_data;       

    wire        S_video_out_rd_busy;
    wire        S_video_in_wr_busy; 
    wire[1:0]   S_video_out_rp;     

    wire        S_ddr_user_wr_en;        //synthesis keep
    wire        S_ddr_user_rd_en;        //synthesis keep
    wire[27:0]  S_ddr_user_addr;         //synthesis keep
    wire[255:0] S_ddr_user_wr_data;      //synthesis keep
    wire        S_ddr_user_ready;        //synthesis keep
    wire        S_ddr_user_rd_valid;     //synthesis keep
    wire[255:0] S_ddr_user_rd_data;      //synthesis keep

    wire        S_vi_ddr_wr_en;   
    wire[27:0]  S_vi_ddr_wr_addr; 
    wire[255:0] S_vi_ddr_wr_data;
    wire        S_vi_ddr_wr_ready;

    wire        S_vo_ddr_rd_en;   
    wire[27:0]  S_vo_ddr_rd_addr; 
    wire        S_vo_ddr_rd_ready;

    wire        S_video_source_vsync;
    wire        S_video_source_user; 
    wire        S_video_source_valid;
    wire        S_video_source_last; 

    wire        S_vdieo_rd_en;  
    wire[95:0]  S_video_rd_data;

    wire        S_mixer_user; 
    wire        S_mixer_valid;  
    wire        S_mixer_last;   
    wire[23:0] S_mixer_data;   

    reg[9:0]    S_hdmi_config_cnt;
    reg         S_serdes_config_done_1d;

    wire        S_ddr_clk;       //synthesis keep

    wire        S_init_calib_complete;  
    wire[27:0]  S_mc_app_addr;          
    wire[2:0]   S_mc_app_cmd;           
    wire        S_mc_app_en;            
    wire[255:0] S_mc_app_wdf_data;      
    wire        S_mc_app_wdf_end;       
    wire[31:0]  S_mc_app_wdf_mask;      
    wire        S_mc_app_wdf_wren;      
    wire[255:0] S_mc_app_rd_data;       
    wire        S_mc_app_rd_data_end;   
    wire        S_mc_app_rd_data_valid; 
    wire        S_mc_app_rdy;           
    wire        S_mc_app_wdf_rdy;       

	wire[3:0]   S_lane_error;
    
    wire[9:0]   S_ts_tempture;
    
    wire  S_fifo_empty;
    wire  S_fifo_rd_valid;
    wire  S_fifo_frame_start;
    wire[9:0]  S_fifo_rd_num;
    wire[9:0]  S_fifo_wr_num;

    wire [23:0]  S_fifo_rd_data;
    reg         S_fifo_rd_en;
    
    wire 			S_csi_rx_vsync0;//synthesis keep
	wire 			S_csi_rx_hsync0;//synthesis keep

    wire [7:0] wbuf_sync_o,rbuf_sync_o,wbuf_sync_o1,rbuf_sync_o1,wbuf_sync_o2,rbuf_sync_o2,wbuf_sync_o3,wbuf_sync_o4,wbuf_sync_o5,rbuf_sync_o3,rbuf_sync_o4,rbuf_sync_o5,wbuf_sync_o01;
    wire [7:0] wbuf_sync_o12,rbuf_sync_o01,rbuf_sync_o017;
    reg  ud_rfifo_en;
    
    wire   vtc_rstn ;
    wire   vtc_clk;
    wire   vtc_vs;//synthesis keep
    wire   vtc_hs;//synthesis keep
    //wire   vtc_user;//synthesis keep
    wire   vtc_de_valid;//synthesis keep
    //wire   vtc_last;////synthesis keep
   
    wire S_rst;
    wire [7 :0]	rgb_r ,rgb_g ,rgb_b;// 定义寄存器保存图像的颜色数据
    assign vtc_clk = S_hdmi_clk; // 内部像素时钟
    assign vtc_rstn = S_pll_lock; //用PLL 的LOCK信号复位
    assign S_rst = ~S_pll_lock;


    wire ud_wclk,ud_wvs,ud_wde,ud_wde1,ud_wde2,ud_wde3,ud_wde4,ud_wde5;
    wire [31:0] ud_wdata,ud_wdata1,ud_wdata2,ud_wdata3,ud_wdata4,ud_wdata5;//synthesis keep
    wire ud_rclk,ud_rvs,ud_rde,ud_rde1,ud_rde2,ud_rde3,ud_rde4,ud_rde5;
    wire [31:0] ud_rdata,ud_rdata1,ud_rdata2,ud_rdata3,ud_rdata4,ud_rdata5;//synthesis keep
    wire [31:0] ud_rdata_dif;
    wire [23:0] video_hdmi_data;

reg [47:0]data;
wire flag,uart_flag;
wire [47:0]data_o1;
reg  [47:0]data_o1_r,data_o2_r;
reg  flag_r,uart_flag_r;
reg  [47:0]data_o11;
ctrl ctrl_inst1
(
    .sys_clk    (I_sys_clk_25m	) ,   //系统时钟，50MHz
    .sys_rst_n  (vtc_rstn	) ,   //复位信号，低有效
    .rx         (I_mcu_uart_rx	) ,   //串口接收数据
	.po_data       (data_o1	),
    .po_flag(flag)
 );
/*
always@(*)begin
	data<=data1;
end
*/
reg stop_cont,read_sd_cmd;
wire [47:0]data_o2;
reg del,u_del;
ctrl ctrl_inst2
(
    .sys_clk    (I_sys_clk_25m	) ,   //系统时钟，50MHz
    .sys_rst_n  (vtc_rstn	) ,   //复位信号，低有效
    .rx         (I_mcu_crtl_rx	) ,   //串口接收数据
    .po_flag    (uart_flag),
	.po_data       (data_o2	)
 );
 reg [1:0] read_sdcnt;
always@(posedge I_sys_clk_25m)begin
	if (S_rst) begin
    	data <= 1'b0;
        stop_cont <= 1'b0;
        read_sd_cmd <= 1'b0;
        read_sdcnt <= 1'b0;
        del <= 0;
        u_del <= 0;
    end else begin
    	if (flag_reg) begin
    		if (data_o1[36])begin
        		data_o11 <= data;
                stop_cont <= 1'b1;
            end else if (data_38_edg) begin
            	read_sd_cmd <= !read_sd_cmd;
            end else if (data_37_edg) begin
            	if (read_sdcnt < 2) 
                	read_sdcnt <= read_sdcnt + 1'b1;
                else
                	read_sdcnt <= 1'b0;
            end else if (data_23_edg || data_23_neg) begin
            	del <= 1;
            end else begin
            	if (stop_cont) begin 
                	stop_cont <= 1'b0;
                end else
                	data <= data_o1;
            end
        end else if (uart_flag_reg) begin
    		if (data_o2[36])begin
        		data_o11 <= data;
                stop_cont <= 1'b1;
            end else if (uart_data_38_edg) begin
            	read_sd_cmd <= !read_sd_cmd;
            end else if (uart_data_37_edg) begin
            	if (read_sdcnt < 2) 
                	read_sdcnt <= read_sdcnt + 1'b1;
                else
                	read_sdcnt <= 1'b0;
            end else if (uart_data_23_edg || uart_data_23_neg) begin
            	u_del <= 1;
            end else begin
            	if (stop_cont) begin 
                	stop_cont <= 1'b0;
                end else
                	data <= data_o2;
            end
        end
    end
end
always@(posedge I_sys_clk_25m)begin
	data_o1_r <= data_o1;
    data_o2_r <= data_o2;
    flag_r <= flag;
    uart_flag_r <= uart_flag;
    cam_vs_r <= S_csi_rx_vsync0;
    cmd2_r <= ddr_sd_cmd2;
end
wire data_36_edg,data_37_edg,data_38_edg,data_39_edg,flag_reg,uart_flag_reg,data_23_edg,data_23_neg;
wire uart_data_36_edg,uart_data_37_edg,uart_data_38_edg,uart_data_39_edg,uart_data_23_edg,uart_data_23_neg;
wire cam_vs_edg,cmd2_edg;

assign data_36_edg = !data_o1_r[36] && data_o1[36];
assign data_37_edg = !data_o1_r[37] && data_o1[37];
assign data_38_edg = !data_o1_r[38] && data_o1[38];
assign data_39_edg = !data_o1_r[39] && data_o1[39];
assign data_23_edg = !data_o1_r[23] && data_o1[23];
assign data_23_neg = data_o1_r[23] && !data_o1[23];

assign uart_data_36_edg = !data_o2_r[36] && data_o2[36];
assign uart_data_37_edg = !data_o2_r[37] && data_o2[37];
assign uart_data_38_edg = !data_o2_r[38] && data_o2[38];
assign uart_data_39_edg = !data_o2_r[39] && data_o2[39];
assign uart_data_23_edg = !data_o2_r[23] && data_o2[23];
assign uart_data_23_neg = data_o2_r[23] && !data_o2[23];
assign flag_reg    = !flag_r && flag;
assign uart_flag_reg    = !uart_flag_r && uart_flag;

assign cam_vs_edg = !cam_vs_r && S_csi_rx_vsync0;
assign cmd2_edg = !cmd2_r && ddr_sd_cmd2;
reg ddr_sd_cmd1,ddr_sd_cmd2,ddr_sd_cmd3;
reg cam_vs_r,cmd2_r;
always @(posedge I_sys_clk_25m) begin
	if (S_rst) begin
    	ddr_sd_cmd1 <= 1'b0;
        ddr_sd_cmd2 <= 1'b0;
        ddr_sd_cmd3 <= 1'b0;
    end else if (data_39_edg || uart_data_39_edg) begin
    	ddr_sd_cmd1 <= 1'b1;
    end else if (cam_vs_edg && ddr_sd_cmd1) begin
    	ddr_sd_cmd2 <= 1'b1;
        ddr_sd_cmd1 <= 1'b0;
    end else if (cam_vs_edg && ddr_sd_cmd2) begin	
    	ddr_sd_cmd2 <= 1'b0;
        ddr_sd_cmd3 <= 1'b1;
    end else if (ddr_sd_cmd3) begin
    	ddr_sd_cmd3 <= 1'b0;
    end
end
reg [7:0] stay_sd;
always @(posedge I_sys_clk_25m) begin
	if (S_rst) begin
    	stay_sd <= 1'b0;
    end else begin
    	if (cmd2_edg) begin
        	if (stay_sd < 2) begin
            	stay_sd <= stay_sd + 1;
            end else begin
            	stay_sd <= 0;
            end
        end
    end
end

reg [7:0]HDMI_R;
reg [7:0]HDMI_G;
reg [7:0]HDMI_B;
reg      HDMI_VS,HDMI_HS,HDMI_DE;
always @(posedge vtc_clk or negedge vtc_rstn) begin
	if(!vtc_rstn) begin
		HDMI_R<=1'b0;
		HDMI_G<=1'b0;
		HDMI_B<=1'b0;
	end else begin
		case(data[47:40])
			8'd0:begin	//raw数据
				HDMI_R<=ud_rdata_d1;
                HDMI_G<=ud_rdata_d1;
                HDMI_B<=ud_rdata_d1;
				HDMI_VS<=~vtc_vs;
				HDMI_HS<=vtc_de_valid_d1;
				HDMI_DE<=vtc_de_valid_d1;			
			end
			8'd1:begin	//去马赛克
				HDMI_R<=w_rgb_r;
                HDMI_G<=w_rgb_g;
                HDMI_B<=w_rgb_b; 
				HDMI_VS<=w_rgb_vsync;
				HDMI_HS<=w_rgb_href;
				HDMI_DE<=w_rgb_href;
			end
			8'd2:begin	//白平衡
				HDMI_R<=w_awb_r;
                HDMI_G<=w_awb_g;
                HDMI_B<=w_awb_b;    
				HDMI_VS<=w_awb_vs;
				HDMI_HS<=w_awb_hs;
				HDMI_DE<=w_awb_de;
			end
			8'd3:begin	//色彩校正
				HDMI_R<=w_ccm_r;
                HDMI_G<=w_ccm_g;
                HDMI_B<=w_ccm_b;    
				HDMI_VS<=w_ccm_vs;
				HDMI_HS<=w_ccm_hs;
				HDMI_DE<=w_ccm_de;
			end
            8'd4:begin	//伽马变换
				HDMI_R<=gamma_r;
                HDMI_G<=gamma_g;
                HDMI_B<=gamma_b;
				HDMI_VS<=gamma_vs;
				HDMI_HS<=gamma_de;
				HDMI_DE<=gamma_de;
			end 
            8'd5:begin	//对比度
				HDMI_R<=contrast_r;
                HDMI_G<=contrast_g;
                HDMI_B<=contrast_b;
				HDMI_VS<=contrast_vs;
				HDMI_HS<=contrast_de;
				HDMI_DE<=contrast_de;
			end  
            8'd6:begin	//缩放
            	HDMI_R<=sc_data[23:16];
                HDMI_G<=sc_data[15:8];
                HDMI_B<=sc_data[7:0];
				HDMI_VS<=~vtc_vs;
				HDMI_HS<=vtc_de_valid;
				HDMI_DE<=vtc_de_valid;
            end
            
            8'd7:begin	//锐化
				HDMI_R<=yuv2rgb_r;
                HDMI_G<=yuv2rgb_g;
                HDMI_B<=yuv2rgb_b;
				HDMI_VS<=yuv2rgb_vs;
				HDMI_HS<=yuv2rgb_href;
				HDMI_DE<=yuv2rgb_href;
			end   
			8'd8:begin	//均值滤波
				HDMI_R<=average_r;
                HDMI_G<=average_g;
                HDMI_B<=average_b;
				HDMI_VS<=average_vs;
				HDMI_HS<=average_hs;
				HDMI_DE<=average_de;
			end            
            8'd9:begin	//中值滤波
            	HDMI_R<=yuv2rgb_r;
                HDMI_G<=yuv2rgb_g;
                HDMI_B<=yuv2rgb_b;
				HDMI_VS<=yuv2rgb_vs;
				HDMI_HS<=yuv2rgb_href;
				HDMI_DE<=yuv2rgb_href;
            end                 
			8'd10:begin	//二值							
				HDMI_R<=binary_y;
                HDMI_G<=binary_y;
                HDMI_B<=binary_y;
				HDMI_VS<=binary_vs;
				HDMI_HS<=binary_hs;
				HDMI_DE<=binary_de;
			end
			8'd11:begin	//腐蚀				
				HDMI_R<=ersion_y;
                HDMI_G<=ersion_y;
                HDMI_B<=ersion_y;
				HDMI_VS<=ersion_vs;
				HDMI_HS<=ersion_de;
				HDMI_DE<=ersion_de;
			end
			8'd12:begin	//膨胀
				HDMI_R<=dilation_y;
                HDMI_G<=dilation_y;
                HDMI_B<=dilation_y;
				HDMI_VS<=dilation_vs;
				HDMI_HS<=dilation_de;
				HDMI_DE<=dilation_de;
			end
			8'd13:begin	//outline
				HDMI_R<= outline_data_y;
                HDMI_G<= outline_data_u; 
                HDMI_B<= outline_data_v;  
				HDMI_VS<=outline_vs;               
				HDMI_HS<=outline_hs;               
				HDMI_DE<=outline_de;              
			end
			8'd14:begin	//sobel
				HDMI_R<=sobel_data[23:16];
                HDMI_G<=sobel_data[15:8];
                HDMI_B<=sobel_data[7:0];
				HDMI_VS<=o_sobel_vs;
				HDMI_HS<=o_sobel_hs;
				HDMI_DE<=o_sobel_de;
			end
			8'd15:begin	//人脸识别		
                HDMI_R<= water_r1;       //face_detect_data[23:16];
                HDMI_G<= water_g1;       //face_detect_data[15:8]; 
                HDMI_B<= water_b1;       //face_detect_data[7:0];  
                HDMI_VS<=water_vs1;     //o_v_sync;               
                HDMI_HS<=water_hs1;     //o_h_sync;               
                HDMI_DE<=water_en1;     //out_valid;            
			end
			8'd16:begin	//水印	
				HDMI_R<=water_r;
                HDMI_G<=water_g;
                HDMI_B<=water_b;
				HDMI_VS<=water_vs;
				HDMI_HS<=water_hs;
				HDMI_DE<=water_en;
			end
			8'd17:begin	//水印	
				HDMI_R<=water_r;
                HDMI_G<=water_g;
                HDMI_B<=water_b;
				HDMI_VS<=water_vs;
				HDMI_HS<=water_hs;
				HDMI_DE<=water_en;
			end
            8'd18:begin
            	HDMI_R<=div_data[23:16];
                HDMI_G<=div_data[15:8]; 
                HDMI_B<=div_data[7:0];
				HDMI_VS<=~vtc_vs;
				HDMI_HS<=vtc_de_valid;
				HDMI_DE<=vtc_de_valid;
			end
            8'd19:begin
            	HDMI_R<=box_select_r;
                HDMI_G<=box_select_g; 
                HDMI_B<=box_select_b;
				HDMI_VS<=box_select_vs;
				HDMI_HS<=box_select_hs;
				HDMI_DE<=box_select_href;
			end
		default : begin
			HDMI_R<=w_awb_r;
			HDMI_G<=w_awb_g;  
			HDMI_B<=w_awb_b; 
			HDMI_VS<=w_awb_vs;
			HDMI_HS<=w_awb_hs;
			HDMI_DE<=w_awb_de;		
		end
		endcase
	end
end


	PLL U_PLL(
  		.refclk   ( I_sys_clk_25m          ),
  		.lock     ( S_pll_lock             ),
        .reset	  (	~I_key_in			   ), 
 
  		.clk0_out ( O_sc2210_clk_27m             ),
  		.clk1_out ( S_sys_clk              ),
        .clk2_out ( S_clk_70m              ),
        .clk3_out ( S_hdmi_clk       ),  //像素时钟
        .clk4_out (	S_serial_clk			   ),//HDMI IO的serdes 时钟 5倍的像素时钟
        .clk5_out (	I_ddr_clk			   ),
        .clk6_out ( clk_ref			)
	);

	assign O_sc2210_rst_n = 1'b1;
	
    ///led
    assign IO_led = S_mcu_gpio_out_en[0] ? S_mcu_gpio_out[0] : 1'bz;
	assign S_mcu_gpio_in[0] = IO_led;

    ///sc2210 iic scl
    assign IO_sc2210_scl    = S_mcu_gpio_out_en[1] ? S_mcu_gpio_out[1] : 1'bz;
    assign S_mcu_gpio_in[1] = IO_sc2210_scl;

    ///sc2210 iic sda
    assign IO_sc2210_sda    = S_mcu_gpio_out_en[2] ? S_mcu_gpio_out[2] : 1'bz;
    assign S_mcu_gpio_in[2] = IO_sc2210_sda;
    
    ///fan 
    assign fan_pwm = 1'b1;


    soft_ps_wrapper#(
        .SYSCLK               ( 70000000                  ),
        .DEV_SERIES           ( "PH1"                     ),
        .CORE_TYPE            ( "MEDIUM"                  ),
        .TCM0_SIZE            ( 32*1024                   ),
        .TCM0_INITFILE        ( "30fps_SC2210_HDMI_1080P.bin.mif" ),
        .TCM0_RAMSTYLE        ( "20K"                     ),
        .UART1_BAUDRATE       ( 115200                    ),
        .MTIME_ENABLE         ( 1'b0                      ),
        .GPIO_PINNUM          ( 32                        ),
        .GPIO_INTENABLE       ( 1'b1                      ),
        .GPIO_INTCFG          ( {45'h0,3'b101,48'h0}      )
    )u_soft_ps_wrapper(
        .I_clk                ( S_clk_70m            ),
        .I_rst                ( S_rst 	             ),//

        .I_mcu_jtag_tms       ( I_mcu_jtag_tms       ),
        .I_mcu_jtag_tdi       ( I_mcu_jtag_tdi       ),
        .O_mcu_jtag_tdo       ( O_mcu_jtag_tdo       ),
        .I_mcu_jtag_tck       ( I_mcu_jtag_tck       ),

        .I_gpio_in            ( S_mcu_gpio_in        ),
        .O_gpio_out           ( S_mcu_gpio_out       ),
        .O_gpio_out_en        ( S_mcu_gpio_out_en    ),
        
        .O_uart1_tx           (         ),
        .I_uart1_rx           (         ),

        .O_user_apb_PADDR     ( S_user_apb_PADDR     ),
        .O_user_apb_PSEL      ( S_user_apb_PSEL      ),
        .O_user_apb_PENABLE   ( S_user_apb_PENABLE   ),
        .O_user_apb_PWRITE    ( S_user_apb_PWRITE    ),
        .O_user_apb_PWDATA    ( S_user_apb_PWDATA    ),
        .I_user_apb_PREADY    ( S_user_apb_PREADY    ),
        .I_user_apb_PRDATA    ( S_user_apb_PRDATA    ),
        .I_user_apb_PSLVERROR ( S_user_apb_PSLVERROR ),
        .I_user_apb_int       ( S_user_apb_int       ),

        .I_spi_miso           (  ),
        .O_spi_mosi           (  ),
        .O_spi_clk            (  ),
        .O_spi_cs             (  ),

        .I_spi2_miso          (  ),
        .O_spi2_mosi          (  ),
        .O_spi2_clk           (  ),
        .O_spi2_cs            (  ),

        .O_uart2_tx           (  ),
        .I_uart2_rx           (  ),

        .IO_i2c_scl           (  ),
        .IO_i2c_sda           (  )
    );


    apd_to_register u_apd_to_register(
        .I_clk               ( S_clk_70m            ),
        .I_rst_n             ( ~S_rst               ),
                             
        .I_apb_paddr         ( S_user_apb_PADDR     ),
        .I_apb_psel          ( S_user_apb_PSEL      ),
        .I_apb_penable       ( S_user_apb_PENABLE   ),
        .I_apb_pwrite        ( S_user_apb_PWRITE    ),
        .I_apb_pwdata        ( S_user_apb_PWDATA    ),
        .O_apb_pready        ( S_user_apb_PREADY    ),
        .O_apb_prdata        ( S_user_apb_PRDATA    ),
        .O_apb_pslverror     ( S_user_apb_PSLVERROR ),
        .O_apb_int           ( S_user_apb_int       ),
                             
        .I_pl_version        ( 32'h20230215         ),
       	.I_ts_tempture		 (	S_ts_tempture		),
        .O_awb_r_gain        ( S_awb_r_gain         ),
        .O_awb_g_gain        ( S_awb_g_gain         ),
        .O_awb_b_gain        ( S_awb_b_gain         ),
    	.O_data_lane3_idelay ( S_data_lane3_idelay  ),
    	.O_data_lane1_idelay ( S_data_lane1_idelay  ),
    	.O_data_lane2_idelay ( S_data_lane2_idelay  ),
    	.O_data_lane0_idelay ( S_data_lane0_idelay  ),
    	.O_clk_lane_idelay   ( S_clk_lane_idelay    ),
        .O_camera_black_level( S_camera_black_level ),
        //.O_hdmi_dp159_oe     ( O_hdmi_tx_en_0       ),
        .O_hdmi_tpg_en       ( S_hdmi_tpg_en        )
    );

localparam  AXI_ADDR_WIDTH = `APP_ADDR_WIDTH +2;
localparam  AXI_DATA_WIDTH = `DRAM_BYTE_NUM*8*8;

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr;   //FDMA写通道地址
wire                             fdma_wareq;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata;   //FDMA写数据
wire                             fdma_wvalid;  //FDMA 写有效
wire                             fdma_wready;  //FDMA写准备好，用户可以写数据

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr;   //synthesis keep     //FDMA读通道地址
wire                             fdma_rareq;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata;   //FDMA读数据
wire                             fdma_rvalid;  //FDMA 读有效
wire                             fdma_rready;  //FDMA读准备好，用户可以读数据

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr1;   //FDMA写通道地址
wire                             fdma_wareq1;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize1;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy1;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata1;   //FDMA写数据
wire                             fdma_wvalid1;  //FDMA 写有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr1;   //FDMA读通道地址
wire                             fdma_rareq1;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize1;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy1;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata1;   //FDMA读数据
wire                             fdma_rvalid1;  //FDMA 读有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr2;   //FDMA写通道地址
wire                             fdma_wareq2;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize2;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy2;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata2;   //FDMA写数据
wire                             fdma_wvalid2;  //FDMA 写有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr2;   //FDMA读通道地址
wire                             fdma_rareq2;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize2;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy2;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata2;   //FDMA读数据
wire                             fdma_rvalid2;  //FDMA 读有效	

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr3;   //FDMA写通道地址
wire                             fdma_wareq3;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize3;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy3;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata3;   //FDMA写数据
wire                             fdma_wvalid3;  //FDMA 写有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr3;   //FDMA读通道地址
wire                             fdma_rareq3;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize3;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy3;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata3;   //FDMA读数据
wire                             fdma_rvalid3;  //FDMA 读有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr4;   //FDMA写通道地址
wire                             fdma_wareq4;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize4;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy4;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata4;   //FDMA写数据
wire                             fdma_wvalid4;  //FDMA 写有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr4;   //FDMA读通道地址
wire                             fdma_rareq4;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize4;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy4;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata4;   //FDMA读数据
wire                             fdma_rvalid4;  //FDMA 读有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr5;   //FDMA写通道地址
wire                             fdma_wareq5;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize5;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy5;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata5;   //FDMA写数据
wire                             fdma_wvalid5;  //FDMA 写有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr5;   //FDMA读通道地址
wire                             fdma_rareq5;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize5;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy5;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata5;   //FDMA读数据
wire                             fdma_rvalid5;  //FDMA 读有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr6;   //FDMA写通道地址
wire                             fdma_wareq6;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize6;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy6;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata6;   //FDMA写数据
wire                             fdma_wvalid6;  //FDMA 写有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr6;   //FDMA读通道地址
wire                             fdma_rareq6;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize6;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy6;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata6;   //FDMA读数据
wire                             fdma_rvalid6;  //FDMA 读有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr7;   //FDMA写通道地址
wire                             fdma_wareq7;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize7;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy7;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata7;   //FDMA写数据
wire                             fdma_wvalid7;  //FDMA 写有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr7;   //FDMA读通道地址
wire                             fdma_rareq7;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize7;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy7;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata7;   //FDMA读数据
wire                             fdma_rvalid7;  //FDMA 读有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr8;   //FDMA写通道地址
wire                             fdma_wareq8;   //FDMA写通道请求
wire [15: 0]                     fdma_wsize8;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy8;   //FDMA处于BUSY状态，AXI总线正在写操作 		
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata8;   //FDMA写数据
wire                             fdma_wvalid8;  //FDMA 写有效

wire [AXI_ADDR_WIDTH-1:  0]      fdma_raddr8;   //FDMA读通道地址
wire                             fdma_rareq8;   //FDMA读通道请求
wire [15: 0]                     fdma_rsize8;   //FDMA读通道一次FDMA的传输大小                                       
wire                             fdma_rbusy8;   //FDMA处于BUSY状态，AXI总线正在读操作 			
wire [AXI_DATA_WIDTH-1 : 0]      fdma_rdata8;   //FDMA读数据
wire                             fdma_rvalid8;  //FDMA 读有效

wire                             O_axi_clk;
wire                             pll_locked;

//例化APP接口转AXI接口
uifdma_axi_ddr#
(
.SIMULATION      ("TRUE")   ,//"TRUE"   
.APP_ADDR_WIDTH  (`APP_ADDR_WIDTH)     ,  // 128 x 16bit                
.AXI_ADDR_WIDTH  (AXI_ADDR_WIDTH)     ,                                     
.AXI_DATA_WIDTH  (`DRAM_BYTE_NUM*8*8) ,
.APP_DATA_WIDTH  (`DRAM_BYTE_NUM*8*8) ,
.APP_MASK_WIDTH  (`DRAM_BYTE_NUM * 8)  
)
u_uifdma_axi_ddr
(
.I_ddr_clk                       ( I_sys_clk_25m    ),
.I_sys_rstn                      ( ~S_rst         ),
.O_ddr_pll_locked                ( pll_locked   ),

// DDR signals
.ddr_reset_n                     ( ddr_reset_n  ),
.ddr_addr                        ( ddr_addr     ),
.ddr_ba                          ( ddr_ba       ),
.ddr_ck_p                        ( ddr_ck_p     ),
.ddr_ck_n                        ( ddr_ck_n     ),
.ddr_cke                         ( ddr_cke      ),
.ddr_cs_n                        ( ddr_cs_n     ),
.ddr_ras_n                       ( ddr_ras_n    ),
.ddr_cas_n                       ( ddr_cas_n    ),
.ddr_we_n                        ( ddr_we_n     ),
.ddr_odt                         ( ddr_odt      ),
.ddr_dqs_p                       ( ddr_dqs_p    ),
.ddr_dqs_n                       ( ddr_dqs_n    ),
.ddr_dq                          ( ddr_dq       ),
.ddr_dm                          ( ddr_dm       ),

.O_uart_txd                      (O_uart_txd    ),
.I_uart_rxd                      (I_uart_rxd    ),

.O_axi_clk                       (O_axi_clk     ),

.I_fdma_waddr                    (fdma_waddr)    ,// FDMA写通道地址
.I_fdma_wareq                    (fdma_wareq)    ,// FDMA写通道请求
.I_fdma_wsize                    (fdma_wsize)    ,// FDMA写通道一次FDMA的传输大小                                            
.O_fdma_wbusy                    (fdma_wbusy)    ,// FDMA处于BUSY状态，AXI总线正在写操作  
				
.I_fdma_wdata                    (fdma_wdata)    ,// FDMA写数据
.O_fdma_wvalid                   (fdma_wvalid)   ,// FDMA 写有效
.I_fdma_wready                   (1'b1)		     ,// FDMA写准备好，用户可以写数据

.I_fdma_raddr                    (fdma_raddr)    ,// FDMA读通道地址
.I_fdma_rareq                    (fdma_rareq)    ,// FDMA读通道请求
.I_fdma_rsize                    (fdma_rsize)    ,// FDMA读通道一次FDMA的传输大小                                      
.O_fdma_rbusy                    (fdma_rbusy)    ,// FDMA处于BUSY状态，AXI总线正在读操作 
				
.O_fdma_rdata                    (fdma_rdata)    ,// FDMA读数据
.O_fdma_rvalid                   (fdma_rvalid)   ,// FDMA 读有效
.I_fdma_rready                   (1'b1)		     // FDMA读准备好，用户可以读数据
);


 
    assign ud_wclk   = S_hs_rx_clk;//S_hdmi_clk;//S_sys_clk;//S_hs_rx_clk;
    assign ud_wvs    = S_csi_rx_vsync0;//S_rgb888_frame_start;//vtc_vs;
    assign ud_wde    = S_raw8_cut_valid;//S_fifo_rd_valid;//S_fifo_rd_en & (~S_fifo_empty);////vtc_de;
    assign ud_wdata  = S_raw8_cut_data;//pixelcont;//S_raw8_cut_data;//{8'd0,S_fifo_rd_data};//S_awb_data;//{8'd0,S_fifo_rd_data};//{8'd0,rgb_r,rgb_g,rgb_b};

    assign ud_rclk   = vtc_clk;
    assign ud_rvs    = vtc_vs;
    assign ud_rde    = ud_rfifo_en;//vtc_de_valid_d1;//ud_rfifo_en;
    // assign video_hdmi_data  = ud_rdata[23:0];

    //例化uidbuf 控制器 
    uidbuf# (
    .VIDEO_ENABLE(1'b1),  
    .ENABLE_WRITE(1'b1), 
    .ENABLE_READ(1'b1), 
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

    .W_BUFDEPTH(2048),
    .W_DATAWIDTH(32),//32
    //.W_BASEADDR(0),
    .W_DSIZEBITS(23),//23
    //.W_XSIZE(480),
    //.W_XSTRIDE(480),
    //.W_YSIZE(1080), 
    //.W_XDIV(1), //2
    .W_BUFSIZE(3),

    .R_BUFDEPTH(2048),
    .R_DATAWIDTH(32),
    //.R_BASEADDR(0),
    .R_DSIZEBITS(23),//23
    //.R_XSIZE(480),
    //.R_XSTRIDE(480),
    //.R_YSIZE(1080),
    //.R_XDIV(1),//2
    .R_BUFSIZE(3)
    )
    uidbuf_u0
    (
    .I_ui_clk(O_axi_clk),
    .I_ui_rstn(pll_locked),
    .R_BASEADDR(R_BASEADDR),
    .W_BASEADDR(W_BASEADDR),
    
    .W_XDIV(1),
	.R_XDIV(1),
    .R_XSIZE(480),   
    .R_XSTRIDE(480), 
    .R_YSIZE(1080),  
    .W_XSIZE(480),
    .W_XSTRIDE(480),
    .W_YSIZE(1080), 

    .I_W_FS(ud_wvs),
    .I_W_clk(ud_wclk),
    .I_W_wren(ud_wde),
    .I_W_data(ud_wdata), 
    .O_W_sync_cnt(wbuf_sync_o),
    .I_W_buf(wbuf_sync_o01),
    .O_W_full(),

    .I_R_FS(ud_rvs),
    .I_R_clk(vtc_clk),
    .I_R_rden(ud_rde),
    .O_R_data(ud_rdata),
    .O_R_sync_cnt(),
    .I_R_buf(rbuf_sync_o),
    .O_R_empty(),
        
    .O_fdma_waddr(fdma_waddr1)  ,
    .O_fdma_wareq(fdma_wareq1)  ,
    .O_fdma_wsize(fdma_wsize1)  ,                                     
    .I_fdma_wbusy(fdma_wbusy1)  ,			
    .O_fdma_wdata(fdma_wdata1)	 ,
    .I_fdma_wvalid(fdma_wvalid1),
    .O_fdma_raddr(fdma_raddr1)  ,
    .O_fdma_rareq(fdma_rareq1)  ,
    .O_fdma_rsize(fdma_rsize1)  ,                                     
    .I_fdma_rbusy(fdma_rbusy1)  ,			
    .I_fdma_rdata(fdma_rdata1)	 ,
    .I_fdma_rvalid(fdma_rvalid1)
    ); 
    
    //sc
    uidbuf# (
    .VIDEO_ENABLE(1'b1),  
    .ENABLE_WRITE(1'b1), 
    .ENABLE_READ(1'b1), 
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

    .W_BUFDEPTH(2048),
    .W_DATAWIDTH(32),//32
    //.W_BASEADDR(26'b10_0000_0000_0000_0000_0000_0000),
    .W_DSIZEBITS(23),//23
    //.W_XSIZE(480),
    //.W_XSTRIDE(480),
    //.W_YSIZE(1080), 
    //.W_XDIV(2), //2
    .W_BUFSIZE(3),

    .R_BUFDEPTH(2048),
    .R_DATAWIDTH(32),
    //.R_BASEADDR(26'b10_0000_0000_0000_0000_0000_0000),
    .R_DSIZEBITS(23),//23
    //.R_XSIZE(480),
    //.R_XSTRIDE(480),
    //.R_YSIZE(1080),
    //.R_XDIV(2),//2
    .R_BUFSIZE(3)
    )
    uidbuf_u1
    (
    .I_ui_clk(O_axi_clk),
    .I_ui_rstn(pll_locked && !change),
    .R_BASEADDR(26'b10_0000_0000_0000_0000_0000_0000),
    .W_BASEADDR(26'b10_0000_0000_0000_0000_0000_0000),
    
    .W_XDIV(2),
	.R_XDIV(2),
    .R_XSIZE(xpix),   
    .R_XSTRIDE(xpix), 
    .R_YSIZE(ypix),  
    .W_XSIZE(xpix),
    .W_XSTRIDE(xpix),
    .W_YSIZE(ypix), 

    .I_W_FS(ud_rvs),
    .I_W_clk(vtc_clk),
    .I_W_wren(sc_en ? ud_wde1 : 0),
    .I_W_data(ud_wdata1), 
    .O_W_sync_cnt(wbuf_sync_o1),
    .I_W_buf(wbuf_sync_o1),
    .O_W_full(),

    .I_R_FS(ud_rvs),
    .I_R_clk(vtc_clk),
    .I_R_rden(sc_en ? ud_rde1 : 0),
    .O_R_data(ud_rdata1),
    .O_R_sync_cnt(),
    .I_R_buf(rbuf_sync_o1),
    .O_R_empty(),
        
    .O_fdma_waddr(fdma_waddr2)  ,
    .O_fdma_wareq(fdma_wareq2)  ,
    .O_fdma_wsize(fdma_wsize2)  ,                                     
    .I_fdma_wbusy(fdma_wbusy2)  ,			
    .O_fdma_wdata(fdma_wdata2)	 ,
    .I_fdma_wvalid(fdma_wvalid2),
    //.O_fdma_wready(fdma_wready),
    .O_fdma_raddr(fdma_raddr2)  ,
    .O_fdma_rareq(fdma_rareq2)  ,
    .O_fdma_rsize(fdma_rsize2)  ,                                     
    .I_fdma_rbusy(fdma_rbusy2)  ,			
    .I_fdma_rdata(fdma_rdata2)	 ,
    .I_fdma_rvalid(fdma_rvalid2)//,
    //.O_fdma_rready(fdma_rready),
    //.O_fmda_wbuf  (fdma_wbuf),	
    //.O_fdma_wirq  (fdma_wirq),		
    //.O_fmda_rbuf  (fdma_rbuf),	
    //.O_fdma_rirq  (fdma_rirq)
    ); 
    //div
    uidbuf# (
    .VIDEO_ENABLE(1'b1),  
    .ENABLE_WRITE(1'b1), 
    .ENABLE_READ(1'b1), 
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

    .W_BUFDEPTH(2048),
    .W_DATAWIDTH(32),//32
    //.W_BASEADDR(27'b100_0000_0000_0000_0000_0000_0000),
    .W_DSIZEBITS(23),//23
    //.W_XSIZE(480),
    //.W_XSTRIDE(480),
    //.W_YSIZE(1080), 
    //.W_XDIV(2), //2
    .W_BUFSIZE(3),

    .R_BUFDEPTH(2048),
    .R_DATAWIDTH(32),
    //.R_BASEADDR(27'b100_0000_0000_0000_0000_0000_0000),
    .R_DSIZEBITS(23),//23
    //.R_XSIZE(480),
    //.R_XSTRIDE(480),
    //.R_YSIZE(1080),
    //.R_XDIV(2),//2
    .R_BUFSIZE(3)
    )
    uidbuf_u2
    (
    .I_ui_clk(O_axi_clk),
    .I_ui_rstn(pll_locked && !change),
    .R_BASEADDR(27'b100_0000_0000_0000_0000_0000_0000),
    .W_BASEADDR(27'b100_0000_0000_0000_0000_0000_0000),
    
    .W_XDIV(2),
	.R_XDIV(2),
    .R_XSIZE(960),   
    .R_XSTRIDE(960), 
    .R_YSIZE(540),  
    .W_XSIZE(960),
    .W_XSTRIDE(960),
    .W_YSIZE(540),  

    .I_W_FS(ud_rvs),
    .I_W_clk(vtc_clk),
    .I_W_wren(data[24] ? ud_wde2 : 0),
    .I_W_data(ud_wdata2), 
    .O_W_sync_cnt(wbuf_sync_o2),
    .I_W_buf(wbuf_sync_o2),
    .O_W_full(),

    .I_R_FS(ud_rvs),
    .I_R_clk(vtc_clk),
    .I_R_rden(data[24] ? ud_rde2 : 0),
    .O_R_data(ud_rdata2),
    .O_R_sync_cnt(),
    .I_R_buf(rbuf_sync_o2),
    .O_R_empty(),
        
    .O_fdma_waddr(fdma_waddr3)  ,
    .O_fdma_wareq(fdma_wareq3)  ,
    .O_fdma_wsize(fdma_wsize3)  ,                                     
    .I_fdma_wbusy(fdma_wbusy3)  ,			
    .O_fdma_wdata(fdma_wdata3)	 ,
    .I_fdma_wvalid(fdma_wvalid3),
    //.O_fdma_wready(fdma_wready),
    .O_fdma_raddr(fdma_raddr3)  ,
    .O_fdma_rareq(fdma_rareq3)  ,
    .O_fdma_rsize(fdma_rsize3)  ,                                     
    .I_fdma_rbusy(fdma_rbusy3)  ,			
    .I_fdma_rdata(fdma_rdata3)	 ,
    .I_fdma_rvalid(fdma_rvalid3)//,
    //.O_fdma_rready(fdma_rready),
    //.O_fmda_wbuf  (fdma_wbuf),	
    //.O_fdma_wirq  (fdma_wirq),		
    //.O_fmda_rbuf  (fdma_rbuf),	
    //.O_fdma_rirq  (fdma_rirq)
    ); 
    
    uidbuf# (
    .VIDEO_ENABLE(1'b1),  
    .ENABLE_WRITE(1'b1), 
    .ENABLE_READ(1'b1), 
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

    .W_BUFDEPTH(2048),
    .W_DATAWIDTH(32),//32
    //.W_BASEADDR(27'b100_0010_0000_0000_0000_0000_0000),
    .W_DSIZEBITS(23),//23
    //.W_XSIZE(480),
    //.W_XSTRIDE(480),
    //.W_YSIZE(1080), 
    //.W_XDIV(2), //2
    .W_BUFSIZE(3),

    .R_BUFDEPTH(2048),
    .R_DATAWIDTH(32),
    //.R_BASEADDR(27'b100_0010_0000_0000_0000_0000_0000),
    .R_DSIZEBITS(23),//23
    //.R_XSIZE(480),
    //.R_XSTRIDE(480),
    //.R_YSIZE(1080),
    //.R_XDIV(2),//2
    .R_BUFSIZE(3)
    )
    uidbuf_u3
    (
    .I_ui_clk(O_axi_clk),
    .I_ui_rstn(pll_locked && !change),
    .R_BASEADDR(27'b100_0010_0000_0000_0000_0000_0000),
    .W_BASEADDR(27'b100_0010_0000_0000_0000_0000_0000),
    
    .W_XDIV(2),
	.R_XDIV(2),
    .R_XSIZE(960),   
    .R_XSTRIDE(960), 
    .R_YSIZE(540),  
    .W_XSIZE(960),
    .W_XSTRIDE(960),
    .W_YSIZE(540), 

    .I_W_FS(ud_rvs),
    .I_W_clk(vtc_clk),
    .I_W_wren(data[24] ? ud_wde3 : 0),
    .I_W_data(ud_wdata3), 
    .O_W_sync_cnt(wbuf_sync_o3),
    .I_W_buf(wbuf_sync_o3),
    .O_W_full(),

    .I_R_FS(ud_rvs),
    .I_R_clk(vtc_clk),
    .I_R_rden(data[24] ? ud_rde3 : 0),
    .O_R_data(ud_rdata3),
    .O_R_sync_cnt(),
    .I_R_buf(rbuf_sync_o3),
    .O_R_empty(),
        
    .O_fdma_waddr(fdma_waddr4)  ,
    .O_fdma_wareq(fdma_wareq4)  ,
    .O_fdma_wsize(fdma_wsize4)  ,                                     
    .I_fdma_wbusy(fdma_wbusy4)  ,			
    .O_fdma_wdata(fdma_wdata4)	 ,
    .I_fdma_wvalid(fdma_wvalid4),
    .O_fdma_raddr(fdma_raddr4)  ,
    .O_fdma_rareq(fdma_rareq4)  ,
    .O_fdma_rsize(fdma_rsize4)  ,                                     
    .I_fdma_rbusy(fdma_rbusy4)  ,			
    .I_fdma_rdata(fdma_rdata4)	 ,
    .I_fdma_rvalid(fdma_rvalid4)
    ); 
    
    uidbuf# (
    .VIDEO_ENABLE(1'b1),  
    .ENABLE_WRITE(1'b1), 
    .ENABLE_READ(1'b1), 
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

    .W_BUFDEPTH(2048),
    .W_DATAWIDTH(32),//32
    //.W_BASEADDR(27'b100_0100_0000_0000_0000_0000_0000),
    .W_DSIZEBITS(23),//23
    //.W_XSIZE(480),
    //.W_XSTRIDE(480),
    //.W_YSIZE(1080), 
    //.W_XDIV(2), //2
    .W_BUFSIZE(4),

    .R_BUFDEPTH(2048),
    .R_DATAWIDTH(32),
    //.R_BASEADDR(27'b100_0100_0000_0000_0000_0000_0000),
    .R_DSIZEBITS(23),//23
    //.R_XSIZE(480),
    //.R_XSTRIDE(480),
    //.R_YSIZE(1080),
    //.R_XDIV(2),//2
    .R_BUFSIZE(4)
    )
    uidbuf_u4
    (
    .I_ui_clk(O_axi_clk),
    .I_ui_rstn(pll_locked && !change),
    .R_BASEADDR(27'b100_0100_0000_0000_0000_0000_0000),
    .W_BASEADDR(27'b100_0100_0000_0000_0000_0000_0000),
    
    .W_XDIV(2),
	.R_XDIV(2),
    .R_XSIZE(960),   
    .R_XSTRIDE(960), 
    .R_YSIZE(540),  
    .W_XSIZE(960),
    .W_XSTRIDE(960),
    .W_YSIZE(540), 

    .I_W_FS(ud_rvs),
    .I_W_clk(vtc_clk),
    .I_W_wren(data[24] ? ud_wde4 : 0),
    .I_W_data(ud_wdata4), 
    .O_W_sync_cnt(wbuf_sync_o4),
    .I_W_buf(wbuf_sync_o4),
    .O_W_full(),

    .I_R_FS(ud_rvs),
    .I_R_clk(vtc_clk),
    .I_R_rden(data[24] ? ud_rde4 : 0),
    .O_R_data(ud_rdata4),
    .O_R_sync_cnt(),
    .I_R_buf(rbuf_sync_o4),
    .O_R_empty(),
        
    .O_fdma_waddr(fdma_waddr5)  ,
    .O_fdma_wareq(fdma_wareq5)  ,
    .O_fdma_wsize(fdma_wsize5)  ,                                     
    .I_fdma_wbusy(fdma_wbusy5)  ,			
    .O_fdma_wdata(fdma_wdata5)	 ,
    .I_fdma_wvalid(fdma_wvalid5),
    .O_fdma_raddr(fdma_raddr5)  ,
    .O_fdma_rareq(fdma_rareq5)  ,
    .O_fdma_rsize(fdma_rsize5)  ,                                     
    .I_fdma_rbusy(fdma_rbusy5)  ,			
    .I_fdma_rdata(fdma_rdata5)	 ,
    .I_fdma_rvalid(fdma_rvalid5)
    ); 
    
    uidbuf# (
    .VIDEO_ENABLE(1'b1),  
    .ENABLE_WRITE(1'b1), 
    .ENABLE_READ(1'b1), 
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

    .W_BUFDEPTH(2048),
    .W_DATAWIDTH(32),//32
    //.W_BASEADDR(27'b100_0110_0000_0000_0000_0000_0000),
    .W_DSIZEBITS(23),//23
    //.W_XSIZE(480),
    //.W_XSTRIDE(480),
    //.W_YSIZE(1080), 
    //.W_XDIV(2), //2
    .W_BUFSIZE(3),

    .R_BUFDEPTH(2048),
    .R_DATAWIDTH(32),
    //.R_BASEADDR(27'b100_0110_0000_0000_0000_0000_0000),
    .R_DSIZEBITS(23),//23
    //.R_XSIZE(480),
    //.R_XSTRIDE(480),
    //.R_YSIZE(1080),
    //.R_XDIV(2),//2
    .R_BUFSIZE(3)
    )
    uidbuf_u5
    (
    .I_ui_clk(O_axi_clk),
    .I_ui_rstn(pll_locked && !change),
    .R_BASEADDR(27'b100_0110_0000_0000_0000_0000_0000),
    .W_BASEADDR(27'b100_0110_0000_0000_0000_0000_0000),
    
    .W_XDIV(2),
	.R_XDIV(2),
    .R_XSIZE(960),   
    .R_XSTRIDE(960), 
    .R_YSIZE(540),  
    .W_XSIZE(960),
    .W_XSTRIDE(960),
    .W_YSIZE(540), 

    .I_W_FS(ud_rvs),
    .I_W_clk(vtc_clk),
    .I_W_wren(data[24] ? ud_wde5 : 0),
    .I_W_data(ud_wdata5), 
    .O_W_sync_cnt(wbuf_sync_o5),
    .I_W_buf(wbuf_sync_o5),
    .O_W_full(),

    .I_R_FS(ud_rvs),
    .I_R_clk(vtc_clk),
    .I_R_rden(data[24] ? ud_rde5 : 0),
    .O_R_data(ud_rdata5),
    .O_R_sync_cnt(),
    .I_R_buf(rbuf_sync_o5),
    .O_R_empty(),
        
    .O_fdma_waddr(fdma_waddr6)  ,
    .O_fdma_wareq(fdma_wareq6)  ,
    .O_fdma_wsize(fdma_wsize6)  ,                                     
    .I_fdma_wbusy(fdma_wbusy6)  ,			
    .O_fdma_wdata(fdma_wdata6)	 ,
    .I_fdma_wvalid(fdma_wvalid6),
    .O_fdma_raddr(fdma_raddr6)  ,
    .O_fdma_rareq(fdma_rareq6)  ,
    .O_fdma_rsize(fdma_rsize6)  ,                                     
    .I_fdma_rbusy(fdma_rbusy6)  ,			
    .I_fdma_rdata(fdma_rdata6)	 ,
    .I_fdma_rvalid(fdma_rvalid6)//
    ); 
    //sdio
    uidbuf# (
    .VIDEO_ENABLE(1'b1),  
    .ENABLE_WRITE(1'b1), 
    .ENABLE_READ(1'b1), 
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

    .W_BUFDEPTH(2048),
    .W_DATAWIDTH(32),//32
    //.W_BASEADDR(28'b1000_0000_0000_0000_0000_0000_0000),
    .W_DSIZEBITS(23),//23
    //.W_XSIZE(480),
    //.W_XSTRIDE(480),
    //.W_YSIZE(1080), 
    //.W_XDIV(1), //2
    .W_BUFSIZE(3),

    .R_BUFDEPTH(2048),
    .R_DATAWIDTH(8),
    //.R_BASEADDR(0),
    .R_DSIZEBITS(23),//23
    //.R_XSIZE(1920),
    //.R_XSTRIDE(1920),
    //.R_YSIZE(1080),
    //.R_XDIV(2),//2
    .R_BUFSIZE(3)
    )
    uidbuf_u6
    (
    .I_ui_clk(O_axi_clk),
    .I_ui_rstn(pll_locked),
    .R_BASEADDR(0),
    .W_BASEADDR(27'b110_0000_0000_0000_0000_0000_0000),
    
    .W_XDIV(1),
	.R_XDIV(2),
    .R_XSIZE(1920),   
    .R_XSTRIDE(1920), 
    .R_YSIZE(1080),  
    .W_XSIZE(480),
    .W_XSTRIDE(480),
    .W_YSIZE(1080), 
/*
    .I_W_FS(sd_vs_r),
    .I_W_clk(clk_ref),
    .I_W_wren(sdio_de),
    .I_W_data(sdio_data), 
    .O_W_sync_cnt(wbuf_sync_o12),
    .I_W_buf(wbuf_sync_o12),
    .O_W_full(),
*/
	.I_W_FS(sd_vs),
    .I_W_clk(clk_ref),
    .I_W_wren(0),//wden),
    .I_W_data(wd_32), 
    .O_W_sync_cnt(wbuf_sync_o12),
    .I_W_buf(wbuf_sync_o12),
    .O_W_full(),

    .I_R_FS(sd_vs),
    .I_R_clk(clk_ref),
    .I_R_rden(wr_req),
    .O_R_data(wr_data),
    .O_R_sync_cnt(),
    .I_R_buf(stay_sd),
    .O_R_empty(),
        
    .O_fdma_waddr(fdma_waddr7)  ,
    .O_fdma_wareq(fdma_wareq7)  ,
    .O_fdma_wsize(fdma_wsize7)  ,                                     
    .I_fdma_wbusy(fdma_wbusy7)  ,			
    .O_fdma_wdata(fdma_wdata7)	 ,
    .I_fdma_wvalid(fdma_wvalid7),
    .O_fdma_raddr(fdma_raddr7)  ,
    .O_fdma_rareq(fdma_rareq7)  ,
    .O_fdma_rsize(fdma_rsize7)  ,                                     
    .I_fdma_rbusy(fdma_rbusy7)  ,			
    .I_fdma_rdata(fdma_rdata7)	 ,
    .I_fdma_rvalid(fdma_rvalid7)
    ); 
    //fram_dif
    uidbuf# (
    .VIDEO_ENABLE(1'b1),  
    .ENABLE_WRITE(1'b0), 
    .ENABLE_READ(1'b1), 
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

    .W_BUFDEPTH(1024),
    .W_DATAWIDTH(32),//32
    //.W_BASEADDR(0),
    .W_DSIZEBITS(23),//23
    //.W_XSIZE(480),
    //.W_XSTRIDE(480),
    //.W_YSIZE(1080), 
    //.W_XDIV(1), //2
    .W_BUFSIZE(3),

    .R_BUFDEPTH(2048),
    .R_DATAWIDTH(32),
    //.R_BASEADDR(0),
    .R_DSIZEBITS(23),//23
    //.R_XSIZE(480),
    //.R_XSTRIDE(480),
    //.R_YSIZE(1080),
    //.R_XDIV(1),//2
    .R_BUFSIZE(3)
    )
    uidbuf_u7
    (
    .I_ui_clk(O_axi_clk),
    .I_ui_rstn(pll_locked),
    .R_BASEADDR(R_BASEADDR),
    .W_BASEADDR(W_BASEADDR),
    
    .W_XDIV(1),
	.R_XDIV(1),
    .R_XSIZE(480),   
    .R_XSTRIDE(480), 
    .R_YSIZE(1080), /* 
    .W_XSIZE(480),
    .W_XSTRIDE(480),
    .W_YSIZE(1080), 

    .I_W_FS(ud_wvs),
    .I_W_clk(ud_wclk),
    .I_W_wren(ud_wde),
    .I_W_data(ud_wdata), 
    .O_W_sync_cnt(wbuf_sync_o),
    .I_W_buf(wbuf_sync_o01),
    .O_W_full(),*/

    .I_R_FS(ud_rvs),
    .I_R_clk(vtc_clk),
    .I_R_rden(data[26] ? ud_rde : 0),
    .O_R_data(ud_rdata_dif),
    .O_R_sync_cnt(),
    .I_R_buf(rbuf_sync_o017),
    .O_R_empty(),
        
    .O_fdma_waddr(fdma_waddr8)  ,
    .O_fdma_wareq(fdma_wareq8)  ,
    .O_fdma_wsize(fdma_wsize8)  ,                                     
    .I_fdma_wbusy(fdma_wbusy8)  ,			
    .O_fdma_wdata(fdma_wdata8)	 ,
    .I_fdma_wvalid(fdma_wvalid8),
    .O_fdma_raddr(fdma_raddr8)  ,
    .O_fdma_rareq(fdma_rareq8)  ,
    .O_fdma_rsize(fdma_rsize8)  ,                                     
    .I_fdma_rbusy(fdma_rbusy8)  ,			
    .I_fdma_rdata(fdma_rdata8)	 ,
    .I_fdma_rvalid(fdma_rvalid8)
    ); 
    
    div_ctrl #(
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH)
) u_div_ctrl(
.clk(O_axi_clk),
.rst_n(pll_locked),
    
.O_fdma_waddr(fdma_waddr), //FDMA写通道地址
.O_fdma_wareq(fdma_wareq), //FDMA写通道请求
.O_fdma_wsize(fdma_wsize), //FDMA写通道一次FDMA的传输大小                                     
.I_fdma_wbusy(fdma_wbusy), //FDMA处于BUSY状态，AXI总线正在写操作   
.O_fdma_wdata(fdma_wdata), //FDMA写数据
.I_fdma_wvalid(fdma_wvalid), //FDMA 写有效

.O_fdma_raddr(fdma_raddr), // FDMA读通道地址
.O_fdma_rareq(fdma_rareq), // FDMA读通道请求
.O_fdma_rsize(fdma_rsize), // FDMA读通道一次FDMA的传输大小                                     
.I_fdma_rbusy(fdma_rbusy), // FDMA处于BUSY状态，AXI总线正在读操作     
.I_fdma_rdata(fdma_rdata), // FDMA读数据
.I_fdma_rvalid(fdma_rvalid), // FDMA 读有效

.I_fdma_waddr1(fdma_waddr1), //FDMA写通道地址
.I_fdma_wareq1(fdma_wareq1), //FDMA写通道请求
.I_fdma_wsize1(fdma_wsize1), //FDMA写通道一次FDMA的传输大小                                     
.O_fdma_wbusy1(fdma_wbusy1), //FDMA处于BUSY状态，AXI总线正在写操作   
.I_fdma_wdata1(fdma_wdata1), //FDMA写数据
.O_fdma_wvalid1(fdma_wvalid1), //FDMA 写有效

.I_fdma_raddr1(fdma_raddr1), // FDMA读通道地址
.I_fdma_rareq1(fdma_rareq1), // FDMA读通道请求
.I_fdma_rsize1(fdma_rsize1), // FDMA读通道一次FDMA的传输大小                                     
.O_fdma_rbusy1(fdma_rbusy1), // FDMA处于BUSY状态，AXI总线正在读操作     
.O_fdma_rdata1(fdma_rdata1), // FDMA读数据
.O_fdma_rvalid1(fdma_rvalid1), // FDMA 读有效

.I_fdma_waddr2(fdma_waddr2), //FDMA写通道地址
.I_fdma_wareq2(fdma_wareq2), //FDMA写通道请求
.I_fdma_wsize2(fdma_wsize2), //FDMA写通道一次FDMA的传输大小                                     
.O_fdma_wbusy2(fdma_wbusy2), //FDMA处于BUSY状态，AXI总线正在写操作   
.I_fdma_wdata2(fdma_wdata2), //FDMA写数据
.O_fdma_wvalid2(fdma_wvalid2), //FDMA 写有效 

.I_fdma_raddr2(fdma_raddr2), // FDMA读通道地址
.I_fdma_rareq2(fdma_rareq2), // FDMA读通道请求
.I_fdma_rsize2(fdma_rsize2), // FDMA读通道一次FDMA的传输大小                                     
.O_fdma_rbusy2(fdma_rbusy2), // FDMA处于BUSY状态，AXI总线正在读操作     
.O_fdma_rdata2(fdma_rdata2), // FDMA读数据
.O_fdma_rvalid2(fdma_rvalid2), // FDMA 读有效

.I_fdma_waddr3(fdma_waddr3), //FDMA写通道地址
.I_fdma_wareq3(fdma_wareq3), //FDMA写通道请求
.I_fdma_wsize3(fdma_wsize3), //FDMA写通道一次FDMA的传输大小                                     
.O_fdma_wbusy3(fdma_wbusy3), //FDMA处于BUSY状态，AXI总线正在写操作   
.I_fdma_wdata3(fdma_wdata3), //FDMA写数据
.O_fdma_wvalid3(fdma_wvalid3), //FDMA 写有效 

.I_fdma_raddr3(fdma_raddr3), // FDMA读通道地址
.I_fdma_rareq3(fdma_rareq3), // FDMA读通道请求
.I_fdma_rsize3(fdma_rsize3), // FDMA读通道一次FDMA的传输大小                                     
.O_fdma_rbusy3(fdma_rbusy3), // FDMA处于BUSY状态，AXI总线正在读操作     
.O_fdma_rdata3(fdma_rdata3), // FDMA读数据
.O_fdma_rvalid3(fdma_rvalid3), // FDMA 读有效

.I_fdma_waddr4(fdma_waddr4), //FDMA写通道地址
.I_fdma_wareq4(fdma_wareq4), //FDMA写通道请求
.I_fdma_wsize4(fdma_wsize4), //FDMA写通道一次FDMA的传输大小                                     
.O_fdma_wbusy4(fdma_wbusy4), //FDMA处于BUSY状态，AXI总线正在写操作   
.I_fdma_wdata4(fdma_wdata4), //FDMA写数据
.O_fdma_wvalid4(fdma_wvalid4), //FDMA 写有效 

.I_fdma_raddr4(fdma_raddr4), // FDMA读通道地址
.I_fdma_rareq4(fdma_rareq4), // FDMA读通道请求
.I_fdma_rsize4(fdma_rsize4), // FDMA读通道一次FDMA的传输大小                                     
.O_fdma_rbusy4(fdma_rbusy4), // FDMA处于BUSY状态，AXI总线正在读操作     
.O_fdma_rdata4(fdma_rdata4), // FDMA读数据
.O_fdma_rvalid4(fdma_rvalid4), // FDMA 读有效

.I_fdma_waddr5(fdma_waddr5), //FDMA写通道地址
.I_fdma_wareq5(fdma_wareq5), //FDMA写通道请求
.I_fdma_wsize5(fdma_wsize5), //FDMA写通道一次FDMA的传输大小                                     
.O_fdma_wbusy5(fdma_wbusy5), //FDMA处于BUSY状态，AXI总线正在写操作   
.I_fdma_wdata5(fdma_wdata5), //FDMA写数据
.O_fdma_wvalid5(fdma_wvalid5), //FDMA 写有效 

.I_fdma_raddr5(fdma_raddr5), // FDMA读通道地址
.I_fdma_rareq5(fdma_rareq5), // FDMA读通道请求
.I_fdma_rsize5(fdma_rsize5), // FDMA读通道一次FDMA的传输大小                                     
.O_fdma_rbusy5(fdma_rbusy5), // FDMA处于BUSY状态，AXI总线正在读操作     
.O_fdma_rdata5(fdma_rdata5), // FDMA读数据
.O_fdma_rvalid5(fdma_rvalid5), // FDMA 读有效

.I_fdma_waddr6(fdma_waddr6), //FDMA写通道地址
.I_fdma_wareq6(fdma_wareq6), //FDMA写通道请求
.I_fdma_wsize6(fdma_wsize6), //FDMA写通道一次FDMA的传输大小                                     
.O_fdma_wbusy6(fdma_wbusy6), //FDMA处于BUSY状态，AXI总线正在写操作   
.I_fdma_wdata6(fdma_wdata6), //FDMA写数据
.O_fdma_wvalid6(fdma_wvalid6), //FDMA 写有效 

.I_fdma_raddr6(fdma_raddr6), // FDMA读通道地址
.I_fdma_rareq6(fdma_rareq6), // FDMA读通道请求
.I_fdma_rsize6(fdma_rsize6), // FDMA读通道一次FDMA的传输大小                                     
.O_fdma_rbusy6(fdma_rbusy6), // FDMA处于BUSY状态，AXI总线正在读操作     
.O_fdma_rdata6(fdma_rdata6), // FDMA读数据
.O_fdma_rvalid6(fdma_rvalid6), // FDMA 读有效

.I_fdma_waddr7(fdma_waddr7), //FDMA写通道地址
.I_fdma_wareq7(fdma_wareq7), //FDMA写通道请求
.I_fdma_wsize7(fdma_wsize7), //FDMA写通道一次FDMA的传输大小                                     
.O_fdma_wbusy7(fdma_wbusy7), //FDMA处于BUSY状态，AXI总线正在写操作   
.I_fdma_wdata7(fdma_wdata7), //FDMA写数据
.O_fdma_wvalid7(fdma_wvalid7), //FDMA 写有效 

.I_fdma_raddr7(fdma_raddr7), // FDMA读通道地址
.I_fdma_rareq7(fdma_rareq7), // FDMA读通道请求
.I_fdma_rsize7(fdma_rsize7), // FDMA读通道一次FDMA的传输大小                                     
.O_fdma_rbusy7(fdma_rbusy7), // FDMA处于BUSY状态，AXI总线正在读操作     
.O_fdma_rdata7(fdma_rdata7), // FDMA读数据
.O_fdma_rvalid7(fdma_rvalid7), // FDMA 读有效

.I_fdma_waddr8(fdma_waddr8), //FDMA写通道地址
.I_fdma_wareq8(fdma_wareq8), //FDMA写通道请求
.I_fdma_wsize8(fdma_wsize8), //FDMA写通道一次FDMA的传输大小                                     
.O_fdma_wbusy8(fdma_wbusy8), //FDMA处于BUSY状态，AXI总线正在写操作   
.I_fdma_wdata8(fdma_wdata8), //FDMA写数据
.O_fdma_wvalid8(fdma_wvalid8), //FDMA 写有效 

.I_fdma_raddr8(fdma_raddr8), // FDMA读通道地址
.I_fdma_rareq8(fdma_rareq8), // FDMA读通道请求
.I_fdma_rsize8(fdma_rsize8), // FDMA读通道一次FDMA的传输大小                                     
.O_fdma_rbusy8(fdma_rbusy8), // FDMA处于BUSY状态，AXI总线正在读操作     
.O_fdma_rdata8(fdma_rdata8), // FDMA读数据
.O_fdma_rvalid8(fdma_rvalid8) // FDMA 读有效
);

    //设置3帧缓存，读延迟写1帧
    uisetvbuf#( 
    .BUF_DELAY(2), 
    .BUF_LENTH(3)
    )
    uisetvbuf_u7
    (
    .bufn_i(wbuf_sync_o01),
    .bufn_o(rbuf_sync_o017)
    ); 
    
    uisetvbuf#( 
    .BUF_DELAY(1), 
    .BUF_LENTH(3)
    )
    uisetvbuf_u
    (
    .bufn_i(wbuf_sync_o01),
    .bufn_o(rbuf_sync_o01)
    ); 
    
    uisetvbuf#( 
    .BUF_DELAY(1), 
    .BUF_LENTH(3)
    )
    uisetvbuf_u1
    (
    .bufn_i(wbuf_sync_o1),
    .bufn_o(rbuf_sync_o1)
    ); 
    
    uisetvbuf#( 
    .BUF_DELAY(1), 
    .BUF_LENTH(3)
    )
    uisetvbuf_u2
    (
    .bufn_i(wbuf_sync_o2),
    .bufn_o(rbuf_sync_o2)
    ); 
    
    uisetvbuf#( 
    .BUF_DELAY(1), 
    .BUF_LENTH(3)
    )
    uisetvbuf_u3
    (
    .bufn_i(wbuf_sync_o3),
    .bufn_o(rbuf_sync_o3)
    ); 
    
    uisetvbuf#( 
    .BUF_DELAY(1), 
    .BUF_LENTH(3)
    )
    uisetvbuf_u4
    (
    .bufn_i(wbuf_sync_o4),
    .bufn_o(rbuf_sync_o4)
    ); 
    
    uisetvbuf#( 
    .BUF_DELAY(1), 
    .BUF_LENTH(3)
    )
    uisetvbuf_u5
    (
    .bufn_i(wbuf_sync_o5),
    .bufn_o(rbuf_sync_o5)
    ); 


    //以下代码需要注意时序设计，在正确的时序输出
    reg [1 :0] ud_rdata_cnt; //synthesis keep
    reg [7 :0] ud_rdata_d1,ud_rdata_dif_d1;//synthesis keep
   // reg  vtc_user_d1;//synthesis keep
   // reg  vtc_last_d1;//synthesis keep
    reg  vtc_de_valid_d1; //synthesis keep

    always @(posedge vtc_clk) begin
        if(vtc_de_valid)
            ud_rdata_cnt <= ud_rdata_cnt + 'd1;
        else 
            ud_rdata_cnt <= 0;
    end

    always @(posedge vtc_clk) begin
           // vtc_user_d1     <= vtc_user;
           // vtc_last_d1     <= vtc_last;
            vtc_de_valid_d1 <= vtc_de_valid;
    end

    // 当vtc_de_valid = 1 ud_rdata_cnt =1 读1个数据，但是ud_rfifo_en延迟1个周期输出1，fifo再延迟1个周期更新数据
    always @(posedge vtc_clk) begin
        ud_rfifo_en <=  (ud_rdata_cnt == 1);
    end

    always @(posedge vtc_clk) begin
        if(vtc_de_valid)begin
            case(ud_rdata_cnt)
                'd0:begin ud_rdata_d1 <=  ud_rdata[31:24];ud_rdata_dif_d1 <= ud_rdata_dif[31:24]; end
                'd1:begin ud_rdata_d1 <=  ud_rdata[23:16];ud_rdata_dif_d1 <= ud_rdata_dif[23:16]; end
                'd2:begin ud_rdata_d1 <=  ud_rdata[15: 8];ud_rdata_dif_d1 <= ud_rdata_dif[15:8];  end
                'd3:begin ud_rdata_d1 <=  ud_rdata[7 : 0];ud_rdata_dif_d1 <= ud_rdata_dif[7:0];   end
            default: begin
                ud_rdata_d1 <= ud_rdata_d1;
                ud_rdata_dif_d1 <= ud_rdata_dif_d1;
            end
        endcase
        end
        else begin
            ud_rdata_d1 <=0;
            ud_rdata_dif_d1<=0;
        end
    end

    wire 			w_rgb_vsync, w_rgb_href; //synthesis keep
    wire 	[7:0] 	w_rgb_r, w_rgb_g, w_rgb_b; //synthesis keep


    raw8_2_rgb888 #(
    .H_SIZE(1920), 
    .V_SIZE(1080)
    )u_raw8_2_rgb888 
    (
    .I_clk	        (vtc_clk),                //cmos video pixel clock
    .I_rst_n	    (vtc_rstn),              //global reset
            
    //CMOS YCbCr444 data output
    .I_raw_vs	    (~vtc_vs),    //Prepared Image data vsync valid signal. Reset on falling edge. 
    .I_raw_de	    (vtc_de_valid_d1),     //Prepared Image data href vaild  signal
    .I_raw_data	    (ud_rdata_d1),        //Prepared Image data 8 Bit RAW Data
	.switch			(data[0])	 ,
    .O_rgb_vs	    (w_rgb_vsync),   //Processed Image data vsync valid signal
    .O_rgb_de	    (w_rgb_href),    //Processed Image data href vaild  signal
    .O_rgb_r		(w_rgb_r),       //Prepared Image green data to be processed 
    .O_rgb_g	    (w_rgb_g),     //Prepared Image green data to be processed
    .O_rgb_b		(w_rgb_b)       //Prepared Image blue data to be processed
    );

    wire 			w_awb_vs, w_awb_hs, w_awb_de; //synthesis keep
    wire 	[7:0] 	w_awb_r, w_awb_g, w_awb_b;//synthesis keep
    awb u_awb 
    (
    .I_clk          (vtc_clk),
    .I_rst_n        (vtc_rstn),

    .I_red_gain     (0),
    .I_green_gain   (0),
    .I_blue_gain    (0),
	.switch			(data[1]),
    .I_awb_vs       (w_rgb_vsync),
    .I_awb_hs       (w_rgb_href),
    .I_awb_de       (w_rgb_href),
    .I_awb_rgb      ({w_rgb_r, w_rgb_g, w_rgb_b}),

    .O_awb_vs       (w_awb_vs),
    .O_awb_hs       (w_awb_hs),
    .O_awb_de       (w_awb_de),
    .O_awb_rgb      ({w_awb_r, w_awb_g, w_awb_b})
    );

//ccm  
    wire	[7:0]	w_ccm_r, w_ccm_g, w_ccm_b;//synthesis keep
    wire 			w_ccm_vs, w_ccm_hs, w_ccm_de; //synthesis keep
 isp_ccm u_isp_ccm
 (
     
     .pclk    		 (vtc_clk),                         
	 .rst_n          (vtc_rstn),                 
     .switch		 (data[2]),
     
     .ccm_rr         (12'b0100_0000_0000),
     .ccm_rg         (12'b1111_1100_0011),
     .ccm_rb         (12'b0000_0011_1101),
     .ccm_gr         (12'b1111_1001_1000),
     .ccm_gg         (12'b0100_0110_0011),
     .ccm_gb         (12'b0000_0100_0001),
     .ccm_br         (12'b1111_0010_1011),
     .ccm_bg         (12'b0001_0010_1111),
     .ccm_bb         (12'b0011_1010_1110),
     /*
	 .ccm_rr         (12'b0101_0000_1010),
     .ccm_rg         (12'b1110_0011_0011),
     .ccm_rb         (12'b0000_1100_0011),
	 .ccm_gr         (12'b1110_1011_1000),
     .ccm_gg         (12'b0011_1110_1000),
     .ccm_gb         (12'b0001_0110_0001),
	 .ccm_br         (12'b1110_1110_1111),
     .ccm_bg         (12'b1110_0110_1011),
     .ccm_bb         (12'b0110_1010_0111),*/
/*
	 .pclk    		 (vtc_clk),                         
	 .rst_n          (vtc_rstn),                 
     .switch		 (data[2]),
	 .ccm_rr         (12'b0010_0000_0000),
     .ccm_rg         (12'b1111_1111_1011),
     .ccm_rb         (12'b0000_0001_0011),
	 .ccm_gr         (12'b1111_1010_1110),
     .ccm_gg         (12'b0011_00001_1001),
     .ccm_gb         (12'b1111_1111_1010),
	 .ccm_br         (12'b1111_1111_0000),
     .ccm_bg         (12'b0100_0110_0110),
     .ccm_bb         (12'b0001_1010_1101),
*/
	 .in_href        (w_awb_de),                   
	 .in_hsync       (w_awb_hs),                   
	 .in_vsync       (w_awb_vs),                   
	 .in_r           (w_awb_r),       
	 .in_g           (w_awb_g),       
	 .in_b           (w_awb_b),        
     
	 .out_href       (w_ccm_de),                  
	 .out_hsync      (w_ccm_hs),                  
	 .out_vsync      (w_ccm_vs),                  
	 .out_r          (w_ccm_r),       
	 .out_g          (w_ccm_g),       
	 .out_b          (w_ccm_b)      
 );
wire gamma_de,gamma_vs,gamma_hf;//synthesis keep
wire[7:0]gamma_r,gamma_g,gamma_b;//synthesis keep
isp_gamma isp_gamma_inst
(
	  .clk	   (vtc_clk		),
      .i_data_r(w_ccm_r	),
      .i_data_g(w_ccm_g	),
      .i_data_b(w_ccm_b	),
      .switch1 (data[3]	),
      .light ({data[8]}),
      .dark  ({data[9]}),
      .i_data_valid	(w_ccm_de	)	,
      .i_href		(w_ccm_hs	)	,
      .i_vsync		(w_ccm_vs	)	,
      .o_vsync		(gamma_vs	)	,
      .o_data_r		(gamma_r	)	,
      .o_data_g		(gamma_g	)	,
      .o_data_b		(gamma_b	)	,
      .o_data_valid (gamma_de	)
 );
//contrast
wire contrast_vs,contrast_de;//synthesis keep
wire [7:0]contrast_r,contrast_g,contrast_b;//synthesis keep
isp_contrast isp_contrast_inst
(
      .clk               (vtc_clk    ),
      .i_data_r        (gamma_r    )        ,
      .i_data_g        (gamma_g    )        ,
      .i_data_b        (gamma_b    )        ,
      .switch1        (data[4]    )        ,
      .light         ({data[10]}    ),
      .dark          ({data[11]}    ),                         
      .i_data_valid    (gamma_de    )        ,
      .i_href        (gamma_de    )        ,
      .i_vsync        (gamma_vs    )        ,
      .o_vsync        (contrast_vs)        ,
      .o_data_r        (contrast_r    )        ,
      .o_data_g        (contrast_g    )        ,
      .o_data_b        (contrast_b    )        ,
      .o_data_valid (contrast_de)
 );
//sc
wire [10:0] xpix,ypix;
wire sc_en,change;
wire [7:0]  xdiv,ydiv;
sc_test u_sc_test(
    .vin_clk(ud_rclk),
	.rst_n(pll_locked),
	.frame_sync_n(contrast_vs),	//输入视频帧同步复位，低有效
	.vin_dat({contrast_r,contrast_g,contrast_b}),			//输入视频数据
	.vin_valid(contrast_de),			//输入视频数据有效
	.vin_ready(nextDin),			//输入准备好
	.vout_dat(ud_wdata1),			//输出视频数据
	.vout_valid(ud_wde1),			//输出视频数据有效
	.vout_ready(1'b1),			//输出准备好
	.vin_xres(1920),			//输入视频水平分辨率
	.vin_yres(1080),			//输入视频垂直分辨率
	.vout_xres(xpix),			//输出视频水平分辨率
	.vout_yres(ypix)			//输出视频垂直分辨率
);

sc_test u1_sc_test(
    .vin_clk(ud_rclk),
	.rst_n(pll_locked),
	.frame_sync_n(o_sobel_vs),	//输入视频帧同步复位，低有效
	.vin_dat(sobel_data),			//输入视频数据
	.vin_valid(o_sobel_de),			//输入视频数据有效
	.vin_ready(nextDin1),			//输入准备好
	.vout_dat(ud_wdata2),			//输出视频数据
	.vout_valid(ud_wde2),			//输出视频数据有效
	.vout_ready(1'b1),			//输出准备好
	.vin_xres(1920),			//输入视频水平分辨率
	.vin_yres(1080),			//输入视频垂直分辨率
	.vout_xres(960),			//输出视频水平分辨率
	.vout_yres(540)			//输出视频垂直分辨率
);

sc_test u2_sc_test(
    .vin_clk(ud_rclk),
	.rst_n(pll_locked),
	.frame_sync_n(w_awb_vs),	//输入视频帧同步复位，低有效
	.vin_dat({w_awb_r, w_awb_g, w_awb_b}),			//输入视频数据
	.vin_valid(w_awb_de),			//输入视频数据有效
	.vin_ready(nextDin1),			//输入准备好
	.vout_dat(ud_wdata3),			//输出视频数据
	.vout_valid(ud_wde3),			//输出视频数据有效
	.vout_ready(1'b1),			//输出准备好
	.vin_xres(1920),			//输入视频水平分辨率
	.vin_yres(1080),			//输入视频垂直分辨率
	.vout_xres(960),			//输出视频水平分辨率
	.vout_yres(540)			//输出视频垂直分辨率
);

sc_test u3_sc_test(
    .vin_clk(ud_rclk),
	.rst_n(pll_locked),
	.frame_sync_n(~vtc_vs),	//输入视频帧同步复位，低有效
	.vin_dat({ud_rdata_d1,ud_rdata_d1,ud_rdata_d1}),			//输入视频数据
	.vin_valid(vtc_de_valid_d1),			//输入视频数据有效
	.vin_ready(nextDin1),			//输入准备好
	.vout_dat(ud_wdata4),			//输出视频数据
	.vout_valid(ud_wde4),			//输出视频数据有效
	.vout_ready(1'b1),			//输出准备好
	.vin_xres(1920),			//输入视频水平分辨率
	.vin_yres(1080),			//输入视频垂直分辨率
	.vout_xres(960),			//输出视频水平分辨率
	.vout_yres(540)			//输出视频垂直分辨率
);

sc_test u4_sc_test(
    .vin_clk(ud_rclk),
	.rst_n(pll_locked),
	.frame_sync_n(contrast_vs),	//输入视频帧同步复位，低有效
	.vin_dat({contrast_r,contrast_g,contrast_b}),			//输入视频数据
	.vin_valid(contrast_de),			//输入视频数据有效
	.vin_ready(nextDin),			//输入准备好
	.vout_dat(ud_wdata5),			//输出视频数据
	.vout_valid(ud_wde5),			//输出视频数据有效
	.vout_ready(1'b1),			//输出准备好
	.vin_xres(1920),			//输入视频水平分辨率
	.vin_yres(1080),			//输入视频垂直分辨率
	.vout_xres(960),			//输出视频水平分辨率
	.vout_yres(540)			//输出视频垂直分辨率
);

sc_control u_sc(
    .clk(ud_rclk),
	.vs(contrast_vs),
    .rst_n(pll_locked),
    .sc_key_up(data[12]),
    .sc_key_down(data[13]),
    .wid_up(data[28]),
    .wid_down(data[29]),
    .hei_up(data[30]),
    .hei_down(data[31]),
    .sc_open(data[15]),
    .sc_en(sc_en),
    .xpix(xpix),
    .ypix(ypix),
    .xdiv(xdiv),
    .ydiv(ydiv),
    .change(change)
);
wire [23:0] sc_data;
sc_data u_sc_data(
	.clk(ud_rclk),              
	.rst(S_rst || vtc_vs),              
	.xpix(xpix),      
	.ypix(ypix),      
	.vtc_de(vtc_de_valid),           
	.i_sc_de(vtc_de_valid),          
	.i_sc_di(ud_rdata1),  
	.o_sc_de(ud_rde1),        
	.o_sc_dout(sc_data) 
);

wire [23:0] div_data;
div_data udiv_data(
    .clk(ud_rclk),
    .rst(S_rst || vtc_vs),
    .vtc_de(vtc_de_valid),
    .i_sc_de(vtc_de_valid),
    .i_sc_di1(ud_rdata2),
    .i_sc_di2(ud_rdata3),
    .i_sc_di3(ud_rdata4),
    .i_sc_di4(ud_rdata5),
    .o_sc_de1(ud_rde2),
    .o_sc_de2(ud_rde3),
    .o_sc_de3(ud_rde4),
    .o_sc_de4(ud_rde5),
    .o_sc_dout(div_data)
);

// CNN accelerator is intentionally not included in this open-source release.
// Tie off the interface so the rest of the video pipeline remains self-contained.
wire [2:0] cnn_result = 3'b0;
wire       cnn_valid  = 1'b0;
//face_detect
wire out_valid,o_h_sync,o_v_sync;//synthesis keep
wire [23:0]    face_detect_data;//synthesis keep
wire [2:0] face_sel;
face_dt face_dt_inst
(
    .rst_n                (vtc_rstn    )            ,
    .switch                (data[22]    )            ,   
    .switch1            (I_key_select)            ,            
    .video_pclk            (vtc_clk    )            ,
    .video_valid        (contrast_de    )            ,
    .video_data            ({contrast_r,contrast_g,contrast_b}    )            ,                      
                                       
                                           
    .i_h_sync            (contrast_de    )            ,                               
    .i_v_sync            (contrast_vs    )            ,                           

    .out_valid            (out_valid    )            ,
    .out_data            (face_detect_data    )            ,                     
                       
    .face_sel            (face_sel    )            ,                      
    .o_h_sync            (o_h_sync    )            ,                         
    .o_v_sync            (o_v_sync    ) 				
);
//water
wire	 water_hs,water_vs,water_en;//synthesis keep
wire 	[7:0] 	water_r, water_g, water_b; //synthesis keep
/*******************************************************************/
watermark_logo watermark_logo_inst
(
	.i_clk(vtc_clk),
	.i_rst_n(vtc_rstn),
    .switch(data[25]),
	.water_select0(data[14]),
	.i_hsyn(o_h_sync),
	.i_vsyn(o_v_sync),
	.i_en_pos(out_valid),
	.i_r(face_detect_data[23:16]),
	.i_g(face_detect_data[15:8]),
	.i_b(face_detect_data[7:0]),		
	
	.o_hs(water_hs),
	.o_vs(water_vs),
	.o_en(water_en),	
	.o_r(water_r),
	.o_g(water_g),
	.o_b(water_b)	
);

// Gesture-overlay module removed (tied to the non-open-sourced CNN path).
// Pass face-detection result straight through so HDMI mode 15 still works.
wire	 water_hs1,water_vs1,water_en1;//synthesis keep
wire 	[7:0] 	water_r1, water_g1, water_b1; //synthesis keep
assign water_hs1 = o_h_sync;
assign water_vs1 = o_v_sync;
assign water_en1 = out_valid;
assign water_r1  = face_detect_data[23:16];
assign water_g1  = face_detect_data[15:8];
assign water_b1  = face_detect_data[7:0];
//rgb_yuv
wire o_csc_de,o_csc_hs,o_csc_vs;//synthesis keep
wire [7:0] o_csc_y;//synthesis keep
wire [7:0] o_csc_u;//synthesis keep
wire [7:0] o_csc_v;//synthesis keep

isp_rgb2yuv #(
    .WIDTH(1920),
    .HEIGHT(1080)
)u_rgb_yuv(
    .pclk(vtc_clk),
    .rst_n(vtc_rstn),
    .switch(1),//**************************************
    
    .in_href(contrast_de),
    .in_vsync(contrast_vs),
    .in_r(contrast_r),
    .in_g(contrast_g),
    .in_b(contrast_b),
    
    .out_href(o_csc_de),
    .out_vsync(o_csc_vs),
    .out_y(o_csc_y),
    .out_u(o_csc_u),
    .out_v(o_csc_v)
);
//ee
wire ee_de,ee_hs,ee_vs;//synthesis keep
wire [7:0] ee_y,ee_u,ee_v;//synthesis keep
isp_ee isp_ee_inst
(
	.pclk		(vtc_clk	)		,
	.rst_n		(vtc_rstn	)		,
	.switch		(data[5]	)		,
	.in_href	(o_csc_de	)		,
    .in_hsync	(o_csc_de	)		,
	.in_vsync	(o_csc_vs	)		,
	.in_y		(o_csc_y	)		,
	.in_u		(o_csc_u	)		,
	.in_v		(o_csc_v	)		,
               
	.out_href	(ee_de	)		,
    .out_hsync	(ee_hs	)		,
	.out_vsync	(ee_vs	)		,
	.out_y		(ee_y	)		,
	.out_u		(ee_u	)		,
	.out_v      (ee_v	)
);
//yuv_rgb
wire yuv2rgb_href,yuv2rgb_vs;//synthesis keep
wire [7:0] yuv2rgb_r,yuv2rgb_g,yuv2rgb_b;//synthesis keep
isp_yuv2rgb isp_yuv2rgb_inst
(
	.pclk				(vtc_clk	),
	.rst_n				(vtc_rstn	),
                       
	.switch				(data[5]	),
                        
	.in_href			(mid_filter_de	),
	.in_vsync			(mid_filter_vs	),
	.in_y				(mid_filter_y	),
	.in_u				(mid_filter_u	),
	.in_v				(mid_filter_v	),
                        
	.out_href			(yuv2rgb_href	),
	.out_vsync			(yuv2rgb_vs	),
	.out_r				(yuv2rgb_r	),
	.out_g				(yuv2rgb_g	),
	.out_b				(yuv2rgb_b	)
);
//average_filter
wire average_hs,average_vs,average_de;//synthesis keep
wire [7:0] average_r,average_g,average_b;//synthesis keep
image_average_filtering image_average_filtering_inst
(
	.i_clk	(vtc_clk	)		,
	.i_rst_n(vtc_rstn	)		,
	.switch	(data[6]	)		,
	.i_hsyn	(yuv2rgb_href	)		,
	.i_vsyn	(yuv2rgb_vs	)		,
	.i_en	(yuv2rgb_href	)		,
	.i_r	(yuv2rgb_r	)		,
	.i_g	(yuv2rgb_g	)		,
	.i_b	(yuv2rgb_b	)		,		
	       
	.o_hs	(average_hs	)		,
	.o_vs	(average_vs	)		,
	.o_en	(average_de	)		,	
	.o_r	(average_r	)		,
	.o_g	(average_g	)		,
	.o_b	(average_b	)
);
//mid_filter
wire mid_filter_de,mid_filter_hs,mid_filter_vs;//synthesis keep
wire [7:0] mid_filter_y,mid_filter_u,mid_filter_v;//synthesis keep
isp_mid_filter isp_mid_filter_inst
(
	.pclk       (vtc_clk	) ,
	.rst_n      (vtc_rstn	) ,
	.switch     (data[7]	) ,
	.in_href    (ee_de	) ,
	.in_hsync   (ee_hs	) ,
	.in_vsync   (ee_vs	) ,
	.in_y       (ee_y	) ,
	.in_u       (ee_u	) ,
	.in_v       (ee_v	) ,
	.out_href   (mid_filter_de	) ,
	.out_hsync  (mid_filter_hs	) ,
	.out_vsync  (mid_filter_vs	) ,
	.out_y      (mid_filter_y	) ,
	.out_u      (mid_filter_u	) ,
	.out_v      (mid_filter_v	)

);
//binary
wire binary_de,binary_hs,binary_vs;//synthesis keep
wire [7:0]binary_y,binary_u,binary_v;//synthesis keep
isp_binary isp_binary_inst
(
    .pclk		(vtc_clk	)		,
    .rst_n		(vtc_rstn	)		,
	.switch		(data[16]	)		,
    .in_href	(ee_de	)		,
    .in_hsync	(ee_hs	)		,
    .in_vsync	(ee_vs	)		,
    .in_y		(ee_y	)		,
    .in_u		(ee_u	)		,
    .in_v		(ee_v	)		,
               
    .out_href	(binary_de	)		,
    .out_hsync	(binary_hs	)		,
    .out_vsync	(binary_vs	)		,
    .out_y		(binary_y	)		,
    .out_u		(binary_u	)		,
    .out_v      (binary_v	)
);
//ersion
wire ersion_de,ersion_vs;//synthesis keep
wire [7:0] ersion_y,ersion_u,ersion_v;//synthesis keep
ersion ersion_inst
(
    
    .pclk			(vtc_clk	)		,
	.rst_n			(vtc_rstn	)		,
	.switch 		(data[17]	)		,
	.per_img_href	(binary_de	)		,
	.per_img_vsync	(binary_vs	)		,
	.per_img_bit	(binary_y	)		,
    .per_img_u		(binary_u	)		,
    .per_img_v		(binary_v	)		,
                
    .post_img_vsync (ersion_vs	)	    ,       
    .post_img_href  (ersion_de	) 		, 
    .post_img_bit   (ersion_y	)			,
   	.post_img_u   	(ersion_u	)			,
    .post_img_v     (ersion_v	)
);
//dilation
wire dilation_de,dilation_vs;//synthesis keep
wire [7:0] dilation_y,dilation_u,dilation_v;//synthesis keep
isp_dilation isp_dilation_inst
(
    
    .pclk			(vtc_clk	)		,
	.rst_n			(vtc_rstn	)		,
	.switch 		(data[18]	)		,
	.per_img_href	(ersion_de	)		,
	.per_img_vsync	(ersion_vs	)		,
	.per_img_bit	(ersion_y	)		,
    .per_img_u		(ersion_u	)		,
    .per_img_v		(ersion_v	)		,
                    
                    
    .post_img_vsync (dilation_vs	) 		,       
    .post_img_href  (dilation_de	)		, 
    .post_img_bit   (dilation_y	)		,
   	.post_img_u   	(dilation_u	)		,
    .post_img_v   	(dilation_v	)     
);

//outline
wire outline_hs,outline_vs,outline_de;//synthesis keep
wire [7:0]outline_data_y,outline_data_u,outline_data_v;//synthesis keep
outline outline_inst
(
	.i_clk	(vtc_clk	)	, 	
	.i_rst_n	(vtc_rstn	)	, 
	.i_hsyn	(contrast_de	)	,	
	.i_vsyn	(contrast_vs	)	,
	.i_r		(contrast_r	)	,
	.i_g		(contrast_g	)	,
	.i_b		(contrast_b	)	,	
	.i_de	(contrast_de	)	,
	.switch	(data[20]	)	,			 		
	.o_hsyn	(outline_hs	)	,	
	.o_vsyn	(outline_vs	)	,	
	.o_data_y	(outline_data_y	)	,
	.o_data_u	(outline_data_u	)	,
	.o_data_v   (outline_data_v	)	,	
	.o_de    	(outline_de	)
);
//sobel
wire o_sobel_hs,o_sobel_vs,o_sobel_de;//synthesis keep
wire [23:0] sobel_data;//synthesis keep
 sobel sobel_inst
(
	.i_clk			(vtc_clk	)	, 	
	.i_rst_n		(vtc_rstn	)	, 
	.i_hsyn			(contrast_de	)	,	
	.i_vsyn			(contrast_vs	)	,	
	.switch			(data[21]	)	,
	.i_r			(contrast_r	)	,
	.i_g			(contrast_g	)	,
	.i_b			(contrast_b	)	,	
	.i_de			(contrast_de	)	,	
	               
	.o_gray_hsyn	(o_sobel_hs	)	,	
	.o_gray_vsyn	(o_sobel_vs	)	,	
	.o_gray_data	(sobel_data	)	,	
	.o_gray_de      (o_sobel_de)
);

wire [7:0] data_ddr_2;
wire data2_de,data2_vs;
ispline u_ispline(
	.vtc_clk(vtc_clk),
    .vtc_rstn(vtc_rstn),
    .vtc_vs(!vtc_vs),
    .vtc_de(vtc_de_valid_d1),
    .vtc_data(ud_rdata_dif_d1),
    .o_csc_vs(data2_vs),
    .o_csc_de(data2_de),
    .o_csc_y (data_ddr_2)
 );
 
 wire o_frame_diff_hs,o_frame_diff_vs,o_frame_diff_de;//synthesis keep
 wire [7:0] frame_diff_data;
 image_frame_diff_algorithm u_frame_diff
(
	.i_clk(vtc_clk),
	.i_rst_n(vtc_rstn),
    
	.i_hsyn(o_csc_de),
	.i_vsyn(!o_csc_vs),
	.i_de(o_csc_de),
	.i_data_0(o_csc_y),	
	.i_data_1(data_ddr_2),		
	
	.o_hs(o_frame_diff_hs),
	.o_vs(o_frame_diff_vs),
	.o_de(o_frame_diff_de),	
	.o_data(frame_diff_data)
);

wire box_select_href,box_select_vs,box_select_hs;//synthesis keep
wire [7:0] box_select_r,box_select_g,box_select_b;//synthesis keep
image_box_select u_box_sel
(
	.i_clk(vtc_clk),
	.i_rst_n(vtc_rstn),
    
	.i_hsyn(o_frame_diff_hs),
	.i_vsyn(!o_frame_diff_vs),
	.i_de(o_frame_diff_de),
	.i_data(frame_diff_data),
    
	.i_hsyn_original(contrast_de),
	.i_vsyn_original(contrast_vs),
	.i_de_original(contrast_de),	
	.i_r_original(contrast_r),
	.i_g_original(contrast_g),
	.i_b_original(contrast_b),
	
	.o_hsyn(box_select_hs),
	.o_vsyn(box_select_vs),
	.o_de(box_select_href),
	.o_r(box_select_r),
	.o_g(box_select_g),
	.o_b(box_select_b)	
);

//bound cut
wire 			w_crop_vs, w_crop_hs;//synthesis keep 
wire			w_crop_de;//synthesis keep
wire 	[23:0] 	w_crop_data;//synthesis keep

bound_cut u_bound_cut 
(
.I_clk		    (vtc_clk),
.I_awb_vs 		(HDMI_VS),                         //(HDMI_VS),                (water_vs),                  
.I_awb_hs 		(HDMI_HS),                         //(HDMI_HS),                (water_hs),                  
.I_awb_de 		(HDMI_DE),                         //(HDMI_DE),                (water_en),                  
.I_awb_data 	({HDMI_R,HDMI_G,HDMI_B}),          //({HDMI_R,HDMI_G,HDMI_B})({water_r,water_g,water_b}), , 
        
.O_awb_vs 		(w_crop_vs),
.O_awb_hs 		(w_crop_hs),
.O_awb_de 		(w_crop_de),
.O_awb_data     (w_crop_data)
    );


    uivtc#
    (
    .H_ActiveSize       (1920), //视频时间参数,行视频信号，一行有效(需要显示的部分)像素所占的时钟数，一个时钟对应一个有效像素
    .H_SyncStart        (1920+88), //视频时间参数,行同步开始，即多少时钟数后开始产生行同步信号 
    .H_SyncEnd          (1920+88+44),//视频时间参数,行同步结束，即多少时钟数后停止产生行同步信号，之后就是行有效数据部分
    .H_FrameSize        (1920+88+44+148), //视频时间参数,行视频信号，一行视频信号总计占用的时钟数

    .V_ActiveSize       (1080),//视频时间参数,场视频信号，一帧图像所占用的有效(需要显示的部分)行数量，通常说的视频分辨率即H_ActiveSize*V_ActiveSize
    .V_SyncStart        (1080+4),//视频时间参数,场同步开始，即多少行数后开始产生场同步信号 
    .V_SyncEnd          (1080+4+5), //视频时间参数,场同步结束，多少行后停止产生长同步信号  
    .V_FrameSize        (1080+4+5+36) //视频时间参数,场视频信号，一帧视频信号总计占用的行数量       
    )
    uivtc_inst
    (
    .I_vtc_clk(vtc_clk),  //系统时钟 
    .I_vtc_rstn(vtc_rstn&&!data_23_edg&&!uart_data_23_edg),//系统复位
    .O_vtc_vs  (vtc_vs),//场同步输出
    .O_vtc_hs  (vtc_hs),//行同步输出
    .O_vtc_de_valid(vtc_de_valid)//视频数据有效
    );


    //hdmi 输出IP
    hdmi_tx#(
    //HDMI视频参数设置       
    .H_ActiveSize       (1920), //视频时间参数,行视频信号，一行有效(需要显示的部分)像素所占的时钟数，一个时钟对应一个有效像素
    .H_SyncStart        (1920+88), //视频时间参数,行同步开始，即多少时钟数后开始产生行同步信号 
    .H_SyncEnd          (1920+88+44),//视频时间参数,行同步结束，即多少时钟数后停止产生行同步信号，之后就是行有效数据部分
    .H_FrameSize        (1920+88+44+148), //视频时间参数,行视频信号，一行视频信号总计占用的时钟数

    .V_ActiveSize       (1080),//视频时间参数,场视频信号，一帧图像所占用的有效(需要显示的部分)行数量，通常说的视频分辨率即H_ActiveSize*V_ActiveSize
    .V_SyncStart        (1080+4),//视频时间参数,场同步开始，即多少行数后开始产生场同步信号 
    .V_SyncEnd          (1080+4+5), //视频时间参数,场同步结束，多少行后停止产生长同步信号  
    .V_FrameSize        (1080+4+5+36),  //视频时间参数,场视频信号，一帧视频信号总计占用的行数量               
        
    .VIDEO_VIC          ( 74       ),
    .VIDEO_TPG          ( "Disable"),//设置disable，用户数据驱动HDMI接口，否则设置eable产生内部测试图形
    .VIDEO_FORMAT       ( "RGB444" )//设置输入数据格式为RGB格式
    )u_hdmi_tx
    (
    .I_pixel_clk        ( S_hdmi_clk           ),//像素时钟
    .I_serial_clk       ( S_serial_clk           ),//串行发送时钟
    .I_rst              ( S_rst || data_23_edg || uart_data_23_edg             ),//异步复位信号，高电平有效

    .I_video_rgb_enable (1'b1                ),//是否使能RGB输入接口，设置1使能，否则采用stream video时序接口  
    .I_video_in_vs      (w_crop_vs            ),//RGB 输入VS 帧同步
    .I_video_in_de      (w_crop_de            ),//RGB 输入de有效
    .I_video_in_data    (w_crop_data   ), //视频输入数据     

    .O_hdmi_clk_p       ( O_hdmi_clk_p       ),//HDMI时钟通道
    .O_hdmi_tx_p        ( O_hdmi_tx_p        )//HDMI数据通道
   );


    video_cutting u_video_cutting(
        .I_clk              ( S_hs_rx_clk            ),
        .I_rst_n            ( ~S_rst                 ),
    
        .I_raw8_frame_start ( S_raw8_frame_start     ),
        .I_raw8_frame_end   ( S_raw8_frame_end       ),
        .I_raw8_valid       ( S_raw8_valid           ),
        .I_raw8_data        ( S_raw8_data            ),

        .O_raw8_frame_start ( S_raw8_cut_frame_start ),
        .O_raw8_frame_end   ( S_raw8_cut_frame_end   ),
        .O_raw8_valid       ( S_raw8_cut_valid       ),
        .O_raw8_data        ( S_raw8_cut_data        )
    );


    raw10_unpacket u_raw10_unpacket(
        .I_clk                ( S_hs_rx_clk          ), 
        .I_rst_n              ( ~S_rst               ),
                                                     
        .I_csi_frame_start    ( S_csi_frame_start    ),
        .I_csi_frame_end      ( S_csi_frame_end      ),
        .I_csi_valid          ( S_csi_valid          ),
        .I_csi_data           ( S_csi_data           ),
        
       	.I_camera_black_level ( S_camera_black_level ),

        .O_raw8_frame_start   ( S_raw8_frame_start   ),
        .O_raw8_frame_end     ( S_raw8_frame_end     ),
        .O_raw8_valid         ( S_raw8_valid         ),
        .O_raw8_data          ( S_raw8_data          )
    );


    csi_unpacket u_csi_unpacket(
        .I_clk             ( S_hs_rx_clk       ),
        .I_rst_n           ( ~S_rst            ),

        .I_hs_valid        ( S_hs_rx_valid     ),
        .I_hs_data         ( S_hs_rx_data      ),

        .O_csi_frame_start ( S_csi_frame_start ),
        .O_csi_frame_end   ( S_csi_frame_end   ),
        .O_csi_rx_vsync0	( S_csi_rx_vsync0	),
    	.O_csi_rx_hsync0	( S_csi_rx_hsync0	),
        .O_csi_valid       ( S_csi_valid       ),
        .O_csi_data        ( S_csi_data        )
    );


    mipi_dphy_rx_ph1a_mipiio_wrapper#(
        .LANE_NUM              ( 4 ),
        .BYTE_NUM              ( 1 )
    )u_mipi_dphy_rx_ph1a_mipiio_wrapper(
        .I_lp_clk              ( S_clk_70m       ), 
        .I_rst                 ( S_rst           ),
 
        .I_clk_lane_in_delay   ( 9'd0            ),
        .I_data_lane0_in_delay ( 9'd0            ),
        .I_data_lane1_in_delay ( 9'd0            ),
        .I_data_lane2_in_delay ( 9'd0            ),
        .I_data_lane3_in_delay ( 9'd0            ),

        .I_lane_invert         ( 4'b0000         ),//1101 

        .O_hs_rx_clk           ( S_hs_rx_clk     ),
        .O_hs_rx_valid         ( S_hs_rx_valid   ),
        .O_hs_rx_data          ( S_hs_rx_data    ),

        .O_lp_rx_lane0_p       (  ),
        .O_lp_rx_lane0_n       (  ),

        .I_lp_tx_en            ( 1'b0            ),
        .I_lp_tx_lane0_p       ( 1'b0            ),
        .I_lp_tx_lane0_n       ( 1'b0            ),

        .O_lane_error          ( S_lane_error    )
    );
    
        //wire define
wire             clk_ref        ;      /*synthesis keep*/
wire             clk_ref_180deg ;
wire             locked         ;
wire             wr_start_en    ;      //开始写SD卡数据信号
wire     [31:0]  wr_sec_addr    ;      //写数据扇区地址    
wire     [7:0]  wr_data        ;      /*synthesis keep*///写数据            
wire             rd_start_en    ;      /*synthesis keep*///开始写SD卡数据信号
wire     [31:0]  rd_sec_addr    ;      //读数据扇区地址    
wire             error_flag     ;      //SD卡读写错误的标志
wire             wr_busy        ;      //写数据忙信号
wire             wr_req         ;      //写数据请求信号
wire             rd_busy        ;      /*synthesis keep*///读忙信号
wire             rd_val_en      ;      /*synthesis keep*///数据读取有效使能信号
wire     [7:0]  rd_val_data    ;      /*synthesis keep*///读数据
wire             sd_init_done   ;      //SD卡初始化完成信号
wire 			 wr_req_valid	;
reg wr_req_r,wr_req_rr;
reg [7:0]wr_data_r;
always @(posedge clk_ref) begin
	wr_req_r <= wr_req;
    wr_req_rr <= wr_req_r;
    wr_data_r <= wr_data;
end
/*
wire capture_key_write;
key_delay key_delay_inst00
(
    .clk			(I_sys_clk_25m	)		,        // 50MHz时钟输入
    .rst_n			(~S_rst	)		,      // 复位信号，低电平有效
    .button_in		(I_key_in	)		,  		// 按键输入信号
    .button_out 	(capture_key_write	)			 // 消抖后的按键输出信号
);

wire capture_key_read;
key_delay key_delay_inst01
(
    .clk			(I_sys_clk_25m	)		,        // 50MHz时钟输入
    .rst_n			(~S_rst	)		,      // 复位信号，低电平有效
    .button_in		(I_key_in2	)		,  		// 按键输入信号
    .button_out 	(capture_key_read	)			 // 消抖后的按键输出信号
);*/

reg ctrl_key;
     
    reg sd_vs;
    reg [26:0] cnt;
    reg cut;
    reg [7:0] r_w,r_stop;
    reg [7:0] r_r;
    reg work = 0;
    
    reg read_sd;
    reg [31:0] cnt_r;
    reg ctrl_key_r;
    reg sd_vs_r;
    reg work_r = 0;
    wire [AXI_ADDR_WIDTH -1'b1: 0] R_BASEADDR,W_BASEADDR;
    initial begin
    	work <= 1'b0;
        work_r <= 1'b0;
    end
    always @(posedge clk_ref) begin
    	if (ddr_sd_cmd3) begin
        	cut <= 1'b0;
        	cnt <= 1'b0;
            sd_vs <= 1'b0;
            ctrl_key <= 1'b0;
            work <= 1'b1;
        end else if (S_rst) begin
        	cut <= 1'b0;
        	cnt <= 1'b0;
            sd_vs <= 1'b0;
            ctrl_key <= 1'b0;
            work <= 1'b0;
        end else if (work) begin
        	if (cnt < 27'b000_0000_0001_0000_0000_0000_0000) begin
            	cnt <= cnt + 1'b1;
                if (cnt == 27'b000_0000_0000_0000_0000_0000_1000) begin
                	cut <= 1'b1;
                    sd_vs <= 1'b1;
                end
                if (cnt == 27'b000_0000_0000_0000_0100_0000_0000) begin
                	ctrl_key <= 1'b1;
                    sd_vs <= 1'b0;
                end
            end else begin
            	cnt <= cnt;
                sd_vs <= 1'b0;
                ctrl_key <= 1'b0;
                if (done && ud_wvs) begin
                	cut <= 1'b0;
                    work <= 1'b0;
                end
            end
        end else begin
        	cut <= 1'b0;
        	cnt <= 1'b0;
            sd_vs <= 1'b0;
            ctrl_key <= 1'b0;
            work <= 1'b0;
        end
    end
    wire [7:0] sdio_readdata;//synthesis keep
    wire sdio_readde;//synthesis keep
    sc_test#(
        .iPIXEL_COLOR(1)
    ) u6_sc_test(
    .vin_clk(clk_ref),
	.rst_n(pll_locked),
	.frame_sync_n(!sd_vs),	//输入视频帧同步复位，低有效
	.vin_dat(wr_data_r),			//输入视频数据
	.vin_valid(wr_req_rr),			//输入视频数据有效
	.vin_ready(nextDin1),			//输入准备好
	.vout_dat(sdio_readdata),			//输出视频数据
	.vout_valid(sdio_readde),			//输出视频数据有效
	.vout_ready(1'b1),			//输出准备好
	.vin_xres(1920),			//输入视频水平分辨率
	.vin_yres(1080),			//输入视频垂直分辨率
	.vout_xres(1920),			//输出视频水平分辨率
	.vout_yres(1080)			//输出视频垂直分辨率
);
reg [31:0]wd_32;//synthesis keep
reg wden;//synthesis keep
reg [2:0] wdcnt;//synthesis keep
	always @(posedge clk_ref) begin
    	if (S_rst) begin
        	wd_32 <= 1'b0;
            wdcnt <= 1'b1;
        end else begin
        	if (sdio_readde) begin
            	wd_32 <= {wd_32[23:0],sdio_readdata};
                if (wdcnt < 3)
                	wdcnt <= wdcnt + 1'b1;
                else
                	wdcnt <= 1'b0;
            end
        end
    end
    always @(posedge clk_ref) begin
    	if (S_rst) begin
        	wden <= 1'b0;
        end else begin
        	if (wdcnt == 1 && sdio_readde)
            	wden <= 1'b1;
            else
            	wden <= 1'b0;
        end
    end
    
    always @(posedge O_axi_clk) begin
    	if (data[39]) begin
        	r_w <= wbuf_sync_o;
            r_r <= rbuf_sync_o1;
        end else begin
        	r_w <= r_w;
            r_r <= r_r;
        end
    end
    
    
   always @(posedge O_axi_clk) begin
   		if (data_36_edg || uart_data_36_edg) begin
           	r_stop <= wbuf_sync_o;
        end else if (S_rst) begin
        	r_stop <= 1'b0;
        end else begin
        	r_stop <= r_stop;
        end
    end
   
 

assign wbuf_sync_o01 = ddr_sd_cmd2 ? stay_sd : stop_cont ? r_stop : cut ? r_w : wbuf_sync_o;
assign rbuf_sync_o = read_sd_cmd ? read_sdcnt : rbuf_sync_o01;
assign R_BASEADDR = read_sd_cmd ? 27'b110_0000_0000_0000_0000_0000_0000 : 1'b0;
assign W_BASEADDR = ddr_sd_cmd2 ? 27'b110_0000_0000_0000_0000_0000_0000 : 1'b0;
assign LED_INIT = init_done_flag;

wire done,r_done;
wire [2:0] mode;
wire init_done_flag;
sdio_top u_sdio(
    .sysclk(clk_ref),
    .resetn(~S_rst),
    .sdio_clk(sdio_clk),
    .cmd_io(cmd_io),
    .data_io(data_io),
    .data_ready(wr_req),
    .wd_data(wr_data),
    .rd_data(rd_val_data),
    .w_done(done),
    .r_done(r_done),
    .mode(mode),
    .init_done_flag(init_done_flag),
	.button(ctrl_key), // 按键输入
    .button1(ctrl_key_r)
);

    
endmodule