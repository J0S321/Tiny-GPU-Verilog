module adder_4bit_tb();

    reg [3:0] a, b;
    reg carry_in;
    wire [3:0] sum;
    wire carry_out; 

    integer i;
    reg [4:0] expected;

    adder_4bit uut
    (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin

        $dumpfile("adder_4bit.vcd");
        $dumpvars(0, adder_4bit_tb);

        for (i = 0; i < 512; i = i + 1) begin
            {carry_in, a, b} = i;
            #10;

        end

        $finish;

    end

endmodule