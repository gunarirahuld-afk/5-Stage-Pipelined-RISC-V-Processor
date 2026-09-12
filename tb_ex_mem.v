`timescale 1ns/1ps

module tb_ex_mem;

reg clk;
reg rst;
reg [31:0] alu_result_in;
reg [31:0] write_data_in;
reg [31:0] branch_target_in;
reg zero_in;
reg [4:0] rd_in;
reg reg_write_in;
reg mem_read_in;
reg mem_write_in;
reg mem_to_reg_in;
reg branch_in;

wire [31:0] alu_result_out;
wire [31:0] write_data_out;
wire [31:0] branch_target_out;
wire zero_out;
wire [4:0] rd_out;
wire reg_write_out;
wire mem_read_out;
wire mem_write_out;
wire mem_to_reg_out;
wire branch_out;

ex_mem uut (
    .clk(clk),
    .rst(rst),
    .alu_result_in(alu_result_in),
    .write_data_in(write_data_in),
    .branch_target_in(branch_target_in),
    .zero_in(zero_in),
    .rd_in(rd_in),
    .reg_write_in(reg_write_in),
    .mem_read_in(mem_read_in),
    .mem_write_in(mem_write_in),
    .mem_to_reg_in(mem_to_reg_in),
    .branch_in(branch_in),
    .alu_result_out(alu_result_out),
    .write_data_out(write_data_out),
    .branch_target_out(branch_target_out),
    .zero_out(zero_out),
    .rd_out(rd_out),
    .reg_write_out(reg_write_out),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .mem_to_reg_out(mem_to_reg_out),
    .branch_out(branch_out)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("ex_mem.vcd");
    $dumpvars(0, tb_ex_mem);

    clk = 0;
    rst = 1;
    alu_result_in = 0;
    write_data_in = 0;
    branch_target_in = 0;
    zero_in = 0;
    rd_in = 0;
    reg_write_in = 0;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;
    branch_in = 0;

    #10;

    rst = 0;
    alu_result_in = 32'd100;
    write_data_in = 32'd25;
    branch_target_in = 32'd40;
    zero_in = 0;
    rd_in = 5'd5;
    reg_write_in = 1;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;
    branch_in = 0;

    #10;

    alu_result_in = 32'd200;
    write_data_in = 32'd50;
    branch_target_in = 32'd80;
    zero_in = 1;
    rd_in = 5'd10;
    reg_write_in = 1;
    mem_read_in = 1;
    mem_write_in = 0;
    mem_to_reg_in = 1;
    branch_in = 0;

    #10;

    alu_result_in = 32'd300;
    write_data_in = 32'd75;
    branch_target_in = 32'd120;
    zero_in = 0;
    rd_in = 5'd15;
    reg_write_in = 0;
    mem_read_in = 0;
    mem_write_in = 1;
    mem_to_reg_in = 0;
    branch_in = 0;

    #10;

    alu_result_in = 32'd400;
    write_data_in = 32'd0;
    branch_target_in = 32'd160;
    zero_in = 1;
    rd_in = 5'd0;
    reg_write_in = 0;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;
    branch_in = 1;

    #10;

    $finish;
end

endmodule