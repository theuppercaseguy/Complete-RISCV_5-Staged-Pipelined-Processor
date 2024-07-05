`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/02/2024 11:29:05 AM
// Design Name: 
// Module Name: mux4
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


module mux4(
    input logic[31:0] a,b,c,d,
    input logic[1:0] s,
    output logic [31:0] out
    );
    assign out = s == 2'b00 ? a : s == 2'b01 ? b : s == 2'b10 ? c : s == 2'b11 ? d : a;
    
    
endmodule
