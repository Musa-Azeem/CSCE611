CSCE611 Lab 3

Musa Azeem and Rahul Bulusu


To run the test bench for this project:
- Uncomment line 24" in cpu.sv: `initial $readmemh("testbench-program.rom", inst_ram);`
- Comment line 23 in cpu.sv: `initial $readmemh("program.rom", inst_ram);`
- In the terminal run the command: `./csce611.sh testbench`

To deploy the program to the FPGA board run these commands: `./csce611.sh compile && ./csce611.sh program`

Project Structure:
```
simtop.sv               Testbench for simulation of the cpu
top.sv                  Top level module - handles input and output of cpu
hexdriver.sv            Module to convert hex numbers to 8-segment display format
cpu.sv                  Implementation of 3 stage pipelined CPU
instruction_decoder.sv  Module to retrieve all possible fields from a 32 bit instruction
control_fields.sv       Module to produce control signal values based on instruction fields
alu.sv                  Implementation of an ALU
regfile.sv              Implementation of a regsiter file
bin2dec.asm             Risc-V program to convert a binary value into a specific decimal format
program.rom             Machine code of bin2dec.asm in hexadecimal text format
testbench-program.asm   Risc-V program to test the CPU's ability to execute instructions
testbench-program.rom   Machine code of testbench-program.asm in hexadecimal text format
testbench-expected.rom  Expected register values from executing testbench-program.asm
```
