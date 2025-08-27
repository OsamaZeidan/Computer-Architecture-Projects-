#Objectives: Solve Linear Equation, by Cramer's Rule...
# Input: From File, Output: To a file or on the screen...
# Team Members: Osama Zeidan | 1210601, Francis Miadi | 1210100
################### Data segment ###################
.data

.align 2
file_descriptor: .word 0 # to save the out file descriptor
.align 2
temp_storage: .word 0 # to save temporary data
.align 2
temp_storage_2: .asciiz "" # to save another temporary data
.align 2
integer_buffer: .space 30 # buffer to save integers
.align 2
float_buffer: .space 30  # buffer to save float numbers
.align 2
temp_buffer: .space 30 

# arrays of 3 integers (coefficients)
.align 2
eq_1: .word 0:4
.align 2
eq_2: .word 0:4
.align 2
eq_3: .word 0:4
.align 2
Xs: .word 0:3
.align 2
Ys: .word 0:3
.align 2
Zs: .word 0:3
.align 2
result: .word 0:3
.align 2
x: .word 0 # to store the x value
.align 2
y: .word 0 # to store the y value
.align 2
z: .word 0 # to store the z value
.align 2
det_A: .word 0 # to store the determinant of A
.align 2
det_Ax: .word 0 # to store the determinant of Ax 
.align 2
det_Ay: .word 0 # to store the determinant of Ay 
.align 2
det_Az: .word 0 # to store the determinant of Az 
result_x: .asciiz "x = "
result_y: .asciiz "y = "
result_z: .asciiz "z = "
no_sol: .asciiz " \n[-] The system has no solution!"
input_file: .space 100
file_data: .space 1024
newLine: .asciiz "\n"
num_of_eqs: .word 0
choice: .byte 
input_file_name: .asciiz "\n[+] Enter The name of Input File, Please: "
output_file: .asciiz "./output.txt"
option_menu: .asciiz "\n[+] To print the result on the Screen, Enter 's' or 'S'.\n[+] To print the result on 'out.txt' enter 'f' or 'F'.\n[+] To Exit enter 'e' or 'E'.\n\n"
invalid_input: .asciiz "\n\n[-] Invalid Option, Please Try Again!\n\n"

factor: .float 100.0 # this factor used to multiply the float numbers by 100
welcome_msg: .asciiz "\n\n[+] Welcome to Osama & Francis Cramer's Calculator....\n\n"
good_bye_msg: .asciiz "\n\n[+] Good Bye!, See You Later!\n"
solution_msg: .asciiz "\n\n[+] The Solution of System in Your Input File...\n"
printed_on_file_msg: .asciiz "\n\n[+]The Solution will be on output.txt...\n"
# float results of determenents
float_det_A: .float 0.0
float_det_Ax: .float 0.0
float_det_Ay: .float 0.0
float_det_Az: .float 0.0
minus_one_float: .float -1.0 # this is to multiply the floats by -1
minus_sign: .asciiz "-"
not_valid_msg: .asciiz "\n[-] There is an invalid equation!, Please Check the Input File...\n"
################### Code segment ###################
.text

# Functions

j main # jump to Main Program
print_array:
	# this function to print any array ($a1 = array_address, $a2 = array_length)
	li $t0, 0 # counter
	loop:
	lw $a0, 0($a1)
	li $v0, 1
	syscall
	addiu $t0, $t0, 1
	beq $t0, $a2, done_print
	addiu $a1, $a1, 4
	b loop
	done_print:
	jr $ra

j main
converte_arrays_3:
	# when the system has 3 equations
	# this function to converte arrays from eq_# to Xs, Ys or Zs
	# ($a1 = adress of eq_#, $a2 = adress of Xs, Ys or Zs)...
	la $a0, Xs
	la $a1, Ys
	la $a2, Zs
	la $a3, result
	la $t0, eq_1
	la $t1, eq_2
	la $t2, eq_3
	
	
	lw $t3, 0($t0)
	sw $t3, 0($a0)
	lw $t3, 0($t1)
	sw $t3, 4($a0)
	lw $t3, 0($t2)
	sw $t3, 8($a0)
	
	lw $t3, 4($t0)
	sw $t3, 0($a1)
	lw $t3, 4($t1)
	sw $t3, 4($a1)
	lw $t3, 4($t2)
	sw $t3, 8($a1)
	
	lw $t3, 8($t0)
	sw $t3, 0($a2)
	lw $t3, 8($t1)
	sw $t3, 4($a2)
	lw $t3, 8($t2)
	sw $t3, 8($a2)
	
	lw $t3, 12($t0)
	sw $t3, 0($a3)
	lw $t3, 12($t1)
	sw $t3, 4($a3)
	lw $t3, 12($t2)
	sw $t3, 8($a3)
	
	
	jr $ra

converte_arrays_2:
	# when the system has 2 equations
	# this function to converte arrays from eq_# to Xs, Ys...
	# ($a1 = adress of eq_#, $a2 = adress of Xs)...
	la $a0, Xs
	la $a1, Ys
	la $a2, Zs
	la $a3, result
	la $t0, eq_1
	la $t1, eq_2
	la $t2, eq_3
	
	# Reset Zs
	sw $zero, 0($a2)
	sw $zero, 4($a2)
	sw $zero, 8($a2)
	
	lw $t3, 0($t0)
	sw $t3, 0($a0)
	lw $t3, 0($t1)
	sw $t3, 4($a0)
	lw $t3, 0($t2)
	sw $t3, 8($a0)
	
	lw $t3, 4($t0)
	sw $t3, 0($a1)
	lw $t3, 4($t1)
	sw $t3, 4($a1)
	lw $t3, 4($t2)
	sw $t3, 8($a1)
	
	# Result
	lw $t3, 12($t0)
	sw $t3, 0($a3)
	lw $t3, 12($t1)
	sw $t3, 4($a3)
	lw $t3, 12($t2)
	sw $t3, 8($a3)
	
	
	jr $ra

ask_for_file:
	# prompt the user
	la $a0, input_file_name
	li $v0, 4
	syscall 
	# read the file name
	la $a0, input_file
	li $a1, 100 # num of characters from user
	li $v0, 8
	syscall
	# Remove the newline character
        la $t0, input_file        # Address of the file name
remove_newline:
    lb $t1, 0($t0)            # Load each byte of the file name
    beqz $t1, done_remove     # If null terminator, we're done
    beq $t1, 0x0A, replace_null # If newline character, replace with null
    addiu $t0, $t0, 1         # Move to the next character
    j remove_newline

replace_null:
    sb $zero, 0($t0)          # Replace newline with null terminator

done_remove:
    jr $ra                    # Return to caller

int_to_string:
    # Inputs:
    #$a0 - integer value to convert
    # $a1 - address of the buffer to store the string
    # output
    # $v0 - start of buffer address where the number is written 
    # $v1 - the address of null termenation of the string 
    #####################################3
    # this function to converte Integers into Strings...
    # Save the callee-saved registers
    addi $sp, $sp , -16
    sw	$ra , ($sp)
    sw	$s0 , 4($sp)
    sw	$s1 , 8($sp)
    sw	$s2 , 12($sp)
    # Initialize the buffer pointer
    move $s0, $a1                                      
    # move to the end of buffer                        
    addi $s0 , $s0 , 9                          
    move $v1 , $s0                                       
    move $s2 , $zero                                    
    # add null termenation
    sb $zero, ($s0)
    #move to least significant digit address
    addi $s0 ,$s0 , -1 
    #make sure that the number is not zero
    bne $a0 , $zero , int_to_string_non_zero_int
    # if it zero 
    addi $s2, $s2, '0'
    sb $s2, ($s0)
    j int_to_string_done
int_to_string_non_zero_int:

convert_number:
    # Convert the number digit by digit
    li $s1, 10
int_to_string_convert_loop:
    # Get the current digit
    divu $a0, $s1 # divide number by 10
    mfhi $s2 # save reminder to s2
    mflo $a0 # save qutien to a0

    # Convert the digit to ASCII and store it
    addi $s2, $s2, '0'
    sb $s2, ($s0)
    
    # Check if we're done
    beq $a0, $zero, int_to_string_done
    addi $s0, $s0, -1 # move to next address
    j int_to_string_convert_loop
    
int_to_string_done:
    # set the output address
    move $v0, $s0
    # restore calee registers 
    lw $ra , ($sp) 
    lw	$s0 , 4($sp)
    lw	$s1 , 8($sp)
    lw	$s2 , 12($sp)
    addi $sp , $sp , 16
    jr $ra


copy_str:
    # copy str: take a memory of data then copy the amount of data to destination address 
    # Inputs:
    # $a0 - source buffer address
    # $a1 - dest buffer address
    # $a2 - lenght of data to copy
    # output:
    # $v0 - address of null termenation char
    # save calee funciton reegisters
    addi $sp, $sp , -4
    sw	$ra , ($sp)

    move $t0 , $a0
    move $t1 , $a1 
    move $t2 ,$a2
    add $t3 , $t1,$t2 # the last address to read 
    move $t4 , $zero
    # if the length is zero then end 
    beq $a2 , $zero , copy_str_end
copy_str_loop:
    lb $t4 , ($t0) 
    sb $t4 , ($t1)
    addi $t0 , $t0, 1
    addi $t1 , $t1, 1
    beq $t3 ,$t1 , copy_str_end 
    j copy_str_loop

copy_str_end:
    #add a null termination to text 
    sb $zero , ($t3)
    # set output the address of null termenation of text 
    move $v0 , $t3 
    # restore calee registers 
    lw $ra , ($sp )
    addi $sp , $sp , 4
    jr $ra

float_to_string:
    # Inputs:
    # $f15 - float value to convert
    # $a0 - address of the buffer to store the string
    # output:
    # $v0 - start of buffer address where the number is written . (the buffer should be at least 25 )
    # $v1 - end ot the buffer where the number is written . (String)
    #############################
    # This function to converte Float Numbers into Strings
    la $a0, temp_storage_2
    # save calee funciton reegisters
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp) # pointer to temp node 
    sw $s5, 20($sp) # test type >> 1 , 2, 3,4 
    sw $ra, 24($sp)
    
    move $s2 , $a0
    move $s3 , $a0
    # Convert float to integer
    cvt.w.s $f1, $f15
    # save the int part in s0
    mfc1 $s0, $f1
    #again convert the int part to float 
    cvt.s.w $f1 , $f1 
    # save 100.0 as float in f5
    li $t0 , 100
    mtc1 $t0 , $f3 
    cvt.s.w $f5 , $f3

    # Calculate fractional part
    sub.s $f1, $f15, $f1
    mul.s $f1, $f1, $f5 
    cvt.w.s $f1, $f1
    mfc1 $s1, $f1 # s1 contain the 2 fraction of floaing number as integer 
    
    ## call the int_to_str to convert the first part to str 
    move $a0 , $s0 
    la $a1 , integer_buffer 
    jal int_to_string
    
    move $a0 , $v0 
    move $a1 , $s2 
    sub $a2 , $v1 , $v0 
    jal copy_str

    move $s2 , $v0

    li $t1 ,'.'
    sb $t1 , ($s2)
    addi $s2 , $s2 , 1

    # find the int to str for fraction part
    move $a0 , $s1 
    la $a1 , float_buffer
    jal int_to_string

    move $a0 , $v0 
    move $a1 , $s2 
    sub $a2 , $v1 , $v0 
    jal copy_str
    
    move $s2 , $v0 # end of the float number 
    
    move $v0 , $s3 
    move $v1 , $s2 
    # copy the values
    
    #copy the str to float buffer 

float_to_string_end:
    # restore calee registers 
    # Restore registers and return
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp) 
    lw $ra, 24($sp)
    addi $sp, $sp, 24   
    jr $ra
 
.globl main
main:
# Welcome Message...
li $v0, 4
la $a0, welcome_msg
syscall
# the Main program function
jal ask_for_file

# Open the Input File for Reading
li $v0, 13
la $a0, input_file
li $a1, 0
li $a2, 0
syscall
move $s0, $v0

# Read the Input File
li $v0, 14
move $a0, $s0
la $a1, file_data
la $a2, 1024
syscall

# print
#li $v0, 4
#la $a0, file_data
#syscall 

# Close the Input File
li $v0, 16
move $a0, $s0
syscall

la $a1, eq_1
la $a2, eq_2
la $a3, eq_3

# Parse Integers
li $t1, 0 # sum = 0
li $t6, 0 # check_validation
li $t2, 10
li $t3, 0 # to indicate the size of equation
li $t4, 0 # index of equation, to know whic array to use
li $t5, 1 # to indicate the minus sign
li $t9, 0 # Flag bit
li $t7, 0 # number of vars in the equation...
# this loop, to extract the equations cooefficents
start_menu:
	# prompt the user
	la $a0, option_menu
	li $v0, 4
	syscall 
	# read char
	li $v0, 12
	syscall
	la $a0, choice
	sb $v0, 0($a0)
	beq $v0, 's', load_data
	beq $v0, 'f', load_data
	beq $v0, 'S', load_data
	beq $v0, 'F', load_data
	beq $v0, 'e', exit
	beq $v0, 'E', exit
	la $a0, invalid_input
	li $v0, 4
	syscall 
	b start_menu
	
load_data:
	# Save the File_Data
	la $a0, file_data
loop1:
	# this loop to read the equations
	##############################################################
	lb $t0, 0($a0)
	addiu $a0, $a0, 1
	beq $t0, '=', check_z
	beq $t0, '+', loop1
	beq $t0, ' ', loop1
	beq $t0, '\n', eq_end # to count the equation
	beq $t0, '-', minus
	blt $t0, '0', add_to_array
	bgt $t0, '9', add_to_array
	addiu $t0, $t0, -48
	mul $t1, $t1, $t2
	add $t1, $t1,  $t0
	b loop1


check_z:
	# this label, to check if the equation has 3 variables or just 2
	##############################################################
	li $t6, 1 # flag to check that '=' exist
	beq $t3, 3, loop1
	li $t9, 1 # flag (no z)
	b loop1
minus:
	# this label to converte the number from postive to minus
	##############################################################
	mul $t5, $t5, -1
	b loop1

add_to_array:
	# this label to add the coefficents to the equations arrays (eq_1, ...)
	##############################################################
	addiu $t7, $t7, 1 # number of variables in the equation...
	addiu $t3, $t3, 1
	beq $t4, 0, eq1
	beq $t4, 1, eq2
	beq $t4, 2, eq3

eq1:
	# to add the variables to eq_1
	##################################################
	beq $t9, 1, increment1
	b continue1
	increment1:
	addiu $a1, $a1, 4
	continue1:
	mul $t1, $t1, $t5
	sw $t1, 0($a1)
	addiu $a1, $a1, 4
	li $t1, 0 # sum = 0
	li $t5, 1
	b loop1
eq2:
	# to add the variables to eq_2
	#################################################
	beq $t9, 1, increment2
	b continue2
	increment2:
	addiu $a2, $a2, 4
	continue2:
	mul $t1, $t1, $t5
	sw $t1, 0($a2)
	addiu $a2, $a2, 4
	li $t1, 0 # sum = 0
	li $t5, 1
	b loop1
eq3:
	# to add the variables to eq_3
	######################################################
	beq $t9, 1, increment3
	b continue3
	increment3:
	addiu $a3, $a3, 4
	continue3:
	mul $t1, $t1, $t5
	sw $t1, 0($a3)
	addiu $a3, $a3, 4
	li $t1, 0 # sum = 0
	li $t5, 1
	b loop1
eq_end:
	# to jump to the next equation, or to solve the system
	##################################################
	bne $t6, 1, not_valid_eq
	addiu $t4, $t4, 1 # jump to next equation
	### check the number of eqs and variables if valid 
	bgt $t4, 3, not_valid_eq
	###
	li $t3, 0 # reset index
	li $t9, 0 # reset flag
	lb $t6, 0($a0)
# 	beq $t6, '\r', sys_end
	blt $t6, '0', sys_end
	bgt $t6, '9', sys_end
	b loop1

not_valid_eq:
	# to print an error message, to indicate an invalid system or equation
	##########################################################3
	li $v0, 4
	la $a0, not_valid_msg
	syscall
	b exit

sys_end:
	# to start solving the system, after reading the system equations...
	#############################################################
	### check the number of eqs and variables if valid 
	blt $t4, 2, not_valid_eq
	###
	move $t8, $t4
	mul $t8, $t8, $t8
	addu $t8, $t8, $t4
	bne $t8, $t7, not_valid_eq
	###
	li $t5, 0 # count the empty lines (if more than 4 the file is finished)
	back:
	# this loop to reject the garbage chars, and to start from the next system, after solving the current system
	##############################################################
	lb $t6, 0($a0)
	beq $t5, 4, cont  # to indicate the end of file
	blt $t6, '0', skip
	bgt $t6, '9', skip
	b cont
	skip:
	addiu $t5, $t5, 1
	addiu $a0, $a0, 1
	b back
	##############################################################
	cont:
	sw $a0, temp_storage # save the file data without the solved systems
	la $a2, num_of_eqs
	sw $t4, 0($a2)
	
	lw $t0, 0($a2)
	li $t1, 2
	# check the size of the system
	beq $t0, $t1, two_eq
	b three_eq

two_eq:
    jal converte_arrays_2
    li $t8, 1 # Zs[2]
    # sw $t8, 8($t0) # set the third element in z to 1
    la $s2, Zs # load the address of array Zs 
    sw $t8, 8($s2) # Zs[2]
    j solve # skip assigning a value to Zs[2] if it was a 2 equation system, to keep it equal to 1

three_eq:
    jal converte_arrays_3
    la $s2, Zs # load the address of array Zs 
    lw $t8, 8($s2) # Zs[2]
     
solve:
    
    # start solving the system
    ##############################################################
	
    la $s0, Xs # load the address of array Xs
    la $s1, Ys # load the address of array Ys
    la $s2, Zs # load the address of array Zs 

    lw $t0, 0($s0) # Xs[0]
    lw $t1, 0($s1) # Ys[0]
    lw $t2, 0($s2) # Zs[0]
    
    lw $t3, 4($s0) # Xs[1]
    lw $t4, 4($s1) # Ys[1]
    lw $t5, 4($s2) # Zs[1]
    
    lw $t6, 8($s0) # Xs[2]
    lw $t7, 8($s1) # Ys[2]
    
    # calculate the det of A
    # det(A) = ( Xs[0]*(Ys[1]*Zs[2] - Ys[2]*Zs[1]) ) - ( Ys[1]*(Xs[1]*Zs[2] - Xs[2]*Zs[1]) ) + ( Zs[2]*(Xs[1]*Ys[2] - Xs[2]*Ys[1]) )
    
    # Xs[0]*(Ys[1]*Zs[2] - Ys[2]*Zs[1])
    
    	mul $s3, $t4, $t8
    	mul $s4, $t7, $t5
    	sub $s5, $s3, $s4
    	mul $s5, $t0, $s5
    	
    # Ys[0]*(Xs[1]*Zs[2] - Xs[2]*Zs[1])
    
    	mul $s3, $t3, $t8
    	mul $s4, $t6, $t5
    	sub $s6, $s3, $s4
    	mul $s6, $t1, $s6
    	
    	
    # Zs[0]*(Xs[1]*Ys[2] - Xs[2]*Ys[1])
    
    	mul $s3, $t3, $t7
    	mul $s4, $t6, $t4
    	sub $s7, $s3, $s4
    	mul $s7, $t2, $s7
    	
    	
    # add them up
    
    	add $s3, $s7, $s5
    	sub $s4, $s3, $s6
    	sw  $s4, det_A   
    
    	beq $s4, $zero, no_solution # if det  =0 , then there is no solution
    	
    	
    # calculate the det of A after substituting the result column instead of the X's
    # det(A) = ( result[0]*(Ys[1]*Zs[2] - Ys[2]*Zs[1]) ) - ( Ys[1]*(result[1]*Zs[2] - result[2]*Zs[1]) ) + ( Zs[2]*(result[1]*Ys[2] - result[2]*Ys[1]) )
    	
    	la $s0, result
    	lw $t0, 0($s0) # result[0]
    	lw $t3, 4($s0) # result[1]
    	lw $t6, 8($s0) # result[2]
    
    # result[0]*(Ys[1]*Zs[2] - Ys[2]*Zs[1])
    
    	mul $s3, $t4, $t8
    	mul $s4, $t7, $t5
    	sub $s5, $s3, $s4
    	mul $s5, $t0, $s5
    	
    # Ys[0]*(result[1]*Zs[2] - result[2]*Zs[1])
    
    	mul $s3, $t3, $t8
    	mul $s4, $t6, $t5
    	sub $s6, $s3, $s4
    	mul $s6, $t1, $s6
    	
    # Zs[0]*(result[1]*Ys[2] - result[2]*Ys[1])
    
    	mul $s3, $t3, $t7
    	mul $s4, $t6, $t4
    	sub $s7, $s3, $s4
    	mul $s7, $t2, $s7
    	
    # add them up
    	
    	add $s3, $s7, $s5
    	sub $s4, $s3, $s6
    	sw  $s4, det_Ax   
    	
    # calculate the det of A after substituting the result column instead of the Y's
    # det(A) = ( Xs[0]*(result[1]*Zs[2] - result[2]*Zs[1]) ) - ( result[1]*(Xs[1]*Zs[2] - Xs[2]*Zs[1]) ) + ( Zs[2]*(Xs[1]*result[2] - Xs[2]*result[1]) )
    	
    	la $s0, result
    	lw $t1, 0($s0) # result[0]
    	lw $t4, 4($s0) # result[1]
    	lw $t7, 8($s0) # result[2]
    	
    	la $s1, Xs
    	lw $t0, 0($s1) # Xs[0]
    	lw $t3, 4($s1) # Xs[1]
    	lw $t6, 8($s1) # Xs[2]
    	
    # Xs[0]*(result[1]*Zs[2] - result[2]*Zs[1])
    
    	mul $s3, $t4, $t8
    	mul $s4, $t7, $t5
    	sub $s5, $s3, $s4
    	mul $s5, $t0, $s5
    	
    # result[0]*(Xs[1]*Zs[2] - Xs[2]*Zs[1])
    
    	mul $s3, $t3, $t8
    	mul $s4, $t6, $t5
    	sub $s6, $s3, $s4
    	mul $s6, $t1, $s6
    
    # Zs[0]*(Xs[1]*result[2] - Xs[2]*result[1])
    
    	mul $s3, $t3, $t7
    	mul $s4, $t6, $t4
    	sub $s7, $s3, $s4
    	mul $s7, $t2, $s7
    	
    # add them up
    
    	add $s3, $s7, $s5
    	sub $s4, $s3, $s6
    	sw  $s4, det_Ay  
    	 
     # calculate the det of A after substituting the result column instead of the Z's
    # det(A) = ( Xs[0]*(Ys[1]*result[2] - Ys[2]*result[1]) ) - ( Ys[1]*(Xs[1]*result[2] - Xs[2]*result[1]) ) + ( result[2]*(Xs[1]*Ys[2] - Xs[2]*Ys[1]) )
    	
    	la $s0, result
    	lw $t2, 0($s0) # result[0]
    	lw $t5, 4($s0) # result[1]
    	lw $t8, 8($s0) # result[2]
    	
    	la $s1, Xs
    	lw $t0, 0($s1) # Xs[0]
    	lw $t3, 4($s1) # Xs[1]
    	lw $t6, 8($s1) # Xs[2]
    	
    	la $s2, Ys
    	lw $t1, 0($s2) # Ys[0]
    	lw $t4, 4($s2) # Ys[1]
    	lw $t7, 8($s2) # Ys[2]
    	
    # Xs[0]*(Ys[1]*result[2] - Ys[2]*result[1])
    
    	mul $s3, $t4, $t8
    	mul $s4, $t7, $t5
    	sub $s5, $s3, $s4
    	mul $s5, $t0, $s5
    
    # Ys[0]*(Xs[1]*result[2] - Xs[2]*result[1])
    
    	mul $s3, $t3, $t8
    	mul $s4, $t6, $t5
    	sub $s6, $s3, $s4
    	mul $s6, $t1, $s6
    	
    # result[0]*(Xs[1]*Ys[2] - Xs[2]*Ys[1])
    
    	mul $s3, $t3, $t7
    	mul $s4, $t6, $t4
    	sub $s7, $s3, $s4
    	mul $s7, $t2, $s7
    	
    # add them up
    	
    	add $s3, $s7, $s5
    	sub $s4, $s3, $s6
    	sw  $s4, det_Az 
    	
    # calculate x,y,z
    	
    	la $t0, det_A
    	lw $t1, 0($t0) # $t1=det_A
    	la $t0, det_Ax
    	lw $t2, 0($t0) # $t2=det_Ax
    	la $t0, det_Ay
    	lw $t3, 0($t0) # $t3=det_Ay
    	la $t0, det_Az
    	lw $t4, 0($t0) # $t4=det_Az
    	
    	# convert the stored values to floating point vlaues
    	
    	mtc1 $t1, $f0 # det_A
    	mtc1 $t2, $f1 # det_Ax
    	mtc1 $t3, $f2 # det_Ay
    	mtc1 $t4, $f3 # det_Az
    	
    	# from word to single precision
    		
    	cvt.s.w $f0, $f0 # det_A
    	cvt.s.w $f1, $f1 # det_Ax
    	cvt.s.w $f2, $f2 # det_Ay
    	cvt.s.w $f3, $f3 # det_Az
    	
    	# store determenets
    	
    	swc1 $f0, float_det_A
    	swc1 $f1, float_det_Ax
    	swc1 $f2, float_det_Ay
    	swc1 $f3, float_det_Az
  
    	la $a0, choice
    	lb $t0, 0($a0)
    	beq $t0, 's', print_on_screen
    	beq $t0, 'S' print_on_screen
    	beq $t0, 'f' print_on_file
    	beq $t0, 'F' print_on_file
    	
print_on_file:
		# Open the output file for writing
		li $v0, 13                  # Syscall for opening a file
		la $a0, output_file         # Address of the output file name
		li $a1, 9                # Write-only mode
		li $a2, 0                   # Default permissions
		syscall
		blt $v0, 0, error_output_file # Check for errors
		move $s0, $v0               # Store file descriptor
		sw $s0, file_descriptor
		
		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		lw $a0, file_descriptor             # File descriptor
		la $a1, newLine       # Address of the text to write
		li $a2, 1                  # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors
		
		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		lw $a0, file_descriptor              # File descriptor
		la $a1, result_x         # Address of the text to write
		li $a2, 4                  # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors
	
		lwc1 $f0, float_det_A
		lwc1 $f1, float_det_Ax
		# Write the value of x to the file
		div.s $f4, $f1, $f0         # Compute x = det_Ax / det_A
		mtc1 $zero, $f10
		c.lt.s $f4, $f10
		bc1t mul_by_minus
		b do_nothing
		mul_by_minus:
		# Write minus sign to the file
		li $v0, 15                  # Syscall for writing to a file
		move $a0, $s0               # File descriptor
		la $a1, minus_sign       # Address of the text to write
		li $a2, 1                 # Number of bytes to write
		syscall
		lwc1 $f10, minus_one_float 
		mul.s $f4, $f4, $f10
		do_nothing:
		mov.s $f15, $f4             # Move x to $f12
		jal float_to_string          # Convert x to ASCII in temp_storage_2
		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		lw $a0, file_descriptor              # File descriptor
		la $a1, temp_storage_2        # Address of the text to write
		li $a2, 3                 # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors
		
		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		move $a0, $s0               # File descriptor
		la $a1, newLine       # Address of the text to write
		li $a2, 1                 # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors

		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		move $a0, $s0               # File descriptor
		la $a1, result_y        # Address of the text to write
		li $a2, 4                  # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors

		lwc1 $f0, float_det_A
		lwc1 $f2, float_det_Ay
		# Write the value of y to the file
		div.s $f5, $f2, $f0         # Compute y = det_Ay / det_A
		mtc1 $zero, $f10
		c.lt.s $f5, $f10
		bc1t mul_by_minus_1
		b do_nothing_1
		mul_by_minus_1:
		# Write minus sign to the file
		li $v0, 15                  # Syscall for writing to a file
		move $a0, $s0               # File descriptor
		la $a1, minus_sign       # Address of the text to write
		li $a2, 1                  # Number of bytes to write
		syscall
		lwc1 $f10, minus_one_float 
		mul.s $f5, $f5, $f10
		do_nothing_1:
		mov.s $f15, $f5             # Move y to $f12
		jal float_to_string          # Convert x to ASCII in temp_storage_2

		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		lw $a0, file_descriptor               # File descriptor
		la $a1, temp_storage_2        # Address of the text to write
		li $a2, 3                  # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors

		
		# Write new line to the file
		li $v0, 15                  # Syscall for writing to a file
		move $a0, $s0               # File descriptor
		la $a1, newLine       # Address of the text to write
		li $a2, 1                  # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors

		# Check if z is required (3 equations)
		la $a0, num_of_eqs
		lw $t0, 0($a0)
		li $t1, 2
		beq $t0, $t1, skip_z        # Skip z if only 2 equations

		# Write "z = " to the file
		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		move $a0, $s0               # File descriptor
		la $a1, result_z        # Address of the text to write
		li $a2, 4                  # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors

		lwc1 $f0, float_det_A
		lwc1 $f3, float_det_Az
		# Write the value of x to the file
		div.s $f6, $f3, $f0         # Compute z = det_Az / det_A
		mtc1 $zero, $f10
		c.lt.s $f6, $f10
		bc1t mul_by_minus_2
		b do_nothing_2
		mul_by_minus_2:
		# Write minus sign to the file
		li $v0, 15                  # Syscall for writing to a file
		move $a0, $s0               # File descriptor
		la $a1, minus_sign       # Address of the text to write
		li $a2, 1                  # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors
		lwc1 $f10, minus_one_float 
		mul.s $f6, $f6, $f10
		do_nothing_2:
		mov.s $f15, $f6             # Move x to $f12
		jal float_to_string          # Convert x to ASCII in temp_storage_2
		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		lw $a0, file_descriptor                # File descriptor
		la $a1, temp_storage_2        # Address of the text to write
		li $a2, 3                 # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors
		
		# Write data to the file
		li $v0, 15                  # Syscall for writing to a file
		move $a0, $s0               # File descriptor
		la $a1, newLine       # Address of the text to write
		li $a2, 1                  # Number of bytes to write
		syscall
		blt $v0, 0, error_output_file    # Check for errors
		
	# Close the output file
		li $v0, 16                  # Syscall for closing a file
		move $a0, $s0               # File descriptor
		syscall
		b end
skip_z:
    # if there is no 3rd variable in the equation (system size = 2)
    # Close the output file
    li $v0, 16                  # Syscall for closing a file
    move $a0, $s0               # File descriptor
    syscall
    b end

error_output_file:
    # Handle file open error
    move $a0, $v0
    li $v0, 1
    syscall
    b end

print_on_screen:
	# print msg on screen...
	 li $v0, 4
         la $a0, solution_msg
         syscall
         
	li $v0, 4 
    	la $a0, newLine 
    	syscall  
    	
    	li $v0, 4  # Syscall code for printing a string
    	la $a0, result_x 
    	syscall  
    
    	div.s $f4, $f1, $f0 #x
    	li $v0, 2 # Syscall code for printing a floating-point number
    	mov.s $f12, $f4 # Move the result into $f12 (the argument for printing)
    	syscall
    	
    	li $v0, 4 
    	la $a0, newLine 
    	syscall  
    	
    	li $v0, 4  
    	la $a0, result_y 
    	syscall 
    	
    	div.s $f5, $f2, $f0 #y
    	li $v0, 2 
    	mov.s $f12, $f5 
    	syscall
    	
    	li $v0, 4  
    	la $a0, newLine 
    	syscall
    	
    	
#   bne $t9, $zero, end # if it is a 2 equation system, no need to calculate z
     la $a0, num_of_eqs
     lw $t0, 0($a0)
     li $t1, 2
     beq $t0, $t1, end
    	 
    li $v0, 4  
    la $a0, result_z 
    syscall 
    	
    div.s $f6, $f3, $f0 #z
    li $v0, 2 
    mov.s $f12, $f6 
    syscall
    	
    li $v0, 4  
    la $a0, newLine 
    syscall
    	
     j end
    		
no_solution:
	# if the system has no solution...
	la $t0, choice
	lb $t0, 0($t0)
	beq $t0, 's', on_screen
	beq $t0, 'S', on_screen
	beq $t0, 'f', on_file
	beq $t0, 'F', on_file
	on_screen:
	li $v0, 4  
    	la $a0, newLine 
    	syscall
    	
	li $v0, 4  
    	la $a0, no_sol 
    	syscall 
    	
    	li $v0, 4  
    	la $a0, newLine 
    	syscall
    	
    on_file:
    # Open the output file for writing
    li $v0, 13                  # Syscall for opening a file
    la $a0, output_file         # Address of the output file name
    li $a1, 9                  # Write-only mode
    li $a2, 0                   # Default permissions
    syscall
    blt $v0, 0, error_output_file # Check for errors
    move $s0, $v0               # Store file descriptor
    # Write "No Solution" to the file
    li $v0, 15
    move $a0, $s0
    la $a1, no_sol
    li $a2, 32
    syscall
    # Write "New Line" to the file
    li $v0, 15
    move $a0, $s0
    la $a1, newLine
    li $a2, 1
    syscall
    
     # Close the output file
    li $v0, 16                  # Syscall for closing a file
    move $a0, $s0               # File descriptor
    syscall
    	
end:    	
    	# to reset all of registers.....
	li $t4, 0
	li $t1, 0 # sum = 0
	li $t2, 10
	la $a1, eq_1
	la $a2, eq_2
	la $a3, eq_3
	sw $zero, 0($a1)
	sw $zero, 4($a1)
	sw $zero, 8($a1)
	sw $zero, 12($a1)
	sw $zero, 0($a2)
	sw $zero, 4($a2)
	sw $zero, 8($a2)
	sw $zero, 12($a2)
	sw $zero, 0($a3)
	sw $zero, 4($a3)
	sw $zero, 8($a3)
	sw $zero, 12($a3)
	li $t6, 0 # check_validation
	li $t3, 0 # to indicate the size of equation
	li $t4, 0 # index of equation, to know whic array to use
	li $t9, 0 # Flag bit
	li $t7, 0 # reset the number of variables
	lw $a0, temp_storage
	lb $t5, 0($a0)
	blt $t5, '0', return_back
	bgt $t5, '9', return_back
	li $t5, 1 # to indicate the minus sign
	b loop1 # to read the next system and solve it...

return_back:
# to return to menu
li $t5, 1 # to indicate the minus sign
la $a0, choice
    lb $t0, 0($a0)
    beq $t0, 'f', printed_on_file
    beq $t0, 'F', printed_on_file
    b pass
    printed_on_file:
    li $v0, 4
    la $a0, printed_on_file_msg
    syscall
    
    pass:
b start_menu

exit:
    
    li $v0, 4
    la $a0, good_bye_msg
    syscall
    # Exit program
    li $v0, 10               # Exit syscall
    syscall


