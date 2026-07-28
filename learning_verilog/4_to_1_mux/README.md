# Mux 4 to 1
Next I choose a mux because a mux chooses between multiple inputs based on a select signal. This is important for GPU's and CPU's because datapaths need to choose where data comes from, such as registers, immediate values, ALU ouputs and memory. 

With the mux I learned about 'vectors'. Just like in VHDL you initalize vectors from `downto` or `to' format, but you don't include that in the initilization you just do 'N:0' for 'downto' and '0:N' for 'to'. 

I also used an `always` block, which is similar to a process block in VHDL. Fors this mux I used always @(*). The `(*)` syntaax automatically includes all the signals used inside the block in the sensitivity list, which helps prevent mistakes from leaving signals out. 

Inside the always block, I used combinational logic to choose which input should be sent to the output based on the select signal. I wrote the mux with `if/else` statements. Doing these statements is similar to writing it in C/C++. 

I also learned how to write binary values in Verilog. The format is `N'bValue` where `N` is the number of bits and `VALUE` is the binary number.

overall this module helped me understand how Verilog handles vectors, combination always blocks, and select-based logic. 

# Waveform


![alt text](https://file%2B.vscode-resource.vscode-cdn.net/var/folders/gz/4hyd94c553n2rtdjd_ww572r0000gn/T/TemporaryItems/NSIRD_screencaptureui_AnmuUI/Screenshot%202026-07-04%20at%201.46.29%E2%80%AFAM.png?version%3D1783143999729)

The waveform shows correctly how the mux 4 to 1 work. as when `0` is selected then `1` gets outputed, then `1` is selected, `2` gets outputed. Then `2` is selected and `4` is outputed. Finally `3` is selected and then `8` is outputed.