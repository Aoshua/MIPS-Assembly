# Author: 	Joshua Abbott
# Date:		04/10/2019
# Desc:		Convert an array of FAT16 Root Area date field
#		Date field is on: 0x18 and is 2 bytes long
#
# 		Rules: Little Endian Convertion
#			Year: 1980 + Left 7 bits(9-15)
#			Month: Middle 4 bits (5-8)
#			Day: Right 5 bits (0-4)

	.data
	greeting:	.asciiz		"Joshua Abbott\n"
	prompt:		.asciiz		"\n\nNow Processing:\n"
	dateBE:		.word 0
	
	# array of pointers (addresses) to the messages
	date_hdr:	.word 0xB22C, 0x2733, 0x4C3F
	#
	date: 		.asciiz	"\nDate: "
			
	one:	.asciiz "January "
	two:	.asciiz "February "
	three:	.asciiz "March "
	four:	.asciiz "April "
	five:	.asciiz "May "
	six:	.asciiz "June "
	seven:	.asciiz "July "
	eight:	.asciiz "August "
	nine:	.asciiz "September "
	ten:	.asciiz "October "
	eleven:	.asciiz "November "
	twelve:	.asciiz "December "
	month_types: 	.word one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve
	
	st1: .asciiz "st, "
	nd2: .asciiz "nd, "
	rd3: .asciiz "rd, "
	th:  .asciiz "th, "
	day_types: .word st1, nd2,rd3,th,th,th,th,th,th,th
			 th,th,th,th,th,th,th,th,th,th,
			 st1,nd2,rd3,th,th,th,th,th,th,th,th
###########################################################	
	.text
.globl main	
	.text
main:

	li $v0, 4		# print(greeting)
	la $a0, greeting	
	syscall
	
	li $t0, 0		# Array index pointer
	li $t1, 3		# Set initial counter
loop:
	la $a0, prompt		# Print item processing
	li $v0, 4
	syscall
	
	lw $a0, date_hdr($t0)   # Print hex
	li $v0 34
	syscall
	
	li $v0, 4
	la $a0, date		# Print new line
	syscall
	
	lw $a0, date_hdr($t0)  	# Get hex value
	jal LEConv		# Convert to Little Endian
	sw $t2, dateBE		# Save B.E. version
	
	lw $a0, dateBE  	# Load B.E. value
	jal GetMonth		# Get Year
	
	lw $a0, dateBE  	# Load B.E. value
	jal GetDay		# Get Day	
	
	lw $a0, dateBE  	# Load B.E. value
	jal GetYear		# Get Year

	addi $t1, $t1, -1	# Update counter
	addi $t0, $t0, 4	# Move index 
	bgtz $t1, loop	
end:
	
exit:				# Exit code 
	li $v0,10		# code==0, so exit program
	syscall

################################################################
# Procedure LEConv(&array)
# Functional Description: Convert 32-bit hex from LittleEndian
#	to Big Endian
################################################################
# Register Usage:
#		$a0 index value for value to process
#		$$t2, $t3 temp value to process
#		$t2 return value
################################################################
# Algorithmic Description:
# a0 = &array 
#	Issolate then rotate the order of bytes 
################################################################
LEConv:

	andi $t2, $a0, 0x00FF	 	# AND 0000 0000 1111 1111
	andi $t3, $a0, 0xFF00		# AND 1111 1111 0000 0000
	
	sll $t2, $t2, 8			# Shift left 8
	srl $t3, $t3, 8			# Shift right 8
	
	add $t2, $t2, $t3		# $t2 = $t2 + $t3
	
LEConvRet:
	jr $ra

################################################################
# Procedure GetYear(&array)
# Functional Description: Display year value
################################################################
# Register Usage:
#		$a0 index value for value to process
#		$$t2, $t3 temp value to process
GetYear:

	andi $t2, $a0, 0xFE00	# AND 1111 1110 0000 0000
	srl $t3, $t2, 9 	# Shift right 9 to isolate year bits
	
	addi $t3, $t3, 1980	# $t3 += 1980 (year that time began) 
	
	li $v0, 1		# print($t3)
	la $a0, ($t3)
	syscall
	
GetYearRet:
	jr $ra
	
################################################################
# Procedure GetMonth(&array)
# Functional Description: Display month value
################################################################
# Register Usage:
#		$a0 index value for value to process
#		$$t2, $t3, $t4 temp value to process
GetMonth:
	
	andi $t2, $a0, 0x1E0	# AND 0000 0001 1110 0000
	srl $t3, $t2, 5 	# Shift right 5 to isolate month bits
	
	subi $t3, $t3, 1		# Adjust for index
	mul $t3, $t3, 4 	 	# To align with addresses
	lw $t4, month_types($t3)	# $t4 = month_types[$t3]
	
	li $v0, 4			# print(month_tpyes[$t3])
	la $a0, ($t4)
	syscall
	
GetMonthRet:
	jr $ra
	
################################################################
# Procedure GetDay(&array)
# Functional Description: Display month value
################################################################
# Register Usage:
#		$a0 index value for value to process
#		$t0, $t1, $t2, $t3 temp value to process
#		$v0 return value
# Save stage of $t0, and $t1
GetDay:
	
	andi $t2, $a0, 0x1F	# AND 0000 0000 0001 1111
	
	li $v0, 1		# print($t2)
	la $a0, ($t2)
	syscall
	
	mul $t2, $t2, 4 	# To align with addresses
	lw $t3, day_types($t2)	# $t3 = day_types[$t2]
	
	li $v0, 4		# print(day_types[$t2])
	la $a0, ($t3)
	syscall
	
GetDayRet:
	jr $ra
