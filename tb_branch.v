`timescale 1ns/1ps

// Branch / flush / new-ALU-op test for riscv_5stage
// Checks: taken beq flushes 2 wrong-path instructions, bne not taken,
// blt taken, srai arithmetic shift.
module tb_branch;

    reg clk;
    reg rst;
    integer errors;
    integer i;

    riscv_5stage dut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task check;
        input [4:0]  r;
        input [31:0] expected;
        begin
            if (dut.u_register_file.registers[r] === expected)
                $display("PASS: x%0d = %0d", r, $signed(expected));
            else begin
                $display("FAIL: x%0d expected %0d, got %0d", r, $signed(expected),
                         $signed(dut.u_register_file.registers[r]));
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        $dumpfile("tb_branch.vcd");
        $dumpvars(0, tb_branch);

        for (i = 0; i < 256; i = i + 1)
            dut.u_instruction_memory.memory[i] = 32'h00000013; // nop

        dut.u_instruction_memory.memory[0]  = 32'h00500093; // addi x1,x0,5
        dut.u_instruction_memory.memory[1]  = 32'h00500113; // addi x2,x0,5
        dut.u_instruction_memory.memory[2]  = 32'h00208663; // beq  x1,x2,+12 (taken)
        dut.u_instruction_memory.memory[3]  = 32'h00100193; // addi x3,x0,1   (must be flushed)
        dut.u_instruction_memory.memory[4]  = 32'h00100213; // addi x4,x0,1   (must be flushed)
        dut.u_instruction_memory.memory[5]  = 32'h00209463; // bne  x1,x2,+8  (not taken)
        dut.u_instruction_memory.memory[6]  = 32'h00700293; // addi x5,x0,7
        dut.u_instruction_memory.memory[7]  = 32'h00104463; // blt  x0,x1,+8  (taken)
        dut.u_instruction_memory.memory[8]  = 32'h00100313; // addi x6,x0,1   (must be flushed)
        dut.u_instruction_memory.memory[9]  = 32'h00900393; // addi x7,x0,9
        dut.u_instruction_memory.memory[10] = 32'hFF000413; // addi x8,x0,-16
        dut.u_instruction_memory.memory[11] = 32'h40245493; // srai x9,x8,2

        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        repeat (25) @(posedge clk);

        check(5'd1, 32'd5);
        check(5'd2, 32'd5);
        check(5'd3, 32'd0);
        check(5'd4, 32'd0);
        check(5'd5, 32'd7);
        check(5'd6, 32'd0);
        check(5'd7, 32'd9);
        check(5'd8, -32'sd16);
        check(5'd9, -32'sd4);

        if (errors == 0) $display("ALL BRANCH TESTS PASSED");
        else             $display("BRANCH TESTS FINISHED WITH %0d ERRORS", errors);
        $finish;
    end

endmodule
