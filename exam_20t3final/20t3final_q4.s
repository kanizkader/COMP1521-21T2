# COMP1521 20T3 final exam Q4 starter code

# This code reads 1 integer and prints it

# Change it to read integers until low is greater or equal to high,
# then print their difference

main:
    li $t0, 0 #low
    li $t1, 100 #high
while:
    bge $t0, $t1, end

    li   $v0, 5        #   scanf("%d", &x);
    syscall

    move $t3, $v0  #x

    add $t0, $t0, $t3
    sub $t1, $t1, $t3
    j while

end:
    sub  $t4, $t0, $t1
    move $a0, $t4      #   printf("%d\n", x);
    li   $v0, 1
    syscall

    li   $a0, '\n'     #   printf("%c", '\n');
    li   $v0, 11
    syscall

    li   $v0, 0        #   return 0
    jr   $ra
