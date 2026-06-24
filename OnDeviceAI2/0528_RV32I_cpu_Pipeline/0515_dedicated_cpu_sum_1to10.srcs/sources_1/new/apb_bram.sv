`timescale 1ns / 1ps


module apb_bram(
    input  logic pclk,
    input  logic [31:0] paddr,
    input  logic [31:0] pwdata,
    input  logic        penable,
    input logic        psel,
    input  logic        pwrite,
    output  logic        pready,
    output logic [31:0] prdata
    );


    logic [31:0] bram [0:63];

assign pready = (penable && psel) ;
assign prdata = bram[paddr[31:2]];

always_ff @(posedge pclk) begin
    if(pwrite & pready) begin
        bram[paddr[7:2]] <= pwdata;
    end 
end







endmodule
