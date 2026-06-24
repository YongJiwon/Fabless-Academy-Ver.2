module rv32i_cpu(
    input logic clk,
    input logic rst,
    input logic [31:0] instr_code, 
    output logic [31:0] instr_addr
);

    logic rf_we;
    logic [3:0] alu_control; // 10비트로 통일

    // 컨트롤 유닛은 제어 신호만 생성
    control_unit U_CONTROL_UNIT(
        .funct7(instr_code[31:25]),
        .funct3(instr_code[14:12]),
        .opcode(instr_code[6:0]),
        .*
    );

    // 데이터패스가 내부에서 ALU와 PC를 모두 처리함
    datapath U_DATA_PATH(.*);

endmodule