`timescale 1ns/1ns
module writeback_mux_tb(); 
    logic [7:0] alu_result, immediate, register_data; 
    logic [1:0] writeback_select;
    logic [7:0] writeback_data; 

    writeback_mux uut
    (
        .alu_result(alu_result),
        .immediate(immediate),
        .register_data(register_data),
        .writeback_select(writeback_select),
        .writeback_data(writeback_data)
    );

    task check_writeback
    (
        input [7:0] in_alu_result, in_immediate, in_register_data,
        input [1:0] in_writeback_select,
        input [7:0] expected_data
    );
    
    begin
        alu_result = in_alu_result; 
        immediate = in_immediate; 
        register_data = in_register_data; 
        writeback_select = in_writeback_select; 

        #1;

        if(expected_data !== writeback_data)
                $display("FAIL: writeback = %d, should be %d", writeback_data, expected_data);
        else
            $display("PASS: select = %b, writeback = %h", writeback_select, writeback_data);
    end

    endtask

    initial begin
        $dumpfile("waveforms/writeback_mux_tb.vcd");
        $dumpvars(0, writeback_mux_tb);

        check_writeback
        (
            8'b0000_0000,
            8'b0000_1111, 
            8'b1111_0000,
            2'b01,
            8'b0000_0000
        );

        check_writeback
        (
            8'b0000_1100,
            8'b0011_1100,
            8'b0111_0000,
            2'b10,
            8'b0011_1100
        );

        check_writeback
        (
            8'b0000_0001,
            8'b1000_0000,
            8'b0001_1000,
            2'b11,
            8'b0001_1000
        );

        check_writeback
        (
            8'b1111_1111,
            8'b1111_1111,
            8'b1111_1111,
            2'b00,
            8'b0000_0000
        );

        $finish; 

    end


endmodule 