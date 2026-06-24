`timescale 1ns / 1ps

interface ram_intf;
    logic clk;
    logic we;
    logic [7:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;
endinterface //ram_intf

class transaction;
    rand logic [7:0] addr;
    rand logic [7:0] wdata;
    logic [7:0] rdata;
endclass //transaction



class tester;
    transaction tr;
    virtual ram_intf ram_if;
    
    function new(virtual ram_intf ram_if);
        this.ram_if = ram_if; 
        this.tr = new(); 
    endfunction //new()

    
    task write();
        ram_if.addr  = tr.addr;
        ram_if.wdata = tr.wdata;
        ram_if.we    = 1;
        @(posedge ram_if.clk);
        $display("[WRITE] we : %0h, addr : %0h, wdata : %0h", ram_if.we, ram_if.addr, ram_if.wdata);
    endtask

    task read();
        ram_if.addr  = tr.addr;
        ram_if.we    = 0;
        @(posedge ram_if.clk);
        tr.rdata = ram_if.rdata;
        
        $display("[READ]  we : %0h, addr : %0h, rdata : %0h", ram_if.we, ram_if.addr, ram_if.rdata);
    endtask

    


    virtual function result();
        if(tr.wdata != tr.rdata) begin
            $display("[Fail!] wdata : %0h, rdata : %0h", tr.wdata, tr.rdata);
        end else begin
            $display("[Pass!] wdata : %0h, rdata : %0h", tr.wdata, tr.rdata);
        end
    endfunction

    virtual task test_run(int loop);
        begin
            repeat (loop) begin
                tr.randomize();
                write();
                read();
                result();
            end
        end
    endtask

endclass //tester


class tester_child extends tester; //부모 클래스의 기능을 포함하겠다.
    int pass, fail;

    function new(virtual ram_intf ram_if);
        super.new(ram_if); //super는 부모 클래스를 의미
        pass = 0;
        fail = 0;
    endfunction //new()

    virtual function result(); //virtual == 자식 클래스에서 재정의 할 수 있다. tlqkf 오버라이드
        if(tr.wdata != tr.rdata) begin
            $display("[Fail!] wdata : %0h, rdata : %0h", tr.wdata, tr.rdata);
            fail++;
        end else begin
            $display("[Pass!] wdata : %0h, rdata : %0h", tr.wdata, tr.rdata);
            pass++;
        end
    endfunction

    function report();
        $diplay("pass count : %d", pass);
        $diplay("fail count : %d", fail);
        $diplay("total test count : %d", pass + fail);
        
    endfunction

    virtual task test_run(int loop);
        repeat (loop) begin
            tr.randomize();
            write();
            read();
            result();
        end
        report(); //재정의
    endtask
endclass // extends tester;


module tb_ram();

    ram_intf ram_if();

    ram U_RAM(
        .clk(ram_if.clk),
        .we(ram_if.we),       
        .addr(ram_if.addr),   
        .wdata(ram_if.wdata), 
        .rdata(ram_if.rdata)  
    );

    tester_child test1;
    
    always #5 ram_if.clk = ~ram_if.clk;
    
    initial begin
        ram_if.clk   = 1'b0;
        ram_if.addr  = 0;
        ram_if.wdata = 0;
        ram_if.we    = 0;
        #10;
        
        test1 = new(ram_if);
        #10;
        
        
        test1.test_run(50);

        #50;
        $stop;
    end
endmodule