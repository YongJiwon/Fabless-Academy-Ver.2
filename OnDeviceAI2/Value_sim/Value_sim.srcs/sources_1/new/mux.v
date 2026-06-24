

`timescale 1ns / 1ps

/*
module mux(
    input [3:0] a_in,
    input [3:0] b_in,
    input [3:0] c_in,
    input [3:0] d_in,
    input [3:0] sel,
    output reg [3:0] mux_out
);


always @(sel) begin
    if (sel == 2'b00) mux_out = a_in;
    else if (sel == 2'b01) mux_out = b_in;
    else if(sel == 2'b10) mux_out = c_in;
    else if(sel == 2'b11) mux_out = d_in;
    else mux_out = 4'b0;
end




endmodule
*/



module mux(
    input [7:0] data_a,
    input [7:0] data_b,
    input en_b,
    input en_a,
    output wire [7:0] bus_data
);

assign bus_data = en_a ? data_a : en_b ? data_b : 8'hzz;

endmodule