module data_memory
(
    input logic clk,
    input logic read_enable, 
    input logic write_enable, 
    input logic [7:0] address, 
    input logic [7:0] write_data, 

    output logic [7:0] read_data
); 
    logic [7:0] memory [0:255]; 

    always_ff @(posedge clk) begin
        if(write_enable)
            memory[address] <= write_data; 
    end

    always_comb begin
        if(read_enable)
            read_data = memory[address];
        else 
            read_data = 8'd0; 
    end


endmodule