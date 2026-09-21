`timescale 1ns/1ns
module dispatcher_tb();

    logic clk, rst, start; 
    logic [2:0] thread_count;

    logic halt_0, halt_1, halt_2, halt_3; 

    logic core_0_enable, core_1_enable, core_2_enable, core_3_enable; 
    logic [1:0] thread_id_0, thread_id_1, thread_id_2, thread_id_3;

    logic done;

    dispatcher uut
    (
        .clk(clk),
        .rst(rst),
        .start(start),
        .thread_count(thread_count),
        .halt_0(halt_0),
        .halt_1(halt_1),
        .halt_2(halt_2),
        .halt_3(halt_3),
        .core_0_enable(core_0_enable),
        .core_1_enable(core_1_enable),
        .core_2_enable(core_2_enable),
        .core_3_enable(core_3_enable),
        .thread_id_0(thread_id_0),
        .thread_id_1(thread_id_1),
        .thread_id_2(thread_id_2),
        .thread_id_3(thread_id_3),
        .done(done)
    ); 

    task check_dispatcher
    (
        input in_start, 
        input [2:0] in_thread_count,
        input in_halt_0, in_halt_1, in_halt_2, in_halt_3,
        input ex_core_0_en, ex_core_1_en, ex_core_2_en, ex_core_3_en, 
        input [1:0] exp_thread_id_0, exp_thread_id_1, exp_thread_id_2, exp_thread_id_3, 
        input exp_done
    );

    start = in_start; 
    thread_count = in_thread_count; 

    halt_0 = in_halt_0; 
    halt_1 = in_halt_1; 
    halt_2 = in_halt_2; 
    halt_3 = in_halt_3; 

    @(posedge clk);
    #1; 

    if(ex_core_0_en !== core_0_enable) begin
        $display("FAILED core 0 status is, %d", core_0_enable);
        $display("Core 0 status should be, %d", ex_core_0_en);
    end
    else if(ex_core_1_en !== core_1_enable) begin
        $display("FAILED core 1 status is, %d", core_1_enable);
        $display("Core 1 status should be, %d", ex_core_1_en);
    end
    else if(ex_core_2_en !== core_2_enable) begin
        $display("FAIL core 2 status is, %d", core_2_enable);
        $display("Core 2 status should be, %d", ex_core_2_en);
    end
    else if(ex_core_3_en !== core_3_enable) begin
        $display("FAIL core 3 status is, %d", core_3_enable);
        $display("Core 3 status should be %d", ex_core_3_en);
    end
    else if(exp_thread_id_0 !== thread_id_0) begin
        $display("FAIL, core 0 ID is, %d", thread_id_0);
        $display("Should be %d", exp_thread_id_0);
    end
    else if(exp_thread_id_1 !== thread_id_1) begin
        $display("FAIL, core 1 ID is, %d", thread_id_1);
        $display("Should be %d", exp_thread_id_1);
    end
    else if(exp_thread_id_2 !== thread_id_2) begin
        $display("FAIL, core 2 ID is, %d", thread_id_2);
        $display("Should be %d", exp_thread_id_2);
    end
    else if(exp_thread_id_3 !== thread_id_3) begin
        $display("FAIL, core 3 ID is, %d", thread_id_3);
        $display("Should be %d", exp_thread_id_3);
    end
    else if(exp_done !== done)begin
        $display("FAIL done signal is, %d", done);
        $display("The signal should be %d", exp_done);
    end
    else 
        $display("PASS! everything passed successfully");
    
    if ({core_3_enable, core_2_enable, core_1_enable, core_0_enable}
    !==
    {ex_core_3_en, ex_core_2_en, ex_core_1_en, ex_core_0_en}) 
    begin
        $error("Enable mismatch: expected %b%b%b%b, received %b%b%b%b",ex_core_3_en, ex_core_2_en, ex_core_1_en, ex_core_0_en,core_3_enable, core_2_enable, core_1_enable, core_0_enable);
    end

    endtask


    always #5 clk = ~clk; 
    initial begin
        $dumpfile("waveforms/dispatcher_tb.vcd");
        $dumpvars(0, dispatcher_tb);
        clk = 0; 
        rst = 1; 

        start = 0; 
        thread_count = 0; 
        halt_0 = 0; 
        halt_1 = 0; 
        halt_2 = 0; 
        halt_3 = 0; 

        repeat (2) @(posedge clk); //basically waits for two pos clock edges
        @(negedge clk); 
        rst = 0; 

        check_dispatcher //Enabling CORE 1
        (
            1'b1,

            3'd1,
            
            1'b0,
            1'b0,
            1'b0,
            1'b0, 

            1'b1,
            1'b0,
            1'b0,
            1'b0,

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'd0 

        );
        
        check_dispatcher //PRODUCE HALT FOR CORE 1
        (
            1'b0, 

            3'd1,

            1'b1,
            1'b0,
            1'b0, 
            1'b0,

            1'b0, 
            1'b0, 
            1'b0, 
            1'b0,

            2'd0, 
            2'd1, 
            2'd2,
            2'd3,

            1'b1
        );

        check_dispatcher //Enabling CORE 0&1
        (
            1'b1, 

            3'd2, 

            1'b0,
            1'b0,
            1'b0,
            1'b0,

            1'b1, 
            1'b1, 
            1'b0, 
            1'b0, 

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'b0
        );

        check_dispatcher //Halt on Core1
        (
            1'b0, 

            3'd2, 

            1'b1, 
            1'b0, 
            1'b0,
            1'b0, 

            1'b1,
            1'b1, 
            1'b0, 
            1'b0, 

            2'd0, 
            2'd1,
            2'd2,
            2'd3,

            1'b0
        );

        check_dispatcher //HALT on Core 1&2 and also stops everything
        (
            1'b0, 

            3'd2, 

            1'b1,
            1'b1,
            1'b0,
            1'b0, 

            1'b0, 
            1'b0,
            1'b0,
            1'b0,

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'b1
        );

        check_dispatcher //Enabling CORE 0&1&2
        (
            1'b1,

            3'd3,
            
            1'b0,
            1'b0,
            1'b0,
            1'b0, 

            1'b1,
            1'b1,
            1'b1,
            1'b0,

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'd0 

        );

        check_dispatcher //HALT inputs for core 1 gets asserted
        (
            1'b0,

            3'd3, 

            1'b1, 
            1'b0, 
            1'b0, 
            1'b0, 

            1'b1, 
            1'b1, 
            1'b1, 
            1'b0, 

            2'd0, 
            2'd1, 
            2'd2, 
            2'd3,

            1'd0 
        );

        check_dispatcher //HALT core 2
        (
            1'b0,
            
            3'd3, 

            1'b1, 
            1'b1, 
            1'b0, 
            1'b0,

            1'b1,
            1'b1, 
            1'b1, 
            1'b0,

            2'd0, 
            2'd1,
            2'd2,
            2'd3,

            1'd0
        );

        check_dispatcher //HALT core 3 and finishs the whole thing
        (
            1'b0, 

            3'd3, 

            1'b1,
            1'b1,
            1'b1, 
            1'b0,

            1'd0,
            1'd0,
            1'd0,
            1'd0,

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'd1

        );

        check_dispatcher
        (
            1'b1, 

            3'd4, 

            1'b0,
            1'b0,
            1'b0,
            1'b0,

            1'b1,
            1'b1,
            1'b1,
            1'b1,
            

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'd0
        );

        check_dispatcher
        (
            1'b0,

            3'd4, 

            1'b1, 
            1'b0,
            1'b0,
            1'b0,

            1'b1,
            1'b1,
            1'b1,
            1'b1,

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'd0
        );

        check_dispatcher
        (
            1'd0, 

            3'd4, 

            1'b1,
            1'b1,
            1'b0,
            1'b0,

            1'b1,
            1'b1,
            1'b1,
            1'b1,

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'd0
        );

        check_dispatcher
        (
            1'd0,

            3'd4, 

            1'b1,
            1'b1,
            1'b1,
            1'b0,

            1'd1,
            1'd1,
            1'd1,
            1'd1,

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'd0
        );

        check_dispatcher
        (
            1'd0,

            3'd4,

            1'b1,
            1'b1,
            1'b1,
            1'b1,

            1'd0,
            1'd0,
            1'd0,
            1'd0,

            2'd0,
            2'd1,
            2'd2,
            2'd3,

            1'd1
        );







        $finish;
    end

endmodule