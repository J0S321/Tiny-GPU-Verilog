module program_counter
(
    input clk, rst, enable,
    output reg [3:0] pc
);

    always@(posedge clk) begin
        if(rst) begin
            pc = 4'b0000; 
        end
        else if(enable) begin
            pc <= pc + 1; 
        end    

    end

endmodule