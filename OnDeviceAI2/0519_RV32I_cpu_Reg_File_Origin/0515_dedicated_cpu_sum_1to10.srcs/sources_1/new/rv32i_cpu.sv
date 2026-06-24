`timescale 1ns / 1ps

module rv32i_cpu (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instr_code, // [원복] Top 모듈의 ROM에서 들어오는 입력 포트
    output logic [31:0] instr_addr  // [원복] Top 모듈의 ROM으로 나가는 출력 포트
);
    logic        rf_we;
    
    // [핵심 버그 수정] ALU의 10비트 규격에 맞춰 버스를 10비트로 확장합니다.
    logic [3:0]  alu_control; 

    // =========================================================================
    // 1. Control Unit 인스턴스
    // =========================================================================
    contorl_unit U_CU (
        .func7      (instr_code[31:25]),
        .func3      (instr_code[14:12]),
        .opcode     (instr_code[6:0]),
        .rf_we      (rf_we),
        .alu_control   (alu_control) // 하위 포트명이 alu_ctrl이면 이대로 매핑
    );

    // =========================================================================
    // 2. Datapath 인스턴스
    // =========================================================================
    rv32i_datapath U_DP (
        .clk        (clk),
        .rst        (rst),
        .instr_code (instr_code),
        .rf_we      (rf_we),
        .alu_control   (alu_control), // 하위 포트명이 alu_ctrl이면 이대로 매핑
        .instr_addr (instr_addr)
    );

endmodule