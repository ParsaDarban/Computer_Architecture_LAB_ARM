module mux_WB(
	input Mem_R_En,
	input [31:0] alu_res, mem_data,
	output [31:0] mux_wb_out
	);

	assign mux_wb_out = Mem_R_En ? mem_data : alu_res;

endmodule
