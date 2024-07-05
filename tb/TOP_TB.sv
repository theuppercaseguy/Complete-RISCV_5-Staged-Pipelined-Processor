`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2024 10:23:15 AM
// Design Name: 
// Module Name: TOP_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TOP_TB();
    logic clk, rst;
//    logic [31:0] mux_out1,mux_out2,data_mem_w;
    
    always #5 clk = ~clk;
    
    initial begin
        clk =0;
        rst = 1;
        #25
        rst = 0;
        #1000000 $finish;
    end
    
    TOP dut(
        clk, 
        rst
    );

endmodule
