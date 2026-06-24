`timescale 1ns / 1ps





module tb_adder_fnd();

    reg clk;
    reg rst;
    reg  [7:0] a;
    reg  [7:0] b;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;
    wire       led;

    
    integer i,j;
    always #5 clk = ~clk;

    adder_fnd dut(
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data),
        .led(led)
    );

    initial begin
        clk = 0;
        rst = 1;
        i = 0;
        j = 0;

        #20;
        rst = 0;

        for(i = 0; i < 256; i = i+1) begin
            for(j = 0; j < 256; j = j+1) begin
            
            a = i; 
            b = j;
            #10;
            end
        end
        $stop;


    end
endmodule
