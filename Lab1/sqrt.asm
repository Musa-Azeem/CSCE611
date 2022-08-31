	.text
	
	li 	s1, 2097152	# Initial step = 128
	li 	s2, 4194304	# Initial Guess = 256

	li 	a7, 5
	ecall			# get integer input value

	mv	s0, a0

loop:
	ble 	s1, zero, done
	
	mul	s3, s2, s2	# get lo bits
	mulhu	s4, s2, s2	# get hi bits
	
	srli	s3, s3, 14	# shift lo bits to align
	slli	s4, s4, 18	# shift hi bits to align
	
	or 	s3, s3, s4	# combine values
	
	bne	s3, s0, continue
	
	j done
	
continue:
	blt	s3, s0, lessthan
	
	sub	s2, s2, s1
	srli	s1, s1, 1
	j loop

lessthan:
	add	s2, s2, s1
	srli	s1, s1, 1
	j loop


done:
	li	a7, 1
	mv	a0, s2
	ecall