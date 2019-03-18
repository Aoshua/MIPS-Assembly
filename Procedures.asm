# Author: 	Joshua Abbott
# Date:		03/18/2019
# Desc:		Work with procedures. In MIPS "procedure" is a function. Procedures do not return values
#		where functions do return values. "jal" (jump address link) use to call procedures. "jr" 
#		(jump register) is used to return. 	


# Variables go here in the .data segment
.data
question:	.asciiz 	"Q: Why do programmers get Halloween and Christmas mixed up?"
answer:		.asciiz		"\n\nBecause Oct 31 == Dec 25!"
prompt:		.asciiz		"\nGive up? [y/n]: "
char:		.word		0

# "Main" program
.text
# Pseudocode:
# main() {
#	printQuestion()
#	witForGiveUp()
#	printAnswer()
# }

	jal printQuestion
	jal waitForGiveUp
	jal printAnswer

	
	# Exit Program
	li $v0, 10
	syscall

	
# Pseudocode:
# void printQuestion() {
#	print(question)
#	return
# }
printQuestion: 
	
	li $v0, 4		#print(question)
	la $a0, question
	syscall
	
	jr $ra			# Return the the previous jal call
	
# Pseudocode:
# void waitForGiveUp() {
#	print(prompt)
#	c = readChar()
#	while (c != 'y')
#	return
# }
# Registers: c => $v0
waitForGiveUp: 
	
Loop:	
	li $v0, 4		# print(prompt)
	la $a0, prompt
	syscall
	
	li $v0, 12		# c = readChar()
	syscall
	
	bne $v0, 'y', Loop	# (c != 'y') exit
	
	jr $ra			# Return the the previous jal call
	
# Pseudocode:
# void printAnswer() {
#	print(answer)
#	return
# }	
printAnswer: 
	
	li $v0, 4		#print(answer)
	la $a0, answer
	syscall
	
	jr $ra			# Return the the previous jal call
