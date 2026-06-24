`timescale 1ns / 1ps



module tb_fifo;


parameter DEPTH = 4;

    reg clk;
    reg rst_n;
    reg [7:0] push_data;
    reg push;
    reg pop;
    wire [7:0] pop_data;
    wire full;
    wire empty;

    reg [7:0] compare_data[0:DEPTH-1];
    reg [1:0] push_cnt, pop_cnt;

    
fifo_sv dut (
    .clk(clk),
    .rst_n(rst_n),
    .push_data(push_data),
    .push(push),
    .pop(pop),
    .pop_data(pop_data),
    .full(full),
    .empty(empty)
);



always #5 clk = ~clk;

integer i;


initial begin

    clk = 0;
    rst_n = 1;
    push_data = 0;
    push = 0;
    pop = 0;
    push_cnt = 0;
    pop_cnt = 0;
    
    for (i = 0;i<256;i = i+1) begin
        compare_data[i] = 0;
    end

    #10;
    rst_n = 0;
    @(posedge clk);
    #1;
    //push only
    for (i = 0; i < DEPTH + 1; i = i + 1) begin
        push = 1;
        push_data = i;
        #10; 
    end
    push_data = 30;
    #30
    
    for (i = 0; i < DEPTH + 1; i = i + 1) begin
        pop =1;    
        //push_data = i;
        #10; 
    end
    push = 0;
    pop = 1;

    for (i = 0; i < DEPTH + 1; i = i + 1) begin
        pop =1;    
        
        push_data = i+8'h0;
        #10; 
    end
    
    //empty fifo
    pop = 1;
    push = 0;
    #20;
    pop =0;
    push = 0;

    //sync for drive signal
    @(posedge clk); //stimulus
    //random test
    for (i = 0; i < 16;i = i+1) begin
        //randomize
        #1;
        push = $random % 2;
        pop = $random % 2;
        push_data = $random % 256;
        if (push && (!full)) begin
            compare_data[push_cnt] = push_data;
            push_cnt = push_cnt + 1;
        end

        @(negedge clk);
        if (pop && (!empty)) begin
            if(pop_data == compare_data[pop_cnt]) begin
                $display("%t : pass : pop_data = %h, compare_data = %h",$time, pop_data, compare_data[pop_cnt]);
            end else begin
                $display("%t : fail : pop_data = %h, compare_data = %h",$time, pop_data, compare_data[pop_cnt]);
            end
            pop_cnt = pop_cnt + 1; //After Process
        end
        //#10;
        @(posedge clk); //phase for drive time
    end




    #100;


    $stop;
end



endmodule
