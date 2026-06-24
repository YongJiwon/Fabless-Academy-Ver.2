`timescale 1ns/1ps

module tb_spi_loopback;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic start = 1'b0;
    logic [7:0] master_tx = 8'h00;
    logic [7:0] master_rx;
    logic master_busy;
    logic master_done;
    logic sclk;
    logic mosi;
    logic miso;
    logic cs_n;
    logic [7:0] slave_tx = 8'h00;
    logic [7:0] slave_rx;
    logic slave_rx_valid;
    logic slave_seen_valid;

    // 반복 횟수 정의 (16회)
    localparam int LOOP_COUNT = 160;
    int i;

    // 시뮬레이션 타임아웃 방지용 변수
    logic watchdog_clear;

    always #5 clk = ~clk;

    // slave_rx_valid 감지 로직 (매 회차 검증 후 clear 구조로 변경)
    always @(posedge slave_rx_valid or negedge rst_n) begin
        if (!rst_n) begin
            slave_seen_valid <= 1'b0;
        end else begin
            slave_seen_valid <= 1'b1;
        end
    end

    // SPI Master 인스턴스
    spi_master #(
        .CLK_DIV(2),
        .CPOL(1'b0),
        .CPHA(1'b0)
    ) dut_master (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_data(master_tx),
        .rx_data(master_rx),
        .busy(master_busy),
        .done(master_done),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .cs_n(cs_n)
    );

    // SPI Slave 인스턴스
    spi_slave #(
        .CPOL(1'b0),
        .CPHA(1'b0)
    ) dut_slave (
        .rst_n(rst_n),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .cs_n(cs_n),
        .tx_data(slave_tx),
        .rx_data(slave_rx),
        .rx_valid(slave_rx_valid)
    );

    // Watchdog Timer: 로직이 hang 상태(무한 루프)에 빠지는 것을 방지
    initial begin
        watchdog_clear = 1'b0;
        forever begin
            #5000; // 각 송수신당 최대 제한 시간
            if (!watchdog_clear) begin
                $fatal(1, "[TIMEOUT] SPI 통신이 지정된 시간 내에 완료되지 않았습니다. 로직 고착 의심.");
            end
            watchdog_clear = 1'b0;
        end
    end

    // Main Test Sequence
    initial begin
        // 하드웨어 리셋
        rst_n = 1'b0;
        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        $display("==================================================");
        $display("  시작: %0d회 연속 SPI 루프백 테스트", LOOP_COUNT);
        $display("==================================================");

        for (i = 0; i < LOOP_COUNT; i = i + 1) begin
            // 1. 매 회차마다 무작위 데이터 생성 (00~FF)
            master_tx = $urandom_range(8'h00, 8'hFF);
            slave_tx  = $urandom_range(8'h00, 8'hFF);
            
            // slave_seen_valid 검증용 플래그 수동 초기화 효과
            // (강제 할당 해제 후 플래그 모니터링을 위해 다음 클락에서 안정화)
            if (i > 0) begin
                force slave_seen_valid = 1'b0;
                @(posedge clk);
                release slave_seen_valid;
            end

            // 2. 송신 시작 신호 인가
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            // 3. Master Done 신호 대기
            wait (master_done);
            watchdog_clear = 1'b1; // 워치독 클리어
            
            // 데이터 래치 안정화를 위해 1클락 대기
            @(posedge clk);

            // 4. 데이터 검증 (Assertion)
            assert (master_rx == slave_tx)
                else $fatal(1, "[에러] [%0d회차] master_rx=%02h (예상값 slave_tx=%02h)", i+1, master_rx, slave_tx);
            
            assert (slave_seen_valid)
                else $fatal(1, "[에러] [%0d회차] slave rx_valid 신호가 발생하지 않았습니다.", i+1);
            
            assert (slave_rx == master_tx)
                else $fatal(1, "[에러] [%0d회차] slave_rx=%02h (예상값 master_tx=%02h)", i+1, slave_rx, master_tx);

            $display("[%02d회차 성공] Master TX:%02h -> Slave RX:%02h | Slave TX:%02h -> Master RX:%02h", 
                     i+1, master_tx, slave_rx, slave_tx, master_rx);

            // 5. 연속 전송 사이의 유휴 상태(Idle Space) 확보 (선택 사항)
            // 마스터 내부 상태 머신이 완전히 IDLE로 돌아갈 시간을 확보합니다.
            repeat (3) @(posedge clk);
        end

        $display("==================================================");
        $display("  검증 완료: %0d회 연속 통신 정상 동작 확인", LOOP_COUNT);
        $display("==================================================");
        $stop;
        $finish;
    end
endmodule