module div_ctrl#(
    parameter  integer                   AXI_DATA_WIDTH = 128,//AXI总线数据位宽
	parameter  integer                   AXI_ADDR_WIDTH = 32 //AXI总线地址位宽
)(
    input wire clk,
    input wire rst_n,
    
output reg     [AXI_ADDR_WIDTH-1'b1: 0]     O_fdma_waddr, //FDMA写通道地址
output reg                                  O_fdma_wareq, //FDMA写通道请求
output reg     [15  :0]                     O_fdma_wsize, //FDMA写通道一次FDMA的传输大小                                     
input  wire                                 I_fdma_wbusy, //FDMA处于BUSY状态，AXI总线正在写操作   
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_wdata, //FDMA写数据
input  wire                                 I_fdma_wvalid, //FDMA 写有效

output reg     [AXI_ADDR_WIDTH-1'b1: 0]     O_fdma_raddr, // FDMA读通道地址
output reg                                  O_fdma_rareq, // FDMA读通道请求
output reg     [15: 0]                      O_fdma_rsize, // FDMA读通道一次FDMA的传输大小                                     
input  wire                                 I_fdma_rbusy, // FDMA处于BUSY状态，AXI总线正在读操作     
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_rdata, // FDMA读数据
input  wire                                 I_fdma_rvalid, // FDMA 读有效
//----------fdma signals write-------       
input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_waddr1, //FDMA写通道地址
input  wire                                 I_fdma_wareq1, //FDMA写通道请求
input  wire    [15  :0]                     I_fdma_wsize1, //FDMA写通道一次FDMA的传输大小                                     
output wire                                 O_fdma_wbusy1, //FDMA处于BUSY状态，AXI总线正在写操作   
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_wdata1, //FDMA写数据
output wire                                 O_fdma_wvalid1, //FDMA 写有效
//output wire                                 O_fdma_wready1, //FDMA写准备好，用户可以写数据
//output reg     [7   :0]                     O_fmda_wbuf1 =0, //FDMA的写帧缓存号输出
//output wire                                 O_fdma_wirq1, //FDMA一次写完成的数据传输完成后，产生中断。 

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_raddr1, // FDMA读通道地址
input  wire                                 I_fdma_rareq1, // FDMA读通道请求
input  wire    [15: 0]                      I_fdma_rsize1, // FDMA读通道一次FDMA的传输大小                                     
output wire                                 O_fdma_rbusy1, // FDMA处于BUSY状态，AXI总线正在读操作     
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_rdata1, // FDMA读数据
output wire                                 O_fdma_rvalid1, // FDMA 读有效
//output wire                                 O_fdma_rready1, // FDMA读准备好，用户可以读数据
//output reg     [7  :0]                      O_fmda_rbuf1 =0, // FDMA的读帧缓存号输出
//output wire                                 O_fdma_rirq1, // FDMA一次读完成的数据传输完成后，产生中断

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_waddr2, //FDMA写通道地址
input  wire                                 I_fdma_wareq2, //FDMA写通道请求
input  wire    [15  :0]                     I_fdma_wsize2, //FDMA写通道一次FDMA的传输大小                                     
output wire                                 O_fdma_wbusy2, //FDMA处于BUSY状态，AXI总线正在写操作   
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_wdata2, //FDMA写数据
output wire                                 O_fdma_wvalid2, //FDMA 写有效
//output wire                                 O_fdma_wready2, //FDMA写准备好，用户可以写数据
//output reg     [7   :0]                     O_fmda_wbuf2 =0, //FDMA的写帧缓存号输出
//output wire                                 O_fdma_wirq2, //FDMA一次写完成的数据传输完成后，产生中断。 

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_raddr2, // FDMA读通道地址
input  wire                                 I_fdma_rareq2, // FDMA读通道请求
input  wire    [15: 0]                      I_fdma_rsize2, // FDMA读通道一次FDMA的传输大小                                     
output wire                                 O_fdma_rbusy2, // FDMA处于BUSY状态，AXI总线正在读操作     
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_rdata2, // FDMA读数据
output wire                                 O_fdma_rvalid2, // FDMA 读有效
//output wire                                 O_fdma_rready2, // FDMA读准备好，用户可以读数据
//output reg     [7  :0]                      O_fmda_rbuf2 =0, // FDMA的读帧缓存号输出
//output wire                                 O_fdma_rirq2 // FDMA一次读完成的数据传输完成后，产生中断

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_waddr3, //FDMA写通道地址
input  wire                                 I_fdma_wareq3, //FDMA写通道请求
input  wire    [15  :0]                     I_fdma_wsize3, //FDMA写通道一次FDMA的传输大小                                     
output wire                                 O_fdma_wbusy3, //FDMA处于BUSY状态，AXI总线正在写操作   
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_wdata3, //FDMA写数据
output wire                                 O_fdma_wvalid3, //FDMA 写有效
//output wire                                 O_fdma_wready2, //FDMA写准备好，用户可以写数据
//output reg     [7   :0]                     O_fmda_wbuf2 =0, //FDMA的写帧缓存号输出
//output wire                                 O_fdma_wirq2, //FDMA一次写完成的数据传输完成后，产生中断。 

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_raddr3, // FDMA读通道地址
input  wire                                 I_fdma_rareq3, // FDMA读通道请求
input  wire    [15: 0]                      I_fdma_rsize3, // FDMA读通道一次FDMA的传输大小                                     
output wire                                 O_fdma_rbusy3, // FDMA处于BUSY状态，AXI总线正在读操作     
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_rdata3, // FDMA读数据
output wire                                 O_fdma_rvalid3, // FDMA 读有效


input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_waddr4, //FDMA写通道地址
input  wire                                 I_fdma_wareq4, //FDMA写通道请求
input  wire    [15  :0]                     I_fdma_wsize4, //FDMA写通道一次FDMA的传输大小                                     
output wire                                 O_fdma_wbusy4, //FDMA处于BUSY状态，AXI总线正在写操作   
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_wdata4, //FDMA写数据
output wire                                 O_fdma_wvalid4, //FDMA 写有效
//output wire                                 O_fdma_wready2, //FDMA写准备好，用户可以写数据
//output reg     [7   :0]                     O_fmda_wbuf2 =0, //FDMA的写帧缓存号输出
//output wire                                 O_fdma_wirq2, //FDMA一次写完成的数据传输完成后，产生中断。 

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_raddr4, // FDMA读通道地址
input  wire                                 I_fdma_rareq4, // FDMA读通道请求
input  wire    [15: 0]                      I_fdma_rsize4, // FDMA读通道一次FDMA的传输大小                                     
output wire                                 O_fdma_rbusy4, // FDMA处于BUSY状态，AXI总线正在读操作     
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_rdata4, // FDMA读数据
output wire                                 O_fdma_rvalid4, // FDMA 读有效

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_waddr5, //FDMA写通道地址
input  wire                                 I_fdma_wareq5, //FDMA写通道请求
input  wire    [15  :0]                     I_fdma_wsize5, //FDMA写通道一次FDMA的传输大小                                     
output wire                                 O_fdma_wbusy5, //FDMA处于BUSY状态，AXI总线正在写操作   
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_wdata5, //FDMA写数据
output wire                                 O_fdma_wvalid5, //FDMA 写有效
//output wire                                 O_fdma_wready2, //FDMA写准备好，用户可以写数据
//output reg     [7   :0]                     O_fmda_wbuf2 =0, //FDMA的写帧缓存号输出
//output wire                                 O_fdma_wirq2, //FDMA一次写完成的数据传输完成后，产生中断。 

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_raddr5, // FDMA读通道地址
input  wire                                 I_fdma_rareq5, // FDMA读通道请求
input  wire    [15: 0]                      I_fdma_rsize5, // FDMA读通道一次FDMA的传输大小                                     
output wire                                 O_fdma_rbusy5, // FDMA处于BUSY状态，AXI总线正在读操作     
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_rdata5, // FDMA读数据
output wire                                 O_fdma_rvalid5, // FDMA 读有效

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_waddr6, //FDMA写通道地址
input  wire                                 I_fdma_wareq6, //FDMA写通道请求
input  wire    [15  :0]                     I_fdma_wsize6, //FDMA写通道一次FDMA的传输大小                                     
output wire                                 O_fdma_wbusy6, //FDMA处于BUSY状态，AXI总线正在写操作   
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_wdata6, //FDMA写数据
output wire                                 O_fdma_wvalid6, //FDMA 写有效
//output wire                                 O_fdma_wready2, //FDMA写准备好，用户可以写数据
//output reg     [7   :0]                     O_fmda_wbuf2 =0, //FDMA的写帧缓存号输出
//output wire                                 O_fdma_wirq2, //FDMA一次写完成的数据传输完成后，产生中断。 

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_raddr6, // FDMA读通道地址
input  wire                                 I_fdma_rareq6, // FDMA读通道请求
input  wire    [15: 0]                      I_fdma_rsize6, // FDMA读通道一次FDMA的传输大小                                     
output wire                                 O_fdma_rbusy6, // FDMA处于BUSY状态，AXI总线正在读操作     
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_rdata6, // FDMA读数据
output wire                                 O_fdma_rvalid6, // FDMA 读有效

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_waddr7, //FDMA写通道地址
input  wire                                 I_fdma_wareq7, //FDMA写通道请求
input  wire    [15  :0]                     I_fdma_wsize7, //FDMA写通道一次FDMA的传输大小                                     
output wire                                 O_fdma_wbusy7, //FDMA处于BUSY状态，AXI总线正在写操作   
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_wdata7, //FDMA写数据
output wire                                 O_fdma_wvalid7, //FDMA 写有效
//output wire                                 O_fdma_wready2, //FDMA写准备好，用户可以写数据
//output reg     [7   :0]                     O_fmda_wbuf2 =0, //FDMA的写帧缓存号输出
//output wire                                 O_fdma_wirq2, //FDMA一次写完成的数据传输完成后，产生中断。 

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_raddr7, // FDMA读通道地址
input  wire                                 I_fdma_rareq7, // FDMA读通道请求
input  wire    [15: 0]                      I_fdma_rsize7, // FDMA读通道一次FDMA的传输大小                                     
output wire                                 O_fdma_rbusy7, // FDMA处于BUSY状态，AXI总线正在读操作     
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_rdata7, // FDMA读数据
output wire                                 O_fdma_rvalid7, // FDMA 读有效

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_waddr8, //FDMA写通道地址
input  wire                                 I_fdma_wareq8, //FDMA写通道请求
input  wire    [15  :0]                     I_fdma_wsize8, //FDMA写通道一次FDMA的传输大小                                     
output wire                                 O_fdma_wbusy8, //FDMA处于BUSY状态，AXI总线正在写操作   
input  wire    [AXI_DATA_WIDTH-1'b1:0]      I_fdma_wdata8, //FDMA写数据
output wire                                 O_fdma_wvalid8, //FDMA 写有效
//output wire                                 O_fdma_wready2, //FDMA写准备好，用户可以写数据
//output reg     [7   :0]                     O_fmda_wbuf2 =0, //FDMA的写帧缓存号输出
//output wire                                 O_fdma_wirq2, //FDMA一次写完成的数据传输完成后，产生中断。 

input  wire    [AXI_ADDR_WIDTH-1'b1: 0]     I_fdma_raddr8, // FDMA读通道地址
input  wire                                 I_fdma_rareq8, // FDMA读通道请求
input  wire    [15: 0]                      I_fdma_rsize8, // FDMA读通道一次FDMA的传输大小                                     
output wire                                 O_fdma_rbusy8, // FDMA处于BUSY状态，AXI总线正在读操作     
output wire    [AXI_DATA_WIDTH-1'b1:0]      O_fdma_rdata8, // FDMA读数据
output wire                                 O_fdma_rvalid8 // FDMA 读有效
 );
 //w
 assign O_fdma_wvalid1 = W == 1 ? I_fdma_wvalid : 1'd0;
 assign O_fdma_wbusy1  = W == 1 ? I_fdma_wbusy : 1'd0;
 
 assign O_fdma_wdata   = W == 1 ? I_fdma_wdata1 : W == 2 ? I_fdma_wdata2 : W == 3 ? I_fdma_wdata3 : W == 4 ? I_fdma_wdata4 : W == 5 ? I_fdma_wdata5 : W == 6 ? I_fdma_wdata6 : W == 7 ? I_fdma_wdata7 : W == 8 ? I_fdma_wdata8 : 8'b11111111;
 
 assign O_fdma_wvalid2 = W == 2 ? I_fdma_wvalid : 1'd0;
 assign O_fdma_wbusy2  = W == 2 ? I_fdma_wbusy : 1'd0;
 
 assign O_fdma_wvalid3 = W == 3 ? I_fdma_wvalid : 1'd0;
 assign O_fdma_wbusy3  = W == 3 ? I_fdma_wbusy : 1'd0;
 
 assign O_fdma_wvalid4 = W == 4 ? I_fdma_wvalid : 1'd0;
 assign O_fdma_wbusy4  = W == 4 ? I_fdma_wbusy : 1'd0;
 
 assign O_fdma_wvalid5 = W == 5 ? I_fdma_wvalid : 1'd0;
 assign O_fdma_wbusy5  = W == 5 ? I_fdma_wbusy : 1'd0;
 
 assign O_fdma_wvalid6 = W == 6 ? I_fdma_wvalid : 1'd0;
 assign O_fdma_wbusy6  = W == 6 ? I_fdma_wbusy : 1'd0;
 
 assign O_fdma_wvalid7 = W == 7 ? I_fdma_wvalid : 1'd0;
 assign O_fdma_wbusy7  = W == 7 ? I_fdma_wbusy : 1'd0;
 
 assign O_fdma_wvalid8 = W == 8 ? I_fdma_wvalid : 1'd0;
 assign O_fdma_wbusy8  = W == 8 ? I_fdma_wbusy : 1'd0;
 //r
 assign O_fdma_rvalid1 = R == 1 ? I_fdma_rvalid : 1'd0;
 assign O_fdma_rbusy1  = R == 1 ? I_fdma_rbusy : 1'd0;                        
 assign O_fdma_rdata1  = R == 1 ? I_fdma_rdata : 1'd0;
 
 assign O_fdma_rdata2  = R == 2 ? I_fdma_rdata : 1'd0;                        
 assign O_fdma_rvalid2 = R == 2 ? I_fdma_rvalid : 1'd0;
 assign O_fdma_rbusy2  = R == 2 ? I_fdma_rbusy : 1'd0;
 
 assign O_fdma_rvalid3 = R == 3 ? I_fdma_rvalid : 1'd0;
 assign O_fdma_rbusy3  = R == 3 ? I_fdma_rbusy : 1'd0;                        
 assign O_fdma_rdata3  = R == 3 ? I_fdma_rdata : 1'd0;
 
 assign O_fdma_rvalid4 = R == 4 ? I_fdma_rvalid : 1'd0;
 assign O_fdma_rbusy4  = R == 4 ? I_fdma_rbusy : 1'd0;                        
 assign O_fdma_rdata4  = R == 4 ? I_fdma_rdata : 1'd0;
 
 assign O_fdma_rvalid5 = R == 5 ? I_fdma_rvalid : 1'd0;
 assign O_fdma_rbusy5  = R == 5 ? I_fdma_rbusy : 1'd0;                        
 assign O_fdma_rdata5  = R == 5 ? I_fdma_rdata : 1'd0;
 
 assign O_fdma_rvalid6 = R == 6 ? I_fdma_rvalid : 1'd0;
 assign O_fdma_rbusy6  = R == 6 ? I_fdma_rbusy : 1'd0;                        
 assign O_fdma_rdata6  = R == 6 ? I_fdma_rdata : 1'd0;
 
 assign O_fdma_rvalid7 = R == 7 ? I_fdma_rvalid : 1'd0;
 assign O_fdma_rbusy7  = R == 7 ? I_fdma_rbusy : 1'd0;                        
 assign O_fdma_rdata7  = R == 7 ? I_fdma_rdata : 1'd0;
 
 assign O_fdma_rvalid8 = R == 8 ? I_fdma_rvalid : 1'd0;
 assign O_fdma_rbusy8  = R == 8 ? I_fdma_rbusy : 1'd0;                        
 assign O_fdma_rdata8  = R == 8 ? I_fdma_rdata : 1'd0;
 
 reg [4:0]W_S;
 reg [4:0]W;
 reg [4:0]R_S;
 reg [4:0]R;

always @(posedge clk) begin
    if(!rst_n)begin
        W_S            <= 4'd0;
        W <= 4'd0;
        O_fdma_wareq  <= 1'd0;
    end
    else begin
        case(W_S)
        0:begin
         if(I_fdma_wbusy == 1'b0 && I_fdma_wareq1)begin //优先执行写
            O_fdma_wareq  <= 1'b1;
            O_fdma_waddr  <= I_fdma_waddr1;
            O_fdma_wsize  <= I_fdma_wsize1;
            W <= 4'd1;
            W_S            <= 4'd1;
         end  
         else if(I_fdma_wbusy == 1'b0 && I_fdma_wareq2)begin//如果写完成后再执行读
            O_fdma_wareq  <= 1'b1;  
            O_fdma_waddr  <= I_fdma_waddr2;
            O_fdma_wsize  <= I_fdma_wsize2;
            W_S            <= 4'd2;
            W <= 4'd2;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_wareq3)begin//如果写完成后再执行读
            O_fdma_wareq  <= 1'b1;  
            O_fdma_waddr  <= I_fdma_waddr3;
            O_fdma_wsize  <= I_fdma_wsize3;
            W_S            <= 4'd3;
            W <= 4'd3;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_wareq4)begin//如果写完成后再执行读
            O_fdma_wareq  <= 1'b1;  
            O_fdma_waddr  <= I_fdma_waddr4;
            O_fdma_wsize  <= I_fdma_wsize4;
            W_S            <= 4'd4;
            W <= 4'd4;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_wareq5)begin//如果写完成后再执行读
            O_fdma_wareq  <= 1'b1;  
            O_fdma_waddr  <= I_fdma_waddr5;
            O_fdma_wsize  <= I_fdma_wsize5;
            W_S            <= 4'd5;
            W <= 4'd5;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_wareq6)begin//如果写完成后再执行读
            O_fdma_wareq  <= 1'b1;  
            O_fdma_waddr  <= I_fdma_waddr6;
            O_fdma_wsize  <= I_fdma_wsize6;
            W_S            <= 4'd6;
            W <= 4'd6;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_wareq7)begin//如果写完成后再执行读
            O_fdma_wareq  <= 1'b1;  
            O_fdma_waddr  <= I_fdma_waddr7;
            O_fdma_wsize  <= I_fdma_wsize7;
            W_S            <= 4'd13;
            W <= 4'd7;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_wareq8)begin//如果写完成后再执行读
            O_fdma_wareq  <= 1'b1;  
            O_fdma_waddr  <= I_fdma_waddr8;
            O_fdma_wsize  <= I_fdma_wsize8;
            W_S            <= 5'd15;
            W <= 5'd8;
         end
        end
        1:begin
            if(O_fdma_wbusy1 == 1'b1) begin //等待写完成
                O_fdma_wareq  <= 1'b0;
                W_S            <= 7;
            end
        end          
        2:begin
            if(O_fdma_wbusy2 == 1'b1) begin //等待读完成
                O_fdma_wareq  <= 1'b0;
                W_S    <= 8;
            end            
        end
        3:begin
            if(O_fdma_wbusy3 == 1'b1) begin //等待读完成
                O_fdma_wareq  <= 1'b0;
                W_S    <= 9;
            end            
        end
        4:begin
            if(O_fdma_wbusy4 == 1'b1) begin //等待读完成
                O_fdma_wareq  <= 1'b0;
                W_S    <= 10;
            end            
        end
        5:begin
            if(O_fdma_wbusy5 == 1'b1) begin //等待读完成
                O_fdma_wareq  <= 1'b0;
                W_S    <= 11;
            end            
        end
        6:begin
            if(O_fdma_wbusy6 == 1'b1) begin //等待读完成
                O_fdma_wareq  <= 1'b0;
                W_S    <= 12;
            end            
        end
        7:begin
            if(O_fdma_wbusy1==0) begin
                W_S    <= 0;
                W <= 4'd0;
            end
        end
        8:begin
            if(O_fdma_wbusy2==0) begin
                W_S    <= 0;
                W <= 4'd0;
            end
        end
        9:begin
            if(O_fdma_wbusy3==0) begin
                W_S    <= 0;
                W <= 4'd0;
            end
        end
        10:begin
            if(O_fdma_wbusy4==0) begin
                W_S    <= 0;
                W <= 4'd0;
            end
        end
        11:begin
            if(O_fdma_wbusy5==0) begin
                W_S    <= 0;
                W <= 4'd0;
            end
        end
        12:begin
            if(O_fdma_wbusy6==0) begin
                W_S    <= 0;
                W <= 4'd0;
            end
        end
        13:begin
            if(O_fdma_wbusy7 == 1'b1) begin //等待写完成
                O_fdma_wareq  <= 1'b0;
                W_S            <= 14;
            end
        end 
        14:begin
            if(O_fdma_wbusy7==0) begin
                W_S    <= 0;
                W <= 4'd0;
            end
        end 
        15:begin
            if(O_fdma_wbusy8 == 1'b1) begin //等待写完成
                O_fdma_wareq  <= 1'b0;
                W_S            <= 16;
            end
        end 
        16:begin
            if(O_fdma_wbusy8==0) begin
                W_S    <= 0;
                W <= 4'd0;
            end
        end 
        default: W_S <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if(!rst_n)begin
        R_S            <= 4'd0;
        R <= 4'd0;
        O_fdma_rareq  <= 1'd0;
    end
    else begin
        case(R_S)
        0:begin
         if(I_fdma_wbusy == 1'b0 && I_fdma_rareq1)begin //优先执行写
            O_fdma_rareq  <= 1'b1;
            O_fdma_raddr  <= I_fdma_raddr1;
            O_fdma_rsize  <= I_fdma_rsize1;
            R <= 4'd1;
            R_S            <= 4'd1;
         end  
         else if(I_fdma_wbusy == 1'b0 && I_fdma_rareq2)begin//如果写完成后再执行读
            O_fdma_rareq  <= 1'b1;  
            O_fdma_raddr  <= I_fdma_raddr2;
            O_fdma_rsize  <= I_fdma_rsize2;
            R_S            <= 4'd2;
            R <= 4'd2;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_rareq3)begin//如果写完成后再执行读
            O_fdma_rareq  <= 1'b1;  
            O_fdma_raddr  <= I_fdma_raddr3;
            O_fdma_rsize  <= I_fdma_rsize3;
            R_S            <= 4'd3;
            R <= 4'd3;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_rareq4)begin//如果写完成后再执行读
            O_fdma_rareq  <= 1'b1;  
            O_fdma_raddr  <= I_fdma_raddr4;
            O_fdma_rsize  <= I_fdma_rsize4;
            R_S            <= 4'd4;
            R <= 4'd4;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_rareq5)begin//如果写完成后再执行读
            O_fdma_rareq  <= 1'b1;  
            O_fdma_raddr  <= I_fdma_raddr5;
            O_fdma_rsize  <= I_fdma_rsize5;
            R_S            <= 4'd5;
            R <= 4'd5;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_rareq6)begin//如果写完成后再执行读
            O_fdma_rareq  <= 1'b1;  
            O_fdma_raddr  <= I_fdma_raddr6;
            O_fdma_rsize  <= I_fdma_rsize6;
            R_S            <= 4'd6;
            R <= 4'd6;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_rareq7)begin//如果写完成后再执行读
            O_fdma_rareq  <= 1'b1;  
            O_fdma_raddr  <= I_fdma_raddr7;
            O_fdma_rsize  <= I_fdma_rsize7;
            R_S            <= 4'd13;
            R <= 4'd7;
         end
         else if(I_fdma_wbusy == 1'b0 && I_fdma_rareq8)begin//如果写完成后再执行读
            O_fdma_rareq  <= 1'b1;  
            O_fdma_raddr  <= I_fdma_raddr8;
            O_fdma_rsize  <= I_fdma_rsize8;
            R_S            <= 4'd15;
            R <= 4'd8;
         end
        end
        1:begin
            if(O_fdma_rbusy1 == 1'b1) begin //等待写完成
                O_fdma_rareq  <= 1'b0;
                R_S            <= 7;
            end
        end          
        2:begin
            if(O_fdma_rbusy2 == 1'b1) begin //等待读完成
                O_fdma_rareq  <= 1'b0;
                R_S    <= 8;
            end            
        end
        3:begin
            if(O_fdma_rbusy3 == 1'b1) begin //等待读完成
                O_fdma_rareq  <= 1'b0;
                R_S    <= 9;
            end            
        end
        4:begin
            if(O_fdma_rbusy4 == 1'b1) begin //等待读完成
                O_fdma_rareq  <= 1'b0;
                R_S    <= 10;
            end            
        end
        5:begin
            if(O_fdma_rbusy5 == 1'b1) begin //等待读完成
                O_fdma_rareq  <= 1'b0;
                R_S    <= 11;
            end            
        end
        6:begin
            if(O_fdma_rbusy6 == 1'b1) begin //等待读完成
                O_fdma_rareq  <= 1'b0;
                R_S    <= 12;
            end            
        end
        7:begin
            if(O_fdma_rbusy1==0) begin
                R_S    <= 0;
                R <= 4'd0;
            end
        end
        8:begin
            if(O_fdma_rbusy2==0) begin
                R_S    <= 0;
                R <= 4'd0;
            end
        end
        9:begin
            if(O_fdma_rbusy3==0) begin
                R_S    <= 0;
                R <= 4'd0;
            end
        end
        10:begin
            if(O_fdma_rbusy4==0) begin
                R_S    <= 0;
                R <= 4'd0;
            end
        end
        11:begin
            if(O_fdma_rbusy5==0) begin
                R_S    <= 0;
                R <= 4'd0;
            end
        end
        12:begin
            if(O_fdma_rbusy6==0) begin
                R_S    <= 0;
                R <= 4'd0;
            end
        end
        13:begin
            if(O_fdma_rbusy7 == 1'b1) begin //等待写完成
                O_fdma_rareq  <= 1'b0;
                R_S            <= 14;
            end
        end 
        14:begin
            if(O_fdma_rbusy7==0) begin
                R_S    <= 0;
                R <= 4'd0;
            end
        end
        15:begin
            if(O_fdma_rbusy8 == 1'b1) begin //等待写完成
                O_fdma_rareq  <= 1'b0;
                R_S            <= 16;
            end
        end 
        16:begin
            if(O_fdma_rbusy8==0) begin
                R_S    <= 0;
                R <= 4'd0;
            end
        end
        default: R_S <= 0;
        endcase
    end
end


endmodule
