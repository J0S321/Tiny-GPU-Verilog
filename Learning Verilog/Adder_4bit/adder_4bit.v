module adder_4bit
(
    input [3:0] a, b, 
    input carry_in, 
    output [3:0] sum,
    output carry_out
); 

    wire c0, c1, c2; 

    full_adder fa0 
    (
        .a(a[0]),
        .b(b[0]),
        .c(carry_in),
        .sum(sum[0]),
        .carry(c0)
    );

    full_adder fa1 
    (
        .a(a[1]),
        .b(b[1]),
        .c(carry_in),
        .sum(sum[1]),
        .carry(c1)
    );

    full_adder fa2 
    (
        .a(a[2]),
        .b(b[2]),
        .c(carry_in),
        .sum(sum[2]),
        .carry(c2)
    );

    full_adder fa3
    (
        .a(a[3]),
        .b(b[3]),
        .c(carry_in),
        .sum(sum[3]),
        .carry(carry_out)
    );

endmodule
