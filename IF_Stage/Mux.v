module Mux #(parameter WIDTH = 32) (
    input[WIDTH-1:0] in1, in2, 
    input sel, 
    output[WIDTH-1:0] out
);

	assign out = sel ? in2 : in1;

endmodule