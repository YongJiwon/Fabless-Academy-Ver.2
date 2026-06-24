`timescale 1ns / 1ps

module fsm_led_tb;
    reg clk;
    reg rst;
    reg [2:0] sw;
    wire [2:0] led;

    // DUT instantiation
    fsm_led dut (
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .led(led)
    );

    // 100MHz clock (10ns period)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        // Waveform dump (for GTKWave)
        $dumpfile("fsm_led_tb.vcd");
        $dumpvars(0, fsm_led_tb);

        // Initial values
        rst = 1'b1;
        sw  = 3'b000;

        // Release reset
        #12;
        rst = 1'b0;
        #10;
        // LED_1(000) -> LED_2(100)
        @(negedge clk); sw = 3'b001;
        @(posedge clk);

        // LED_2(100) -> LED_3(010)
        @(negedge clk); sw = 3'b010;
        @(posedge clk);

        // LED_3(010) -> LED_4(001)
        @(negedge clk); sw = 3'b100;
        @(posedge clk);

        // LED_4(001) -> LED_5(111)
        @(negedge clk); sw = 3'b111;
        @(posedge clk);

        // LED_5(111) -> LED_1(000)
        @(negedge clk); sw = 3'b000;
        @(posedge clk);

        // LED_1(000) -> LED_3(010) direct branch
        @(negedge clk); sw = 3'b010;
        @(posedge clk);

        // Hold in LED_3 with non-matching input
        @(negedge clk); sw = 3'b001;
        @(posedge clk);

        // Move LED_3 -> LED_4 -> LED_2 path
        @(negedge clk); sw = 3'b100;
        @(posedge clk);

        @(negedge clk); sw = 3'b001;
        @(posedge clk);

        // Finish
        #20;
        $finish;
    end

    // Console monitor
    initial begin
        $display(" time\t rst sw  led");
        $monitor(" %0t\t  %b  %03b %03b", $time, rst, sw, led);
    end

endmodule