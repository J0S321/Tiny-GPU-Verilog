module Instruction_decoder
(
    input [7:0] instruction,
    output [1:0] opcode, dest_addr, src_addr1, src_addr2
);
//[7:6] OPCODE
//[5:4] DESTINATION REG
//[3:2] SOURCE REG1
//[1:0] SOURCE REG2

    assign opcode = instruction[7:6];
    assign dest_addr = instruction[5:4]; 
    assign src_addr1 = instruction[3:2]; 
    assign src_addr2 = instruction[1:0]; 



endmodule 