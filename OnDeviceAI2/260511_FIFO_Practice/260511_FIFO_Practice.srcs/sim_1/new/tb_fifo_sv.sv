`timescale 1ns / 1ps

// 1. 오타 수정: trasaction -> transaction
class transaction;
    rand bit [7:0] push_datah;
    rand bit push;
    rand bit [7:0] pop_data;
    rand bit pop;
    bit rst_n;
    bit full;
    bit empty;



    function void debug_print(string name); // void 추가
        $display("%t : [%s] addr = %d, wdata = %d, we = %d, rdata = %d", $time, name, addr, wdata, we, rdata);
    endfunction
endclass

interface ram_interface;
    logic clk;
    logic [7:0] addr;
    logic [7:0] wdata;
    logic we;
    logic [7:0] rdata;
endinterface

class generator;
    transaction tr; // 오타 수정
    mailbox #(transaction) gen2drv_mbox;
    event event_gen_next;

    function new(mailbox#(transaction) gen2drv_mbox, event event_gen_next);
        this.gen2drv_mbox = gen2drv_mbox;
        this.event_gen_next = event_gen_next;
    endfunction

    task run(int count);
        repeat (count) begin
            tr = new();
            assert (tr.randomize()) 
            else   $error("[GEN] tr.randomize() error!");
            gen2drv_mbox.put(tr);
            tr.debug_print("GEN");
            @(event_gen_next);
        end
    endtask
endclass

// 2. 오타 수정: dirver -> driver
class driver;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    virtual ram_interface ram_if;

    function new(mailbox#(transaction) gen2drv_mbox, virtual ram_interface ram_if);
        this.gen2drv_mbox = gen2drv_mbox;
        this.ram_if = ram_if;        
    endfunction

    task preset(); //하다 말았음
        ram_vif.rst_n =1;
        ram_vif.clk =1;
    endtask //automatic


    task run();
        // Driver는 보통 여러 번 실행되어야 하므로 forever 추가가 일반적입니다.
        forever begin 
            gen2drv_mbox.get(tr);
            tr.debug_print("DRV");
            @(posedge ram_if.clk);
            #1;
            //ram_if.addr = tr.addr;
            //ram_if.wdata = tr.wdata;
            //ram_if.we = tr.we;
        end
    endtask
endclass

class monitor;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    virtual ram_interface ram_vif;

    function new(mailbox#(transaction) mon2scb_mbox, virtual ram_interface ram_vif);
        this.mon2scb_mbox = mon2scb_mbox;
        this.ram_vif = ram_vif;
    endfunction

    task run();
        forever begin
            @(posedge ram_vif.clk); // ram_vif -> ram_if 오타 수정
            //#1; // DUT 결과가 나올 때까지 약간 대기
            tr = new();
            tr.addr = ram_vif.addr;
            tr.wdata = ram_vif.wdata;
            tr.we = ram_vif.we;
            tr.rdata = ram_vif.rdata;
            mon2scb_mbox.put(tr);
            tr.debug_print("MON");
        end
    endtask
endclass

class scoreboard;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    event event_gen_next;
    int total_cnt = 0, pass_cnt = 0, fail_cnt = 0;


    byte mem[256];
    function new(mailbox #(transaction) mon2scb_mbox, event event_gen_next);
        this.mon2scb_mbox = mon2scb_mbox;
        this.event_gen_next = event_gen_next;
    endfunction

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            tr.debug_print("SCB");
            total_cnt++;
            if (tr.we) begin //write scenario
                mem[tr.addr] = tr.wdata; //값을 바로 받아가서 타이밍 이슈가 발생할 수 조차 없는 상황 ㅋㅋㅋ 당연히 pass밖에 안 뜨지
            end else begin //read scenario
                if (tr.rdata == mem[tr.addr]) begin
                    pass_cnt++;
                    $display("%t : PASS", $time);
                end else begin
                    fail_cnt++;
                    $display("%t : FAIL addr = %d, rdata = %d, we = %d, wdata = %d, mem[addr] = %d", 
                    $time, tr.addr, tr.rdata, tr.we, tr.wdata, mem[tr.addr]);
                
                end
                
            end
            -> event_gen_next;
        end
    endtask
endclass

class environment;
    generator gen;
    driver    drv;
    monitor   mon;
    scoreboard scb;

    // Mailbox와 Event 선언 누락 수정
    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;
    event event_gen_next;

    function new(virtual ram_interface ram_vif);
        gen2drv_mbox = new();
        mon2scb_mbox = new();
        gen = new(gen2drv_mbox, event_gen_next);
        drv = new(gen2drv_mbox, ram_vif);
        mon = new(mon2scb_mbox, ram_vif);
        scb = new(mon2scb_mbox, event_gen_next);
    endfunction

    task run();
        fork
            gen.run(40);
            drv.run();
            mon.run();
            scb.run();
        join_any
        #10;
        $display("env run task end");
        $display("____________________________");
        $display("** SRAM IP Verification **");
        $display("** total test run num = %d **",scb.total_cnt);
        $display("** pass num = %d **",scb.pass_cnt);
        $display("** fail num = %d **",scb.fail_cnt);
        $display("*****************************");
        $stop;
    endtask
endclass

module tb_fifo_sv();
    ram_interface ram_if();
    
    // DUT 연결 시 모듈 이름 확인 (ram_ip라고 가정)
    ram_ip dut(
        .clk(ram_if.clk),
        .addr(ram_if.addr),
        .wdata(ram_if.wdata),
        .we(ram_if.we),
        .rdata(ram_if.rdata)
    );

    // clk 선언 위치 수정
    always #5 ram_if.clk = ~ram_if.clk;

    environment env;

    initial begin
        ram_if.clk = 0;
        env = new(ram_if);
        env.run();
    end
endmodule