`timescale 1ns / 1ps // 사용할 시간 단위/ (시뮬레이터)해석 단위

module gates( //top moulde
    input a, //미선언시 wire 자동 할당
    input b, //임피던스 : 연결 끊어진 상태
    output y0, // &
    output y1, // ~&
    output y2, // |
    output y3, // ~|
    output y4, // xor
    output y5, // xnor
    output y6 // ~
);


//assign : 항상 연결해라(Latch)
assign y0 = a & b; //드라이브 상태임
assign y1 = ~(a & b);  //race condition (reg wire 혼용시 실행순서에 따라 결과가 달라짐)
assign y2 = a | b;
assign y3= ~(a | b);
assign y4= (a ^ b); //xor
assign y5 = ~(a ^ b); //xnor
assign y6 = ~a; 

//X : Don't care (쇼트 남)
//always @(posedge clk and negedge rst_n)
endmodule
