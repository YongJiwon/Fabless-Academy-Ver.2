`timescale 1ns / 1ps



module top_rv32i_soc(
    input logic clk,
    input logic rst
    );

logic [31:0] instr_code; 
logic [31:0] instr_addr;

rv32i_cpu U_RV32I_CPU(
    .clk(clk),
    .rst(rst),
    .instr_code(instr_code), 
    .instr_addr(instr_addr)
);

instruction_mem U_INSTR_ROM(
    .instr_addr(instr_addr),
    .instr_code(instr_code)
);


endmodule
