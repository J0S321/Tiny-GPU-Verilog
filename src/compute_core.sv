module compute_core
(
    input clk, rst, core_enable,
    input [7:0] memory_read_data, 
    input [15:0] instruction,

    //NEW 
    output logic memory_read_enable, 
    output logic halt, memory_write_enable, 
    output logic [7:0] pc, memory_address, memory_write_data
);
    //INSTRUCTION DECODER
    logic [3:0] opcode, field1, field2, field3;
    logic [7:0] imm8;

    //NEXT PC SELECTION
    logic [7:0] next_pc_check; 

    always_comb begin
        if(opcode == 4'b1100 || opcode == 4'b1101)
            next_pc_check = {4'b0000, field1};
        else
            next_pc_check = imm8; 
    end

    //Gate
    logic gated_reg_write_enable; 


    instruction_decoder decoder_unit
    (
        .instruction(instruction),
        .opcode(opcode),
        .field1(field1),
        .field2(field2),
        .field3(field3),
        .imm8(imm8)
    );


    //CONTROL UNIT
    logic alu_zeroflag, branch_equal; 
    logic reg_write_enable, pc_load, mem_write, halt_signal, control_mem_read; 
    logic [1:0] writeback_select;
    logic [2:0] alu_operation;
    assign gated_reg_write_enable = core_enable && reg_write_enable; 

    control_unit control_inst
    (
        .zeroflag(branch_equal),
        .opcode(opcode),
        .reg_write_enable(reg_write_enable),
        .pc_load(pc_load),
        .mem_read(control_mem_read),
        .mem_write(mem_write),
        .halt(halt_signal),
        .writeback_select(writeback_select),
        .alu_operation(alu_operation)
    );

    //REGISTER FILE
    logic [7:0] write_data;
    logic [7:0] read_data_1, read_data_2, read_data_3; 
    
    assign branch_equal = (read_data_2 == read_data_3);
    register_file register_file_unit
    (
        .clk(clk),
        .rst(rst),
        .write_enable(gated_reg_write_enable),
        .write_address(field1),
        .read_address_1(field1),
        .read_address_2(field2),
        .read_address_3(field3),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .read_data_3(read_data_3)
    );

    //ALU
    logic [7:0] result; 
    logic carry, overflow; 
    alu alu_unit
    (
        .operand_a(read_data_2),
        .operand_b(read_data_3),
        .accumulator(read_data_1),
        .alu_operation(alu_operation),
        .result(result),
        .zeroflag(alu_zeroflag),
        .carry(carry),
        .overflow(overflow)
    );

    //PC
    program_counter pc_unit
    (
        .clk(clk),
        .rst(rst),
        .pc_load(pc_load),
        .halt(halt_signal),
        .enabled(core_enable),
        .next_pc(next_pc_check),
        .pc(pc)
    );

    //WRITEBACK MUX
    writeback_mux writeback_unit
    (
        .alu_result(result),
        .immediate(imm8),
        .register_data(read_data_2),
        .writeback_select(writeback_select),
        .memory_data(memory_read_data),
        .writeback_data(write_data)
    );

    assign memory_read_enable = core_enable && control_mem_read;
    assign halt = core_enable && halt_signal;
    assign memory_write_enable = core_enable && mem_write;
    assign memory_address = (memory_read_enable || memory_write_enable) ? imm8 : 8'd0;
    assign memory_write_data = memory_write_enable ? read_data_1 : 8'd0;

endmodule