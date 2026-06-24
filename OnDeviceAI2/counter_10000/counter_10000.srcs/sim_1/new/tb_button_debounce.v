`timescale 1ns / 1ps

module tb_button_debounce();   

reg clk, rst, i_btn;
wire o_btn;


    button_debounce dut(
            .clk(clk),
            .rst(rst),
            .i_btn(i_btn),
            .o_btn(o_btn)
    );


always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    i_btn = 0;

    repeat (3) @(negedge clk);
    rst = 0;
    #10;
    i_btn = 1;
    repeat (20000) @(negedge clk);
    i_btn = 0;
    #20;
    repeat (20000) @(negedge clk);
    i_btn = 1;
    #20;
    repeat (30000) @(negedge clk);

    #10;
    i_btn = 0;
    #20;







    $stop;

end





















    
endmodule
