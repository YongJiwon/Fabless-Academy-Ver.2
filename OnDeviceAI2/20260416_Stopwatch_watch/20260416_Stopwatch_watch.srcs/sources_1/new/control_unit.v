`timescale 1ns / 1ps

module control_unit(
    input clk,
    input rst,
    input wire [1:0] in_state,
    output reg [1:0] sw_state
);


reg [1:0] state, next_state;
reg [1:0] S0 = 2'b00; //IDLE
reg [1:0] S1 = 2'b01; // rst
reg [1:0] S2 = 2'b10; // stop/run
reg [1:0] S3 = 2'b11; //clear
 


// next state 결정(조합논리)
always @(*) begin
    next_state = state;
    case (state)
        S0: next_state = (in_state == 2'b00) ? S0 : S1;
        S1: next_state = (in_state == 2'b01) ? S1 : S2;
        S2: next_state = (in_state == 2'b10) ? S2 : S3;
        S3: next_state = (in_state == 2'b11) ? S3 : S0;
        default: next_state = S0;
    endcase
end


//상태 레지스터 (순차논리)
always @(posedge clk or posedge rst) begin
    if(rst) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end


endmodule
