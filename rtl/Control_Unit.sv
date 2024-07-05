`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2024 12:54:00 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
        input logic rst,
        input logic [8:0] instr,
        input logic BrEq,logic BrLT,logic start_instr_flag,
        
        output logic PCSel,logic BrUn,logic ASel,logic BSel,logic MemR,logic MemW,logic RegWEn, 
        output logic [2:0] ImmSel,logic [3:0] ALUSel,logic [1:0] WBSel,
        output logic [3:0] MEM_Ctrl
    );  
        //PCSEL => alu = 1, +4 =0
        //i 0, s 1, b 2, j 3, u 4
        parameter alu_pc = 1'b1; parameter plus4 = 1'b0;
        parameter i = 3'd0; parameter s = 3'd1; parameter b = 3'd2; parameter j = 3'd3; parameter u = 3'd4;
        parameter RegA = 1'b0; parameter pc = 1'b1;
        parameter RegisB = 1'b0; parameter imm = 1'b1;
        parameter add = 4'd0; parameter sub = 4'd1; parameter op = 4'd2;
        parameter read = 1'b1; parameter write = 1'b1;
        parameter mem = 2'd0;parameter alu_wb = 2'd1; parameter pcplus4 = 2'd2;
        
        logic [31:0] inst_check;
        always_comb
        begin
            if(rst == 1'b1)
            begin
                MEM_Ctrl <= 4'd0; PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=1'b0; MemW<=0; RegWEn<=0; WBSel <= alu_wb;
                inst_check <=31'd0;
            end
            
            else if(instr[4:0] == 5'b01101) //lui
            begin
                PCSel <= plus4; ImmSel <= u; BrUn<=0; ASel<=pc; BSel<=imm; ALUSel <= 10; MemR <=1; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd1;
            end
            
            else if(instr[4:0] == 5'b00101)//auipc
            begin
                PCSel <= plus4; ImmSel <= u; BrUn<=0; ASel<=pc; BSel<=imm; ALUSel <= 11; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd2;
            end
            
            else if(instr[4:0] == 5'b11011)//jal
            begin
                PCSel <= alu_pc; ImmSel <= j; BrUn<=0; ASel<=pc; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= pcplus4;
                inst_check <=31'd3;
            end
            
            else if(instr[7:0] == 8'b000_11001)//jalr
            begin
                PCSel <= alu_pc; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= pcplus4;            
                inst_check <=31'd4;
            end
            
            else if(BrEq == 1'b0 && instr[7:0] == 8'b101_11000)//beq fail
            begin
                PCSel <= plus4; ImmSel <= b; BrUn<=0; ASel<=pc; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=0; WBSel <= 0;
                inst_check <=31'd5;
            end
            else if(BrEq == 1'b1 && instr[7:0] == 8'b101_11000)//beq pass
            begin
                PCSel <= alu_pc; ImmSel <= b; BrUn<=0; ASel<=pc; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=0; WBSel <= 0;
                inst_check <=31'd6;
            end
            
            else if(BrEq == 1'b0 && instr[7:0] == 8'b001_11000)//bne fail
            begin
                PCSel <= plus4; ImmSel <= b; BrUn<=0; ASel<=pc; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd7;
            end
            
            else if(BrEq == 1'b1 && instr[7:0] == 8'b001_11000)//bne pass
            begin
                PCSel <= alu_pc; ImmSel <= b; BrUn<=0; ASel<=pc; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd8;
            end
            
            else if(BrLT == 1'b1 && instr[7:0] == 8'b110_11000)//blt pass
            begin
                PCSel <= alu_pc; ImmSel <= b; BrUn<=0; ASel<=pc; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd9;
            end
            
            else if(BrLT == 1'b1 && instr[7:0] == 8'b111_11000)//bltu
            begin
                PCSel <= alu_pc; ImmSel <= b; BrUn<=1; ASel<=pc; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd10;
            end
            
            else if(instr[7:0] == 8'b000_00000 && start_instr_flag == 1'b1)//lb
            begin
                MEM_Ctrl <= 4'd0; PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=1; MemW<=0; RegWEn<=1; WBSel <= mem;
                inst_check <=31'd11;
            end
            
            else if(instr[7:0] == 8'b001_00000)//lh
            begin
                MEM_Ctrl <= 4'd1; PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=1; MemW<=0; RegWEn<=1; WBSel <= mem;
                inst_check <=31'd12;
            end
            
            else if(instr[7:0] == 8'b010_00000)//lw
            begin
                MEM_Ctrl <= 4'd2; PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <= 1; MemW<=0; RegWEn<=1; WBSel <= mem;
                inst_check <=31'd13;
            end
            
            else if(instr[7:0] == 8'b100_00000)//lbu
            begin
                MEM_Ctrl <= 4'd3; PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=1; MemW<=0; RegWEn<=1; WBSel <= mem;
                inst_check <=31'd14;
            end
            
            else if(instr[7:0] == 8'b101_00000)//lhu
            begin
                MEM_Ctrl <= 4'd4; PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=1; MemW<=0; RegWEn<=1; WBSel <= mem;
                inst_check <=31'd15;
            end
            
            else if(instr[7:0] == 8'b000_01000)//sb
            begin
                MEM_Ctrl <= 4'd5; PCSel <= plus4; ImmSel <= s; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=1; RegWEn<=0; WBSel <= alu_wb;
                inst_check <=31'd16;
            end
            
            else if(instr[7:0] == 8'b001_01000)//sh
            begin
                MEM_Ctrl <= 4'd6; PCSel <= plus4; ImmSel <= s; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=1; RegWEn<=0; WBSel <= alu_wb;
                inst_check <=31'd17;
            end
            
            else if(instr[7:0] == 8'b010_01000)//sw
            begin
                MEM_Ctrl <= 4'd7; PCSel <= plus4; ImmSel <= s; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=1; RegWEn<=0; WBSel <= 0;
                inst_check <=31'd18;
            end
            
            else if(instr[7:0] == 8'b000_00100)//addi
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd19;
            end
            
            else if(instr[7:0] == 8'b010_00100)//slti
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= 4'd3; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd20;
            end
            
            else if(instr[7:0] == 8'b011_00100)//sltiu
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= 4'd4; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd21;
            end
            
            else if(instr[7:0] == 8'b100_00100)//xori
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= 4'd5; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd22;
            end
            
            else if(instr[7:0] == 8'b110_00100)//ori
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= 4'd8; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd23;
            end
            
            else if(instr[7:0] == 8'b111_00100)//andi
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= 4'd9; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd24;
            end
            
            else if(instr[8:0] == 9'b0_001_00100)//slli
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= 4'd2; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd25;
            end
            
            else if(instr[8:0] == 9'b0_101_00100)//srli
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= 4'd6; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd26;
            end
            
            else if(instr[8:0] == 9'b1_101_00100)//srai
            begin
                PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= 4'd7; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd27;
            end
            
            else if(instr[8:0] == 9'b0_000_01100)//add
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd0; MemR <=0; MemW<=0; RegWEn<=1; WBSel = alu_wb;
                inst_check <=31'd28;
            end
            
            else if(instr[8:0] == 9'b1_000_01100)//sub
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd1; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd29;
            end
            
            else if(instr[8:0] == 9'b0_001_01100)//sll
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd2; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd30;
            end
            
            else if(instr[8:0] == 9'b0_010_01100)//slt
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd3; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd31;
            end
            
            else if(instr[8:0] == 9'b0_011_01100)//sltu
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd4; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd32;
            end
            
            else if(instr[8:0] == 9'b0_100_01100)//xor
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd5; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd33;
            end
            
            else if(instr[8:0] == 9'b0_101_01100)//srl
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd6; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd34;
            end
            
            else if(instr[8:0] == 9'b1_101_01100)//sra
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd7; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd35;
            end
            
            else if(instr[8:0] == 9'b0_110_01100)//or
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd8; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd36;
            end
            
            else if(instr[8:0] == 9'b0_111_01100)//and
            begin
                PCSel <= plus4; ImmSel <= 0; BrUn<=0; ASel<=RegA; BSel<=RegisB; ALUSel <= 4'd9; MemR <=0; MemW<=0; RegWEn<=1; WBSel <= alu_wb;
                inst_check <=31'd37;
            end
            else 
            begin
                MEM_Ctrl <= 4'd0; PCSel <= plus4; ImmSel <= i; BrUn<=0; ASel<=RegA; BSel<=imm; ALUSel <= add; MemR <=1'b0; MemW<=1'b0; RegWEn<=1'b0; WBSel <= alu_wb;
                inst_check <=31'd38;
            end
        end
        
    
    
    
endmodule









