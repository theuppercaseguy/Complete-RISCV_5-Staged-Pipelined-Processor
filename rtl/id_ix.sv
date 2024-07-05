
module id_ix(
        input logic clk, logic rst, STALL, FLUSH,
        input logic [31:0] pc_in,logic [31:0] dataR1_in, logic [31:0]dataR2_in,logic [31:0] imm_ext_in,logic [31:0] inst_in,                
        input logic pc_sel_in, logic BrUn_in, logic  Asel_in,  logic Bsel_in, logic  MemR_in,  logic MemW_in, logic  RegWEn_in, 
        input logic [2:0]ImmSel_in, 
        input logic [3:0] ALUSel_in,logic [3:0] MEM_Ctrl_in, 
        input logic [1:0] WBSel_in,
                
        output logic [31:0]pc_out,logic [31:0] dataR1_out, logic [31:0]dataR2_out,logic [31:0] imm_ext_out,logic [31:0] inst_out,
                
        output logic pc_sel_out, logic  BrUn_out, logic  Asel_out, logic  Bsel_out, logic  MemR_out, logic  MemW_out, logic  RegWEn_out,
        output logic [2:0]ImmSel_out, logic[3:0] ALUSel_out,logic [3:0]MEM_Ctrl_out,
        output logic [1:0]WBSel_out
        );
        
        
        always_ff@(posedge clk)
        begin
            if(rst ==1'b1)
            begin
                pc_out <=0; 
                dataR1_out <=0; 
                dataR2_out <=0;
                imm_ext_out <=0; 
                inst_out <=0;
                            
                pc_sel_out <=0; BrUn_out <=0; Asel_out <=0; Bsel_out <=0; MemR_out <=0; MemW_out <=0; RegWEn_out <=0;
                ImmSel_out <=0; ALUSel_out <=0; MEM_Ctrl_out <=0;
                WBSel_out  <=0;
            end
            else if(STALL == 1'b1)
            begin
                pc_out <=pc_out; 
                dataR1_out <=dataR1_out; 
                dataR2_out <=dataR2_out;
                imm_ext_out <=imm_ext_out; 
                inst_out <=inst_out;
                            
                pc_sel_out <=pc_sel_out; BrUn_out <=BrUn_out; Asel_out <=Asel_out; 
                Bsel_out <=Bsel_in/*Bsel_out*/ ; MemR_out <=MemR_out ; MemW_out <=MemW_out ; 
                RegWEn_out <=RegWEn_in/*RegWEn_out*/ ;
                ImmSel_out <=ImmSel_out; ALUSel_out <=ALUSel_out ; MEM_Ctrl_out <=MEM_Ctrl_out ;
                WBSel_out  <=WBSel_out;
            end
/*            else if (FLUSH)
            begin
                pc_out <=0; 
                dataR1_out <=0; 
                dataR2_out <=0;
                imm_ext_out <=0; 
                inst_out <=0;
                            
                pc_sel_out <=0; BrUn_out <=0; Asel_out <=0; Bsel_out <=0; MemR_out <=0; MemW_out <=0; RegWEn_out <=0;
                ImmSel_out <=0; ALUSel_out <=0; MEM_Ctrl_out <=0;
                WBSel_out  <=0;
            end*/
            else
            begin
                pc_out <= pc_in; 
                dataR1_out <=dataR1_in; 
                dataR2_out <=dataR2_in;
                imm_ext_out <=imm_ext_in; 
                inst_out <=inst_in;
                            
                pc_sel_out <=pc_sel_in; BrUn_out <=BrUn_in; Asel_out <=Asel_in; Bsel_out <=Bsel_in; MemR_out <=MemR_in; MemW_out <=MemW_in; RegWEn_out <=RegWEn_in;
                ImmSel_out <=ImmSel_in; ALUSel_out <=ALUSel_in; MEM_Ctrl_out <=MEM_Ctrl_in;
                WBSel_out  <=WBSel_in;
            end
        
        end
endmodule
