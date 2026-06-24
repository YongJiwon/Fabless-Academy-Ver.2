`timescale 1ns / 1ps
module tb_cpu0 ();
    
    logic clk = 0;
    logic rst_n = 0;

    always #5 clk = ~clk; // 100MHz 클록 생성

    // 인터페이스 인스턴스
    cpu_if vif(clk);
    
    // 환경 클래스 핸들
    cpu_env env;

    // DUT 인스턴스 (수정된 data_path 기준)
    data_path dut (
        .clk      (clk),
        .rst    (vif.rst_n),
        .asrc_sel (vif.asrc_sel),
        .areg_load(vif.areg_load),
        .out_sel  (vif.out_sel),
        .eq9      (vif.eq9),
        .out      (vif.out)
    );

    initial begin
        env = new(vif);
        env.run_test();
    end

endmodule

/*
// 1. Interface 정의 (신호 연결 간소화)
interface cpu_if (input logic clk);
    logic rst_n;
    logic asrc_sel;
    logic areg_load;
    logic out_sel;
    logic [7:0] out;
    logic eq9;
endinterface

// 2. Environment 클래스 (Driver + Monitor + Scoreboard 통합)
class cpu_env;
    virtual cpu_if vif;

    function new(virtual cpu_if vif);
        this.vif = vif;
    endfunction

    // 리셋 구동 태스크
    task preset();
        vif.rst_n = 0;
        vif.asrc_sel = 0;
        vif.areg_load = 0;
        vif.out_sel = 0;
        @(posedge vif.clk);
        vif.rst_n = 1;
        $display("[%0t] [ENV] Reset Complete", $time);
    endtask

    // 제어 신호 인가 태스크 (1 Cycle 명령어 실행 모사)
    task drive_ctrl(bit asrc, bit load);
        @(posedge vif.clk);
        
        vif.asrc_sel = asrc;
        vif.areg_load = load;
    endtask

    // 메인 테스트 시나리오
    task run_test();
        preset();
        $display("========================================");
        $display("[%0t] [ENV] CPU Datapath Test Start", $time);
        
        // Step 1: MUX num0(0) 선택 후 A_REG에 로드 (초기화)
        drive_ctrl(1'b0, 1'b1);
        @(posedge vif.clk);
        $display("[%0t] [CHK] Init A_REG. out = %0d", $time, vif.out);

        // Step 2: MUX alu_in 선택 후 A_REG 반복 로드 (카운팅 동작)
        for (int i = 0; i < 11; i++) begin
            drive_ctrl(1'b1, 1'b1);
            @(posedge vif.clk); // 연산 및 레지스터 반영 대기
            
            
            $display("[%0t] [CHK] asrc: 1, load: 1 | out: %2d | eq9: %b", 
                     $time, vif.out, vif.eq9);

            if (vif.eq9) begin
                $display("[%0t] [SCB] PASS: eq9 signal asserted at out = 9!", $time);
            end
        end

        $display("[%0t] [ENV] CPU Datapath Test End", $time);
        $display("========================================");
        $finish;
    endtask
endclass

// 3. Testbench Top 모듈
module tb_cpu0 ();
    
    logic clk = 0;
    always #5 clk = ~clk; // 100MHz 클록 생성

    // 인터페이스 인스턴스
    cpu_if vif(clk);
    
    // 환경 클래스 핸들
    cpu_env env;

    // DUT 인스턴스 (수정된 data_path 기준)
    data_path dut (
        .clk      (clk),
        .rst_n    (vif.rst_n),
        .asrc_sel (vif.asrc_sel),
        .areg_load(vif.areg_load),
        .out_sel  (vif.out_sel),
        .eq9      (vif.eq9),
        .out      (vif.out)
    );

    initial begin
        env = new(vif);
        env.run_test();
    end

endmodule

*/