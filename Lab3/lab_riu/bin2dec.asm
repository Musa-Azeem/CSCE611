# Convert binary input to decimal format to display on 8 displays

li 	a0, 0x1999999A	# Approximation of 1/10 * 2^32
addi 	a1, zero, 10		# Use to later get back actual value
addi	a2, zero, 0		# clear a2 for output

# Read 32 bit gpio input (lower 18 bits is SW)
#li 	s0, 16	# li for testing
csrrw 	s0, 0xf00, zero	# read input

# Each iteration:
# t0 = lo of s0 * a0 	- divide input by 10 and get the fractional part
# s0 = hi of s0 * a0 	- divide input by 10 and get the whole part
# t0 = hi of t0 * 10 	- multiply fractional part by 10 to get mod
# t0 = t0 << n	     	- shift by n amount each time to align with final output
# a2 = t0 | a2	     	- combine this decimal with the rest

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulhu	t0, t0, a1	# mod
slli	t0, t0, 0	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulhu	t0, t0, a1	# mod
slli	t0, t0, 4	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulhu	t0, t0, a1	# mod
slli	t0, t0, 8	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulhu	t0, t0, a1	# mod
slli	t0, t0, 12	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulhu	t0, t0, a1	# mod
slli	t0, t0, 16	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulhu	t0, t0, a1	# mod
slli	t0, t0, 20	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulhu	t0, t0, a1	# mod
slli	t0, t0, 24	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulhu	t0, t0, a1	# mod
slli	t0, t0, 28	# align
or	a2, a2, t0	# combine

# Done, output final to gpio hex displays
csrrw 	zero, 0xf02, a2	# write output
