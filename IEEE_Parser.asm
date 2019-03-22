# Author: 	Joshua Abbott
# Date:		03/22/2019
# Description:	Takes a user's floating point and prints the different elements IEEE format.

.data
	prompt: 	.ascii 	"Joshua Abbott\nCS2810 Spring2019\n"
			.ascii 	"Welcome to the IEEE Parser\n"
			.asciiz "Enter a decimal number:\n"
	showSign:	.asciiz "\nSign bit: "
	showExpoBiased:	.asciiz "\nExponent with bias: "
	showExpo:	.asciiz "\nExponent without bias: "
	showMantissa:	.asciiz "\nMantissa: "
	bye:    	.asciiz "\nDo you want to do it again?."
	
	ieee: 		.float 0  # input from user

	ieee1:		.word 0   # IEEE sign component
	ieee2:		.word 0   # IEEE exponent component (biased)
	ieee3:		.word 0	  # IEEE exponent component (no bias)
	ieee4:		.word 0   # IEEE fraction/mantissa component
.text
	
main:		 
	jal TakeUserInput  	# Take user input in DisplayBox
	
	lw $a0, ieee 		# set argument 1: ieee
	jal PrintSign

	lw $a0, ieee 		# set argument 1: ieee
	jal PrintExponent
	
	lw $a0, ieee 		# set argument 1: ieee
	jal PrintMantissa
	
	li   $v0, 50		# Again? (in Display box)
	la   $a0, bye
	syscall
	
	beqz $a0, main  	# check input to stay in loop

mainEnd: 	
	
	li   $v0, 10		# exit
	syscall

################################################################
# Procedure void TakeUserInput()
# Functional Description: Asks user to enter a float point value.
################################################################
# Register Usage:
TakeUserInput:

	li   $v0, 52		# print(prompt) in Display box
	la   $a0, prompt
	syscall
	
	li $v0, 6
	s.s $f0, ieee		# ieee = readFloat()
	
	#li $v0, 2		# print(ieee)
	#la $a0, ieee
	#syscall
	
TakeUserInputRet:
	jr $ra
################################################################
# Procedure void PrintSign(float ieee)
# Functional Description: Print the MSG for the sign.
#		Sign 1 bit long: bit 31
################################################################
# Register Usage:
#		$a0: ieee value in 32-bit register
#		$t0: working value of ieee
#		$t1: MSB followed by zeros
#		$t2: the MSB of ieee in LSB position 
PrintSign:

	lw $t0, ieee			# $t0 = ieee
	andi $t1, $t0, 0x80000000	# Isolate the first bit
	srl $t2, $t1, 31		# Shift right 31 positions
	
	sw $t2, ieee1			# ieee1 = sign componenet
	
	li $v0, 4			# print(showSign)
	la $a0, showSign
	syscall
	
	li $v0, 34			# Print sign comp in hex
	la $a0, ($t2)
	syscall
	
PrintSignRet:	
	jr $ra
################################################################
# Procedure void PrintExponent(float ieee)
# Functional Description: Extract and print the exponenent component 
# 			  of ieee.
#    	8 bits long: bits 30-23
################################################################
# Register Usage:
#		$a0: ieee value in 32-bit register
#		$t0: working value of ieee
#		$t1: numbers in 30-23
#		$t2: numbers 30-23 shifted right 23 => biased exponent => unbiased exponent

PrintExponent:
	# Isolate exponent bits23-30
	# 0111 1111 1000 0000 0000 0000 0000 0000
	# 0xC1FE0000
	# and
	# 0x7F800000

	lw $t0, ieee			# $t0 = ieee
	andi $t1, $t0, 0x7F800000	# Isolate 30-23
	srl $t2, $t1, 23		# Shift right 23 positions
	
	sw $t2, ieee2			# ieee2 = exponent (biased)
	
	li $v0, 4			# print(showExpoBiased)
	la $a0, showExpoBiased
	syscall
	
	li $v0, 34			# Print sign comp in hex
	la $a0, ($t2)
	syscall
	
	subi $t2, $t2, 127
	sw $t2, ieee3			# ieee3 = exponent (no bias)
	
	li $v0, 4			# print(showExpo)
	la $a0, showExpo
	syscall
	
	li $v0, 34			# Print sign comp in hex
	la $a0, ($t2)
	syscall

PrintExponentRet:	
	jr $ra
################################################################
# Procedure void PrintMantissa(float ieee)
# Functional Description: Extract and print the mantissa component 
# 			  of ieee.
#	23 bits long: bits 22-0
################################################################
# Register Usage:
#		$a0: ieee value 
#		$t0: working value of ieee
#		$t1: bits 22-0 of ieee
PrintMantissa:

	lw $t0, ieee			# $t0 = ieee
	andi $t1, $t0, 0x7FFFFF		# Isolate 30-23
	
	sw $t1, ieee4			# ieee4 = mantissa
	
	li $v0, 4			# print(showMantissa)
	la $a0, showMantissa
	syscall
	
	li $v0, 34			# Print sign comp in hex
	la $a0, ($t1)
	syscall
	
PrintMantissaRet:	
	jr $ra

