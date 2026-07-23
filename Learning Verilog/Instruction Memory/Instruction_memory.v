module Instruction_memory 
#(    
    parameter INSTRUCTION_WIDTH = 8
)
(
    input [3:0] address, 
    output reg [INSTRUCTION_WIDTH-1:0] instruction
);
    reg[INSTRUCTION_WIDTH-1:0] memory [0:15]; 
    initial begin
        memory[0] = 8'b00010111;
        memory[1] = 8'b11111111; 
        memory[2] = 8'b01010101; 
        memory[3] = 8'b00000000;
        memory[4] = 8'b11010101; 
        memory[5] = 8'b00011100;
        memory[6] = 8'b11100000;
        memory[7] = 8'b10101010;
        memory[8] = 8'b00000000;
        memory[9] = 8'b00110011; 
        memory[10] = 8'b11000010;
        memory[11] = 8'b11100000;
        memory[12] = 8'b01010101;
        memory[13] = 8'b00000000;
        memory[14] = 8'b11111111;
    end

    always @(*) begin 
        instruction = memory[address];
    end


endmodule