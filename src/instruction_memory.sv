module instruction_memory
(
    input [7:0] pc_0, pc_1, pc_2, pc_3,
    output [15:0] instruction_0, instruction_1, instruction_2, instruction_3
);

    logic [15:0] memory [0:255]; 

    initial begin 
        $readmemh("programs/program.hex", memory);
    end

    assign instruction_0 = memory[pc_0]; //CORE 1
    assign instruction_1 = memory[pc_1]; //CORE 2
    assign instruction_2 = memory[pc_2]; //CORE 3
    assign instruction_3 = memory[pc_3]; //CORE4




endmodule