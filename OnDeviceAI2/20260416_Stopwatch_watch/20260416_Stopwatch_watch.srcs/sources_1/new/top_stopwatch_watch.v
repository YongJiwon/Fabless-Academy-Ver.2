`timescale 1ns / 1ps

module top_stopwatch_watch(
    input clk,
    input rst,
    input btnR,
    input btnL,
    input btnU,
    input btnD,
    input [2:0] sw,
    output [7:0] fnd_data,
    output [3:0] fnd_com,
    output [2:0] led
);

    parameter MSEC_WIDTH = 7,
              SEC_WIDTH  = 6,
              MIN_WIDTH  = 6,
              HOUR_WIDTH = 5;

    wire [MSEC_WIDTH-1:0] w_msec;
    wire [SEC_WIDTH-1:0]  w_sec;
    wire [MIN_WIDTH-1:0]  w_min;
    wire [HOUR_WIDTH-1:0] w_hour;

    wire w_run_stop, w_clear, w_mode;
    wire w_btnR, w_btnL, w_btnD, w_btnU;
    wire [2:0] w_led;

    // -----------------------------
    // 버튼 디바운스
    // -----------------------------
    button_debounce U_BTNR(
        .clk(clk),
        .rst(rst),
        .i_btn(btnR),
        .o_btn(w_btnR)
    );

    button_debounce U_BTNL(
        .clk(clk),
        .rst(rst),
        .i_btn(btnL),
        .o_btn(w_btnL)
    );

    button_debounce U_BTND(
        .clk(clk),
        .rst(rst),
        .i_btn(btnD),
        .o_btn(w_btnD)
    );

    button_debounce U_BTNU(
        .clk(clk),
        .rst(rst),
        .i_btn(btnU),
        .o_btn(w_btnU)
    );

    // -----------------------------
    // Control Unit
    // 버튼 매핑:
    // btnD -> mode
    // btnL -> clear
    // btnR -> run/stop
    // btnU -> extra button
    // -----------------------------
    control_unit U_CONTROL_UNIT (
        .clk(clk),
        .rst(rst),
        .i_mode(w_btnD),
        .i_clear(w_btnL),
        .i_run_stop(w_btnR),
        .i_btnu(w_btnU),
        .sw(sw),
        .o_mode(w_mode),
        .o_clear(w_clear),
        .o_run_stop(w_run_stop),
        .o_led(w_led)
    );

    // -----------------------------
    // Datapath
    // -----------------------------
    stopwatch_datapath U_STOPWATCH_DATAPATH(
        .clk(clk),
        .rst(rst),
        .i_runstop(w_run_stop),
        .i_clear(w_clear),
        .i_mode(w_mode),
        .msec(w_msec),
        .sec(w_sec),
        .min(w_min),
        .hour(w_hour)
    );

    // -----------------------------
    // FND Controller
    // 주의:
    // 현재 올려주신 fnd_controller 정의에는
    // sw 포트가 없고, fnd_in 포트가 있습니다.
    // 그래서 아래처럼 연결해야 맞습니다.
    // -----------------------------
    fnd_controller U_FND_CNTL(
        .clk(clk),
        .rst(rst),
        .msec(w_msec),
        .sec(w_sec),
        .min(w_min),
        .hour(w_hour),
        .fnd_in(8'd0),      // 현재 미사용이면 0으로 묶기
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );

    assign led = w_led;

endmodule