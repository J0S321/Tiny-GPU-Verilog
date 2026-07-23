# Instruction Memory

This was another fun and simple module that I created.

Instruction memory is a memory module that stores the instructions of a program. This module connects to the program counter, since it will provide an address, and the instruction memory will output the instruction that is stored at that address.

Since this module is not receiving instructions from another component/module, I hardcoded the instructions inside of an `initial block`.

To store the instructions, I created an array:

```verilog
reg[INSTRUCTION_WIDTH-1:0] memory[0:15];
```

This line taught me how to create a memory array in Verilog.

The first range:

```verilog
[INSTRUCTION_WIDTH-1:0]
```

determines how many bits an element should have.

The second range:

```verilog
[0:15]
```

creates 16 memory locations, or is how many elements there should be. Another thing is that this is index 0-based.

In this module, I also learned how to use parameters in Verilog:

```verilog
module Instruction_memory#(paramenter INSTRUCTION_WIDTH = 8)
```

This gives `INSTRUCTION_WIDTH` a value of `8`, and any time it's used, such as:

```verilog
[INSTRUCTION_WIDTH-1:0]
```
just becomes:

```verilog
[7:0];
```

This means that every memory location stores one 8-bit instruction.

Finally, the `address` input is used as an index of the memory array as seen by this line:

```verilog
instruction = memory[address];
```

Whatever the address changes to, the module outputs the instruction stored at that location.

# Testbench

The testbench was also simple.

Since I wanted to read all 16 memory locations, I used a `for` loop to increment the address from 0 to 15.

I intentionally left the memory location 15 uninitialized so that when address `1111` was selected, it would output `xxxxxxxx`.

# Waveform
![Insruction Memory Waveform](Images/Insturction_memory_waveform.png)