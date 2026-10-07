module compute_cluster
(
    input  clk, rst, start,
    input  [2:0] thread_count,
    input  [15:0] instruction_0, instruction_1, instruction_2, instruction_3,
    input  [7:0] memory_read_data_0, memory_read_data_1, memory_read_data_2, memory_read_data_3,
    
    //NEW
    input logic memory_ready_0, 
    input logic memory_ready_1, 
    input logic memory_ready_2, 
    input logic memory_ready_3, 

    //NEW
    output logic memory_read_enable_0, 
    output logic memory_read_enable_1,
    output logic memory_read_enable_2, 
    output logic memory_read_enable_3, 
    output  done,
    output  memory_write_enable_0, memory_write_enable_1, memory_write_enable_2, memory_write_enable_3,
    output  [7:0] pc_0, pc_1, pc_2, pc_3,
    output  [7:0] memory_address_0, memory_address_1, memory_address_2, memory_address_3,
    output  [7:0] memory_write_data_0, memory_write_data_1, memory_write_data_2, memory_write_data_3

);

    logic [3:0] core_enable, core_halt; 

    logic [1:0] thread_id_0, thread_id_1, thread_id_2, thread_id_3; 

    dispatcher dispatcher_unit
    (
        .clk(clk),
        .rst(rst),
        .start(start),
        .thread_count(thread_count),

        .halt_0(core_halt[0]),
        .halt_1(core_halt[1]),
        .halt_2(core_halt[2]),
        .halt_3(core_halt[3]),

        .core_0_enable(core_enable[0]),
        .core_1_enable(core_enable[1]),
        .core_2_enable(core_enable[2]),
        .core_3_enable(core_enable[3]),

        .thread_id_0(thread_id_0),
        .thread_id_1(thread_id_1),
        .thread_id_2(thread_id_2),
        .thread_id_3(thread_id_3),

        .done(done)
    );

    // CORE 0
    compute_core core_0
    (
        .clk(clk),
        .rst(rst),
        .core_enable(core_enable[0]),
        .memory_read_data(memory_read_data_0),
        .memory_ready(memory_ready_0), 
        .instruction(instruction_0),

        .memory_read_enable(memory_read_enable_0),
        .halt(core_halt[0]),
        .memory_write_enable(memory_write_enable_0),
        .pc(pc_0),
        .memory_address(memory_address_0),
        .memory_write_data(memory_write_data_0)
    );

    // CORE 1
    compute_core core_1
    (
        .clk(clk),
        .rst(rst),
        .core_enable(core_enable[1]),
        .memory_read_data(memory_read_data_1),
        .memory_ready(memory_ready_1), 
        .instruction(instruction_1),

        .memory_read_enable(memory_read_enable_1),
        .halt(core_halt[1]),
        .memory_write_enable(memory_write_enable_1),
        .pc(pc_1),
        .memory_address(memory_address_1),
        .memory_write_data(memory_write_data_1)
    );

    // CORE 2
    compute_core core_2
    (
        .clk(clk),
        .rst(rst),
        .core_enable(core_enable[2]),
        .memory_read_data(memory_read_data_2),
        .memory_ready(memory_ready_2), 
        .instruction(instruction_2),

        .memory_read_enable(memory_read_enable_2),
        .halt(core_halt[2]),
        .memory_write_enable(memory_write_enable_2),
        .pc(pc_2),
        .memory_address(memory_address_2),
        .memory_write_data(memory_write_data_2)
    );

    // CORE 3
    compute_core core_3
    (
        .clk(clk),
        .rst(rst),
        .core_enable(core_enable[3]),
        .memory_read_data(memory_read_data_3),
        .memory_ready(memory_ready_3),  
        .instruction(instruction_3),

        .memory_read_enable(memory_read_enable_3),
        .halt(core_halt[3]),
        .memory_write_enable(memory_write_enable_3),
        .pc(pc_3),
        .memory_address(memory_address_3),
        .memory_write_data(memory_write_data_3)
    );

    

endmodule