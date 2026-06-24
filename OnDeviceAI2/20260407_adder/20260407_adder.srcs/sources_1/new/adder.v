`timescale 1ns / 1ps
module full_adder (
    input  a,
    input  b,
    input  cin,
    output s,
    output c
);
    wire w_s1, w_c1, w_c2;  //reg가 아니라 wire인 이유? -> 단순히 U_HA0의 출력을 U_HA1의 입력으로 연결하는 것이기 때문

    assign c = w_c1 | w_c2;

    half_adder U_HA0 (  //그림 왼쪽 half_adder 먼저 설계
        .a(a),  //from full_adder input a      
        .b(b),  //from full_adder input b
        .s(w_s1),
        .c(w_c1)
    );

    half_adder U_HA1 (  //그림 오른쪽 half_adder
        .a(w_s1),  //from full_adder input a
        .b(cin),  //from full_adder input cin
        .s(s),  //to full adder output s
        .c(w_c2)
    );

endmodule

module half_adder (
    input  a,
    input  b,
    output s,
    output c
);

    assign s = a ^ b;
    assign c = a & b;

endmodule
