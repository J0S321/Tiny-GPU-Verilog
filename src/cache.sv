module cache
(
    input logic clk,
    input logic rst, 

    //COMPUTE CLUSTER
    input logic core_read_enable, 
    input logic core_write_enable,
    input logic [7:0] core_address, 
    input logic [7:0] core_write_data, 

    output logic [7:0] core_read_data, 
    output logic core_ready, 
    output logic cache_hit, 

    //DATA-MEMORY 
    output logic memory_read_enable, 
    output logic memory_write_enable, 
    output logic [7:0] memory_address, 
    output logic [7:0] memory_write_data, 

    input logic [7:0] memory_read_data
);
    logic [7:0] cache_data [0:15];
    logic [3:0] cache_tag [0:15];
    logic cache_valid [0:15];

    logic [3:0] cache_index; 
    logic [3:0] address_tag; 

    assign cache_index = core_address[3:0];
    assign address_tag = core_address[7:4]; 

    assign cache_hit = cache_valid[cache_index] && (cache_tag[cache_index] == address_tag);

    always_ff @(posedge clk) begin
        if(rst) begin
            for(integer i = 0; i < 16; i = i + 1) begin
                cache_valid[i] <= 1'b0; 
            end
        end
        else begin
            if(core_write_enable && cache_hit) begin
                cache_data[cache_index] <= core_write_data; 
            end
        end
    end 

    always_comb begin
        if(core_read_enable && cache_hit) begin
            core_read_data = cache_data[cache_index]; 
            core_ready = 1'b1; 
        end
        if(core_read_enable && !cache_hit) begin
            memory_read_enable = 1'b1; 
            memory_address = core_address; 
            
        end 
        else
    end


endmodule