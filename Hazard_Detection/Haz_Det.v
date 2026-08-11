module hazard_det(
	input Two_src, Exe_WB_En, Mem_WB_EN, forward_en, Mem_R_EN_EXE_in,
	input [3:0]src1, src2, Exe_Dest, Mem_Dest,
	output reg Hazard
	);

	wire Hazard_std;
    wire Hazard_ld;


	assign Hazard_std =  ((src1 == Exe_Dest) && (Exe_WB_En == 1'b1)) ||
			 ((src2 == Exe_Dest) && (Exe_WB_En == 1'b1) && (Two_src == 1'b1)) ||
			 ((src1 == Mem_Dest) && (Mem_WB_EN == 1'b1)) ||
			 ((src2 == Mem_Dest) && (Mem_WB_EN == 1'b1) && (Two_src == 1'b1));

	assign Hazard_ld =
        Mem_R_EN_EXE_in & Exe_WB_En & ((src1 == Exe_Dest) | (Two_src & (src2 == Exe_Dest)));

    always @(*) begin
        if (forward_en)
            Hazard = Hazard_ld;
        else
            Hazard = Hazard_std;
    end


endmodule
