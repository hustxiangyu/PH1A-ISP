module key_delay1 (
    input  wire clk,          // 时钟信号
    input  wire resetn,       // 复位信号（低有效）
    input  wire button_in,    // 原始按键输入信号
    output reg  button_stable // 消抖后的按键稳定信号
);

    // 参数定义
    parameter DEBOUNCE_TIME = 20_000; // 消抖时间，单位为时钟周期

    // 寄存器定义
    reg [19:0] counter;       // 计数器，用于计时
    reg button_sync0, button_sync1; // 同步信号
    reg button_state;         // 当前稳定的按键状态

    // 按键输入同步到时钟域
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            button_sync0 <= 1'b0;
            button_sync1 <= 1'b0;
        end else begin
            button_sync0 <= button_in;
            button_sync1 <= button_sync0;
        end
    end

    // 消抖逻辑
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            counter <= 20'd0;
            button_state <= 1'b0;
        end else if (button_sync1 != button_state) begin
            // 按键状态发生变化，开始计时
            counter <= counter + 1;
            if (counter >= DEBOUNCE_TIME) begin
                button_state <= button_sync1; // 按键状态稳定后更新
                counter <= 20'd0;            // 重置计数器
            end
        end else begin
            counter <= 20'd0; // 无变化时重置计数器
        end
    end

    // 输出稳定的按键状态
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            button_stable <= 1'b0;
        end else begin
            button_stable <= button_state;
        end
    end

endmodule
