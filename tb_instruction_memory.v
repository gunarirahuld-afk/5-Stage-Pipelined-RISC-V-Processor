`timescale 1ns/1ps

module tb_instruction_memory;

reg [31:0] pc;
wire [31:0] instruction;

instruction_memory uut (
    .pc(pc),
    .instruction(instruction)
);

initial begin
    $dumpfile("instruction_memory.vcd");
    $dumpvars(0, tb_instruction_memory);

    pc = 32'd0;
    #10;

    pc = 32'd4;
    #10;

    pc = 32'd8;
    #10;

    pc = 32'd12;
    #10;

    pc = 32'd16;
    #10;

    pc = 32'd20;
    #10;

    pc = 32'd24;
    #10;

    pc = 32'd28;
    #10;

    $finish;
end

endmodule