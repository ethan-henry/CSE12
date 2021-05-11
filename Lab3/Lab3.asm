##########################################################################
# Created by:  Henry, Ethan
#              efhenry
#              5 November 2019
#
# Assignment:  Lab 3: ASCII Forest
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: This program prints a Forest that is a certain height and number of trees
# 
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

# for(int x=0; x<height; x++)
#{
	# for(int y=0; y<number; y++)
	#{
	# System.out.print(TREE DIAGRAM)'
	#}
	#System.out.print(\n);
#for(int y=0; y<number; y++)
#{
#System.out.print("----");
#}
# for(int x=0; x<height/2; x++)
#{
	# for(int y=0; y<number; y++)
	#{
	# System.out.print("| |");
	#}
	#System.out.print(\n);
#for(int y=0; y<number; y++)
#{
#System.out.print(" _ ");
#}

.text
.globl main
main: 

#Get input value height
getPrompt1:
li $v0, 4
la $a0, prompt1
syscall
li $v0, 5
syscall
move $s0, $v0

#Test if Invalid Height if Tree
start_if1: 
sle $t1, $s0, 0
beqz $t1, end_if1
la $a0, error
move $v0, $a0
li $v0, 4
syscall
b getPrompt1
end_if1:
b getPrompt2


#Get input value numberOfTrees
getPrompt2:
li $v0, 4
la $a0, prompt2
syscall
li $v0, 5
syscall
move $s1, $v0


#Check if Invalid Number of Trees
start_if2: 
sle $t1, $s1, 1
beqz $t1, end_if2
la $a0, error
move $v0, $a0
li $v0, 4
syscall
b getPrompt2
end_if2:


#Print the Top(s) of the Trees
redefine1:
add $t1,$s0, $zero

start_loop1:
	la $a0, 0x20
	move $v0, $a0
	li $v0, 11
	syscall
sne $t0, $t1, 0
beqz $t0, end_loop1
	la $a0, 0x2F
	move $v0, $a0
	sub $t1, $t1, 1
	li $v0, 11
	syscall
	la $a0, 0x5C
	move $v0, $a0
	li $v0, 11
	syscall
	la $a0, 0x20
	move $v0, $a0
	li $v0, 11
	syscall
	la $a0, 0x20
	move $v0, $a0
	li $v0, 11
	syscall
	la $a0, 0x20
	move $v0, $a0
	li $v0, 11
	syscall
b start_loop1
end_loop1:
li $v0, 4
la $a0, newline
syscall

#Print Middle of Tree
redefine3:
add $s5,$s1,$zero
add $s6, $s0, $zero

start_outer_loop:				#Outside Loop
	sne $t0, $s5, 1
	beqz $t0, end_outer_loop
	move $s6, $s0
		start_inner_loop:		#Inside Loop
		sne $t3, $s6, 0
		beqz $t3, end_inner_loop
		sub $s6, $s6, 1
		la $a0, 0x2F
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x20
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x20
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x5C
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x20
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x20
		move $v0, $a0
		li $v0, 11
		syscall
		b start_inner_loop
	end_inner_loop:
		la $a0, 0xA
		move $v0, $a0
		li $v0, 11
		syscall
		sub $s5, $s5, 1
b start_outer_loop
end_outer_loop:

#Print bottom line of Tree
redefine2:
add $t1,$s0,$zero

start_loop2:
	sne $t0, $t1, 0
	beqz $t0, end_loop2
	sub $t1, $t1, 1
	la $a0, 0x2D
	move $v0, $a0
	li $v0, 11
	syscall
	la $a0, 0x2D
	move $v0, $a0
	li $v0, 11
	syscall
	la $a0, 0x2D
	move $v0, $a0
	li $v0, 11
	syscall
	la $a0, 0x2D
	move $v0, $a0
	li $v0, 11
	syscall
	la $a0, 0x20
	move $v0, $a0
	li $v0, 11
	syscall
	la $a0, 0x20
	move $v0, $a0
	li $v0, 11
	syscall
b start_loop2
end_loop2:
la $a0, 0xA
move $v0, $a0
li $v0, 11
syscall

#Print Trunk of Tree
redefine4:
add $t1,$s1,$zero
add $t2, $s0, $zero

start_outer_loop1:				#Outer Loop
	sne  $t0, $t1, 1
	beqz $t0, end_outer_loop1
	sne  $t0, $t1, 0
	beqz $t0, end_outer_loop1
	move $t2, $s0
		start_inner_loop1:		#Inside Loop
		sne $t3, $t2, 0
		beqz $t3, end_inner_loop1
		sub $t2, $t2, 1
		la $a0, 0x20
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x7C
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x7C
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x20
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x20
		move $v0, $a0
		li $v0, 11
		syscall
		la $a0, 0x20
		move $v0, $a0
		li $v0, 11
		syscall
	b start_inner_loop1
end_inner_loop1:
la $a0, 0xA
move $v0, $a0
li $v0, 11
syscall
sub $t1, $t1, 2
b start_outer_loop1
end_outer_loop1:


li $v0, 10					#Ends Code Cleanly
syscall


.data
prompt1: .asciiz "Enter the number of trees to print (must be greater than 0): "
prompt2: .asciiz "Enter the size of one tree (must be greater than 1): "
newline: .asciiz "\n"
error: .asciiz "Invalid entry!\n"

