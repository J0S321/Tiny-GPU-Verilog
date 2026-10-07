module memory_arbiter
(
    input  logic clk,
    input  logic rst,

    // Requests from the four cores. Index 0 belongs to core 0.
    input  logic [3:0]      core_read_enable,
    input  logic [3:0]      core_write_enable,
    input  logic [3:0][7:0] core_address,
    input  logic [3:0][7:0] core_write_data,

    output logic [3:0][7:0] core_read_data,
    output logic [3:0]      core_ready,

    // One shared connection to the cache
    output logic       cache_read_enable,
    output logic       cache_write_enable,
    output logic [7:0] cache_address,
    output logic [7:0] cache_write_data,

    input  logic [7:0] cache_read_data,
    input  logic       cache_ready
);
    localparam logic [1:0] IDLE   = 2'd0;
    localparam logic [1:0] ACTIVE = 2'd1;
    localparam logic [1:0] GAP    = 2'd2;

    logic [1:0] state;
    logic [1:0] owner;
    logic [1:0] selected_core;
    logic       selected_valid;
    logic [3:0] request;

    assign request = core_read_enable | core_write_enable;

    // Choose a requester. Once a request starts, keep its core selected
    // until the cache finishes it.
    always_comb begin
        selected_valid = 1'b0;
        selected_core  = 2'd0;

        if (state == ACTIVE) begin
            selected_valid = 1'b1;
            selected_core  = owner;
        end
        else if (state == IDLE) begin
            if (request[0]) begin
                selected_valid = 1'b1;
                selected_core  = 2'd0;
            end
            else if (request[1]) begin
                selected_valid = 1'b1;
                selected_core  = 2'd1;
            end
            else if (request[2]) begin
                selected_valid = 1'b1;
                selected_core  = 2'd2;
            end
            else if (request[3]) begin
                selected_valid = 1'b1;
                selected_core  = 2'd3;
            end
        end
    end

    // Send only the selected core's request to the cache.
    // Return ready and read data only to that core.
    always_comb begin
    cache_read_enable  = 1'b0;
    cache_write_enable = 1'b0;
    cache_address      = 8'd0;
    cache_write_data   = 8'd0;

    if (selected_valid) begin
        cache_read_enable  = core_read_enable[selected_core];
        cache_write_enable = core_write_enable[selected_core];
        cache_address      = core_address[selected_core];
        cache_write_data   = core_write_data[selected_core];
    end
    end

// Route the cache response back to the selected core.
    always_comb begin
        core_read_data = '0;
        core_ready     = '0;

        if (selected_valid) begin
            core_ready[selected_core] = cache_ready;

            if (cache_ready)
                core_read_data[selected_core] = cache_read_data;
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            owner <= 2'd0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (selected_valid) begin
                        if (cache_ready) begin
                            state <= GAP;
                        end
                        else begin
                            owner <= selected_core;
                            state <= ACTIVE;
                        end
                    end
                end

                ACTIVE: begin
                    if (cache_ready)
                        state <= GAP;
                end

                GAP: begin
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule 