

module PC #(parameter PC_Width = 32,
            parameter inc_width = 3,
            parameter pc_next_width = 31
            ) (
    input logic clk,logic  rst,
    input logic [PC_Width - 1:0] PC,
    
    output logic [pc_next_width:0] PC_next
);
   
   always_ff @(posedge clk)
   begin
        if(rst == 1'b1)
        begin
            PC_next<=32'h80000000;
        end
        else
        begin
            PC_next <=  PC /*- 32'h80000000*/;
        end
   end
    
    
endmodule
