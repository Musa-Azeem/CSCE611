vlog -pedanticerrors -lint -hazards -source -stats=all *.sv
vsim -pedanticerrors -hazards -c -sva -immedassert work.simtop -do /dev/stdin