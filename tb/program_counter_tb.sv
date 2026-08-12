`timescale 1ns/1ns
module program_counter_tb();
    logic clk, rst, pc_load, halt;
    logic [7:0] next_pc; 
    logic [7:0] pc; 

    program_counter uut
    (
        .clk(clk),
        .rst(rst),
        .pc_load(pc_load),
        .halt(halt),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk; 

    task check_pc 
    (
        input expected_rst,
        input expected_pc_load, 
        input expected_halt,
        input [7:0] expected_next_pc, 
        input [7:0] expected_pc
    );

        begin 
            rst = expected_rst; 
            pc_load = expected_pc_load; 
            next_pc = expected_next_pc; 
            halt = expected_halt; 

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

        check_pc
        (
            1'b1,
            1'b0,
            1'b0,
            8'b0011_1111,
            8'd0
        );

        check_pc
        (
            1'b0,
            1'b0, 
            1'b0, 
            8'b0011_1111,
            8'b1
        );

        check_pc
        (
            1'b0,
            1'b0,
            1'b0, 
            8'b0011_1111,
            8'd2
        );
        
        check_pc
        (
            1'b0,
            1'b0,
            1'b0, 
            8'b0011_1111,
            8'd3
        );

        check_pc
        (
            1'b0,
            1'b0,
            1'b0, 
            8'b0011_1111,
            8'd4
        );

        check_pc
        (
            1'b0,
            1'b0,
            1'b0,
            8'b0011_1111,
            8'd5
        );

        check_pc
        (
            1'b0,
            1'b0,
            1'b0, 
            8'b0011_1111,
            8'd6
        );
    
        check_pc
        (
            1'b0,
            1'b0,
            1'b0, 
            8'b0011_1111,
            8'd7
        );

        check_pc
        (
            1'b0,
            1'b1,
            1'b0, 
            8'b0011_1111,
            8'b0011_1111
        );

        check_pc
        (
            1'b1,
            1'b0,
            1'b0, 
            8'b0000_0000,
            8'b0000_0000
        );

        check_pc
        (
            1'b1,
            1'b0,
            1'b0,
            8'b0011_1111,
            8'd0
        );

        check_pc
        (
            1'b0,
            1'b0, 
            1'b0, 
            8'b0011_1111,
            8'b1
        );

        check_pc
        (
            1'b0,
            1'b0, 
            1'b1, 
            8'b0011_1111,
            8'b1
        );

        check_pc
        (
            1'b0,
            1'b0, 
            1'b1, 
            8'b0011_1111,
            8'b1
        );




        $finish; 
        
        

    end





endmodule