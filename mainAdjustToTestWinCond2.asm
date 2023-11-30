.data
    .globl board, exitProg, status, slider, turn
    board: .word 1,2,3,4,5,6,7,8,9,10,12,14,15,16,18,20,21,24,25,27,28,30,32,35,36,40,42,45,48,49,54,56,63,64,72,81
    status: .word 0, 2, 1, 2, 0, 1, 2, 0, 2, 1, 2, 1, 0, 1, 2, 1, 2, 1, 1, 2, 1, 2, 1, 2, 0, 2, 1, 2, 1, 2, 0, 1, 2, 0, 2, 1
    slider: .word 1,0,0,0,0,1,0,0,0
    turn: .word 2
     ContMsg: .asciiz "the game is contiuing and about to exit\n"
    
.text
    .globl main   
main:

	# do game logic
	
    # Check win conditions
    jal checkHorizontalWin
    
    li $v0, 4          # 4 is the syscall number for print string
    la $a0, ContMsg   # Load the address of the string into $a0
    syscall            # Make the syscall
    # jump here
    j exitProg

    # If no win or draw, continue the game
    # Logic to switch turns or other game mechanics

exitProg:
    li $v0, 10
    syscall
