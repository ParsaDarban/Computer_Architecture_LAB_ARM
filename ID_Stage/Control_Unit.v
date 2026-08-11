module control_unit(
	input [1:0] mode,
	input [3:0] Opcode,
	input S,
	output reg uncond_Mem_R_En,
 	output reg uncond_Mem_W_En,
	output [8:0] signal_out_Mux
);

	localparam Exe_Mov = 4'b0001;
	localparam Exe_Mvn = 4'b1001;
	localparam Exe_Add = 4'b0010;
	localparam Exe_Adc = 4'b0011;
	localparam Exe_Sub = 4'b0100;
	localparam Exe_Sbc = 4'b0101;
	localparam Exe_And = 4'b0110;
	localparam Exe_Orr = 4'b0111;
	localparam Exe_Eor = 4'b1000;
	localparam Exe_Cmp = Exe_Sub;
	localparam Exe_Tst = Exe_And;
	localparam Exe_Ldr = Exe_Add;
	localparam Exe_Str = Exe_Add;	
	localparam Exe_B   = 4'b0000;
	
	reg [3:0] EXE_CMD;
	reg WB_EN;
	reg MEM_R_EN;
	reg MEM_W_EN;
	reg B_Out;
	reg S_Out;
	
	always @(*) begin
		EXE_CMD  = 4'b0000;
		WB_EN    = 1'b0;
		MEM_R_EN = 1'b0;
		MEM_W_EN = 1'b0;
		B_Out = 1'b0;
		S_Out = 1'b0;
		uncond_Mem_W_En = 1'b0;
		uncond_Mem_R_En = 1'b0;

		if (mode == 2'b00) begin
			S_Out = S;
			
			case(Opcode)
				4'b1101: begin EXE_CMD = Exe_Mov; WB_EN = 1'b1; end 
				4'b1111: begin EXE_CMD = Exe_Mvn; WB_EN = 1'b1; end 
				4'b0100: begin EXE_CMD = Exe_Add; WB_EN = 1'b1; end
				4'b0101: begin EXE_CMD = Exe_Adc; WB_EN = 1'b1; end
				4'b0010: begin EXE_CMD = Exe_Sub; WB_EN = 1'b1; end
				4'b0110: begin EXE_CMD = Exe_Sbc; WB_EN = 1'b1; end
				4'b1100: begin EXE_CMD = Exe_Orr; WB_EN = 1'b1; end
				4'b0001: begin EXE_CMD = Exe_Eor; WB_EN = 1'b1; end
				4'b1010: begin EXE_CMD = Exe_Cmp; WB_EN = 1'b0; S_Out = 1'b1; end
				4'b1000: begin EXE_CMD = Exe_Tst; WB_EN = 1'b0; S_Out = 1'b1; end
				4'b0000: begin EXE_CMD = Exe_And; WB_EN = 1'b1;end

				default: begin EXE_CMD = 4'b0000; WB_EN = 1'b0; S_Out = 1'b0; end
			endcase
		end

		else if (mode == 2'b01) begin
			if (Opcode == 4'b0100) begin
				case(S)
					1'b1: begin EXE_CMD = Exe_Ldr; MEM_R_EN = 1'b1; MEM_W_EN = 1'b0; WB_EN = 1'b1; uncond_Mem_R_En = 1'b1; end
					1'b0: begin EXE_CMD = Exe_Str; MEM_R_EN = 1'b0; MEM_W_EN = 1'b1; WB_EN = 1'b0; uncond_Mem_W_En = 1'b1; end	
				endcase
			end
		end

		else if (mode == 2'b10) begin
			B_Out = 1'b1;	
		end
	end
	assign signal_out_Mux = {WB_EN, MEM_R_EN, MEM_W_EN, EXE_CMD, B_Out, S_Out};			
endmodule
