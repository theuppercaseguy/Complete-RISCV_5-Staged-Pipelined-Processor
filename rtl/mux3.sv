`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2024 12:50:18 PM
// Design Name: 
// Module Name: mux3
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


module mux3(
        input logic [31:0] a,b,c,
        input logic [1:0] s,
        output logic [31:0] d
    );
        assign d = s == 0 ? a : s == 1 ? b : s == 2 ? c : 0;  
endmodule
