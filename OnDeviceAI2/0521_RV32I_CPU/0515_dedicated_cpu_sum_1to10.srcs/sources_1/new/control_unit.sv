`timescale 1ns / 1ps

`include "define.vh"

module control_unit(                    //clk 없음, 1clk마다 자동으로 값이 계속 바껴서 들어옴.
    input logic [31:0] instr_code,
    output logic rf_we,
    output logic alusrc_sel,
    output logic [3:0] alu_control,
    output logic [2:0] mem_mode,
    output logic dwe,
    output logic rfsrc_sel
);


    logic [2:0] funct3;
    logic [6:0] funct7;  //7bit
    logic [6:0] opcode;  //7bit


    assign funct7 = instr_code[31:25];  //7bit
    assign funct3 = instr_code[14:12];  //3bit
    assign opcode = instr_code[6:0];  //7bit

    //[DEBUG]
    typedef enum logic [6:0] {
        R_TYPE  = `R_TYPE,
        S_TYPE  = `S_TYPE,
        IL_TYPE = `IL_TYPE,
        I_TYPE  = `I_TYPE
    } opcode_dbg_e;
    opcode_dbg_e opcode_dbg;
    assign opcode_dbg = opcode_dbg_e'(opcode);

    always_comb begin
        rf_we       = 1'b0;
        alusrc_sel  = 0;
        alu_control = 4'd0;
        mem_mode    = 3'b0;
        dwe         = 0;
        rfsrc_sel   = 0;
        case (opcode)
            `R_TYPE: begin
                rf_we = 1'b1;
                alusrc_sel = 0;
                alu_control = {funct7[5], funct3};
                mem_mode = 3'b0;
                dwe = 0;
                rfsrc_sel = 0;
            end
            `S_TYPE: begin
                rf_we = 1'b0;
                alusrc_sel = 1;
                alu_control = `ADD;
                mem_mode = funct3;
                dwe = 1;
                rfsrc_sel = 0;
            end
            `IL_TYPE: begin
                rf_we = 1'b1;  // 
                alusrc_sel = 1;  //immediate 값
                alu_control = `ADD;  //add만 있으면 됨
                mem_mode = funct3;  //1
                dwe = 0;  //memory에 write가 아니라 load를 해야됨.
                rfsrc_sel = 1;  //memory에서 값이 오는거임
            end
            `I_TYPE: begin
                rf_we      = 1'b1;
                alusrc_sel = 1'b1;
                mem_mode   = 3'b0;
                dwe        = 1'b0;
                rfsrc_sel  = 1'b0;
                if (funct3 == 3'b101) begin
                    alu_control = {funct7[5], funct3};
                end else begin
                    alu_control = {1'b0, funct3};
                end             
            end
        endcase
    end
endmodule
