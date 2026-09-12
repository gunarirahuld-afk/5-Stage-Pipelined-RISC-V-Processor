`timescale 1ns/1ps

module tb_mem_wb;

reg clk;
reg rst;
reg [31:0] read_data_in;
reg [31:0] alu_result_in;
reg [4:0] rd_in;
reg reg_write_in;
reg mem_to_reg_in;

wire [31:0] read_data_out;
wire [31:0] alu_result_out;
wire [4:0] rd_out;
wire reg_write_out;
wire mem_to_reg_out;

mem_wb uut (
    .clk(clk),
    .rst(rst),
    .read_data_in(read_data_in),
    .alu_result_in(alu_result_in),
    .rd_in(rd_in),
    .reg_write_in(reg_write_in),
    .mem_to_reg_in(mem_to_reg_in),
    .read_data_out(read_data_out),
    .alu_result_out(alu_result_out),
    .rd_out(rd_out),
    .reg_write_out(reg_write_out),
    .mem_to_reg_out(mem_to_reg_out)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("mem_wb.vcd");
    $dumpvars(0, tb_mem_wb);

    clk = 0;
    rst = 1;
    read_data_in = 0;
    alu_result_in = 0;
    rd_in = 0;
    reg_write_in = 0;
    mem_to_reg_in = 0;

    #10;

    rst = 0;
    read_data_in = 32'd100;
    alu_result_in = 32'd50;
    rd_in = 5'd5;
    reg_write_in = 1;
    mem_to_reg_in = 1;

    #10;

    read_data_in = 32'd200;
    alu_result_in = 32'd75;
    rd_in = 5'd10;
    reg_write_in = 1;
    mem_to_reg_in = 0;

    #10;

    read_data_in = 32'd300;
    alu_result_in = 32'd125;
    rd_in = 5'd15;
    reg_write_in = 1;
    mem_to_reg_in = 1;

    #10;

    read_data_in = 32'd0;
    alu_result_in = 32'd400;
    rd_in = 5'd0;
    reg_write_in = 0;
    mem_to_reg_in = 0;

    #10;

    $finish;
end

endmodule