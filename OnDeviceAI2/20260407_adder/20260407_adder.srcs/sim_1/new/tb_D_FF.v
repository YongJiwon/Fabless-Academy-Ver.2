`timescale 1ns/1ps

module tb_D_FF;
reg clk;
reg rst_n;
reg d;
wire q;

D_FF1 U_D_FF1(
	.clk(clk),
	.rst_n(rst_n),
	.d(d),
	.q(q)
);

always @(posedge clk , negedge rst_n) begin
	if(!rst_n) begin
		clk <= 1'b0;
		rst_n <=1'b0;		

	end
	else begin
		clk <= ~clk;
		rst_n <= 1'b1;
	end
end

endmodule