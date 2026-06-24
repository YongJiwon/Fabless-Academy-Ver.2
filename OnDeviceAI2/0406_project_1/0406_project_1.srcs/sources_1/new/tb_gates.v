`timescale 1ns / 1ps

module tb_gates();

reg clk;
reg a,b;
wire y0,y1,y2,y3,y4,y5,y6;






initial	begin
	clk = 0 ;
	forever
		#5 clk = ~ clk ;
end

initial begin
    clk = 1'b0;
    a <=1'b0; b <=1'b0;
    
    #5    a <=1'b1; b <=1'b0; 
    
    #5    a <=1'b0; b <=1'b1;

    #5    a <=1'b1; b <=1'b1;
    
    #5    a <=1'b0; b <=1'b0;

    #5    a <=1'b1; b <=1'b1;
    
    #5    a <=1'b0; b <=1'b0;
    

    #5    a <=1'bZ; b <=1'bZ;
     
    #5    a <=1'bX; b <= 1'bX;
    $finish;
end




gates dut(
    .a(a),
    .b(b),
    .y0(y0),
    .y1(y1),
    .y2(y2),
    .y3(y3),
    .y4(y4),
    .y5(y5),
    .y6(y6)
);


endmodule
