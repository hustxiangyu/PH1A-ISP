module sdio_top( 
    input 					 sysclk,
    input  wire        		 resetn,
    output wire         	 sdio_clk,
    inout                    cmd_io,
    inout  wire    [3:0]     data_io,
    output  wire   		     data_ready,
    input   wire [7:0] 		 wd_data,
    output  wire [7:0] 		 rd_data,/*synthesis keep*/
    output  reg w_done,
    output  reg r_done,
    output  reg  			 init_done_flag,
    output  reg [2:0] mode,/*synthesis keep*/
	input	wire			 button, // 按键输入
    input 	wire 			 button1
);


reg [7:0] w_data;/*synthesis keep*/
reg [7:0] read_index;           
reg compare_failed;             


// 状态机定义
localparam INIT       = 3'd0;
localparam WRITE      = 3'd3;
localparam READ       = 3'd4;
localparam IDLE       = 3'd5;

reg [2:0] mode;
wire data_ready;/*synthesis keep*/
reg button_reg1, button_reg2, button_reg3;
reg button1_reg1, button1_reg2, button1_reg3;
always@(posedge sysclk or negedge resetn) begin
	if (!resetn) begin
		button_reg1 <= 1'b0;
		button_reg2 <= 1'b0;
		button_reg3 <= 1'b0;
        button1_reg1 <= 1'b0;
		button1_reg2 <= 1'b0;
		button1_reg3 <= 1'b0;
	end else begin
		button_reg1 <= button;
		button_reg2 <= button_reg1;
		button_reg3 <= button_reg2;
        button1_reg1 <= button1;
		button1_reg2 <= button1_reg1;
		button1_reg3 <= button1_reg2;
	end
end
wire pos_button = ~button_reg2 & button_reg3; // 检测按键上升沿
wire pos_button1 = ~button1_reg2 & button1_reg3; // 检测按键上升沿
reg start;

// 状态机逻辑
always @(posedge sysclk or negedge resetn) begin
    if (!resetn) begin
        mode <= INIT;
        init_done_flag <= 1'b0;
        w_done <= 1'b0;
        r_done <= 1'b0;
        read_index <= 8'd0;
        compare_failed <= 1'b1;
        start <= 1'b0;
    end else begin
        case (mode)
            INIT: begin
            	if (!init_done_flag) begin
                	start <= 1'b1;
                end
                if (done) begin
                    init_done_flag <= 1'b1;
                    mode <= IDLE; 
                    start <= 1'b0;
                end		
            end
            IDLE: begin
            	if (pos_button) begin
                    mode <= WRITE; 
                    start <= 1'b1;
                    w_done <= 1'b0;
				end	
                if (pos_button1) begin
                    mode <= READ; 
                    start <= 1'b1;
                    r_done <= 1'b0;
				end
            end
            WRITE: begin
                if (done) begin
                    w_done <= 1'b1;
                    mode <= INIT;
                    init_done_flag <= 1'b0;
                    start <= 1'b0;
                end	
            end
            READ: begin	
                if (done) begin
                    r_done <= 1'b1; // 确保在 `done` 信号拉高时设置 `r_done`
                    mode <= INIT;
                    init_done_flag <= 1'b0;
                    start <= 1'b0;
                end
            end
            default: mode <= IDLE;
        endcase
    end
end

sdcard_sdio_driver sdcard_sdio_driver_inst
(
    .cmd_io			(cmd_io		),        
    .data_io		(data_io	),        
    .sdio_clk		(sdio_clk	),        
    .capacity		(			),        
    .sdhc_vaild		(			),        
    .data_ready		(data_ready	),        
    .sector_done	(			),        
    .sector_check	(			),        
    .rd_data		(rd_data	),        
    .idle			(			),        
    .done			(done		),        
    .sector_addr	(32'd20000	),        
    .sector_nums	(32'd4050	),        
    .wr_data		(wd_data		),        
    .mode			(mode		),        
    .start			(start),//(mode == INIT) || (mode == WRITE)||(mode == READ)), 
    .clk			(sysclk		),        
    .rst            (~resetn	)         
);
endmodule
