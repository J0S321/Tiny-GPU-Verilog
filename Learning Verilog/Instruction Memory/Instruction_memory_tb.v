module Instruction_memory_tb(); 

    parameter INSTRUCTION_WIDTH = 8; 
    reg [3:0] address;
    wire [INSTRUCTION_WIDTH-1:0] instruction;

    Instruction_memory uut
    (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("Instruction_memory_tb.vcd");
        $dumpvars(0, Instruction_memory_tb); 
        for(integer i = 0; i <= 15; i++) begin
            address = i; 
            #10; 
        end
        $finish;
    end


endmodule 