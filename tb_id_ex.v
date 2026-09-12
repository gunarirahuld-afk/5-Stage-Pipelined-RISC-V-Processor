`timescale 1ns/1ps

module tb_id_ex;

reg clk;
reg rst;
reg [31:0] pc_in;
reg [31:0] read_data1_in;
reg [31:0] read_data2_in;
reg [31:0] immediate_in;
reg [4:0] rs1_in;
reg [4:0] rs2_in;
reg [4:0] rd_in;
reg reg_write_in;
reg alu_src_in;
reg mem_read_in;
reg mem_write_in;
reg mem_to_reg_in;
reg branch_in;
reg [3:0] alu_control_in;

wire [31:0] pc_out;
wire [31:0] read_data1_out;
wire [31:0] read_data2_out;
wire [31:0] immediate_out;
wire [4:0] rs1_out;
wire [4:0] rs2_out;
wire [4:0] rd_out;
wire reg_write_out;
wire alu_src_out;
wire mem_read_out;
wire mem_write_out;
wire mem_to_reg_out;
wire branch_out;
wire [3:0] alu_control_out;

id_ex uut (
    .clk(clk),
    .rst(rst),
    .pc_in(pc_in),
    .read_data1_in(read_data1_in),
    .read_data2_in(read_data2_in),
    .immediate_in(immediate_in),
    .rs1_in(rs1_in),
    .rs2_in(rs2_in),
    .rd_in(rd_in),
    .reg_write_in(reg_write_in),
    .alu_src_in(alu_src_in),
    .mem_read_in(mem_read_in),
    .mem_write_in(mem_write_in),
    .mem_to_reg_in(mem_to_reg_in),
    .branch_in(branch_in),
    .alu_control_in(alu_control_in),
    .pc_out(pc_out),
    .read_data1_out(read_data1_out),
    .read_data2_out(read_data2_out),
    .immediate_out(immediate_out),
    .rs1_out(rs1_out),
    .rs2_out(rs2_out),
    .rd_out(rd_out),
    .reg_write_out(reg_write_out),
    .alu_src_out(alu_src_out),
    .mem_read_out(mem_read_out),
    .mem_write_out(mem_write_out),
    .mem_to_reg_out(mem_to_reg_out),
    .branch_out(branch_out),
    .alu_control_out(alu_control_out)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("id_ex.vcd");
    $dumpvars(0, tb_id_ex);

    clk = 0;
    rst = 1;
    pc_in = 0;
    read_data1_in = 0;
    read_data2_in = 0;
    immediate_in = 0;
    rs1_in = 0;
    rs2_in = 0;
    rd_in = 0;
    reg_write_in = 0;
    alu_src_in = 0;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;
    branch_in = 0;
    alu_control_in = 0;

    #10;

    rst = 0;
    pc_in = 32'h00000000;
    read_data1_in = 32'd10;
    read_data2_in = 32'd20;
    immediate_in = 32'd5;
    rs1_in = 5'd1;
    rs2_in = 5'd2;
    rd_in = 5'd3;
    reg_write_in = 1;
    alu_src_in = 0;
    mem_read_in = 0;
    mem_write_in = 0;
    mem_to_reg_in = 0;
    branch_in = 0;
    alu_control_in = 4'b0000;

    #10;

    pc_in = 32'h00000004;
    read_data1_in = 32'd30;
    read_data2_in = 32'd40;
    immediate_in = 32'd8;
    rs1_in = 5'd3;
    rs2_in = 5'd4;
    rd_in = 5'd5;
    reg_write_in = 1;
    alu_src_in = 1;
    alu_control_in = 4'b0000;

    #10;

    pc_in = 32'h00000008;
    read_data1_in = 32'd50;
    read_data2_in = 32'd60;
    immediate_in = 32'd12;
    rs1_in = 5'd5;
    rs2_in = 5'd6;
    rd_in = 5'd7;
    reg_write_in = 0;
    alu_src_in = 1;
    mem_read_in = 1;
    mem_write_in = 0;
    mem_to_reg_in = 1;
    branch_in = 0;
    alu_control_in = 4'b0000;

    #10;

    pc_in = 32'h0000000C;
    read_data1_in = 32'd70;
    read_data2_in = 32'd80;
    immediate_in = 32'd16;
    rs1_in = 5'd7;
    rs2_in = 5'd8;
    rd_in = 5'd9;
    reg_write_in = 0;
    alu_src_in = 1;
    mem_read_in = 0;
    mem_write_in = 1;
    mem_to_reg_in = 0;
    branch_in = 0;
    alu_control_in = 4'b0000;

    #10;

    $finish;
end

endmodule