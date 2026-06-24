`timescale 1ns / 1ps

module tick_gen_us(
    input  wire clk,
    input  wire rst,
    input  wire clear,
    output reg  tick_100hz
);
    localparam COUNT_MAX = CLOCK_FREQ_HZ / COUNT_HZ;
    localparam COUNT_WIDTH = $clog2(COUNT_MAX);
    reg [COUNT_WIDTH-1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst || clear) begin
            count <= 0;
            tick_100hz <= 0;
        end else begin
            count <= count + 1;
            if (count == COUNT_MAX - 1) begin
                count <= 0;
                tick_100hz <= 1;
            end else begin
                tick_100hz <= 0;
            end
        end
    end

endmodule
