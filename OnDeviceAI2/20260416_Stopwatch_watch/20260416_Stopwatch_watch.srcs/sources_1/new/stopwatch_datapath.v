`timescale 1ns / 1ps

module stopwatch_datapath #(
    parameter   MSEC_WIDTH = 7,
                SEC_WIDTH = 6,
                MIN_WIDTH = 6,
                HOUR_WIDTH = 5
)(
    input clk,
    input rst,
    input [MSEC_WIDTH - 1:0] msec,
    input [SEC_WIDTH - 1:0] sec,
    input [MIN_WIDTH - 1:0] min,
    input [HOUR_WIDTH - 1:0] hour,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

wire w_tick_100hz, w_sec_tick, w_min_tick, w_hour_tick;







//밀리초
 tick_counter  # (
    .TIMES(100),
    .BIT_WIDTH (MSEC_WIDTH)
) U_MSEC_TICK_COUNTER(
    .clk(clk),
    .rst(rst),
    .i_tick(w_tick_100hz), //from msec o_tick
    .time_counter(msec),
    .o_tick(w_sec_tick)
);

//초
 tick_counter  # (
    .TIMES(60),
    .BIT_WIDTH (SEC_WIDTH)
) U_SEC_TICK_COUNTER(
    .clk(clk),
    .rst(rst),
    .i_tick(w_sec_tick),
    .time_counter(sec),
    .o_tick(w_min_tick)
);

//분
 tick_counter  # (
    .TIMES(60),
    .BIT_WIDTH (MIN_WIDTH)
) U_MIN_TICK_COUNTER(
    .clk(clk),
    .rst(rst),
    .i_tick(w_min_tick),
    .time_counter(min),
    .o_tick(w_hour_tick)
);

 tick_counter  # (
    .TIMES(24),
    .BIT_WIDTH (HOUR_WIDTH)
) U_HOUR_TICK_COUNTER(
    .clk(clk),
    .rst(rst),
    .i_tick(w_hour_tick),
    .time_counter(hour),
    .o_tick()
);



//-----------------------------------------------------------------------------------------------


//tick_gen_100hz start

tick_gen_100hz dut(
    .clk(clk),
    .rst(rst),
    .o_tick_100hz(w_tick_100hz)
);


endmodule

//stopwatch_datapath end



//-----------------------------------------------------------------------------------------------//


//tick_counter start

module tick_counter #(
    parameter   TIMES = 100,
                BIT_WIDTH = 7
)(
    input clk,
    input rst,
    input i_clear,
    input i_mode,
    input i_tick, //enable
    output [BIT_WIDTH -1:0] time_counter,
    output reg o_tick
);
    //counter register
    reg [BIT_WIDTH-1:0] counter_reg, counter_next;
    assign time_counter = counter_reg;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_reg <=0;
        end else begin
            counter_reg <= counter_next;
        end  
    end


    
    //next counter
    //parameter F_COUNT = 100_000_000/100; 뭔데 이거
    //틱이 들어올때마다 카운트함
    // next counter CL : blocking =
    always @(*) begin
        counter_next = counter_reg;
        o_tick = 1'b0;
        if (i_tick) begin
            //output: next -> counter_next, input : current -> counter_reg
            if (i_mode) begin
                counter_next = counter_reg - 1;
                if (counter_reg == 0) begin
                    counter_next = TIMES - 1;
                    o_tick = 1'b1;
                end else begin
                    o_tick = 1'b0;
                end
            end else begin
                counter_next = counter_reg + 1;
                if (counter_reg == TIMES - 1) begin
                    counter_next = 0;
                    o_tick = 1'b1;
                end else begin
                    o_tick = 1'b0;
                end
            end
        end else if (i_clear) begin
            counter_next = 0;
            o_tick = 1'b0;
        end
    end


endmodule

//tick_counter end



//tick_gen_100hz start

module tick_gen_100hz (
    input clk,
    input rst,
    input i_runstop,
    input i_clear,
    output reg o_tick_100hz
);


parameter F_COUNT = 100_000_000/100;
reg [$clog2(F_COUNT) - 1:0] counter_reg;
 


always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter_reg <= 0;
        o_tick_100hz <= 1'b0; //reset
    end else begin
        if (i_runstop) begin
            counter_reg <=counter_reg +1;
            if (counter_reg == F_COUNT -1) begin
                counter_reg <= 0;
                o_tick_100hz <= 1'b1;
            end else begin
                o_tick_100hz <= 1'b0;
            end
        end else if (i_clear) begin
            
        end
        
    end
end

    
endmodule

//tick_gen_100hz end