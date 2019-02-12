# Name Joshua Abbott
# Date: 01/14/2019
# Desc: Print "Hello World!"

# Variables go here in .data segment
.data 

hello: .asciiz "Hello world!"

# "Main" program
.text 		# Your code goes here
	# Print a string
	li $v0, 4
	la $a0, hello
	syscall 

	#Use system calls to print exit, load, etc.
	li $v0, 10 	# Exit call
	syscall 