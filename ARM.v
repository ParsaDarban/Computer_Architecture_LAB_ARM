
`include "IF_Stage/Adder.v"
`include "IF_Stage/IF_Stage_Reg.v"
`include "IF_Stage/IF_Stage.v"
`include "IF_Stage/instruction_mem.v"
`include "IF_Stage/Mux.v"
`include "IF_Stage/PC_Reg.v"


`include "ID_Stage/ID_Stage_Reg.v"
`include "ID_Stage/ID_Stage.v"
`include "ID_Stage/RegisterFile.v"
`include "ID_Stage/EXE_CMD_MUX.v"
`include "ID_Stage/Control_Unit.v"
`include "ID_Stage/Condition_Check.v"


`include "EXE_Stage/EXE_Stage_Reg.v"
`include "EXE_Stage/EXE_Stage.v"
`include "EXE_Stage/ALU.v"
`include "EXE_Stage/Status_Reg.v"
`include "EXE_Stage/Val2Generate.v"


`include "MEM_Stage/MEM_Stage_Reg.v"
`include "MEM_Stage/MEM_Stage.v"
`include "MEM_Stage/Data_Memory.v"

`include "WB_Stage/WB_Stage_Reg.v"
`include "WB_Stage/WB_Stage.v"
`include "WB_Stage/Mux_WB.v"

`include "Hazard_Detection/Haz_Det.v"


module ARM (
    	input clk, rst, forward_en
	);

    // IF Stage Signals
    wire [31:0] IF_pc_out, IF_instr_out;
    
    // IF-ID Pipeline Signals
    wire [31:0] IF_pc_out_ID, IF_instr_out_ID;

    // ID Stage Signals
	wire writeBackEN_ID, Hazard_in_ID, Two_Src_ID, I_ID;
	wire [31:0] Result_WB_ID, status_ID, reg_out1_ID, reg_out2_ID;
    wire [31:0] ID_pc_out;
	wire [3:0] Dest_WB_ID, src1_ID, src2_ID, Dest_ID;
	wire [8:0] Exe_Signals_ID;
	wire [11:0] Shifter_Operand_ID;
	wire [23:0]signed_imm_24_ID;

    // ID-EXE Pipeline Signals   
	wire imm_EXE_in, WB_EN_EXE_in, Mem_R_EN_EXE_in, Mem_W_EN_EXE_in, B_EXE_in, S_EXE_in;
	wire [31:0] ID_pc_out_EXE, reg_out1_EXE_in, reg_out2_EXE_in, status_reg_EXE_in;
	wire [3:0] EXE_CMD_EXE_in, Dest_EXE_in;
	wire [11:0] Shift_Operand_EXE_in;
	wire [23:0] signed_imm_24_EXE_in;

    // EXE Stage Signals
   	wire [31:0] EXE_pc_out;
	wire [31:0] ALU_result_EXE, BR_addr_EXE, Val_Rm_out_EXE;
	wire [31:0] status_EXE;

    // EXE-MEM Pipeline Signals
    wire [31:0] EXE_pc_out_MEM;
	wire WB_en_MEM, MEM_R_en_MEM, MEM_W_en_MEM;
	wire [31:0] ALU_result_MEM, Val_Rm_MEM;
	wire [3:0] Dest_MEM;

    // MEM Stage Signals
	wire WB_EN_out_MEM, Mem_R_En_out_MEM;
	wire [3:0] dest_out_MEM;
	wire [31:0] alu_res_out_MEM, data_out_MEM;

    // MEM-WB Pipeline Signals
    wire Mem_R_EN_WB, WB_EN_WB;
	wire [3:0] dest_mem_WB;
	wire [31:0] alu_res_WB, data_mem_WB;

	wire [1:0] sel_src1, sel_src2;
	wire [3:0] src1_EXE;
    wire [3:0] src2_EXE;
    
   	IF_Stage IF_stage(
       	.clk(clk),
       	.rst(rst),
       	.Branch_taken(B_EXE_in),
       	.freeze(Hazard_in_ID),
       	.BranchAddr(BR_addr_EXE),
       	.PC(IF_pc_out),
       	.Instruction(IF_instr_out)
   	);
	
   	IF_Stage_Reg IF_reg(
       	.clk(clk),
       	.rst(rst),
       	.freeze(Hazard_in_ID),
       	.flush(B_EXE_in),
       	.PC_in(IF_pc_out),
       	.Instruction_in(IF_instr_out),
       	.PC(IF_pc_out_ID),
       	.Instruction(IF_instr_out_ID)
   	);

   	ID_Stage ID_stage(
       	.clk(clk),
       	.rst(rst),
		.writeBackEN(writeBackEN_ID),
		.Hazard_in(Hazard_in_ID),
		.PC_in(IF_pc_out_ID),
		.instruction(IF_instr_out_ID),
		.Result_WB(Result_WB_ID),
		.status(status_ID),
		.Dest_WB(Dest_WB_ID),
		.PC(ID_pc_out),
		.reg_out1(reg_out1_ID),
		.reg_out2(reg_out2_ID),
		.src1(src1_ID), 
		.src2(src2_ID), 
		.Dest(Dest_ID),
		.Exe_Signals(Exe_Signals_ID),
		.Shifter_Operand(Shifter_Operand_ID),
		.signed_imm_24(signed_imm_24_ID),
		.Two_Src(Two_Src_ID),
		.I(I_ID)
   	);

   	ID_Stage_Reg ID_reg(
       	.clk(clk),
       	.rst(rst),
		.src1(src1_ID),
		.src2(src2_ID),
		.src1_out(src1_EXE),
		.src2_out(src2_EXE),
		.imm_in(I_ID),
		.flush(B_EXE_in),
       	.PC_in(ID_pc_out),
		.reg_out_in1(reg_out1_ID),
		.reg_out_in2(reg_out2_ID),
		.status_reg_in(status_ID),
		.Exe_Signals_in(Exe_Signals_ID),
		.Shift_Operand_in(Shifter_Operand_ID),
		.signed_imm_24_in(signed_imm_24_ID),
		.Dest_in(Dest_ID),
		.imm(imm_EXE_in),
		.WB_EN(WB_EN_EXE_in),
		.Mem_R_EN(Mem_R_EN_EXE_in), 
		.Mem_W_EN(Mem_W_EN_EXE_in), 
		.B(B_EXE_in),
		.S(S_EXE_in),
       	.PC(ID_pc_out_EXE),
		.reg_out1(reg_out1_EXE_in), 
		.reg_out2(reg_out2_EXE_in), 
		.status_reg(status_reg_EXE_in),
		.EXE_CMD(EXE_CMD_EXE_in),
		.Dest(Dest_EXE_in),
		.Shift_Operand(Shift_Operand_EXE_in),
		.signed_imm_24(signed_imm_24_EXE_in)
   	);

	EXE_Stage EX_stage(
       	.clk(clk),
		.EXE_CMD(EXE_CMD_EXE_in),
		.MEM_R_EN(Mem_R_EN_EXE_in), 
		.MEM_W_EN(Mem_W_EN_EXE_in),
       	.PC_in(ID_pc_out_EXE),
		.Val_Rn(reg_out1_EXE_in),
		.Val_Rm(reg_out2_EXE_in),
		.imm(imm_EXE_in),
		.Shift_operand(Shift_Operand_EXE_in),
		.Signed_imm_24(signed_imm_24_EXE_in),
		.SR(status_reg_EXE_in),
		.ALU_result(ALU_result_EXE),
		.BR_addr(BR_addr_EXE),
		.Val_Rm_out(Val_Rm_out_EXE),
		.status(status_EXE),
		.sel_src1(sel_src1),
		.sel_src2(sel_src2),
		.WB_fwd_data(Result_WB_ID),
		.MEM_fwd_data(ALU_result_MEM)
   	);

   	EXE_Stage_Reg EX_reg(
       	.clk(clk),
       	.rst(rst),
		.WB_en_in(WB_EN_EXE_in),
		.MEM_R_EN_in(Mem_R_EN_EXE_in),
		.MEM_W_EN_in(Mem_W_EN_EXE_in),
		.ALU_result_in(ALU_result_EXE),
		.Val_Rm_in(Val_Rm_out_EXE),
		.Dest_in(Dest_EXE_in),
		.WB_en(WB_en_MEM),
		.MEM_R_en_MEM(MEM_R_en_MEM),
		.MEM_W_en_MEM(MEM_W_en_MEM),
		.ALU_result(ALU_result_MEM),
		.Val_Rm(Val_Rm_MEM),
		.Dest(Dest_MEM)
    );

	Status_Reg sts_reg(
		.clk(clk),
		.rst(rst),
		.StatusBits(status_EXE),
		.S(S_EXE_in),
		.out(status_ID)
	);

   	MEM_Stage MEM_stage(
       	.clk(clk),
       	.rst(rst),
       	.WB_EN(WB_en_MEM), 
		.Mem_R_En(MEM_R_en_MEM), 
		.Mem_W_En(MEM_W_en_MEM),
		.dest(Dest_MEM), 
		.alu_res(ALU_result_MEM), 
		.data(Val_Rm_MEM), 
		.WB_EN_out(WB_EN_out_MEM), 
		.Mem_R_En_out(Mem_R_En_out_MEM),
		.dest_out(dest_out_MEM),
		.alu_res_out(alu_res_out_MEM), 
		.data_out(data_out_MEM)
   	);

   	MEM_Stage_Reg MEM_reg(
       	.clk(clk),
       	.rst(rst),
       	.Mem_R_EN(Mem_R_En_out_MEM), 
		.WB_EN(WB_EN_out_MEM),
		.dest_mem(dest_out_MEM),
		.alu_res_mem(alu_res_out_MEM), 
		.data_mem(data_out_MEM),
		.Mem_R_EN_WB(Mem_R_EN_WB), 
		.WB_EN_WB(WB_EN_WB),
		.dest_mem_WB(dest_mem_WB),
		.alu_res_WB(alu_res_WB), 
		.data_mem_WB(data_mem_WB)
   	);

   	WB_Stage WB_stage(
       	.clk(clk),
       	.rst(rst),
		.WB_EN(WB_EN_WB),
		.Mem_R_En(Mem_R_EN_WB),
		.dest(dest_mem_WB),
		.alu_res(alu_res_WB),
		.mem_data(data_mem_WB),
		.WB_EN_out(writeBackEN_ID),
		.dest_out(Dest_WB_ID),
		.val_out(Result_WB_ID)
   	);
	hazard_det hazard_det(
		.forward_en(forward_en),
		.Mem_R_EN_EXE_in(Mem_R_EN_EXE_in),
		.Two_src(Two_Src_ID), 
		.Exe_WB_En(WB_EN_EXE_in), 
		.Mem_WB_EN(WB_en_MEM),
		.src1(src1_ID), 
		.src2(src2_ID), 
		.Exe_Dest(Dest_EXE_in), 
		.Mem_Dest(Dest_MEM),
		.Hazard(Hazard_in_ID)
	);
	Forwarding_Unit Forwarding_Unit_inst(
        .forward_en(forward_en),
        .src1(src1_EXE), .src2(src2_EXE),
        .wb_en_mem(WB_en_MEM), .dest_mem(Dest_MEM),
        .wb_wb_en(writeBackEN_ID), .dest_wb(Dest_WB_ID),
        .sel_src1(sel_src1), .sel_src2(sel_src2)
    );


endmodule