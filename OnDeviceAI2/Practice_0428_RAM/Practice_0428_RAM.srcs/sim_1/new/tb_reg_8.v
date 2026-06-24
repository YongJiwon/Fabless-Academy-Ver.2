`timescale 1ns / 1ps


module tb_reg_8();

    reg clk;
    reg rst;
    reg [7:0] d;
    wire [7:0] q;




always #5 clk = ~clk;


        
integer i;

initial begin
    
    clk = 1;
    rst = 1;
    #10 rst =0;
    #11 d = 8'd0;
    //#9 d = 8'd126;
    

    for (i = 0; i<1000; i=i+1 ) begin
        #10 d = 8'd0;
        #10 d = i;
    #10 d = 8'd127;

    end
    


    $stop;

    $finish;




end
    



register_8bit dut(
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);


endmodule
