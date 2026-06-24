`timescale 1ns / 1ps


module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum,
    output carry
);

    wire w_sum1, w_carry1;

    full_adder_4bit FA_4bit0 (
        .a  (a[3:0]),
        .b  (b[3:0]),
        .cin(1'b0),
        .s  (w_sum1),
        .c  (w_carry1)
    );
    full_adder_4bit FA_4bit1 (
        .a  (a[7:4]),
        .b  (b[7:4]),
        .cin(w_carry1),
        .s  (sum),
        .c  (carry)
    );

endmodule
