CSCE611 Lab 3
Musa Azeem and Rahul Bulusu
Lab 3 Testbench Instructions

To run the test bench for this lab first, in the cpu.sv file uncomment "initial $readmemh("testbench-program.rom", inst_ram);" on line 24 and comment the previous line (line 23) "initial $readmemh("program.rom", inst_ram);."
Second, in the terminal run the command: ./csce611.sh testbench.
To deploy the program to the FPGA board run these commands: ./csce611.sh compile ; ./csce611.sh program.
