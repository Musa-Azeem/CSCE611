li x10,10
li x11,429496730

add	x15	x0	x0	# clear registers 15, 5, 6
add	x5	x0	x0
add	x6	x0	x0

csrrw	x5	io0	x0

mul	x6	x5	x11	# x6 is the fractional part
mulhu	x5	x5	x11	# x5 is the running value
mulhu	x6	x6	x10	# multiply by 10, x6 is now the modulus
slli	x6	x6	0
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
