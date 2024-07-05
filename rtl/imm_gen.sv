`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 03:41:14 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen#
    (
        parameter input_width = 12,
        parameter output_width = 32
        
    )
    (
    input logic [31:0] imm,
    input logic [2:0] CTRL,

    output logic [output_width -1 : 0] imm_ext
    );

//    assign imm_ext = (S_CTRL == 1'b1) ? ({ {20{INSTR[31]}} ,{INSTR[31:25]},{INSTR[11:7]} }) : { {20{imm[11]}},imm};
    //i 0, s 1, b 2, j 3, u 4
        
    always_comb
    begin
        case(CTRL)
/*i*/        0:  imm_ext <= { {20{imm[31]}},imm[31:20]};
/*s*/        1:  imm_ext <= { {20{imm[31]}},{imm[31:25],imm[11:7]} };
/*b*/        2:  imm_ext <= { {20{imm[31]}},{imm[31]},{imm[7]},{imm[30:25]},{imm[11:8]} } ;
/*j*/        3:  imm_ext <= { {12{imm[31]}},{imm[31]},{imm[19:12]},{imm[20]},{imm[30:21]} };
/*u*/        4:  imm_ext <= { {10{imm[31]}},imm[31:12]};
        
        endcase    
    
    end
        
endmodule












