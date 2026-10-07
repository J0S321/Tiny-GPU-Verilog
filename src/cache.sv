module cache
(
    input logic clk,
    input logic rst,

    // COMPUTE CLUSTER
    input logic core_read_enable,
    input logic core_write_enable,
    input logic [7:0] core_address,
    input logic [7:0] core_write_data,

    output logic [7:0] core_read_data,
    output logic core_ready,
    output logic cache_hit,

    // DATA MEMORY
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
    logic cache_line_match;

    assign cache_index = core_address[3:0];
    assign address_tag = core_address[7:4];

    // Checks whether the selected cache entry belongs to this address
    assign cache_line_match = cache_valid[cache_index] && (cache_tag[cache_index] == address_tag);

    // cache_hit specifically represents a read hit
    assign cache_hit = core_read_enable && cache_line_match;

    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1) begin
                cache_valid[i] <= 1'b0;
            end
        end
        else begin
            // Update cached copy on a write hit
            if (core_write_enable && cache_line_match) begin
                cache_data[cache_index] <= core_write_data;
            end

            else if(core_read_enable && !cache_line_match) begin
                cache_data[cache_index] <= memory_read_data; 
                cache_tag[cache_index] <= address_tag; 
                cache_valid[cache_index] <= 1'b1; 
            end
        end
    end

    always_comb begin
        // Default values
        core_read_data = 8'b0;
        core_ready     = 1'b0;

        memory_read_enable  = 1'b0;
        memory_write_enable = 1'b0;
        memory_address      = 8'b0;
        memory_write_data   = 8'b0;

        if (core_read_enable) begin
            if (cache_hit) begin
                // Read hit: return cached data
                core_read_data = cache_data[cache_index];
                core_ready     = 1'b1;
            end
            else begin
                // Read miss: return data from main memory
                memory_read_enable = 1'b1;
                memory_address     = core_address;

                core_read_data = memory_read_data;
                core_ready     = 1'b1;
            end
        end
        else if (core_write_enable) begin
            // Write-through: every write goes to data memory
            memory_write_enable = 1'b1;
            memory_address      = core_address;
            memory_write_data   = core_write_data;
            core_ready          = 1'b1;
        end
    end

endmodule