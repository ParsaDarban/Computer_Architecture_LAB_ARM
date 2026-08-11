module MEM_Stage(
    	input clk, rst, WB_EN, Mem_R_En, Mem_W_En,
	input [3:0] dest, 
    	input [31:0] alu_res, data, 
	output WB_EN_out, Mem_R_En_out,
	output [3:0] dest_out,
	output [31:0] alu_res_out, data_out
	);

	assign alu_res_out = alu_res;
	assign WB_EN_out = WB_EN;
	assign Mem_R_En_out = Mem_R_En;
	assign dest_out = dest;

	data_mem data_mem(
		.clk(clk),
		.Mem_W_EN(Mem_W_En),
		.Data(data),
		.MEM_R_EN(Mem_R_En),
		.Address(alu_res),
		.Out_Data(data_out)
		);

endmodule