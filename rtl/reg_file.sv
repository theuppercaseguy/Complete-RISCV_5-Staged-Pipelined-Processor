


module reg_file
    (
        input logic clk, rst, WE,
        input logic [4:0] rs1,rs2,rsw,
        input logic [31:0] dataW,
        
        output logic [31:0] data1,data2
    );

    logic [31:0]Registers[31:0];
    
    
    assign data1 = Registers[rs1];
    assign data2 = Registers[rs2];

    always_ff@(negedge clk)
    begin
        if(WE == 1'b1) Registers[rsw] <= dataW;
    end
    initial begin
        Registers[0] = 0;
//        Registers[1] = 1;
//        Registers[2] = 2;
//        Registers[3] = 123;
    end

endmodule

