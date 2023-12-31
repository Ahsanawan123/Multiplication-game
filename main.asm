.data
	.globl board, status, main, exitProg, slider, turn
	board: .word 1,2,3,4,5,6,7,8,9,10,12,14,15,16,18,20,21,24,25,27,28,30,32,35,36,40,42,45,48,49,54,56,63,64,72,81
	status: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	slider: .word 0,0,0,0,0,0,0,0,0
	turn: .word 1
	
.text
	# CHOOSE RANDOM NUMBER FOR SLIDER
	li $v0, 42
   	li $a1, 9
	syscall
	mul $a0, $a0, 4
    	
    	li $t0, 1
    	sw $t0, slider($a0)

	# INITIAL BOARD PRINT
	la $ra, main
	jal print
	
main:

	# CHECK WHOS TURN IT IS
	lw $t1, turn
	
	# CALL EITHER GET PLAYER INPUT OR GENERATE COMPUTER MOVE BASED ON CHOICE
	beq $t1, 1, callPlayerTurn
	j callComputerTurn
	
callPlayerTurn:
	#j playerTurn
	
callComputerTurn:
	j generate_CPU_turn
	
exitProg:
	li $v0, 10
	syscall
