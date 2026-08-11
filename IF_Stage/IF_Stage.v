module IF_Stage (
    input clk, rst, freeze, Branch_taken,
    input [31:0] BranchAddr,
    output [31:0] PC, Instruction
);

    wire[31:0] adder_out, mux_out, PC_reg_out;
    wire [10:0] instr_addr;
    wire co;

    Mux #(
        .WIDTH(32)
    ) mux (
        .in1(adder_out),
        .in2(BranchAddr),
        .sel(Branch_taken),
        .out(mux_out)
    );

    Adder #(
        .WIDTH(32)
    ) adder (
        .in1(PC_reg_out),
        .in2(32'd1),
        .out(adder_out),
        .co(co)
    );

    PC_Reg#(
       .WIDTH(32)
    )
     pc_reg (
        .clk(clk),
        .rst(rst),
        .ld_data(1'b1),
        .freeze(freeze),
        .ParIn(mux_out),
        .data(PC_reg_out)
    );

    instruction_mem instr_mem(
        .addr(instr_addr),
        .instruction(Instruction)
    );

    assign PC = adder_out;
    assign instr_addr = PC_reg_out [10:0];

endmodule