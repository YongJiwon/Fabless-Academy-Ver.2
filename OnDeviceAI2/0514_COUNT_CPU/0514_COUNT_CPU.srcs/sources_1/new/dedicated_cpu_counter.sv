`timescale 1ns / 1ps
module dedicated_cpu_counter(
    input  logic       clk,
    input  logic       rst,
    output logic [7:0] out
    );

    logic asrc_sel;
    logic areg_load;
    logic out_sel;
    logic eq9;

    data_path U_data_path (.*);
    control_unit U_control_unit (.*);

endmodule

module data_path (
    input  logic       clk,
    input  logic       rst,
    input  logic       asrc_sel,
    input  logic       areg_load,
    input  logic       out_sel,
    output logic       eq9,
    output logic [7:0] out
);
    logic [7:0] mux_out, reg_out, alu_result;
    
    mux_2x1 U_mux_2x1 (
    .in0(8'h00),
    .in1(alu_result),
    .sel(asrc_sel),
    .mux_out(mux_out)
    );

    a_reg U_a_reg (
    .clk(clk),
    .rst(rst),
    .load(areg_load),
    .data_in(mux_out),
    .data_out(reg_out)
    );

    alu U_alu (
    .a(reg_out),
    .b(8'h01),
    .alu_result(alu_result)
    );

    comp_eq9 U_comp_eq9 (
    .in(reg_out),
    .compare(8'h09),
    .eq9(eq9)
    );

    assign out = (out_sel) ? reg_out : 8'hz;
endmodule

module mux_2x1 (
    input  logic [7:0] in0,
    input  logic [7:0] in1,
    input  logic       sel,
    output logic [7:0] mux_out
);

    always_comb begin
        if(sel)begin
            mux_out = in1;
        end else begin
            mux_out = in0;
        end
    end

endmodule

module a_reg (
    input logic clk,
    input logic rst,
    input logic load,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
    logic [7:0] a_register;
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            a_register <= 0;
        end else begin
            if (load) begin
                a_register <= data_in;
            end 
        end
    end

    assign data_out = a_register;
endmodule

module alu (
    input   [7:0] a,
    input   [7:0] b,
    output  [7:0] alu_result
);
    assign alu_result = a + b;
endmodule

module comp_eq9 (
    input [7:0] in,
    input [7:0] compare,
    output      eq9
);
    assign eq9 = (in == compare);
endmodule

// module buffer_3_state (
//     input  [7:0] buf_in,
//     input        sel,
//     output [7:0] buf_out
// );
//     assign buf_out = (sel) ? buf_in : 8'bz;
// endmodule

module control_unit (
    input  logic clk,
    input  logic rst,
    input  logic eq9,
    output logic asrc_sel,
    output logic areg_load,
    output logic out_sel
);
    typedef enum {S0 = 0, S1, S2} state_t;
    state_t c_state, n_state;

    always_ff @(posedge clk, posedge rst) begin 
        if (rst) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    always_comb begin
        n_state     = c_state;
        areg_load   = 1;
        asrc_sel    = 0;
        out_sel     = 0;
        case (c_state)
            S0:begin
                asrc_sel    = 0;
                areg_load   = 1;
                out_sel     = 0;
                n_state     = S1;                
            end 
            S1:begin
                if (eq9) begin
                    asrc_sel    = 0;
                    areg_load   = 0;
                    out_sel     = 0;
                    n_state     = S2;
                end else begin
                    asrc_sel    = 1;
                    areg_load   = 1;
                    out_sel     = 0;
                    n_state     = S1;
                end
            end
            S2:begin
                asrc_sel    = 0;
                areg_load   = 0;
                out_sel     = 1;
            end
        endcase
    end
endmodule


/*`timescale 1ns / 1ps

module dedicated_cpu_counter(
    input clk,
    input rst_n,
    output [7:0] out

);
    control_unit U_CTRL(
        .*
    );

    data_path U_DATA(
        .*
    );

endmodule

// 1. ALU Module
module alu(
    input  [7:0] a_in,
    input  [7:0] b_in,
    output [7:0] alu_out
);
    assign alu_out = a_in + b_in;
endmodule

// 2. MUX Module
module mux_2to1 (
    input  logic [7:0] num0,
    input  logic [7:0] alu_in,
    input  logic  asrc_sel,
    output logic [7:0] mux_out
);
    assign mux_out = (asrc_sel) ? alu_in : num0;
endmodule

// 3. Register Module (순수 저장 소자로 수정)
module a_register (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       areg_load,
    input  logic [7:0] data_in,
    output logic [7:0] a_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_out <= 8'h00;
        end else if (areg_load) begin
            a_out <= data_in;
        end
    end
endmodule
 
module comp_eq9(
    input logic [7:0] in,
    input logic [7:0] compare,
    output logic eq9
);

assign eq9 = (in == compare);  
endmodule

// 4. Data Path Module
module data_path (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       asrc_sel,
    input  logic       areg_load,
    input  logic       out_sel,
    output logic       eq9,
    output logic [7:0] out
);

    // 내부 신호 logic으로 통일
    logic [7:0] mux_to_areg; 
    logic [7:0] alu_to_mux;
    logic [7:0] areg_to_alu_a;

    // 출력 처리 및 비교 로직
    assign out = areg_to_alu_a;
    assign eq9 = (areg_to_alu_a == 8'd9);

    // 인스턴스화
    mux_2to1 U_MUX(
        .num0(8'h00),
        .alu_in(alu_to_mux),
        .asrc_sel(asrc_sel),
        .mux_out(mux_to_areg)
    );

    a_register U_A_REG(
        .clk(clk),
        .rst_n(rst_n),
        .areg_load(areg_load),
        .data_in(mux_to_areg),
        .a_out(areg_to_alu_a)
    
    );

    alu U_ALU(
        .a_in(areg_to_alu_a),
        .b_in(8'h01),
        .alu_out(alu_to_mux)
    );
endmodule
    
module control_unit (
    input logic clk, 
    input logic rst_n,
    input logic eq9,
    output logic asrc_sel,
    output logic areg_load,
    output logic out_sel
);
    typedef enum {
        S0 = 0,
        S1,
        S2
    } state_t;
    state_t state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state = S0;
    end else begin
        state = next_state;
    end
end

always_comb begin
    next_state = state;
    asrc_sel = 0;
    areg_load = 0;
    out_sel = 0;
    
    case (state)
        S0: begin
                asrc_sel = 0;
                areg_load = 0;
                out_sel = 0;
                next_state = S1;
        end
        S1: begin
                if (eq9) begin
                    asrc_sel = 1;
                    areg_load = 1;
                    out_sel = 0;
                    next_state = S2;
                end else begin
                    asrc_sel = 1;
                    areg_load = 1;
                    out_sel = 0;
                    next_state = S1;
                end
        end
        S2: begin
            asrc_sel = 0;
            areg_load = 0;
            out_sel = 1;
        end
    endcase
end
endmodule*/