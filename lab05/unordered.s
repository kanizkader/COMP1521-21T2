# Read 10 numbers into an array
# print 0 if they are in non-decreasing order
# print 1 otherwise

# i in register $t0

main:

    li   $t0, 0         # i = 0
loop0:
    bge  $t0, 10, end0  # while (i < 10) {

    li   $v0, 5         #   scanf("%d", &numbers[i]);
    syscall             #

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    sw   $v0, ($t3)     #   store entered number in array

    addi $t0, $t0, 1    #   i++;
    j    loop0          # }
end0:
    # PUT YOUR CODE HERE
    li   $t4, 0         # swapped = 0
    li   $t0, 1         # i = 1 
    
loop1:
    #calculate i - 1 using (address - 4 bytes)
    
    
    bge  $t0, 10, end1  # while (i < 10) {
    li   $t1, 0
    li   $t2, 0
    li   $t3, 0
    mul  $t1, $t0, 4    #   calculate &numbers[i] (GIVES NUM OF BYTES)
    la   $t2, numbers   #(LOADING ADDRESS OF NUMBERS INTO t2)=startofarray
    add  $t3, $t1, $t2  #   num of bytes + start of array
    lw   $a1, ($t3)     #   store entered number in array
    # lw when array is on RHS
    # sw when array is on LHS
    
    move $t5, $a1       #   int x = numbers[i]
    
    li   $t1, 0
    li   $t2, 0
    li   $t3, 0
    
    subu $t0, $t0, 1    #   i--;
    
    mul  $t1, $t0, 4    #   calculate &numbers[i - 1]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $a2, ($t3)     #   store entered number in array
    
    move $t6, $a2       #   int y = numbers[i - 1] 
    
    addi $t0, $t0, 1    #   i++;
    
if:
    bge  $t5, $t6, end2 #   if (x < y)
    li   $t4, 1         #   swapped = 1
    
end2:
    addi $t0, $t0, 1    #   i = i + 1;      
    j    loop1
    
end1:          
    
    move   $a0, $t4        # printf("%d", 42)
    li   $v0, 1         #
    syscall

    li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11
    syscall
    
    

    jr   $ra

.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};

