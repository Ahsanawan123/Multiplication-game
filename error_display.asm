.globl error_1, error_2, error_3
.data
	message1: .asciiz "\nOne of the values you inputted are out of the bounds [1,9]. Input again.\n"
	message2: .asciiz "\nOne (and only one) of your values must be a value currently selected on the slider. Input again.\n"
	message3: .asciiz "\nThis value is already chosen on the board. Input again.\n" 
.text
	main:
	error_1: 
		li $v0, 4
		la $a0, message1
		syscall
		j playerTurn
		
	error_2: 
		li $v0, 4
		la $a0, message2
		syscall
		j playerTurn
	
	error_3: 
		li $v0, 4
		la $a0, message3
		syscall
		j playerTurn
		
		

		
		
