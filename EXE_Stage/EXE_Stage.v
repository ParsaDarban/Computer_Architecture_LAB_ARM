module EXE_Stage(
    input clk,
    input[3:0] EXE_CMD,
    input MEM_R_EN, MEM_W_EN,
    input [31:0] PC_in ,Val_Rn, Val_Rm,
    input imm,
    input [11:0] Shift_operand,
    input[23:0] Signed_imm_24,
    input[31:0] SR,

    input       [31:0]  MEM_fwd_data,
    input       [31:0]  WB_fwd_data,
    input       [1:0]   sel_src1,
    input       [1:0]   sel_src2,

    output[31:0] ALU_result, BR_addr, Val_Rm_out,
    output[31:0] status
);
    wire[31:0] val2;
    
    wire [31:0] signed_imm_32, Val_Rn_mux, Val_Rm_mux;
    Val2Generate val(
        .Val_Rm(Val_Rm_mux),
        .shift_operand(Shift_operand),
        .imm(imm),
        .Type_Sel(MEM_R_EN | MEM_W_EN),
        .Val2(val2)
    );
    
    ALU alu(
        .Val1(Val_Rn_mux),
        .Val2(val2),
        .EXE_CMD(EXE_CMD),
        .c(SR[29]), 
        .alu_result(ALU_result),
        .Status_Bits(status)
    );

    assign signed_imm_32 = {{8{Signed_imm_24[23]}}, Signed_imm_24};  

    Adder #(32) adder_unit (.in1(PC_in), .in2(signed_imm_32), .co(), .out(BR_addr));
    assign Val_Rm_out = Val_Rm_mux;
    assign Val_Rm_mux = (sel_src2 == 2'b01) ? MEM_fwd_data :
                        (sel_src2 == 2'b10) ? WB_fwd_data :
                        Val_Rm;

    assign Val_Rn_mux = (sel_src1 == 2'b01) ? MEM_fwd_data :
                        (sel_src1 == 2'b10) ? WB_fwd_data :
                        Val_Rn;

endmodule