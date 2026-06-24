`timescale 1ns / 1ps

module i2c_demo_count(
    input logic clk,
    input logic reset,
    input logic sw,
    output logic scl,
    inout wire sda
    //output logic count
);



    typedef enum logic [2:0] {
        IDLE = 0,
        START,
        ADDR,
        WRITE,
        STOP
    } i2c_state_e;

    localparam SLA_W = {7'h12, 1'b0};

    i2c_state_e state;





    logic cmd_start;
    logic cmd_write;
    logic cmd_read;
    logic cmd_stop;

    logic [7:0] tx_data;
    logic [7:0] rx_data;
    logic ack_in;
    logic ack_out;
    logic busy;
    logic done;

    logic [1:0] dff;
    logic sw_r;
    logic [7:0] counter;

    assign sw_r = dff[1];


    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            dff <= 0;
        end else begin
            dff[0] <= sw;
            dff[1] <= dff[0];
        end
    end



I2C_Master_top dut(
    .clk(clk),
    .reset(reset),
    // command port
    .cmd_start(cmd_start),
    .cmd_write(cmd_write),
    .cmd_read(cmd_read),
    .cmd_stop(cmd_stop),
    // internal port
    .tx_data(tx_data),
    .rx_data(rx_data),
    .ack_in(ack_in),
    .ack_out(ack_out),
    .busy(busy),
    .done(done),
    // external i2c port
    .scl(scl),
    .sda(sda)

);


always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        counter <= 0;
        cmd_start <= 0;
        cmd_write <= 0;
        cmd_read <= 0;
        cmd_stop <= 0;
        tx_data <= 0;
    end else begin
        case (state)
            IDLE: begin
                cmd_start <= 0;
                cmd_write <= 0;
                cmd_read <= 0;
                cmd_stop <= 0;
                if (sw_r) begin
                    state <= START;
                end
                
            end
            START: begin
                cmd_start <= 1;
                cmd_write <= 0;
                cmd_read <= 0;
                cmd_stop <= 0;
                if (done) begin
                    state <= ADDR;
                end
            end
            ADDR: begin
                cmd_start <= 0;
                cmd_write <= 1;
                cmd_read <= 0;
                cmd_stop <= 0;
                tx_data <= 0;
                if (done) begin
                    state <= WRITE;
                end
            end
            WRITE: begin
                cmd_start <= 0;
                cmd_write <= 1;
                cmd_read <= 0;
                cmd_stop <= 0;
                tx_data <= counter;
                if (done) begin
                    state <= STOP;
                    counter <= counter + 1;
                end
            end
            STOP: begin
                cmd_start <= 0;
                cmd_write <= 0;
                cmd_read <= 0;
                cmd_stop <= 1;
                if (done) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end

end






endmodule
