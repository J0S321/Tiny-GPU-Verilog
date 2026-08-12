module register_file
(
    input clk, rst, write_enable, 
    input [3:0] write_address, read_address_1, read_address_2, read_address_3,
    input [7:0] write_data,

    output [7:0] read_data_1, read_data_2, read_data_3
);
    logic [7:0] registers [0:15];
    always_ff @(posedge clk) begin
        if(rst) begin
            for(integer i = 0; i < 16; i++)
                registers[i] <= 8'b0000_0000; 
        end
        else if(write_enable)
            registers[write_address] <= write_data;
    end

    assign read_data_1 = registers[read_address_1];
    assign read_data_2 = registers[read_address_2];
    assign read_data_3 = registers[read_address_3];


endmodule