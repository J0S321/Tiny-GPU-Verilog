`timescale 1ns/1ns
module alu_tb();
    logic [7:0] operand_a, operand_b, accumulator;
    logic [2:0] alu_operation;
    logic [7:0] result;
    logic zeroflag, carry, overflow;

    alu uut
    (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .accumulator(accumulator),
        .alu_operation(alu_operation),
        .result(result),
        .zeroflag(zeroflag),
        .carry(carry),
        .overflow(overflow)
    );

    task check_alu
    (
        input [7:0] a,
        input [7:0] b,
        input [7:0] ac,
        input [2:0] operation,

        input [7:0] expected_result, 
        input expected_zero, 
        input expected_carry,
        input expected_overflow
    );

    begin
        operand_a = a; 
        operand_b = b; 
        accumulator = ac; 
        alu_operation = operation;

        #1; 

        if(result !== expected_result || zeroflag !== expected_zero || carry !== expected_carry || overflow !== expected_overflow)
            begin
                $display("FAIL: A=%d B=%d OP=%b", a, b, operation);
                $display("Expected: result=%d, zero=%b, carry =%b, oveflow=%b", expected_result, expected_zero, expected_carry, expected_overflow);
                $display("Actual: Result =%d, zero =%b carry =%b, overflow =%b", result, zeroflag, carry, overflow);
            end
        else
            begin
                $display("PASS: A =%d, B =%d OP =%b, Ac = %b", a, b, operation, ac);
            end
    end
    endtask

    initial begin
        $dumpfile("waveforms/alu_tb.vcd");
        $dumpvars(0, alu_tb);
        
        check_alu
        (
            8'b0011_0000,  // 48
            8'b0011_0000,  // 48
            8'b0000_0001,  // ACCUMULATOR
            3'b000,        // ADD
            8'b0110_0000,  // 96
            1'b0,          // zero
            1'b0,          // carry
            1'b0           // overflow
        );


        check_alu
        (
            8'b1000_0000, // 128
            8'b1000_0000, // 128
            8'b0000_0001,  // ACCUMULATOR
            3'b000,       // ADD
            8'b0000_0000, // 0
            1'b1,         
            1'b1,         
            1'b1         
        );

        check_alu
        (
            8'b0000_1000, // 8
            8'b0000_1000, // 8
            8'b0000_0001,  // ACCUMULATOR
            3'b001,       // SUB
            8'b0000_0000, //0
            1'b1,   
            1'b1,
            1'b0     
        );

        check_alu
        (
            8'b0000_0010, // 2
            8'b0000_0100, // 4
            8'b0000_0001,  // ACCUMULATOR
            3'b010,       //MUL
            8'b0000_1000, //8
            1'b0,
            1'b0,
            1'b0
        );

        check_alu
        (
            8'b1010_1010,
            8'b0000_1111,
            8'b0000_0001,  // ACCUMULATOR
            3'b011,     //AND
            8'b0000_1010,
            1'b0,
            1'b0,
            1'b0
        );

        check_alu
        (
            8'b1010_1010,
            8'b0000_1111,
            8'b0000_0001,  // ACCUMULATOR
            3'b100,     //OR
            8'b1010_1111,
            1'b0,
            1'b0,
            1'b0
        );

        check_alu
        (
            8'b1111_0000,
            8'b1111_1111,
            8'b0000_0001,  // ACCUMULATOR
            3'b101, //XOR
            8'b0000_1111,
            1'b0,
            1'b0,
            1'b0
        );

        check_alu
        (
            8'b0001_0000,
            8'b1000_0000,
            8'b0000_0001,  // ACCUMULATOR
            3'b110, //MAC
            8'b0000_0001,
            1'b0,
            1'b0,
            1'b1
        );

        $finish; 

    end

endmodule