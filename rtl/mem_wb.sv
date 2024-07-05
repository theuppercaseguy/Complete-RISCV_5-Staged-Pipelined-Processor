`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2024 12:53:11 PM
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
     input logic  clk, rst,
     input logic  [31:0] pc_in, ALU_in, dataR_in, inst_in,
     input logic  [1:0]WBSel_in,
     input logic  RegWEn_in,
     
     output logic  [31:0] pc_out, ALU_out, dataR_out, inst_out,
     output logic  [1:0] WBSel_out,
     output logic RegWEn_out

     );
     
     always_ff@(posedge clk)
     begin
         if(rst == 1'b1)
         begin
            pc_out <=0; ALU_out <=0; dataR_out <=0; inst_out <=0;
            WBSel_out <=0;
            RegWEn_out <=0;
         end
         else
         begin
            pc_out <=pc_in; 
            ALU_out <=ALU_in; 
            dataR_out <=dataR_in; 
            inst_out <=inst_in;
            WBSel_out <= WBSel_in;
            RegWEn_out <= RegWEn_in;
         end
     end
endmodule












