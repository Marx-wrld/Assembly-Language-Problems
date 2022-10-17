.text
main:
# Prompt user to input non-negative number
la $a0,prompt   
li $v0,4
syscall

li $v0,5    #Read the number(n)
syscall

move $t2,$v0    # n to $t2

# Call function to get fibonnacci #n
move $a0,$t2
move $v0,$t2
jal squareSeries     #call squareSeries(n)
move $t3,$v0    #result is in $t3

# Output message and n
la $a0,result   #Print H_
li $v0,4
syscall

move $a0,$t2    #Print n
li $v0,1
syscall

la $a0,result2  #Print =
li $v0,4
syscall

move $a0,$t3    #Print the answer
li $v0,1
syscall

la $a0,endl #Print '\n'
li $v0,4
syscall

# End program
li $v0,10
syscall

squareSeries:
# Compute and return fibonacci number

beq $a0,1,one   #if n=1 return 1

sub     $sp, $sp,4              # making a space in stack
sw      $ra,0($sp)              # return address stored in stack 
mul     $t1,$a0,$a0             # multiply $a0*$a0 means $a0^2 and storing it in $t1
sub     $sp, $sp,4              # making a space in stack
sw      $t1,0($sp)              #storing a square of $a0 in stack       
sub     $a0, $a0,1              #subtracting $a0 by 1 
jal     squareSeries            #again calling squareSeries to implement recursion
lw      $t1, 0($sp)             #retriving $a1 from stack
addi    $sp, $sp,4              # making a space in stack
add     $v0, $v0, $t1           # performing  a sum of squares 
lw      $ra, 0($sp)             # again loading a return 
addi    $sp,$sp,4               # making a space in stack
jr      $ra                     #jump to its parent calling process 



one:
li $v0,1
jr $ra          #jump to its parent calling process 

.data
prompt: .asciiz "This program calculates  square of n numbers (starting from 1) and then performs addition of that using recursive function.\nEnter a non-negative number: "
result: .asciiz "H_"
result2: .asciiz " = "
endl: .asciiz "\n"
