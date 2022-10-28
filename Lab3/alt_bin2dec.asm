# Convert binary input to decimal format to display on 8 displays

# Want to shift by 18 bits each time to get whole part of input
# But 2^18 * 2^14 (fixed point) is too big, so divide by 10
li 	a0, 429496730	# round ( 2^18 * 2^14 / 10 )
li 	a1, 10		# Use to later get back actual value


# Read 32 bit gpio input (lower 18 bits is SW)
li 	s0, 0x0003FFFF	# for testing
#csrrw 	s0, 0xf00, zero	# read input

# Each time:
# t0 = lo of s0 * a0 - shift s0 left by 18 bits to get fractional part
# s0 = hi of s0 * a0 - shift s0 again and get overflow bits for whole part
# t0 = hi of t0 * 10 - get back actual value of fractional - overflow is the mod
# t0 = t0 & 0xF	     - Make sure all 28 high bits of t0 are zero
# t0 = t0 << n	     - shift by n amount each time to align with final output
# a2 = t0 | a2	     - combine this decimal with the rest

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulh	t0, t0, a1	# mod
andi	t0, t0, 0xF	# 0 extend
slli	t0, t0, 0	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulh	t0, t0, a1	# mod
andi	t0, t0, 0xF	# 0 extend
slli	t0, t0, 4	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulh	t0, t0, a1	# mod
andi	t0, t0, 0xF	# 0 extend
slli	t0, t0, 8	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulh	t0, t0, a1	# mod
andi	t0, t0, 0xF	# 0 extend
slli	t0, t0, 12	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulh	t0, t0, a1	# mod
andi	t0, t0, 0xF	# 0 extend
slli	t0, t0, 16	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulh	t0, t0, a1	# mod
andi	t0, t0, 0xF	# 0 extend
slli	t0, t0, 20	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulh	t0, t0, a1	# mod
andi	t0, t0, 0xF	# 0 extend
slli	t0, t0, 24	# align
or	a2, a2, t0	# combine

mul 	t0, s0, a0	# fractional
mulh	s0, s0, a0	# whole
mulh	t0, t0, a1	# mod
andi	t0, t0, 0xF	# 0 extend
slli	t0, t0, 28	# align
or	a2, a2, t0	# combine

# Done, output final to gpio hex displays
# csrrw 	zero, 0xf02, a2	# write output