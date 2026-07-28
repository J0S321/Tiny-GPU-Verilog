module digit_counter
(
    input clk, rst,
    output reg [1:0] sel
);

    always @(posedge clk) begin
        if(rst) begin
            sel <= 2'b00; 
        end
        else begin
            sel <= sel + 1; 
        end
    end


endmodule