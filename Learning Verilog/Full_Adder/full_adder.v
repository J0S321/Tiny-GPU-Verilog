module full_adder 
(
    input a, b, c,
    output carry, sum //assigning inputs and outputs 
);
    assign carry = ((a ^ b) & c) | (a & b); //makign carry eqaul to the carry bool equation 
    assign sum = ((a ^ b) ^ c); //making sum equal to the sum bool equation for full adder
endmodule