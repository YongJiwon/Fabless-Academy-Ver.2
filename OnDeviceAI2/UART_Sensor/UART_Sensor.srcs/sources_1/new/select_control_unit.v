`timescale 1ns / 1ps

module select_control_unit (
    input        btnL,
    input        btnR,
    input        btnU,
    input        btnD,
    input  [1:0] sw_mode,
    output       o_wt_left,
    output       o_wt_right,
    output       o_wt_up,
    output       o_wt_down,
    output       o_st_clear,
    output       o_st_run_stop,
    output       o_st_type,
    output       o_dht11_signal,
    output       o_sr04_signal
);

    and (o_wt_left, btnL, ~sw_mode[1], ~sw_mode[0]);
    and (o_wt_right, btnR, ~sw_mode[1], ~sw_mode[0]);
    and (o_wt_up, btnU, ~sw_mode[1], ~sw_mode[0]);
    and (o_wt_down, btnD, ~sw_mode[1], ~sw_mode[0]);
    and (o_st_clear, btnL, ~sw_mode[1], sw_mode[0]);
    and (o_st_run_stop, btnR, ~sw_mode[1], sw_mode[0]);
    and (o_st_type, btnD, ~sw_mode[1], sw_mode[0]);
    and (o_dht11_signal, btnR, sw_mode[1], ~sw_mode[0]);
    and (o_sr04_signal, btnR, sw_mode[1], sw_mode[0]);


endmodule