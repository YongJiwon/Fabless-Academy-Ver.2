`timescale 1ns / 1ps

module slave_top #(
    parameter int CLK_FREQ_HZ = 100_000_000,
    parameter int UART_BAUD   = 9600,
    parameter int UART_OVERSAMPLE = 16,
    parameter logic [6:0] SLAVE_ADDR = 7'h42
)(
    input  logic clk,       // 50MHz system clock
    input  logic reset_n,   // Active Low reset
    input  logic scl,       // I2C SCL input from external master board
    inout  wire  sda,       // I2C SDA open-drain bidirectional pin
    output logic uart_txd   // UART TX pin to PC
);
    typedef enum logic [1:0] {
        IDLE  = 2'b00, // Wait for i2c_slave data_valid
        START = 2'b01, // Latch I2C byte and issue UART tx_start pulse
        WAIT  = 2'b10  // Wait until uart_tx becomes idle after transmission
    } state_t;

    localparam int BAUD_TICK_COUNT = (CLK_FREQ_HZ + ((UART_BAUD * UART_OVERSAMPLE) / 2)) /
                                     (UART_BAUD * UART_OVERSAMPLE);
    localparam int BAUD_CNT_WIDTH  = (BAUD_TICK_COUNT <= 1) ? 1 : $clog2(BAUD_TICK_COUNT);

    state_t state;

    logic [BAUD_CNT_WIDTH-1:0] baud_cnt;
    logic b_tick;

    logic [7:0] i2c_data_out;
    logic       i2c_data_valid;

    logic       tx_start;
    logic [7:0] tx_data;
    logic       tx_busy;
    logic       tx_busy_seen;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            baud_cnt <= '0;
            b_tick   <= 1'b0;
        end else begin
            if (baud_cnt == BAUD_TICK_COUNT - 1) begin
                baud_cnt <= '0;
                b_tick   <= 1'b1;
            end else begin
                baud_cnt <= baud_cnt + 1'b1;
                b_tick   <= 1'b0;
            end
        end
    end

    i2c_slave #(
        .SLAVE_ADDR(SLAVE_ADDR)
    ) U_I2C_SLAVE (
        .clk(clk),
        .reset_n(reset_n),
        .data_out(i2c_data_out),
        .data_valid(i2c_data_valid),
        .sda(sda),
        .scl(scl)
    );

    uart_tx U_UART_TX (
        .clk(clk),
        .rst(~reset_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .b_tick(b_tick),
        .tx_busy(tx_busy),
        .tx(uart_txd)
    );

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state        <= IDLE;
            tx_start     <= 1'b0;
            tx_data      <= 8'h00;
            tx_busy_seen <= 1'b0;
        end else begin
            tx_start <= 1'b0;

            case (state)
                IDLE: begin
                    tx_busy_seen <= 1'b0;
                    if (i2c_data_valid) begin
                        tx_data <= i2c_data_out;
                        state   <= START;
                    end
                end

                START: begin
                    tx_start <= 1'b1;
                    state    <= WAIT;
                end

                WAIT: begin
                    if (tx_busy) begin
                        tx_busy_seen <= 1'b1;
                    end
                    if (tx_busy_seen && !tx_busy) begin
                        tx_busy_seen <= 1'b0;
                        state        <= IDLE;
                    end
                end

                default: begin
                    state        <= IDLE;
                    tx_busy_seen <= 1'b0;
                end
            endcase
        end
    end
endmodule
