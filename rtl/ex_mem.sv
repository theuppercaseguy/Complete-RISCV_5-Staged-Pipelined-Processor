



module ex_mem(
    input logic  clk, logic  rst, logic  STALL, logic  FLUSH,
    input logic  [31:0] pc_in,logic  [31:0]  ALU_in,logic  [31:0]  rs2_in,logic  [31:0]  inst_in,
    input logic  MEMR_in, logic   MEMW_in, 
    input logic  [3:0] MEM_Ctrl_in,
    input logic  [1:0] WBSel_in,
    input logic  ASel_in, logic   BSel_in,
    input logic  RegWEn_in,
    
    output logic  [31:0] pc_out, logic  [31:0]ALU_out,logic  [31:0] rs2_out,logic  [31:0] inst_out,
    
    output logic  MEMR_out,  
    output logic  MEMW_out, 
    output logic  [3:0] MEM_Ctrl_out,
    output logic  [1:0] WBSel_out,
    
    output logic  ASel_out, logic  BSel_out,    
    output logic  RegWEn_out
    );
    logic ASel_interm;
    logic BSel_interm;
    always_ff@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            pc_out <=0; ALU_out <=0; rs2_out<=0; inst_out<=0;
            
            MEMR_out <=0; 
            MEMW_out <=0; MEM_Ctrl_out <=0; WBSel_out <=0; 
            ASel_out<=0; BSel_out<=0;
            RegWEn_out <=0;
            
            ASel_interm <=0;
            BSel_interm <=0;
        end
        else if (FLUSH)
        begin
            pc_out <=0; ALU_out <=0; rs2_out<=0; inst_out<=0;
            
            MEMR_out <=0; 
            MEMW_out <=0; MEM_Ctrl_out <=0; WBSel_out <=0; 
            ASel_out<=0; BSel_out<=0;
            RegWEn_out <=0;
            
            ASel_interm <=0;
            BSel_interm <=0;
        end
        else
        begin
            pc_out   <= pc_in;
            ALU_out  <= ALU_in;
            rs2_out  <= rs2_in;
            inst_out <= inst_in;
            MEMR_out <= MEMR_in;
            MEMW_out <=MEMW_in; MEM_Ctrl_out <= MEM_Ctrl_in; WBSel_out <= WBSel_in;
            RegWEn_out <= RegWEn_in;
                        
            ASel_interm <= ASel_in;            
            BSel_interm <= BSel_in;            
            ASel_out <= ASel_interm; 
            BSel_out <= BSel_interm;

        end
    end
    
endmodule
