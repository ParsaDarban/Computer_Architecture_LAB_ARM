module ID_Stage (
	input clk, rst, writeBackEN, Hazard_in,
    	input [31:0] PC_in, instruction, Result_WB, status,
	input [3:0] Dest_WB,
    	output [31:0] PC, reg_out1, reg_out2,
	output [3:0] src1, src2, Dest,
	output [8:0] Exe_Signals,
	output [11:0] Shifter_Operand,
	output [23:0]signed_imm_24,
	output Two_Src, I
);
	wire [3:0] Cond;
	wire [1:0] Mode;
	wire [3:0] Opcode;
	wire S;
	wire [3:0] Rn;
	wire [3:0] Rd;
	wire [3:0] Rm;

	wire uncond_Mem_R_En, uncond_Mem_W_En, Cond_Haz_OR, pass;
	wire [8:0]signal_out_Mux;

	assign Cond   = instruction[31:28];
	assign Mode   = instruction[27:26];
	assign I      = instruction[25];
	assign Opcode = instruction[24:21];
	assign S      = instruction[20];
	assign Rn     = instruction[19:16];
	assign Rd     = instruction[15:12];
	assign Shifter_Operand = instruction[11:0];
	
	assign src1 = Rn;
	assign Rm = (I == 0 && Shifter_Operand[4] == 0)? Shifter_Operand[3:0]: 4'b0;
	assign signed_imm_24 = (Mode == 2'b10) ? instruction[23:0] : 24'b0;
	assign Two_Src = ~(I | uncond_Mem_R_En);
	
	control_unit control_unit(
	.mode(Mode),
	.Opcode(Opcode),
	.S(S),
	.uncond_Mem_R_En(uncond_Mem_R_En),
 	.uncond_Mem_W_En(uncond_Mem_W_En),
	.signal_out_Mux(signal_out_Mux)
	);

	ID_Mux #(
        	.WIDTH(9)
    	) mux1 (
        .in1(signal_out_Mux),
        .in2(9'b0),
        .sel(Cond_Haz_OR),
        .out(Exe_Signals)
    	);

	ID_Mux #(
        	.WIDTH(4)
    	) mux2 (
        .in1(Rm),
        .in2(Rd),
        .sel(uncond_Mem_W_En),
        .out(src2)
    	);

	RegisterFile registerFile(
	.clk(clk),
	.rst(rst),
	.src1(src1),
	.src2(src2),
	.Dest_WB(Dest_WB),
	.Result_WB(Result_WB),
	.writeBackEN(writeBackEN),
	.reg_out1(reg_out1),
	.reg_out2(reg_out2)
	);

	Condition_Check condition_check(
	.Cond(Cond),
	.status(status),
	.pass(pass)
	);
	
	assign Cond_Haz_OR = (~pass) || Hazard_in; 
	assign PC = PC_in;
	assign Dest = Rd;
endmodule
