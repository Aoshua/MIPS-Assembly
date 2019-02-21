# Author:	Joshua Abbott
# Date:		02-21-2019
# Desc:		This program explores how to allocate space in the stack, as well as how to use loops and multiplication calls. 

.data
intro: 		.asciiz "Joshua Abbott\nCS 2810 Spring 2019\nWelcome to the multiplication table printer!\n\n"
promptName: 	.asciiz "\nPlease enter your name: "
promptMult: 	.asciiz "\nPlease the max number of your desired multiplication table: "
greet:		.asciiz "\nHello, "
despido:	.asciiz "\nBye!"
newLine:	.asciiz "\n"
tab:		.asciiz "\t"

name:		.space 64
num:		.word 0


.text 
# Pseudocode:
# 	print(prompt)
# 	name = readString()
# 	num = readInt()
# 	print("hello" + name)
# 	// Print Multiplication tables 1 to num
# 	for(i=1; i<num; i++)
# 		for(j=1; j<num; j++)
# 			print(i*j)
# 		print("\n")
# 	print(bye)
#
# Register mappings:
# 	$t0 = counter1,		$t1 = counter 2
#	$s0 = user's num,	$t2 = working number


	# print(intro)
	li $v0, 4		# Syscall to print string
	la $a0, intro		# Load address of intro
	syscall
	
	# print(promptName)
	li $v0, 4	
	la $a0, promptName	# Load address of promptName
	syscall
	
	# name = readString()
	li $v0, 8		# Syscall to read string
	la $a0, name		# Store string in text
	li $a1, 64		# Size is 64 bits
	syscall
	
	# Print promptInt
	li, $v0, 4		# Syscall to print
	la, $a0, promptMult	# Load address of promptInt
	syscall
	
	# num = readInt()
	li, $v0, 5		# Syscall to read int
	syscall
	sw, $v0, num		# Store into num
	
	# print("hello" + name)
	li $v0, 4		# Syscall to print string
	la $a0, greet		# Load address of greet
	syscall
	li $v0, 4		# Syscall to print string
	la $a0, name		# Load address of name
	syscall
	
	li $t0, 1 		# t0 = 0 "counter 1"
	li $t1, 1 		# t1 = 0 "counter 2"
	lw $s0, num		# t2 = num 
	addi $s0, $s0, 1	# limit = num + 1
	li $t2, 1 		# number to print = 1


loop1:
	beq $t0, $s0, exit1	# if ( $t0 == $t2) { branch to exit1 }
loop2:
	beq $t1, $s0, exit2	# if ( $t1 == $t2) { branch to exit2 }
	mul $t2, $t0, $t1	# $t3 = $t0 * $t1
	
	# print(result)
	li $v0, 1		# Syscall to print int	
	move $a0, $t2		# load $t3 into $a0
	syscall
	
	# print(tab)
	li $v0, 4		# Syscall to print string
	la $a0, tab		# Load address of tab
	syscall
	
	addi $t1, $t1, 1	# t1++ 
	j loop2			# loop

exit2:
	li $t1, 1 		# reset $t1 = 1
	# print(newLine)
	li $v0, 4		# Syscall to print string
	la $a0, newLine		# Load address of newLine
	syscall
	
	addi $t0, $t0, 1	# t0++ 
	j loop1			# loop
exit1:
	# print(despido)
	li $v0, 4		# Syscall to print string
	la $a0, despido		# Load address of despido
	syscall
	
	li $v0, 10 # Exit code
	syscall
	
