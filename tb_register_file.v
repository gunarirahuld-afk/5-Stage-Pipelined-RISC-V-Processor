`timescale 1ns/1ps

module tb_register_file;

reg clk;
reg rst;
reg reg_write;
reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;
reg [31:0] write_data;

wire [31:0] read_data1;
wire [31:0] read_data2;

register_file uut (
    .clk(clk),
    .rst(rst),
    .reg_write(reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("register_file.vcd");
    $dumpvars(0, tb_register_file);

    clk = 0;
    rst = 1;
    reg_write = 0;
    rs1 = 0;
    rs2 = 0;
    rd = 0;
    write_data = 0;

    #10;

    rst = 0;

    rd = 5;
    write_data = 32'd100;
    reg_write = 1;

    #10;

    reg_write = 0;
    rs1 = 5;

    #10;

    rd = 10;
    write_data = 32'd200;
    reg_write = 1;

    #10;

    reg_write = 0;
    rs1 = 5;
    rs2 = 10;

    #10;

    rs1 = 0;
    rs2 = 0;

    #10;

    $finish;
end

endmodule