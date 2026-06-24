`timescale 1ns / 1ps

module mux_2to1 (
    input [7:0] num0,
    input [7:0] alu_in,
    input asrc_sel,
    output wire [7:0] alu_out
);
assign alu_out = (asrc_sel) ? alu_in : num0;
endmodule
