# read a line and print whether it is a palindrom

main:
    la   $a0, str0       # printf("Enter a line of input: ");
    li   $v0, 4
    syscall

    la   $a0, line
    la   $a1, 256
    li   $v0, 8          # fgets(buffer, 256, stdin)
    syscall              #

    li $t0, 0   #int i
while:
    lb $t1, line($t0)
    beqz $t1, whileend
    add $t0, $t0, 1
    j while
whileend:

    li $t2, 0
    sub $t3, $t0, 2

while2:
    bge $t2, $t3, while2end
if:
    lb $t4, line($t2)
    lb $t5, line($t3)
    beq $t4, $t5, ifend
    la   $a0, not_palindrome
    li   $v0, 4
    syscall
    li   $v0, 0          # return 0
    jr   $ra
ifend:
    add $t2, $t2, 1
    sub $t3, $t3, 1
    j while2
while2end:

  

    la   $a0, palindrome
    li   $v0, 4
    syscall

    li   $v0, 0          # return 0
    jr   $ra


.data
str0:
    .asciiz "Enter a line of input: "
palindrome:
    .asciiz "palindrome\n"
not_palindrome:
    .asciiz "not palindrome\n"


# line of input stored here
line:
    .space 256

