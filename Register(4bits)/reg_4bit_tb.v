module reg_4bit_tb();
    reg clk, rst, en;
    reg [3:0] d;
    wire [3:0] q; 

    reg_4bit uut
    (
        .clk(clk), 
        .rst(rst),
        .en(en),
        .d(d),
        .q(q)
    );

    initial begin
        clk = 0; 
        forever #5 clk = ~clk; 
    end

    initial begin

        $dumpfile("reg_4bit.vcd");
        $dumpvars(0, reg_4bit_tb);
        d = 4'b1010; en = 0; rst = 1; #10;
        rst = 0; 
        en = 1; #50; 
        en = 0; 
        d = 4'b1111;
        rst = 0; #100;


        $finish;

    end



endmodule