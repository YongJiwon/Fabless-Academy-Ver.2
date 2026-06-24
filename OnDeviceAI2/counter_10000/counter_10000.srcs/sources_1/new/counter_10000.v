`timescale 1ns / 1ps

module counter_10000 (
    input        clk,
    input        rst,
    input       BTN_D,
    input       BTN_R,
    input       BTN_L,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);
    
    wire [13:0] w_tick_counter;
    wire w_run_stop, w_clear, w_mode;
    wire w_btn_L, w_btn_R, w_btn_D;

button_debounce U_DB_RUNSTOP(
    .clk(clk),
    .rst(rst),
    .i_btn(BTN_R),
    .o_btn(w_btn_R)
);

button_debounce U_DB_CLEAR(
    .clk(clk),
    .rst(rst),
    .i_btn(BTN_L),
    .o_btn(w_btn_L)
);


button_debounce U_DB_MODE(
    .clk(clk),
    .rst(rst),
    .i_btn(BTN_D),
    .o_btn(w_btn_D)
);





control_unit U_CONTROL_UNIT(
    .clk(clk),
    .rst(rst),
    .i_run_stop(w_btn_R),
    .i_clear(w_btn_L),
    .i_mode(w_btn_D),
    .o_run_stop(w_run_stop),
    .o_clear(w_clear),
    .o_mode(w_mode)
);


    fnd_controller U_FND_UNIT (
     .clk(clk),
     .rst(rst),
     .fnd_in(w_tick_counter),
     .fnd_com(fnd_com),
     .fnd_data(fnd_data)
    );

    datapath U_DATAPATH(
    .clk(clk),
    .rst(rst),
    .i_run_stop(w_run_stop),
    .i_clear(w_clear),
    .i_mode(w_mode),
    .tick_counter(w_tick_counter)
    ); 
endmodule



module datapath(
    input clk,
    input rst,
    input i_run_stop,
    input i_clear,
    input i_mode,
    output [13:0] tick_counter
); 

    wire w_tick_10hz;

    tick_counter U_TICK_COUNTER(
    .clk(clk),
    .rst(rst),
    .i_tick(w_tick_10hz),
    //.i_run_stop(i_run_stop),
    .i_clear(i_clear),
    .i_mode(i_mode),
    .o_tick_counter(tick_counter) 
);

    clk_tick_gen U_CLK_GEN(
        .clk(clk),
        .rst(rst),
        .i_run_stop(i_run_stop),
        .i_clear(i_clear),
        .o_tick(w_tick_10hz)
);

endmodule


module tick_counter ( //외부 신호 내보내는 것
    input clk,
    input rst,
    input i_tick,
    input i_clear,
    input i_mode,
    output [13:0] o_tick_counter //왜 이거는 o_tick이랑 달리 reg로 선언하지 않았을까?
);
    reg [$clog2(10_000)-1 : 0] tick_counter_reg;

    assign o_tick_counter = tick_counter_reg;

    always @(posedge clk, posedge rst) begin
        if(rst | i_clear) begin
            tick_counter_reg <= 14'd0;
        end else begin
            //if(i_tick == 1'b1) begin
            if(i_tick) begin
                if(!i_mode) begin
                    //up count
                    tick_counter_reg <= tick_counter_reg + 1;
                    if(tick_counter_reg == (10_000 -1)) begin
                        tick_counter_reg <= 14'd0;
                    end
                end else begin
                    //down count
                    tick_counter_reg <= tick_counter_reg - 1;
                    if(tick_counter_reg == 0) begin
                        tick_counter_reg <= 14'd9999;
                    end
                end
            end
        end
    end

endmodule

//clk_tick_gen_10khz 설계
module clk_tick_gen (
    input      clk,
    input      rst,
    input      i_run_stop,
    input      i_clear,
    output reg o_tick       //신호이므로 1bit
);

    //100_000_000를 카운트(10hz로 바꾸기)하려면 얼마를 나누면 될까? 천만번 카운트하면 됨
    //=> 100_000_000 / 10  (100Mhz -> 10hz)
    reg [$clog2(100_000_000/10)-1 : 0] counter_reg;  //$clog2가 시스템 함수 같은 것으로 해당 숫자 log base2한 값을 리턴함
    //0까지니까 -1한 것!


    always @(posedge clk, posedge rst) begin
        if (rst | i_clear) begin
            counter_reg <= 24'd0;
            o_tick      <= 1'b0;  //출력도 초기화
        end else begin
            if (i_run_stop) begin
                counter_reg <= counter_reg + 1;
                o_tick <= 1'b0;
                if(counter_reg == (10_000_000 - 1)) begin //10_000_000 -1까지 카운트한 다음에 초기화, 그렇게 해야 otick 신호 발생시켜서 100ms마다 일 발생시킬 수 있음
                    counter_reg <= 24'd0; //여기까지는 clk만 발생시키고 있고 o_tick은 아직!

                    o_tick <= 1'b1; //counter가 9_999_999가 되면 o_tick을 1로 한 뒤에 다음 사이클에 0으로 떨구기
                end
            end
        end
    end

endmodule

