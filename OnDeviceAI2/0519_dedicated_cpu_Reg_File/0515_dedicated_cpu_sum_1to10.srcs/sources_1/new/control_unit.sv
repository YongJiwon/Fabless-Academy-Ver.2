`timescale 1ns / 1ps
`include "define.vh"

module control_unit (
    input  logic [6:0] funct7,
    input  logic [2:0] funct3,
    input  logic [6:0] opcode,
    output logic        rf_we,
    output logic [3:0] alu_control
);



    logic [3:0] funct_comb;
    assign funct_comb = {funct7[5], funct3};

    always_comb begin
        rf_we = 0;
        alu_control = 0;
        case (opcode) 
             
            `R_TYPE: begin
                rf_we = 1;
                case({funct7, funct3})
                    `ADD:  alu_control = `ADD;
                    `SUB: alu_control = `SUB;
                    `SLT: alu_control = `SLT;
                    `SLL: alu_control = `SLL;
                    `SLTU: alu_control = `SLTU;
                    `XOR: alu_control = `XOR;
                    `SRL: alu_control = `SRL;
                    `SRA: alu_control = `SRA;
                    `OR: alu_control = `OR;
                    `AND:alu_control = `AND;
                endcase
                end
            
        endcase
    end

endmodule



