



module IMEM#(
        parameter instr_registers = 1024,
        parameter addr_width = 32        
    )
    (
        input logic [addr_width-1:0] addr,
        input logic rst,clk,
        
        output logic [31:0]dataR
    );
    
    logic [addr_width-1:0]INSTR_REG [instr_registers-1:0];
    
    always_comb
    begin
        if(rst ==1'b1)
        begin
            dataR <=32'd0;
        end
        else
        begin
            dataR <= INSTR_REG[addr[31:2]];
        end
    end
    initial begin
     $readmemh("/home/cc/Desktop/sim/seed/test.hex",INSTR_REG);
    end
    
   /* initial begin //testing purposes
    
    INSTR_REG[0] <= 32'h00500093;
    INSTR_REG[1] <= 32'h00A00113;
    INSTR_REG[2] <= 32'h002081B3;
    INSTR_REG[3] <= 32'h00518213;
    INSTR_REG[4] <= 32'h004082B3;
    INSTR_REG[5] <= 32'h00120333;
    INSTR_REG[6] <= 32'h005083B3;
    INSTR_REG[7] <= 32'h00002403;
    INSTR_REG[8] <= 32'h008184B3;
    INSTR_REG[9] <= 32'h00340533;
    INSTR_REG[10] <= 32'h00402583;
    INSTR_REG[11] <= 32'h00358633;
    INSTR_REG[12] <= 32'h00B186B3;
    INSTR_REG[13] <= 32'h00802703;
    INSTR_REG[14] <= 32'h00E707B3;
    INSTR_REG[15] <= 32'h00C02803;
    INSTR_REG[16] <= 32'h00F808B3;
    INSTR_REG[17] <= 32'h01002903;
    INSTR_REG[18] <= 32'h012889B3;
    INSTR_REG[19] <= 32'h01298A33;
    INSTR_REG[20] <= 32'h01002A83;
    INSTR_REG[21] <= 32'h015A0B33;
    INSTR_REG[22] <= 32'h0620C463;
    INSTR_REG[23] <= 32'h004082B3;
    INSTR_REG[24] <= 32'h00120333;
    INSTR_REG[25] <= 32'h005083B3;
    INSTR_REG[26] <= 32'h00208BB3;
    INSTR_REG[27] <= 32'h00208C33;





    
    INSTR_REG[0] <= 32'h00500093;
    INSTR_REG[1] <= 32'h00A00113;
    INSTR_REG[2] <= 32'h00500193;
    INSTR_REG[3] <= 32'h00500213;
    INSTR_REG[4] <= 32'h00500293;
    INSTR_REG[5] <= 32'h00208333;
    INSTR_REG[6] <= 32'h402083B3;
    INSTR_REG[7] <= 32'h00209433;
    INSTR_REG[8] <= 32'h0020A4B3;
    INSTR_REG[9] <= 32'h0020B533;
    INSTR_REG[10] <= 32'h0020C5B3;
    INSTR_REG[11] <= 32'h0020D633;
    INSTR_REG[12] <= 32'h4020D6B3;
    INSTR_REG[13] <= 32'h0020E733;
    INSTR_REG[14] <= 32'h0020F7B3;
    INSTR_REG[15] <= 32'h00400803;
    INSTR_REG[16] <= 32'h00201883;
    INSTR_REG[17] <= 32'h00402903;
    INSTR_REG[18] <= 32'h00204983;
    INSTR_REG[19] <= 32'h00405A03;
    INSTR_REG[20] <= 32'h005004A3;
    INSTR_REG[21] <= 32'h00601623;
    INSTR_REG[22] <= 32'h00702923;
    INSTR_REG[23] <= 32'h0051AA93;
    INSTR_REG[24] <= 32'h0051BB13;
    INSTR_REG[25] <= 32'h00519B93;
    INSTR_REG[26] <= 32'h0051DC13;
    INSTR_REG[27] <= 32'h4051DC93;
    INSTR_REG[28] <= 32'h00014237;
    INSTR_REG[29] <= 32'h00014D17;

    INSTR_REG[30] <= 32'h0820C863;  //jump
    
    INSTR_REG[31] <= 32'h00519B93;
    INSTR_REG[32] <= 32'h0051DC13;
    INSTR_REG[33] <= 32'h4051DC93;
    INSTR_REG[34] <= 32'h00014237;
    INSTR_REG[35] <= 32'h00014D17;
    INSTR_REG[36] <= 32'h00208DB3;
    INSTR_REG[37] <= 32'h40208E33;
   
    
    
    end */
endmodule









