module Mux4to1 #(parameter WIDTH = 32) (input[WIDTH-1:0] num1, num2, num3, input[1:0] sel, output[WIDTH-1:0] out_mux);
	assign out_mux = (sel == {2'b00}) ? num1 :
                     (sel == {2'b01}) ? num2 :
                     (sel == {2'b10}) ? num3 : 4'bz;
endmodule
