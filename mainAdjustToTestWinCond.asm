.data
	.globl board, status, main, exitProg, slider, turn
	board: .word 1,2,3,4,5,6,7,8,9,10,12,14,15,16,18,20,21,24,25,27,28,30,32,35,36,40,42,45,48,49,54,56,63,64,72,81
	status: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	slider: .word 0,0,0,0,0,0,0,0,0
	turn: .word 1
	
.text
    # Additional functions from WinCond.asm if any

    # CHOOSE RANDOM NUMBER FOR SLIDER
    li $v0, 42
    li $a1, 9
    syscall
    addi $a0, $a0, 1
    mul $a0, $a0, 4
        
    li $t0, 1
    sw $t0, slider($a0)
    
main:
    # Main game loop
    # You may need a loop here to repeat turns

    # CHECK WHOSE TURN IT IS
    lw $t1, turn
    
    # CALL EITHER GET PLAYER INPUT OR GENERATE COMPUTER MOVE BASED ON CHOICE
    beq $t1, 1, callPlayerTurn
    j callComputerTurn
    
callPlayerTurn:
    # Call the player turn function
    # j playerTurn
    # Here you should have the player make a move, then check for win/draw

callComputerTurn:
  
    # Here you should have the computer make a move, then check for win/draw

    # Check for win conditions after a turn
    jal checkHorizontalWin
    jal checkVerticalWin
    jal checkDiagonalWinAscending
    jal checkDiagonalWinDescending

    # Check for a draw
    jal checkForDraw

    # Continue to next turn or end game based on the result
    # You may want to include a label to jump to for the next turn
    # and logic to end the game if there's a win or draw

exitProg:
    li $v0, 10
    syscall