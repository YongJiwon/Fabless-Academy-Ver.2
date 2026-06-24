`timescale 1ns / 1ps

module tb_adder ();

    reg a, b, cin;  //입력은 reg로 선언
    wire s, c;  //output은 wire로 선언

    //instanciation 실체화
    //dut : design under test
    //uut : unit under test
    //cct : 
    full_adder dut (
        .a  (a),
        .b  (b),
        .cin(cin),
        .s  (s),
        .c  (c)
    );

    initial begin
        //init, time control

        a = 0;
        b = 0; 
        cin = 0;
        #10;
        a = 0;
        b = 1; 
        cin = 0;
        #10;
        a = 1;
        b = 0; 
        cin = 0;
        #10;
        a = 1;
        b = 1; 
        cin = 0;
        #10;

        a = 0;
        b = 0; 
        cin = 1;
        #10;
        a = 0;
        b = 1; 
        cin = 1;
        #10;
        a = 1;
        b = 0; 
        cin = 1;
        #10;
        a = 1;
        b = 1; 
        cin = 1;
        #10;
        $stop;

    end

endmodule
