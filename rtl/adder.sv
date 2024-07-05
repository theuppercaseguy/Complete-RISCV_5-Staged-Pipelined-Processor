`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 04:28:46 PM
// Design Name: 
// Module Name: adder
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


module adder(
    input logic [31:0] a,b,
    input logic rst,STALL,
    output logic [31:0] s
    );
    
    always_comb
    begin
        if(rst == 1'b1) s = 32'h80000000;
        else if(STALL) s = a;
        else s = (a + b);
    end
    
    
endmodule
