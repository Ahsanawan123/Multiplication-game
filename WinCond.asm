.data
PlayerWinMssg: .asciiz "Player Wins!\n"
CompWinMssg: .asciiz "Computer Wins!\n"
DrawMssg: .asciiz "It's a draw!\n"


.text

# Part a
# Function to check for horizontal win condition
.globl checkHorizontalWin
checkHorizontalWin:
    # Registers:
    # $t0 - base address of status
    # $t1 - row counter
    # $t2 - column counter
    # $t3 - temporary value for comparison
    # $t4 - consecutive count
    # $t5 - player number (1 or 2, depending on whose turn it is)
    # $t6 - index calculation
    # $t7 - constant value 4 for comparison
# Function: Check for a horizontal win

    # Load the turn into $t5 to be used in win-checking functions
    lw $t5, turn
    
    la $t0, status    # Load base address of the status array
    li $t1, 0              # Row counter
    li $t7, 4              # Count for a win condition

horizontal_row_loop:
    bge $t1, 6, end_horizontal_check  # Check all rows
    li $t2, 0              # Column counter

horizontal_column_loop:
    bgt $t2, 3, next_row_horizontal   # Check up to the 3rd column for four in a row
    
    li $t4, 0              # Reset consecutive count
    li $t3, 0              # Inner loop counter for checking four in a row
    check_consecutive_horizontal:
        bgt $t3, 3, continue_horizontal  # Check four positions
        #j next_column_horizontal  # If four have been checked and no win, go to the next column

        # Calculate index in status
        mul $t6, $t1, 6     # Row width
        add $t6, $t6, $t2   # Column offset
        add $t6, $t6, $t3   # Additional offset for checking consecutive elements
        sll $t6, $t6, 2     # Convert to word offset
        add $t6, $t0, $t6   # Address in the status

        lw $t8, 0($t6)      # Load the element
        bne $t8, $t5, reset_consecutive_horizontal # Reset if not matching player's marker
         
        addi $t4, $t4, 1    # Increment consecutive count
        addi $t3, $t3, 1    # Move to the next element
        j check_consecutive_horizontal

    continue_horizontal:
        bne $t4, $t7, next_column_horizontal # Move to next column if four in a row not reached
        j win_horizontal    # Jump to win condition if four in a row

    reset_consecutive_horizontal:
        li $t4, 0         # Reset consecutive count
        j continue_horizontal
        
next_column_horizontal:
        addi $t2, $t2, 1  # Move to the next column
        j horizontal_column_loop
        
next_row_horizontal:
     addi $t1, $t1, 1    # Move to the next row
    j horizontal_row_loop

end_horizontal_check:
    # No win found, jump to the next check
    j checkVerticalWin

win_horizontal:
    # Compare turn and decide the message to print            
     beq $t5, 1, playerWin        # Win found
     beq $t5, 2, compWin
     j exitProgram
       
       
# Function: Check for a vertical win
.globl checkVerticalWin
checkVerticalWin:
    lw $t5, turn

    la $t0, status   # Load base address of the status array
    li $t1, 0             # Column counter
    li $t7, 4             # Count for a win condition

vertical_column_loop:
    bgt $t1, 6, end_vertical_check   # Check all columns
    li $t2, 0             # Row counter

vertical_row_loop:
    bgt $t2, 3, next_column_vertical # Check up to the 3rd row for four in a row
    li $t4, 0             # Reset consecutive count

    # Loop to check four consecutive elements in a column
    li $t3, 0             # Inner loop counter for checking four in a row
    check_consecutive_vertical:
        bgt $t3, 18, continue_vertical # Check four positions

        # Calculate index in status
        mul $t6, $t2, 6    # Row width
        add $t6, $t6, $t1  # Column offset
        add $t6, $t6, $t3  # Additional offset for checking consecutive elements
        sll $t6, $t6, 2    # Convert to word offset
        add $t6, $t0, $t6  # Address in the status

        lw $t8, 0($t6)     # Load the element
        #lw $t9, turn          # Assume we are checking for player's turn (1). Change to 2 for computer.
        bne $t8, $t5, reset_consecutive_vertical # Reset if not matching player's marker
        addi $t4, $t4, 1   # Increment consecutive count

        addi $t3, $t3, 6   # Move to the next element in the column
        j check_consecutive_vertical

    continue_vertical:
        beq $t4, $t7, win_vertical # Check if four in a row is reached
        # addi $t2, $t2, 1   # Move to the next row
        j next_row_vertical

    reset_consecutive_vertical:
        li $t4, 0          # Reset consecutive count
        j continue_vertical

next_row_vertical:
	addi $t2, $t2, 1  # Move to the next row
        j vertical_row_loop

next_column_vertical:
    addi $t1, $t1, 1     # Move to the next column
    j vertical_column_loop

end_vertical_check:
    li $v0, 0            # No win found
    j checkDiagonalWinAscending       # might have to jump to next function if no win is found

win_vertical:
    lw $t9, turn
    beq $t9, 1, playerWin
    beq $t9, 2, compWin
    j exitProgram
    
    
# Function: Check for an ascending diagonal win
.globl checkDiagonalWinAscending
checkDiagonalWinAscending:
    la $t0, status   # Load base address of the status array
    lw $t5, turn     # Load the current player's number

    li $t1, 30       # Starting index for the first diagonal check from bottom left
    li $t7, 4        # Count for a win condition

    ascending_diagonal_loop:
        li $t4, 0         # Reset consecutive count
        li $t3, 0         # Counter for checking four in a diagonal

        check_consecutive_ascending:
            bge $t3, $t7, next_diagonal_ascending # Check four positions

            mul $t6, $t3, 5  # Index increases by 5 for each step in ascending diagonal
    	    sub $t6, $t1, $t6 # Subtract since we're moving up and to the right
            sll $t6, $t6, 2  # Convert to word offset
            add $t6, $t0, $t6 # Address in the status

            lw $t8, 0($t6)   # Load the element
            bne $t8, $t5, reset_consecutive_descending # If not matching, check next
            addi $t4, $t4, 1 # Increment consecutive count

            addi $t3, $t3, 1 # Move to the next element in the diagonal
            j check_consecutive_ascending

        next_diagonal_ascending:
            beq $t4, $t7, win_diagonal_ascending # Check if four in a row is reached
            addi $t1, $t1, 1   # Move to the next starting index to the right
    	    blt $t1, 33, ascending_diagonal_loop # If index less than 33, continue checking

        check_next:
    	addi $t1, $t1, 6   # Move up to start checking next diagonal
    	blt $t1, 36, ascending_diagonal_loop # If index less than 36, continue checking

    	li $v0, 0          # No win found
    	j checkDiagonalWinDescending    # Proceed to check for a draw

win_diagonal_ascending:
     lw $t9, turn             # Win found
     beq $t9, 1, playerWin
     beq $t9, 2, compWin
     j exitProgram

# Function to check for a descending diagonal win
.globl checkDiagonalWinDescending
checkDiagonalWinDescending:
    
    # Function: Check for a descending diagonal win
    la $t0, status   # Load base address of the status array
    lw $t5, turn        # Assuming it's the player's turn (use 2 for the computer)
    li $t7, 4        # Count for a win condition
    
    # Starting indices for potential descending diagonals on a 6x6 board
    # (The actual indices should be calculated based on your game board's layout)
    li $t1, 0        # Top-left corner index for the first diagonal
    
    descending_diagonal_loop:
    	li $t4, 0        # Reset consecutive count
    	li $t3, 0         # Inner loop counter for checking four in a diagonal
    
    check_consecutive_descending:
        bge $t3, $t7, next_diagonal_descending  # Check four positions
        
        # Calculate index in status for descending diagonal
        mul $t6, $t3, 7  # Index increases by 7 for each step in descending diagonal
        add $t6, $t6, $t1
        sll $t6, $t6, 2  # Convert to word offset
        add $t6, $t0, $t6 # Address in the status
        
        lw $t8, 0($t6)   # Load the element
        bne $t8, $t5, reset_consecutive_descending # If not matching, check next
        addi $t4, $t4, 1 # Increment consecutive count
        
        addi $t3, $t3, 1 # Move to the next element in the diagonal
        j check_consecutive_descending
        
    next_diagonal_descending:
	beq $t4, $t7, win_diagonal_descending # Check if four in a row is reached

	# Decide whether to move right or left for the next check
    	addi $t1, $t1, 1
    	blt $t1, 18, descending_diagonal_loop # If index less than 18, check the next diagonal
    
        li $v0, 0          # No win found
        j checkForDraw     # Jump to check for draw before returning

reset_consecutive_descending:
    li $t4, 0          # Reset consecutive count
    j next_diagonal_descending

win_diagonal_descending:
    lw $t9, turn       # Win found
    beq $t9, 1, playerWin
    beq $t9, 2, compWin
    j exitProgram      # Exit the program after a win
playerWin:
    li $v0, 4                  # syscall for print string
    la $a0, PlayerWinMssg
    syscall
    j exitProgram

compWin:
    li $v0, 4                  # syscall for print string
    la $a0, CompWinMssg
    syscall
    j exitProgram

exitProgram:
    li $v0, 10                 # syscall for exit
    syscall
  
    
# Part b
# Validates move and checks for draw
.globl checkForDraw
checkForDraw:
    la $t0, slider        # Load base address of the slider array
    la $t1, status        # Load base address of the status array
    la $t2, board         # Load base address of the board array
    li $t3, 0             # Initialize outer loop counter
    li $t4, 9             # Total slider positions

# Loop over slider positions (outer loop)
slider_check_outer:
    bge $t3, $t4, check_draw  # If we've checked all positions, check for draw
    addi $t5, $t3, 1       # Slider value at outer loop position
    
    li $t6, 0             # Initialize inner loop counter
# Loop over slider positions (inner loop)
slider_check_inner:
    bge $t6, $t4, update_outer_counter  # If we've checked all positions, go to next position 1
    addi $t7, $t6, 1       # Slider value at inner loop position

    mul $t8, $t5, $t7      # Compute the product for the move

    # Now we need to find the index of this product in the board array
    li $s0, 0              # Initialize index for board array
    li $s1, 36            # Total number of positions in the board
    
find_product_index:
    bge $s0, $s1, update_inner_counter  # If we've reached end of board, go to next slider position
    sll $s2, $s0, 2       # Multiply index by 4 to get word offset
    add $s2, $s2, $t2     # Get address of the board element
    lw $s3, 0($s2)        # Load the value at current board index (instead of $t11)
    beq $t8, $s3, check_status  # If product is found, check status
    addi $s0, $s0, 1      # Increment board index
    j find_product_index

check_status:
    # Assuming status array is the same size as board array, we can use the same index
    sll $s2, $s0, 2       # Multiply index by 4 to get word offset
    add $s2, $s2, $t1     # Get address of the status element
    lw $s4, 0($s2)        # Load the status at the found index (instead of $t12)
    beq $s4, 0, valid_move_found  # If unoccupied, a valid move is found, exit the check

update_inner_counter:
    addi $t6, $t6, 1      # Increment inner loop counter
    j slider_check_inner

update_outer_counter:
    addi $t3, $t3, 1      # Increment outer loop counter
    j slider_check_outer

check_draw:
    # If no valid moves were found, declare a draw
    li $v0, 4             # syscall for print string
    la $a0, DrawMssg      # Load address of draw message
    syscall
    li $v0, 10            # syscall for exit
    syscall

valid_move_found:
    # If a valid move is found, simply return
    j jumpToMain #jr ra
    
# Part c
.globl jumpToMain
jumpToMain:
    #j main         # Jump to the main label
    jr $ra
    nop            # Following the jump with a nop is a good practice to handle the delay slot


    
