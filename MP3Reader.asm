# Author: Joshua Abbott
# Date:	  03/30/2019
# Desc:   The program processes information from an array and decodes MP3 information from the header
#	  file based on an MP3 map. 
 
.data
	intro:		.asciiz		"Joshua Abbott\n"
	prompt:		.asciiz		"\nNow Processing:\n"
	
	mpeg_0:		.asciiz		"\nMPEG Version 2.5\n"
	mpeg_1:		.asciiz		"\nMPEG Version Reserved\n"
	mpeg_2:		.asciiz		"\nMPEG Version 2.0\n"
	mpeg_3:		.asciiz		"\nMPEG Version 1.0\n"
	
	layer_0:	.asciiz		"Reserved\n"
	layer_1:	.asciiz		"Layer III\n"
	layer_2:	.asciiz		"Layer II\n"
	layer_3:	.asciiz		"Layer I\n"
	
	mpeg:		.word 0
	
	# Array indexes       0           4           8          12
	mp3_hdr:	.word 0xFFE33364, 0xFFF6C123, 0xFFFD3C40  		# array of pointers (addresses) to the messages
	mpeg_types: 	.word mpeg_0,     mpeg_1,     mpeg_2, 	mpeg_3
	layers:		.word layer_0,    layer_1,    layer_2, 	layer_3
	sample_0:	.word 44100,      22050,      11025 
	sample_1:	.word 48000,      24000,      12000 
	sample_2:	.word 32000,      16000,      8000 
	
	# Table of labels for sampling:
        sr_types:  	.word sp_mpeg25, sp_re, sp_mepg20, sp_mpeg10
	# Tables with sampling values
       	sr_mp1_00: 	.asciiz "44100 Hz\n"
        sr_mp1_01: 	.asciiz "48000 Hz\n"
        sr_mp1_10: 	.asciiz "32000 Hz\n"
        sr_mp1_11: 	.asciiz "Reserved\n"
        sr_mp1_types: 	.word sr_mp1_00, sr_mp1_01, sr_mp1_10, sr_mp1_11

        sr_mp2_00: 	.asciiz "22050 Hz\n"
        sr_mp2_01: 	.asciiz "24000 Hz\n"
        sr_mp2_10: 	.asciiz "16000 Hz\n"
        sr_mp2_11: 	.asciiz "Reserved\n"
        sr_mp2_types: 	.word sr_mp2_00, sr_mp2_01, sr_mp2_10, sr_mp2_11

        sr_mp25_00: 	.asciiz "11025 Hz\n"
        sr_mp25_01:	.asciiz "12000 Hz\n"
        sr_mp25_10:	.asciiz "8000 Hz\n"
        sr_mp25_11: 	.asciiz "Reserved\n"
        sr_mp25_types:	.word sr_mp25_00, sr_mp25_01, sr_mp25_10, sr_mp25_11
	
###########################################################	

	.text
.globl main	
	.text
main:
	jal PrintInfo

	li $t1, 0		# Set initial counter
loop:

	li $v0, 4		# print(prompt)
	la $a0, prompt
	syscall
	
	jal GetMPEG		# Call void GetMPEG
	
	jal GetLayer		# Call void GetLayer
	
	jal GetSampling		# Call void GetSampling
		
	addi $t1, $t1, 1	# Update counter

	ble $t1, 2, loop	# branch to loop if(t1 <= 2)
	
exit:				# Exit code 
	li $v0, 10		
	syscall

################################################################
# Procedure void PrintInfo()
# Functional Description: Prints Student information
################################################################
PrintInfo:
	
	li $v0 4	# print(intro)
	la $a0, intro
	syscall
	
PrintInfoRet:
	jr $ra		# Return
	
################################################################
# Procedure void GetMPEG(&array)
# Functional Description: Displays the MPEG version (Field B)
# Register mapping:
#	$t1 = loop counter 	  $t2 = adjusted counter 1
#	$t3 = mp3_hdr[i]	  $t4 = adjusted counter 2
#	$s0 = 2-bit version num   $t5 = mpeg_types[j]	 
################################################################
GetMPEG:

	# Pseudocode:
	#
	# Change hex header to bits	
	#      Imagine: 1111 1111 1111 1011 1001 0010 0110 0100
	# Compare with: AAAA AAAA AAAB BCCD EEEE FFGH IIJJ KLMM
	# 	AND:    0000 0000 0001 1000 0000 0000 0000 0000 (isolates B field)
	# Shift bits to the right 19 positions:
	# 	$t0 =  0000 0000 0000 0000 0000 0000 0000 0011
	#
	# mul $t1, $t0, 4 #t0 * 4 will help with array 
	# lw $a0, mpeg_types($t1)
	#
	# Could also be done with branches
	# if(t0 == 11) {is V1.0}
	# else if ((t0 == 10) {is V2.0}
	# else if ((t0 == 00) {V2.5}
	# else # 01 {Reserved}
	
	mul $t2, $t1, 4			# Adjust counter address to match word size (4)
	lw $t3, mp3_hdr($t2)		# $t3 = mp3_hdr[i]
	
	li $v0, 34			# print in hex
	la $a0, ($t3)
	syscall
	
	andi $t3, $t3, 0x180000	 	# AND 0000 0000 0001 1000 0000 0000 0000 0000
	srl $s0, $t3, 19		# s0 = t3 shifted right 19
	
	mul $t4, $s0, 4			# Adjust counter address to match word size (4)
	lw $t5, mpeg_types($t4)		# t5 = mpeg_types(j)
	
	li $v0, 4			# print(mpeg_types[$t4])
	la $a0, ($t5)
	syscall
	
GetMPEGRet:
	jr $ra				# Return
	
################################################################
# Procedure GetLayer(&array)
# Functional Description: Displays the layer version (Field C)
# Register mapping:
#	$t1 = loop counter 	  $t2 = adjusted counter 1
#	$t3 = mp3_hdr[i]	  $t4 = adjusted counter 2
#	$s1 = 2-bit layer num     $t5 = layers[j]	 
################################################################
GetLayer:

	# Pseudocode:
	# Very similar to the previous method. The only 
	# differences are to AND 0x60000 and to SRL 17

	mul $t2, $t1, 4			# Adjust counter address to match word size (4)
	lw $t3, mp3_hdr($t2)		# $t3 = mp3_hdr[i]
	
	andi $t3, $t3, 0x60000	 	# AND 0000 0000 0000 0110 0000 0000 0000 0000
	srl $s1, $t3, 17		# s1 = t3 shifted right 17
	
	mul $t4, $s1, 4			# Adjust counter address to match word size (4)
	lw $t5, layers($t4)		# t5 = layers(j)
	
	li $v0, 4			# print(layers[$t4])
	la $a0, ($t5)
	syscall	
	
GetLayerRet:
	jr $ra				# Return
	
################################################################
# Procedure GetSampling(&array)
# Functional Description: Displays the sampling rate (Field F).
#			  uses the MPEG version found int the
#			  GetMPEG procedure, which was stored
#			  in $s0
# Register mapping:
#	$t1 = loop counter 	  $t2 = adjusted counter 1
#	$t3 = mp3_hdr[i]	  $t4 = adjusted counter 2
#	$t5 = mpNumType[j]	  $s2 = rampling rate index
#	$s0 = MPEG version index
################################################################
GetSampling:

	# Pseudocode:
	# Very similar to the first method only AND 0x600,
	# SRL 10, and use a switch with a table of values
	# to print the sampling rate frequency.
	
	mul $t2, $t1, 4			# Adjust counter address to match word size (4)
	lw $t3, mp3_hdr($t2)		# $t3 = mp3_hdr[i]
	
	andi $t3, $t3, 0x600	 	# AND 0000 0000 0000 0110 0000 0000 0000 0000
	srl $s2, $t3, 10		# s2 = t3 shifted right 10
	
	mul $t4, $s0, 4			# Adjust counter for version num
    	
    	beq $s0, 0, sp_mpeg25		# if(s0 == V2.5)
	beq $s0, 1, sp_re		# if(s0 == Reserved)
	beq $s0, 2, sp_mepg20		# if(s0 == V2.0)
	beq $s0, 3, sp_mpeg10		# if(s0 == V1.0)
	
	# Similar to a switch:
	sp_mpeg25: 
		lw $t5, sr_mp25_types($t4)	# t5 = sr_mp25_types[t4]
		
		li $v0, 4			# print(sr_mp25_types[$t4])
		la $a0, ($t5)
		syscall
		
		j GetSampRet			# Break
	sp_re:	
		li $v0, 4			# print(layer_0)
		la $a0, layer_0
		syscall
		
		j GetSampRet			# Break
	sp_mepg20:
		lw $t5, sr_mp2_types($t4)	# t5 = sr_mp2_types[t4]
		
		li $v0, 4			# print(sr_mp2_types[$t4])
		la $a0, ($t5)
		syscall
		
		j GetSampRet			# Break
	sp_mpeg10:
		lw $t5, sr_mp1_types($t4)	# t5 = sr_mp1_types[t4]
		
		li $v0, 4			# print(sr_mp1_types[$t4])
		la $a0, ($t5)
		syscall
		
		j GetSampRet			# Break
	
GetSampRet:
	jr $ra					# Return
