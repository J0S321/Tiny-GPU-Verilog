`timescale 1ns/1ns
module cache_tb(); 
integer errors = 0; 
logic clk;
logic rst; 

//COMPUTE CLUSTER
logic core_read_enable; 
logic core_write_enable; 
logic [7:0] core_address;
logic [7:0] core_write_data;

logic [7:0] core_read_data; 
logic core_ready; 
logic cache_hit; 

//DATA MEMORY
logic memory_read_enable; 
logic memory_write_enable; 
logic [7:0] memory_address; 
logic [7:0] memory_write_data; 

logic [7:0] memory_read_data;

cache uut
(
    .clk(clk),
    .rst(rst),
    .core_read_enable(core_read_enable),
    .core_write_enable(core_write_enable),
    .core_address(core_address),
    .core_write_data(core_write_data),
    .core_read_data(core_read_data),
    .core_ready(core_ready),
    .cache_hit(cache_hit),
    .memory_read_enable(memory_read_enable),
    .memory_write_enable(memory_write_enable),
    .memory_address(memory_address),
    .memory_write_data(memory_write_data),
    .memory_read_data(memory_read_data)
);

always #5 clk = ~clk; 

task test_cache
(
    input in_core_read_enable,
    input in_core_write_enable,
    input [7:0] in_core_address,
    input [7:0] in_core_write_data, 
    input [7:0] in_memory_read_data,

    input [7:0] ex_core_read_data, 
    input ex_core_ready,
    input ex_cache_hit, 
    input ex_memory_read_enable, 
    input ex_memory_write_enable, 
    input [7:0] ex_memory_address, 
    input [7:0] ex_memory_write_data
);
    @(negedge clk);
    core_read_enable = in_core_read_enable; 
    core_write_enable = in_core_write_enable; 
    core_address = in_core_address; 
    core_write_data = in_core_write_data; 
    memory_read_data = in_memory_read_data; 
    
    #1; 

    if(core_read_data !== ex_core_read_data) begin
        errors++;
        $display("ERROR: Core_read_data"); 
    end
    if(core_ready !== ex_core_ready) begin
        errors++;
        $display("ERROR: Core_ready");
    end
    if(cache_hit !== ex_cache_hit) begin
        errors++;
        $display("ERROR: Cache Hit");
    end
    if(memory_read_enable !== ex_memory_read_enable) begin
        errors++;
        $display("ERROR: memory_read_enable");
    end
    if(memory_write_enable !== ex_memory_write_enable) begin
        errors++;
        $display("ERROR: memory_write_enable");
    end
    if(memory_address !== ex_memory_address) begin
        errors++;
        $display("ERROR: memory_address");
    end
    if(memory_write_data !== ex_memory_write_data) begin
        errors++;
        $display("ERROR: memory_write_data");
    end
endtask

initial begin
    $dumpfile("waveforms/cache_tb.vcd");
    $dumpvars(0, cache_tb);

    clk = 1'b0; 
    rst = 1'b1; 
    core_read_enable = 1'b0; 
    core_write_enable = 1'b0; 
    core_address = 8'd0; 
    core_write_data = 8'd0; 
    memory_read_data = 8'h00; 
    
    @(negedge clk);
    rst = 1'b0; 
    //IDLE
    test_cache(1'b0, 1'b0, 8'd10, 8'd40, 8'd30, 8'd0, 1'b0, 1'b0, 1'b0, 1'b0, 8'd0, 8'd0);

    //READ MISS
    test_cache(1'b1, 1'b0, 8'h2A, 8'h00, 8'h55, 8'h55, 1'b1, 1'b0, 1'b1, 1'b0, 8'h2A, 8'h00);

    //READ AGAIN BUT THIS TIME CACHE HITS
    test_cache(1'b1, 1'b0, 8'h2A, 8'h00, 8'h00, 8'h55, 1'b1, 1'b1, 1'b0, 1'b0, 8'h00, 8'h00);

    //WRITE HIT
    test_cache(1'b0, 1'b1, 8'h2A, 8'h77, 8'h00, 8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 8'h2A, 8'h77);

    //READ HIT 
    test_cache(1'b1, 1'b0, 8'h2A, 8'h00, 8'h00, 8'h77, 1'b1, 1'b1, 1'b0, 1'b0, 8'h00, 8'h00);
   
    //WRITE MISS
    test_cache(1'b0, 1'b1, 8'h3B, 8'h99, 8'h00, 8'h00, 1'b1, 1'b0, 1'b0, 1'b1, 8'h3B, 8'h99);

    //READ AFTER MISS
    test_cache(1'b1, 1'b0, 8'h3B, 8'h00, 8'h99, 8'h99, 1'b1, 1'b0, 1'b1, 1'b0, 8'h3B, 8'h00);

    //REPEAT READ
    test_cache(1'b1, 1'b0, 8'h3B, 8'h00, 8'h00, 8'h99, 1'b1, 1'b1, 1'b0, 1'b0, 8'h00, 8'h00);

    //CONFLICT MISS
    test_cache(1'b1, 1'b0, 8'h7A, 8'h00, 8'hCC, 8'hCC, 1'b1, 1'b0, 1'b1, 1'b0, 8'h7A, 8'h00); 

    //READ AGAIN
    test_cache(1'b1, 1'b0, 8'h7A, 8'h00, 8'h00, 8'hCC, 1'b1, 1'b1, 1'b0, 1'b0, 8'h00, 8'h00);

    //TEST 0X2A
    test_cache(1'b1, 1'b0, 8'h2A, 8'h00, 8'h77, 8'h77, 1'b1, 1'b0, 1'b1, 1'b0, 8'h2A, 8'h00);

    test_cache(1'b0, 1'b0, 8'h00, 8'h00, 8'h00, 8'h00, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00, 8'h00);

    @(negedge clk);
    core_read_enable = 1'b0; 
    core_write_enable = 1'b0; 
    rst = 1'b1; 

    @(posedge clk);
    #1; 

    @(negedge clk);
    rst = 1'b0; 

    test_cache(1'b1, 1'b0, 8'h2A, 8'h00, 8'h66, 8'h66, 1'b1, 1'b0, 1'b1, 1'b0, 8'h2A, 8'h00);
    if(errors != 0)
        $fatal(1, "cache_tb failed with %0d mismatches", errors);
    $display("PASS: Cach_tb");
    $finish; 



end





endmodule