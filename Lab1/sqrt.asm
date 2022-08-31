	.text
	
	li 	s1, 2097152	# Initial step = 128
	li 	s2, 4194304	# Initial Guess = 256

	li 	a7, 5
	ecall			# get integer input value
		
	slli	s0, a0, 14	# Convert input to (32,14) format
	
	
	mul	s3, s2, s2
	li	a7, 1
	mv	a0, s3
	ecall


loop:
	ble 	s1, zero, done
	
	mul	s3, s2, s2
	mulhu	s4, s2, s2
	
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