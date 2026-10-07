`timescale 1ns/1ps

module tb_riscv_5stage;

    reg clk;
    reg rst;

    // ------------------------------------------------
    // Functional verification
    // ------------------------------------------------

    integer errors;
    integer test2_wb_count;
    reg test2_active;

    // ------------------------------------------------
    // Performance counters
    // ------------------------------------------------

    integer cycle_count;
    integer instruction_count;
    integer stall_count;
    integer forward_a_count;
    integer forward_b_count;

    // ------------------------------------------------
    // DUT
    // ------------------------------------------------

    riscv_5stage dut (
        .clk(clk),
        .rst(rst)
    );

    // ------------------------------------------------
    // Clock
    // 10 ns period
    // ------------------------------------------------

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ------------------------------------------------
    // Performance monitor
    // ------------------------------------------------

    always @(negedge clk) begin

        if (!rst) begin

            // Count clock cycles
            cycle_count = cycle_count + 1;

            // ----------------------------------------
            // Count completed instructions
            // ----------------------------------------

            if (dut.mem_wb_reg_write &&
                dut.mem_wb_rd != 5'd0) begin

                instruction_count = instruction_count + 1;

                $display(
                    "WB: x%0d = %0d | cycle=%0d",
                    dut.mem_wb_rd,
                    dut.write_back_data,
                    cycle_count
                );

            end

            // ----------------------------------------
            // Count load-use stalls
            // ----------------------------------------

            if (dut.control_stall) begin

                stall_count = stall_count + 1;

                $display(
                    "STALL detected | cycle=%0d",
                    cycle_count
                );

            end

            // ----------------------------------------
            // Count Forward A events
            // ----------------------------------------

            if (dut.forward_a != 2'b00) begin

                forward_a_count = forward_a_count + 1;

                $display(
                    "FWD_A event: %b | cycle=%0d",
                    dut.forward_a,
                    cycle_count
                );

            end

            // ----------------------------------------
            // Count Forward B events
            // ----------------------------------------

            if (dut.forward_b != 2'b00) begin

                forward_b_count = forward_b_count + 1;

                $display(
                    "FWD_B event: %b | cycle=%0d",
                    dut.forward_b,
                    cycle_count
                );

            end

        end

    end

    // ------------------------------------------------
    // Test 2 functional checking
    // ------------------------------------------------

    always @(posedge clk) begin

        #1;

        if (test2_active &&
            dut.mem_wb_reg_write &&
            dut.mem_wb_rd != 5'd0) begin

            test2_wb_count = test2_wb_count + 1;

            case (test2_wb_count)

                // x1 = 5
                1: begin

                    if (dut.mem_wb_rd == 5'd1 &&
                        dut.write_back_data == 32'd5) begin

                        $display("PASS: Test2 x1 = 5");

                    end
                    else begin

                        $display(
                            "FAIL: Test2 expected x1 = 5, got x%0d = %0d",
                            dut.mem_wb_rd,
                            dut.write_back_data
                        );

                        errors = errors + 1;

                    end

                end

                // x2 = 5
                2: begin

                    if (dut.mem_wb_rd == 5'd2 &&
                        dut.write_back_data == 32'd5) begin

                        $display("PASS: Test2 x2 = 5");

                    end
                    else begin

                        $display(
                            "FAIL: Test2 expected x2 = 5, got x%0d = %0d",
                            dut.mem_wb_rd,
                            dut.write_back_data
                        );

                        errors = errors + 1;

                    end

                end

                // x3 = 10
                3: begin

                    if (dut.mem_wb_rd == 5'd3 &&
                        dut.write_back_data == 32'd10) begin

                        $display("PASS: Test2 x3 = 10");

                    end
                    else begin

                        $display(
                            "FAIL: Test2 expected x3 = 10, got x%0d = %0d",
                            dut.mem_wb_rd,
                            dut.write_back_data
                        );

                        errors = errors + 1;

                    end

                end

                // x4 = 15
                4: begin

                    if (dut.mem_wb_rd == 5'd4 &&
                        dut.write_back_data == 32'd15) begin

                        $display("PASS: Test2 x4 = 15");

                    end
                    else begin

                        $display(
                            "FAIL: Test2 expected x4 = 15, got x%0d = %0d",
                            dut.mem_wb_rd,
                            dut.write_back_data
                        );

                        errors = errors + 1;

                    end

                end

                default: begin

                    // Ignore additional writebacks

                end

            endcase

        end

    end

    // ------------------------------------------------
    // Main test sequence
    // ------------------------------------------------

    initial begin

        // Initialize counters

        errors = 0;

        test2_wb_count = 0;
        test2_active = 1'b0;

        cycle_count = 0;
        instruction_count = 0;
        stall_count = 0;
        forward_a_count = 0;
        forward_b_count = 0;

        // ------------------------------------------------
        // VCD waveform
        // ------------------------------------------------

        $dumpfile("riscv_5stage.vcd");
        $dumpvars(0, tb_riscv_5stage);

        $display("");
        $display("========================================");
        $display("  5-STAGE RISC-V BASELINE MEASUREMENT");
        $display("========================================");

        // ------------------------------------------------
        // RESET
        // ------------------------------------------------

        rst = 1'b1;

        repeat (2)
            @(posedge clk);

        rst = 1'b0;

        // ------------------------------------------------
        // TEST 1
        // Arithmetic Dependencies
        // ------------------------------------------------

        $display("");
        $display("----------------------------------------");
        $display("TEST 1: Arithmetic Dependencies");
        $display("----------------------------------------");

        $display("Expected:");
        $display("x1 = 5");
        $display("x2 = 10");
        $display("x3 = 15");
        $display("x4 = 25");
        $display("x5 = 40");
        $display("x6 = 65");
        $display("x7 = 105");
        $display("x8 = 170");

        $display("");

        repeat (12)
            @(posedge clk);

        // ------------------------------------------------
        // TEST 2
        // Load-Use Hazard
        // ------------------------------------------------

        $display("");
        $display("----------------------------------------");
        $display("TEST 2: Load-Use Hazard");
        $display("----------------------------------------");

        $display("Expected:");
        $display("x1 = 5");
        $display("x2 = 5");
        $display("x3 = 10");
        $display("x4 = 15");

        $display("");

        // ------------------------------------------------
        // Reset pipeline
        // ------------------------------------------------

        rst = 1'b1;

        repeat (2)
            @(posedge clk);

        // ------------------------------------------------
        // Load-use test program
        // ------------------------------------------------

        // addi x1, x0, 5
        dut.u_instruction_memory.memory[0] = 32'h00500093;

        // sw x1, 0(x0)
        dut.u_instruction_memory.memory[1] = 32'h00102023;

        // lw x2, 0(x0)
        dut.u_instruction_memory.memory[2] = 32'h00002103;

        // add x3, x2, x1
        dut.u_instruction_memory.memory[3] = 32'h001101B3;

        // add x4, x3, x2
        dut.u_instruction_memory.memory[4] = 32'h00218233;

        // ------------------------------------------------
        // NOPs
        // ------------------------------------------------

        dut.u_instruction_memory.memory[5] = 32'h00000013;
        dut.u_instruction_memory.memory[6] = 32'h00000013;
        dut.u_instruction_memory.memory[7] = 32'h00000013;

        // ------------------------------------------------
        // Start Test 2
        // ------------------------------------------------

        test2_active = 1'b1;
        test2_wb_count = 0;

        rst = 1'b0;

        // ------------------------------------------------
        // Allow pipeline to complete
        // ------------------------------------------------

        repeat (15)
            @(posedge clk);

        test2_active = 1'b0;

        // ------------------------------------------------
        // Final performance report
        // ------------------------------------------------

        $display("");
        $display("========================================");
        $display("       BASELINE PERFORMANCE REPORT");
        $display("========================================");

        $display(
            "Total cycles           : %0d",
            cycle_count
        );

        $display(
            "Instructions completed : %0d",
            instruction_count
        );

        $display(
            "Load-use stalls        : %0d",
            stall_count
        );

        $display(
            "Forward A events       : %0d",
            forward_a_count
        );

        $display(
            "Forward B events       : %0d",
            forward_b_count
        );

        if (instruction_count != 0) begin

            $display(
                "CPI                    : %0f",
                cycle_count * 1.0 / instruction_count
            );

        end
        else begin

            $display("CPI                    : N/A");

        end

        $display("========================================");

        // ------------------------------------------------
        // Functional verification result
        // ------------------------------------------------

        $display("");

        if (errors == 0) begin

            $display("ALL PIPELINE TESTS PASSED");

        end
        else begin

            $display(
                "PIPELINE TESTS FINISHED WITH %0d ERRORS",
                errors
            );

        end

        $display("");

        $display("========================================");

        $finish;

    end

endmodule