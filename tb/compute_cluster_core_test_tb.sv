`timescale 1ns/1ns
module compute_cluster_core_test_tb();

logic clk, rst, start;
logic [2:0] thread_count;
logic [15:0] instruction_0, 
    instruction_1, 
    instruction_2, 
    instruction_3; 
logic [7:0] memory_read_data_0, 
    memory_read_data_1, 
    memory_read_data_2, 
    memory_read_data_3;

logic done;

logic memory_read_enable_0, 
    memory_read_enable_1, 
    memory_read_enable_2, 
    memory_read_enable_3;

logic memory_write_enable_0,
    memory_write_enable_1, 
    memory_write_enable_2, 
    memory_write_enable_3; 

logic [7:0] pc_0, pc_1, pc_2, pc_3;
logic [7:0] memory_address_0, 
    memory_address_1, 
    memory_address_2,
     memory_address_3;
logic [7:0] memory_write_data_0, 
    memory_write_data_1,
    memory_write_data_2,
    memory_write_data_3;



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
compute_cluster uut
(
    .clk(clk),
    .rst(rst),
    .start(start),

    .thread_count(thread_count),
    .instruction_0(instruction_0),
    .instruction_1(instruction_1),
    .instruction_2(instruction_2),
    .instruction_3(instruction_3),

    .memory_read_data_0(memory_read_data_0),
    .memory_read_data_1(memory_read_data_1),
    .memory_read_data_2(memory_read_data_2),
    .memory_read_data_3(memory_read_data_3),
    
    .done(done),

    .memory_write_enable_0(memory_write_enable_0),
    .memory_write_enable_1(memory_write_enable_1),
    .memory_write_enable_2(memory_write_enable_2),
    .memory_write_enable_3(memory_write_enable_3),

    .memory_read_enable_0(memory_read_enable_0),
    .memory_read_enable_1(memory_read_enable_1),
    .memory_read_enable_2(memory_read_enable_2),
    .memory_read_enable_3(memory_read_enable_3),

    .pc_0(pc_0),
    .pc_1(pc_1),
    .pc_2(pc_2),
    .pc_3(pc_3),
    
    .memory_address_0(memory_address_0),
    .memory_address_1(memory_address_1),
    .memory_address_2(memory_address_2),
    .memory_address_3(memory_address_3),

    .memory_write_data_0(memory_write_data_0),
    .memory_write_data_1(memory_write_data_1),
    .memory_write_data_2(memory_write_data_2),
    .memory_write_data_3(memory_write_data_3)
);

task test_cluster 
(

    input [7:0] in_memory_read_data_0, 
        in_memory_read_data_1, 
        in_memory_read_data_2, 
        in_memory_read_data_3,

    input ex_done, 
    input ex_memory_write_enable_0, 
        ex_memory_write_enable_1, 
        ex_memory_write_enable_2, 
        ex_memory_write_enable_3, 

    input [7:0] ex_pc_0, ex_pc_1, ex_pc_2, ex_pc_3, 

    input [7:0] ex_memory_address_0, 
        ex_memory_address_1, 
        ex_memory_address_2, 
        ex_memory_address_3, 

    input [7:0] ex_write_data_0, 
        ex_write_data_1, 
        ex_write_data_2, 
        ex_write_data_3,

    input ex_memory_read_enable_0, 
        ex_memory_read_enable_1, 
        ex_memory_read_enable_2, 
        ex_memory_read_enable_3

);
    begin
        @(negedge clk);

        memory_read_data_0 = in_memory_read_data_0;
        memory_read_data_1 = in_memory_read_data_1;
        memory_read_data_2 = in_memory_read_data_2;
        memory_read_data_3 = in_memory_read_data_3;


        #1;
        if (
            (done === ex_done) &&

            (memory_write_enable_0 === ex_memory_write_enable_0) &&
            (memory_write_enable_1 === ex_memory_write_enable_1) &&
            (memory_write_enable_2 === ex_memory_write_enable_2) &&
            (memory_write_enable_3 === ex_memory_write_enable_3) &&

            (pc_0 === ex_pc_0) &&
            (pc_1 === ex_pc_1) &&
            (pc_2 === ex_pc_2) &&
            (pc_3 === ex_pc_3) &&

            (memory_address_0 === ex_memory_address_0) &&
            (memory_address_1 === ex_memory_address_1) &&
            (memory_address_2 === ex_memory_address_2) &&
            (memory_address_3 === ex_memory_address_3) &&

            (memory_write_data_0 === ex_write_data_0) &&
            (memory_write_data_1 === ex_write_data_1) &&
            (memory_write_data_2 === ex_write_data_2) &&
            (memory_write_data_3 === ex_write_data_3) &&

            (memory_read_enable_0 === ex_memory_read_enable_0) &&
            (memory_read_enable_1 === ex_memory_read_enable_1) &&
            (memory_read_enable_2 === ex_memory_read_enable_2) &&
            (memory_read_enable_3 === ex_memory_read_enable_3)
        )
        begin
            $display(
                "PASS: Compute cluster outputs matched at time %0t",
                $time
            );
        end
        else
        begin
            $display(
                "FAIL: Compute cluster mismatch at time %0t",
                $time
            );

            if (done !== ex_done)
                $display(
                    "  done: expected=%0b, actual=%0b",
                    ex_done, done
                );

            if (memory_write_enable_0 !== ex_memory_write_enable_0)
                $display(
                    "  core 0 memory_write_enable: expected=%0b, actual=%0b",
                    ex_memory_write_enable_0,
                    memory_write_enable_0
                );

            if (memory_write_enable_1 !== ex_memory_write_enable_1)
                $display(
                    "  core 1 memory_write_enable: expected=%0b, actual=%0b",
                    ex_memory_write_enable_1,
                    memory_write_enable_1
                );

            if (memory_write_enable_2 !== ex_memory_write_enable_2)
                $display(
                    "  core 2 memory_write_enable: expected=%0b, actual=%0b",
                    ex_memory_write_enable_2,
                    memory_write_enable_2
                );

            if (memory_write_enable_3 !== ex_memory_write_enable_3)
                $display(
                    "  core 3 memory_write_enable: expected=%0b, actual=%0b",
                    ex_memory_write_enable_3,
                    memory_write_enable_3
                );

            if (pc_0 !== ex_pc_0)
                $display(
                    "  pc_0: expected=0x%02h, actual=0x%02h",
                    ex_pc_0, pc_0
                );

            if (pc_1 !== ex_pc_1)
                $display(
                    "  pc_1: expected=0x%02h, actual=0x%02h",
                    ex_pc_1, pc_1
                );

            if (pc_2 !== ex_pc_2)
                $display(
                    "  pc_2: expected=0x%02h, actual=0x%02h",
                    ex_pc_2, pc_2
                );

            if (pc_3 !== ex_pc_3)
                $display(
                    "  pc_3: expected=0x%02h, actual=0x%02h",
                    ex_pc_3, pc_3
                );

            if (memory_address_0 !== ex_memory_address_0)
                $display(
                    "  core 0 memory_address: expected=0x%02h, actual=0x%02h",
                    ex_memory_address_0,
                    memory_address_0
                );

            if (memory_address_1 !== ex_memory_address_1)
                $display(
                    "  core 1 memory_address: expected=0x%02h, actual=0x%02h",
                    ex_memory_address_1,
                    memory_address_1
                );

            if (memory_address_2 !== ex_memory_address_2)
                $display(
                    "  core 2 memory_address: expected=0x%02h, actual=0x%02h",
                    ex_memory_address_2,
                    memory_address_2
                );

            if (memory_address_3 !== ex_memory_address_3)
                $display(
                    "  core 3 memory_address: expected=0x%02h, actual=0x%02h",
                    ex_memory_address_3,
                    memory_address_3
                );

            if (memory_write_data_0 !== ex_write_data_0)
                $display(
                    "  core 0 write_data: expected=0x%02h, actual=0x%02h",
                    ex_write_data_0,
                    memory_write_data_0
                );

            if (memory_write_data_1 !== ex_write_data_1)
                $display(
                    "  core 1 write_data: expected=0x%02h, actual=0x%02h",
                    ex_write_data_1,
                    memory_write_data_1
                );

            if (memory_write_data_2 !== ex_write_data_2)
                $display(
                    "  core 2 write_data: expected=0x%02h, actual=0x%02h",
                    ex_write_data_2,
                    memory_write_data_2
                );

            if (memory_write_data_3 !== ex_write_data_3)
                $display(
                    "  core 3 write_data: expected=0x%02h, actual=0x%02h",
                    ex_write_data_3,
                    memory_write_data_3
                );
            if (memory_read_enable_0 !== ex_memory_read_enable_0)
                $display(
                    "  core 0 memory_read_enable: expected=%0b, actual=%0b",
                    ex_memory_read_enable_0,
                    memory_read_enable_0
                );

            if (memory_read_enable_1 !== ex_memory_read_enable_1)
                $display(
                    "  core 1 memory_read_enable: expected=%0b, actual=%0b",
                    ex_memory_read_enable_1,
                    memory_read_enable_1
                );

            if (memory_read_enable_2 !== ex_memory_read_enable_2)
                $display(
                    "  core 2 memory_read_enable: expected=%0b, actual=%0b",
                    ex_memory_read_enable_2,
                    memory_read_enable_2
                );

            if (memory_read_enable_3 !== ex_memory_read_enable_3)
                $display(
                    "  core 3 memory_read_enable: expected=%0b, actual=%0b",
                    ex_memory_read_enable_3,
                    memory_read_enable_3
                );
        end
    end

endtask 
    //ADDING R1, R2 and storing it into memory address 0x10 and then stopping and or adding nops + # core 
    always_comb begin
        instruction_0 = {NOP, 4'd0, 4'd0, 4'd0};
        instruction_1 = {NOP, 4'd0, 4'd0, 4'd0};
        instruction_2 = {NOP, 4'd0, 4'd0, 4'd0};
        instruction_3 = {NOP, 4'd0, 4'd0, 4'd0};

        case(pc_0)
            8'd0: instruction_0 = {LDI, 4'd1, 8'd5};
            8'd1: instruction_0 = {LDI, 4'd2, 8'd3};
            8'd2: instruction_0 = {ADD, 4'd3, 4'd2, 4'd1};
            8'd3: instruction_0 = {STORE, 4'd3, 8'h10};
            8'd4: instruction_0 = {LOAD, 4'd4, 8'h10 };
            8'd5: instruction_0 = {STORE, 4'd4, 8'h11};
            8'd6: instruction_0 = {HALT, 12'd0};
            default: instruction_0 = 16'h0000; 
        endcase

        case(pc_1)
            8'd0: instruction_1 = {LDI, 4'd1, 8'd10};
            8'd1: instruction_1 = {LDI, 4'd2, 8'd4};
            8'd2: instruction_1 = {ADD, 4'd3, 4'd2, 4'd1};
            8'd3: instruction_1 = {STORE, 4'd3, 8'h11};
            8'd4: instruction_1 = {LOAD, 4'd4, 8'h11};
            8'd5: instruction_1 = {STORE, 4'd4, 8'h12};
            8'd6: instruction_1 = {NOP, 12'd0};
            8'd7: instruction_1 = {HALT, 12'd0};
            default: instruction_1 = 16'h0000; 
        endcase

        case(pc_2)
            8'd0: instruction_2 = {LDI, 4'd1, 8'd20};
            8'd1: instruction_2 = {LDI, 4'd2, 8'd7};
            8'd2: instruction_2 = {ADD, 4'd3, 4'd2, 4'd1};
            8'd3: instruction_2 = {STORE, 4'd3, 8'h12};
            8'd4: instruction_2 = {LOAD, 4'd4, 8'h12};
            8'd5: instruction_2 = {STORE, 4'd4, 8'h13};
            8'd6: instruction_2 = {NOP, 12'd0};
            8'd7: instruction_2 = {NOP, 12'd0};
            8'd8: instruction_2 = {HALT, 12'd0};
            default: instruction_2 = 16'h0000; 
        endcase
        case(pc_3)
            8'd0: instruction_3 = {LDI, 4'd1, 8'd30};
            8'd1: instruction_3 = {LDI, 4'd2, 8'd12};
            8'd2: instruction_3 = {ADD, 4'd3, 4'd2, 4'd1};
            8'd3: instruction_3 = {STORE, 4'd3, 8'h13};
            8'd4: instruction_3 = {LOAD, 4'd4, 8'h13};
            8'd5: instruction_3 = {STORE, 4'd4, 8'h14};
            8'd6: instruction_3 = {NOP, 12'd0};
            8'd7: instruction_3 = {NOP, 12'd0};
            8'd8: instruction_3 = {NOP, 12'd0};
            8'd9: instruction_3 = {HALT, 12'd0};
            default: instruction_3 = 16'h0000; 
        endcase 
        
    end
        always #5 clk = ~clk;
    initial begin
            $dumpfile("waveforms/compute_cluster_core_test_tb.vcd");
            $dumpvars(0, compute_cluster_core_test_tb);
            
            clk = 1'b0; 
            rst = 1'b1; 
            start = 1'b0; 
            thread_count = 3'd3;

            memory_read_data_0 = 8'd0; 
            memory_read_data_1 = 8'd0; 
            memory_read_data_2 = 8'd0; 
            memory_read_data_3 = 8'd0; 

            repeat (2) @(negedge clk);

            rst = 1'b0; 
            start = 1'b1; 

            @(negedge clk);
            start = 1'b0; 
            //CHECKS IF ALL CORES ARE STORING
            wait((pc_0 === 8'd3));
            test_cluster
            (
                //Memory_read_data inputs not used
                8'd0,
                8'd0,
                8'd0,
                8'd0, 

                //DONE SIGNAL
                1'b0, 

                //CORE FOUR IS DISABLED ON THIS TEST
                1'b1,
                1'b1,
                1'b1, 
                1'b0, 

                //PC SIGNAL, CORE 4 DISABLED
                8'd3, 
                8'd3,
                8'd3,
                8'd0, 

                //WHERE THEY'RE STORING
                8'h10, 
                8'h11,
                8'h12,
                8'h00,

                //VALUE THEY'RE STORING
                8'd8,
                8'd14,
                8'd27,
                8'd00,

                //No cores are reading during STORE
                1'b0,
                1'b0,
                1'b0,
                1'b0
            );
            wait(pc_0 === 8'd4);

            test_cluster
            (
                //Values returned to the active cores during LOAD
                8'd8,
                8'd14,
                8'd27,
                8'd0,

                //DONE SIGNAL
                1'b0,

                //LOAD does not write to memory
                1'b0,
                1'b0,
                1'b0,
                1'b0,

                //PC SIGNAL, CORE 3 DISABLED
                8'd4,
                8'd4,
                8'd4,
                8'd0,

                //Addresses being read
                8'h10,
                8'h11,
                8'h12,
                8'h00,

                //No memory write data during LOAD
                8'd0,
                8'd0,
                8'd0,
                8'd0,

                //Active cores assert memory_read_enable
                1'b1,
                1'b1,
                1'b1,
                1'b0
            );

            wait((pc_0 === 8'd5));
            test_cluster
            (
                8'd8,
                8'd14, 
                8'd27,
                8'd0,

                1'b0, 

                1'b1,
                1'b1,
                1'b1,
                1'b0,

                8'd5, 
                8'd5, 
                8'd5, 
                8'd0,

                8'h11,
                8'h12,
                8'h13,
                8'h00,

                8'd8,
                8'd14,
                8'd27,
                8'd0,

                //No cores are reading during STORE
                1'b0,
                1'b0,
                1'b0,
                1'b0
            );
            wait (done === 1'b1);
            #10; 

            $display("Three-core cluster test finished.");
            $finish; 
    end

endmodule
