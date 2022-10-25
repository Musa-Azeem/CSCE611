li	a0,10
li  a1,429496730

add	a2,zero,zero
add	t0,zero,zero
add	t1,zero,zero

csrrw	t0	hex_value, zero

mul	t1,t0,a1	#t1 is the fractional part
mulhu	t0,t0,a1
mulhu	t1,t1,a0	# multiply by 10 and t1 becomes the modulus
slli	t1,t1,0
or	x15	x15	x6

mul	x6	x5	x11	#  x6 is the fractional part
mulhu	x5	x5	x11	# x5 is the running value
mulhu	x6	x6	x10	# multiply by 10, x6 is now the modulus
slli	x6	x6	4
or	x15	x15	x6

mul	x6	x5	x11	#  x6 is the fractional part
mulhu	x5	x5	x11	# x5 is the running value
mulhu	x6	x6	x10	# multiply by 10, x6 is now the modulus
slli	x6	x6	8
or	x15	x15	x6

mul	x6	x5	x11	#  x6 is the fractional part
mulhu	x5	x5	x11	# x5 is the running value
mulhu	x6	x6	x10	# multiply by 10, x6 is now the modulus
slli	x6	x6	12
or	x15	x15	x6

mul	x6	x5	x11	#  x6 is the fractional part
mulhu	x5	x5	x11	# x5 is the running value
mulhu	x6	x6	x10	# multiply by 10, x6 is now the modulus
slli	x6	x6	16
or	x15	x15	x6

mul	x6	x5	x11	#  x6 is the fractional part
mulhu	x5	x5	x11	# x5 is the running value
mulhu	x6	x6	x10	# multiply by 10, x6 is now the modulus
slli	x6	x6	20
or	x15	x15	x6

mul	x6	x5	x11	#  x6 is the fractional part
mulhu	x5	x5	x11	# x5 is the running value
mulhu	x6	x6	x10	# multiply by 10, x6 is now the modulus
slli	x6	x6	24
or	x15	x15	x6

mul	x6	x5	x11	#  x6 is the fractional part
mulhu	x5	x5	x11	# x5 is the running value
mulhu	x6	x6	x10	# multiply by 10, x6 is now the modulus
slli	x6	x6	28
or	x15	x15	x6

csrrw	x0	io2	x15
