addi 	x5, x0, 10	# x5  = 10 (b'1010)		x5  = h'a
addi 	x6, x0, 5	# x6  = 5 (b'0101)		x6  = h'5
add 	x7,  x5,  x6	# x7  = 15 (b'1111)		x7  = h'f
sub 	x8,  x5,  x6	# x8  = 5 (b'0101)		x8  = h'5
and 	x9,  x5,  x6	# x9  = b'0000			x9  = h'0
or 	x10, x5,  x6	# x10 = b'1111			x10 = h'f
xor 	x11, x5,  x6	# x11 = b'1111			x11 = h'f
sll 	x12, x5,  x6	# x12 = b'1_0100_0000		x12 = h'140
sra	x13, x5, x6	#				x13 = h'0
srl	x14, x5, x6	#				x14 = h'0
slt	x15, x5, x6	#				x15 = h'0
sltu	x16, x5, x6	#				x16 = h'0
mul	x17, x5, x6	#				x17 = h'32
mulh	x18, x5, x6	#				x18 = h'0
mulhu	x19, x5, x6	#				x19 = h'0

#TODO I-type, U-type, IO-type