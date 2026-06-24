`timescale 1ns / 1ps

module tb_FND;

    //reg         clk;
    //reg         rst;
    reg  [7:0]  buttons_a;
    reg  [7:0]  buttons_b;
    wire [7:0]  segment_display;
    //wire [3:0]  digit_enable;
    wire        c_out_seg;

    //integer i, j;
    reg [7:0] i, j;


    // DUT
   /* FND uut (
        .clk(clk),
        .rst(rst),
        .buttons_a(buttons_a),
        .buttons_b(buttons_b),
        .segment_display(segment_display),
        .digit_enable(digit_enable),
        .c_out_seg(c_out_seg)
    );

    // clock 생성
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
*/
    FA_8bit uut(
    .a_in(buttons_a),
    .b_in(buttons_b),
    .c_in(1'b0),
    .sum_out(segment_display),
    .c_out(c_out_seg)
    
    );

    // 테스트
    initial begin
  //      rst = 1;
      /*  buttons_a = 8'd0;
        buttons_b = 8'd0;
        i = 8'h0;
        j = 8'h0;
        */
        #20;
    //    rst = 0;

        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                buttons_a = i;
                buttons_b = j;
                #10;
            end
        end

        #100000;
        $finish;
    end

endmodule