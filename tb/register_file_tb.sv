`timescale 1ns/1ns

module register_file_tb();

    logic clk, rst, write_enable;

    logic [3:0] write_address;
    logic [3:0] read_address_1;
    logic [3:0] read_address_2;
    logic [3:0] read_address_3;

    logic [7:0] write_data;

    logic [7:0] read_data_1;
    logic [7:0] read_data_2;
    logic [7:0] read_data_3;

    register_file uut
    (
        .clk(clk),
        .rst(rst),
        .write_enable(write_enable),
        .write_address(write_address),
        .read_address_1(read_address_1),
        .read_address_2(read_address_2),
        .read_address_3(read_address_3),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .read_data_3(read_data_3)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("waveforms/register_file_tb.vcd");
        $dumpvars(0, register_file_tb);

        // RESET
        rst = 1;
        write_enable = 0;

        write_address = 4'b0000;

        read_address_1 = 4'b0000;
        read_address_2 = 4'b0000;
        read_address_3 = 4'b0000;

        write_data = 8'b0000_0000;

        #10;


        // Write 3 into R0
        rst = 0;
        write_enable = 1;

        write_address = 4'b0000;
        read_address_1 = 4'b0000;
        read_address_2 = 4'b0000;
        read_address_3 = 4'b0000;

        write_data = 8'b0000_0011;

        #10;


        // Write 51 into R1
        write_address = 4'b0001;

        read_address_1 = 4'b0000;
        read_address_2 = 4'b0001;
        read_address_3 = 4'b0000;

        write_data = 8'b0011_0011;

        #10;


        // Make sure register does not write when disabled
        write_enable = 0;

        #10;


        write_address = 4'b0000;
        write_data = 8'b1111_1111;

        read_address_1 = 4'b0000;
        read_address_2 = 4'b0001;
        read_address_3 = 4'b0000;

        #10;


        // Write FF into R0
        write_enable = 1;

        #10;


        // Write 66 into R7
        write_address = 4'b0111;
        write_data = 8'b0110_0110;

        read_address_1 = 4'b0001;
        read_address_2 = 4'b0111;
        read_address_3 = 4'b0000;

        #10;


        // RESET registers
        rst = 1;

        #10;


        // Check reset values
        read_address_1 = 4'b0000;
        read_address_2 = 4'b0001;
        read_address_3 = 4'b0111;

        #10;


        read_address_1 = 4'b0111;

        #10;


        // TEST NEW 4-BIT ADDRESS + THIRD READ PORT
        rst = 0;
        write_enable = 1;

        write_address = 4'b1001;      // R9
        write_data = 8'b1010_0000;    // A0

        read_address_3 = 4'b1001;     // Read R9 using third port

        #10;


        $finish;

    end

endmodule