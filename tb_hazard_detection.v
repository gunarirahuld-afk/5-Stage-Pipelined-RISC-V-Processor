`timescale 1ns/1ps

module tb_hazard_detection;

reg [4:0] id_ex_rd;
reg id_ex_mem_read;
reg [4:0] if_id_rs1;
reg [4:0] if_id_rs2;

wire pc_write;
wire if_id_write;
wire control_stall;

hazard_detection uut (
    .id_ex_rd(id_ex_rd),
    .id_ex_mem_read(id_ex_mem_read),
    .if_id_rs1(if_id_rs1),
    .if_id_rs2(if_id_rs2),
    .pc_write(pc_write),
    .if_id_write(if_id_write),
    .control_stall(control_stall)
);

initial begin
    $dumpfile("hazard_detection.vcd");
    $dumpvars(0, tb_hazard_detection);

    id_ex_rd = 5'd0;
    id_ex_mem_read = 0;
    if_id_rs1 = 5'd1;
    if_id_rs2 = 5'd2;
    #10;

    id_ex_rd = 5'd5;
    id_ex_mem_read = 1;
    if_id_rs1 = 5'd5;
    if_id_rs2 = 5'd2;
    #10;

    id_ex_rd = 5'd5;
    id_ex_mem_read = 1;
    if_id_rs1 = 5'd1;
    if_id_rs2 = 5'd5;
    #10;

    id_ex_rd = 5'd5;
    id_ex_mem_read = 1;
    if_id_rs1 = 5'd1;
    if_id_rs2 = 5'd2;
    #10;

    id_ex_rd = 5'd5;
    id_ex_mem_read = 0;
    if_id_rs1 = 5'd5;
    if_id_rs2 = 5'd2;
    #10;

    id_ex_rd = 5'd0;
    id_ex_mem_read = 1;
    if_id_rs1 = 5'd0;
    if_id_rs2 = 5'd0;
    #10;

    $finish;
end

endmodule