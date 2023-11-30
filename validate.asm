.globl validateInput
.text
	#assuming user inputs are in $a0 and $a1
	validateInput:
	#test to see if within 1 and 9. If failed, goes to error_1
	bgt $a0, 9, error_1
	bgt $a1, 9, error_1
	blt $a0, 1, error_1
	blt $a1, 1, error_1
	
	#test to see if one of the 2 values are selected
	li $t5, 0
	la $t0, slider
	subi $t1, $a0, 1 #we turn this value into the index of slider we need to compare a0 with (1-9 now 0-8)
	sll $t1, $t1, 2 #t1 has 4 * index at which we need to compare with (word aligned)
	move $s0, $t1
	add $t2, $t1, $t0 #t2 contains address of corresponding location of slider
	lw $t3, 0($t2)
	beq $t3, 1, adder1
	continue1:

	subi $t1, $a1, 1
	sll $t1, $t1, 2 #t1 has 4 * index at which we need to compare with
	move $s1, $t1
	add $t2, $t1, $t0 #t2 contains address of corresponding location of slider
	lw $t3, 0($t2)
	beq $t3, 1, adder2
	continue2:
	
	bne $t5, 1, error_2
	
	#calculate product and check if the slot is taken
	mul $t0, $a0, $a1 #t0 has product
	la $t1, board #t1 has base address of board
	li $t2, 0 #loop variable, will exit loop if this value exceeds 35 (touches 36)
	
	loop:
		lw $t3, 0($t1)
		beq $t0, $t3, process
		addi $t1, $t1, 4
		addi $t2, $t2, 1
		ble $t2, 35, loop
		
	continue3:
	
	# update board, slider, and check for win
	li $t6, 1
	sw $t6, status($t2)
	
		# RESET SLIDER ARRAY TO ZERO
	li $t1, -4						# loop to set each value in slider to zero
	resetLoop:
	addi $t1, $t1, 4
	sw $zero, slider($t1)
	bne $t1, 32, resetLoop
	
	sw $t6, slider($s0)
	sw $t6, slider($s1)
	
	jal print
	#j checkHorizontalWin
	j validateWin
	

	#adder for error 2
	adder1:
		addi $t5, $t5, 1
		j continue1
	
	adder2:
		addi $t5, $t5, 1
		j continue2
		
	process:
		la $t3, status
		sll $t2, $t2, 2
		add $t3, $t3, $t2
		lw $t3, 0($t3)
		bne $t3, 0, error_3
		j continue3
	
