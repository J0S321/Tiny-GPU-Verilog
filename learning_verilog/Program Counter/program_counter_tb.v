module program_counter_tb(); 
    
    reg clk, rst, enable; 
    wire [3:0] pc; 

    program_counter uut
    (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin

        $dumpfile("program_counter_tb.vcd");
        $dumpvars(0, program_counter_tb); 

        rst = 1; 
        enable = 0; 
        #10; 
        
        rst = 0; 
        enable = 1;
        #50; 

        enable = 0; 
        #20; 

        rst = 1; 
        #20; 

        $finish;

    end

endmodule 