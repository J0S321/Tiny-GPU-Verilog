`timescale 1ns/1ns
module program_counter_tb();
    logic clk, rst, pc_load, halt, enabled; 
    logic [7:0] next_pc; 
    logic [7:0] pc; 

    program_counter uut
    (
        .clk(clk),
        .rst(rst),
        .pc_load(pc_load),
        .halt(halt),
        .next_pc(next_pc),
        .pc(pc),
        .enabled(enabled)
    );

    always #5 clk = ~clk; 

    task check_pc 
    (
        input expected_rst,
        input expected_pc_load, 
        input expected_halt,
        input in_enabled,
        input [7:0] expected_next_pc, 
        input [7:0] expected_pc
    );

        begin 
            rst = expected_rst; 
            pc_load = expected_pc_load; 
            next_pc = expected_next_pc; 
            halt = expected_halt; 
            enabled = in_enabled; 

            @(posedge clk);
            #1; 

            if(pc !== expected_pc)
                begin
                    $display("FAIL: rst=%b, pc_load=%b, next_pc=%d, halt = %d", rst, pc_load, next_pc, halt);
                    $display("Expected pc=%d, Actual pc=%d", expected_pc, pc);
                end

            else
                begin
                    $display("PASS: pc=%d", pc); 
                end

        end

    endtask



    initial begin
        clk = 0; 
        rst = 1; 
        pc_load = 0; 
        next_pc = 0; 
        halt = 0; 

        $dumpfile("waveforms/program_counter_tb.vcd");
        $dumpvars(0, program_counter_tb);

        // Reset while disabled: reset should still work
        check_pc(1'b1, 1'b0, 1'b0, 1'b0, 8'd0, 8'd0);

        // Enable PC and increment
        check_pc(1'b0, 1'b0, 1'b0, 1'b1, 8'd0, 8'd1);
        check_pc(1'b0, 1'b0, 1'b0, 1'b1, 8'd0, 8'd2);

        // Disable PC: it should remain at 2
        check_pc(1'b0, 1'b0, 1'b0, 1'b0, 8'd0, 8'd2);
        check_pc(1'b0, 1'b0, 1'b0, 1'b0, 8'd0, 8'd2);

        // Re-enable: continue from 2
        check_pc(1'b0, 1'b0, 1'b0, 1'b1, 8'd0, 8'd3);

        // Load 63 while enabled
        check_pc(1'b0, 1'b1, 1'b0, 1'b1, 8'd63, 8'd63);

        // Attempt another load while disabled: remain at 63
        check_pc(1'b0, 1'b1, 1'b0, 1'b0, 8'd100, 8'd63);

        // Halt while enabled: remain at 63
        check_pc(1'b0, 1'b0, 1'b1, 1'b1, 8'd0, 8'd63);

        // Release halt: increment to 64
        check_pc(1'b0, 1'b0, 1'b0, 1'b1, 8'd0, 8'd64);

        // Reset again
        check_pc(1'b1, 1'b0, 1'b0, 1'b0, 8'd0, 8'd0);

        $finish; 
        
    end





endmodule