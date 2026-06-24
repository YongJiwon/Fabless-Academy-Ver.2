`timescale 1ns / 1ps

module fnd_controller (
    input clk,
    input rst,
    input [7:0] fnd_in,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);
    wire [3:0] w_out_mux, w_digit_1, w_digit_10, w_digit_100, w_digit_1000;
    wire [2:0] w_digit_sel;          // 2bit -> 3bit
    wire w_125hz;
    wire [7:0] w_bcd_data;

    // 콜론/DP 패턴 (보드에 따라 수정 필요)
    // active-low 기준으로 "점만 켜기" 후보값
    localparam [7:0] COLON_DATA = 8'h7F;

    digit_splitter U_DIGIT_SPLIT (
        .digit_in  (fnd_in),
        .digit_1   (w_digit_1),
        .digit_10  (w_digit_10),
        .digit_100 (w_digit_100),
        .digit_1000(w_digit_1000)
    );

    // 하위 2비트로만 자리 선택
    mux_8x1 U_MUX_4x1 (
        .in0(w_digit_1),      
        .in1(w_digit_10),     
        .in2(w_digit_100),    
        .in3(w_digit_1000),   
        .in4(4'hf),      
        .in5(4'hf),     
        .in6(),    
        .in7(4'hf),   
        .sel(w_digit_sel[1:0]),
        .out_mux(w_out_mux)
    );

    // 숫자 패턴 생성
    bcd U_BCD (
        .bin(w_out_mux),
        .bcd_data(w_bcd_data)
    );

    // 125Hz 스캔 클럭
    clk_div_125hz U_CLK_DIV_125HZ(
        .clk(clk),
        .rst(rst),
        .o_125hz(w_125hz)
    );

    // 3비트 카운터 : 0~7
    counter_8 U_COUNTER_8 (
        .clk(w_125hz),
        .rst(rst),
        .digit_sel(w_digit_sel)
    );

    // 자리 선택은 하위 2비트만 사용
    decoder_2X4 U_DECODER_2X4 (
        .decoder_in(w_digit_sel[1:0]),
        .fnd_com(fnd_com)
    );

    // 비교기 역할:
    // w_digit_sel[2] == 0 이면 숫자 출력
    // w_digit_sel[2] == 1 이면 콜론(또는 점) 출력
    assign fnd_data = (w_digit_sel[2] == 1'b0) ? w_bcd_data : COLON_DATA;

endmodule


// ============================================================
// 100MHz 입력 기준 125Hz 토글 클럭 생성
// 기존 1kHz 대신 125Hz
// ============================================================
module clk_div_125hz(
    input clk,
    input rst,
    output o_125hz
);

    reg [19:0] counter_reg;
    reg o_125hz_reg;

    assign o_125hz = o_125hz_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_reg <= 20'd0;
            o_125hz_reg <= 1'b0;
        end else begin
            if (counter_reg == (400_000 - 1)) begin
                counter_reg <= 20'd0;
                o_125hz_reg <= ~o_125hz_reg;
            end else begin
                counter_reg <= counter_reg + 1'b1;
            end
        end
    end
endmodule


// ============================================================
// 3비트 카운터 : 0~7
// ============================================================
module counter_8 (
    input clk,
    input rst,
    output [2:0] digit_sel
);

    reg [2:0] counter_reg;

    assign digit_sel = counter_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_reg <= 3'd0;
        end else begin
            counter_reg <= counter_reg + 3'd1;
        end
    end
endmodule


// ============================================================
// 2x4 decoder
// 하위 2비트만 받아서 자리 선택
// ============================================================
module decoder_2X4 (
    input      [1:0] decoder_in,
    output reg [3:0] fnd_com
);

    always @(*) begin
        case (decoder_in)
            2'b00: fnd_com = 4'b1110;
            2'b01: fnd_com = 4'b1101;
            2'b10: fnd_com = 4'b1011;
            2'b11: fnd_com = 4'b0111;
            default: fnd_com = 4'b1111;
        endcase
    end

endmodule


// ============================================================
// 자리 분리
// ============================================================
module digit_splitter (
    input  [7:0] digit_in,
    output [3:0] digit_1,
    output [3:0] digit_10,
    output [3:0] digit_100,
    output [3:0] digit_1000
);

    assign digit_1    = digit_in % 10;
    assign digit_10   = (digit_in / 10) % 10;
    assign digit_100  = (digit_in / 100) % 10;
    assign digit_1000 = (digit_in / 1000) % 10;

endmodule


// ============================================================
// 4x1 mux
// 선택은 하위 2비트
// ============================================================
module mux_8x1 (
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [3:0] in4,
    input [3:0] in5,
    input [3:0] in6,
    input [3:0] in7,
    
    input [2:0] sel,
    output [3:0] out_mux
);
    reg [3:0] out_reg;
    assign out_mux = out_reg;

    always @(*) begin
        case (sel)
            3'b000: out_reg = in0;
            3'b001: out_reg = in1;
            3'b010: out_reg = in2;
            3'b011: out_reg = in3;
            3'b100: out_reg = in4;
            3'b101: out_reg = in5;
            3'b110: out_reg = in6;
            3'b111: out_reg = in7;
            default: out_reg = 4'b0000;
        endcase
    end
endmodule


// ============================================================
// BCD to 7-segment
// ============================================================
module bcd (
    input [3:0] bin,
    output reg [7:0] bcd_data
);

    always @(*) begin
        case(bin)
            4'b0000: bcd_data = 8'hC0;
            4'b0001: bcd_data = 8'hF9;
            4'b0010: bcd_data = 8'hA4;
            4'b0011: bcd_data = 8'hB0;
            4'b0100: bcd_data = 8'h99;
            4'b0101: bcd_data = 8'h92;
            4'b0110: bcd_data = 8'h82;
            4'b0111: bcd_data = 8'hF8;
            4'b1000: bcd_data = 8'h80;
            4'b1001: bcd_data = 8'h90;
            4'b1010: bcd_data = 8'h88;
            4'b1011: bcd_data = 8'h83;
            4'b1100: bcd_data = 8'hC6;
            4'b1101: bcd_data = 8'hA1;
            4'b1110: bcd_data = 8'h7F;  //dot on
            4'b1111: bcd_data = 8'hFF;  //all off
            default: bcd_data = 8'hFF;
        endcase
    end
endmodule 