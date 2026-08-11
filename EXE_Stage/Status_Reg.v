module Status_Reg(
    input [31:0] StatusBits,
    input clk, rst, S,
    output reg [31:0] out
    );

    always @(negedge clk,posedge rst) begin
        if (rst) begin
            out <= 32'd0;
        end
        else if (S) begin
            out <= StatusBits;
        end
        else
            out <= out;
    end
    
endmodule