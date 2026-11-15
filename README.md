# 5-Stage Pipelined RISC-V Processor (Verilog)

A 5-stage pipelined RISC-V CPU in Verilog HDL, with data forwarding and hazard detection, verified in simulation and synthesized with Yosys.

![Verilog](https://img.shields.io/badge/Verilog-HDL-blue) ![RISC-V](https://img.shields.io/badge/RISC--V-RV32-green) ![Yosys](https://img.shields.io/badge/Yosys-0%20problems-orange) ![Sim](https://img.shields.io/badge/Simulation-PASS-brightgreen)

## Highlights

- Classic IF → ID → EX → MEM → WB pipeline with IF/ID, ID/EX, EX/MEM and MEM/WB pipeline registers
- **Forwarding unit** resolves RAW data hazards without stalling where possible
- **Hazard detection unit** inserts stalls for load-use hazards
- **Branches resolved in EX** with forwarded operands; a taken branch flushes IF/ID and ID/EX (2-cycle penalty)
- Separate instruction and data memory, register file, ALU, immediate generator and control unit
- Self-checking testbenches: load-use hazard test with CPI/stall/forwarding counters, and a branch/flush test, GTKWave waveforms, Yosys RTL schematic

## Supported instructions

RV32I subset: R-type `add sub and or xor sll srl sra slt sltu`, I-type `addi andi ori xori slli srli srai slti sltiu`, `lw`, `sw`, and all six branches `beq bne blt bge bltu bgeu`. Not yet implemented: `jal/jalr`, `lui/auipc`, byte/half-word loads and stores.

## Architecture

| Stage | What it does |
|---|---|
| IF | Fetches the instruction and computes the next PC |
| ID | Decodes, generates control signals, reads registers, builds the immediate |
| EX | ALU operation and branch decision; forwarded operands selected here; a taken branch redirects the PC and flushes IF/ID and ID/EX |
| MEM | Data-memory load/store |
| WB | Writes the result back to the register file |

![RTL schematic](riscv_schematic.png)

## Repository layout

| File | Module |
|---|---|
| `riscv_5stage.v` | Top level |
| `if_id.v`, `id_ex.v`, `ex_mem.v`, `mem_wb.v` | Pipeline registers |
| `alu.v`, `control_unit.v`, `register_file.v`, `immediate_generator.v` | Datapath and control |
| `forwarding_unit.v`, `hazard_detection.v` | Hazard handling |
| `instruction_memory.v`, `data_memory.v` | Memories |
| `tb_riscv_5stage.v` | Pipeline testbench (dependencies, load-use hazard, performance counters) |
| `tb_branch.v` | Branch testbench (taken/not-taken branches, flush of wrong-path instructions, `srai`) |
| `tb_*.v` | Unit testbenches for each module |
| `riscv_schematic.png`, `riscv_waveform.png`, `RICSwave.gtkw` | Schematic, waveform screenshot, GTKWave save file |

## Run it

Requires Icarus Verilog, GTKWave and Yosys.

```bash
# Simulate
iverilog -g2012 -o riscv_sim alu.v control_unit.v data_memory.v ex_mem.v forwarding_unit.v \
  hazard_detection.v id_ex.v if_id.v immediate_generator.v instruction_memory.v \
  mem_wb.v register_file.v riscv_5stage.v tb_riscv_5stage.v
vvp riscv_sim            # prints: ALL PIPELINE TESTS PASSED

# Branch / flush test
iverilog -g2012 -o branch_sim alu.v control_unit.v data_memory.v ex_mem.v forwarding_unit.v \
  hazard_detection.v id_ex.v if_id.v immediate_generator.v instruction_memory.v \
  mem_wb.v register_file.v riscv_5stage.v tb_branch.v
vvp branch_sim           # prints: ALL BRANCH TESTS PASSED

# View waveforms
gtkwave riscv_5stage.vcd
```

```text
# Synthesize (inside yosys)
read_verilog alu.v control_unit.v data_memory.v ex_mem.v forwarding_unit.v hazard_detection.v id_ex.v if_id.v immediate_generator.v instruction_memory.v mem_wb.v register_file.v riscv_5stage.v
prep -top riscv_5stage
check                    # Found and reported 0 problems
write_verilog -noattr riscv_synth.v
show -format dot -prefix riscv_schematic
```

## Results

- Both testbenches pass in Icarus Verilog (`ALL PIPELINE TESTS PASSED`, `ALL BRANCH TESTS PASSED`); all 12 unit testbenches pass
- Yosys synthesis completes with 0 reported problems; gate-level netlist and schematic generated

## Next steps

- `jal/jalr`, `lui/auipc`, byte/half-word loads and stores
- Branch prediction to cut the 2-cycle taken-branch penalty
- Wider instruction coverage against the RV32I compliance tests
- Take the core through OpenLane/LibreLane on SKY130

## Author

**Rahul Dayanand Gunari**, B.E. Electronics & Communication, Sri Venkateshwara College of Engineering, Bengaluru
[LinkedIn](https://www.linkedin.com/in/rahul-gunari-b31350312/) · gunarirahuld@gmail.com
