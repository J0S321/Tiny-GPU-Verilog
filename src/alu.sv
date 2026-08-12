module alu
(
    input [7:0] operand_a, operand_b, accumulator,
    input [2:0] alu_operation,
    output logic [7:0] result,
    output logic zeroflag, carry, overflow
);
    logic [8:0] extended_result;
    logic [15:0] product; 

    
    always_comb begin
        result = 8'b0; 
        carry = 1'b0;
        overflow = 1'b0;
        zeroflag = 1'b0; 
        extended_result = 9'b0;
        product = 16'b0; 

        if(alu_operation == 3'b000) //ADD
            extended_result = {1'b0, operand_a} + {1'b0, operand_b};
        else if(alu_operation == 3'b001) //SUB
            extended_result = {1'b0, operand_a} + {1'b0, ~operand_b} + 9'b1;
        else if(alu_operation == 3'b010) //MUL
            product = operand_a * operand_b; 
        else if(alu_operation == 3'b011) //AND
            result = operand_a & operand_b;
        else if(alu_operation == 3'b100) //OR
            result = operand_a | operand_b;
        else if(alu_operation == 3'b101) //XOR
            result = operand_a ^ operand_b;
        else if(alu_operation == 3'b110)//MAC
            product = accumulator + (operand_a * operand_b);
        

        if((alu_operation == 3'b000)|| (alu_operation == 3'b001)) begin
            carry = extended_result[8];
            result = extended_result[7:0];
        end
        else
            carry = 1'b0; 

        //OVERFLOW
        if(alu_operation == 3'b000) //ADD
            overflow = (~(operand_a[7] ^ operand_b[7])) &  (result[7] ^ operand_a[7]);
        else if(alu_operation == 3'b001)//SUB
            overflow = (operand_a[7] ^ operand_b[7]) & (result[7] ^ operand_a[7]);
        else if(alu_operation == 3'b010 || alu_operation == 3'b110) begin //MUL
            result = product[7:0];
            overflow = |product[15:8];
        end
        else
            overflow = 1'b0;

        zeroflag = (result == 8'b0);
    end


endmodule