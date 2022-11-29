# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
main:

    # PUT YOUR CODE
    li  $t0, 0          # i = 0
while1:
    bge $t0, 1000, while1end
    li  $t1, 1
    sb  $t1, prime($t0)
    add     $t0, $t0, 1
    j   while1    
while1end:

    li  $t0, 2

while2:
    bge $t0, 1000, while2end
if:
    lb  $t2, prime($t0)
    bne $t2, 1, ifend

    move $a0, $t0		# move score into $a0
	li   $v0, 1       	# printf("%d", score)
	syscall
	li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11		# print char
	syscall
    
   mul $t3, $t0, 2
while3:
    bge $t3, 1000, while3end
    li  $t4, 0
    sb  $t4, prime($t3)
    add $t3, $t3, $t0
    j   while3

while3end:

ifend:

    add     $t0, $t0, 1
    j   while2
while2end:

    li $v0, 0           # return 0
    jr $31

.data
prime:
    .space 1000
