`timescale 1ns / 1ps


interface alu_intf;
    logic opcode;
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] result;


endinterface //alu_intf
class tester;
    virtual alu_intf alu_if;
    function new(virtual alu_intf alu_if);
        this.alu_if = alu_if; //링크를 가져오는 개념, 실제 인테페이스 wire는 아님, 테스트 벤치 첫줄에 선언된 애가 실제 인터페이스임 
    endfunction //new()

    task add_test(logic [7:0] add_a, logic [7:0] add_b);
        alu_if.opcode = 1'b0;
        alu_if.A = add_a;
        alu_if.B = add_b;
    endtask //add_test

    task sub_test(logic [7:0] sub_a, logic [7:0] sub_b);
        alu_if.opcode = 1'b1;
        alu_if.A = sub_a;
        alu_if.B = sub_b;
    endtask //sub_test

endclass //tester

module tb_ALU();

    alu_intf alu_if();

    logic opcode;
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] result;

    ALU dut(
        .opcode(alu_if.opcode),
        .A(alu_if.A),
        .B(alu_if.B),
        .result(alu_if.result)
    );

    tester BTS;
    tester BlackPink;
    tester test1;
    tester test2;

    initial begin
        alu_if.opcode = 1'b0;
        alu_if.A = 0;
        alu_if.B = 0;
        #10;
        BTS = new(alu_if);
        BlackPink = new(alu_if);
        #10;
        BTS.add_test(10, 20);
        #10;
        BTS.sub_test(10, 5);
        BlackPink.add_test(4, 6);
        #10;
        BlackPink.sub_test(6, 4);
        #10;
        $stop;
        $finish;



    end
endmodule
