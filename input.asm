.data
	nLine: .asciiz "\n"
	space: .asciiz " "
	arrow: .asciiz "^"
	message: .asciiz "Enter an integer 1-9 for the first number of your product:  "
	message2: .asciiz "\nEnter an integer 1-9 for  the second number of your product:  "
	.globl playerTurn
.text

playerTurn:

	# DISPLAY SLIDER
	la $a0, nLine
	li $v0, 4
	syscall
	
	li $t1, 1
loop1:
	move $a0, $t1
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	addi $t1, $t1, 1
	bne $t1, 10, loop1
	
	la $a0, nLine
	li $v0, 4
	syscall
	
	li $t1, -4
loop2:
	addi $t1, $t1, 4
	beq $t1, 36, exitLoop2
	lw $t2, slider($t1)
	beq $t2, 0,  printSpaces
	
	la $a0, arrow
	li $v0, 4
	syscall
	
	la $a0, space
	li $v0, 4
	syscall
	
	j loop2

printSpaces:
	la $a0, space
	li $v0, 4
	syscall
	syscall
	
	j loop2
	
exitLoop2:

	la $a0, nLine
	li $v0, 4
	syscall
	
	# GET FIRST NUMBER
	la $a0, message
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	# GET SECOND NUMBER
	la $a0, message2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	# CALL VALIDATE FUNCTION
	move $a0, $t1
	move $a1, $v0
	j validateInput
	
