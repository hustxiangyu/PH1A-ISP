module  rs485
(
    input   wire            sys_clk     ,   //系统时钟，50MHz
    input   wire            sys_rst_n   ,   //复位信号，低有效
    input   wire            rx          ,   //串口接收数据

    output  wire            tx          , //串口接收数据
	output  reg 			led0		,
	output  reg 			led1		,
	output  reg 			led2		,
	output  reg 			led3		
);

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//

//parameter define
parameter   UART_BPS    =   18'd115200;       //比特率
parameter   CLK_FREQ    =   26'd25_000_000; //时钟频率

//wire  define
wire    [7:0]    po_data         ;   //接收数据
wire    [7:0]   pi_data         ;   //发送数据
wire            pi_flag         ;   //发送标志信号
wire            water_key_flag  ;   //流水灯按键有效信号
wire            breath_key_flag ;   //呼吸灯按键有效信号
wire    [3:0]   led_out_w       ;   //流水灯
wire            led_out_b       ;   //呼吸灯

//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//

//--------------------uart_rx_inst------------------------
wire po_flag;
uart_rx
#(
    .UART_BPS    (UART_BPS  ),   //串口波特率
    .CLK_FREQ    (CLK_FREQ  )    //时钟频率
)
uart_rx_inst(
    .sys_clk     (sys_clk   ),   //系统时钟50Mhz
    .sys_rst_n   (sys_rst_n ),   //全局复位
    .rx          (rx        ),   //串口接收数据

    .po_data     (po_data   ),   //串转并后的8bit数据
    .po_flag     (po_flag   )    //接收数据完成标志信号没用到可不接
);


reg [7:0]data;
always@(posedge sys_clk )begin
	data<=po_data;
end
always@(posedge sys_clk or negedge sys_rst_n)begin
	if(~sys_rst_n)begin
		led0<=1'b0;
		led1<=1'b0;
		led2<=1'b0;
		led3<=1'b0;
	end else begin
		case(data)
			8'b0000_0001 : begin
					led0<=1'b1;
					led1<=1'b0;
					led2<=1'b0;
					led3<=1'b0;
			end
			8'b0000_0010 : begin
					led0<=1'b0;
					led1<=1'b1;
					led2<=1'b0;
					led3<=1'b0;
			end
			8'b0000_0100 : begin
					led0<=1'b0;
					led1<=1'b0;
					led2<=1'b1;
					led3<=1'b0;
			end
			8'b0000_1000 : begin
					led0<=1'b0;
					led1<=1'b0;
					led2<=1'b0;
					led3<=1'b1;
			end
		default:begin
					led0<=led0;
					led1<=led1;
					led2<=led2;
					led3<=led3;
		end
		endcase
	end


end




endmodule
