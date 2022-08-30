	.text
	
	li 	s1, 2097152	# Initial step = 128
	li 	s2, 4194304	# Initial Guess = 256

	li 	a7, 5
	ecall			# get integer input value
	
	slli	s0, a0, 14	# Convert input to (32,14) format
	

loop:
	beq 	s0, zero, done
	


done:
