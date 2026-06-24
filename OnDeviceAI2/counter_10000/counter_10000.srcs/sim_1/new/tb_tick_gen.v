`timescale 1ns / 1ps


module tb_tick_gen();

    reg clk, rst;
    wire o_tick;

    clk_tick_gen dut(
        .clk(clk),
        .rst(rst),
        .o_tick(o_tick)  //신호이므로 1bit
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        #20;
        rst = 0;

        //시간 많이 끌어주기(200ms delay)
        #200_000_000; //2개 보기
        $stop;
    end
endmodule