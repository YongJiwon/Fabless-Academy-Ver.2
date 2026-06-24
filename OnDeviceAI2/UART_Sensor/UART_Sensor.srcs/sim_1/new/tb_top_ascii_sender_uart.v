`timescale 1ns / 1ps

module tb_top_ascii_sender_uart;
    reg clk,
        rst,
        echo,
        btnR,
        btnL,
        btnU,
        btnD,
        tx_start;
    reg [3:0] sw;
    reg [7:0] tx_data;

    wire [7:0] rx_data;
    wire trig,rx_done, tx_busy;
    wire [3:0] fnd_com;
    wire       dht11; //inout
    wire [7:0] led,fnd_data;

    wire pc_to_board; // PC(U_UART)가 보내고 Board(dut)가 받는 선
    wire board_to_pc; // Board(dut)가 보내고 PC(U_UART)가 받는 선

uart U_UART(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .rx(board_to_pc),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .tx_busy(tx_busy),
    .tx(pc_to_board)
);

    // DUT
top_uart_time_sensor dut(
    .clk(clk),
    .rst(rst),
    .echo(echo),
    .btnR(btnR),
    .btnL(btnL),
    .btnU(btnU),
    .btnD(btnD),
    .sw(sw),
    .rx(pc_to_board),
    .tx(board_to_pc),
    .trig(trig),
    .fnd_data(fnd_data),
    .fnd_com(fnd_com),
    .led(led),
    .dht11(dht11)
);
    // 100MHz clock
always #5 clk = ~clk;
// 하나의 문자를 안정적으로 전송하는 task

task send_char;
    input [7:0] data;
    begin
        tx_data = data;
        #100;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;
        
        wait(tx_busy == 1);
        wait(tx_busy == 0);
        #1_000; // 20,000,000(20ms) -> 1,000(1us)로 과감하게 줄이세요.
    end
endtask


task press_button;
    input [7:0] btn_char; // "U", "D", "L", "R" 중 하나를 8비트로 받음
    input integer duration;
    begin
        case (btn_char)
            "U": btnU = 1;
            "D": btnD = 1;
            "L": btnL = 1;
            "R": btnR = 1;
        endcase

        #(duration);

        case (btn_char)
            "U": btnU = 0;
            "D": btnD = 0;
            "L": btnL = 0;
            "R": btnR = 0;
        endcase
        
        #100000;
    end
endtask


initial begin
    clk           = 1'b0;
    rst           = 1'b1;
    #10;
    rst = 1'b0;
    #10;
    tx_start      = 1'b0;
    tx_data       = 8'h00;
    sw            = 4'b0000;
    btnR          = 0;
    btnU          = 0;
    btnD          = 0;
    btnL          = 0;
    echo          = 0;
    #100000;
    // reset

//------------------------------------------------------------//
//Clock Mode

    sw = 4'b1000;
    #100_000;
    send_char("U");
    #100_000;
    //#1_100_000_000;
    send_char("R");
    //press_button("R", 10_000_000);
    #100_000;
    send_char("R");
    #100_000;
    //press_button("u", 10_000_000);
    send_char("U");
    #100_000;
    send_char("u");
    //press_button("u", 10_000_000);
    #100_000;
    send_char("U");
    //press_button("u", 10_000_000);
    #100_000;
    send_char("u");
    //press_button("u", 10_000_000);
    #100_000;
    sw = 4'b0000;
    send_char("R");
    //press_button("R", 10_000_000);
    #100_000;
    sw = 4'b0100;
    #100_000;
    send_char("R");
    #100_000;
    //#1_100_000_000;

    
//------------------------------------------------------------//



//Stopwatch Mode
/*
    sw = 4'b0001;
    send_char("S");
    send_char("T"); //warning [A: type change or B : only display] which? 1st

    #69420000;
    press_button("R", 10_000_000);
    send_char("s");
    press_button("R", 10_000_000); //down count?? 2nd

    sw = 4'b0101;
    send_char("U"); //no disturb and display
    send_char("t"); //restart down count
    press_button("D", 10_000_000); //monitor
    

    
   */
    





////////////////////////////////////////////////////////////////





//------------------------------------------------------------//
//Humnidity & Temperature Sensor Mode
/*
    sw = 4'b0010;
    press_button("M", 10_000_000);

    press_button("R", 10_000_000);
    
    press_button("T", 10_000_000);
    press_button("M", 10_000_000);
    



*/

////////////////////////////////////////////////////////////////





//------------------------------------------------------------//
//Ultra Sonic Sensor
    /*
      sw = 4'b0011;
        #10_000;
        
        send_char("M");
        
        // trig 펄스 포착 대기
        wait(trig == 1);
        wait(trig == 0);
        #10_000; // trig 하강 에지 이후의 안전 마진
        
        // echo 구동 시작 (7cm 모사)
        echo = 1;  
        #(58_000 * 7);   
        echo = 0;
        
        #1_000_000;

        // 결과값 출력 요청
        send_char("R");
        #100_000;

*/

////////////////////////////////////////////////////////////////


    $stop;
    $finish;
end
endmodule