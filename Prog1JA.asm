#####################################################################
# Program #1:	Joshua Abbott
# Due Date: 	01/27/2018
# Desc: 	A simple MIPS program to practice the basics
######################################################################

.data			# Data declaration section

# String Variables:
intro: .asciiz "  ****  Buenos dias amigo! Como anda? **** \n Title: Program 1 \n Author: Joshua Abbott \n Description: A simple MIPS program to practice the basics. \n"
bye:	.asciiz	"\n\n  ****  Adios Amigo! Que le vaya bien!  **** \n"
prompNum1: .asciiz "\n Please enter a whole number: \n"
prompNum2: .asciiz " Please enter another whole number: \n"
prompSum: .asciiz "\n The sum is: "
prompDiff: .asciiz "\n The difference is: "
prompProduct: .asciiz "\n The product is: "
endLine: .asciiz "\n"

# Integer Variables:
number1: .word 0
number2: .word 0
sumOfNums: .word 0
diffOfNums: .word 0
productOfNums: .word 0


.text			# Executable code follows
	
	# Print introduction:
	li $v0, 4 		# Print a string
	la $a0, intro 		# Load address of intro
	syscall
	
	# Ask for first number:
	li $v0, 4 		# Print a string
	la $a0, prompNum1 	# Load address of prompNum1
	syscall
	
	# Catch first number:
	li $v0, 5 		# Read an integer
	syscall
	sw $v0, number1 	# Store integer from $v0 in number1
	
	# Ask for second number:
	li $v0, 4 		# Print a string
	la $a0, prompNum2 	# Load address of prompNum2
	syscall
	
	# Catch second number:
	li $v0, 5 		# Read an integer
	syscall
	sw $v0, number2 	# Store integer from $v0 in number2
	
	# Load numbers:
	lw $t0, number1		# $t0 gets number1
	lw $t1, number2		# $t1 gets number2
	
	# Add numbers:
	add $t3, $t0, $t1	# $t3 = $t0 + $t1
	sw $t3, sumOfNums	# Store sum in memory
	lw $t3, sumOfNums	# Load the value from memory
	
	# Subract numbers:
	sub $t3, $t0, $t1	# $t3 = $t0 - $t1
	sw $t3, diffOfNums	# Store difference in memory
	lw $t3, diffOfNums	# Load the value from memory
	
	# Multiply numbers:
	mult $t0, $t1		# $t0 * $t1
	mflo $v0		# Catches the LSB 
	sw $v0, productOfNums	# Store product in memory
	lw $v0, productOfNums	# Load the value from memory
	
	# Print the sum:
	li $v0, 4		# Print string
	la $a0 prompSum		# Load address
	syscall
	
	li $v0, 1		# Print integer
	lw $a0, sumOfNums	# Load sumOfNums
	syscall
	
	# Print the difference:
	li $v0, 4		# Print string
	la $a0 prompDiff	# Load address
	syscall
	
	li $v0, 1		# Print integer
	lw $a0, diffOfNums	# Load diffOfNums
	syscall

	
	# Print the product:
	li $v0, 4		# Print string
	la $a0 prompProduct	# Load address
	syscall
	
	li $v0, 1		# Print integer
	lw $a0, productOfNums	# Load productOfNums
	syscall	
	
	# Begin to exit
	li $v0, 4 		# Print a string
	la $a0, bye 		# Load address of bye
	syscall

	li $v0, 10		# Terminate program run and
	syscall			# Return control to system

	# END OF PROGRAM
