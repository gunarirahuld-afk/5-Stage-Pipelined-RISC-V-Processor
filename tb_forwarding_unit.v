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

task check_result;
    input [1:0] expected_a;
    input [1:0] expected_b;
    input [127:0] test_name;

    begin
        #1;

        if ((forward_a === expected_a) &&
            (forward_b === expected_b))
            $display("%s : PASS", test_name);
        else
            $display("%s : FAIL  forward_a=%b forward_b=%b",
                     test_name, forward_a, forward_b);
    end
endtask

initial begin
    $dumpfile("forwarding_unit.vcd");
    $dumpvars(0, tb_forwarding_unit);

    $display("========================================");
    $display(" Forwarding Unit Verification");
    $display("========================================");

    // Test 1: No forwarding
    id_ex_rs1 = 5'd1;
    id_ex_rs2 = 5'd2;
    ex_mem_rd = 5'd0;
    mem_wb_rd = 5'd0;
    ex_mem_reg_write = 0;
    mem_wb_reg_write = 0;

    check_result(2'b00, 2'b00, "TEST 1 - No forwarding");

    // Test 2: EX/MEM -> rs1
    id_ex_rs1 = 5'd5;
    id_ex_rs2 = 5'd2;
    ex_mem_rd = 5'd5;
    mem_wb_rd = 5'd0;
    ex_mem_reg_write = 1;
    mem_wb_reg_write = 0;

    check_result(2'b10, 2'b00, "TEST 2 - EX/MEM rs1");

    // Test 3: MEM/WB -> rs2
    id_ex_rs1 = 5'd1;
    id_ex_rs2 = 5'd10;
    ex_mem_rd = 5'd0;
    mem_wb_rd = 5'd10;
    ex_mem_reg_write = 0;
    mem_wb_reg_write = 1;

    check_result(2'b00, 2'b01, "TEST 3 - MEM/WB rs2");

    // Test 4: Both operands forwarded
    id_ex_rs1 = 5'd5;
    id_ex_rs2 = 5'd10;
    ex_mem_rd = 5'd5;
    mem_wb_rd = 5'd10;
    ex_mem_reg_write = 1;
    mem_wb_reg_write = 1;

    check_result(2'b10, 2'b01, "TEST 4 - Both operands");

    // Test 5: EX/MEM must have priority over MEM/WB
    id_ex_rs1 = 5'd7;
    id_ex_rs2 = 5'd8;
    ex_mem_rd = 5'd7;
    mem_wb_rd = 5'd7;
    ex_mem_reg_write = 1;
    mem_wb_reg_write = 1;

    check_result(2'b10, 2'b00, "TEST 5 - EX/MEM priority");

    // Test 6: x0 must not be forwarded
    id_ex_rs1 = 5'd0;
    id_ex_rs2 = 5'd0;
    ex_mem_rd = 5'd0;
    mem_wb_rd = 5'd0;
    ex_mem_reg_write = 1;
    mem_wb_reg_write = 1;

    check_result(2'b00, 2'b00, "TEST 6 - x0 protection");

    $display("========================================");
    $display(" Verification complete");
    $display("========================================");

    $finish;
end

endmodule