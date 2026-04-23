# SAP-1 Verilog Mini Project

This repository contains a simple SAP-1 implementation in Verilog and a testbench for the program below:

- `LDA 3`
- `ADD 6`
- `HLT`

The testbench initializes:

- `mem[3] = 8'h04`
- `mem[6] = 8'h05`

Expected result:

- Register `A = 8'h09`

## Structure

- `src/register.v` generic register module used for MAR, IR, A, and B
- `src/program_counter.v` 4-bit program counter
- `src/alu.v` 8-bit ALU for add and subtract
- `src/memory.v` 16 x 8 memory
- `src/bus.v` single shared bus
- `src/control_unit.v` hardwired controller with SAP-1 style control signals
- `src/cpu.v` top-level CPU
- `tb/cpu_tb.v` simulation testbench

## Implemented instruction set

- `0x0_`: `LDA addr`
- `0x1_`: `ADD addr`
- `0x2_`: `SUB addr`
- `0x3_`: `STA addr`
- `0xE_`: `NOP`
- `0xF_`: `HLT`

## Example simulation flow

With Icarus Verilog:

```powershell
iverilog -g2005-sv -o cpu_tb.out src/*.v tb/cpu_tb.v
vvp cpu_tb.out
```
