`timescale 1ns/1ns
module instruction_decoder_tb();
    logic [15:0] instruction;
    logic [3:0] opcode, field1, field2, field3;
    logic [7:0] imm8;


    instruction_decoder uut
    (
        .instruction(instruction),
        .opcode(opcode),
        .field1(field1),
        .field2(field2),
        .field3(field3),
        .imm8(imm8)
    );

    initial begin
        $dumpfile("waveforms/instruction_decoder_tb.vcd");
        $dumpvars(0, instruction_decoder_tb);

        instruction = 16'b0000_0000_0000_0000;
        #10;

        instruction = 16'b0000_0011_1010_0101;
        #10;

        instruction = 16'b0000_0011_1010_0101;
        #10;

        instruction = 16'b0100_0010_0011_0100;
        #10;

        instruction = 16'b1111_0010_0010_0110; 
        #10;

        $finish;
    end


endmodule;