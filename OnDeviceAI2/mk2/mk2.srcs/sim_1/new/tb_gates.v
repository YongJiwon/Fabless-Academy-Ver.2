`timescale 1ns / 1ps

module tb_gates;


reg d;
reg [6:0]seg;
wire [2:0] sw;
wire q;


sw_sum_fnd fnd_m(
    .sw(sw),     // 스위치 3개
    .seg(seg)     // 7-segment (a,b,c,d,e,f,g)
);


gates dut(
    .d(d),
    .q(q)
);

initial begin
    d = 0;
    #5 d = 0;
    #5 d = 1;
    #5 d = 0;
    #5 d = 1;
    #5 d = 0;
    #5 d = 1;
    #5 d = 0;

    $finish;
end

endmodule