module Adder #(parameter WIDTH = 32) (
    input [WIDTH-1:0] in1, in2, 
    output [WIDTH-1:0] out, 
    output co
);
    assign {co, out} = in1 + in2;

endmodule