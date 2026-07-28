# Full Adder
The next module I made was a full adder. This module builds on the idea of the half adder, but it adds a third input called `carry_in` or as I named it c in the module. 

A half adder only adds two bit 1 valeus while the full adder adds three 1-bit values, `a`, `b`, `c`. The ouput sum represents the low bit of the result while c represents wethere the addition has overflowed into the next binary place. 


# Full Adder TB
For this testbench, I tested all posible input combinations for `a`, `b` and `carry_in`

There wasn't any new syntax I learned compared tot hehalf adder testbench, but looking back, this would have been a good place to use a `for` loop instead of hard-coding each input combination manually. Since a full adder has three inputs thus it produce `8` total combinations. 

# Waveform

the waveform below shows the full adder responding to all of the input combinations.

[alt text](https://file%2B.vscode-resource.vscode-cdn.net/Users/joseperez/Desktop/Screenshot%202026-06-30%20at%201.38.40%E2%80%AFAM.png?version%3D1782797933496)

the waveform shows the correct behavior for a full adder, the adder adds a, b, and carry_in together. If the total is '0' then output is `sum = 0` and `carry_out = 0`. if the total is 1, the output is `sum = 1` and `carry_out = 0`. When the total reachs `2`, the result in base two is `10`. this means the lower bit becomes `0`, so `sum = 0`, and the overflow bit becomes `1`, so `carry_out = 1`. when all three inputs are `1` the total is then `3` whichs i 11 in binary. This means that both `sum` and `carry_out` are equal to `1`.

Overall, the waveform confirms that the full adder is correctly adding all three inputs and producing the correct `sum` and `carry_out` values. 