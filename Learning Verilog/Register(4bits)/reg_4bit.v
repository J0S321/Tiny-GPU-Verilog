module reg_4bit
(
    input clk, rst, en,
    input [3:0] d, 
    output reg [3: 0] q
);

    always @(posedge clk) begin
        if(rst == 1'b1) begin
            q <= 4'b0000; 
        end
        else if(en) begin
            q <= d; 
        end
        else begin
            q <= q; 
        end

    end 


endmodule