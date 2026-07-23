# Program Counter

This module is very similar to the `Digit_Counter` that I created previously.

The main difference is that the program counter includes an `enable` input.

If `enable` is asserted, `pc` increments on each positive clock edge. If `enable` is not asserted, `pc` holds its previous value.

The program counter is used to keep track of the address of the current instruction. Since`pc` is 4 bits wide, it can represent addresses from `0000` to `1111`,

# Testbench

The testbench was straightforward because I hard-coded the input values to test each behavior of the program counter.

The testbench shows:

1. `pc` resets to `0000`.
2. `pc` increments while `enable` is asserted.
3. `pc` holds its value while `enable` is de-asserted.
4. Finally, `pc` resets back to `0000` when `rst` is asserted again.

# Waveform

![Program Counter](Images/Program_Counter_waveform.png)