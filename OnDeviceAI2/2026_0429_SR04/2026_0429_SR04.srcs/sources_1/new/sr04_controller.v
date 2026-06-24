`timescale 1ns / 1ps

module TOP_sr04_controller(
    input clk,
    input rst,
    input btn_R,       // 시작 버튼
    input echo,        // 초음파 Echo
    output trig,       // 초음파 Trig
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    // 내부 연결을 위한 와이어 선언
    wire w_tick_us;
    wire [8:0] w_dist;
    wire [3:0] d1, d10, d100; // 자릿수 데이터
    wire w_btn_db;

    // 1. 버튼 디바운스 (목록에 있는 button_debounce 활용)
    button_debounce U_BTN_DB (
        .clk(clk), .rst(rst), .i_btn(btn_R), .o_btn(w_btn_db)
    );

    // 2. 1us Tick 생성기 (로직 수정됨)
    tick_gen_us U_TICK (
        .clk(clk), .rst(rst), .tick_us(w_tick_us)
    );

    // 3. 초음파 센서 제어 모듈
    sr04 U_SR04 (
        .clk(clk), .rst(rst),
        .u_tick(w_tick_us),
        .sr04_start(w_btn_db),
        .echo(echo),
        .trig(trig),
        .dist(w_dist)
    );

    // 4. 자릿수 분리 (9비트 대응)
    digit_splitter #(.DATA_BIT(9)) U_SPLIT (
        .digit_data(w_dist),
        .digit_ones(d1),
        .digit_tens(d10),
        .digit_hundreds(d100)
    );

    // 5. FND 컨트롤러 (지원님 프로젝트 내 FND_Controller 구조 반영)
    // FND_Controller의 포트 구성에 맞춰 bcd 데이터 전달
    FND_Controller U_FND (
        .clk(clk),
        .rst_n(~rst),
        .msec({4'd0, 4'd0}), // 밀리초 미사용 시 0
        .sec({d10, d1}),     // 초 자리에 십/일의 자리 표시
        .min({4'd0, d100}),  // 분 자리에 백의 자리 표시
        .hour(8'd0),
        .time_unit_sel(1'b0), // 표시할 모드 선택 (분/초 영역 사용)
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );

endmodule

// 로직이 수정된 1us 생성기
module tick_gen_us(
    input clk,
    input rst,
    output reg tick_us
);
    parameter F_COUNT = 100; // 100MHz / 1MHz = 100
    reg [6:0] counter_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_reg <= 0;
            tick_us <= 1'b0;
        end else begin
            if (counter_reg == F_COUNT - 1) begin
                counter_reg <= 0;
                tick_us <= 1'b1;
            end else begin
                counter_reg <= counter_reg + 1;
                tick_us <= 1'b0;
            end
        end
    end
endmodule

module sr04_controller( //하위 모듈
    input clk,
    input rst,
    input sr04_start,
    input tick_us,
    input echo,
    output trig,
    output [8:0] distance
);
endmodule