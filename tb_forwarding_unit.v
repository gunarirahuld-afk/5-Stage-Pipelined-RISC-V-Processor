`timescale 1ns/1ps

module tb_forwarding_unit;

reg [4:0] id_ex_rs1;
reg [4:0] id_ex_rs2;
reg [4:0] ex_mem_rd;
reg [4:0] mem_wb_rd;
reg ex_mem_reg_write;
reg mem_wb_reg_write;

wire [1:0] forward_a;
wire [1:0] forward_b;

forwarding_unit uut (
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .ex_mem_rd(ex_mem_rd),
    .mem_wb_rd(mem_wb_rd),
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_reg_write(mem_wb_reg_write),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

initial begin
    $dumpfile("forwarding_unit.vcd");
    $dumpvars(0, tb_forwarding_unit);

    id_ex_rs1 = 5'd1;
    id_ex_rs2 = 5'd2;
    ex_mem_rd = 5'd0;
    mem_wb_rd = 5'd0;
    ex_mem_reg_write = 0;
    mem_wb_reg_write = 0;
    #10;

    id_ex_rs1 = 5'd5;
    id_ex_rs2 = 5'd2;
    ex_mem_rd = 5'd5;
    mem_wb_rd = 5'd0;
    ex_mem_reg_write = 1;
    mem_wb_reg_write = 0;
    #10;

    id_ex_rs1 = 5'd1;
    id_ex_rs2 = 5'd10;
    ex_mem_rd = 5'd0;
    mem_wb_rd = 5'd10;
    ex_mem_reg_write = 0;
    mem_wb_reg_write = 1;
    #10;

    id_ex_rs1 = 5'd5;
    id_ex_rs2 = 5'd10;
    ex_mem_rd = 5'd5;
    mem_wb_rd = 5'd10;
    ex_mem_reg_write = 1;
    mem_wb_reg_write = 1;
    #10;

    id_ex_rs1 = 5'd7;
    id_ex_rs2 = 5'd8;
    ex_mem_rd = 5'd7;
    mem_wb_rd = 5'd7;
    ex_mem_reg_write = 1;
    mem_wb_reg_write = 1;
    #10;

    id_ex_rs1 = 5'd0;
    id_ex_rs2 = 5'd0;
    ex_mem_rd = 5'd0;
    mem_wb_rd = 5'd0;
    ex_mem_reg_write = 1;
    mem_wb_reg_write = 1;
    #10;

    $finish;
end

endmodule