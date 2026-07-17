module reg_file_4bit (
    input clk, rst, write_enable,
    input [1:0] write_addr, read_addr1, read_addr2,
    input [3:0] write_data,
    output [3:0] read_data1, read_data2
);
    
    reg [3:0] registers [0:3]; 

    always @(posedge clk) begin
        if(rst) begin
            registers[0] <= 4'b0000; 
            registers[1] <= 4'b0000; 
            registers[2] <= 4'b0000; 
            registers[3] <= 4'b0000; 
        end
        else if(write_enable) begin
            registers[write_addr] <= write_data; 
        end          
    end

    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2]; 

endmodule