`timescale 1ns/1ns

module memory_arbiter_tb;

    logic clk;
    logic rst;

    // Four core interfaces; index 0 belongs to core 0
    logic [3:0]      core_read_enable;
    logic [3:0]      core_write_enable;
    logic [3:0][7:0] core_address;
    logic [3:0][7:0] core_write_data;
    logic [3:0][7:0] core_read_data;
    logic [3:0]      core_ready;

    // Shared cache interface
    logic       cache_read_enable;
    logic       cache_write_enable;
    logic [7:0] cache_address;
    logic [7:0] cache_write_data;
    logic [7:0] cache_read_data;
    logic       cache_ready;

    memory_arbiter uut (
        .clk(clk),
        .rst(rst),

        .core_read_enable(core_read_enable),
        .core_write_enable(core_write_enable),
        .core_address(core_address),
        .core_write_data(core_write_data),
        .core_read_data(core_read_data),
        .core_ready(core_ready),

        .cache_read_enable(cache_read_enable),
        .cache_write_enable(cache_write_enable),
        .cache_address(cache_address),
        .cache_write_data(cache_write_data),
        .cache_read_data(cache_read_data),
        .cache_ready(cache_ready)
    );

    always #5 clk = ~clk;

    task automatic check(
        input logic condition,
        input string description
    );
        if (condition !== 1'b1) begin
            $display("FAIL at %0t: %s", $time, description);
            $fatal(1);
        end
    endtask

    // Prevent the simulation from running forever if a test gets stuck.
    initial begin
        #1000;
        $fatal(1, "Testbench timed out");
    end

    initial begin
        $dumpfile("memory_arbiter_tb.vcd");
        $dumpvars(0, memory_arbiter_tb);

        clk               = 1'b0;
        rst               = 1'b1;
        core_read_enable  = '0;
        core_write_enable = '0;
        core_address      = '0;
        core_write_data   = '0;
        cache_read_data   = 8'd0;
        cache_ready       = 1'b0;

        // Test 1: No requests
        repeat (2) @(negedge clk);
        rst = 1'b0;
        #1;

        check(cache_read_enable == 0 &&
              cache_write_enable == 0,
              "idle: cache request should be off");

        check(core_ready == 4'b0000,
              "idle: no core should be ready");

        $display("PASS: idle");

        // Test 2: Cores 0 and 2 request together.
        // Fixed priority means core 0 goes first.
        @(negedge clk);
        core_read_enable[0] = 1'b1;
        core_address[0]     = 8'd10;
        core_read_enable[2] = 1'b1;
        core_address[2]     = 8'd22;
        #1;

        check(cache_read_enable == 1 &&
              cache_write_enable == 0 &&
              cache_address == 8'd10,
              "core 0 should win the simultaneous requests");

        check(core_ready == 4'b0000,
              "core 0 must wait while cache_ready is low");

        // The arbiter records core 0 as the active owner.
        @(posedge clk);
        #1;
        @(negedge clk);
        #1;

        check(cache_read_enable == 1 &&
              cache_address == 8'd10,
              "core 2 must not take the cache from core 0");

        check(core_ready == 4'b0000,
              "neither core is ready before the cache responds");

        // Test 3: Complete core 0's delayed read.
        @(negedge clk);
        cache_read_data = 8'd42;
        cache_ready     = 1'b1;
        #1;

        check(core_ready == 4'b0001,
              "only core 0 should receive ready");

        check(core_read_data[0] == 8'd42 &&
              core_read_data[1] == 8'd0 &&
              core_read_data[2] == 8'd0 &&
              core_read_data[3] == 8'd0,
              "only core 0 should receive read data");

        $display("PASS: delayed read and response routing");

        // The arbiter enters its one-clock GAP state.
        @(posedge clk);
        #1;

        check(cache_read_enable == 0 &&
              cache_write_enable == 0 &&
              core_ready == 4'b0000,
              "gap: no cache request or core response");

        // Core 0 stops requesting. Core 2 keeps waiting.
        @(negedge clk);
        core_read_enable[0] = 1'b0;
        cache_ready         = 1'b0;

        @(posedge clk);
        #1;

        check(cache_read_enable == 1 &&
              cache_write_enable == 0 &&
              cache_address == 8'd22,
              "core 2 should get the cache after core 0");

        // Complete core 2's read.
        @(negedge clk);
        cache_read_data = 8'd99;
        cache_ready     = 1'b1;
        #1;

        check(core_ready == 4'b0100,
              "only core 2 should receive ready");

        check(core_read_data[2] == 8'd99 &&
              core_read_data[0] == 8'd0 &&
              core_read_data[1] == 8'd0 &&
              core_read_data[3] == 8'd0,
              "only core 2 should receive read data");

        $display("PASS: simultaneous requests, core 0 then core 2");

        @(posedge clk);
        #1;

        check(cache_read_enable == 0 &&
              cache_write_enable == 0,
              "second completed read should enter the gap");

        @(negedge clk);
        core_read_enable[2] = 1'b0;
        cache_ready         = 1'b0;

        @(posedge clk);
        #1;

        check(core_ready == 4'b0000,
              "no core should be ready after requests end");

        // Test 4: Core 3 writes 55 to address 20.
        @(negedge clk);
        core_write_enable[3] = 1'b1;
        core_address[3]      = 8'd20;
        core_write_data[3]   = 8'd55;
        #1;

        check(cache_read_enable == 0 &&
              cache_write_enable == 1 &&
              cache_address == 8'd20 &&
              cache_write_data == 8'd55,
              "core 3 write address and data should reach the cache");

        check(core_ready == 4'b0000,
              "core 3 must wait for write completion");

        @(posedge clk);
        #1;

        @(negedge clk);
        cache_ready = 1'b1;
        #1;

        check(core_ready == 4'b1000,
              "only core 3 should receive write completion");

        $display("PASS: write routing");

        @(posedge clk);
        #1;

        check(cache_read_enable == 0 &&
              cache_write_enable == 0,
              "completed write should enter the gap");

        @(negedge clk);
        core_write_enable[3] = 1'b0;
        cache_ready          = 1'b0;

        @(posedge clk);
        #1;

        // Test 5: Core 1 gets an immediate cache response.
        @(negedge clk);
        core_read_enable[1] = 1'b1;
        core_address[1]     = 8'd33;
        cache_read_data     = 8'd77;
        cache_ready         = 1'b1;
        #1;

        check(cache_read_enable == 1 &&
              cache_address == 8'd33,
              "core 1 immediate read should reach the cache");

        check(core_ready == 4'b0010 &&
              core_read_data[1] == 8'd77,
              "core 1 should receive the immediate response");

        $display("PASS: immediate response");

        @(posedge clk);
        #1;

        check(cache_read_enable == 0 &&
              cache_write_enable == 0 &&
              core_ready == 4'b0000,
              "immediate response should also enter the gap");

        $display("ALL MEMORY ARBITER TESTS PASSED");
        $finish;
    end
endmodule