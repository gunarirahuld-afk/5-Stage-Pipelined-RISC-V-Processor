`timescale 1ns/1ps

module tb_immediate_generator;

reg [31:0] instruction;
wire [31:0] immediate;

immediate_generator uut (
    .instruction(instruction),
    .immediate(immediate)
);

initial begin
    $dumpfile("immediate_generator.vcd");
    $dumpvars(0, tb_immediate_generator);

    instruction = 32'b00000000010100000000001010010011;
    #10;

    instruction = 32'b00000000010100000010001010100011;
    #10;

    instruction = 32'b00000000010100001000010001100011;
    #10;

    instruction = 32'b0;
    #10;

    $finish;
end

endmodule