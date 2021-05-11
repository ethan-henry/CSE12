##########################################################################
# Created by:  Henry, Ethan
#              efhenry
#              13 November 2019
#
# Assignment:  Lab 4: Sorting Floats
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: This program will take arguments and return them sorted from least to greatest in both IEEE 754 single precision and Decimal
# 
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

#Pseudocode:
#Print "Program Arguments: "
#Print the Program Arguments by accessing thier memory spots and using syscall 2
#Use some comparator (like blt or bne) and find which is greatest and which is least greatest, moving larger numbers to a specific address in memory
#Print "Sorted Values (IEEE 754 single precision floatinf point format): "
#Print the sorted values using syscall 2 and a for loop
#Convert the floating point numbers and save them in a similar configuration to the sorted unconverted numbers
#Print "Sorted values (decimal): "
#Use for loop to print out converted numbers
.text



#Print the description for the arguments
la $a0, arguments
li $v0, 4
syscall
la $a0, newLine
syscall

BeginOutLoop:
	lw $t0 ($a1)
	move $t5, $t6
	li $s7, 0
	BeginLoop:
		beq $t0, $zero, EndLoop
		lb $s5 ($t0)
		move $a0, $s5
		li $v0, 11
		syscall
		add $t0, $t0, 1
		add $s7, $s7, 1
		bne $s7, 11, BeginLoop
	sub $t5, $t5, 1
	add $a1, $a1, 4
	la $a0, 0x20
	move $v0, $a0
	li $v0, 11
	syscall
	bne $t5, $zero, BeginOutLoop
EndLoop:
la $a0, newLine
li $v0, 4
syscall
syscall





#Print the Description for the sorted values in IEEE 754 single precision floating point format/sorting
sub $a1, $a1, 12
la $a0, hex
li $v0, 4
syscall
la $a0, newLine
li $v0, 4
syscall

li $s5, 3
BeginOutLoop5:
	lw $s0 ($a1)
	move $t5, $t6
	li $s7, 0
	li $s4, 0
	li $t6, 11
	li $t5, 9

	BeginLoop5:
		beq $s0, $zero, EndLoop5
		lb $s1 ($s0)
		sub $s1, $s1, 48
		bgt $s1, 16, letter
		bge $s1, 103, fix
		b rest
			letter:
			sub $s1, $s1, 7
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
			mul $s1, $s1, 16
			bne $t4, $zero, beginloop5
		end:
		add $s4, $s4, $s1
		fix:
		add $s0, $s0, 1
		add $s7, $s7, 1
		

		bne $s7, 10, BeginLoop5
beq $s5, 3, f3
beq $s5, 2, f2
beq $s5, 1, f1
f3:
	sw $s4, ($a1)
	l.s $f5, ($a1)
	b end1
f2:
	sw $s4, ($a1)
	l.s $f4, ($a1)
	b end1
f1:
	sw $s4, ($a1)
	l.s $f3, ($a1)
	b end1
end1:
#		la $a0, 0x20
#		move $v0, $a0
#		li $v0, 11
#		syscall
		sub $s5, $s5, 1
#		move $a0, $s4
#		li $v0, 34
#		syscall
	beq $a0, $zero, EndLoop5
#	move $s5, $s4


	sub $t5, $t5, 1
	add $a1, $a1, 4
#	la $a0, 0x20
#	move $v0, $a0
#	li $v0, 11
#	syscall
	bne $t5, $zero, BeginOutLoop5
EndLoop5:

#cvt.w.s $f15, $f5
#cvt.w.s $f13, $f4
#cvt.w.s $f14, $f3

mov.s $f0, $f3
mov.s $f1, $f4
mov.s $f2, $f5
beginsortloop5:

li $s3, 1
c.lt.s $f1, $f0
	bc1t least1
c.lt.s $f2, $f0
	bc1t least2
c.le.s $f0, $f2
	bc1f greatest1
c.le.s $f1, $f2
	bc1f greatest2
b rest2
	least1:
		mov.s $f10, $f0
		mov.s $f0, $f1
		mov.s $f1, $f10
		li $s3, 0
		b rest2
	least2:
		mov.s $f10, $f0
		mov.s $f0, $f2
		mov.s $f2, $f10
		li $s3, 0
		b rest2
	greatest1:
		mov.s $f10, $f2
		mov.s $f2, $f0
		mov.s $f0 $f10
		li $s3, 0
		b rest2
	greatest2:
		mov.s $f10, $f2
		mov.s $f2, $f1
		mov.s $f1, $f10
		li $s3, 0
		b rest2
		
rest2:
beq $s3, $zero, beginsortloop5
mfc1 $t5, $f0
move $a0, $t5
li $v0, 34
syscall
		la $a0, 0x20
		li $v0, 11
		syscall
mfc1 $t0, $f1
move $a0, $t0
li $v0, 34
syscall
		la $a0, 0x20
		li $v0, 11
		syscall
mfc1 $t0, $f2
move $a0, $t0
li $v0, 34
syscall
la $a0, newLine
li $v0, 4
syscall
syscall


#Print the Description for the Sorted Decimal Values

la $a0, decimal
li $v0, 4
syscall
la $a0, newLine
li $v0, 4
syscall

li $v0, 2
mov.s $f12, $f0
syscall
	la $a0, 0x20
	li $v0, 11
	syscall
mov.s $f12, $f1
li $v0,2
syscall
	la $a0, 0x20
	li $v0, 11
	syscall
li $v0,2
mov.s $f12, $f2
syscall




li $v0, 10
syscall


.data
arguments: .asciiz "Program arguments: "
hex: .asciiz "Sorted values (IEEE 754 single precision floating point format): "
decimal: .asciiz "Sorted values (decimal): "
newLine: .asciiz "\n"
