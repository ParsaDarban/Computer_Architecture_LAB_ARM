module data_mem(
	input clk, Mem_W_EN, MEM_R_EN,
	input [31:0] Data,
	input [31:0] Address,
	output [31:0] Out_Data
	);
	
	reg [31:0] mem [0:2047];
	
	initial begin
		$readmemb("data_mem.mem", mem);
	end
	
	always@ (posedge clk) begin
		if (Mem_W_EN) begin mem[Address] <= Data; end
	end

	assign Out_Data = (MEM_R_EN) ? mem[Address] : 32'b0;
	


endmodule
