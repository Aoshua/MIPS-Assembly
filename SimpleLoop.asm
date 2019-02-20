# Author:	Joshua Abbott
# Date:		02-11-2019
# Desc:		Simple loop to write the user's string n times.

.data	# For variables

intro:		.asciiz "Author: Joshua Abbott\nDate: The String/Integer Reader\nDesc: Simple loop to write the user's string n times.\n\n"
promptString:	.asciiz "Please enter your favorite quote: "
promptInt:	.asciiz "Please enter the number of times you wish to print the phrase (or 0 to quit): "
farewell:	.asciiz "\nFarewell!"
newLine:	.asciiz "\n"

text:		.space 64
int:		.word 0


.text	# Like "main" 

# peseudocode:
#	Print intro
#	Prompt for string
#	Prompt for integer
#	Set up counter
#	Loop:
#		Print string
#		Increment counter
#		Branch on = 0
#	Exit program
	
	# Print intro
	li, $v0, 4		# Syscall to print string
	la, $a0, intro		# Load address of intro
	syscall
	
	# Print promptString
	li, $v0, 4		# Syscall to print string
	la, $a0, promptString	# Load address of promptString
	syscall
	
	# Read user string input
	li $v0, 8		# Syscall to read string
	la $a0, text		# Store string in text
	li $a1, 64		# Size is 64 bits
	syscall
	
	# Print promptInt
	li, $v0, 4		# Syscall to print
	la, $a0, promptInt	# Load address of promptInt
	syscall
	
	# Read user int input
	li, $v0, 5		# Syscall to read int
	syscall
	sw, $v0, int		# Store into int
	
	# Print promptString
	li, $v0, 4		# Syscall to print
	la, $a0, newLine	# Load address of newLine
	syscall
	
	# User defined counter
	li $t0, 0 		# counter $t0 = 0
	lw $s0, int		# limit $s0 = int
	syscall

loop:
	beq $t0, $s0, end	# if(t0 == t1) jump to end
	li $v0, 4		# Print text
	la $a0 text		# Load address
	syscall

	subi $s0, $s0, 1	# i--
	j loop			# jump to loop
	
end:
	
	# Print farewell
	li, $v0, 4		# Syscall to print string
	la, $a0, farewell	# Load address of farewell
	syscall
	
	# Exit program
	li $v0, 10 
	syscall
