`timescale 1ns/1ns

module testbench();

reg rst = 0;
reg clk = 0;
reg forward_en = 1;
    
ARM arm (
    .clk(clk),
    .rst(rst),
    .forward_en(forward_en)
);

    always begin #10;clk=~clk; end

    initial begin
        rst = 1;
        #30
        rst = 0;
        #100000
        $stop;
    end

endmodule 
