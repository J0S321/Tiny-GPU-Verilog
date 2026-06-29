module alu_4bit_tb(); 
    reg [3:0] a, b;
    reg [1:0] op;
    wire [3:0] result;
    wire carry_out, zero;

    alu_4bit uut
    (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .carry_out(carry_out),
        .zero(zero)
    );

    initial begin

        $dumpfile("alu_4bit_tb.vcd");
        $dumpvars(0, alu_4bit_tb);
        
        op = 2'b00; a = 4'b1010; b = 4'b0101; #40; //add 10 + 5 = 15
        op = 2'b01; a = 4'b1001; b = 4'b0001; #40; //sub 9 - 1 = 8
        op = 2'b10; a = 4'b1100; b = 4'b0011; #40; //and a/b
        op = 2'b11; a = 4'b1101; b = 4'b1111; #40;


        $finish; 
        
    end

endmodule