# Group Members: Musa Azeem and Rahul Bulusu

.text
	
	li 	s1, 2097152			# Initial step = 128
	li 	s2, 4194304			# Initial Guess = 256
	
	li s0, 80000
	slli	s0, s0, 14

	#mv	s0, a0

loop:
	ble 	s1, zero, done			# if step goes to zero, return guess
	
	mul	s3, s2, s2			# get lo bits of guess^2
	mulhu	s4, s2, s2			# get hi bits of guess^2
	
	srli	s3, s3, 14			# shift lo bits to align
	slli	s4, s4, 18			# shift hi bits to align
	
	or 	s3, s3, s4			# combine values
	
	bne	s3, s0, continue		# if guess^2 is not equal to input, continue looping 
	
	j done					# if guess^2 is equal to input, return guess
	
continue:
	blt	s3, s0, lessthan		# if guess^2 is less than input, branch
	
	sub	s2, s2, s1			# if guess^2 is greater than input, subtract step from guess
	srli	s1, s1, 1			# divide step by 2
	j loop					# continue looping

lessthan:
	add	s2, s2, s1			# if guess^2 is less than input, add step to guess
	srli	s1, s1, 1			# divide step by 2
	j loop					# continue looping


done:						# print final guess to console
	li	a7, 1
	mv	a0, s2
	ecall
