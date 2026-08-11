module ID_Stage_Reg (
	input clk, rst, imm_in, flush,
    input [31:0] PC_in, reg_out_in1, reg_out_in2, status_reg_in,
	input [8:0] Exe_Signals_in,
	input [11:0] Shift_Operand_in,
	input [23:0] signed_imm_24_in,
	input [3:0] Dest_in, 
	input [3:0] src1, src2,
	output reg imm, WB_EN, Mem_R_EN, Mem_W_EN, B, S,
	output reg [31:0] PC, reg_out1, reg_out2, status_reg,
	output reg [3:0] EXE_CMD, Dest, src1_out, src2_out,
	output reg [11:0] Shift_Operand,
	output reg [23:0] signed_imm_24
);

    	always @(posedge clk or negedge rst) begin
        	if(rst) begin
            	PC <= 0;
				reg_out1 <= 0; 
				reg_out2 <= 0;
				status_reg <= 0;
				imm <= 0;
				Shift_Operand <= 0;
				signed_imm_24 <= 0;
				Dest <= 0;
				
				WB_EN <= 0;
				Mem_R_EN <= 0;
				Mem_W_EN <= 0;
				EXE_CMD <= 0;
				B <= 0;
				S <= 0;
				src1_out <= 0;
				src2_out <= 0;
	
			end else if (flush) begin
				PC <= 0;
				reg_out1 <= 0; 
				reg_out2 <= 0;
				status_reg <= 0;
				imm <= 0;
				Shift_Operand <= 0;
				signed_imm_24 <= 0;
				Dest <= 0;
				
				WB_EN <= 0;
				Mem_R_EN <= 0;
				Mem_W_EN <= 0;
				EXE_CMD <= 0;
				B <= 0;
				S <= 0;
				src1_out <= 0;
				src2_out <= 0;
			end else begin
            	PC <= PC_in;
				reg_out1 <= reg_out_in1; 
				reg_out2 <= reg_out_in2;
				status_reg <= status_reg_in;
				imm <= imm_in;
				Shift_Operand <= Shift_Operand_in;
				signed_imm_24 <= signed_imm_24_in;
				Dest <= Dest_in;
				
				WB_EN <= Exe_Signals_in[8];
				Mem_R_EN <= Exe_Signals_in[7];
				Mem_W_EN <= Exe_Signals_in[6];
				EXE_CMD <= Exe_Signals_in[5:2];
				B <= Exe_Signals_in[1];
				S <= Exe_Signals_in[0];
				src1_out <= src1;
				src2_out <= src2;
        	end
    	end
endmodule