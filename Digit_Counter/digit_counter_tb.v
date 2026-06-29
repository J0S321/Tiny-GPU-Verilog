module digit_counter_tb();

    reg rst, clk; 
    wire [1:0] sel; 

    digit_counter uut
    (
        .rst(rst),
        .clk(clk),
        .sel(sel)
    );

    initial begin
        clk = 0; 
        forever #5 clk = ~clk; 
    end


    initial begin

        $dumpfile("digit_counter.vcd");
        $dumpvars(0, digit_counter_tb);

        rst = 1; #10; 
        rst = 0; #100; 

        $finish; 
    end


endmodule