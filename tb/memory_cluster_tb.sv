`timescale 1ns/1ns

module memory_cluster_tb();
    logic clk;
    logic rst;
    logic [3:0]      core_read_enable;
    logic [3:0]      core_write_enable;
    logic [3:0][7:0] core_address;
    logic [3:0][7:0] core_write_data;
    logic [3:0][7:0] core_read_data;
    logic [3:0]      core_ready;

    memory_cluster uut (
        .clk(clk),
        .rst(rst),
        .core_read_enable(core_read_enable),
        .core_write_enable(core_write_enable),
        .core_address(core_address),
        .core_write_data(core_write_data),
        .core_read_data(core_read_data),
        .core_ready(core_ready)
    );

    always #5 clk = ~clk;

    task automatic check
    (
        input logic condition,
        input string description
    );
        if (condition !== 1'b1) begin
            $display("FAIL at %0t: %s", $time, description);
            $fatal(1);
        end
    endtask

    initial begin
        #1000;
        $fatal(1, "Timeout waiting for memory cluster test to finish");
    end

    initial begin
        $dumpfile("memory_cluster_tb.vcd");
        $dumpvars(0, memory_cluster_tb);

        clk = 1'b0;
        rst = 1'b1;
        core_read_enable  = '0;
        core_write_enable = '0;
        core_address      = '0;
        core_write_data   = '0;

        repeat (2) @(negedge clk);
        rst = 1'b0;
        #1;
        check(core_ready === 4'b0000, "No core ready after reset");

        // 1. Write miss: write 34 to address 84.
        @(negedge clk);
        core_write_enable[0] = 1'b1;
        core_address[0]      = 8'h84;
        core_write_data[0]   = 8'h34;

        wait (core_ready[0] === 1'b1);
        #1;
        check(core_ready === 4'b0001,
              "Only core 0 gets write ready");
        check(uut.cache_int.cache_line_match === 1'b0,
              "First write should miss the cache");
        check(uut.memory_write_enable === 1'b1 &&
              uut.memory_address === 8'h84 &&
              uut.memory_write_data === 8'h34,
              "Write should reach data memory");

        @(negedge clk);
        check(uut.cache_int.cache_valid[4] === 1'b0,
              "Write miss should not allocate a cache line");
        core_write_enable[0] = 1'b0;
        $display("PASS: write miss");

        @(negedge clk); // Let the arbiter leave GAP.

        // 2. Read miss: read 84 and fill the cache.
        core_read_enable[2] = 1'b1;
        core_address[2]     = 8'h84;

        wait (core_ready[2] === 1'b1);
        #1;
        check(core_ready === 4'b0100,
              "Only core 2 gets read ready");
        check(uut.cache_hit === 1'b0,
              "First read should miss the cache");
        check(uut.memory_read_enable === 1'b1,
              "Read miss should access data memory");
        check(core_read_data[2] === 8'h34,
              "Read miss should return the value core 0 wrote");

        @(negedge clk);
        check(uut.cache_int.cache_valid[4] === 1'b1 &&
              uut.cache_int.cache_tag[4] === 4'h8 &&
              uut.cache_int.cache_data[4] === 8'h34,
              "Read miss should fill the cache entry");
        core_read_enable[2] = 1'b0;
        $display("PASS: read miss and cache fill");

        @(negedge clk);

        // 3. Write hit: update cached address 84 to 32.
        core_write_enable[3] = 1'b1;
        core_address[3]      = 8'h84;
        core_write_data[3]   = 8'h32;

        wait (core_ready[3] === 1'b1);
        #1;
        check(core_ready === 4'b1000,
              "Only core 3 gets write ready");
        check(uut.cache_int.cache_line_match === 1'b1,
              "Core 3's write should hit the cache");
        check(uut.memory_write_enable === 1'b1 &&
              uut.memory_address === 8'h84 &&
              uut.memory_write_data === 8'h32,
              "Write-through should update data memory");

        @(negedge clk);
        check(uut.cache_int.cache_data[4] === 8'h32,
              "Write hit should update cached data");
        core_write_enable[3] = 1'b0;
        $display("PASS: write hit");

        @(negedge clk);

        // 4. Read hit: another core reads the updated value.
        core_read_enable[1] = 1'b1;
        core_address[1]     = 8'h84;

        wait (core_ready[1] === 1'b1);
        #1;
        check(core_ready === 4'b0010,
              "Only core 1 gets read ready");
        check(core_read_data[1] === 8'h32,
              "Read hit should return the updated value");
        check(uut.cache_hit === 1'b1,
              "Core 1's read should hit");
        check(uut.memory_read_enable === 1'b0,
              "Read hit should not access data memory");

        @(negedge clk);
        core_read_enable[1] = 1'b0;
        $display("PASS: read hit");

        // 5. Simultaneous requests: core 0 has priority over core 2.
        core_read_enable[0]  = 1'b1;
        core_address[0]      = 8'h84;
        core_write_enable[2] = 1'b1;
        core_address[2]      = 8'h85;
        core_write_data[2]   = 8'h5A;

        wait (core_ready[0] === 1'b1);
        #1;
        check(core_ready === 4'b0001,
              "Only core 0 should get ready first");
        check(core_read_data[0] === 8'h32,
              "Core 0 should read the cached value");
        check(uut.cache_hit === 1'b1,
              "Core 0's read should hit");

        @(posedge clk);
        #1;
        check(core_ready === 4'b0000,
              "Arbiter should enter GAP");

        @(negedge clk);
        core_read_enable[0] = 1'b0;

        wait (core_ready[2] === 1'b1);
        #1;
        check(core_ready === 4'b0100,
              "Core 2 should get write ready");
        check(uut.memory_write_enable === 1'b1 &&
              uut.memory_address === 8'h85 &&
              uut.memory_write_data === 8'h5A,
              "Core 2's write should reach data memory");

        @(posedge clk);
        #1;
        @(negedge clk);
        core_write_enable[2] = 1'b0;
        $display("PASS: simultaneous requests served in priority order");

        // 6. Read back core 2's write. The write miss did not allocate 85.
        @(negedge clk);
        core_read_enable[3] = 1'b1;
        core_address[3]     = 8'h85;

        wait (core_ready[3] === 1'b1);
        #1;
        check(core_ready === 4'b1000,
              "Only core 3 gets read ready");
        check(uut.cache_hit === 1'b0,
              "Read after write miss should miss");
        check(uut.memory_read_enable === 1'b1,
              "Read miss should access memory");
        check(core_read_data[3] === 8'h5A,
              "Core 3 should read core 2's write");

        @(negedge clk);
        core_read_enable[3] = 1'b0;
        $display("PASS: readback after write miss");

        @(negedge clk); // Let the arbiter leave GAP before the next write.

        // 7. Tag replacement: 94 and 84 both use cache index 4.
        // First write 6B to memory address 94. A write miss does not replace 84.
        core_write_enable[0] = 1'b1;
        core_address[0]      = 8'h94;
        core_write_data[0]   = 8'h6B;

        wait (core_ready[0] === 1'b1);
        #1;
        check(core_ready === 4'b0001,
              "Only core 0 gets write ready");
        check(uut.cache_int.cache_line_match === 1'b0,
              "94 should miss while 84 occupies index 4");

        @(negedge clk);
        check(uut.cache_int.cache_tag[4] === 4'h8,
              "Write miss should leave 84 cached");
        core_write_enable[0] = 1'b0;

        @(negedge clk);

        // Reading 94 misses and replaces index 4 with tag 9.
        core_read_enable[1] = 1'b1;
        core_address[1]     = 8'h94;

        wait (core_ready[1] === 1'b1);
        #1;
        check(core_ready === 4'b0010,
              "Only core 1 gets read ready");
        check(uut.cache_hit === 1'b0,
              "First read of 94 should miss");
        check(core_read_data[1] === 8'h6B,
              "94 should contain 6B");

        @(negedge clk);
        check(uut.cache_int.cache_valid[4] === 1'b1 &&
              uut.cache_int.cache_tag[4] === 4'h9 &&
              uut.cache_int.cache_data[4] === 8'h6B,
              "94 should replace 84 at cache index 4");
        core_read_enable[1] = 1'b0;

        @(negedge clk);

        // Reading 84 again misses and replaces tag 9 with tag 8.
        core_read_enable[2] = 1'b1;
        core_address[2]     = 8'h84;

        wait (core_ready[2] === 1'b1);
        #1;
        check(core_ready === 4'b0100,
              "Only core 2 gets read ready");
        check(uut.cache_hit === 1'b0,
              "84 should miss after replacement");
        check(core_read_data[2] === 8'h32,
              "84 should retain its value in data memory");

        @(negedge clk);
        check(uut.cache_int.cache_valid[4] === 1'b1 &&
              uut.cache_int.cache_tag[4] === 4'h8 &&
              uut.cache_int.cache_data[4] === 8'h32,
              "Reading 84 should replace 94 at cache index 4");
        core_read_enable[2] = 1'b0;
        $display("PASS: cache tag replacement");

        $display("ALL MEMORY CLUSTER TESTS PASSED");
        $finish;
    end
endmodule