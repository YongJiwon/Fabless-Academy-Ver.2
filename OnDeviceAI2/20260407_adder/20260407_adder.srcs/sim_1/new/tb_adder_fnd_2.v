`timescale 1ns/1ps

module tb_adder_fnd_2;
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


initial begin
	#5	clk = 1'b0;
	#0.1	rst_n =1'b1;
	d = 0;
	#10 rst_n =1'b1;
	#10 d=1'b1;
	#10 d = 1'b0;
	#10 d = 1'b1;
	#20 $finish;

end

endmodule





