module adder_4bit
(
    input [3:0] a, b, 
    input carry_in,
    output [3:0] result,
    output carry_out
);

wire c1, c2, c3;

full_adder fa0
(
    .a(a[0]),
    .b(b[0]),
    .carry_in(carry_in),
    .sum(result[0]),
    .carry(c1)
);

full_adder fa1
(
    .a(a[1]),
    .b(b[1]),
    .carry_in(c1),
    .sum(result[1]),
    .carry(c2)
);

full_adder fa2
(
    .a(a[2]),
    .b(b[2]),
    .carry_in(c2),
    .sum(result[2]),
    .carry(c3)
);

full_adder fa3
(
    .a(a[3]),
    .b(b[3]),
    .carry_in(c3),
    .sum(result[3]),
    .carry(carry_out)
);





endmodule