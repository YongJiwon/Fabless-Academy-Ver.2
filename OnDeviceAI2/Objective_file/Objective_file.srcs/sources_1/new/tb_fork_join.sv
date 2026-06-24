`timescale 1ns / 1ps


module tb_fork_join();

    initial begin
        #1 $display("%t : start for - join,",$time);

        fork
            #10 A_thread();
            #20 B_thread();
            #15 C_thread();
        join_any

        #10 $display("%t : end fork - join,",$time);
        disable fork;
        $stop;
    end 

    task A_thread ();
        repeat (5) $display("%t : A thread",$time);
    endtask //_thread

    task B_thread ();
        forever begin
            $display("%t : B thread",$time);
            #5;
        end
    endtask //_thread
    task C_thread ();
        forever begin
            $display("%t : C thread",$time);
            #10;
        end
    endtask //_thread

    
/*

initial begin
        #1 $display("%t : start for - join,",$time);

        fork
            #10 A_thread();
            #20 B_thread();
            #15 C_thread();
        join_any

        #10 $display("%t : end fork - join,",$time);
    end 

    initial begin
        #1 $display("%t : start for - join,",$time);

        fork
            #10 A_thread();
            #20 B_thread();
            #15 C_thread();
        join_none

        #10 $display("%t : end fork - join,",$time);
    end 
*/





endmodule

    




