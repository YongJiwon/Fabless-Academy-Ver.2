`timescale 1ns / 1ps

module tb_uart();

    //(system clock * 1 clock time) / BAUD
    parameter UART_BAUD_PERIOD = (100_000_000*10/9600); //clock 개수니까 곱하기 10을 한다는 게 무슨 말이지?
    reg clk, rst, btnR;
    reg [7:0] tx_data;
    wire tx;

    uart dut(
        .clk(clk),
        .rst(rst),
        .btnR(btnR),
        .tx_data(tx_data),
        .tx(tx)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        btnR = 0;

        tx_data = 8'h30;   //ascii '0' 의미
        //rst
        @(negedge clk); //이건 왜 주는 거지? 이렇게 하면 시간 주는 것보다 쉽나?
        @(negedge clk);
        rst = 0;

        //1000사이클에 8사이클 이상? 그리고 곱하기 10? 그래서 여유 있게 80000? 
        //tx start trigger
        btnR = 1;
        #(100_000);
        btnR = 0;

        //얼마의 시간 뒤에 UART가 출력될까? 1bit에 9600
        //1bit
        repeat (10) #(UART_BAUD_PERIOD);
        
        btnR = 1;
        tx_data = 8'h31;
        #(100_000);
        btnR = 0;

        //1bit
        repeat(10) #(UART_BAUD_PERIOD);

        #1000;
        $stop; //simulator에 따라서 finish로 종료할 수도 있음

    end
endmodule

/*`timescale 1ns / 1ps

module tb_uart;

    reg clk;
    reg rst;
    reg btnR;
    reg [7:0] tx_data;
    wire tx;

    uart dut (
        .clk    (clk),
        .rst    (rst),
        .btnR   (btnR),
        .tx_data(tx_data),
        .tx     (tx)
    );

    // 100MHz clock -> 10ns period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // 버튼 입력: 디바운스 통과용으로 충분히 길게 유지
    task send_start;
    begin
        @(negedge clk);
        btnR = 1'b1;
        #20_000_000;   // 20ms 유지
        @(negedge clk);
        btnR = 1'b0;
    end
    endtask

    initial begin
        // 초기화
        rst     = 1'b1;
        btnR    = 1'b0;
        tx_data = 8'h30;   // ASCII '0'

        // reset 유지
        #1_000;
        rst = 1'b0;

        // 안정화 대기
        #1_000_000;        // 1ms

        // =========================
        // 첫 번째 전송
        // =========================
        send_start();

        // 전송 완료까지 충분히 대기
        // 9600bps에서 1프레임 약 1.04ms지만 넉넉하게 20ms 대기
        #20_000_000;

        // =========================
        // 두 번째 전송
        // =========================
        tx_data = 8'h41;   // ASCII 'A'
        #1_000_000;        // 1ms 대기
        send_start();

        // 두 번째 전송 완료까지 충분히 대기
        #20_000_000;

        $finish;
    end

endmodule*/

/*`timescale 1ns / 1ps

module tb_uart;

    reg clk;
    reg rst;
    reg btnR;
    reg [7:0] tx_data;
    wire tx;

    uart dut (
        .clk    (clk),
        .rst    (rst),
        .btnR   (btnR),
        .tx_data(tx_data),
        .tx     (tx)
    );

    // 100MHz clock -> 10ns period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // 버튼 입력: 디바운스 통과용으로 충분히 길게 유지
    task send_start;
    begin
        @(negedge clk);
        btnR = 1'b1;
        #20_000_000;   // 20ms 유지
        @(negedge clk);
        btnR = 1'b0;
    end
    endtask

    initial begin
        // 초기화
        rst     = 1'b1;
        btnR    = 1'b0;
        tx_data = 8'h30;   // ASCII '0'

        // reset 유지
        #1_000;
        rst = 1'b0;

        // 안정화 대기
        #1_000_000;        // 1ms

        // =========================
        // 첫 번째 전송
        // =========================
        send_start();

        // 전송 완료까지 충분히 대기
        // 9600bps에서 1프레임 약 1.04ms지만 넉넉하게 20ms 대기
        #20_000_000;

        // =========================
        // 두 번째 전송
        // =========================
        tx_data = 8'h41;   // ASCII 'A'
        #1_000_000;        // 1ms 대기
        send_start();

        // 두 번째 전송 완료까지 충분히 대기
        #20_000_000;

        $finish;
    end

endmodule*/