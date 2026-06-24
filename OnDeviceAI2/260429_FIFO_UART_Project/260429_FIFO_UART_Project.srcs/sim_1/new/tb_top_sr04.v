`timescale 1ns / 1ps

module tb_top_sr04();

    reg clk, rst, btn_R, echo;
    wire trig;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;
    wire [1:0] led;

    assign led[0] = trig;
    // 모듈 이름 대소문자 확인: TOP_sr04_controller
    TOP_sr04_controller uut (
        .clk(clk), .rst(rst), .btn_R(btn_R), .echo(echo),
        .trig(trig), .fnd_com(fnd_com), .fnd_data(fnd_data)
    );

    always #5 clk = ~clk;

    task simulate_echo;
        input [15:0] distance_cm;
        integer echo_duration_us;
        begin
            echo_duration_us = distance_cm * 58;
            wait(trig == 1); 
            wait(trig == 0); 
            #2000; 
            echo = 1;
            repeat(echo_duration_us) #1000; 
            echo = 0;
        end
    endtask

    initial begin
        clk = 0; rst = 1; btn_R = 0; echo = 0;
        #100 rst = 0;
        #1000;

        // --- Test 1: 디바운스 통과를 위해 충분히 길게 누름 (20ms) ---
        $display("Starting Test: 10cm");
        btn_R = 1; 
        #20000000; // 20ms 대기 (디바운스 시간 고려)
        btn_R = 0; 
        
        simulate_echo(10); 
        
        #10000000; // 결과 확인 대기
        $stop;
    end
endmodule