`timescale 1ns / 1ps

interface i2c_intf;
    logic       clk;
    logic       reset_n;
    logic       start;
    logic [6:0] slave_addr;
    logic [7:0] data_in;
    logic       busy;
    logic       done;
    logic       ack_error;
    logic [7:0] data_out;
    logic       data_valid;
    wire        sda;
    wire        scl;
endinterface //i2c_intf

package i2c_uvm_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `uvm_analysis_imp_decl(_expected)
    `uvm_analysis_imp_decl(_actual)

    class transaction extends uvm_sequence_item;
        rand logic [6:0] slave_addr;
        rand logic [7:0] data_in;
        logic [7:0] data_out;
        logic       ack_error;

        constraint addr_c { slave_addr == 7'h42; }
        constraint data_c { data_in == 8'hA5; }

        `uvm_object_utils_begin(transaction)
            `uvm_field_int(slave_addr, UVM_ALL_ON)
            `uvm_field_int(data_in,    UVM_ALL_ON)
            `uvm_field_int(data_out,   UVM_ALL_ON)
            `uvm_field_int(ack_error,  UVM_ALL_ON)
        `uvm_object_utils_end

        function new(string name = "transaction");
            super.new(name);
        endfunction //new()
    endclass //transaction

    class i2c_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(i2c_sequence)

        function new(string name = "i2c_sequence");
            super.new(name);
        endfunction //new()

        virtual task body();
            transaction tr;

            tr = transaction::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize()) begin
                `uvm_fatal("RAND_FAIL", "transaction randomize failed")
            end
            finish_item(tr);
        endtask
    endclass //i2c_sequence

    class i2c_sequencer extends uvm_sequencer #(transaction);
        `uvm_component_utils(i2c_sequencer)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()
    endclass //i2c_sequencer

    class driver extends uvm_driver #(transaction);
        `uvm_component_utils(driver)

        virtual i2c_intf i2c_if;
        uvm_analysis_port #(transaction) expected_port;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            expected_port = new("expected_port", this);
        endfunction //new()

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(virtual i2c_intf)::get(this, "", "i2c_if", i2c_if)) begin
                `uvm_fatal("NO_INTF", "i2c_if config is missing")
            end
        endfunction

        virtual task run_phase(uvm_phase phase);
            transaction tr;

            i2c_if.start      <= 1'b0;
            i2c_if.slave_addr <= 7'h00;
            i2c_if.data_in    <= 8'h00;

            @(posedge i2c_if.reset_n);
            repeat (5) @(posedge i2c_if.clk);

            forever begin
                seq_item_port.get_next_item(tr);
                expected_port.write(tr);
                write(tr);
                seq_item_port.item_done();
            end
        endtask

        task write(transaction tr);
            i2c_if.slave_addr <= tr.slave_addr;
            i2c_if.data_in    <= tr.data_in;

            @(posedge i2c_if.clk);
            i2c_if.start <= 1'b1;
            @(posedge i2c_if.clk);
            i2c_if.start <= 1'b0;

            wait (i2c_if.busy == 1'b1);
            wait (i2c_if.done == 1'b1);
            tr.ack_error = i2c_if.ack_error;

            if (tr.ack_error) begin
                `uvm_error("ACK_ERROR", "master ack_error is asserted")
            end

            `uvm_info("WRITE", $sformatf("slave_addr : %0h, data_in : %0h", tr.slave_addr, tr.data_in), UVM_MEDIUM)
        endtask
    endclass //driver

    class monitor extends uvm_component;
        `uvm_component_utils(monitor)

        virtual i2c_intf i2c_if;
        uvm_analysis_port #(transaction) actual_port;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            actual_port = new("actual_port", this);
        endfunction //new()

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(virtual i2c_intf)::get(this, "", "i2c_if", i2c_if)) begin
                `uvm_fatal("NO_INTF", "i2c_if config is missing")
            end
        endfunction

        virtual task run_phase(uvm_phase phase);
            transaction tr;

            forever begin
                @(posedge i2c_if.clk);
                if (i2c_if.data_valid) begin
                    tr = transaction::type_id::create("tr", this);
                    tr.slave_addr = i2c_if.slave_addr;
                    tr.data_out   = i2c_if.data_out;
                    tr.ack_error  = i2c_if.ack_error;
                    actual_port.write(tr);
                    `uvm_info("READ", $sformatf("data_out : %0h", tr.data_out), UVM_MEDIUM)
                end
            end
        endtask
    endclass //monitor

    class scoreboard extends uvm_component;
        `uvm_component_utils(scoreboard)

        uvm_analysis_imp_expected #(transaction, scoreboard) expected_export;
        uvm_analysis_imp_actual   #(transaction, scoreboard) actual_export;

        transaction tr_q[$];
        int pass, fail;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            expected_export = new("expected_export", this);
            actual_export   = new("actual_export", this);
            pass = 0;
            fail = 0;
        endfunction //new()

        function void write_expected(transaction tr);
            transaction tr_copy;

            tr_copy = transaction::type_id::create("tr_copy", this);
            tr_copy.copy(tr);
            tr_q.push_back(tr_copy);
        endfunction

        function void write_actual(transaction tr);
            transaction exp;

            if (tr_q.size() == 0) begin
                fail++;
                `uvm_error("FAIL", $sformatf("unexpected data_out : %0h", tr.data_out))
            end else begin
                exp = tr_q.pop_front();
                if ((exp.data_in != tr.data_out) || tr.ack_error) begin
                    fail++;
                    `uvm_error("FAIL", $sformatf("data_in : %0h, data_out : %0h, ack_error : %0b", exp.data_in, tr.data_out, tr.ack_error))
                end else begin
                    pass++;
                    `uvm_info("PASS", $sformatf("data_in : %0h, data_out : %0h", exp.data_in, tr.data_out), UVM_LOW)
                end
            end
        endfunction

        virtual function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            if (tr_q.size() != 0) begin
                fail += tr_q.size();
                `uvm_error("FAIL", $sformatf("remain expected transaction count : %0d", tr_q.size()))
            end
            if (pass == 0) begin
                `uvm_error("FAIL", "no pass transaction")
            end
        endfunction

        virtual function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("REPORT", $sformatf("pass count : %0d", pass), UVM_NONE)
            `uvm_info("REPORT", $sformatf("fail count : %0d", fail), UVM_NONE)
            `uvm_info("REPORT", $sformatf("total test count : %0d", pass + fail), UVM_NONE)
        endfunction
    endclass //scoreboard

    class agent extends uvm_agent;
        `uvm_component_utils(agent)

        i2c_sequencer seqr;
        driver        drv;
        monitor       mon;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            seqr = i2c_sequencer::type_id::create("seqr", this);
            drv  = driver::type_id::create("drv", this);
            mon  = monitor::type_id::create("mon", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.seq_item_port.connect(seqr.seq_item_export);
        endfunction
    endclass //agent

    class env extends uvm_env;
        `uvm_component_utils(env)

        agent      agt;
        scoreboard scb;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt = agent::type_id::create("agt", this);
            scb = scoreboard::type_id::create("scb", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.drv.expected_port.connect(scb.expected_export);
            agt.mon.actual_port.connect(scb.actual_export);
        endfunction
    endclass //env

    class test extends uvm_test;
        `uvm_component_utils(test)

        env          e;
        i2c_sequence seq;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            e = env::type_id::create("e", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            seq = i2c_sequence::type_id::create("seq");
            seq.start(e.agt.seqr);
            repeat (100) @(posedge e.agt.drv.i2c_if.clk);
            phase.drop_objection(this);
        endtask
    endclass //test
endpackage //i2c_uvm_pkg

import uvm_pkg::*;
`include "uvm_macros.svh"
import i2c_uvm_pkg::*;

module tb_i2c_uvm();
    i2c_intf i2c_if();

    pullup(i2c_if.sda);

    I2C_Master #(
        .CLK_DIV(20)
    ) U_I2C_MASTER(
        .clk(i2c_if.clk),
        .reset_n(i2c_if.reset_n),
        .start(i2c_if.start),
        .slave_addr(i2c_if.slave_addr),
        .data_in(i2c_if.data_in),
        .busy(i2c_if.busy),
        .done(i2c_if.done),
        .ack_error(i2c_if.ack_error),
        .sda(i2c_if.sda),
        .scl(i2c_if.scl)
    );

    I2C_Salve #(
        .SLAVE_ADDR(7'h42)
    ) U_I2C_SALVE(
        .clk(i2c_if.clk),
        .reset_n(i2c_if.reset_n),
        .data_out(i2c_if.data_out),
        .data_valid(i2c_if.data_valid),
        .sda(i2c_if.sda),
        .scl(i2c_if.scl)
    );

    always #5 i2c_if.clk = ~i2c_if.clk;

    initial begin
        i2c_if.clk        = 1'b0;
        i2c_if.reset_n    = 1'b0;
        i2c_if.start      = 1'b0;
        i2c_if.slave_addr = 7'h00;
        i2c_if.data_in    = 8'h00;
        repeat (5) @(posedge i2c_if.clk);
        i2c_if.reset_n = 1'b1;
    end

    initial begin
        $dumpfile("tb_i2c_uvm.vcd");
        $dumpvars(0, tb_i2c_uvm);
    end

    initial begin
        uvm_config_db #(virtual i2c_intf)::set(null, "uvm_test_top.e.agt.*", "i2c_if", i2c_if);
        run_test("test");
    end
endmodule
