# Reg_file_4bit

This was another module that I found fun to create. 

The register file acts like a small memory block. It contains four 4-bit registers that can be both written to and read from. 

This register module has:

- One write port
- Two read ports
- Four internal 4-bit registers

At every positive clock edge, the module checks for rst and write_enable

If rst is asserted, all four internal registers are cleared to 4b'0000. 

now if write_enable is asserted, the value in write_data is stored inside one of the registers that's selected by write_addr. 

Since the write_addr is 2 bits wide, it can select one of the four registers listed below: 

00 -> register 0
01 -> register 1
10 -> register 2 
11 -> register 3 

Verilog allows the binary value of write_addr to be used directly as the index of the register array as shown below: 

```verilog

register[write_adder] <= write_data; 

```
The module also has two independent read ports, allowing two registers to be read at the same time.

Now it selects the respective register by read_addr1 and read_addr2. They both respectively select read_data1 and read_data2

Now the read outputs are asynchronous thus, they don't need to wait for a positive clock edge 

# Testbench

For the testbench, I hardcoded several values to test the different operations of the register file. 

The testbench performs the following simple steps: 

1. Reset all four registers. 
2. Writes 0001 into register 0. 
3. Writes 0100 into register 2. 
4. Read register 0 and 2 at the same time. 
5. Writes 0010 into register 1. 
6. Writes 1000 into register 3.
7. Read registers 1 and 3 at the same time. 
8. Finally clears all the register files again.
# Waveform

![Reg File 4Bit](Images/Reg_file_4bit_waveform.png)

