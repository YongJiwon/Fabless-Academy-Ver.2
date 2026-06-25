`timescale 1ns / 1ps


module tb_uart_i2c_system;
    localparam int CLK_FREQ_HZ = 100_000_000;
    localparam int UART_BAUD   = 1_000_000; // faster than board UART for simulation
    localparam int UART_BIT_NS = 1_000_000_000 / UART_BAUD;
    localparam logic [6:0] SLAVE_ADDR = 7'h42;
    localparam logic [7:0] TEST_DATA  = 8'hA5;

    logic clk;
    logic master_reset;
    logic slave_reset_n;
    logic uart_rxd;
    wire  scl;
    wire  sda;
    logic uart_txd;

    pullup(sda);
    pullup(scl);

    master_top #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .UART_BAUD(UART_BAUD),
        .UART_OVERSAMPLE(16),
        .SLAVE_ADDR(SLAVE_ADDR)
    ) U_MASTER_TOP (
        .clk(clk),
        .reset(master_reset),
        .uart_rxd(uart_rxd),
        .scl(scl),
        .sda(sda)
    );

    slave_top #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .UART_BAUD(UART_BAUD),
        .UART_OVERSAMPLE(16),
        .SLAVE_ADDR(SLAVE_ADDR)
    ) U_SLAVE_TOP (
        .clk(clk),
        .reset_n(slave_reset_n),
        .scl(scl),
        .sda(sda),
        .uart_txd(uart_txd)
    );

    always #5 clk = ~clk; // 100MHz

    task automatic uart_send_byte(input logic [7:0] data);
        int i;
        begin
            uart_rxd = 1'b1;
            #(UART_BIT_NS);
            uart_rxd = 1'b0; // start bit
            #(UART_BIT_NS);
            for (i = 0; i < 8; i++) begin
                uart_rxd = data[i]; // UART sends LSB first
                #(UART_BIT_NS);
            end
            uart_rxd = 1'b1; // stop bit
            #(UART_BIT_NS);
        end
    endtask

    task automatic uart_recv_byte(output logic [7:0] data);
        int i;
        begin
            data = 8'h00;
            @(negedge uart_txd);          // start bit edge
            #(UART_BIT_NS + UART_BIT_NS/2); // sample in middle of bit 0
            for (i = 0; i < 8; i++) begin
                data[i] = uart_txd;       // UART receives LSB first
                #(UART_BIT_NS);
            end
            if (uart_txd !== 1'b1) begin
                $display("[FAIL] UART stop bit was not high at %0t", $time);
                $fatal;
            end
        end
    endtask

    initial begin
        logic [7:0] received_data;

        $dumpfile("tb_uart_i2c_system.vcd");
        $dumpvars(0, tb_uart_i2c_system);

        clk           = 1'b0;
        master_reset  = 1'b1;
        slave_reset_n = 1'b0;
        uart_rxd      = 1'b1;

        repeat (20) @(posedge clk);
        master_reset  = 1'b0;
        slave_reset_n = 1'b1;
        repeat (20) @(posedge clk);

        $display("[TB] Send UART byte 0x%02h to master at %0t", TEST_DATA, $time);
        uart_send_byte(TEST_DATA);

        fork
            begin
                uart_recv_byte(received_data);
            end
            begin
                #(20_000_000); // 20ms timeout at 1ns timescale
                $display("[FAIL] Timeout waiting for slave UART TX at %0t", $time);
                $fatal;
            end
        join_any
        disable fork;

        if (received_data == TEST_DATA) begin
            $display("[PASS] Slave UART TX returned 0x%02h", received_data);
        end else begin
            $display("[FAIL] Expected 0x%02h, got 0x%02h", TEST_DATA, received_data);
            $fatal;
        end

        #1000;
        $finish;
    end
endmodule
