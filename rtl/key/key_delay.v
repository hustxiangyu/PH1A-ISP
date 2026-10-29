module key_delay
(
    input wire clk,        // 50MHz时钟输入
    input wire rst_n,      // 复位信号，低电平有效
    input wire button_in,  // 按键输入信号
    output reg button_out  // 消抖后的按键输出信号
);

    // 参数定义
    parameter N = 20;      // 消抖计数器位宽，假设消抖延时为20ms

    reg [N-1:0] cnt;       // 计数器
    reg button_sync_0;     // 按键同步寄存器第一级
    reg button_sync_1;     // 按键同步寄存器第二级
    reg button_stable;     // 稳定的按键状态

    // 同步按键输入到时钟域
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            button_sync_0 <= 0;
            button_sync_1 <= 0;
        end
        else begin
            button_sync_0 <= button_in;
            button_sync_1 <= button_sync_0;
        end
    end

    // 按键消抖逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            button_stable <= 0;
            button_out <= 0;
        end
        else begin
            // 判断按键状态是否变化
            if (button_sync_1 == button_stable) begin
                cnt <= 0;
            end
            else begin
                cnt <= cnt + 1;
                // 当计数器达到指定值时，确认按键状态稳定
                if (cnt == (50_000 * 10 - 1)) begin  // 50MHz * 20ms
                    button_stable <= button_sync_1;
                    button_out <= button_sync_1;
                end
            end
        end
    end

endmodule

