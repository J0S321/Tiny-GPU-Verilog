# Half_Adder

This was the first module I created in Verilog. In VHDL, this would be similar to an entity declaration, but in Verilog it's called a module.



While creating this module, I learned how to declare inputs and outputs using `input` and `output`. in VHDL, ports are usually declared with `in` and `out`, but Verilog uses `input` for signals going in and `output` for signals that are coming out of the module.



One thing I found interesting is that Verilog does not use `std_logic` like VHDL. Instead, Verilog has a built-in 4-state logic system that can represent values like `0`, `1`, `X`, and `Z`.



I also learned how continuous assignments work in Verilog. Instead of using VHDL's `<=` syntax, Verilog can use the `assign` keyword to connect output signals to logic expressions. For example, the sum and carry outputs can be assigned based on the input signals.



# Half_Adder_tb

This is where I learned how to write a Verilog testbench.



Similar to VHDL, the testbench module does not need input or output ports because it isn't meant to be connected to another module. Instead, it creates internal signals that are used to test the design.



In the testbench, I used `reg` for signals that are being controlled by the testbench, like input values. I used `wire` for signals that are driven by the half_adder module, such as the outputs sum and carry.



I learned how to create the module under test. The left side of each connection refers to the original port names from the half_adder module, while the right side refers to the signal created inside the testbench,



For simulation, I used Icarus Verilog with `iverilog` and vvp. This is why the `$dumpfile` and `$dumpvars` to create a `.vcd` waveform file. Then used Surfer to open the waveform and verify that the outputs changed correctly.



The `#10` delays tell the simulator to wait 10 time units before changing to the next input combination. At the end of the test bench, `$finish` is used to stop the simulation



# Waveform



The waveform below shows the Half_adder responding to all possible input combinations



![alt text](https://file%2B.vscode-resource.vscode-cdn.net/Users/joseperez/Desktop/Screenshot%202026-06-30%20at%201.23.11%E2%80%AFAM.png?version%3D1782797045764)



The waveform shows the correct combinational logic for the half adder. When inputs are `0 + 0`, the sum is 0 and the carry is 0. The next two cases, `0 + 1` and `1 + 0`, both produce a sum of 1 with no carry because adding only `1` in binary does nto overflow into the next bit. Finally, when the inputs are `1 + 1` the sum becomes `0` and the carry becomes `1`, since the binary `1 + 1` equals `10`