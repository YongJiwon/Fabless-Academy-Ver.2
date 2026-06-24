`timescale 1ns / 1ps

module tb_fnd_controller();
    
    reg [3:0] bin;
    
    
    fnd_controller dut(
        .bin(),
        .fnd_com(),
        .fnd_data()
    );
endmodule
