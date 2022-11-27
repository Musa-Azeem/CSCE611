# RISC-V Code to read input from gpio, calculate its square root, and display
# 	the result in (8,5) fixed point base ten on gpio hex displays

# GPIO INPUT
# cssrrw 	s0, 0xf00, zero			# get input from switches
li s0, 1000						# For testing

# CALCULATE SQUARE ROOT

li 		s1, 2097152				# Initial step = 128 in fixed point
li 		s2, 4194304				# Initial guess = 256 in fixed point
slli	s0, s0, 14				# convert integer input to (32,14) fixed point

sqrtloop:						# label to continue sqrt iteration

ble 	s1, zero, donesqrt 		# if step goes to zero, return sqrt estimate

mul		s3, s2, s2				# get lo bits of guess^2
mulhu	s4, s2, s2				# get hi bits of guess^2
srli	s3, s3, 14				# shift lo bits to align
slli	s4, s4, 18				# shift hi bits to align
or 		s3, s3, s4				# combine lo and hi of product
beq		s3, s0, donesqrt		# if guess^2 is equal to input, return sqrt
blt		s3, s0, lessthan		# if guess^2 is less than input, branch

sub		s2, s2, s1				# if guess^2 is greater than input, guess -= step
srli	s1, s1, 1				# divide step by 2
j 		sqrtloop				# continue iteration

lessthan:
add		s2, s2, s1				# if guess^2 is less than input, guess += step
srli	s1, s1, 1				# divide step by 2
j 		sqrtloop				# continue iteration

donesqrt:						# Done calculating square root (in s2)

# CONVERT TO (8,5) DECIMAL FOR HEX DISPLAYS

slli	s1, s2, 17				# Get decimal part of sqrt result

li 		a1, 0x1999999A			# Approximation of 1/10 in (32, 32) fixed point
li		a2, 10					# Used to multiply by 10
li 		a3, 0x28000				# 10 in (32,14) fixed point
li		a4, 20					# iterate 5 times
li 		s3, 0					# Clear s3 register for output
li		s4, 0					# iteration counter

# Get the 5 fractional digits for hex display
loopfrac:						# iteration for fractional
mul		t0, s1, a3				# lo bits s1*10		(4 bits whole, rest are fractional)
mulh	t1, s1, a1				# hi bits of s1*10  (all whole bits)
slli	s1, t0, 4				# update s1 as only fractional bits of s1*10
srli	t1, t1, 28				# align whole bits of lo
slli	t0, t0, 4				# align hi
or		t0, t1, t0				# combine to get whole part of s1*10 - next decimal digit
sll		t0, t0, s4				# align with output based on iteration number
or		s3, s3, t0				# add next digit to output
addi	s4, s4, 4				# iterate counter
bne		s4, a4, loopfrac		# continue iteration

# Get 3 whole digits for hex display