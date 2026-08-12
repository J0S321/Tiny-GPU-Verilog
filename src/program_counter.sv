module program_counter
(
    input clk, rst, pc_load, halt,
    input [7:0] next_pc,
    output logic [7:0] pc
);

    always_ff @(posedge clk) begin
        if(rst)
            pc <= 8'b0; 
        else if(halt)
            pc <= pc; 
        else if(pc_load)
            pc <= next_pc; 
        else
            pc <= pc + 8'b1; 
        
    end


endmodule