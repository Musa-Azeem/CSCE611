li a0, 10 #used for multiplying by 10 to get the modulous
li a1, 4194304 #Initial = 256

#clear registers for use
add	a2,	zero,	zero
add	t1, zero, zero
add	t2, zero, zero

csrrw	t1,	mhex2,	zero

#process: get the fractional part, the actual value, and multiply by 10 to get the modulous of the temp register
#increment the slli by 4 each time from 31:0 - which is the num of inputs
mul	t2, t1, a1	
mulhu	t1, t1, a1	
mulhu	t2, t2, a0	
slli	t2, t2, 0
or	a2, a2, t2

mul	t2, t1, a1	
mulhu	t1, t1, a1	
mulhu	t2, t2, a0	
slli	t2, t2, 4
or	a2, a2, t2

mul	t2, t1, a1	
mulhu	t1, t1, a1	
mulhu	t2, t2, a0	
slli	t2, t2, 8
or	a2, a2, t2

mul	t2, t1, a1	
mulhu	t1, t1, a1	
mulhu	t2, t2, a0	
slli	t2, t2, 16
or	a2, a2, t2

mul	t2, t1, a1	
mulhu	t1, t1, a1	
mulhu	t2, t2, a0	
slli	t2, t2, 20
or	a2, a2, t2

mul	t2, t1, a1	
mulhu	t1, t1, a1	
mulhu	t2, t2, a0	
slli	t2, t2, 24
or	a2, a2, t2

mul	t2, t1, a1	
mulhu	t1, t1, a1	
mulhu	t2, t2, a0	
slli	t2, t2, 28
or	a2, a2, t2

mul	t2, t1, a1	
mulhu	t1, t1, a1	
mulhu	t2, t2, a0	
slli	t2, t2, 32
or	a2, a2, t2

csrrw	zero, mhex2, a2
