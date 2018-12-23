	addi $t0, $zero, 1 #consts
	addi $t1, $zero, 16
	addi $t2, $zero, 4
	
	addi $a0, $zero, 0 #operand 0
	addi $a1, $zero, 0 #operand 1
	addi $a2, $zero, 0 #mul result
	
	addi $s1, $zero, 0 #memory pointer/iteration counter
	
outer:	lw $a0, 0($s1)
	lw $a1, 16($s1)
	addi $a2, $zero, 0
mul_:	beqz $a1, exit
	add $a2, $a2, $a0
	sub $a1, $a1, $t0
	j mul_
exit:	
	addi $s1, $s1, 1
	sw $a2, 31($s1)
	beq $s1, $t1, finish
	j outer
finish:
	addi $s1, $zero, 0 # arg pointer
	addi $s2, $zero, 0 # result pointer
	addi $s3, $zero, 0 # row index
	
	addi $t3, $zero, 0 #row result
	
row:
	lw $a0, 32($s1) # load new cell
	addi $zero, $zero, 0
	add $t3, $t3, $a0 # add to result
	addi $s3, $s3, 1 # else: increment index
	addi $s1, $s1, 1 # increment pointer
	beq $s3, $t2, store_res #if index == 3, go to store
	j row
store_res:
	sw $t3, 48($s2)
	addi $s2, $s2, 1
	addi $s3, $zero, 0
	addi $t3, $zero, 0
	beq $s2, $t2, prg_finish
	j row
prg_finish:
