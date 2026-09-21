`timescale 1ns/1ns
module data_memory_tb(); 
logic clk;
logic read_enable; 
logic write_enable; 
logic [7:0] address; 
logic [7:0] write_data; 

logic [7:0] read_data; 

data_memory uut 
(
    .clk(clk),
    .read_enable(read_enable),
    .write_enable(write_enable),
    .address(address),
    .write_data(write_data),
    .read_data(read_data)
);

always #5 clk = ~clk; 

task test_data_memory
(
    input in_read_enable, 
    input in_write_enable,

    input [7:0] in_address,
    input [7:0] in_data,

    input [7:0] ex_read_data
);
    @(negedge clk);
    read_enable = in_read_enable; 
    write_enable = in_write_enable; 
    address = in_address; 
    write_data = in_data; 

    @(posedge clk);
    #1; 
    if(read_data !== ex_read_data) begin
        $display
        (
                "FAIL: address=0x%02h, expected=0x%02h, actual=0x%02h",
                address, ex_read_data, read_data
        );
    end
    else begin
        $display
        (
                "PASS: address=0x%02h, expected=0x%02h, actual=0x%02h",
                address, ex_read_data, read_data
        );
    end

endtask
initial begin
    $dumpfile("waveforms/data_memory_tb.vcd");
    $dumpvars(0, data_memory_tb);

    clk = 1'b0; 
    read_enable = 1'b0; 
    write_enable = 1'b0; 
    address = 8'd0; 
    write_data = 8'd0; 

    test_data_memory(1'b0, 1'b0, 8'h00, 8'h00, 8'h00); //ISN"T READING OR WRITING
    test_data_memory(1'b0, 1'b1, 8'h10, 8'h08, 8'h00); //WRITING TO ADDRESS 10 
    test_data_memory(1'b1, 1'b0, 8'h10, 8'h10, 8'h08); //SHOULD BE READING FROM ADRESS 10 now and output 8

    test_data_memory(1'b0, 1'b1, 8'h14, 8'h10, 8'h00); //WRITING TO DIFFERENT ADRESS NOW
    test_data_memory(1'b1, 1'b0, 8'h14, 8'h12, 8'h10); //READING FROM ADDRESS 14 
    test_data_memory(1'b1, 1'b0, 8'h10, 8'h12, 8'h08); //MAKING SURE THE OLD ADRESS HAS THE SAME VALUE

    test_data_memory(1'b0, 1'b1, 8'h10, 8'h12, 8'h00); //CHANGING VALUES
    test_data_memory(1'b1, 1'b0, 8'h10, 8'h12, 8'h12); //SEING IF IT GOT UPDATED

    $display("Data memory test finished.");
    $finish; 

end


endmodule