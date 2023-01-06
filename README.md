# CPU DESIGN

This repository is an implementation of a 32 bit CPU to run RISC-V instructions

It is implemented in SystemVerilog, and can be compiled onto an FPGA board

It includes a test RISC-V program that prints the square root of the input value (from the switches) on the seven segment displays

The Following files contain SystemVerilog Components:


- `simtop.sv` : top level module for simulation
- `top.sv` : top level module to instance the CPU
- `cpu.sv` : top level module of the CPU implementation
    - `alu.sv` : CPU ALU
    - `control_unit.sv` : control unit of the CPU
    - `instruction_decoder.sv` : module to decode RISC-V instructions
    - `regfile.sv` : regsiter file module
- `hexdriver.sv` : module to display hex values on a seven-segment display
