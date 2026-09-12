\# 5-Stage Pipelined RISC-V Processor Using Verilog HDL



\## Overview



This project implements a 32-bit 5-stage pipelined RISC-V processor using Verilog HDL. The processor is organized into the standard instruction pipeline stages: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB).



The design focuses on understanding processor datapath organization, pipeline registers, instruction execution, data forwarding, and hazard detection at the RTL level.



\## Architecture



The processor consists of the following five pipeline stages:



1\. \*\*Instruction Fetch (IF)\*\*

&#x20;  - Program Counter (PC)

&#x20;  - Instruction Memory

&#x20;  - PC increment logic



2\. \*\*Instruction Decode (ID)\*\*

&#x20;  - Instruction decoding

&#x20;  - Register File

&#x20;  - Immediate generation

&#x20;  - Control signal generation



3\. \*\*Execute (EX)\*\*

&#x20;  - ALU operations

&#x20;  - Operand selection

&#x20;  - Data forwarding

&#x20;  - Branch target calculation



4\. \*\*Memory Access (MEM)\*\*

&#x20;  - Data Memory

&#x20;  - Load and Store operations

&#x20;  - Branch decision handling



5\. \*\*Write Back (WB)\*\*

&#x20;  - Selection between ALU result and memory data

&#x20;  - Register File write-back



\## Supported Instruction Set



The current RTL supports a basic subset of RV32I instructions:



\- ADD

\- SUB

\- AND

\- OR

\- XOR

\- SLL

\- SRL

\- SLT

\- ADDI

\- LW

\- SW

\- BEQ



\## Design Modules



| Module | Description |

|---|---|

| `riscv\_5stage.v` | Top-level processor |

| `alu.v` | Arithmetic and logical operations |

| `register\_file.v` | 32 × 32-bit processor register file |

| `control\_unit.v` | Generates control signals |

| `immediate\_generator.v` | Generates instruction immediates |

| `instruction\_memory.v` | Stores processor instructions |

| `data\_memory.v` | Handles load and store operations |

| `if\_id.v` | IF/ID pipeline register |

| `id\_ex.v` | ID/EX pipeline register |

| `ex\_mem.v` | EX/MEM pipeline register |

| `mem\_wb.v` | MEM/WB pipeline register |

| `forwarding\_unit.v` | Resolves data hazards using forwarding |

| `hazard\_detection.v` | Detects load-use hazards |

| `tb\_riscv\_5stage.v` | Processor simulation testbench |



\## Pipeline and Hazard Handling



The processor uses pipeline registers between each major stage to allow multiple instructions to be processed simultaneously.



\### Data Forwarding



The forwarding unit detects dependencies between instructions and forwards results from later pipeline stages to the Execute stage when required.



\### Hazard Detection



The hazard detection unit identifies load-use hazards and generates control signals to stall the pipeline when forwarding alone cannot resolve the dependency.



\## Verification



The design was simulated using an RTL simulation flow with Icarus Verilog and waveform analysis using GTKWave.



Simulation generates a VCD waveform file:



```text

riscv.vcd

