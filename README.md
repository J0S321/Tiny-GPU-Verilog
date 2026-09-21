# Tiny-GPU-Verilog
Learning GPU architecture by building a small Verilog-based GPU for parallel matrix operations. 

## Inspiration

This project was inspired by Adam Maj's Tiny GPU project, a small GPU implementation written in System Verilog to explore GPU architecture from the ground up. 

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

### Register File

Wow, now we are getting into some heavier-duty components. This module contains sixteen 8-bit register and provides one write port and two read ports.

Data can be written into the reigster file by selected a register with `write_address` and asserting `write_enable`. On the rising edge of the clock `write_data` will be stored in the selceted register. 

The module also reads from two register simultaneously. `read_address_1` and `read_address_2` select the register. While the stored values are displayed through `read_data_1` and `read_data_2`

When `rst` is asserted, all sixteen register are cleared back to `0000_0000`.

#### Testbench

The testbench verifies that value can be written into different registers and read through both read ports. 

It also confirms that the register hold their value while `write_enable` is disabled, even if `write_address` and `wite_data` changes. 

At the end of the simulation, `rst` is asserted again to verify that all of the used register are cleared.

As the modules have now become more complex, I plan to begin using self-checking testbenches so that the expected values can be verified autoatically instead of relying entirely on waveform inspections. 

![Register File Waveform](images/register_file_waveform.png)

### ALU
This was another interesting module. The Arithmetic Logic Unit, or ALU for short, is where most of the computational operations happen inside a processor. For my Tiny GPU, the ALU can perform addition, subtraction, multiplication, AND, OR, and XOR operations. 

These operations are selected using the `alu_operation` input. The control unit will eventually use the opcode from the instruction set to determine what value should be sent through `alu_operation`. 

One of the main things I learned while creating this module was how overflow works for different arithemtic operations. 

For addition, overflow happens when the two operands have the same signs, and the sign of the result differs from operand A. 

For subtraction, overflow occurs when the two operands have different signs, and the sign of the result differs from operand A. 

Multiplication works a little bit differently because multiplying two 8-bit values can produce a 16-bit result. The lower eight bits are stored in `result`. While the upper eight bits are checked for overflow. If any bit in the `produce[15:0]` is a `1`, then the complete result couldn't fit into the 8'bit output. 

The zero flag is more straightforward. After the ALU finishes an operation, it check wether the final result is `0000_0000`. If it is, then `zeroflag` is asserted. 

#### Testbench
For this module, I designed a self-checking testbench. The initialization is similar to my previous testbenches, but I introduced a new SystemVerilog feature called a `task`. 

A task allows me to create a reusable block of testbench code with parameters: 
```Verilog
    task check_alu
    (
        input [7:0] a,
        input [7:0] b,
        input [2:0] operation,

        input [7:0] expected_result, 
        input expected_zero, 
        input expected_carry,
        input expected_overflow
    );
```

Tasks are basically like functions in C/C++. Using the parameter, the task would apply the operands and operation to the ALU and compare the actual outputs against the expected result, zero flag, carry flag, and overflow flag. 

If all of the values matc, then the testbench displays that the test passed in the terminal. 

![ALU Pass Terminal](images/alu_selfchecking.png)

Now, if a value does not match, the testbench displays a failure message along with the expected values and the actual values produced by the ALU. This makes debugging so much easier than relying solely on the waveform inspections. 


I also placed the simulation delay inside of the task itself; because of this, the initial block only needs to call the `check_alu` with only different operands, operations, and expected values.

After testing the different ALU operations and flag conditions, all of the tests produced the expected results 

![ALU waveform](images/alu_waveform.png)

### Program Counter
The next module I created was the Program Counter. I won't go too deep into how this module works because I already explained the basic idea in my SAP-1 project. However, this Program Counter differs from the SAP-1's version because it can also receive a new address and jump directly to it by using the `[7:0] next_pc` input. 

Normally, the Program Counter increments by one on every rising edge of the clock. However, when `pc_load` is asserted, instead of incrementing the Program Counter loads the value that is stored in `next_pc`. This will be really useful for the branch instructions where the processor needs to continue execution from a different instruction address. 

#### Testbench
The testbench wasn't too difficult ot create. I was mainly getting more practice with using `task` inside of my testbenches. A self-checking task wasn't really necessary for a simple module like this one, but it was goo practice for verify the sequential logic. 

The task applies the reset, `pc_load` and `next_pc` values, waits for a rising edge of the clock, and then checks whether the actual Program Counter matches the expected value. 

I tested the Program Counter by reseting it to zero, allowing it to increment normally, loading a new address using `next_pc`, and then resetting it again. 

Below are the results of the self-checking testbench. 

![Program Counter Pass Terminal](images/pc_selfchecking.png)

![Program Counter Waveform](images/pc_waveform.png)

### Control Unit
This was another fascinating module, although it did take a while to complete because I had to make sure that every instruction generated the correct control signals. 

The Control Unit takes 4-bit `opcode` from the Instruction Decoder and uses a `case` statement to determine what the rest of the processor should do. Depending on the instruction, it can enable register write, select an ALU operation, write to memory , load a new Program Counter address, or halt execution. 

The main controls in this unit are: 

- `reg_write_enable` - Allows a value to be written into the Register File. 
- `pc_load` - Allows the PC to load a new address fro jumps and branches. 
- `halt` - Stops the process from continuing any instruction. 
- `alu_operation` - Selects which operation the ALU should perform. 

For example, when the Control Unit gets the `ADD` opcode, it selects the ADD operation in the ALU and asserts `reg_write_enable` so that the result can be written into the destination register:

```Verilog
4'b0100: begin //ADD
    reg_write_enable = 1'b1; 
    alu_operation = 3'b000;
end
```

Another thing I learned was how conditional branch instruction can use the ALU's `zeroflag`. Since both `BEQ` and `BNE` use subtraction to compare two registers. If the subtraction computation produces a zero then that means that the values are equal. 

So for `BEQ`, `pc_load` is asserted when the `zeroflag` is `1`. While the opposite is true for `BNE`, when `zeroflag` is `0` then `pc_load` is asserted. 

Now one of the major problems that I ran while creating the Control Unit was on how to implement the `MAC` instruction. At first I thought I could perform multiplication and then addition by assigning two different values to `alu_operation` inside of the same case block. However since the Control Unit is using combinational logic, the second assignment would overwrite the first one, thus not allowing this method to work. 

To solve this I had to modify the `alu` module. 

#### Modifications
I add a dedicated `MAC` operation to the ALU using the bit values of `3'b110`

```Verilog
4'b0111: begin //MAC
    reg_write_enable = 1'b1; 
    alu_operation = 3'b110; 
end
```

I also added an `accumulator` input to the ALU. This would allow the ALU to now perform: 
`Rd = Rd + (Rs1 * Rs2)`

using the previous value of `Rd` as the accumulator. 

Just to make sure that the module works as intended I also modified the testbench to verify. And everything works corrcetly!

![New ALU Waveform](images/new_alu_waveform.png)


#### Testbench 
The testbench wasn't too difficult to create, it was just tedious since I had to copy the same structure of code for the task a lot of times. None the less I feel much more comfortable writing self-checking testbenches in SystemVerilog now. 

The testbench goes through each opcode and checks wether the expected control signals are asserted. This verifies signals like `reg_write_enable`, `pc_load`, `mem_write`, `halt`, `alu_operation`. 

I also test both possible conditions for `BEQ` and `BNE` instructions. this allowed me to verify that the branch is taken when its conditions are true or ignored when the coditions are false. 


![Control Unit Pass Terminal](images/control_unit_selfchecking.png)

![Control Unit Waveform](images/control_unit_waveform.png)


### Writeback Mux
This is a small module that I created to select what data should be written back into `Rd`. It is a 3-to1 mux controlled by the `writeback_select` signal. 

The three possible inputs are: 

`alu_result` - The result produced by the ALU. 
`immediate` - The 8-bit immediate value from the instruction. 
`register_data` - Register data used mainly for the `MOV` instruction. 

The `writeback_select` signal determines which value is sent to the Register File: 

- `2'b01` - ALU result
- `2'b10` - Immediate value
- `2'b11` - Register data
- `2'b00` - Default value of zero

##### Register File
For the Register File, I added a third read port for the `MAC` operation. 

Since `MAC` does the operation: 

`Rd = Rd + (Rs1 * Rs2)`

The ALU needs to read `Rs1`. `Rs2` and the old value of `Rd` at the same time. The third read port allows the old value of `Rd` to be sent into the ALU as the accumulator. 

I also modified the testbench and tested the Register file again to make sure the new changes didn't break any functionality. 

![Modified Register File](images/modified_register_file_waveform.png)

###### Program Counter
For the Program Counter, I added one more input called `halt`. When this signal is asserted, the Program Counter holds its current value instead of continuing to increment. 

I also modified the testbench to check that the Program Counter stays at the same address while `halt` is asserted. 

![Modified Program Counter](images/modified_program_counter_waveform.png)

![Modified Program Counter Test](images/modified_program_counter_selfchecking.png)

#### Testbench
The testbench for the Writeback Mux is pretty simple. I tested every possible value of `writeback_select` and checked if the correct input was sent to `writeback_data`. 

I also tested the unused `2'b00` selection to make sure that the output was all zeros. 

![Writeback Testbench](images/writeback_mux_waveform.png)

![Writeback Testbench Test](images/writeback_mux_waveform_selfchecking.png)

### Compute Core
Wow, this module really took a while to make. I put this project to the side for about two weeks since I was working on a Family Feud game for a SHPE GBM I was hosting during the first week of classes. 

But anyways, let's get back to this module. The compute core basically connects most of the modules I previously created to form the main exectuion unit of the GPU. This GPU will eventually have four compute cores in total, so this module represents one of the four cores. 

While creating the core, I also modified the ISA. I changed the immediate load instruction to `LDI`, which loads an immediate value into a register, and added `LD`, which loads a value from memory into a register. 

For example: 

```text
LDI R1, 5
```

This loads the immediate value 5 into R1, while 

```text
LD R1, 0x10 
```

loads the value in the memory address 0x10 into R1.

The compute core connects the instruction deocder, control unit, register file, ALU, program counter, and writeback mux together. This allows the core to execute arithmetic instructions, move values between registers, access memory, and change program flow using jumps and branches. 

While creating this module, I had trouble simulating it because the simulation would get stuck and wouldn't produce the full waveform when certain instructions were executed. Debugging this help me understand how important it is to avoid combinational loops when connecting different modules together. 

#### Testbench
While writing the testbench, the biggest issue I ran into was that the simulation would stop continuing when it reached the `SUB` instruction. 

The problem was caused by a combinational loop between the control unit and the ALU. The control unit was affecting the ALU operation while also depending on a flag that was produced from the ALU. This caused the simulator to continuously check both module without progressing the simulation time. 

After fixing this, I tested several instructions together to make sure the entire compute core was working properly.

The testbench currently tests instructions like: 
- `LDI`
- `ADD`
- `SUB`
- `MOV` 
- `LD` 
- `STORE`
- `BEQ`
- `BNE` 
- `JMP` 
- `HALT`

I also added registers 0-5 to the waveform to confirm that values were being written to the correct registers. 

![Compute Core](images/compute_core_waveform.png)

### Instruction_memory
This module wasn't too hard to write. I just needed four different program counter inputs and four instruction outputs, one for each of the four compute cores. 

The main purpose of this module is to allow each core to fetch its own insturction using its own program counter. Since every core has its own PC, they can each request an instruction from a different location in instruction memory. 

The biggest improvement from SAP-1 project is that the program is now being read from an external file instead of being hard-coded directly into memory. This is done using the following code: 

```verilog
initial begin
    $readmemh("programs/program.hex", memory); 
end
```
The `$readmemh` reads the hexadecimal instructions stored inside `program.hex` and loads them into the instruction memory when the simulation begins. 

For example, the program counter file can have 
````text 
1105
1207
4312
F000
````

which in binary is just 
0001 0001 0000 0101 -> LDI, R1, 5
0001 0010 0000 0111 -> LDI, R2, 7
0100 0011 0001 0010 -> ADD, R3, R1, R2
1111 0000 0000 0000 -> HALT 


#### Testbench
The testbench for this module was also straightfoward. I want to make sur ethat the instruction stored inside `program.hex` were correctly loaded into memory and appeared on all four instruction outputs. 

The testbench changes the program counter address and checks that `instruction_0`, `instruction_1`, `instruction_2`, and `instruction_3` all returned the expected 16-bit instruction. 

![instruction_memory](images/instruction_memory_waveform.png);

### Dispatcher
Although this module looks tedious because it has 17 ports, it was relatively easy to create. 

The basic functionality of the dispatcher is to manaage the four compute cores. it determines which cores should be enabled using `core_X_enable`, monitors whether each enable core has stopped using its `halt` signal, and asserts done when every active core has finished. 

When `start` is asserted the dispatcher uses a case statement to check `thread_count`. It then enables the corresponding number of cores. For example, a `thread_count` of three enables cores 0, 1, and 2. Each core is also assigned its own thread ID from 0 - 3. 

The internal `busy` signal keeps track of wether teh dispatcher is currently running a group of thread. While `busy` is asserted, the dispatcher check wether every enabled core has asserted its `halt` signal. Once every active core has halted, the dispatcher disables all four cores, clears busy, and asserts `done` signal. 

#### Testbench
The testbench checks all of the supported `thread_count` from one through four. For each thread count, it verfies the core enable signals, thread IDS, halt behavior, and `done` output.

One difficulty I had to resolve involved unasserting `rst`. Originally, reset was being changed at the same time as a postive clock edge which just created a race condition. I fixed this by implementing

```` verilog
    repeat (2) @(posedge clk);
    @(negedge clk);
````

The `repeat` statement waits for two positive clock edges so the synchronous reset is recognized by the dispatcher. The testbench then waits for a negative clock edge before deasserting `rst`, preventing reset from changing at the same time as the active clock edge. 

![Dispatcher Waveform](images/dispatcher_waveform.png);

![Dispatcher Verification](images/dispatcher_self_checking_testbench.png);

### Compute Cluster
This module took a while to finish, especially because of the testbench. The purpose of the compute cluster is to combine the dispatcher with all four compute cores. The dispatcher uses `thread_count` to enable the requested number of cores and asserts done once every enabled core has been halted. 

#### Modified Modules
Two modules that were modified while creating the compute cluster: `compute_core` and `program_counter`. 

The `compute_core` module was given an additional input called `core_enable`. This allows the dispatcher to enable or disable each individual core. It also prevents a disabled core from updating any of its internal registers. 

The `program_counter` module was given an `enabled` input. When `enabled` is not asserted, the program counter holds its current values instead of moving advancing. This allows the dispatcher to keep unused cores disabled 

#### Testbench 
This was the longest testbench I had written at this point. This was mainly because of the number of inputs and outputs, instruction local parameters, the instruction logic for each core, and the self-checking task.

Each core executes a small program: first loads a value into `R1`. It then loads another value into `R2` and adds the two values together, storing the result in `R3`. Finally, each core stores `R3` at a different memory address.

Some cores execute additional `NOP` instructions before stopping or `HALTING`. This gives each program a different length and allows for the `done` signal to be verified that it only gets asserts until all the cores are halted.

The testbench also gives each core an instruction according to the core's program counter. It checks the program counters, memory addresses, memory write data, and memory write enables, and the final `done` signal. 

![Compute Cluster Waveform](images/compute_cluster_waveform.png)

#### Four Active Cores
I also tested the cluster with different `thread_count` values: 
```verilog
thread_count = 3'd1 // Enables core 0 
thread_count = 3'd2 // Enables core 1
thread_count = 3'd3 // Enables core 2
thread_count = 3'd4 // Enables Core 3
```

![One Compute Cluster Waveform](images/compute_cluster_one_core_test_waveform.png)

![Two Compute Cluster Waveform](images/compute_cluster_two_core_active_waveform.png)

![Three Compute Cluster Waveform](images/compute_cluster_testing_core_waveform.png)

This tests all confirmed that the dispatcher correctly controls the four compute cores, each enabled core executes its own instructions, disabled cores remain inactive and `done` is only asserted after each active core has stoped

### Data Memory
Before implementing the data memory I modified the `control_unit`, `compute_core`, and `compute_cluster` modules so that they can support memory reads. The control unit now asserts a `mem_read` signal during a `LOAD` instruction. The compute core and compute cluster also got new `memory_read_enable` output signals allowing future cache and memory modules to determine when a core is requesting data 

After making these changes I retested the compute cluster to verify that both the memory read and write signals still work correctly. 

![Compute Cluster](images/memory_cluster_updates/new_compute_cluster.png)

The data memory will serve as the primary storage for the program's data. It contains 256 memory locations that each hold an 8-bit value. The cache will sit between the cores and data memory and hold copies of recently accessed values.

Writes occur on the rising edge of the clock when `write_enable` is asserted. Reads are combinational, so when `read_enable` is asserted, `read_data` will display the values stored at that address. When reading is disabled, `read_data` outputs zero. 


#### Testbench 
The testbench begins by initializing all input signals to zero. It then performs the following test: 

1. Writes `0x08` to address `0x10` and reads it back.
2. Writes `0x10` to address `0x14` and verifies the stored value.
3. Reads address `0x10` again to ensure its original value was not changed by writing to another address. 
4. Overwrites address `0x10` with `0x12` and confirms that the value was updated correctly. 
5. Checks the `read_data` outputs zero whenever `read_enable` is disabled 

All tests passed confirming that the module can write, retain, read, and overwrite stored data correctly

![Data Memory](images/memory_cluster_updates/data_memory_waveform.png)


