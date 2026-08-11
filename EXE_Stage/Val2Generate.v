module Val2Generate(input [31: 0] Val_Rm,
        input [11:0] shift_operand,
        input imm,
        input Type_Sel,
        output reg[31:0] Val2
);

    wire[4:0] shift_imm = shift_operand[11:7];
    wire[1:0] shift = shift_operand[6:5];

    wire[7:0] immed_8 = shift_operand[7:0];
    wire[3:0] rotate_imm = shift_operand[11:8];

    integer i;

    always @(Val_Rm, shift_operand, imm, Type_Sel) begin
        Val2 = 32'b0;

        //offset
        if (Type_Sel) begin  
            Val2 = {{20{shift_operand[11]}}, shift_operand};
        end

        //32-bit immediate
        else if (imm) begin 
            Val2 = {24'b0, immed_8};
            for (i = 0; i < 2 * rotate_imm; i = i + 1) begin
                Val2 = {Val2[0], Val2[31:1]};
            end

        end

        //immediate shifts
        else begin 
            case (shift)
                    2'b00: Val2 = Val_Rm << shift_imm;               // LSL
                    2'b01: Val2 = Val_Rm >> shift_imm;               // LSR
                    2'b10: Val2 = $signed(Val_Rm) >>> shift_imm;     // ASR
                    2'b11: begin                                    // ROR
                        Val2 = Val_Rm;
                        for (i = 0; i < shift_imm; i = i + 1) begin
                            Val2 = {Val2[0], Val2[31:1]};
                        end
                    end
            endcase

        end            
    end

endmodule