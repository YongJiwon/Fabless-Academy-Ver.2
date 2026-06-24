`timescale 1ns / 1ps

module ram(
    input clk,
    input [3:0] addr,
    input [7:0] wdata,
    input we,
    output  reg [7:0] rdata
    );



    reg [7:0] ram [0:15]; //{2D -Array 배열} {parameter name} {2D- Vector: address}


//SL Output
/**/
    always @(posedge clk) begin
        //read only
        if (we) begin
            ram[addr] <= wdata; //Write data
        end
        
        //writr only
        
        else begin
            rdata <= ram[addr]; //Read and Output data
        end
    end

/**/

// CL Output
/*    always @(posedge clk) begin
        //read only
        if (we) begin
            ram[addr] <= wdata;
        end
        
        //writr only

assign rdata = ram[addr];


output wire [7:0] rdata

*/







endmodule
