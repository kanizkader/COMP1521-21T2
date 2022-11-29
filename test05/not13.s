main:
    li   $v0, 5         #   scanf("%d", &x);
    syscall             #
    move $t0, $v0

    li   $v0, 5         #   scanf("%d", &y);
    syscall             #
    move $t1, $v0
    
    #li   $t3, 0
    
    addi  $t3, $t0, 1   # i = 1 + x
    
loop:
    bge   $t3, $t1, end
if:
    beq,  $t3, 13, end_1
    
    move   $a0, $t3        #   printf("%d\n", 42);
    li   $v0, 1
    syscall
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall
        
end_1:    
    addi $t3, $t3, 1    # i++
    j   loop    

end:

    li   $v0, 0         # return 0
    jr   $ra
