module WB_Stage (
    	input clk, rst, WB_EN, Mem_R_En, 
    	input [3:0] dest,
	input [31:0] alu_res, mem_data,
	output WB_EN_out,
	output [3:0] dest_out,
	output [31:0] val_out
	);
	
	assign WB_EN_out = WB_EN;
	assign dest_out = dest;

	mux_WB mux_WB(
		.Mem_R_En(Mem_R_En),
		.alu_res(alu_res),
		.mem_data(mem_data),
		.mux_wb_out(val_out)
		);

endmodule
