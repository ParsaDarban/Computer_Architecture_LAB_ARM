module RegisterFile(
	input clk,
	input rst,
	input [3:0] src1,
	input [3:0] src2,
	input [3:0] Dest_WB,
	input [31:0] Result_WB,
	input writeBackEN,
	output [31:0] reg_out1,
	output [31:0] reg_out2
);

	reg [31:0] registers [0:14];
	integer i;
	
	assign reg_out1 = (src1 <= 14) ? registers[src1] : 32'b0;
	assign reg_out2 = (src2 <= 14) ? registers[src2] : 32'b0;

	always @(negedge clk or negedge rst) begin
		if (rst) begin
			for(i = 0; i<=14; i = i+1)
			registers[i] <= i;
		end
		else begin 
			if(writeBackEN && (Dest_WB <= 14)) begin
				registers[Dest_WB] <= Result_WB;
			end
		end
	end
endmodule
