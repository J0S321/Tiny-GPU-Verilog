
`timescale 1ns/1ns
module compute_core_tb();
    logic clk, rst, core_enable; 

    logic memory_ready, memory_read_enable; 


    logic [7:0] memory_read_data; 
    logic [15:0] instruction; 

    logic halt, memory_write_enable; 
    logic [7:0] pc, memory_address, memory_write_data; 

    localparam NOP   = 4'b0000;
    localparam LDI   = 4'b0001;
    localparam STORE = 4'b0010;
    localparam MOV   = 4'b0011;
    localparam ADD   = 4'b0100;
    localparam SUB   = 4'b0101;
    localparam MUL   = 4'b0110;
    localparam MAC   = 4'b0111;
    localparam AND_OP = 4'b1000;
    localparam OR_OP  = 4'b1001;
    localparam XOR_OP = 4'b1010;
    localparam JMP   = 4'b1011;
    localparam BEQ   = 4'b1100;
    localparam BNE   = 4'b1101;
    localparam LOAD  = 4'b1110;
    localparam HALT  = 4'b1111;


    compute_core uut
    (
        .clk(clk),
        .rst(rst),
        .memory_read_data(memory_read_data),
        .instruction(instruction),
        .memory_ready(memory_ready), 
        .memory_read_enable(memory_read_enable),
        .halt(halt),
        .memory_write_enable(memory_write_enable),
        .pc(pc),
        .memory_address(memory_address),
        .memory_write_data(memory_write_data),
        .core_enable(core_enable)
    );

    logic [7:0] R0;
    logic [7:0] R1;
    logic [7:0] R2;
    logic [7:0] R3;
    logic [7:0] R4;
    logic [7:0] R5;

    always_comb begin
        R0 = uut.register_file_unit.registers[0];
        R1 = uut.register_file_unit.registers[1];
        R2 = uut.register_file_unit.registers[2];
        R3 = uut.register_file_unit.registers[3];
        R4 = uut.register_file_unit.registers[4];
        R5 = uut.register_file_unit.registers[5];
    end

    task test_core
    (
        input [15:0] test_instruction,
        input [7:0] test_memory_read_data,
        input in_core_enable, 
        input in_memory_ready, 
        
        input expected_halt, expected_memory_write_enable,
        input [7:0] expected_pc, expected_memory_address, expected_memory_write_data
    );

    instruction = test_instruction;
    memory_read_data = test_memory_read_data; 
    core_enable = in_core_enable; 
    memory_ready = in_memory_ready; 

    @(posedge clk);
    #1;

    if(halt !== expected_halt) begin
        $fatal(1, "FAIL: HALT expected %d, got %d", expected_halt, halt);
    end

    if(pc !== expected_pc) begin
        $fatal(1, "FAIL: PC expected %d, got %d", expected_pc, pc);
    end

    if(memory_write_enable !== expected_memory_write_enable) begin
        $fatal(1, "FAIL: Memory write enable expected %d, got %d",
                expected_memory_write_enable, memory_write_enable);
    end

if (expected_memory_write_enable) begin
        if (memory_address !== expected_memory_address) begin
            $fatal(1, "FAIL: Memory address expected %d, got %d",
                   expected_memory_address, memory_address);
        end

        if (memory_write_data !== expected_memory_write_data) begin
            $fatal(1, "FAIL: Memory write data expected %d, got %d",
                   expected_memory_write_data, memory_write_data);
        end
    end 

    if (in_core_enable && !in_memory_ready && test_instruction[15:12] == LOAD) begin
        if (memory_read_enable !== 1'b1)
            $fatal(1, "FAIL: stalled LOAD did not request memory");

        if (memory_address !== expected_memory_address)
            $fatal(1, "FAIL: LOAD address expected %h, got %h",
                   expected_memory_address, memory_address);
    end

    endtask

    always #5 clk = ~clk; 

    initial begin
        memory_ready = 0; 
        clk = 0; 
        rst = 1; 
        core_enable = 0;
        instruction = {NOP, 12'd0};
        memory_read_data = 8'd0; 

        $dumpfile("waveforms/compute_core_tb.vcd");
        $dumpvars(0, compute_core_tb);

        @(posedge clk);
        #1; 
        rst = 0; 

        // Test LDI while the core is disabled
        test_core({LDI, 4'd1, 8'd5}, 8'd0, 1'b0, 1'b0, 1'b0, 1'b0, 8'd0, 8'd0, 8'd0);

        if(R1 !== 8'd0)
            $fatal(1, "FAIL: Disabled core wrote to R1");


        // Enable the core and load 5 into R1
        test_core({LDI, 4'd1, 8'd5}, 8'd0, 1'b1,  1'b0, 1'b0, 1'b0, 8'd1, 8'd0, 8'd0);

        // Load 7 into R2
        test_core({LDI, 4'd2, 8'd7}, 8'd0, 1'b1, 1'b0, 1'b0, 1'b0, 8'd2, 8'd0, 8'd0);

        // Add R1 and R2 and store 12 in R3
        test_core({ADD, 4'd3, 4'd1, 4'd2}, 8'd0, 1'b1, 1'b0, 1'b0, 1'b0, 8'd3, 8'd0, 8'd0);

        // Test STORE while the core is disabled
        test_core({STORE, 4'd3, 8'd20}, 8'd0, 1'b0, 1'b0, 1'b0, 1'b0, 8'd3, 8'd0, 8'd0);

        // Store R3 at memory address 20
        test_core({STORE, 4'd3, 8'd20}, 8'd0, 1'b1, 1'b0, 1'b0, 1'b1, 8'd3, 8'd20, 8'd12);

        test_core({STORE, 4'd3, 8'd20}, 8'd0, 1'b1, 1'b0, 1'b0, 1'b1, 8'd3, 8'd20, 8'd12);

        test_core({STORE, 4'd3, 8'd20}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b1, 8'd4, 8'd20, 8'd12);

        // Load 25 from memory address 0x10 into R1
        test_core({LOAD, 4'd1, 8'h10}, 8'd25, 1'b1, 1'b0, 1'b0, 1'b0, 8'd4, 8'h10, 8'd0);
        
        if(R1 !== 8'd5)
            $fatal(1, "R1 changed before LOAD completed: got %0d", R1);

        test_core({LOAD, 4'd1, 8'h10}, 8'd25, 1'b1, 1'b0, 1'b0, 1'b0, 8'd4, 8'h10, 8'd0);
        if(R1 !== 8'd5)
            $fatal(1, "R1 changed before LOAD completed: got %0d", R1);

        test_core({LOAD, 4'd1, 8'h10}, 8'd25, 1'b1, 1'b1, 1'b0, 1'b0, 8'd5, 8'h10, 8'd0);

        if(memory_address !== 8'h10)
            $fatal(1, "FAIL: LOAD expected memory address 0x10, got %h", memory_address);

        if(R1 !== 8'd25)
            $fatal(1, "FAIL: LOAD expected R1=25, got %d", R1);

        // Store R1 at memory address 21
        test_core({STORE, 4'd1, 8'd21}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b1, 8'd6, 8'd21, 8'd25);

        // Move R3 into R4
        test_core({MOV, 4'd4, 4'd3, 4'd0}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b0, 8'd7, 8'd0, 8'd0);

        // Store R4 at memory address 22
        test_core({STORE, 4'd4, 8'd22}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b1, 8'd8, 8'd22, 8'd12);

        // Subtract R3 from R3 and store zero in R5
        test_core({SUB, 4'd5, 4'd3, 4'd3}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b0, 8'd9, 8'd0, 8'd0);

        $display("FINISHED SUB at time %0t, PC = %0d", $time, pc);

        // Store R5 at memory address 23
        test_core({STORE, 4'd5, 8'd23}, 8'd0, 1'b1, 1'b1,  1'b0, 1'b1, 8'd10, 8'd23, 8'd0);

        // BEQ taken because R3 equals R3
        test_core({BEQ, 4'd12, 4'd3, 4'd3}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b0, 8'd12, 8'd0, 8'd0);

        // BEQ not taken because R3 does not equal R2
        test_core({BEQ, 4'd7, 4'd3, 4'd2}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b0, 8'd13, 8'd0, 8'd0);

        // BNE taken because R3 does not equal R2
        test_core({BNE, 4'd6, 4'd3, 4'd2}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b0, 8'd6, 8'd0, 8'd0);

        // BNE not taken because R3 equals R3
        test_core({BNE, 4'd6, 4'd3, 4'd3}, 8'd0, 1'b1, 1'b1, 1'b0, 1'b0, 8'd7, 8'd0, 8'd0);

        // Jump to program address 30
        test_core({JMP, 4'd0, 8'd30}, 8'd0, 1'b1, 1'b1,  1'b0, 1'b0, 8'd30, 8'd0, 8'd0);

        // Test HALT while the core is disabled
        test_core({HALT, 4'd0, 4'd0, 4'd0}, 8'd0, 1'b0, 1'b1, 1'b0, 1'b0, 8'd30, 8'd0, 8'd0);

        // Enable the core and execute HALT
        test_core({HALT, 4'd0, 4'd0, 4'd0}, 8'd0, 1'b1, 1'b1, 1'b1, 1'b0, 8'd30, 8'd0, 8'd0);

        $display("COMPUTE CORE TESTBENCH FINISHED");
        $finish; 
    end

endmodule

