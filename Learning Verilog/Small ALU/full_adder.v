module full_adder 
(
    input a, b, carry_in,
    output carry, sum //assigning inputs and outputs 
);
    assign carry = ((a ^ b) & carry_in) | (a & b); //makign carry eqaul to the carry bool equation 
    assign sum = ((a ^ b) ^ carry_in); //making sum equal to the sum bool equation for full adder
endmodule