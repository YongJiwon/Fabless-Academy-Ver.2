`timescale 1ms / 1ms



module tb_stopwatch_datapath();

stopwatch_datapath dut(
    .clk(clk),
    .rst(rst),
    .msec(msec),
    .sec(sec),
    .min(min),
    .hour(hour)
);









always #5 clk =~clk;





initial begin
    clk = 1'b0;
    rst = 1'b1;
    #5;

    rst = 1'b0;

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    rst = 0;
    repeat (100_000_000) @(negedge clk);

    $stop;
    #20000;

end






















endmodule



