#------------------------------------------------------------------------
# Created by:  Henry, Ethan
#              efhenry
#              11 Dec 2019 
#
# Assignment:  Lab 5: Subroutines
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: Library of subroutines used to convert an array of
#              numerical ASCII strings to ints, sort them, and print
#              them.
# 
# Notes:       This file is intended to be run from the Lab 5 test file.
#------------------------------------------------------------------------

.text

j  exit_program                # prevents this file from running
                               # independently (do not remove)

#------------------------------------------------------------------------
# MACROS
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# print new line macro
.macro lab5_print_new_line
    addiu $v0 $zero   11
    addiu $a0 $zero   0xA
    syscall
.end_macro

#------------------------------------------------------------------------
# print string

.macro lab5_print_string(%str)

    .data
    string: .asciiz %str

    .text
    li  $v0 4
    la  $a0 string
    syscall
    
.end_macro

#------------------------------------------------------------------------
# add additional macros here


#------------------------------------------------------------------------
# main_function_lab5_19q4_fa_ce12:
#
# Calls print_str_array, str_to_int_array, sort_array,
# print_decimal_array.
#
# You may assume that the array of string pointers is terminated by a
# 32-bit zero value. You may also assume that the integer array is large
# enough to hold each converted integer value and is terminated by a
# 32-bit zero value
# 
# arguments:  $a0 - pointer to integer array
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - minimum element in array (32-bit int)
#             $v1 - maximum element in array (32-bit int)
#-----------------------------------------------------------------------
# REGISTER USE
# $s0 - pointer to int array
# $s1 - double pointer to string array
# $s2 - length of array
#-----------------------------------------------------------------------

.text
main_function_lab5_19q4_fa_ce12: 
    subi  $sp    $sp   16       # decrement stack pointer
    sw    $ra 12($sp)           # push return address to stack
    sw    $s0  8($sp)           # push save registers to stack
    sw    $s1  4($sp)
    sw    $s2   ($sp)
    
    move  $s0    $a0            # save ptr to int array
    move  $s1    $a1            # save ptr to string array
    
    move  $a0    $s1   
        # load subroutine arguments
    jal   get_array_length      # determine length of array
    move  $s2    $v0            # save array length
                                # print input header
                                 
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nInput string array\n")
                       
    ########################### 
    move $a1, $s1
    move $a0, $s2
                                 # load subroutine arguments
    jal   print_str_array
                 # print array of ASCII strings
	
    
    ########################### # add code (delete this comment)
              # load subroutine arguments
    move $a1, $s1
    move $a0, $s2
    move $a2, $s0
    jal   str_to_int_array
          # convert string array to int array
                           
    ########################### # add code (delete this comment)                             # load subroutine arguments
    move $a1, $s0
    move $a0, $s2
    jal   sort_array
                # sort int array                          # save min and max values from array

                                # print output header    
    lab5_print_new_line
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nSorted integer array\n")
    
    ########################### # add code (delete this comment)                            # load subroutine arguments
    
    move $a1, $s0
    move $a0, $s2
    jal   print_decimal_array   # print integer array as decimal                          # save output values
    lab5_print_new_line

    ########################### # add code (delete this comment)
    move $v0, $t6                            # move min and max values from array
                                # to output registers
                                          
    lw    $ra 12($sp)           # pop return address from stack
    lw    $s0  8($sp)           # pop save registers from stack
    lw    $s1  4($sp)
    lw    $s2   ($sp)
    addi  $sp    $sp   16       # increment stack pointer
    jr    $ra                   # return from subroutine

#-----------------------------------------------------------------------
# print_str_array	
#
# Prints array of ASCII inputs to screen.
#
# arguments:  $a0 - array length (optional)
# 
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_str_array: 

	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 9
 	move $t1, $a1
	BeginOutLoop:
	lw $t0, ($t1)
	li $t2, 0
	BeginLoop:
		beq $t0, $zero, EndLoop
		lb $t3 ($t0)
		move $a0, $t3
		li $v0, 11
		syscall
		add $t0, $t0, 1
		add $t2, $t2, 1
		bne $t2, 11, BeginLoop
	sub $t4, $t4, 1
	add $t1, $t1, 4
	la $a0, 0x20
	move $v0, $a0
	li $v0, 11
	syscall
	bne $t5, $zero, BeginOutLoop
EndLoop:
                                # add code to implement subroutine

    jr  $ra
    
#-----------------------------------------------------------------------
# str_to_int_array
#
# Converts array of ASCII strings to array of integers in same order as
# input array. Strings will be in the following format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, with A - F
# capitalized
# 
# arguments:  $a0 - array length (optional)
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
#             $a2 - pointer to integer array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
str_to_int_array: 
move $t2, $a0
move $t3, $ra
move $t8, $a1
looptyloop:
	lw $a0, ($t8)
	jal str_to_int
	sub $t2, $t2, 1
	add $t8, $t8, 4
	sw $v0, ($a2)
	add $a2, $a2, 4
	bne $t2, $zero, looptyloop
move $ra, $t3
    jr   $ra

#-----------------------------------------------------------------------
# str_to_int	
#
# Converts ASCII string to integer. Strings will be in the following
# format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, capitalizing
# A - F.
# 
# argument:   $a0 - pointer to first character of ASCII string
#
# returns:    $v0 - integer conversion of input string
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
str_to_int: 
	li $t7, 0
	li $t4, 0
	li $t6, 11
	li $t5, 9
	li $v0, 0
	BeginLoop5:
		beq $a0, $zero, EndLoop5
		lb $t1 ($a0)
		sub $t1, $t1, 48
		bgt $t1, 16, letter
		bge $t1, 103, fix
		b rest
			letter:
			sub $t1, $t1, 7
			b rest
		rest:
		beq $t6, $zero, end
		sub $t6, $t6, 1
		move $t4, $t6
		beq $t4, $zero, end
		sub $t4, $t4, 1
		beginloop5:
			beq $t4, $zero, end
			sub $t4, $t4, 1
			mul $t1, $t1, 16
			bne $t4, $zero, beginloop5
		end:
		add $v0, $v0, $t1
		fix:
		add $a0, $a0, 1
		add $t7, $t7, 1
bne $t7, 10, BeginLoop5

EndLoop5:
    jr   $ra
    
#-----------------------------------------------------------------------
# sort_array
#
# Sorts an array of integers in ascending numerical order, with the
# minimum value at the lowest memory address. Assume integers are in
# 32-bit two's complement notation.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    $v0 - minimum element in array
#             $v1 - maximum element in array
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
sort_array:  
move $t3, $a0
move $t4, $a0
move $t5, $a0
move $t7, $a0
move $t8, $a1
li $t1, 0
sub $t3, $t3, 1
sub $t4, $t4, 1
scooptityloop:
mul $t7, $t4, 4
lw $t0, ($t8)
lw $t2, 4($t8)
bgt $t0, $t2, bigboi
b zombie

	bigboi:
		move $t1, $t0
		sw $t2, ($t8)
		sw $t1, 4($t8)
	zombie:
sub $t3, $t3, 1
add $t8, $t8, 4
bnez $t3, scooptityloop
sub $t4, $t4, 1
move $t3, $t4
sub $t8, $t8, $t7
bnez $t4, scooptityloop

sub $a0, $a0, 1
mul $t6, $a0, 4
add $t8, $t8, $t6
lw $v1, ($t8)
sub $t8, $t8, $t6
lw $v0, ($t8)
move $t6, $v0
jr $ra
#-----------------------------------------------------------------------
# print_decimal_array
#
# Prints integer input array in decimal, with spaces in between each
# element.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_decimal_array: 
move $t5, $ra
move $t8, $a1
move $t3, $a0
beginloop9:
lw $a0, ($t8)
jal print_decimal
add $t8, $t8, 4
li $a0, 0x20
li $v0, 11
syscall
sub $t3, $t3, 1
bnez $t3, beginloop9
rest9:
move $ra, $t5
move $v0, $t6

    jr   $ra
    
#-----------------------------------------------------------------------
# print_decimal
#
# Prints integer in decimal representation.
#
# arguments:  $a0 - integer to print
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
print_decimal: 

li $t0, 0
li $t1, 0
li $t2, 0 
li $t4, 0 
li $t7, 0      
move $t2, $a0
move $t9, $a0
move $t4, $t2
blt $t2, $zero, negative
b rest2
negative:
	mul $t2, $t2, -1
	li $t7, 1
rest2:
beq $t7, 1, negative1
b beginloop

negative1:
	li $a0, 45
	li $v0, 11
	syscall
beginloop:

bge $t2, 10, big
add $t4, $t4, 1
b rest3


big:
	div  $t2, $t2, 10
	mfhi $t0
	sw $t0, ($sp)
	sub $sp, $sp, 4
	add $t1, $t1, 1
	b rest3
	

 rest3:
bge $t2, 10, beginloop
	add $t2, $t2, 48
	move $a0, $t2
	li $v0, 11
	syscall

move $t7, $t1

beq $t7, $zero, rest4
beginloop1:
	add $sp, $sp, 4
	lw $t2, ($sp)
	addi $t2, $t2, 48
	move $a0, $t2
	li $v0, 11
	syscall
	sub $t7, $t7, 1
	sub $t1, $t1, 1
	bne $t7, $zero, beginloop1
	
rest4:
move $a0, $t9

    jr   $ra

#-----------------------------------------------------------------------
# exit_program (given)
#
# Exits program.
#
# arguments:  n/a
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $v0: syscall
#-----------------------------------------------------------------------

.text
exit_program: nop
    
    addiu   $v0  $zero  10      # exit program cleanly
    syscall
    
#-----------------------------------------------------------------------
# OPTIONAL SUBROUTINES
#-----------------------------------------------------------------------
# You are permitted to delete these comments.

#-----------------------------------------------------------------------
# get_array_length (optional)
# 
# Determines number of elements in array.
#
# argument:   $a0 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - array length
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------

.text
get_array_length: nop
li $v0, 3
                                # replace with /code to
                                # determine array length
    jr      $ra
    
#-----------------------------------------------------------------------
# save_to_int_array (optional)
# 
# Saves a 32-bit value to a specific index in an integer array
#
# argument:   $a0 - value to save
#             $a1 - address of int array
#             $a2 - index to save to
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# 
#-----------------------------------------------------------------------
