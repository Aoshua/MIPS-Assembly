# Author: 	Joshua Abbott
# Date:		02/13/2019
# Desc:		Create a switch statement

# Pseudocode:
# 	print (promt)
# 	n = readInt()
# 	switch(n) :
#		case 0:
#			print(n is zero)
#			break
#		case 4:
#			print(n is even)
#			break
#		case 1:
#		case 9:
#			print(n is square)
#			break
#		case 2:
#			print(n is even)
#			break
#		case 3:
#		case 5:
#		case 7:
#			print(n is even)
#			break
#		default:
#			print(out of range)


# Variables go here in the .data segment
.data
prompt:	.asciiz "Enter a one digit number: "
zero: 	.asciiz "n is zero.\n"
even: 	.asciiz "n is even.\n"
square: .asciiz "n is square.\n"
prime: 	.asciiz "n is prime.\n"
bad: 	.asciiz "n is out of range.\n"
# switch jump table
switch: .word case0, case1, case2, case3, case4
	.word case5, case6, case7, case8, case9


# "Main" program
.text
	
	li, $v0, 4		# Print string
	la $a0, prompt		# Load address of prompt
	syscall
	
	li, $v0, 5		# Read integer
	syscall
	move $t0, $v0 		# save value from $v0 to $t0
	
	li $v0, 4		# Setup for future print string calls
	
	blt $t0, 0, default	# Branch if(n < 0), jump to default
	bgt $t0, 9, default	# Branch if(n > 9), jump to default
	mul $t1, $t0, 4		# temp = n * 4 (word size)
	lw $t1, switch($t1)	# temp = switch[temp]
	jr $t1			# jump by temp
	
case0:
	la $a0, zero		# print(zero)
	syscall
	j end			# Break
case4:
	la $a0, even		# print(even)
	syscall
	j end			# Break
case1:
case9:
	la $a0, square
	syscall
	j end			# Break
case2:
	la $a0, even
	syscall
	j end			# Break
case3:
case5:
case7:
	la $a0, prime
	syscall
	j end			# Break
case6:
case8:
	la $a0, even
	syscall
	j end			# Break
default:
	la $a0, bad
	syscall

end:
	# Exit Program
	li $v0, 10
	syscall
