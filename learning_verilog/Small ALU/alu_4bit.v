module alu_4bit
(
    input [3:0] a, b,
    input [1:0] op, 
    output reg [3:0] result,
    output reg carry_out, zero
);
    wire [3:0] addRes, subRes;
    wire addCarry, subCarry;
    adder_4bit fa1
    (
        .a(a),
        .b(b),
        .carry_in(1'b0),
        .result(addRes),
        .carry_out(addCarry)
    );

    adder_4bit fa2
    (
        .a(a),
        .b(~b),
        .carry_in(1'b1),
        .result(subRes),
        .carry_out(subCarry)
    );


    always @(*) begin
        result = 4'b0000; 
        carry_out = 1'b0;
        zero = 1'b0; 

        if(op == 2'b00) begin //add
            result = addRes; 
            carry_out = addCarry;
        end
        else if(op == 2'b01) begin //sub
            result = subRes;
            carry_out = subCarry; 
        end
        else if(op == 2'b10) begin //and
            result = a & b; 
            carry_out = 1'b0;
        end
        else if(op == 2'b11) begin //or
            result = a | b; 
            carry_out = 1'b0; 
        end
        else begin          //default
            result = 4'b0000;
            carry_out = 1'b0;
        end

        if(result == 4'b0000) begin
            zero = 1'b1;
        end 
        else begin
            zero = 1'b0; 
        end
    end

endmodule