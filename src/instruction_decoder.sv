
module instruction_decoder
(
    input[15:0] instruction,
    output [3:0] opcode, field1, field2, field3,
    output [7:0] imm8
);

    assign opcode = instruction[15:12];
    assign field1 = instruction[11:8];
    assign field2 = instruction[7:4];
    assign field3 = instruction[3:0];
    assign imm8 = {field2, field3};


endmodule