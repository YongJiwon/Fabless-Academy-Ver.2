`timescale 1ns / 1ps

module tb_spi_master;
    logic       clk;
    logic       reset;
    logic       start;
    logic       cpol;
    logic       cpha;
    logic [7:0] clk_div;
    logic [7:0] tx_data;
    logic       busy;
    logic [7:0] rx_data;
    logic       done;
    logic       sclk;
    logic       mosi;
    logic       miso;
    logic       ss_n;

initial clk = 0;
always #5 clk =~clk;

initial begin
    clk = 0;
    reset =1;
    repeat(3) @(posedge clk);
    reset = 0;
    @(posedge clk);
    clk_div = 4;




end








spi_master U_SPI_MASTER(    
    .clk(clk),
    .reset(reset),
    .start(start),
    .cpol(cpol),
    .cpha(cpha),
    .clk_div(clk_div),
    .tx_data(tx_data),
    .busy(busy),
    .rx_data(rx_data),
    .done(done),
    .sclk(sclk),
    .mosi(mosi),
    .miso(miso),
    .ss_n(ss_n)
);








endmodule
