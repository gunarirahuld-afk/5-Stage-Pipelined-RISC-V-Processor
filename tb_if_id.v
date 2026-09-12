`timescale 1ns/1ps

module tb_if_id;

reg clk;
reg rst;
reg [31:0] pc_in;
reg [31:0] pc_plus4_in;
reg [31:0] instruction_in;

wire [31:0] pc_out;
wire [31:0] pc_plus4_out;
wire [31:0] instruction_out;

if_id uut (
    .clk(clk),
    .rst(rst),
    .pc_in(pc_in),
    .pc_plus4_in(pc_plus4_in),
    .instruction_in(instruction_in),
    .pc_out(pc_out),
    .pc_plus4_out(pc_plus4_out),
    .instruction_out(instruction_out)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("if_id.vcd");
    $dumpvars(0, tb_if_id);

    clk = 0;
    rst = 1;
    pc_in = 0;
    pc_plus4_in = 0;
    instruction_in = 0;

    #10;

    rst = 0;
    pc_in = 32'h00000000;
    pc_plus4_in = 32'h00000004;
    instruction_in = 32'h00500093;

    #10;

    pc_in = 32'h00000004;
    pc_plus4_in = 32'h00000008;
    instruction_in = 32'h00A00113;

    #10;

    pc_in = 32'h00000008;
    pc_plus4_in = 32'h0000000C;
    instruction_in = 32'h002081B3;

    #10;

    pc_in = 32'h0000000C;
    pc_plus4_in = 32'h00000010;
    instruction_in = 32'h00310233;

    #10;

    $finish;
end

endmodule