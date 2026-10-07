module tiny_gpu
(
    input logic clk, 
    input logic rst, 
    input logic start, 
    input logic [2:0] thread_count, 

    input logic [15:0] instruction_0,
    input logic [15:0] instruction_1,
    input logic [15:0] instruction_2,
    input logic [15:0] instruction_3,

    output logic done,

    output logic [7:0] pc_0,
    output logic [7:0] pc_1,
    output logic [7:0] pc_2,
    output logic [7:0] pc_3,

    output logic [3:0]      store_valid,
    output logic [3:0][7:0] result_address,
    output logic [3:0][7:0] result_data
);

    // Internal connections
    logic [3:0]      core_read_enable;
    logic [3:0]      core_write_enable;
    logic [3:0]      core_ready;

    logic [3:0][7:0] core_address;
    logic [3:0][7:0] core_write_data;
    logic [3:0][7:0] core_read_data;

    compute_cluster compute_cluster_unit
    (
        .clk(clk),
        .rst(rst),
        .start(start),
        .thread_count(thread_count),

        .instruction_0(instruction_0),
        .instruction_1(instruction_1),
        .instruction_2(instruction_2),
        .instruction_3(instruction_3),

        // Data returned by the memory cluster
        .memory_read_data_0(core_read_data[0]),
        .memory_read_data_1(core_read_data[1]),
        .memory_read_data_2(core_read_data[2]),
        .memory_read_data_3(core_read_data[3]),

        // Memory completion signals
        .memory_ready_0(core_ready[0]),
        .memory_ready_1(core_ready[1]),
        .memory_ready_2(core_ready[2]),
        .memory_ready_3(core_ready[3]),

        // Read requests sent to the memory cluster
        .memory_read_enable_0(core_read_enable[0]),
        .memory_read_enable_1(core_read_enable[1]),
        .memory_read_enable_2(core_read_enable[2]),
        .memory_read_enable_3(core_read_enable[3]),

        // Write requests sent to the memory cluster
        .memory_write_enable_0(core_write_enable[0]),
        .memory_write_enable_1(core_write_enable[1]),
        .memory_write_enable_2(core_write_enable[2]),
        .memory_write_enable_3(core_write_enable[3]),

        .memory_address_0(core_address[0]),
        .memory_address_1(core_address[1]),
        .memory_address_2(core_address[2]),
        .memory_address_3(core_address[3]),

        .memory_write_data_0(core_write_data[0]),
        .memory_write_data_1(core_write_data[1]),
        .memory_write_data_2(core_write_data[2]),
        .memory_write_data_3(core_write_data[3]),

        .done(done),

        .pc_0(pc_0),
        .pc_1(pc_1),
        .pc_2(pc_2),
        .pc_3(pc_3)
    );

    memory_cluster memory_cluster_in
    (
        .clk(clk),
        .rst(rst),
        .core_read_enable(core_read_enable),
        .core_write_enable(core_write_enable),
        .core_address(core_address),
        .core_write_data(core_write_data),
        .core_read_data(core_read_data),
        .core_ready(core_ready)
    );

    assign store_valid = core_write_enable & core_ready; 
    assign result_address = core_address; 
    assign result_data = core_write_data; 

endmodule