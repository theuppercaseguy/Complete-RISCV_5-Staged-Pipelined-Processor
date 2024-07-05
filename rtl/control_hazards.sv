`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2024 02:41:07 AM
// Design Name: 
// Module Name: control_hazards
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


module control_hazards(
        input logic [31:0] inst_execute,
        input logic BrLT, BrEq,
        output logic flush
    );
    
    always_comb
    begin
        if(inst_execute[6:0] == 7'b1100011 & (BrLT | BrEq) )
        begin
            flush <= 1'b1;
        end
        else flush <= 0;
    end
endmodule



















