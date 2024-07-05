`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2024 03:39:50 PM
// Design Name: 
// Module Name: Branch_Comp
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


module Branch_Comp(
    input logic [31:0] data1, data2,
    input logic BrUn,
    
    output logic BrEq, BrLT
    );
    
    always_comb
    begin
        if(BrUn == 1'b0)
        begin
            BrEq <= data1 == data2 ? 1'b1 : 1'b0;
            BrLT <= data1 < data2 ? 1'b1 : 1'b0;
        end
        else if(BrUn == 1'b0)
        begin
            BrEq <= ( $unsigned(data1) == $unsigned(data2) ) ? 1'b1 : 1'b0;
            BrLT <= ( $unsigned(data1)  < $unsigned(data2) ) ? 1'b1 : 1'b0;
        end
    end
    
    
    
endmodule
