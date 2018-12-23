	addi $t1, $zero, 0 #i
	addi $t2, $zero, 1 #and mask
	addi $t4, $zero, 4 #n
	lw $a2, ($zero) #result

loop:	addi $t1, $t1, 1 #increment i
	beq $t1, $t4, exit #if i = n, exit
	lw $a0, ($t1) #load x(i)

	and $t7, $t1, $t2 #mask i, result in t7
	beqz $t7, add_ #check t7, if even, jump to add
	j sub_ #even, jump to sub
	
sub_:	sub $a2, $a2, $a0
	j loop
add_:	add $a2, $a2, $a0
	j loop
exit:	sw $a2, 42