
//OP-CODE
`define R_TYPE 7'b011_0011
`define S_TYPE 7'b010_0011
`define IL_TYPE 7'b000_0011
`define I_TYPE 7'b001_0011

//R-type instruction

//{funct7[5], funct3}
`define ADD 4'b0000
`define SUB 4'b1000
`define SLL 4'b0001
`define SLT 4'b0010
`define SLTU 4'b0011
`define XOR 4'b0100
`define SRL 4'b0101
`define SRA 4'b1101
`define OR  4'b0110
`define AND 4'b0111

//I-type instruction
`define LHU 3'b011
`define LBU  3'b101

`define LBU 3'b100  // 무부호 바이트 로드 규격 (funct3 = 3'b100)
`define LHU 3'b101  // 무부호 하프워드 로드 규격 (funct3 = 3'b101)

//S-Type instruction
`define SB 3'b000
`define SH 3'b001
`define SW 3'b010







