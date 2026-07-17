module mux_4_to_1_tb; 

    reg [1:0] sel;
    wire [3:0] out;

    mux_4_to_1 uut
    (
        .in0(4'b0001),
        .in1(4'b0010),
        .in2(4'b0100),
        .in3(4'b1000),
        .sel(sel),
        .out(out)
    ); 

    initial begin

        $dumpfile("mux_4_to_1.vcd"); 
        $dumpvars(0, mux_4_to_1_tb);

        sel = 2'b00; #10; 
        sel = 2'b01; #10; 
        sel = 2'b10; #10;
        sel = 2'b11; #10; 

        $finish; 
    end


endmodule