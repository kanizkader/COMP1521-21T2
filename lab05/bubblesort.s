# read 10 numbers into an array
# bubblesort them
# then print the 10 numbers

# i in register $t0
# registers $t1, $t2 & $t3 used to hold temporary results

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
    li   $t9, 1         # swapped = 1   

while:
    bne  $t9, 1, endw
    li   $t9, 0         # swapped = 0  
    
    li   $t0, 1         # i = 1
    
loop_half:
    bge  $t0, 10, end_half  # while (i < 10) {
        
    mul  $t1, $t0, 4    #   calculate &numbers[i] (GIVES NUM OF BYTES)
    la   $t2, numbers   
    add  $t3, $t1, $t2  #   num of bytes + start of array
    lw   $a1, ($t3)     #   store entered number in array
    # lw when array is on RHS
    # sw when array is on LHS
    
    move $t5, $a1       #   int x = numbers[i]
      
    subu $t0, $t0, 1    #   i--;
    
    mul  $t1, $t0, 4    #   calculate &numbers[i - 1]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $a2, ($t3)     #   store entered number in array
    
    move $t6, $a2       #   int y = numbers[i - 1] 
    addi $t0, $t0, 1    #   i++; 
    
if:
    bge  $t5, $t6, end2 #   if (x < y)
    
    mul  $t1, $t0, 4    #   calculate &numbers[i] (GIVES NUM OF BYTES)
    la   $t2, numbers   
    add  $t3, $t1, $t2  #   num of bytes + start of array
    sw   $t6, ($t3)     #   store entered number in array [Y]
                        # lw when array is on RHS
                        # sw when array is on LHS
                      
    
    mul  $t1, $t0, 4    #   calculate &numbers[i - 1]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    subu $t3, $t3, 4    #   [address - 4];
    sw   $t5, ($t3)     #   store entered number in array [x]
    
    li   $t9, 1         # swapped = 1    
    
    
end2:
    addi $t0, $t0, 1    #   i = i + 1;      
    j    loop_half
    
end_half:

endw:
    

    li   $t0, 0         # i = 0
loop1:
    bge  $t0, 10, end1  # while (i < 10) {

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $a0, ($t3)     #   load numbers[i] into $a0
    li   $v0, 1         #   printf("%d", numbers[i])
    syscall

    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

    addi $t0, $t0, 1    #   i++
    j    loop1          # }
end1:

    jr   $ra            # return

.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};

