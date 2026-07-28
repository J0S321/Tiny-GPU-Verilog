# Small ALU

Now this project is starting to get more interesting!

This module is a small 4-bit ALU that performs addition, subtraction, and simple logic operations like `AND` and `OR`

For this module, I reused the 4-bit adder that I created previously. The 4-bit adder itself is built using four full-adder modules, which I reused as well

The operations performed by the ALU are selected using the `op` input. Depending on the value of `op,` the ALU outputs the result of either addition, subtraction, AND, or OR.

One improvement I could make looking back is I can use a control signal that allows the same 4-bit adder to perform both addition and subtraction.

Now the way subtraction was performed here was using two's complement:

```verilog

A - B = A + (~B) + 1

```

When subtracting, `B` would be inverted and the adder's `carry_in` would be set to `1`. When adding, `B` would stay the same and `carry_in` would be set to `0`.

Although this module did not introduce much new Verilog syntax, it helped me understand how previous modules can be reused to build a larger component.

This really felt like I was playing with LEGOs

# Testbench

Now the testbench was straightforward since I hardcoded several input values to verify that every ALU operation worked correctly.

For each test, I selected an operation using `op`, assigned values to `a` and `b`, and checked the resulting output in the waveform.

# Waveform

![Small ALU](Images/Small_ALU_waveform.png)