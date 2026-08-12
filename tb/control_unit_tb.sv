`timescale 1ns/1ns
module control_unit_tb();
    logic zeroflag; 
    logic [3:0] opcode;
    logic reg_write_enable, pc_load, mem_write, halt; 
    logic [1:0] writeback_select;
    logic [2:0] alu_operation;

    control_unit uut
    (
        .zeroflag(zeroflag),
        .opcode(opcode), 
        .reg_write_enable(reg_write_enable),
        .pc_load(pc_load),
        .mem_write(mem_write),
        .halt(halt),
        .writeback_select(writeback_select), 
        .alu_operation(alu_operation)
    );

    task check_control_unit
    (
        input [3:0] test_opcode,
        input test_zeroflag,  

        input expected_reg_write,
        input expected_pc_load,
        input expected_mem_write, 
        input expected_halt,
        input [1:0] ex_writeback_select,
        input [2:0] expected_alu_operation
    );
        zeroflag = test_zeroflag;
        opcode = test_opcode; 

        #1; 

        if(reg_write_enable !== expected_reg_write)
            begin
                $display("FAIL: reg_write = %d", reg_write_enable);
                $display("Expected: %d", expected_reg_write);
            end
        else if(pc_load !== expected_pc_load)
            begin
                $display("FAIL: pc_load = %d", pc_load);
                $display("Expected: %d", expected_pc_load);
            end
        else if(mem_write !== expected_mem_write)
            begin
                $display("FAIL: mem_write = %d", mem_write);
                $display("Expected: %d", expected_mem_write);
            end
        else if(halt !== expected_halt)
            begin
                $display("FAIL: halt = %d", halt);
                $display("Expected: %d", expected_halt);
            end
        else if(alu_operation !== expected_alu_operation)
            begin
                $display("FAIL: alu_operation = %d", alu_operation);
                $display("Expected: %d", expected_alu_operation);
            end
        else if(writeback_select !== ex_writeback_select)
            begin
                $display("FAIL: writeback_select = %b", writeback_select);
                $display("Expected: %b", ex_writeback_select);
            end
        else
            $display(
                "PASS: opcode=%b, reg_write=%b, pc_load=%b, mem_write=%b, halt=%b, writeback_select = %b, alu_operation=%b",
                opcode,
                reg_write_enable,
                pc_load,
                mem_write,
                halt,
                writeback_select, 
                alu_operation
            );
    endtask

    initial begin
    $dumpfile("waveforms/control_unit_tb.vcd");
    $dumpvars(0, control_unit_tb);

        // NOP
        check_control_unit
        (
            4'b0000,
            1'b0,

            1'b0, // reg_write
            1'b0, // pc_load
            1'b0, // mem_write
            1'b0, // halt
            2'b00,
            3'b000
        );

        // LOAD
        check_control_unit
        (
            4'b0001,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b10,
            3'b000
        );

        // STORE
        check_control_unit
        (
            4'b0010,
            1'b0,

            1'b0,
            1'b0,
            1'b1,
            1'b0,
            2'b00,
            3'b000
        );

        // MOV
        check_control_unit
        (
            4'b0011,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b11,
            3'b000
        );

        // ADD
        check_control_unit
        (
            4'b0100,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b01,
            3'b000
        );

        // SUB
        check_control_unit
        (
            4'b0101,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b01, 
            3'b001
        );

        // MUL
        check_control_unit
        (
            4'b0110,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b01,
            3'b010
        );

        // MAC
        check_control_unit
        (
            4'b0111,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b01,
            3'b110
        );

        // AND
        check_control_unit
        (
            4'b1000,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b01,
            3'b011
        );

        // OR
        check_control_unit
        (
            4'b1001,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b01, 
            3'b100
        );

        // XOR
        check_control_unit
        (
            4'b1010,
            1'b0,

            1'b1,
            1'b0,
            1'b0,
            1'b0,
            2'b01, 
            3'b101
        );

        // JMP
        check_control_unit
        (
            4'b1011,
            1'b0,

            1'b0,
            1'b1,
            1'b0,
            1'b0,
            2'b00,
            3'b000
        );

        // BEQ - condition false
        check_control_unit
        (
            4'b1100,
            1'b0,

            1'b0,
            1'b0,
            1'b0,
            1'b0,
            2'b00,
            3'b001
        );

        // BEQ - condition true
        check_control_unit
        (
            4'b1100,
            1'b1,

            1'b0,
            1'b1,
            1'b0,
            1'b0,
            2'b00,
            3'b001
        );

        // BNE - condition true
        check_control_unit
        (
            4'b1101,
            1'b0,

            1'b0,
            1'b1,
            1'b0,
            1'b0,
            2'b00,
            3'b001
        );

        // BNE - condition false
        check_control_unit
        (
            4'b1101,
            1'b1,

            1'b0,
            1'b0,
            1'b0,
            1'b0,
            2'b00,
            3'b001
        );

        // HALT
        check_control_unit
        (
            4'b1111,
            1'b0,

            1'b0,
            1'b0,
            1'b0,
            1'b1,
            2'b00,
            3'b000
        );

        $finish;
    end

endmodule