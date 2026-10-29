module ctrl(
    input   wire            sys_clk     ,   //系统时钟，50MHz
    input   wire            sys_rst_n   ,   //复位信号，低有效
    input   wire            rx          ,   //串口接收数据
	output  wire		[47:0]	po_data,
    output wire po_flag

 );
//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//

//parameter define
parameter   UART_BPS    =   18'd115200;       //比特率
parameter   CLK_FREQ    =   26'd25_000_000; //时钟频率

//wire  define
wire    [47:0]    po_data         ;   //接收数据

//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//

//--------------------uart_rx_inst------------------------
//wire po_flag;
uart_rx
#(
    .UART_BPS    (UART_BPS  ),   //串口波特率
    .CLK_FREQ    (CLK_FREQ  )    //时钟频率
)
uart_rx_inst1(
    .sys_clk     (sys_clk   ),   //系统时钟50Mhz
    .sys_rst_n   (sys_rst_n ),   //全局复位
    .rx          (rx        ),   //串口接收数据

    .po_data     (po_data   ),   //串转并后的8bit数据
    .po_flag     (po_flag   )    //接收数据完成标志信号没用到可不接
);
/*
always@(posedge sys_clk or negedge sys_rst_n )begin
	if(~sys_rst_n)begin
		data<=1'b0;		
	end else begin
		data<=po_data;
	end
end
*/
endmodule
