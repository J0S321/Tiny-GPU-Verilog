# Instruction Decoder 

This was again another simple but important module I created. 

The isntruction decoder takes one 8-bit input called 'instruction' and separates it into four 2-bit outputs. 

The instruction format is: 

bits 7-6 -> opcode
bits 5-4 -> destination register
bits 3-2 -> source register 1
bits 1-0 -> source register 2

The opcode tells the ALU which operation to perform, such as ADD, SUB, AND, or OR. 

The destination registeridentifies where the result of the operation will be stored at. 

source register 1 and source register 2 identify which register will provide the two input values for the operation. 

To create the decoder all I did was bit slicing to separate the 8-bit value input into four different fields: 

```verilog

assign opcode = instruction[7:6];
assign dest_addr = instruction[5:4];
assign src_addr1 = instruction[3:2];
assign src_addr2 = instruction[1:0];
```
Since the decoder only separates bits from the instruction it's just combinational and doesn't require a clock input signal

# Testbench
The testbenhc was straightfoward since we're just testing this module by itself. 

This is why I hardcoded multiple 8-bit values and check wether each one was separated into its correct outputs. 

# Waveform
![Instruction Decoder](Instruction_decoder_waveform.png)