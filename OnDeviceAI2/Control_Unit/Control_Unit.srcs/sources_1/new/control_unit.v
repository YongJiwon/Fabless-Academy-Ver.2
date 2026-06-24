`timescale 1ns / 1ps

module control_unit(
    input clk,
    input rst,
    input i_mode,
    input i_clear,
    input i_run_stop,
    input i_btnu,        // 지금은 미사용
    input [2:0] sw,
    output o_mode,
    output reg o_clear,
    output reg o_run_stop,
    output [2:0] o_led
);

    // 상태 정의
        // mode는 기억되어야 하므로 reg 필요
    reg mode_reg, mode_next;

    parameter S0_STOP  = 2'b00;
    parameter S1_RUN   = 2'b01;
    parameter S2_CLEAR = 2'b10;
    parameter S3_MODE  = 2'b11;

    reg [1:0] state, next_state;

    wire [2:0] w_led;

    // 출력 연결
    assign o_mode = mode_reg;
    assign o_led  = sw;

    //========================
    // state register
    //========================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state    <= S0_STOP;
            mode_reg <= 1'b0;
        end else begin
            state    <= next_state;
            mode_reg <= mode_next;
        end
    end

    //========================
    // next state + output logic
    //========================
    always @(*) begin
        // 기본값
        next_state = state;
        mode_next  = mode_reg;

        o_clear    = 1'b0;
        o_run_stop = 1'b0;

        case (state)
            // -----------------
            // STOP 상태
            // -----------------
            S0_STOP: begin
                o_run_stop = 1'b0;   // 정지 상태
                o_clear    = 1'b0;

                if (i_run_stop) begin
                    next_state = S1_RUN;
                end
                else if (i_clear) begin
                    next_state = S2_CLEAR;
                end
                else if (i_mode) begin
                    next_state = S3_MODE;
                end
            end

            // -----------------
            // RUN 상태
            // -----------------
            S1_RUN: begin
                o_run_stop = 1'b1;   // 동작 상태
                o_clear    = 1'b0;

                if (i_run_stop) begin
                    next_state = S0_STOP;
                end
                else if (i_clear) begin
                    next_state = S2_CLEAR;
                end
                else if (i_mode) begin
                    next_state = S3_MODE;
                end
            end

            // -----------------
            // CLEAR 상태
            // 1클럭 동안 clear 출력 후
            // STOP으로 복귀
            // -----------------
            S2_CLEAR: begin
                o_run_stop = 1'b0;
                o_clear    = 1'b1;
                next_state = S0_STOP;
            end

            // -----------------
            // MODE 상태
            // mode 토글 후 STOP 복귀
            // -----------------
            S3_MODE: begin
                o_run_stop = 1'b0;
                o_clear    = 1'b0;
                mode_next  = ~mode_reg;
                next_state = S0_STOP;
            end

            default: begin
                next_state = S0_STOP;
                mode_next  = mode_reg;
                o_run_stop = 1'b0;
                o_clear    = 1'b0;
            end
        endcase
    end

endmodule