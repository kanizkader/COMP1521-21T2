# Recursive factorial function
# n < 1 yields n! = 1
# $s0 is used for n
# we use an s register because the convention is their value
# is preserved across function calls
# f is in $t0

# DO NOT CHANGE THE CODE IN MAIN

main:
    addi $sp, $sp, -8  # create stack frame
    sw   $ra, 4($sp)   # save return address
    sw   $s0, 0($sp)   # save $s0

    li   $s0, 0
    la   $a0, msg1
    li   $v0, 4
    syscall            # printf(Enter n: ")

    li    $v0, 5
    syscall            # scanf("%d", &n)
    move  $s0, $v0

    move  $a0, $s0     # factorial(n)
    jal   factorial    #
    move  $t0, $v0     #

    move  $a0, $s0
    li    $v0, 1
    syscall            # printf ("%d", n)

    la    $a0, msg2
    li    $v0, 4
    syscall            # printf("! = ")

    move  $a0, $t0
    li    $v0, 1
    syscall            # printf ("%d", f)

    li   $a0, '\n'     # printf("%c", '\n');
    li   $v0, 11
    syscall

                       # clean up stack frame
    lw   $s0, 0($sp)   # restore $s0
    lw   $ra, 4($sp)   # restore $ra
    addi $sp, $sp, 8   # restore sp

    li  $v0, 0         # return 0
    jr  $ra

    .data
msg1:   .asciiz "Enter n: "
msg2:   .asciiz "! = "


# DO NOT CHANGE CODE ABOVE HERE


    .text
factorial:
    #  ADD CODE TO CREATE STACK FRAME
    addiu	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw 	$s0, 8($sp)
	sw 	$s1, 4($sp)
    sw  $s2, 0($sp)
    # ADD CODE FORFUNCTION HERE
# n is in $a0
    li $s0, 0       # int result
    move $s1, $a0   # n
if:
    ble $s1, 1, else

    sub $s1, $s1, 1

    move $a0, $s1
    jal factorial
    move $s2, $v0

    add $s1, $s1, 1

    mul $s0, $s1, $s2
    j   return
    
else:
    li $s0, 1
return:
    # ADD CODE TO REMOVE STACK FRAME
    move	$v0, $s0
    lw  $s2, 0($sp)
    lw 	$s1, 4($sp)
	lw 	$s0, 8($sp)
	lw	$ra, 12($sp)
	addiu 	$sp, $sp, 16

    
    jr  $ra
