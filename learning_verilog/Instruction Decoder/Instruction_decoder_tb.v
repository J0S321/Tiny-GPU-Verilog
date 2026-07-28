module Instruction_decoder_tb(); 

    reg[7:0] instruction; 
    wire [1:0] opcode, dest_addr, src_addr1, src_addr2; 

    Instruction_decoder uut
    (
        .instruction(instruction),
        .opcode(opcode),
        .dest_addr(dest_addr),
        .src_addr1(src_addr1), 
        .src_addr2(src_addr2)
    );

    initial begin
        $dumpfile("Instruction_decoder_tb.vcd"); 
        $dumpvars(0, Instruction_decoder_tb); 

        instruction = 8'b00000000;
        #10;

        instruction = 8'b10101010;
        #10;

        instruction = 8'b11111111;
        #10; 

        instruction = 8'b11100011;
        #10; 

        instruction = 8'b00110101; 
        #10; 
        $finish; 
    end 
endmodule