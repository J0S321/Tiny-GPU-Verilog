# Tiny-GPU-Verilog
Learning GPU architecture by building a small Verilog-based GPU for parallel matrix operations. 

## Inspiration

This project was inspired by Adam Maj's Tiny GPU project, a small GPU implementation written in System Verilog to explore PGU architecture from the ground up. 

My goal with this repository is to develop my own understanding of GPU architecture, Verilog design, instruction-set design, and parallel computation by implementing and documenting similar concepts step by step.

## Previous Work

While preparing ot build the Tiny GPU, I started a side project that introduced me to components such as registers, RAM, the program counter, instruction register, ALU, control unit, and a top-level datapath integration.

That project was a SAP-1 computer written entirely in Verilog. It taught me many of the fundamental concepts that will be reused and expanded on in this project. 

Rather than documenting all of those concepts from scratch all over again, this project builds upon that foundation and applies them to a GPU-style parallel architecture. 

[SAP-1 Verilog Project](https://github.com/J0S321/SAP-1-Verilog)

## Modules

### Instruction Decoder

The instruction decoder receives a 16-bit instruction and separates it into an opcode and three 4-bit fields. 

The instruction format is:
| Bit     | Purpose |
|---------|---------|
|`[15:12]`| Opcode  |
|`[11:8]` | Field 1 |
| `[7:4]` | Field 2 |
| `[3:0]` | Field 3 |

The meaning of each field depends entire ont he opcode. For arithmetic instructions, the field may represent the destination and source register addresses.

For instructions that use an immediate value or memory address, fields 2 and 3 are then concatenated together to create an 8-bit `imm8` output:

`imm8 = {field2, field3}`

### Why the Decoder is Separate from the Control Unit

The instruction decoder is responsible only for separating the instruction into its individual fields.

The control unit uses the opcode to determine what operation should be performed and generates the necessary signals for the components like the register file, ALU, memory, and the program counter.

Keeping these modules separate makes each component easier to understand, test, debug, and reuse. 

#### Testbench

The testbench verifies that the 16'bit instruction is correctly separated into the opcode and three 4-bit fields. It also verifies that fields 2 and 3 are concatenated correctly to produce the 8'bit `imm8` value. 

![Instruction Decoder Waveform](images/Instruction_decoder_waveform.png)