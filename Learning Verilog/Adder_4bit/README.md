# 4-Bit Adder

The 4-bit adder was not too difficult to create becuase I reused the full-adder module that I had created previously. 

This module taught me how to create multiple modules inside another module. The syntax is similar to when your creating a unit under test in the test bench, except the four full adders are connected together to create a larger circuit. 

Each full adder handles on bit of a and b, the carry output from one full adder becomes the carry input of the next full adder. 

To connect the carry signals between the full adders, I declared three internal wires: 

```verilog
    wire c0, c1, c2;
```

These wires represent the carry values between eachs tage of the 4-bit adder. 

The final carry output from the most significant full adder then becomes the module's `carry_out`. 

# Testbench

while creating the testbnech, I learned how to declare an integer in Verilog.

```verilog
integer i;
```

Now what caught me off guard was the Verilog uses the traditional `integer` keyword rather than just `int` like many other languages.

Now this variable was used as the control variable for a `for` loop. The structure is very similar to a `for` loop in C or C+

```c 
    for(starting_value, condition; increment)
``` 

Now the only difference is that Verilog adds a `begin` and `end`:

```verilog
    for(i = 0; i < 512, i = i + 1) begin
        {carry_in, a, b} = i;
    #10;
end
```
Now the loop tests all of the 512 possible input combinations. There's 512 possible combinations becomes there is four bits in both `A` and `B` and one `carry_in` bit thus giving us '2^9 = 512'

The final thing I learned is that Verilog does not requre a function like `to_unsigned` or `to_integer` for this type of assignments. 

```verilog
{carry_in, a, b} = 1;
```

In this statement, Verilog automatically assigns the binary representation of `i` to the combined input signals. 

# Waveform
![Full Adder 4Bits](images/Full_Adder_4bit_waveform.png)

This is a better version of the Waveform 
![Full Adder 4Bits Zoomed In](Full_Adder_4bit_Waveform_zoomed_in.png)