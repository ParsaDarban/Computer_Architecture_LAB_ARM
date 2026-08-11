module MEM_Stage_Reg (
    	input clk, rst, Mem_R_EN, WB_EN,
    	input [3:0] dest_mem,
    	input [31:0] alu_res_mem, data_mem, 
    	output reg Mem_R_EN_WB, WB_EN_WB,
	output reg [3:0] dest_mem_WB,
	output reg [31:0] alu_res_WB, data_mem_WB
);
	always @(posedge clk, negedge rst) begin 
		if(rst) begin
			{Mem_R_EN_WB, WB_EN_WB} <= {2'b0};
			{alu_res_WB, data_mem_WB} <= {64'b0};
			dest_mem_WB <= 4'b0;
		end
		else begin
			{Mem_R_EN_WB, WB_EN_WB} <= {Mem_R_EN, WB_EN};
			{alu_res_WB, data_mem_WB} <= {alu_res_mem, data_mem};	
			dest_mem_WB <= dest_mem;
		end
	end

endmodule