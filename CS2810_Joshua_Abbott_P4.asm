# Author: 	Joshua Abbott
# Date:		03/18/2019
# Description:	Takes a user's floating point and prints the different elements IEEE format.

.data
	prompt: 	.ascii "Joshua Abbott\nCS2810 Spring2019\n"
			.ascii "Welcome to the IEEE Parser\n"
			.asciiz "Enter a decimal number:\n"
	bye:    	.asciiz "\nDo you want to do it again?."
	ieee: 		.float 0  # input from user
    # You may want to use these values
	ieee1:		.word 0   # IEEE sign component
	ieee2:		.word 0   # IEEE exponent component
	ieee3:		.word 0   # IEEE fraction/mantissa component
.text
	
main:		 
	jal TakeUserInput  # Take user input in DisplayBox
	
	lw $a0, ieee 		# set argument 1: ieee
	#jal PrintSign

	lw $a0, ieee 		# set argument 1: ieee
	#jal PrintExponent
	
	lw $a0, ieee 		# set argument 1: ieee
	#jal PrintMantissa
	
	# Extra Credit
	#jal PrintIEEE
	
	li   $v0, 50		# Again? (in Display box)
	la   $a0, bye
	syscall
	
	beqz $a0, main  	# check input to stay in loop

mainEnd: 	
	
	li   $v0, 10		# exit
	syscall

################################################################
# Procedure void TakeUserInput()
# Functional Description: 
################################################################
# Register Usage:
TakeUserInput:

	li   $v0, 52		# print(prompt) in Display box
	la   $a0, prompt
	syscall
	s.s $f0, ieee		# ieee = readFloat()
	
	
	li $v0, 2		# print(float)
	l.s $f12, ieee
	syscall
	
	

TakeUserInputRet:
	jr $ra
################################################################
# Procedure void PrintSign(float ieee)
# Functional Description: Print the MSG for the sign
#		Sign 1 bit long: bit 31
################################################################
# Register Usage:
#		$a0: ieee value in 32-bit register
PrintSign:

PrintSignRet:	
	jr $ra
################################################################
# Procedure void PrintExponent(float ieee)
# Functional Description: Extract the exponenent component
#    	8 bits long: bits 30-23
################################################################
# Register Usage:
#		$a0: ieee value in 32-bit register

PrintExponent:

PrintExponentRet:	
	jr $ra
################################################################
# Procedure void PrintMantissa(float ieee)
# Functional Description: 
#	23 bits long: bits 22-0
################################################################
# Register Usage:
#		$a0: ieee value 
#	
PrintMantissa:
	
PrintMantissaRet:	
	jr $ra
################################################################
# Procedure void PrintIEEE(void) Extra Credit
# Functional Description: 
#	Sign 1 bit long: bit 31
#	Exponent 8 bits long: bits 30-23
#	Mantissa 23 bits long: bits 22-0
################################################################
PrintIEEE:
	
PrintIEEERet:
	jr $ra
