`timescale 1ns / 1ps
`include "define.vh"

module contorl_unit (
    input  logic [6:0] func7,
    input  logic [2:0] func3,
    input  logic [6:0] opcode,
    output logic       rf_we,
    output logic [3:0] alu_control
);

    logic [3:0] funct_comb;
    assign funct_comb = {func7[5], func3};

    always_comb begin
        rf_we    = 0;
        alu_control = 0;

        case (opcode)
            `R_TYPE: begin
                rf_we = 1'b1;
                case (funct_comb)
                    `ADD:  alu_control = `ADD;
                    `SUB:  alu_control = `SUB;
                    `SLL:  alu_control = `SLL;
                    `SRL:  alu_control = `SRL;
                    `SRA:  alu_control = `SRA;
                    `SLT:  alu_control = `SLT;
                    `SLTU: alu_control = `SLTU;
                    `XOR:  alu_control = `XOR;
                    `OR:   alu_control = `OR;
                    `AND:  alu_control = `AND;
                endcase
            end
        endcase
    end
endmodule
