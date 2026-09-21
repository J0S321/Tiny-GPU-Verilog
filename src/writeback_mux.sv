module writeback_mux 
(
    input [7:0] alu_result, immediate, register_data, memory_data, 
    input [1:0] writeback_select, 
    output logic [7:0] writeback_data
);


    always_comb begin
        if(writeback_select == 2'b01)
            writeback_data = alu_result; 
        else if(writeback_select == 2'b10)
            writeback_data = immediate; 
        else if(writeback_select == 2'b11)
            writeback_data = register_data; 
        else
            writeback_data = memory_data; 
    end


endmodule