module reg_file_4bit_tb
();
    reg clk, rst, write_enable;
    reg [1:0] write_addr, read_addr1, read_addr2;
    reg [3:0] write_data;
    wire [3:0] read_data1, read_data2;

    reg_file_4bit uut
    (
        .clk(clk), 
        .rst(rst),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    initial begin
        clk = 0; 
        forever #5 clk = ~clk; 

    end

    initial begin

        rst = 1;
        write_enable = 0;
        write_addr = 0;
        read_addr1 = 0;
        read_addr2 = 0;
        write_data = 0;

        $dumpfile("reg_file_4bit_tb.vcd");
        $dumpvars(0, reg_file_4bit_tb); 

        #10;
        rst = 0; 

        write_addr = 2'b00;
        write_data = 4'b0001;
        write_enable = 1; 
        #20;  //writing to address 0, and writing 0001, and turning enable on 

        write_addr = 2'b10; 
        write_data = 4'b0100;
        #30;  //Then we change address number to 2, and writing 0100

        write_enable = 0;
        read_addr1 = 2'b00; 
        read_addr2 = 2'b10; 
        #40;  //finally we're displaying address 0 and 2, while turning write enable off so we don't accidently write to a register 
 
        write_addr = 2'b01; 
        write_data = 4'b0010;
        write_enable = 1;
        #50; //Then we write to address 1, with a value of 0010 while turning on write enable

        write_addr = 2'b11;
        write_data = 4'b1000;
        #60; //Then we write to adress 3, with a value of 1000

        write_enable = 0;
        read_addr1 = 2'b01;
        read_addr2 = 2'b11; 
        #70; //and again we display that with reading from adress 1 and 3 while turning of write enable 

        rst = 1;  
        #80; //then reseting everything


        $finish; 
    end

endmodule 