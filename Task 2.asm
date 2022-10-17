 .text
main:
        li   $a0, 10
        jal  fib      #Calling fibonacci through recursion      
        
        move    $a0, $v0    # from n to $a0            
        li      $v0, 1      # result
        syscall

        li       $v0, 4   
        syscall

        li      $a0, 1               # $a0 must be equal to 1
        li      $a1, 0               # $a1 must be equal to 0
        li      $a2, 10              # $a2 equal to n
        jal     fib                  # Calling fibonacci
        
        move    $a0, $v0                
        li      $v0, 1               # result
        syscall

        li       $v0, 4   
        syscall

        
        li      $v0, 4     
        la      $a0, exit_str        # print: "Enter to exit"
        syscall

        li      $v0, 8       
        la      $a0, new_str         # Wait for enter to exit
        li      $a1, 32     
        syscall


exit_main:
        lw      $ra, 12($sp)         # Restore return address
        lw      $fp, 8($sp)          # Restore frame pointer
        addiu   $sp, $sp, 24         # Pop stack frame
        
        jr      $ra    

#int fib(int n)
#{
#       if (n == 0)
#               return 0;
#       else if (n == 1)
#               return 1;
#       else
#               return fib(n - 1) + fib(n - 2);
#}
#
#
# a0 = n, we use s0


fib:
        subu    $sp, $sp, 32         # Allocate stack frame of 32 btyes
        sw      $ra, 20($sp)         # Save return address
        sw      $fp, 16($sp)         # Save frame pointer
        sw      $s0, 12($sp)         # Save s0 
        addiu   $fp, $sp, 28         # Setup stack frame

# if (n == 0) then return 0
B1_fib:
        seq     $t0, $a0, $zero
        beq     $t0, $zero, B2_fib   # if (n != 0) ==> goto B2
        li      $v0, 0               # else ==> return zero
        j       exit_fib

# if (n == 1) then return 1
B2_fib:
        seq     $t0, $a0, 1
        beq     $t0, $zero, B3_fib   # if (n != 1) ==> goto B3
        li      $v0, 1               # else ==> return 1
        j       exit_fib

# else return fib(n-1) + fib(n-2);
B3_fib:
        subu    $s0, $a0, 1          # Save n - 1 in s0
        move    $a0, $s0             # arg1 = n -1
        jal     fib     
        
        subu    $a0, $s0, 1          # arg1 = n -2
        move    $s0, $v0             # Save fib(n-1)
        jal     fib
        add     $v0, $v0, $s0        # Return fib(n-1) + fib(n-2)
        
        
exit_fib:
        lw      $ra, 20($sp)         # Restore return address
        lw      $fp, 16($sp)         # Restore frame pointer
        lw      $s0, 12($sp)         # Restore s0
        addiu   $sp, $sp, 32         # Pop stack frame
        
        jr      $ra                  # Return to caller    
                

# a, b = two previos Fib numbers, n = Fib number to generate
# Must be called: Fib(1, 0, n)
#
#int fib_iter(int a, int b, int count)
#{
#       if (count == 1)
#               return b;
#       else
#               return fib_iter(a + b, a, count - 1);
#}
#
# a0 = a, a1 = b, a2 = count

fib_iter:

# if (count == 1) then return b

start_fib_iter:
        seq     $t0, $a2, $zero
        beq     $t0, $zero, B1_fib_iter # if (count != 0) ==> goto B1
        move    $v0, $a1
        j       exit_fib_iter

# else return fiber_iter(a + b, a, count - 1)
B1_fib_iter:
        add     $t0, $a0, $a1          # t0 = a + b
        move    $a1, $a0               # arg2 = a
        move    $a0, $t0               # arg1 = a + b
        subu    $a2, $a2, 1            # arg3 = count - 1
        j       start_fib_iter

exit_fib_iter:
        jr      $ra