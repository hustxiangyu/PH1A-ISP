
/*******************************MILIANKE*******************************
*Company : MiLianKe Electronic Technology Co., Ltd.
*WebSite:https://www.milianke.com
*TechWeb:https://www.uisrc.com
*tmall-shop:https://milianke.tmall.com
*jd-shop:https://milianke.jd.com
*taobao-shop1: https://milianke.taobao.com
*Create Date: 2023/03/23
*Module Name:
*File Name:
*Description: 
*The reference demo provided by Milianke is only used for learning. 
*We cannot ensure that the demo itself is free of bugs, so users 
*should be responsible for the technical problems and consequences
*caused by the use of their own products.
*Copyright: Copyright (c) MiLianKe
*All rights reserved.
*Revision: 1.0
*Signal description
*1) I_ input
*2) O_ output
*3) IO_ input output
*4) S_ system internal signal
*5) _n activ low
*6) _dg debug signal 
*7) _r delay or register
*8) _s state mechine
*********************************************************************/

/*************uifdma_axi_ddr(DDR controller)*************
--版本号1.0
--以下是米联客设计的uifdma_axi_ddr(DDR controller)DDR控制器
--1.代码简洁，代码结构清晰，逻辑设计严谨
--2.使用方便，基于AXI总线接口设计的，DDR控制器，用户接口采用米联客的FDMA时序接口，只需要给出需要burst的设计长度，以及burst请求，就可以自动完成DDR数据的读写burst
--3.参数灵活设置，支持AXI1.0 AXI3.0 AXI4.0协议，支持AXI burst长度设置，而用户端的FDMA接口只要给出总的数据长度，无需关注每次AXI的burst长度
*********************************************************************/

module uifdma_axi_ddr#
(
parameter SIMULATION            =    "TRUE",//"TRUE"
parameter DRAM_BYTE_NUM         =    4,
parameter APP_ADDR_WIDTH        =    27,  // 128 x 16bit 
parameter AXI_ID_WIDTH          =    4,                                       
parameter AXI_ADDR_WIDTH        =    APP_ADDR_WIDTH+2,                                     
parameter AXI_DATA_WIDTH        =    DRAM_BYTE_NUM * 8 * 8,
parameter APP_DATA_WIDTH        =    DRAM_BYTE_NUM * 8 * 8,
parameter APP_MASK_WIDTH        =    DRAM_BYTE_NUM * 8,
parameter M_AXI_MAX_BURST_LEN   =    16
) 
(

input                                     I_ddr_clk   , 
input                                     I_sys_rstn  ,
output                                    O_ddr_pll_locked ,   
output                                    O_init_calib_complete ,
output    [14:0]                          ddr_addr    , // 256M x 16bit
output    [ 2:0]                          ddr_ba      ,
output    [ 0:0]                          ddr_cke     ,
output    [ 0:0]                          ddr_odt     ,
output    [ 0:0]                          ddr_cs_n    ,
output                                    ddr_ras_n   ,
output                                    ddr_cas_n   ,
output                                    ddr_we_n    ,
output    [ 0:0]                          ddr_ck_p    ,
output    [ 0:0]                          ddr_ck_n    ,
output                                    ddr_reset_n ,
inout     [DRAM_BYTE_NUM     - 1 : 0]     ddr_dm      ,
inout     [DRAM_BYTE_NUM * 8 - 1 : 0]     ddr_dq      ,
inout     [DRAM_BYTE_NUM     - 1 : 0]     ddr_dqs_p   ,
inout     [DRAM_BYTE_NUM     - 1 : 0]     ddr_dqs_n   ,
input                                     I_uart_rxd  ,
output                                    O_uart_txd  ,

output                                    O_axi_clk      ,//synthesis keep 
input     [AXI_ADDR_WIDTH-1 : 0]          I_fdma_waddr   ,//synthesis keep//FDMA写通道地址
input                                     I_fdma_wareq   ,//synthesis keep//FDMA写通道请求
input     [15 : 0]                        I_fdma_wsize   ,//synthesis keep//FDMA写通道一次FDMA的传输大小                                            
output                                    O_fdma_wbusy   ,//synthesis keep//FDMA处于BUSY状态，AXI总线正在写操作  
				
input     [AXI_DATA_WIDTH-1 :0]           I_fdma_wdata	 ,//synthesis keep/FDMA写数据
output                                    O_fdma_wvalid  ,//synthesis keep//FDMA 写有效
input	                                    I_fdma_wready	 ,//synthesis keep//FDMA写准备好，用户可以写数据

input     [AXI_ADDR_WIDTH-1 : 0]          I_fdma_raddr   ,//synthesis keep// FDMA读通道地址
input                                     I_fdma_rareq   ,//synthesis keep// FDMA读通道请求
input     [15 : 0]                        I_fdma_rsize   ,//synthesis keep// FDMA读通道一次FDMA的传输大小                                      
output                                    O_fdma_rbusy   ,//synthesis keep// FDMA处于BUSY状态，AXI总线正在读操作 
				
output   [AXI_DATA_WIDTH-1 :0]            O_fdma_rdata	 ,//synthesis keep// FDMA读数据
output                                    O_fdma_rvalid  ,//synthesis keep// FDMA 读有效
input	                                    I_fdma_rready   //synthesis keep// FDMA读准备好，用户可以读数据



);

localparam DQS_WIDTH  = DRAM_BYTE_NUM ;
localparam DQ_WIDTH   = DQS_WIDTH*8    ;
localparam DM_WIDTH   = DQS_WIDTH      ;
localparam BANK_WIDTH = 3  ;
localparam ADDR_WIDTH = 14 ;
localparam ROW_WIDTH  = 14 ;
localparam COL_WIDTH  = 10 ;
localparam CWL        = 6 ;//6  ; 5
localparam CL         = 7 ;//7  ; 6

//-------- User Clock --------//
wire                      user_clk0        ;
wire                      pll_locked       ;
wire                      ddrphy_cal_done  ;
wire [             31:0]  user_led         ;

wire                      dfi_clk          ;
wire [             3:0]   dfi_reset_n      ;
wire [             3:0]   dfi_cke          ;
wire [             3:0]   dfi_odt          ;
wire [             3:0]   dfi_cs_n         ;
wire [             3:0]   dfi_ras_n        ;
wire [             3:0]   dfi_cas_n        ;
wire [             3:0]   dfi_we_n         ;
wire [BANK_WIDTH*4-1:0]   dfi_bank         ; 
wire [ADDR_WIDTH*4-1:0]   dfi_address      ;
wire [DQS_WIDTH *4-1:0]   dfi_wrdata_en    ;
wire [DQ_WIDTH  *8-1:0]   dfi_wrdata       ;
wire [DM_WIDTH  *8-1:0]   dfi_wrdata_mask  ;
wire [DQS_WIDTH *4-1:0]   dfi_rddata_en    ;
wire [DQS_WIDTH *4-1:0]   dfi_rddata_valid ;
wire [DQ_WIDTH  *8-1:0]   dfi_rddata       ;
wire [DM_WIDTH  *8-1:0]   dfi_rddata_dbi_n ;

wire                      dfi_mtest_running  ; 
wire                      dfi_mtest_flashing ; 
wire                      dfi_mtest_done     ; 
wire                      dfi_mtest_err      ; 

wire                      ddr3_app_rd_data_valid ;//synthesis keep
wire                      data_compare_error;

assign O_axi_clk        =  dfi_clk;
assign O_ddr_pll_locked =  pll_locked;
assign O_init_calib_complete = ddrphy_cal_done;

reg [15:0] rc_sys_rstn = 0; 
reg r_sys_rstn = 0; 
always @(posedge I_ddr_clk) begin
   rc_sys_rstn <= rc_sys_rstn[15] == 1'b0 ? rc_sys_rstn +1'b1 : rc_sys_rstn;

	r_sys_rstn <= rc_sys_rstn[15]; 
end

//wire I_sys_rstn = r_sys_rstn; 


//例化DDR IP
ddr_ip   u_ddr_phy(
.sys_clk_p                  ( I_ddr_clk        ),
.sys_rstn                   ( I_sys_rstn       ),
.pll_locked                 ( pll_locked       ),

// DDR signals
.ddr_reset_n                ( ddr_reset_n      ),
.ddr_addr                   ( ddr_addr         ),
.ddr_ba                     ( ddr_ba           ),
.ddr_ck_p                   ( ddr_ck_p         ),
.ddr_ck_n                   ( ddr_ck_n         ),
.ddr_cke                    ( ddr_cke          ),
.ddr_cs_n                   ( ddr_cs_n         ),
.ddr_ras_n                  ( ddr_ras_n        ),
.ddr_cas_n                  ( ddr_cas_n        ),
.ddr_we_n                   ( ddr_we_n         ),
.ddr_odt                    ( ddr_odt          ),
.ddr_dqs_p                  ( ddr_dqs_p        ),
.ddr_dqs_n                  ( ddr_dqs_n        ),
.ddr_dq                     ( ddr_dq           ),
.ddr_dm                     ( ddr_dm           ),

// DFI bus signals, between hard controller and users or top-level systems
.dfi_clk                    ( dfi_clk          ),
.dfi_reset_n                ( dfi_reset_n      ),
.dfi_cke                    ( dfi_cke          ),
.dfi_odt                    ( dfi_odt          ),
.dfi_cs_n                   ( dfi_cs_n         ),
//  .dfi_act_n              ( dfi_act_n        ),
.dfi_ras_n                  ( dfi_ras_n        ),
.dfi_cas_n                  ( dfi_cas_n        ),
.dfi_we_n                   ( dfi_we_n         ),
//  .dfi_bg                 ( dfi_bg           ),  
.dfi_bank                   ( dfi_bank         ),
.dfi_address                ( dfi_address      ),
.dfi_wrdata_en              ( dfi_wrdata_en    ),
.dfi_wrdata                 ( dfi_wrdata       ),
.dfi_wrdata_mask            ( dfi_wrdata_mask  ),
.dfi_rddata_en              ( dfi_rddata_en    ),
.dfi_rddata_valid           ( dfi_rddata_valid ),
.dfi_rddata                 ( dfi_rddata       ),
.dfi_rddata_dbi_n           ( dfi_rddata_dbi_n ),

.dfi_ctrlupd_req            ( 2'b0  ),
.dfi_ctrlupd_ack            (       ),
.dfi_phyupd_req             (       ),
.dfi_phyupd_ack             ( 2'h0  ),
.dfi_phyupd_type            (       ),

.uart_rxd                   ( I_uart_rxd ),
.uart_txd                   ( O_uart_txd ),
.ddr_init_cal_done          ( ddrphy_cal_done )
 
 );


localparam  MEM_ADDR_ORDER        ="ROW_COLUMN_BANK";
localparam  ECC                   ="OFF";

wire [APP_ADDR_WIDTH-1:0] ddr3_app_addr          ;
wire [               2:0] ddr3_app_cmd           ;
wire                      ddr3_app_en            ;
wire [APP_DATA_WIDTH-1:0] ddr3_app_wdf_data      ;
wire                      ddr3_app_wdf_end       ;
wire [APP_MASK_WIDTH-1:0] ddr3_app_wdf_mask      ;
wire                      ddr3_app_wdf_wren      ;
wire [APP_DATA_WIDTH-1:0] ddr3_app_rd_data       ;//synthesis keep
wire                      ddr3_app_rd_data_end   ; 
wire                      ddr3_app_rdy           ;
wire                      ddr3_app_wdf_rdy       ;
wire                      ddr3_clk               ;
wire                      ddr3_rst               ;
wire                      wr_rd_complete         ;//synthesis keep
wire                      init_calib_complete    ;//synthesis keep

assign init_calib_complete = ddrphy_cal_done ; 



//例化DDR 控制器，控制器只支持APP接口
mc_wrapper  #(
.SIMULATION                 ( SIMULATION            ),
.DRAM_TYPE                  ( "DDR3"                ),
.DQS_WIDTH                  ( DQS_WIDTH             ),
.BANK_WIDTH                 ( BANK_WIDTH            ),
.BANK_GROUP_WIDTH           ( 0                     ),  
.ADDR_WIDTH                 ( ADDR_WIDTH            ),
.ROW_WIDTH                  ( ROW_WIDTH             ),
.CWL                        ( CWL                   ),
.CL                         ( CL                    )
) 
u_alc_ddr3_mc (
.clk                        ( dfi_clk                ),
.rst                        (~pll_locked             ),
.init_calib_complete        ( init_calib_complete    ),

// native user interface
.ddr_app_addr               ( ddr3_app_addr          ),
.ddr_app_cmd                ( ddr3_app_cmd           ),
.ddr_app_en                 ( ddr3_app_en            ),
.ddr_app_wdf_data           ( ddr3_app_wdf_data      ),
.ddr_app_wdf_end            ( ddr3_app_wdf_end       ),
.ddr_app_wdf_mask           ( ddr3_app_wdf_mask      ),
.ddr_app_wdf_wren           ( ddr3_app_wdf_wren      ),
.ddr_app_rd_data            ( ddr3_app_rd_data       ),
.ddr_app_rd_data_end        ( ddr3_app_rd_data_end   ),
.ddr_app_rd_data_valid      ( ddr3_app_rd_data_valid ),
.ddr_app_rdy                ( ddr3_app_rdy           ),
.ddr_app_wdf_rdy            ( ddr3_app_wdf_rdy       ),

// dfi interface 
.dfi_reset_n                ( dfi_reset_n            ),
.dfi_cke_p                  ( dfi_cke                ),
.dfi_cs_n_p                 ( dfi_cs_n               ),
.dfi_odt_p                  ( dfi_odt                ),
//  .dfi_act_n_p                ( dfi_act_n              ),
.dfi_ras_n_p                ( dfi_ras_n              ),
.dfi_cas_n_p                ( dfi_cas_n              ),
.dfi_we_n_p                 ( dfi_we_n               ),
//  .dfi_bg_p                   ( dfi_bg                 ),
.dfi_bank_p                 ( dfi_bank               ),
.dfi_address_p              ( dfi_address            ),
.dfi_wrdata_en_p            ( dfi_wrdata_en          ),
.dfi_wrdata_p               ( dfi_wrdata             ),
.dfi_wrdata_mask_p          ( dfi_wrdata_mask        ),
.dfi_rddata_en_p            ( dfi_rddata_en          ),
.dfi_rddata_valid_w         ( dfi_rddata_valid       ), // {{(DQS_WIDTH *4){1'b0}},
.dfi_rddata_w               ( dfi_rddata             ),
.dfi_rddata_dbi_w           ( dfi_rddata_dbi_n       )
);


wire                             ddr3_data_msmatch_err;
wire                             ddr3_write_err;
wire                             ddr3_read_err;
wire [3:0]                       ddr3_s_axi_awid;
wire [AXI_ADDR_WIDTH-1:0]        ddr3_s_axi_awaddr;
wire [7:0]                       ddr3_s_axi_awlen;
wire [2:0]                       ddr3_s_axi_awsize;
wire [1:0]                       ddr3_s_axi_awburst;
wire [3:0]                       ddr3_s_axi_awcache;
wire [2:0]                       ddr3_s_axi_awprot;
wire                             ddr3_s_axi_awvalid;
wire                             ddr3_s_axi_awready;
  // Slave Interface Write Data Ports
wire [AXI_DATA_WIDTH-1:0]        ddr3_s_axi_wdata;
wire [(AXI_DATA_WIDTH/8)-1:0]    ddr3_s_axi_wstrb;
wire                             ddr3_s_axi_wlast;
wire                             ddr3_s_axi_wvalid;
wire                             ddr3_s_axi_wready;
   // Slave Interface Write Response Ports
wire                             ddr3_s_axi_bready;
wire [3:0]                       ddr3_s_axi_bid;
wire [1:0]                       ddr3_s_axi_bresp;
wire                             ddr3_s_axi_bvalid;
   // Slave Interface Read Address Ports
wire [3:0]                       ddr3_s_axi_arid;
wire [AXI_ADDR_WIDTH-1:0]        ddr3_s_axi_araddr;
wire [7:0]                       ddr3_s_axi_arlen;
wire [2:0]                       ddr3_s_axi_arsize;
wire [1:0]                       ddr3_s_axi_arburst;
wire [3:0]                       ddr3_s_axi_arcache;
wire                             ddr3_s_axi_arvalid;
wire                             ddr3_s_axi_arready;
   // Slave Interface Read Data Ports
wire                             ddr3_s_axi_rready;
wire [3:0]                       ddr3_s_axi_rid;
wire [AXI_DATA_WIDTH-1:0]        ddr3_s_axi_rdata;
wire [1:0]                       ddr3_s_axi_rresp;
wire                             ddr3_s_axi_rlast;
wire                             ddr3_s_axi_rvalid;

reg     calDone;
always@(posedge dfi_clk)begin
 if(~pll_locked)
     calDone<= 1'b0;
 else
   calDone <= ddrphy_cal_done ? 1'b1 : calDone;
end

//例化APP接口转AXI接口
alc_axi u_ddr_axi
(
.aclk                                   (dfi_clk),
// Slave Interface Write Address Ports
.aresetn                                (pll_locked),
.s_axi_awid                             (ddr3_s_axi_awid),
.s_axi_awaddr                           (ddr3_s_axi_awaddr),
.s_axi_awlen                            (ddr3_s_axi_awlen),
.s_axi_awsize                           (ddr3_s_axi_awsize),
.s_axi_awburst                          (ddr3_s_axi_awburst),
.s_axi_awlock                           (1'b0),
.s_axi_awcache                          (ddr3_s_axi_awcache),
.s_axi_awprot                           (ddr3_s_axi_awprot),
.s_axi_awqos                            (4'b0),
.s_axi_awvalid                          (ddr3_s_axi_awvalid),
.s_axi_awready                          (ddr3_s_axi_awready),
// Slave Interface Write Data Ports
.s_axi_wdata                            (ddr3_s_axi_wdata),
.s_axi_wstrb                            (ddr3_s_axi_wstrb),
.s_axi_wlast                            (ddr3_s_axi_wlast),
.s_axi_wvalid                           (ddr3_s_axi_wvalid),
.s_axi_wready                           (ddr3_s_axi_wready),
// Slave Interface Write Response Ports
.s_axi_bid                              (ddr3_s_axi_bid),
.s_axi_bresp                            (ddr3_s_axi_bresp),
.s_axi_bvalid                           (ddr3_s_axi_bvalid),
.s_axi_bready                           (ddr3_s_axi_bready),
// Slave Interface Read Address Ports
.s_axi_arid                             (ddr3_s_axi_arid),
.s_axi_araddr                           (ddr3_s_axi_araddr),
.s_axi_arlen                            (ddr3_s_axi_arlen),
.s_axi_arsize                           (ddr3_s_axi_arsize),
.s_axi_arburst                          (ddr3_s_axi_arburst),
.s_axi_arlock                           (1'b0),
.s_axi_arcache                          (ddr3_s_axi_arcache),
.s_axi_arprot                           (3'b0),
.s_axi_arqos                            (4'b0),
.s_axi_arvalid                          (ddr3_s_axi_arvalid),
.s_axi_arready                          (ddr3_s_axi_arready),
// Slave Interface Read Data Ports
.s_axi_rid                              (ddr3_s_axi_rid),
.s_axi_rdata                            (ddr3_s_axi_rdata),
.s_axi_rresp                            (ddr3_s_axi_rresp),
.s_axi_rlast                            (ddr3_s_axi_rlast),
.s_axi_rvalid                           (ddr3_s_axi_rvalid),
.s_axi_rready                           (ddr3_s_axi_rready),

// MC Master Interface
//CMD PORT
.mc_app_en                              (ddr3_app_en),
.mc_app_cmd                             (ddr3_app_cmd),
.mc_app_sz                              (),
.mc_app_addr                            (ddr3_app_addr),
.mc_app_hi_pri                          (ddr3_app_hi_pri),
.mc_app_autoprecharge                   (ddr3_app_autoprecharge),
.mc_app_rdy                             (ddr3_app_rdy),
.mc_init_complete                       (calDone),

//DATA PORT
.mc_app_wdf_wren                        (ddr3_app_wdf_wren),
.mc_app_wdf_mask                        (ddr3_app_wdf_mask),
.mc_app_wdf_data                        (ddr3_app_wdf_data),
.mc_app_wdf_end                         (ddr3_app_wdf_end),
.mc_app_wdf_rdy                         (ddr3_app_wdf_rdy),

.mc_app_rd_valid                        (ddr3_app_rd_data_valid),
.mc_app_rd_data                         (ddr3_app_rd_data),
.mc_app_rd_end                          (ddr3_app_rd_data_end),
.mc_app_ecc_multiple_err                (ddr3_app_ecc_multiple_err)
);

//例化米联客uiFDMA AXI 控制器 IP
uiFDMA#
(
.M_AXI_ID_WIDTH(AXI_ID_WIDTH)           ,//ID位宽
.M_AXI_ADDR_WIDTH(AXI_ADDR_WIDTH)		,//内存地址位宽
.M_AXI_DATA_WIDTH(AXI_DATA_WIDTH)		,//AXI总线的数据位宽
.M_AXI_MAX_BURST_LEN (32)                //AXI总线的burst 大小，对于AXI4，支持任意长度，对于AXI3以下最大16
)
uiFDMA_inst
(
.I_fdma_waddr(I_fdma_waddr)          ,//FDMA写通道地址
.I_fdma_wareq(I_fdma_wareq)          ,//FDMA写通道请求
.I_fdma_wsize(I_fdma_wsize)          ,//FDMA写通道一次FDMA的传输大小                                            
.O_fdma_wbusy(O_fdma_wbusy)          ,//FDMA处于BUSY状态，AXI总线正在写操作  
				
.I_fdma_wdata(I_fdma_wdata)		    ,//FDMA写数据
.O_fdma_wvalid(O_fdma_wvalid)        ,//FDMA 写有效
.I_fdma_wready(1'b1)		       ,//FDMA写准备好，用户可以写数据

.I_fdma_raddr(I_fdma_raddr)          ,// FDMA读通道地址
.I_fdma_rareq(I_fdma_rareq)          ,// FDMA读通道请求
.I_fdma_rsize(I_fdma_rsize)          ,// FDMA读通道一次FDMA的传输大小                                      
.O_fdma_rbusy(O_fdma_rbusy)          ,// FDMA处于BUSY状态，AXI总线正在读操作 
				
.O_fdma_rdata(O_fdma_rdata)		    ,// FDMA读数据
.O_fdma_rvalid(O_fdma_rvalid)        ,// FDMA 读有效
.I_fdma_rready(1'b1)		    ,// FDMA读准备好，用户可以读数据

//以下为AXI总线信号		
.M_AXI_ACLK                             (dfi_clk),
.M_AXI_ARESETN                          (pll_locked),
// Master Interface Write Address Ports
.M_AXI_AWID                             (ddr3_s_axi_awid),
.M_AXI_AWADDR                           (ddr3_s_axi_awaddr),
.M_AXI_AWLEN                            (ddr3_s_axi_awlen),
.M_AXI_AWSIZE                           (ddr3_s_axi_awsize),
.M_AXI_AWBURST                          (ddr3_s_axi_awburst),
.M_AXI_AWLOCK                           (),
.M_AXI_AWCACHE                          (ddr3_s_axi_awcache),
.M_AXI_AWPROT                           (ddr3_s_axi_awprot),
.M_AXI_AWQOS                            (),
.M_AXI_AWVALID                          (ddr3_s_axi_awvalid),
.M_AXI_AWREADY                          (ddr3_s_axi_awready),
// Master Interface Write Data Ports
.M_AXI_WDATA                            (ddr3_s_axi_wdata),
.M_AXI_WSTRB                            (ddr3_s_axi_wstrb),
.M_AXI_WLAST                            (ddr3_s_axi_wlast),
.M_AXI_WVALID                           (ddr3_s_axi_wvalid),
.M_AXI_WREADY                           (ddr3_s_axi_wready),
// Master Interface Write Response Ports
.M_AXI_BID                              (ddr3_s_axi_bid),
.M_AXI_BRESP                            (ddr3_s_axi_bresp),
.M_AXI_BVALID                           (ddr3_s_axi_bvalid),
.M_AXI_BREADY                           (ddr3_s_axi_bready),
// Master Interface Read Address Ports
.M_AXI_ARID                             (ddr3_s_axi_arid),
.M_AXI_ARADDR                           (ddr3_s_axi_araddr),
.M_AXI_ARLEN                            (ddr3_s_axi_arlen),
.M_AXI_ARSIZE                           (ddr3_s_axi_arsize),
.M_AXI_ARBURST                          (ddr3_s_axi_arburst),
.M_AXI_ARLOCK                           (),
.M_AXI_ARCACHE                          (ddr3_s_axi_arcache),
.M_AXI_ARPROT                           (),
.M_AXI_ARQOS                            (),
.M_AXI_ARVALID                          (ddr3_s_axi_arvalid),
.M_AXI_ARREADY                          (ddr3_s_axi_arready),
// Master Interface Read Data Ports
.M_AXI_RID                              (ddr3_s_axi_rid),
.M_AXI_RDATA                            (ddr3_s_axi_rdata),
.M_AXI_RRESP                            (ddr3_s_axi_rresp),
.M_AXI_RLAST                            (ddr3_s_axi_rlast),
.M_AXI_RVALID                           (ddr3_s_axi_rvalid),
.M_AXI_RREADY                           (ddr3_s_axi_rready)		
);

endmodule