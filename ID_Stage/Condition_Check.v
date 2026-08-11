module Condition_Check(
	input [3:0] Cond,
	input [31:0] status,
	output reg pass
);

	wire N = status[31];
	wire Z = status[30];
	wire C = status[29];
	wire V = status[28];

	always @(*) begin
		pass = 0;
		case(Cond)
			4'b0000: begin pass = (Z == 1); end
			4'b0001: begin pass = (Z == 0); end
			4'b0010: begin pass = (C == 1); end
			4'b0011: begin pass = (C == 0); end
			4'b0100: begin pass = (N == 1); end
			4'b0101: begin pass = (N == 0); end
			4'b0110: begin pass = (V == 1); end
			4'b0111: begin pass = (V == 0); end
			4'b1000: begin pass = (C == 1 && Z == 0); end
			4'b1001: begin pass = (C == 0 || Z == 1); end
			4'b1010: begin pass = (N == V); end
			4'b1011: begin pass = (N != V); end
			4'b1100: begin pass = (Z == 0 && N == V); end
			4'b1101: begin pass = (Z == 1 || N != V); end
			4'b1110: begin pass = 1; end
			4'b1111: begin pass = 0; end
		endcase
	end
endmodule
