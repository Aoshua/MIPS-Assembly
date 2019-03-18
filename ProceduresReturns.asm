# Author: 	Joshua Abbott
# Date:		03/18/2019
# Desc:		Work with procedures with return values.


# Variables go here in the .data segment
.data


# "Main" program
.text
# Procedure use: Pseudocode
# c = sumOfSquares (x, y)
# print (c)

	li $a0, 3			# a0 = 3
	li $a1, 5			# a1 = 5
	
	jal sumOfSquares		# method call: sumOfSquares()
	move $t2, $v0			# c = sumOfSquares()
	# Note: Do NOT assume the values of $t0, $t1, are the same after the jal call.
	
	li $v0, 1			# print(c)
	move $a0, $t2
	syscall	
	
	
	# Exit Program
	li $v0, 10
	syscall
	
# Procedure def: Pseudocode
# int sumOfSquares (x, y) {
#	return x*x + y*y
# }
# Registers: x => $a0, y => $a1, result = $v0
sumOfSquares:
	
	mul $t0, $a0, $a0		# t0 = a0 * a0
	mul $t1, $a1, $a1		# t1 = a1 * a1
	add $v0, $t0, $t1		# v0 = t0 + t1
	
	jr $ra				# End of sumOfSquares
