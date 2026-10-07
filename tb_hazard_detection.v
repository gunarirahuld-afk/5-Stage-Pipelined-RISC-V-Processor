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

task check_result;
    input expected_pc_write;
    input expected_if_id_write;
    input expected_control_stall;
    input [127:0] test_name;

    begin
        #1;

        if ((pc_write === expected_pc_write) &&
            (if_id_write === expected_if_id_write) &&
            (control_stall === expected_control_stall))
            $display("%s : PASS", test_name);
        else
            $display("%s : FAIL  pc_write=%b if_id_write=%b control_stall=%b",
                     test_name, pc_write, if_id_write, control_stall);
    end
endtask

initial begin
    $dumpfile("hazard_detection.vcd");
    $dumpvars(0, tb_hazard_detection);

    $display("========================================");
    $display(" Hazard Detection Unit Verification");
    $display("========================================");

    // Test 1: No hazard
    id_ex_rd = 5'd0;
    id_ex_mem_read = 0;
    if_id_rs1 = 5'd1;
    if_id_rs2 = 5'd2;

    check_result(1'b1, 1'b1, 1'b0, "TEST 1 - No hazard");

    // Test 2: Hazard through rs1
    id_ex_rd = 5'd5;
    id_ex_mem_read = 1;
    if_id_rs1 = 5'd5;
    if_id_rs2 = 5'd2;

    check_result(1'b0, 1'b0, 1'b1, "TEST 2 - rs1 hazard");

    // Test 3: Hazard through rs2
    id_ex_rd = 5'd5;
    id_ex_mem_read = 1;
    if_id_rs1 = 5'd1;
    if_id_rs2 = 5'd5;

    check_result(1'b0, 1'b0, 1'b1, "TEST 3 - rs2 hazard");

    // Test 4: No dependency
    id_ex_rd = 5'd5;
    id_ex_mem_read = 1;
    if_id_rs1 = 5'd1;
    if_id_rs2 = 5'd2;

    check_result(1'b1, 1'b1, 1'b0, "TEST 4 - No dependency");

    // Test 5: Memory read disabled
    id_ex_rd = 5'd5;
    id_ex_mem_read = 0;
    if_id_rs1 = 5'd5;
    if_id_rs2 = 5'd2;

    check_result(1'b1, 1'b1, 1'b0, "TEST 5 - MemRead disabled");

    // Test 6: Destination register x0
    id_ex_rd = 5'd0;
    id_ex_mem_read = 1;
    if_id_rs1 = 5'd0;
    if_id_rs2 = 5'd0;

    check_result(1'b1, 1'b1, 1'b0, "TEST 6 - rd = x0");

    $display("========================================");
    $display(" Verification complete");
    $display("========================================");

    $finish;
end

endmodule