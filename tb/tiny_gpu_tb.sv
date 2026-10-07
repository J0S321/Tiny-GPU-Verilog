module tiny_gpu_tb(); 

logic clk;
logic rst;
logic start;
logic [2:0] thread_count;

logic [15:0] instruction_0;
logic [15:0] instruction_1;
logic [15:0] instruction_2;
logic [15:0] instruction_3;

logic done;

logic [7:0] pc_0;
logic [7:0] pc_1;
logic [7:0] pc_2;
logic [7:0] pc_3;

logic [3:0]      store_valid;
logic [3:0][7:0] result_address;
logic [3:0][7:0] result_data;

    localparam NOP   = 4'b0000;
    localparam LDI   = 4'b0001;
    localparam STORE = 4'b0010;
    localparam MOV   = 4'b0011;
    localparam ADD   = 4'b0100;
    localparam SUB   = 4'b0101;
    localparam MUL   = 4'b0110;
    localparam MAC   = 4'b0111;
    localparam AND_OP = 4'b1000;
    localparam OR_OP  = 4'b1001;
    localparam XOR_OP = 4'b1010;
    localparam JMP   = 4'b1011;
    localparam BEQ   = 4'b1100;
    localparam BNE   = 4'b1101;
    localparam LOAD  = 4'b1110;
    localparam HALT  = 4'b1111;


tiny_gpu uut
(
    .clk(clk),
    .rst(rst),
    .start(start),
    .thread_count(thread_count),

    .instruction_0(instruction_0),
    .instruction_1(instruction_1),
    .instruction_2(instruction_2),
    .instruction_3(instruction_3),

    .done(done),

    .pc_0(pc_0),
    .pc_1(pc_1),
    .pc_2(pc_2),
    .pc_3(pc_3),

    .store_valid(store_valid),
    .result_address(result_address),
    .result_data(result_data)
);

always #5 clk = ~clk; 

task automatic check
(
    input logic condition, 
    input string description
);

    if(condition !== 1'b1) begin
        $display("FAIL at %0t: %s", $time, description);
        $fatal(1);
    end
endtask

always_comb begin
    instruction_1 = {HALT, 12'd0};
    instruction_2 = {HALT, 12'd0};
    instruction_3 = {HALT, 12'd0};

    case (pc_0)
        8'd0: instruction_0 = {LDI,   4'd1, 8'd5};
        8'd1: instruction_0 = {LDI,   4'd2, 8'd7};
        8'd2: instruction_0 = {ADD,   4'd3, 4'd1, 4'd2};
        8'd3: instruction_0 = {STORE, 4'd3, 8'h00};
        8'd4: instruction_0 = {LOAD,  4'd4, 8'h00};
        8'd5: instruction_0 = {ADD,   4'd5, 4'd1, 4'd4};
        8'd6: instruction_0 = {STORE, 4'd5, 8'h21};
        8'd7: instruction_0 = {HALT, 12'd0};
        default: instruction_0 = {HALT, 12'd0};
    endcase
end

initial begin
    #1000; 
    $fatal(1, "Timeout");
end

initial begin
    $dumpfile("tiny_gpu_tb.vcd");
    $dumpvars(0, tiny_gpu_tb);

    clk = 1'b0; 
    rst = 1'b1; 
    start = 1'b0; 
    thread_count = 3'd0; 

    
    repeat(2) @(negedge clk);
    rst = 1'b0; 
    start = 1'b1; 
    thread_count = 3'd1; 
    #1; 

    @(negedge clk);
    start = 1'b0; 

    wait(store_valid[0] === 1'b1);
    @(posedge clk); 

    check(store_valid[0] === 1'b1, 
        "Core 0 STORE must be balid at the rising edge");

    check(result_address[0] == 8'h00, 
        "First STORE address should be 0x00");

    check(result_data[0] === 8'd12, 
        "First STORE data should be 12");


    wait(store_valid[0] === 1'b0); 
    wait(store_valid[0] === 1'b1); 
    @(posedge clk); 

    check(store_valid[0] === 1'b1,
        "Second STORE must be valid at the rising edge");

    check(result_address[0] === 8'h21,
        "Second STORE address should be 0x21");

    check(result_data[0] === 8'd17, 
        "Second STORE data should be 17");
    
    wait(done === 1'b1); 
    @(negedge clk); 
    $display("TINY GPU PASSED SUCCESSFULLY!"); 
    $finish; 
end



endmodule