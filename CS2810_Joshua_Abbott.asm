# Author:	Joshua Abbott
# Date:		02-11-2019
# Desc:		Simple loop to read/write string

.data
intro: .asciiz "Author: Joshua Abbott\nDate: The String/Integer Reader\nDesc: This program reads strings and integers from the user.\n"
stringPrompt: .asciiz "Enter your favorite quote: "
intPrompt: .asciiz "Enter your favorite quote: "
parrot: .asciiz "Parrot says: "

intext: .space 64 	# Asigns x bytes

.text 
# peseudocode
# while(true) {
# 	print(prompt)
# 	save input into intext
# 	print(parrot + intext)
# }

	li $v0, 4		# Print intro
	la $a0 intro		# Load address
	syscall
	
	li $t0, 0 		# counter
	li $t1, 3		# limit

loop:
	li $v0, 4		# Print prompt
	la $a0 prompt		# Load address
	syscall
	
	# Read user inpt
	li $v0, 8		# $v0 = readString()
	la $a0, intext		# where to store
	li $a1, 64		# how many
	syscall
	
	li $v0, 4		# Print parrot
	la $a0 parrot		# Load address
	syscall
	
	li $v0, 4		# Print intext
	la $a0 intext		# Load address
	syscall
	
	addi $t0, $t0, 1	# i++
	beq $t0, $t1, end	# if(t0 == t1) break
	j loop			# jump to end of loop
	
end:
	
	li $v0, 10 # Exit code
	syscall
	