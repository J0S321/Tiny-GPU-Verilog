`timescale 1ns/1ns

module instruction_memory_tb();

    logic [7:0] pc_0, pc_1, pc_2, pc_3;
    logic [15:0] instruction_0, instruction_1, instruction_2, instruction_3;

    instruction_memory uut
    (
        .pc_0(pc_0),
        .pc_1(pc_1),
        .pc_2(pc_2),
        .pc_3(pc_3),

        .instruction_0(instruction_0),
        .instruction_1(instruction_1),
        .instruction_2(instruction_2),
        .instruction_3(instruction_3)
    );

    task check_instruction_memory
    (
        input [7:0] pc,
        input [15:0] expected_instruction
    );

        pc_0 = pc;
        pc_1 = pc;
        pc_2 = pc;
        pc_3 = pc;

        #1;

        if(instruction_0 !== expected_instruction)
        begin
            $display("FAIL: instruction_0 = %h", instruction_0);
            $display("Expected: %h", expected_instruction);
        end

        if(instruction_1 !== expected_instruction)
        begin
            $display("FAIL: instruction_1 = %h", instruction_1);
            $display("Expected: %h", expected_instruction);
        end

        if(instruction_2 !== expected_instruction)
        begin
            $display("FAIL: instruction_2 = %h", instruction_2);
            $display("Expected: %h", expected_instruction);
        end

        if(instruction_3 !== expected_instruction)
        begin
            $display("FAIL: instruction_3 = %h", instruction_3);
            $display("Expected: %h", expected_instruction);
        end

    endtask


    initial begin

        $dumpfile("waveforms/instruction_memory_tb.vcd");
        $dumpvars(0, instruction_memory_tb);

        check_instruction_memory
        (
            8'd0,
            16'h1105
        );

        check_instruction_memory
        (
            8'd1,
            16'h1207
        );

        check_instruction_memory
        (
            8'd2,
            16'h4312
        );

        check_instruction_memory
        (
            8'd3,
            16'hF000
        );

        $finish;

    end

endmodule