`timescale 1ns/1ps

module tb_riscv_5stage;

reg clk;
reg rst;

riscv_5stage uut (
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("riscv.vcd");
    $dumpvars(0, tb_riscv_5stage);

    rst = 1'b1;

    #20;
    rst = 1'b0;

    #300;

    $finish;
end

endmodule