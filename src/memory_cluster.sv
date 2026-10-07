module memory_cluster
(
    input logic clk, 
    input logic rst, 
    input logic [3:0] core_read_enable,
    input logic [3:0] core_write_enable, 
    input logic [3:0][7:0] core_address, 
    input logic [3:0][7:0] core_write_data, 

    output logic [3:0][7:0] core_read_data, 
    output logic [3:0] core_ready

);
    //ARBITER OUTPUT
    logic cache_read_enable;
    logic cache_write_enable; 
    logic [7:0] cache_address;
    logic [7:0] cache_write_data; 
    logic [7:0] cache_read_data;
    logic cache_ready;

    memory_arbiter arbiter_int
    (
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

    //CACHE OUTPUTS
    logic cache_hit;
    logic memory_read_enable; 
    logic memory_write_enable; 
    logic [7:0] memory_address; 
    logic [7:0] memory_write_data; 
    logic [7:0] memory_ready_data; 
    cache cache_int 
    (
        .clk(clk),
        .rst(rst),
        .core_read_enable(cache_read_enable),
        .core_write_enable(cache_write_enable),
        .core_address(cache_address),
        .core_write_data(cache_write_data),
        
        .core_read_data(cache_read_data),
        .core_ready(cache_ready),
        .cache_hit(cache_hit),
        .memory_read_enable(memory_read_enable), 
        .memory_write_enable(memory_write_enable), 
        .memory_address(memory_address), 
        .memory_write_data(memory_write_data), 
        .memory_read_data(memory_ready_data)
    );

    data_memory memory_int 
    (
        .clk(clk),
        .read_enable(memory_read_enable),
        .write_enable(memory_write_enable),
        .address(memory_address),
        .write_data(memory_write_data),
        .read_data(memory_ready_data)
    );



    





endmodule