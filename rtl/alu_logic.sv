


module ALU#
    (
        parameter select_line_width = 4
    )
    (
        input logic clk, rst,
        input logic [select_line_width-1 : 0]ALUSel,
        input logic [31:0] A,B,
        
        output logic [31:0] ALUOut        
    );

    always_comb
    begin
        if(rst ==1'b1)
        begin
            ALUOut <=32'd0;
        end
        else
        begin
            case(ALUSel)
            0: ALUOut <= A + B;
            1: ALUOut <= A - B;
            2: ALUOut <= A  << B;
            3: ALUOut <= A < B ;
            4: ALUOut <= $unsigned (A) < $unsigned (B);
            5: ALUOut <= A ^ B ;
            6: ALUOut <= A >> B ;
            7: ALUOut <= A >>> B ;
            8: ALUOut <= A | B ;
            9: ALUOut <= A & B ;
            10: ALUOut <= B << 12 ;
            11: ALUOut <= A + (B << 12) ;
            default: ALUOut <= 0;
            endcase
        end
    end


endmodule



