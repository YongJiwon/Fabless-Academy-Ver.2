`timescale 1ns / 1ps

module tb_fnd_full_adder();

    reg [3:0] a;
	reg [3:0] b;
	wire [3:0] fnd_com;
	wire [7:0] fnd_data;
	wire       led;
	
	integer i,j;
	
	adder_fnd dut(
		.a(a),
		.b(b),
		.fnd_com(fnd_com),
		.fnd_data(fnd_data),
		.led(led)
	);
	
	initial begin
	//a와 b에 어떤 값을 줘야 할까?
		i = 0;
		j = 0;
		for(i = 0; i < 16; i = i+1) begin
			for(j = 0; j < 16; j = j+1) begin
				a = i;
				b = j;
				#10;
				end
		end
		$stop;
		
	end
endmodule
