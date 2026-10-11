# 5-Stage Pipelined RISC-V Processor with Memory and SPI Interface

## Overview

This project implements a 5-stage pipelined RISC-V processor using Verilog HDL. The design includes instruction and data memory, pipeline registers, forwarding logic, and hazard detection logic. The RTL was simulated using Icarus Verilog, analyzed using GTKWave, and synthesized using Yosys.

## Features

* 5-stage processor pipeline: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB)
* Instruction and data memory modules
* Arithmetic Logic Unit (ALU)
* Register file and immediate generator
* Control unit
* Pipeline registers between stages
* Forwarding unit
* Hazard detection unit
* RTL simulation and waveform analysis
* Yosys synthesis and RTL schematic generation

## Architecture

The processor is organized into five pipeline stages:

1. **Instruction Fetch (IF):** Fetches instructions and calculates the next program counter.
2. **Instruction Decode (ID):** Decodes instructions, generates control signals, and reads register operands.
3. **Execute (EX):** Performs ALU operations and evaluates execution results.
4. **Memory Access (MEM):** Handles data-memory operations.
5. **Write Back (WB):** Writes results back to the register file.

## Project Structure

```text
5-Stage-Pipelined-RISC-V-Processor/
├── alu.v
├── control_unit.v
├── data_memory.v
├── ex_mem.v
├── forwarding_unit.v
├── hazard_detection.v
├── id_ex.v
├── if_id.v
├── immediate_generator.v
├── instruction_memory.v
├── mem_wb.v
├── register_file.v
├── riscv_5stage.v
├── tb_riscv_5stage.v
├── riscv.vcd
├── riscv_synth.v
├── riscv_schematic.png
└── README.md
```

## Tools Used

* **Verilog HDL** — RTL design
* **Icarus Verilog** — RTL compilation and simulation
* **GTKWave** — Waveform analysis
* **Yosys** — RTL synthesis and design checking
* **Graphviz** — Schematic image generation

## Simulation

Compile the design and testbench from the project directory:

```bash
iverilog -g2012 -o riscv_sim alu.v control_unit.v data_memory.v ex_mem.v forwarding_unit.v hazard_detection.v id_ex.v if_id.v immediate_generator.v instruction_memory.v mem_wb.v register_file.v riscv_5stage.v tb_riscv_5stage.v
```

Run the simulation:

```bash
vvp riscv_sim
```

Expected completion message:

```text
RISC-V SIMULATION: PASS
```

The simulation generates `riscv.vcd` for waveform inspection.

## Waveform Analysis

Open the generated waveform using GTKWave:

```bash
gtkwave riscv.vcd
```

Use the waveform to inspect the program counter, instruction, pipeline signals, register data, memory controls, and write-back signals.

## Synthesis

The RTL was synthesized and checked using Yosys.

Load the design files:

```text
read_verilog alu.v control_unit.v data_memory.v ex_mem.v forwarding_unit.v hazard_detection.v id_ex.v if_id.v immediate_generator.v instruction_memory.v mem_wb.v register_file.v riscv_5stage.v
```

Prepare the top-level design:

```text
prep -top riscv_5stage
```

The completed Yosys design check reported:

```text
Found and reported 0 problems.
```

Generate the synthesized Verilog netlist:

```text
write_verilog -noattr riscv_synth.v
```

Generate the RTL schematic:

```text
show -format dot -prefix riscv_schematic
```

## Results

* RTL simulation completed and displayed the testbench PASS message.
* GTKWave waveform generated for simulation analysis.
* Yosys synthesis and design checking completed with zero reported problems.
* Synthesized Verilog netlist and schematic generated.

**Note:** A successful Yosys design check confirms that no problems were reported by that check; it does not by itself prove that every processor instruction or hazard scenario is functionally correct.

## Author

**Rahul D G**
Electronics and Communication Engineering

