`timescale 1ns / 1ps

class transaction;

    rand bit [7:0] a;
    rand bit [7:0] b;
    rand bit       mode;
    bit      [7:0] s;
    bit            c;

    function debug_print(string  name);
        $display("time : %t name = %s   a = %d   b = %d  mode = %d  s = %d  c = %d", $time, name, a, b, mode, s, c);      
    endfunction

    constraint  in_range{
        a inside {[0:127]};
    }
    constraint  mode_distribute{
        mode dist {0:/90, 1:/10};
    }
    constraint in_b{
        b inside {0,1,2,3,15,31,250};
    };


endclass


interface adder_interface();
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] e;

endinterface //interfacename

class generator;
    
    transaction tr;
    mailbox # (transaction) gen2drv_mbox;
    event event_gen_next;
        function new(mailbox # (transaction) gen2drv_mbox);
            this.gen2drv_mbox = gen2drv_mbox;
            this.event_gen_next = event_gen_next;
        endfunction

    task run(int count);
        repeat(count) begin
            tr = new();
            tr.randomize();
            tr.debug_print("GEN");
            gen2drv_mbox.put(tr);    
            @(event_gen_next);
        end
        $display("GEB end task");
    endtask
endclass




class driver;
    transaction tr;
    virtual adder_interface adder_vif;
    mailbox #(transaction) drv2gen_mbox;
    event event_drv_next;
    
    function new(mailbox #(transaction) drv2gen_mbox );
        //
    endfunction //new()

    task run(int count);
        fork
            gen.run(20);
            drv.run();
        join_any
        $display("ENV fork join any end");
    endtask
endclass



module tb_alu_sv();
    adder_interface adder_if();
    environment env;
    
endmodule




class scoreboard;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;    
    int total_cnt, pass_cnt, fail_cnt;

    function new();
        this.mon2scb_mbox = mon2scb_mbox;
    endfunction

    task run();
        bit [7:0] expected_sum;
        bit expected_carry;

        forever begin
            mon2scb_mbox.get(tr);
            tr.debug_print("SCB");
            total_cnt++;
            if (tr.mode) begin
                {expected_carry, expected_sum} = tr.a - tr.b;
            end else begin
                {expected_carry, expected_sum} = tr.a + tr.b;
            end
            if((tr.s == expected_sum) && (tr.c == expected_carry)) begin
                $display("%t, [pass] !!",$time);
                pass_cnt++;
            end else begin
                $display("%t, [fail] !! mode = %d, a = %d, b = %d, s = %d, c = %d,sum = %d, carry = %d",
                            $time, tr.mode, tr.a, tr.b, tr.s, tr.c, expected_sum, expected_carry);
                fail_cnt++;
            end
        end

    endtask
endclass



class monitor;
    function new();
        //
    endfunction
endclass


class environment;
    generator gen;
    scoreboard scb;
    monitor mon;
    driver drv;
    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) drv2gen_mbox;
    event event_gen_next;
    
    

    
    function new(virtual adder_interface adder_vif);
        gen2drv_mbox = new;
        mon2scb_mbox = new;
        gen = new(gen2drv_mbox, event_gen_next);
        drv = new(gen2drv_mbox, event_gen_next, adder_vif);
        mon = new(mon2scb_mbox,adder_vif);
        scb = new(mon2scb_mbox);
    endfunction


    task run (int count);
        fork
        gen.run(20);
        drv.run();
        mon.run();
        scb.run();

        join_any
        $display("ENV fork join any end");
        $display("______________________");
        

    endtask //run
    
endclass