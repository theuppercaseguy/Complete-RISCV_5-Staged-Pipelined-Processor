
module TOP(
    input logic clk, rst
);
    logic        BrEq_out, BrLT_out, BrUn_out, BrUn_out_execute, ASel_signal_out, BSel_signal_out,
                 ASel_signal_out_execute, BSel_signal_out_execute, ASel_signal_out_memory,
                 BSel_signal_out_memory, MemR_out, MemR_out_decode, 
                 MemR_out_execute, MemR_out_memory, MemW_out, MemW_out_decode, MemW_out_execute,
                 MemW_out_memory, RegWEn_out, RegWEn_out_execute, RegWEn_out_memory, RegWEn_out_writeback,
                 STALL, WE_OFF_ON_LW_STALL, temp_STALL, FLUSH, pc_sel ,pc_sel_decode
    ;
    logic [1:0]  WBSel_out, WBSel_out_execute,WBSel_out_memory, WBSel_out_writeback,
                 ASEL_frwrd, BSEL_frwrd;
    logic [2:0]  ImmSel_out, ImmSel_out_execute;
    logic [3:0]  ALUSel_out, ALUSel_out_execute, MEM_Ctrl_out, MEM_Ctrl_out_execute, MEM_Ctrl_out_memory;
    logic [31:0] adder_out,  pc_mux_out, pc_out, INSTR_out,
                 INSTR_out_decode, pc_out_decode, imm_ext_out, dataR1_out, dataR2_out,
                 dataR1_out_execute, dataR2_out_execute, imm_ext_out_execute,
                 INSTR_out_execute, INSTR_out_memory, INSTR_out_writeback, pc_out_execute,
                 pc_out_memory, mem_adder_out, mem_adder_out_writeback, dmem_mux_out, ASel_out,
                 alu_out_writeback, BSel_out, ALU_Out, dataR2_out_memory, dataR_out_writeback, 
                 dataR_out, alu_out_memory, ASEL_frwrd_out, BSEL_frwrd_out
    ;
 



    logic [31:0] instruction1, instruction2, instruction3, instruction4,instruction5,  
        rs1_1_data, rs2_1_data, rs1_2_data, rs2_2_data,rs1_3_data, rs2_3_data,rs1_4_data, rs2_4_data,
         wdata1, wdata2, wdata3,
        pc_next_1, pc_next_2, pc_next_3, pc_next_4, pc_curr_1, pc_curr_2,
        pc_curr_3, pc_curr_4, pc_curr_5, pc_curr_6
    ;
logic [4:0] rs1_1_adr, rs2_1_adr, rs1_2_adr, rs2_2_adr, rs1_3_adr, rs2_3_adr, rs1_4_adr, rs2_4_adr, rd_adr_1, rd_adr_2, rd_adr_3;



    logic [8:0] imm_extend_concat;
    assign imm_extend_concat = { {INSTR_out_decode[30]}, {INSTR_out_decode[14:12]}, {INSTR_out_decode[6:2]} };

    mux pc_mux(
        .a(adder_out),
        .b(alu_out_memory),
        .s(pc_sel_decode),
        .c(pc_mux_out)
    );

    PC pc_inst(
        .clk(clk),
        .rst(rst),
        .PC(pc_mux_out), 
            
        .PC_next(pc_out)
    );
    adder adder_inst(
        .rst(rst),
        .STALL(STALL),
        .a(pc_out),
        .b(32'd4),
        .s(adder_out)
    );
    logic [31:0]imem_offset;
    assign imem_offset  = pc_out - 32'h80000000;
        
    IMEM IMEM_inst(
        .clk(clk),
        .rst(rst),
        .addr(imem_offset),
        .dataR(INSTR_out)
    );
    
    if_id if_id_dut(
        .clk(clk), 
        .rst(rst),
        .pc_in(pc_out), 
        .inst_in(INSTR_out),
        .STALL(STALL),
        .FLUSH(FLUSH),
        
        .pc_out(pc_out_decode), 
        .inst_out(INSTR_out_decode)
    );
    
    reg_file reg_file_inst(
        .clk(clk),
        .rst(rst),
        .WE( temp_STALL/*WE_OFF_ON_LW_STALL*/ == 1'b1 ? 1'b0 : RegWEn_out_writeback),
        .rs1(INSTR_out_decode[19:15]),
        .rs2(INSTR_out_decode[24:20]),
        .rsw(INSTR_out_writeback[11:7]),
        .dataW(dmem_mux_out),
        
        .data1(dataR1_out),
        .data2(dataR2_out)
    );
    
    imm_gen imm_gen_inst(
        .imm(INSTR_out_decode),
        .CTRL(ImmSel_out_execute),
        .imm_ext(imm_ext_out)
    );

    logic start_instr_flag;
    assign start_instr_flag = INSTR_out_decode == 0 ? 1'b0 : 1'b1;
    Control_Unit CU(
        .rst(rst),
        .instr(imm_extend_concat),
        .BrEq(BrEq_out),
        .BrLT(BrLT_out),
        .start_instr_flag(start_instr_flag), 
                
        .PCSel(pc_sel), 
        .BrUn(BrUn_out), 
        .ASel(ASel_signal_out), 
        .BSel(BSel_signal_out), 
        .MemR(MemR_out), 
        .MemW(MemW_out), 
        .RegWEn(RegWEn_out), 
        .ImmSel(ImmSel_out),
        .ALUSel(ALUSel_out), 
        .WBSel(WBSel_out),
        .MEM_Ctrl(MEM_Ctrl_out)
    
    ); 
    
    id_ix id_ix_dut(
        .clk(clk), 
        .rst(rst),
        .STALL(STALL),
        .FLUSH(FLUSH),
        
        .pc_in(pc_out_decode), 
        .dataR1_in(dataR1_out), 
        .dataR2_in(dataR2_out), 
        .imm_ext_in(imm_ext_out), 
        .inst_in(INSTR_out_decode),                
        .pc_sel_in(pc_sel),
        
        
        .BrUn_in(BrUn_out), 
        .Asel_in(ASel_signal_out), 
        .Bsel_in(BSel_signal_out), 
        .MemR_in(MemR_out), 
        .MemW_in(MemW_out), 
        .RegWEn_in(RegWEn_out), 
        .ImmSel_in(ImmSel_out), 
        .ALUSel_in(ALUSel_out), 
        .MEM_Ctrl_in(MEM_Ctrl_out), 
        .WBSel_in(WBSel_out),
                
        .pc_out(pc_out_execute), 
        .dataR1_out(dataR1_out_execute), 
        .dataR2_out(dataR2_out_execute), 
        .imm_ext_out(imm_ext_out_execute), 
        .inst_out(INSTR_out_execute),
        .pc_sel_out(pc_sel_decode), 
        .BrUn_out(BrUn_out_execute), 
        .Asel_out(ASel_signal_out_execute), 
        .Bsel_out(BSel_signal_out_execute), 
        .MemR_out(MemR_out_decode), 
        .MemW_out(MemW_out_decode), 
        .RegWEn_out(RegWEn_out_execute),
        .ImmSel_out(ImmSel_out_execute), 
        .ALUSel_out(ALUSel_out_execute), 
        .MEM_Ctrl_out(MEM_Ctrl_out_execute),
        .WBSel_out(WBSel_out_execute)
    );
    
    Branch_Comp BRAN_COMP(
        .data1(dataR1_out_execute), 
        .data2(dataR2_out_execute),
        .BrUn(BrUn_out_execute),
        
        .BrEq(BrEq_out), 
        .BrLT(BrLT_out)
    );
        
    mux ASel_mux(
        .a(dataR1_out_execute),
        .b(pc_out_execute),
        .s(ASel_signal_out_execute/*ASel_signal_out_memory*/),
        .c(ASel_out)
    );
    
    mux BSel_mux(
        .a(dataR2_out_execute),
        .b(imm_ext_out_execute),
        .s(BSel_signal_out_execute/*BSel_signal_out_memory*/),
        .c(BSel_out)
    );    
    
    mux4 ASEL_frwrd_dut(
        ASel_out,
        alu_out_memory,
        dmem_mux_out,
        dataR_out,
        ASEL_frwrd,
        
        ASEL_frwrd_out
    );
    
    mux4 BSEL_frwrd_dut(
        BSel_out,
        alu_out_memory,
        dmem_mux_out,
        dataR_out,
        BSEL_frwrd,
        
        BSEL_frwrd_out
    );
    
    ALU ALU_inst(
        .clk(clk),
        .rst(rst),
        .ALUSel(ALUSel_out_execute),
        .A(ASEL_frwrd_out),
        .B(BSEL_frwrd_out),
        .ALUOut(ALU_Out)
    );    
    
    ex_mem ex_mem_dut(
        .clk(clk),
        .rst(rst),
        .STALL(STALL),
//        .FLUSH(FLUSH),
        .pc_in(pc_out_execute),
        .ALU_in(ALU_Out),
        .rs2_in(dataR2_out_execute),
        .inst_in(INSTR_out_execute),
        .MEMR_in(MemR_out_decode),
        .MEMW_in(MemW_out_decode),
        .MEM_Ctrl_in(MEM_Ctrl_out_execute),
        .WBSel_in(WBSel_out_execute),
        .ASel_in(ASel_signal_out_execute),
        .BSel_in(BSel_signal_out_execute),
        .RegWEn_in(RegWEn_out_execute),
        
        .pc_out(pc_out_memory),
        .ALU_out(alu_out_memory),
        .rs2_out(dataR2_out_memory),
        .inst_out(INSTR_out_memory),
        .MEMR_out(MemR_out_memory),
        .MEMW_out(MemW_out_memory),
        .MEM_Ctrl_out(MEM_Ctrl_out_memory),
        .WBSel_out(WBSel_out_memory),
        .ASel_out(ASel_signal_out_memory),
        .BSel_out(BSel_signal_out_memory),
        .RegWEn_out(RegWEn_out_memory)
    );
    
    adder adder_mem(
        .a(pc_out_memory),
        .b(31'd4),
        .rst(rst),
        .s(mem_adder_out)
    );
    
    data_mem data_mem_inst(
        .clk(clk),
        .rst(rst),
        .MEMR(MemR_out_memory),
        .MEMW(MemW_out_memory),
        .MEM_Ctrl(MEM_Ctrl_out_memory),
        .addr(alu_out_memory),
        .dataW(dataR2_out_memory),
        .dataR(dataR_out)
    );
    
    mem_wb mem_wb_dut(
        .clk(clk), .rst(rst),
         .pc_in(mem_adder_out), 
         .ALU_in(alu_out_memory), 
         .dataR_in(dataR_out), 
         .inst_in(INSTR_out_memory),
         .WBSel_in(WBSel_out_memory),
         .RegWEn_in(RegWEn_out_memory),
         
         .pc_out(mem_adder_out_writeback), 
         .ALU_out(alu_out_writeback), 
         .dataR_out(dataR_out_writeback), 
         .inst_out(INSTR_out_writeback),
         .WBSel_out(WBSel_out_writeback),
         .RegWEn_out(RegWEn_out_writeback)
    );
        
    mux3 dmem_mux(
        .a(dataR_out_writeback),
        .b(alu_out_writeback),
        .c(mem_adder_out_writeback),
        .s(WBSel_out_writeback),
        .d(dmem_mux_out)
    );
    
    Forwarding_Control_Logic frwrding(
         .clk(clk),
         .decode_memory_read(MemR_out_decode),
         .mem_WE(RegWEn_out_memory),
         .wb_WE(RegWEn_out_writeback),
         .exec_writeback_mux(WBSel_out_execute),
         .inst_decode(INSTR_out_decode),
         .inst_execute(INSTR_out_execute),
         .inst_memory(INSTR_out_memory),
         .inst_writeback(INSTR_out_writeback),
            
          .ASEL_frwrd(ASEL_frwrd), 
          .BSEL_frwrd(BSEL_frwrd),
          .STALL(STALL),
          .WE_OFF_ON_LW_STALL(WE_OFF_ON_LW_STALL)
        );
        
     control_hazards control_hazards_dut(
          .inst_execute(INSTR_out_execute),
          .BrLT(BrLT_out), 
          .BrEq(BrEq_out),
          
          .flush(FLUSH)
     );



        always_ff@(posedge clk)
        begin
            if(rst) temp_STALL <=0; 
            else temp_STALL <= WE_OFF_ON_LW_STALL;
        end

    // The below code is for testing the processor on IP Tracer
    
    // always_ff@(posedge clk)
    // begin
    //     instruction1 <= INSTR_out;
    //     instruction2 <= instruction1;
    //     instruction3 <= instruction2;
    //     instruction4 <= instruction3;
    //     instruction5 <= instruction4;
        
    //     rs1_1_adr <= INSTR_out_decode[19:15];
    //     rs2_1_adr <= INSTR_out_decode[24:20];
    //     rs1_2_adr <= rs1_1_adr;
    //     rs2_2_adr <= rs2_1_adr;
    //     rs1_3_adr <= rs1_2_adr;
    //     rs2_3_adr <= rs2_2_adr;
    //     rs1_4_adr <= rs1_3_adr;
    //     rs2_4_adr <= rs2_3_adr;
        
    //     rs1_1_data <= dataR1_out;
    //     rs2_1_data <= dataR2_out;
    //     rs1_2_data <= rs1_1_data;
    //     rs2_2_data <= rs2_1_data;
    //     rs1_3_data <= rs1_2_data;
    //     rs2_3_data <= rs2_2_data;
    //     rs1_4_data <= rs1_3_data;
    //     rs2_4_data <= rs2_3_data;
        
    //     rd_adr_1 <= INSTR_out_writeback[11:7];
    //     rd_adr_2 <= rd_adr_1;
    //     rd_adr_3 <= rd_adr_2;
        
    //     wdata1 <= dmem_mux_out;
        
    //     pc_curr_1 <= pc_mux_out;
    //     pc_curr_2 <= pc_curr_1;
    //     pc_curr_3 <= pc_curr_2;
    //     pc_curr_4 <= pc_curr_3;
    //     pc_curr_5 <= pc_curr_4;
    //     pc_curr_6 <= pc_curr_5;
        
        
    //     pc_next_1 <= pc_out;
    //     pc_next_2 <= pc_next_1;
    //     pc_next_3 <= pc_next_2;
    //     pc_next_4 <= pc_next_3;
    // end
       
    // tracer tracer_ip (
    //     .clk_i(clk),
    //     .rst_ni(rst),
    //     .hart_id_i(32'b0),
    //     .rvfi_valid(1'b1),
        
    //     .rvfi_insn_t(instruction5),
    //     .rvfi_rs1_addr_t(rs1_4_adr),
    //     .rvfi_rs2_addr_t(rs1_4_adr),
    //     .rvfi_rs1_rdata_t(rs1_4_data),
    //     .rvfi_rs2_rdata_t(rs2_4_data),
    //     .rvfi_rd_addr_t(rd_adr_1) ,
        
    //     .rvfi_rd_wdata_t(wdata),
        
    //     .rvfi_pc_rdata_t(pc_curr_6),
    //     .rvfi_pc_wdata_t(pc_next_4),
        
    //     .rvfi_mem_addr(0),
    //     .rvfi_mem_rmask(0),
    //     .rvfi_mem_wmask(0),
    //     .rvfi_mem_rdata(0),
    //     .rvfi_mem_wdata(0)
    // );

endmodule

