vlog -pedanticerrors -lint -hazards -source -stats=all *.sv
printf "run 100000\n" | vsim -pedanticerrors -hazards -c -sva -immedassert work.simtop -do /dev/stdin