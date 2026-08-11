module EXE_Stage_Reg(
    input clk, rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in,
    input[31:0] ALU_result_in, Val_Rm_in,
    input[3:0] Dest_in,
    output reg WB_en, MEM_R_en_MEM, MEM_W_en_MEM,
    output reg[31:0] ALU_result, Val_Rm,
    output reg[3:0] Dest
);

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            {WB_en, MEM_R_en_MEM, MEM_W_en_MEM} <= 3'b0;
            {ALU_result, Val_Rm} <= {2*32'b0};
            {Dest} <= 4'b0;
        end
        else begin
            {WB_en, MEM_R_en_MEM, MEM_W_en_MEM} <= {WB_en_in, MEM_R_EN_in, MEM_W_EN_in};
            {ALU_result, Val_Rm} <= {ALU_result_in, Val_Rm_in};
            {Dest} <= {Dest_in};
        end
    end
endmodule