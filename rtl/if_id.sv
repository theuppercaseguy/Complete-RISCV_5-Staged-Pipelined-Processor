module if_id(
    input logic  clk, rst,FLUSH,
    input logic  [31:0] pc_in, inst_in,
    input logic  STALL,
    output logic [31:0] pc_out, inst_out
    );
    
    always_ff@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            pc_out <= 0;
            inst_out <= 0;
        end
        else if(STALL ==1'b1)
        begin
            pc_out      <= pc_out;
            inst_out    <= inst_out;
        end
        else if(FLUSH)
        begin
            pc_out <= 0;
            inst_out <= 0;
        end
        else
        begin
            pc_out<= pc_in;
            inst_out <= inst_in;
        end
    end
    
endmodule