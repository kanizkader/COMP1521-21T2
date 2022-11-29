########################################################################
# COMP1521 21T2 -- Assignment 1 -- Snake!
# <https://www.cse.unsw.edu.au/~cs1521/21T2/assignments/ass1/index.html>
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# For instructions, see: https://www.cse.unsw.edu.au/~cs1521/21T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Kaniz (z5363412)
# on 8/7/21
#
# Version 1.0 (2021-06-24): Team COMP1521 <cs1521@cse.unsw.edu.au>
#

	# Requires:
	# - [no external symbols]
	#
	# Provides:
	# - Global variables:
	.globl	symbols
	.globl	grid
	.globl	snake_body_row
	.globl	snake_body_col
	.globl	snake_body_len
	.globl	snake_growth
	.globl	snake_tail

	# - Utility global variables:
	.globl	last_direction
	.globl	rand_seed
	.globl  input_direction__buf

	# - Functions for you to implement
	.globl	main
	.globl	init_snake
	.globl	update_apple
	.globl	move_snake_in_grid
	.globl	move_snake_in_array

	# - Utility functions provided for you
	.globl	set_snake
	.globl  set_snake_grid
	.globl	set_snake_array
	.globl  print_grid
	.globl	input_direction
	.globl	get_d_row
	.globl	get_d_col
	.globl	seed_rng
	.globl	rand_value


########################################################################
# Constant definitions.

N_COLS          = 15
N_ROWS          = 15
MAX_SNAKE_LEN   = N_COLS * N_ROWS

EMPTY           = 0
SNAKE_HEAD      = 1
SNAKE_BODY      = 2
APPLE           = 3

NORTH       = 0
EAST        = 1
SOUTH       = 2
WEST        = 3


########################################################################
# .DATA
	.data

# const char symbols[4] = {'.', '#', 'o', '@'};
symbols:
	.byte	'.', '#', 'o', '@'

	.align 2
# int8_t grid[N_ROWS][N_COLS] = { EMPTY };
grid:
	.space	N_ROWS * N_COLS

	.align 2
# int8_t snake_body_row[MAX_SNAKE_LEN] = { EMPTY };
snake_body_row:
	.space	MAX_SNAKE_LEN

	.align 2
# int8_t snake_body_col[MAX_SNAKE_LEN] = { EMPTY };
snake_body_col:
	.space	MAX_SNAKE_LEN

# int snake_body_len = 0;
snake_body_len:
	.word	0

# int snake_growth = 0;
snake_growth:
	.word	0

# int snake_tail = 0;
snake_tail:
	.word	0

# Game over prompt, for your convenience...
main__game_over:
	.asciiz	"Game over! Your score was "


########################################################################
#
# Your journey begins here, intrepid adventurer!
#
# Implement the following 6 functions, and check these boxes as you
# finish implementing each function
#
#  - [x] main
#  - [x] init_snake
#  - [x] update_apple
#  - [x] update_snake
#  - [x] move_snake_in_grid
#  - [x] move_snake_in_array
#



########################################################################
# .TEXT <main>
	.text
main:

	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    $ra, $s0, $s1
	# Uses:	    $a0, $v0, $s0, $s1
	# Clobbers: $a0, $v0
	#
	# Locals:
	#   - 'direction' in $a0
	#   - 'score' in $s0	
	#   - 'snake_body_len' in $s1
	#
	# Structure:
	#   main
	#   -> [main__prologue]
	#   -> main__body
	#   -> m_call_functions
	#   -> m_do_while_loop
	#	-> m_do_while_condition
	#	-> m_end_of_do_while_loop
	#   -> m_print_game_over
	#   -> m_print_score
	#   -> m_print_new_line
	#   -> [main__epilogue]

	# Code:
main__prologue:
	# set up stack frame
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw 	$s0, 4($sp)
	sw 	$s1, 0($sp)
main__body:
	# TODO ... complete this function.
m_call_functions:	
	jal     init_snake              # init_snake();
	jal     update_apple            # update_apple();
		 
m_do_while_loop:        
        jal     print_grid              # print_grid();
        jal     input_direction
        move    $a0, $v0                # direction = input_direction
	jal	update_snake		# update_snake();
m_do_while_condition:
	beq	$v0, 1, m_do_while_loop # while (update_snake(direction))

m_end_of_do_while_loop:        
	lw	$s1, snake_body_len	# $s1 = snake_body_len
	div 	$s0, $s1, 3		# int score = snake_body_len / 3;
	
ma_print_game_over:
	la	$a0, main__game_over	# pass string as an argument
	li	$v0, 4			# printf("Game over! Your score was", score);
	syscall

m_print_score:
	move	$a0, $s0		# move score into $a0
	li   	$v0, 1       	        # printf("%d", score)
	syscall

m_print_new_line:
	li      $a0, '\n'      		# printf("%c", '\n');
    	li      $v0, 11			# print char
	syscall
	        
main__epilogue:
	# tear down stack frame
	lw 	$s1, 0($sp)
	lw 	$s0, 4($sp)
	lw	$ra, 8($sp)
	addiu 	$sp, $sp, 12

	li	$v0, 0
	jr	$ra			# return 0;



########################################################################
# .TEXT <init_snake>
	.text
init_snake:

	# Args:     void
	# Returns:  void
	#
	# Frame:    $ra
	# Uses:     $a0, $a1, $a2
	# Clobbers: $a0, $a1, $a2
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   init_snake
	#   -> [init_snake__prologue]
	#   -> init_snake__body
	#   -> [init_snake__epilogue]

	# Code:
init_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

init_snake__body:
	# TODO ... complete this function.
	li	$a0, 7
	li	$a1, 7
	li	$a2, SNAKE_HEAD 
	jal	set_snake 		# set_snake(7, 7, SNAKE_HEAD); 	

	li	$a0, 7
	li	$a1, 6
	li	$a2, SNAKE_BODY
	jal	set_snake 		# set_snake(7, 6, SNAKE_HEAD);

	li	$a0, 7
	li	$a1, 5
	li	$a2, SNAKE_BODY
	jal	set_snake 		# set_snake(7, 5, SNAKE_HEAD); 
	
	li	$a0, 7
	li	$a1, 4
	li	$a2, SNAKE_BODY
	jal	set_snake 		# set_snake(7, 4, SNAKE_HEAD); 		
	

init_snake__epilogue:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	jr	$ra			# return;



########################################################################
# .TEXT <update_apple>
	.text
update_apple:

	# Args:     void
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1, $s2
	# Uses:     $s0, $s1, $s2, $v0, $t0, $t1, $t2, $t3, $a0
	# Clobbers: $a0
	#
	# Locals:
	#   - 'apple_row' in $s0
	#   - 'apple_col' in $s1
	#   - 'N_ROWS' in $a0
	#   - 'N_COLS' in $a0
	#   - 'EMPTY' in $t2
	#   - 'APPLE' in $t3
	#
	# Structure:
	#   update_apple
	#   -> [update_apple__prologue]
	#   -> body
	#   -> ua_do_while_loop
	#	-> ua_do_while_condition
	#	-> ua_end_of_do_while_loop	
	#   -> [update_apple__epilogue]

	# Code:
update_apple__prologue:
	# set up stack frame
	addiu	$sp, $sp, -16	
	sw	$ra, 12($sp)
	sw 	$s0, 8($sp)
	sw 	$s1, 4($sp)
	sw	$s2, 0($sp)

update_apple__body:
	# TODO ... complete this function.
ua_do_while_loop:
	li	$a0, N_ROWS
	jal	rand_value		# rand_value(N_ROWS);
	move	$s0, $v0		# apple_row = rand_value(N_ROWS);

	li	$a0, N_COLS		
	jal	rand_value		# rand_value(N_COLS);
	move	$s1, $v0		# apple_col = rand_value(N_COLS);

ua_do_while_condition:		
	mul 	$t0, $a0, $s0		# $t0 = N_COLS * apple_row	
	add	$t1, $t0, $s1		# $t1 = $t0 + apple_col
	lb	$s2, grid($t1)		# $s2 = grid[[apple_row][apple_col]

	li	$t2, EMPTY		# while (grid[apple_row][apple_col] != EMPTY);
	bne  	$s2, $t2,ua_do_while_loop
ua_end_of_do_while_loop:
	li	$t3, APPLE
	sb	$t3, grid($t1)		# grid[apple_row][apple_col] = APPLE;

update_apple__epilogue:
	# tear down stack frame
	lw	$s2, 0($sp)
	lw	$s1, 4($sp)	
	lw 	$s0, 8($sp)
	lw	$ra, 12($sp)
	addiu 	$sp, $sp, 16
		
	jr	$ra			# return;



########################################################################
# .TEXT <update_snake>
	.text
update_snake:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: bool
	#
	# Frame:    $ra, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $s8
	# Uses:     $v0, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $s8, $a0, $a1, $t0, $t1, $t2, $t3, $t4, $t5, 
	# Clobbers: $v0, $a0, $a1, $t0, $t1, $t3
	#
	# Locals:
	#   - 'd_row' in $t1
	#   - 'd_col' in $t2	
	#   - 'N_COLS' in $t0
	#   - 'N_ROWS' in $t1
	#   - 'APPLE' in $t0
	#   - 'snake_body_len' in $t3
	#   - 'new_head_row' in $s0
	#   - 'new_head_col' in $s1
	#   - 'SNAKE_BODY' in $s4
	#   - 'snake_tail' in $s5
	#   - 'snake_growth' in $s6
	#   - 'head_row' in $s7		         	
	#   - 'head_col' in $s8
	#  
	# Structure:
	#   update_snake
	#   -> [update_snake__prologue]
	#   -> update_snake__body
	#   -> us_set_array_equal_to_snake_body
	#   -> us_if_statements_that_return_false
	#   -> us_bool_apple_check
	#	-> us_is_apple
	#       -> us_is_not_apple
	#   -> us_after_bool_apple_check
	#   -> us_if_not_array_return_false
	#   -> us_set_move_snake_in_array_new
	#   -> us_if_bool_apple_was_true:
	#   -> us_return_true
	#   -> [update_snake__epilogue]
	#	-> return_true
	#	-> return_false

	# Code:
update_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -40
	sw	$ra, 36($sp)
	sw 	$s0, 32($sp)
	sw 	$s1, 28($sp)
	sw	$s2, 24($sp)
	sw	$s3, 20($sp)
	sw	$s4, 16($sp)
	sw	$s5, 12($sp)
	sw	$s6, 8($sp)
	sw	$s7, 4($sp)
	sw	$s8, 0($sp)

update_snake__body:
	# TODO ... complete this function.
	jal	get_d_row		# get_d_row(direction);
	move	$t1, $v0		# int d_row = get_d_row(direction);
	
	jal	get_d_col		# get_d_col(direction);
	move	$t2, $v0		# int d_col = get_d_col(direction);

	lb	$s7, snake_body_row	# int head_row = snake_body_row[0];
	lb	$s8, snake_body_col	# int head_col = snake_body_col[0];

us_set_array_equal_to_snake_body:
	li	$t0, N_COLS		# $t0 = N_COLS
	mul	$t3, $t0, $s7		# $t3 = N_COLS * head_row
	add 	$t4, $t3, $s8		# $t4 = $t3 + head_col

	li	$t5, SNAKE_BODY		# $t5 = SNAKE_BODY
	sb	$t5, grid($t4)		# grid[head_row][head_col] = SNAKE_BODY;

	add	$s0, $t1, $s7		# int new_head_row = head_row + d_row;
	add	$s1, $t2, $s8		# int new_head_col = head_col + d_col;

us_if_statements_that_return_false:
	li	$t1, N_ROWS		# $t1 = N_ROWS
	bltz    $s0, return_false 	# new_head_row < 0
	bge 	$s0, $t1, return_false  # new_head_row >= N_ROWS
	bltz    $s1, return_false	# new_head_col < 0
	bge	$s1, $t0, return_false  # new_head_col >= N_COLS	

us_bool_apple_check:
	mul	$t2, $t0, $s0		# $t2 = N_COLS * new_head_row
	add 	$t3, $t2, $s1		# $t3 = $t2 + new_head_col
	lb 	$s2, grid($t3)		# $s2 = grid[new_head_row][new_head_col]

	li	$t0, APPLE		# $t0 = APPLE
	beq 	$s2, $t0, us_is_apple	# if (grid[new_head_row][new_head_col] == APPLE) is true
	j 	us_is_not_apple		# if (grid[new_head_row][new_head_col] == APPLE) is false

us_is_apple:
	li	$s3, 1			# if (grid[new_head_row][new_head_col] == APPLE)
	j 	us_after_bool_apple_check
us_is_not_apple:  
	li	$s3, 0			# if (grid[new_head_row][new_head_col] != APPLE)

us_after_bool_apple_check:	
	lw	$s4, snake_body_len
	sub	$t0, $s4, 1		# snake_body_len - 1
	la	$s5, snake_tail
	sw	$t0, ($s5)		# snake_tail = snake_body_len - 1

us_if_not_array_return_false:
	move	$a0, $s0
	move	$a1, $s1
	jal	move_snake_in_grid	# move_snake_in_grid(new_head_row, new_head_col)
	beqz	$v0, return_false	# if (! move_snake_in_grid(new_head_row, new_head_col)) 

us_set_move_snake_in_array_new:
	move	$a0, $s0
	move	$a1, $s1
	jal 	move_snake_in_array	# move_snake_in_array(new_head_row, new_head_col);

us_if_bool_apple_was_true:	
	beqz	$s3, return_true 	# if (apple)
	lw	$t0, snake_growth
	add	$t0, $t0, 3		# snake_growth += 3;
	la	$s6, snake_growth		
	sw 	$t0, ($s6)		# save snake_gorwth
	li	$a0, 0
	jal 	update_apple		# update_apple()
us_return_true:	
	j 	return_true

update_snake__epilogue:
	# tear down stack frame
return_true:	
	lw 	$s8, 0($sp)
	lw 	$s7, 4($sp)
	lw 	$s6, 8($sp)
	lw 	$s5, 12($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 20($sp)
	lw 	$s2, 24($sp)
	lw 	$s1, 28($sp)
	lw 	$s0, 32($sp)
	lw	$ra, 36($sp)
	addiu 	$sp, $sp, 40

	li	$v0, 1
	jr	$ra			# return true;

return_false:
	# tear down stack frame
	lw 	$s8, 0($sp)
	lw 	$s7, 4($sp)
	lw 	$s6, 8($sp)
	lw 	$s5, 12($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 20($sp)
	lw 	$s2, 24($sp)
	lw 	$s1, 28($sp)
	lw 	$s0, 32($sp)
	lw	$ra, 36($sp)
	addiu 	$sp, $sp, 40

	li	$v0, 0			# return false; 
	jr	$ra

########################################################################
# .TEXT <move_snake_in_grid>
	.text
move_snake_in_grid:

	# Args:
	#   - $a0: new_head_row
	#   - $a1: new_head_col
	# Returns:
	#   - $v0: bool
	#
	# Frame:    $ra, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $s8
	# Uses:     $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $s8, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $a0, $a1, $v0
	# Clobbers: $a0, $a1, $t0, $t1, $t2, $t4
	#
	# Locals:
	#   - 'snake_growth' in $s0
	#   - 'snake_tail' in $s1, $s3
	#   - 'snake_body_len' in $s2	
	#   - 'tail_row' in $s4
	#   - 'tail_col' in $s5
	#   - 'new_head_row' in $s6
	#   - 'new_head_col' in $s7
	#   - 'N_COLS' in $t0, $t4
	#   - 'EMPTY' in $t4
	#   - 'SNAKE_BODY' in $t3
   	#   - 'SNAKE_HEAD' in $t6
	#
	# Structure:
	#   move_snake_in_grid
	#   -> [move_snake_in_grid__prologue]
	#   -> move_snake_in_grid__body
	#   -> mg_if_snake_growth_gtz
	#   -> mg_else_snake_growth
	#   -> mg_if_array_equals_snake_body
	#   -> mg_set_array_to_snake_head
	#   -> [move_snake_in_grid__epilogue]
	#	-> move_s_true
	#	-> move_s_false

	# Code:
move_snake_in_grid__prologue:
	# set up stack frame
	addiu	$sp, $sp, -40
	sw	$ra, 36($sp)
	sw 	$s0, 32($sp)
	sw 	$s1, 28($sp)
	sw	$s2, 24($sp)
	sw	$s3, 20($sp)
	sw	$s4, 16($sp)
	sw	$s5, 12($sp)
	sw	$s6, 8($sp)
	sw	$s7, 4($sp)
	sw	$s8, 0($sp)

move_snake_in_grid__body:
	# TODO ... complete this function.
mg_if_snake_growth_gtz:
	lw	$t0, snake_growth
	blez	$t0, mg_else_snake_growth

	lw	$t1, snake_tail	
	add	$t1, $t1, 1		# snake_tail++
	la	$s1, snake_tail
	sw	$t1, ($s1)

	lw	$t2, snake_body_len
	add	$t2, $t2, 1		# snake_body_len++
	la	$s2, snake_body_len
	sw	$t2, ($s2)

	sub	$t0, $t0, 1		# snake_growth--
	la	$s0, snake_growth
	sw	$t0, ($s0)

	j 	mg_if_array_equals_snake_body

mg_else_snake_growth:
	lw	$s3, snake_tail		# int tail = snake_tail

	lb	$s4, snake_body_row($s3)# int tail_row = snake_body_row[tail];	
	lb	$s5, snake_body_col($s3)# int tail_col = snake_body_col[tail];

	li	$t0, N_COLS		# $t0 = N_COLS
	mul	$t0, $t0, $s4		# $t0 = N_COLS * tail_row 
	add	$t1, $t0, $s5		# $t1 = $t0 + tail_col
	li	$t2, EMPTY		# $t2 = EMPTY
	sb	$t2, grid($t1)		# grid[tail_row][tail_col] = EMPTY;
	
mg_if_array_equals_snake_body:
	move	$s6, $a0		# new_head_row
	move	$s7, $a1		# new_head_col
	li	$t3, SNAKE_BODY		# $t3 = SNAKE_BODY

	li	$t4, N_COLS		# $t4 = N_COLS
	mul	$t4, $t4, $s6		# $t4 = N_COLS * new_head_row
	add	$t5, $t4, $s7		# $t5 = $t4 + new_head_col
	lb	$s8, grid($t5)		# $s8 = grid[new_head_row][new_head_col] 
	beq	$s8, $t3, move_s_false	# grid[new_head_row][new_head_col] == SNAKE_BODY

mg_set_array_to_snake_head:
	li	$t6, SNAKE_HEAD		# $t6 = SNAKE_HEAD
	sb	$t6, grid($t5)		# grid[new_head_row][new_head_col] = SNAKE_HEAD;
	j 	move_s_true		# return true

move_snake_in_grid__epilogue:
	
move_s_true:
	# tear down stack frame
	lw 	$s8, 0($sp)
	lw 	$s7, 4($sp)
	lw 	$s6, 8($sp)
	lw 	$s5, 12($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 20($sp)
	lw 	$s2, 24($sp)
	lw 	$s1, 28($sp)
	lw 	$s0, 32($sp)
	lw	$ra, 36($sp)
	addiu 	$sp, $sp, 40

	li	$v0, 1
	jr	$ra			# return true;
move_s_false:
	# tear down stack frame
	lw 	$s8, 0($sp)
	lw 	$s7, 4($sp)
	lw 	$s6, 8($sp)
	lw 	$s5, 12($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 20($sp)
	lw 	$s2, 24($sp)
	lw 	$s1, 28($sp)
	lw 	$s0, 32($sp)
	lw	$ra, 36($sp)
	addiu 	$sp, $sp, 40
	li	$v0, 0
	jr	$ra			# return false;

########################################################################
# .TEXT <move_snake_in_array>
	.text
move_snake_in_array:

	# Arguments:
	#   - $a0: int new_head_row
	#   - $a1: int new_head_col
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1, $s2, $s3, $s4
	# Uses:     $s0, $s1, $s2, $s3, $s4, $a0, $a1, $a2
	# Clobbers: $a0, $a1, $a2
	#
	# Locals:
	#   - 'new_head_row' in $s0
	#   - 'new_head_col' in $s1
	#   - 'i' in $s4
	#
	# Structure:
	#   move_snake_in_array
	#   -> [move_snake_in_array__prologue]
	#   -> body
	#   -> ma_for_snake_tail_gte_1
	#   -> ma_after_for_loop
	#   -> [move_snake_in_array__epilogue]

	# Code:
move_snake_in_array__prologue:
	# set up stack frame
	addiu	$sp, $sp, -24
	sw	$ra, 20($sp)
	sw 	$s0, 16($sp)
	sw 	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)	

move_snake_in_array__body:
	# TODO ... complete this function.
	move	$s0, $a0		# new_head_row
	move	$s1, $a1		# new_head_col
	
	lw	$s4, snake_tail		# i = snake_tail
ma_for_snake_tail_gte_1:
	blt	$s4, 1, ma_after_for_loop  # while (i >= 1)

	sub	$s4, $s4, 1		# i--
	lb	$s2, snake_body_row($s4)# snake_body_row[i-1]
	lb	$s3, snake_body_col($s4)# snake_body_col[i-1]
	add	$s4, $s4, 1		# i++

	move	$a0, $s2
	move	$a1, $s3
	move	$a2, $s4
	jal	set_snake_array		# set_snake_array(snake_body_row[i - 1], snake_body_col[i - 1], i);

	sub	$s4, $s4, 1		# i--	
	j 	ma_for_snake_tail_gte_1
ma_after_for_loop:	
	
	move	$a0, $s0		
	move	$a1, $s1
	li	$a2, 0
	jal	set_snake_array		# set_snake_array(new_head_row, new_head_col, 0);

move_snake_in_array__epilogue:
	# tear down stack frame
	lw	$s4, 0($sp)
	lw	$s3, 4($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 12($sp)
	lw 	$s0, 16($sp)
	lw	$ra, 20($sp)
	addiu 	$sp, $sp, 24

	jr	$ra			# return;


########################################################################
####                                                                ####
####        STOP HERE ... YOU HAVE COMPLETED THE ASSIGNMENT!        ####
####                                                                ####
########################################################################

##
## The following is various utility functions provided for you.
##
## You don't need to modify any of the following.  But you may find it
## useful to read through --- you'll be calling some of these functions
## from your code.
##

	.data

last_direction:
	.word	EAST

rand_seed:
	.word	0

input_direction__invalid_direction:
	.asciiz	"invalid direction: "

input_direction__bonk:
	.asciiz	"bonk! cannot turn around 180 degrees\n"

	.align	2
input_direction__buf:
	.space	2



########################################################################
# .TEXT <set_snake>
	.text
set_snake:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int body_piece
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1
	# Uses:     $a0, $a1, $a2, $t0, $s0, $s1
	# Clobbers: $t0
	#
	# Locals:
	#   - `int row` in $s0
	#   - `int col` in $s1
	#
	# Structure:
	#   set_snake
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

	# Code:
set_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1,  ($sp)

set_snake__body:
	move	$s0, $a0		# $s0 = row
	move	$s1, $a1		# $s1 = col

	jal	set_snake_grid		# set_snake_grid(row, col, body_piece);

	move	$a0, $s0
	move	$a1, $s1
	lw	$a2, snake_body_len
	jal	set_snake_array		# set_snake_array(row, col, snake_body_len);

	lw	$t0, snake_body_len
	addiu	$t0, $t0, 1
	sw	$t0, snake_body_len	# snake_body_len++;

set_snake__epilogue:
	# tear down stack frame
	lw	$s1,  ($sp)
	lw	$s0, 4($sp)
	lw	$ra, 8($sp)
	addiu 	$sp, $sp, 12

	jr	$ra			# return;



########################################################################
# .TEXT <set_snake_grid>
	.text
set_snake_grid:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int body_piece
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0, $a1, $a2, $t0
	# Clobbers: $t0
	#
	# Locals:   None
	#
	# Structure:
	#   set_snake
	#   -> body

	# Code:
	li	$t0, N_COLS
	mul	$t0, $t0, $a0		#  15 * row
	add	$t0, $t0, $a1		# (15 * row) + col
	sb	$a2, grid($t0)		# grid[row][col] = body_piece;

	jr	$ra			# return;



########################################################################
# .TEXT <set_snake_array>
	.text
set_snake_array:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int nth_body_piece
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0, $a1, $a2
	# Clobbers: None
	#
	# Locals:   None
	#
	# Structure:
	#   set_snake_array
	#   -> body

	# Code:
	sb	$a0, snake_body_row($a2)	# snake_body_row[nth_body_piece] = row;
	sb	$a1, snake_body_col($a2)	# snake_body_col[nth_body_piece] = col;

	jr	$ra				# return;



########################################################################
# .TEXT <print_grid>
	.text
print_grid:

	# Args:     void
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $v0, $a0, $t0, $t1, $t2
	# Clobbers: $v0, $a0, $t0, $t1, $t2
	#
	# Locals:
	#   - `int i` in $t0
	#   - `int j` in $t1
	#   - `char symbol` in $t2
	#
	# Structure:
	#   print_grid
	#   -> for_i_cond
	#     -> for_j_cond
	#     -> for_j_end
	#   -> for_i_end

	# Code:
	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# putchar('\n');

	li	$t0, 0			# int i = 0;

print_grid__for_i_cond:
	bge	$t0, N_ROWS, print_grid__for_i_end	# while (i < N_ROWS)

	li	$t1, 0			# int j = 0;

print_grid__for_j_cond:
	bge	$t1, N_COLS, print_grid__for_j_end	# while (j < N_COLS)

	li	$t2, N_COLS
	mul	$t2, $t2, $t0		#                             15 * i
	add	$t2, $t2, $t1		#                            (15 * i) + j
	lb	$t2, grid($t2)		#                       grid[(15 * i) + j]
	lb	$t2, symbols($t2)	# char symbol = symbols[grid[(15 * i) + j]]

	li	$v0, 11			# syscall 11: print_character
	move	$a0, $t2
	syscall				# putchar(symbol);

	addiu	$t1, $t1, 1		# j++;

	j	print_grid__for_j_cond

print_grid__for_j_end:

	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# putchar('\n');

	addiu	$t0, $t0, 1		# i++;

	j	print_grid__for_i_cond

print_grid__for_i_end:
	jr	$ra			# return;



########################################################################
# .TEXT <input_direction>
	.text
input_direction:

	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0, $a1, $t0, $t1
	# Clobbers: $v0, $a0, $a1, $t0, $t1
	#
	# Locals:
	#   - `int direction` in $t0
	#
	# Structure:
	#   input_direction
	#   -> input_direction__do
	#     -> input_direction__switch
	#       -> input_direction__switch_w
	#       -> input_direction__switch_a
	#       -> input_direction__switch_s
	#       -> input_direction__switch_d
	#       -> input_direction__switch_newline
	#       -> input_direction__switch_null
	#       -> input_direction__switch_eot
	#       -> input_direction__switch_default
	#     -> input_direction__switch_post
	#     -> input_direction__bonk_branch
	#   -> input_direction__while

	# Code:
input_direction__do:
	li	$v0, 8			# syscall 8: read_string
	la	$a0, input_direction__buf
	li	$a1, 2
	syscall				# direction = getchar()

	lb	$t0, input_direction__buf

input_direction__switch:
	beq	$t0, 'w',  input_direction__switch_w	# case 'w':
	beq	$t0, 'a',  input_direction__switch_a	# case 'a':
	beq	$t0, 's',  input_direction__switch_s	# case 's':
	beq	$t0, 'd',  input_direction__switch_d	# case 'd':
	beq	$t0, '\n', input_direction__switch_newline	# case '\n':
	beq	$t0, 0,    input_direction__switch_null	# case '\0':
	beq	$t0, 4,    input_direction__switch_eot	# case '\004':
	j	input_direction__switch_default		# default:

input_direction__switch_w:
	li	$t0, NORTH			# direction = NORTH;
	j	input_direction__switch_post	# break;

input_direction__switch_a:
	li	$t0, WEST			# direction = WEST;
	j	input_direction__switch_post	# break;

input_direction__switch_s:
	li	$t0, SOUTH			# direction = SOUTH;
	j	input_direction__switch_post	# break;

input_direction__switch_d:
	li	$t0, EAST			# direction = EAST;
	j	input_direction__switch_post	# break;

input_direction__switch_newline:
	j	input_direction__do		# continue;

input_direction__switch_null:
input_direction__switch_eot:
	li	$v0, 17			# syscall 17: exit2
	li	$a0, 0
	syscall				# exit(0);

input_direction__switch_default:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, input_direction__invalid_direction
	syscall				# printf("invalid direction: ");

	li	$v0, 11			# syscall 11: print_character
	move	$a0, $t0
	syscall				# printf("%c", direction);

	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# printf("\n");

	j	input_direction__do	# continue;

input_direction__switch_post:
	blt	$t0, 0, input_direction__bonk_branch	# if (0 <= direction ...
	bgt	$t0, 3, input_direction__bonk_branch	# ... && direction <= 3 ...

	lw	$t1, last_direction	#     last_direction
	sub	$t1, $t1, $t0		#     last_direction - direction
	abs	$t1, $t1		# abs(last_direction - direction)
	beq	$t1, 2, input_direction__bonk_branch	# ... && abs(last_direction - direction) != 2)

	sw	$t0, last_direction	# last_direction = direction;

	move	$v0, $t0
	jr	$ra			# return direction;

input_direction__bonk_branch:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, input_direction__bonk
	syscall				# printf("bonk! cannot turn around 180 degrees\n");

input_direction__while:
	j	input_direction__do	# while (true);



########################################################################
# .TEXT <get_d_row>
	.text
get_d_row:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0
	# Clobbers: $v0
	#
	# Locals:   None
	#
	# Structure:
	#   get_d_row
	#   -> get_d_row__south:
	#   -> get_d_row__north:
	#   -> get_d_row__else:

	# Code:
	beq	$a0, SOUTH, get_d_row__south	# if (direction == SOUTH)
	beq	$a0, NORTH, get_d_row__north	# else if (direction == NORTH)
	j	get_d_row__else			# else

get_d_row__south:
	li	$v0, 1
	jr	$ra				# return 1;

get_d_row__north:
	li	$v0, -1
	jr	$ra				# return -1;

get_d_row__else:
	li	$v0, 0
	jr	$ra				# return 0;



########################################################################
# .TEXT <get_d_col>
	.text
get_d_col:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0
	# Clobbers: $v0
	#
	# Locals:   None
	#
	# Structure:
	#   get_d_col
	#   -> get_d_col__east:
	#   -> get_d_col__west:
	#   -> get_d_col__else:

	# Code:
	beq	$a0, EAST, get_d_col__east	# if (direction == EAST)
	beq	$a0, WEST, get_d_col__west	# else if (direction == WEST)
	j	get_d_col__else			# else

get_d_col__east:
	li	$v0, 1
	jr	$ra				# return 1;

get_d_col__west:
	li	$v0, -1
	jr	$ra				# return -1;

get_d_col__else:
	li	$v0, 0
	jr	$ra				# return 0;



########################################################################
# .TEXT <seed_rng>
	.text
seed_rng:

	# Args:
	#   - $a0: unsigned int seed
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0
	# Clobbers: None
	#
	# Locals:   None
	#
	# Structure:
	#   seed_rng
	#   -> body

	# Code:
	sw	$a0, rand_seed		# rand_seed = seed;

	jr	$ra			# return;



########################################################################
# .TEXT <rand_value>
	.text
rand_value:

	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: unsigned int
	#
	# Frame:    None
	# Uses:     $v0, $a0, $t0, $t1
	# Clobbers: $v0, $t0, $t1
	#
	# Locals:
	#   - `unsigned int rand_seed` cached in $t0
	#
	# Structure:
	#   rand_value
	#   -> body

	# Code:
	lw	$t0, rand_seed		#  rand_seed

	li	$t1, 1103515245
	mul	$t0, $t0, $t1		#  rand_seed * 1103515245

	addiu	$t0, $t0, 12345		#  rand_seed * 1103515245 + 12345

	li	$t1, 0x7FFFFFFF
	and	$t0, $t0, $t1		# (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF

	sw	$t0, rand_seed		# rand_seed = (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF;

	rem	$v0, $t0, $a0
	jr	$ra			# return rand_seed % n;

