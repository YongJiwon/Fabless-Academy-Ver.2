`timescale 1ns / 1ps

module top_rv32i_soc (
    input logic clk,
    input logic rst
);
    // 1. 내부 중간 연결 전선(Bus) 선언
    logic [31:0] instr_code, instr_addr;
    //logic [31:0] data_addr, data_rd; // [추가] 데이터 롬용 전선

    // 2. 명령어 롬 인스턴스
    instruction_mem U_INSRT_ROM (
        .instr_addr(instr_addr),
        .instr_code(instr_code)
    );

    // 3. 데이터 롬 인스턴스 [추가]
 /*   data_rom U_DATA_ROM (
        .data_addr(data_addr), // CPU가 계산한 데이터 메모리 주소를 받음
        .data_rd(data_rd)      // 읽어온 데이터를 CPU의 데이터패스로 전달
    );
*/
    // 4. RV32I CPU 코어 인스턴스
    // (.* 와일드카드에 의해 instr_code, instr_addr, data_addr, data_rd가 이름에 맞춰 자동 결선됩니다.)
    rv32i_cpu U_CPU (.*);

endmodule