`timescale 1ns / 1ps
`include "define.vh"

module rv32i_datapath (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instr_code,
    input  logic        rf_we,
    input logic rfsrc_sel,
    input logic alusrc_sel,
    input logic [31:0] drdata,
    input  logic [ 3:0] alu_control,
    output logic [31:0] instr_addr,
    output logic [31:0] daddr,
    output logic [31:0] dwdata
);

    logic [31:0] rs2, rs1, alu_result,alu_rs2_mux,imm_extend, rf_src_mux_out;

    assign daddr = alu_result;
    assign dwdata = rs2;

mux_2x1 U_REG_FILE_SRC_MUX(
    .in0(alu_result),
    .in1(drdata),
    .sel(rfsrc_sel),
    .out_mux(rf_src_mux_out)
);



    program_counter U_PC (
        .clk(clk),
        .rst(rst),
        .pc_in(instr_addr),     //for next program count
        .pc_out(instr_addr)     // current program count
    );

    alu U_ALU (
        .alu_control(alu_control),
        .rs1        (rs1),
        .rs2        (alu_rs2_mux),
        .alu_result (alu_result)
    );


mux_2x1 U_ALU_RS2_MUX(
    .in0(rs2),
    .in1(imm_extend),
    .sel(alusrc_sel),
    .out_mux(alu_rs2_mux)
);

imm_extend U_IMM_EXTEND (
    .instr_code(instr_code),
    .imm_extend(imm_extend)
);



    register_file U_REG_FILE (
        .clk(clk),
        .rf_we(rf_we),
        .waddr(instr_code[11:7]),
        .wdata(rf_src_mux_out),
        .raddr1(instr_code[19:15]),
        .raddr2(instr_code[24:20]),
        .rdata1(rs1),
        .rdata2(rs2)

    );


endmodule

module program_counter (
    input clk,
    input rst,
    input [31:0] pc_in,
    output [31:0] pc_out
);

    logic [31:0] pc_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_reg <= 0;
        end else begin
            pc_reg <= pc_in + 4;
        end
    end

    assign pc_out = pc_reg;

endmodule

module imm_extend (
    input  logic [31:0] instr_code,
    output logic [31:0] imm_extend
);


    always_comb begin
        imm_extend = 32'd0;
        case(instr_code[6:0])
        `S_TYPE : imm_extend = {{20{instr_code[31]}},instr_code[31:25],instr_code[11:7]};
        `IL_TYPE,`I_TYPE : imm_extend = {{20{instr_code[31]}},instr_code[31:20]};
        endcase
    end
endmodule




module alu (
    input  logic [ 3:0] alu_control,
    input  logic [31:0] rs1,
    input  logic [31:0] rs2,
    output logic [31:0] alu_result
);
    always_comb begin
        alu_result = 32'd0;
        case (alu_control)
            `ADD:  alu_result = rs1 + rs2;
            `SUB:  alu_result = rs1 - rs2;
            `AND:  alu_result = rs1 & rs2;
            `OR:   alu_result = rs1 | rs2;
            `XOR:  alu_result = rs1 ^ rs2;
            `SLTU: alu_result = (rs1 < rs2) ? 1 : 0;
            `SLT:  alu_result = ($signed(rs1) < $signed(rs2)) ? 1 : 0;
            `SLL: alu_result = rs1 << rs2;
            `SRL: alu_result = rs1 >> rs2[4:0];
            `SRA: alu_result = $signed(rs1) >>> rs2[4:0];
        endcase
    end
endmodule



module register_file (
    input  logic        clk,
    input  logic        rf_we,   //register file write enable
    input  logic [ 4:0] waddr,
    input  logic [31:0] wdata,
    input  logic [ 4:0] raddr1,
    input  logic [ 4:0] raddr2,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2

);


    logic [31:0] register_file[1:31];
    int i = 0;
    initial begin
        for (i = 1; i < 32; i++) register_file[i] = i;
    end
    always @(posedge clk) begin
        if (rf_we) begin
            register_file[waddr] <= wdata;
        end
    end
    assign rdata1 = (raddr1 != 0) ? register_file [raddr1] :32'd0; // 조합으로 해야 1cycle 내에 처리됨. 순차로 하면 1cycle내에 처리가 안됨.
    assign rdata2 = (raddr2 != 0) ? register_file[raddr2] : 32'd0;



endmodule


module mux_2x1(
    input  logic [31:0] in0,
    input  logic [31:0] in1,
    input  logic sel,
    output logic  [31:0] out_mux
);

assign out_mux = (sel) ? in1 : in0;


endmodule
