module mux_4_to_1
    (
        input [3:0] in0, in1, in2, in3, 
        input [1:0] sel,
        output reg [3:0] out
        
    );


    always @(*) begin
        if(sel == 2'b00)
            out = in0; 
        else if(sel == 2'b01)
            out = in1; 
        else if(sel == 2'b10)
            out = in2; 
        else
            out = in3; 
    end

endmodule