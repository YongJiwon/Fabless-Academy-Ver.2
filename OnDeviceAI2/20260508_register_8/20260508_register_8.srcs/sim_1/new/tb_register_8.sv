`timescale 1ns / 1ps

interface reg_interface;
    logic       clk;
    logic       rst;
    logic [7:0] d;
    logic [7:0] q;
endinterface  //reg_interface

class transction;
    rand bit [7:0] d;
    bit [7:0] q;

    function void debug_print(string name);
        $display("%t : [%s] d= %d, q = %d", $time, name,d, q);
    endfunction

endclass
//*************************************************************************generator
class generator;
    transction tr;
    mailbox #(transction) gen2drv_mbox;
    event event_gen_next;
    function new(mailbox#(transction) gen2drv_mbox, event event_gen_next);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.event_gen_next = event_gen_next;

    endfunction

    task run(int count);
        repeat (count) begin
            tr = new;
            tr.randomize();
            tr.debug_print("GEN");
            #1;
            gen2drv_mbox.put(tr);
            @(event_gen_next);
        end
    endtask

endclass
//************************************************************************* driver
class driver;
    transction tr;
    mailbox #(transction) gen2drv_mbox;
    event event_mon_next;
    virtual reg_interface reg_vif;

    function new(mailbox#(transction) gen2drv_mbox, event event_mon_next,
                 virtual reg_interface reg_vif);
        this.gen2drv_mbox = gen2drv_mbox;
        this.event_mon_next = event_mon_next;
        this.reg_vif = reg_vif;
    endfunction

    task preset;
        reg_vif.rst = 1;
        repeat (2)@(posedge reg_vif.clk);
        reg_vif.rst = 0;
    endtask

    task run();
    forever begin
        @(posedge reg_vif.clk);
        #1;
        gen2drv_mbox.get(tr);
        reg_vif.d = tr.d;
        tr.debug_print("DRV");
        //#5; 여기 왜 5나노세크는 안되는지 찾아볼것
    
        @(negedge reg_vif.clk);
        -> event_mon_next;  //위에 있으면 1나노 끝나자마자 바로 발생함.
    end
    
endtask //run
endclass
//*************************************************************************monitor
class monitor;
    transction tr;
    mailbox #(transction) mon2scb_mbox;
    event event_mon_next;
    virtual reg_interface reg_vif;

    function new(mailbox#(transction) mon2scb_mbox, event event_mon_next,
                 virtual reg_interface reg_vif);
        this.mon2scb_mbox = mon2scb_mbox;
        this.event_mon_next = event_mon_next;
        this.reg_vif = reg_vif;
    endfunction

    task run();
        forever begin
            @(event_mon_next);
            @(posedge reg_vif.clk);
            tr = new;
            tr.d = reg_vif.d;
            #1;
            tr.q = reg_vif.q;
            tr.debug_print("MON");
            mon2scb_mbox.put(tr);
            
        end
    endtask

endclass
//*************************************************************************scoreboard
class scoreboard;
    transction tr;
    mailbox #(transction) mon2scb_mbox;
    event event_gen_next;

    int total_cnt = 0, pass_cnt = 0, fail_cnt = 0;



    function new(mailbox#(transction) mon2scb_mbox, event event_gen_next);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.event_gen_next = event_gen_next;

    endfunction

    task run(int count);
        forever begin

            mon2scb_mbox.get(tr);
            tr.debug_print();
            if (tr.d == tr.q) begin
               $display("%t : PASS !!", $time);
            end else begin
               $display("%t : FAIL !! d = %d, q = %d", $time,tr.d, tr.q);
            end
            -> event_gen_next;
        end 
    endtask
endclass
//*************************************************************************enviroment
class environment;
    generator             gen;
    driver                drv;
    monitor               mon;
    scoreboard            scb;
    virtual reg_interface reg_vif;

    mailbox #(transction) gen2drv_mbox;
    mailbox #(transction) mon2scb_mbox;

    event                 event_gen_next;
    event                 event_mon_next;

    function new(virtual reg_interface reg_vif);
        gen2drv_mbox = new;
        mon2scb_mbox = new;
        gen = new(gen2drv_mbox, event_gen_next);
        drv = new(gen2drv_mbox, event_mon_next, reg_vif);
        mon = new(mon2scb_mbox, event_mon_next, reg_vif);
        scb = new(mon2scb_mbox, event_gen_next);

    endfunction


    
    task run();
        drv.preset();
        fork
            gen.run(100);
            drv.run();
            mon.run();
            scb.run();
        join_any
        $display("&t : ENV fork join_any end", $time);
        #20;
        $display("_______________________________");
        $display("** Register 8bit verification**");
        $display("**** Total test number = %4d **",scb.total_cnt);
        $display("**** Pass test number = %4d **",scb.pass_cnt);
        $display("**** Fail test number = %4d **",scb.fail_cnt);
        $display("******************************");
        
        
        $stop;
    endtask

endclass

module tb_register_8;
    reg_interface reg_if;
    
    environment   env;

    register_8bit dut (
        .clk(reg_if.clk),
        .rst(reg_if.rst),
        .d  (reg_if.d),
        .q  (reg_if.q)
    );

    //clk생성
    always #5 reg_if.clk = ~reg_if.clk;

    initial begin
        reg_if.clk = 0;
        env = new(reg_if);
        env.run();
    end

endmodule
