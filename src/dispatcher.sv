module dispatcher
(
    input clk, rst, start,
    input [2:0] thread_count, 

    input halt_0, halt_1, halt_2, halt_3, 

    output logic core_0_enable, core_1_enable, core_2_enable, core_3_enable,
    output logic [1:0] thread_id_0, thread_id_1, thread_id_2, thread_id_3,

    output logic done
); 

    logic busy; 
    always_comb begin
        thread_id_0 = 2'd0; 
        thread_id_1 = 2'd1; 
        thread_id_2 = 2'd2; 
        thread_id_3 = 2'd3; 
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            core_0_enable <= 1'b0; 
            core_1_enable <= 1'b0; 
            core_2_enable <= 1'b0; 
            core_3_enable <= 1'b0; 

            done <= 1'b0; 
            busy <= 1'b0; 
        end
        else
        begin

            done <= 1'b0; 

            if(start && !busy) begin

                busy <= 1'b1; 

                case (thread_count)
                    3'd1: begin
                        core_0_enable <= 1'b1; 
                        core_1_enable <= 1'b0; 
                        core_2_enable <= 1'b0; 
                        core_3_enable <= 1'b0;    
                    end

                    3'd2: begin
                        core_0_enable <= 1'b1; 
                        core_1_enable <= 1'b1; 
                        core_2_enable <= 1'b0; 
                        core_3_enable <= 1'b0; 
                    end

                    3'd3: begin
                        core_0_enable <= 1'b1; 
                        core_1_enable <= 1'b1; 
                        core_2_enable <= 1'b1;
                        core_3_enable <= 1'b0; 
                    end

                    3'd4: begin
                        core_0_enable <= 1'b1; 
                        core_1_enable <= 1'b1; 
                        core_2_enable <= 1'b1; 
                        core_3_enable <= 1'b1; 
                    end

                    default: begin
                        core_0_enable <= 1'b0; 
                        core_1_enable <= 1'b0; 
                        core_2_enable <= 1'b0; 
                        core_3_enable <= 1'b0; 

                        busy <= 1'b0; 
                    end
                endcase 
            end
            else if(busy && (!core_0_enable || halt_0) && (!core_1_enable || halt_1) && (!core_2_enable || halt_2) && (!core_3_enable || halt_3)) 
            begin
                done <= 1'b1; 
                busy <= 1'b0; 

                core_0_enable <= 1'b0; 
                core_1_enable <= 1'b0; 
                core_2_enable <= 1'b0; 
                core_3_enable <= 1'b0;
            end
        end
    end


endmodule 