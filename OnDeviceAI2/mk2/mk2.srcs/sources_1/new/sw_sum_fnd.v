`timescale 1ns / 1ps

module sw_sum_fnd (
    input  wire [2:0] sw,     // 스위치 3개
    output reg  [6:0] seg     // 7-segment (a,b,c,d,e,f,g)
);

reg [1:0] sum;

always @(*) begin
    // 켜진 스위치 개수 카운트
    sum = sw[0] + sw[1] + sw[2];

    // FND 출력 (common cathode 기준: 1이면 켜짐)
    case (sum)
        2'd0: seg = 7'b1111110; // 0
        2'd1: seg = 7'b0110000; // 1
        2'd2: seg = 7'b1101101; // 2
        2'd3: seg = 7'b1111001; // 3
        default: seg = 7'b0000000;
    endcase
end

endmodule