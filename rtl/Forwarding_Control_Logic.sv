`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2024 01:02:21 PM
// Design Name: 
// Module Name: Forwarding_Control_Logic
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


module Forwarding_Control_Logic(
        input logic clk, decode_memory_read, mem_WE, wb_WE, 
        input logic [1:0]exec_writeback_mux,
        input logic[31:0] inst_decode, inst_execute,
        input logic[31:0] inst_memory, inst_writeback,
        
        output logic [1:0]ASEL_frwrd, BSEL_frwrd,
        output logic STALL, WE_OFF_ON_LW_STALL
    );
    
    logic [10:0] temp;
    /*always_comb
    begin
        if(inst_memory == 0 || inst_execute == 0)
        begin
            ASEL_frwrd = 2'b00;
            BSEL_frwrd = 2'b00;
            temp <= 0;
            STALL <= 0;
        end
        else if( (inst_decode[19:15] == inst_execute[11:7]) && (inst_decode[24:20] == inst_memory[11:7]) && (inst_execute[6:0] == 7'b0000011 ) ) //lw d_rs1 = ex_rd, de_rs2 = mem_rd
        begin
            STALL = 1'b1; 
            ASEL_frwrd = 2'b10;
            BSEL_frwrd = 2'b00;
            temp <= 1;
        end
        else if( (inst_decode[24:20] == inst_execute[11:7]) && (inst_decode[19:15] == inst_memory[11:7]) && (inst_execute[6:0] == 7'b0000011 ) ) //lw d_rs2 = ex_rd, de_rs1 = mem_rd
        begin
            STALL = 1'b1; 
            ASEL_frwrd = 2'b00;
            BSEL_frwrd = 2'b10;
            temp <= 2;
        end    
        else if( (inst_decode[24:20] == inst_execute[11:7]) && (inst_memory[6:0] == 7'b0000011 ) )      //lw after stall, value reached writeback, de_rs2 = exe_rd
        begin
            STALL = 1'b0; 
            ASEL_frwrd = 2'b00;
            BSEL_frwrd = 2'b11;
            temp <= 3;
        end    
        else if( (inst_decode[19:15] == inst_execute[11:7]) && (inst_memory[6:0] == 7'b0000011 ) ) // lw after stall, value reached writeback, de_rs1 = exe_rd   
        begin
            STALL = 1'b0; 
            ASEL_frwrd = 2'b11;
            BSEL_frwrd = 2'b00;
            temp <= 4;
        end
        else if (inst_execute[19:15] == inst_memory[11:7] &&  inst_execute[24:20] == inst_writeback[11:7])  //ex rs1 == mem rs1 && exe rs2 == wb rs2
        begin
            ASEL_frwrd = 2'b01;
            BSEL_frwrd = 2'b10;
            temp <= 5;
            STALL <= 0;
        end
        else if (inst_execute[19:15] == inst_writeback[11:7] && inst_execute[24:20] == inst_memory[11:7]) //exe rs1 == wb rs1 && ex rs2 == mem rs2
        begin
            ASEL_frwrd = 2'b10;
            BSEL_frwrd = 2'b01;
            temp <= 6;
            STALL <= 0;
        end
        else if(inst_memory[11:7] == inst_execute[19:15]  ) //dest = rs1
        begin
            ASEL_frwrd = 2'b01;
            BSEL_frwrd = 2'b00;
            temp <= 7;
            STALL <= 0;
        end
        else if(inst_memory[11:7] == inst_execute[24:20]  ) //dest = rs2
        begin
            ASEL_frwrd = 2'b00; 
            BSEL_frwrd = 2'b01; 
            temp <= 8;
            STALL <= 0;
        end
        else
        begin
            ASEL_frwrd = 2'b00;
            BSEL_frwrd = 2'b00;
            STALL = 1'b0; 
            temp <= 9;
        end
    end
    */
    
    logic [4:0] rs1d, rs2d, rdd, rs1e, rs2e, rde, rs1m, rs2m, rdm, rs1w, rs2w, rdw; 
    
    assign rs1d = inst_decode[19:15];
    assign rs2d = inst_decode[24:20];
    assign rdd = inst_decode[11:7];
    
    assign rs1e = inst_execute[19:15];
    assign rs2e = inst_execute[24:20];
    assign rde = inst_execute[11:7];
    
    assign rs1m = inst_memory[19:15];
    assign rs2m = inst_memory[24:20];
    assign rdm = inst_memory[11:7];
    
    assign rs1w = inst_writeback[19:15];
    assign rs2w = inst_writeback[24:20];
    assign rdw = inst_writeback[11:7];
    
///    assign STALL  = ( ( rs1d == rdm | rs2d  == rdm | rs1d == rdw | rs2d == rdw ) ) ? 1'b0 : ( ((rs1d == rde) | (rs2d == rde))) ? 1'b1 : 1'b0 ;
    
    reg temp_stall;
    
    always_comb
    begin
       if(rs1e == rdm & rs2e == rdm &  inst_memory[6:0] == 7'b000011)
        begin
            ASEL_frwrd <= 2'b11;
            BSEL_frwrd <= 2'b11;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=2;
        end
        else if(rs1e == rdw & rs2e == rdw &  inst_writeback[6:0] == 7'b000011)
        begin
            ASEL_frwrd <= 2'b00;
            BSEL_frwrd <= 2'b00;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=3;
        end
//        rs1e = rdm, rs2e = rdw
        else if(rs1e == rdm & rs2e == rdw & inst_memory[6:0] == 7'b000011)
        begin
            ASEL_frwrd <= 2'b11;
            BSEL_frwrd <= 2'b10;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=20;
        end
        /*else if(rs2e == rdm & rs1e == rdw & inst_memory[6:0] == 7'b000011)
        begin
            ASEL_frwrd <= 2'b11;
            BSEL_frwrd <= 2'b00;
            STALL <= 1'b1;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=21;
        end*/
        else if(rs1e == rdm & inst_memory[6:0] == 7'b000011)
        begin
            ASEL_frwrd <= 2'b11;
            BSEL_frwrd <= 2'b00;
            STALL <= 1'b1;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=4;
        end
        //#rs1 = rdw, rs2e = rdm, inst_mem == lw
        else if(rs1e == rdw & rs2e == rdm & inst_memory[6:0] == 7'b000011)
        begin
            ASEL_frwrd <= 2'b10;
            BSEL_frwrd <= 2'b11;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=22;
        end
        else if(rs2e == rdm & inst_memory[6:0] == 7'b000011)
        begin
             ASEL_frwrd <= 2'b00;
             BSEL_frwrd <= 2'b11;
             STALL <= 1'b1;
             WE_OFF_ON_LW_STALL <=1'b0;
             temp <=5;
        end
        else if(rs1e == rdw & inst_writeback[6:0] == 7'b000011)
        begin
            ASEL_frwrd <= 2'b10;
            BSEL_frwrd <= 2'b00;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=6;
        end
        else if(rs1e == rdw & inst_writeback[6:0] == 7'b000011)
        begin
           ASEL_frwrd <= 2'b10;
           BSEL_frwrd <= 2'b00;
           STALL <= 1'b0;
           WE_OFF_ON_LW_STALL <=1'b0;
           temp <=7;
        end
        else if( (rs1e == rdm)  & (rs2e == rdw) & (inst_writeback[6:0] == 7'b000011) )
            begin
                ASEL_frwrd <= 2'b01;
                BSEL_frwrd <= 2'b10;
                STALL <= 1'b0;
                WE_OFF_ON_LW_STALL <=1'b0;
                temp <=25;
            end
        else if( (rs1e == rdm)  & (rs2e == rdw) )
        begin
            ASEL_frwrd <= 2'b01;
            BSEL_frwrd <= 2'b00;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=8;
        end
        else if( (rs2e == rdm)  & (rs1e == rdw) )
        begin
            ASEL_frwrd <= 2'b10;
            BSEL_frwrd <= 2'b01;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;    
            temp <=9;
        end
       else if(rdm == rs1e &&  mem_WE)
       begin
            ASEL_frwrd <= 2'b01;
            BSEL_frwrd <= 2'b00;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=10;
       end
       else if(rdm == rs2e  && mem_WE)
       begin
            ASEL_frwrd <= 2'b00;
            BSEL_frwrd <= 2'b01;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=11;
       end
       else if(rdw == rs1e  && wb_WE)
       begin
            ASEL_frwrd <= 2'b10;
            BSEL_frwrd <= 2'b00;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=12;
       end
       else if(rdw == rs2e && wb_WE && WE_OFF_ON_LW_STALL)
       begin
           ASEL_frwrd <= 2'b00;
           BSEL_frwrd <= 2'b01;
           STALL <= 1'b0;
           WE_OFF_ON_LW_STALL <=1'b0;
           temp <=13;
       end
//       #rs2 = rdw2, rs1 == rdw
       else if(rs2e == rdw & rs1e ==rs1w & inst_execute[6:0] == 7'b000011)
       begin
         ASEL_frwrd <= 2'b00;
         BSEL_frwrd <= 2'b00;
         STALL <= 1'b0;
         WE_OFF_ON_LW_STALL <=1'b0;
         temp <=14;
       end
       else if( (rdw == rs2e) & wb_WE & ( (rs1e != rdw) | (rs1e != rdm) ) )
       begin
            ASEL_frwrd <= 2'b00;
            BSEL_frwrd <= 2'b10;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=15;
        end
        else 
        begin
            ASEL_frwrd <= 2'b00;
            BSEL_frwrd <= 2'b00;
            STALL <= 1'b0;
            WE_OFF_ON_LW_STALL <=1'b0;
            temp <=16;
        end
    end
    
endmodule


