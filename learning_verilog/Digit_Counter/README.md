# Digit_Counter 
The next module I created was a 2-bit counter. Since `sel` is only 2 bits wide, it can only represent values from 0 through 3. 

The counter follows the sequence: 
`00` -> `01` -> `10` -> `11` -> `00`

after reaching `11`, adding one causes the value to overlfow and wrap back to `00`. 

During this module, I also learned how to increment a value in Verilog using the following line: 

`sel <= sel + 1;`


# Testbench
Since this module uses a clock, I learned how to create a clcok signal inside a Verilog testbench. 

The clock is created inside a procedural `initial` block. Just lik ein VHDL, the clock must first be initialized then you have to continously update it by inverting its current value. 

```Verilog
initial begin
    clk = 0; 
    forever #5 clk = ~clk; 
end
```



# Waveform
![Digit counter waveform](images/Digit_Counter_waveform.png)
