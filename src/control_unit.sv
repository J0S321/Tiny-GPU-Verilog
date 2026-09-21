module control_unit
(
    input zeroflag, 
    input [3:0] opcode, 

    output logic mem_read, 
    output logic reg_write_enable, pc_load, mem_write, halt, //Basically flags for write to register file, load PC enable, and write to cache and halt
    output logic [1:0] writeback_select,
    output logic [2:0] alu_operation
);

    always_comb begin
        //DEFAULT VALUES
        reg_write_enable = 1'b0; 
        pc_load = 1'b0; 
        mem_write = 1'b0; 
        halt = 1'b0; 
        alu_operation = 3'b000; 
        writeback_select = 2'b00; 
        mem_read = 1'b0; 
        case(opcode)

        4'b0000: begin //NOP
        end

        4'b0001: begin //LDI
            reg_write_enable = 1'b1; 
            writeback_select = 2'b10;
        end

        4'b0010: begin //STORE
            mem_write = 1'b1; 
        end

        4'b0011: begin //MOVE
            reg_write_enable = 1'b1; 
            writeback_select = 2'b11; 
        end

        4'b0100: begin //ADD
            reg_write_enable = 1'b1; 
            alu_operation = 3'b000; 
            writeback_select = 2'b01; 
        end

        4'b0101: begin //SUB
            reg_write_enable = 1'b1; 
            alu_operation = 3'b001; 
            writeback_select = 2'b01; 
        end

        4'b0110: begin //MUL
            reg_write_enable = 1'b1; 
            alu_operation = 3'b010; 
            writeback_select = 2'b01; 
        end

        4'b0111: begin //MAC
            reg_write_enable = 1'b1; 
            alu_operation = 3'b110; 
            writeback_select = 2'b01; 
        end

        4'b1000: begin //AND
            reg_write_enable = 1'b1; 
            alu_operation = 3'b011; 
            writeback_select = 2'b01; 
        end

        4'b1001: begin //OR
            reg_write_enable = 1'b1; 
            alu_operation = 3'b100; 
            writeback_select = 2'b01; 
        end

        4'b1010: begin //XOR
            reg_write_enable = 1'b1; 
            alu_operation = 3'b101; 
            writeback_select = 2'b01; 
        end

        4'b1011: begin //JMP
            pc_load = 1'b1; 
        end

        4'b1100: begin //BEQ
            alu_operation = 3'b001; 
            if(zeroflag)
                pc_load = 1'b1; 
            else
                pc_load = 1'b0; 
        end
        
        4'b1101: begin //BNE
            alu_operation = 3'b001; //SUB
            if(!zeroflag)
                pc_load = 1'b1; 
            else
                pc_load = 1'b0; 
        end

        4'b1110: begin //LOAD
            mem_read = 1'b1; 
            reg_write_enable = 1'b1; 
            writeback_select = 2'b00; 
        end

        4'b1111: begin
            halt = 1'b1; 
        end


        default: begin
        end

        endcase
    end

endmodule