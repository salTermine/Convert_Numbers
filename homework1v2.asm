# HOMEWORK 1 VERSION 2
# SALVATORE TERMINE
# 109528463

.text
	# New line
	.macro newline
		li $v0, 4
		la $a0, nl
		syscall
	.end_macro
	# Tab
	.macro tab
		li $v0, 4
		la $a0, tb
		syscall
	.end_macro
	.macro shiftLeft(%x)
		sll $t0,%x,9		# Shift left 9 bits
	.end_macro
	# Print String
	.macro printstring(%x)
		li $v0, 4		
		la $a0, %x
		syscall
	.end_macro
	# Print Decimal Value
	.macro printDecvalue(%x)
		li $v0, 1
		move $a0,%x
		syscall
	.end_macro
	# Print Negative One's Compliment
	.macro printOnesComp(%x)
		li $v0,100
		move $a0,%x
		syscall
	.end_macro
	# Print Negative Signed Magnitude
	.macro printNegSigMag(%x)
		li $v0,101
		move $a0,%x
		syscall
	.end_macro
	# Print Binary
	.macro printbinary(%x)
		move $a0, %x
		li $v0, 35
		syscall
	.end_macro
	# Print Hex
	.macro printhex(%x)
		move $a0, %x
		li $v0, 34
		syscall
	.end_macro
	.macro twosComp(%x)
		move $t0,%x
		printstring(twosComp)		# Print two's comp label
		tab	
		printDecvalue(%x)		# Print integer value of input	
		tab
		printhex(%x)			# Print Hex value
		tab
		printbinary(%x)			# Print Binary value
		tab
		printDecvalue(%x)		# Print Value
		newline
	.end_macro
	.macro onesComp(%x)
		move $t0,%x			# Start with original value
		printstring(onesComp)		# Print one's comp label
		tab
		printDecvalue($t0)		# Print Value
		tab
		bgtz $t0, next			# Branch to next if $t0 is positive
		addiu $t0,$t0, -1		# Otherwise add -1
	next:   printhex($t0)			# Print Hex value
		tab
		printbinary($t0)		# Print Binary value 
		tab
		printDecvalue($t0)		# Print Value
		newline
	.end_macro

	.macro negOnesComp(%x)
		move $t0,%x			# Start with original value
		printstring(negOnesComp)	# Print label
		tab
		bgtz $t0, greater		# Branch to greater if positive
		not $t0,$t0			# Flip the bits
		addi $t0,$t0,1			# Add 1
		j next1				# Jump to next1
       greater: not $t0,$t0			# Flip the bits
	 next1:	printOnesComp($t0)		# Print decimal value syscall 100
		tab
		printhex($t0)			# Print Hex
		tab
		printbinary($t0)		# Print Binary
		tab
		printOnesComp($t0)		# Print decimal value syscall 100
		newline
	.end_macro
	.macro negSignMag(%x)
		move $t0, %x			# Start with original value
		printstring(negSignedMag)	# Print label
		tab
		bgtz $t0, greater2		# Branch to greater2 if positive
		not $t0,$t0			# Flip the bits
		addi $t0,$t0,1			# Add 1
		j next2				# Jump to next
      greater2: ori $t0, $t0, 0x80000000	# Turn on the sign bit
	 next2: printNegSigMag($t0)		# Print value using syscall 101
		tab
		printhex($t0)			# Print Hex value
		tab
		printbinary($t0)		# Print Binary value
		tab
		printNegSigMag($t0)		# Print value using syscall 101
		newline
	.end_macro
	# Exit
	.macro exit
		li $v0,10
		syscall
	.end_macro
	
.globl main

main:	#################### GET USER INPUT ###############################
	printstring(inputMsg)		# Print msg1
	li $v0, 5			# Get input from user 
	syscall	
	move $s0, $v0			# Save it in register $s0
	#################### TWO's COMPLIMENT #############################
	twosComp($s0)
	#################### ONE'S COMPLIMENT #############################
	onesComp($s0)
	############## NEGATIVE ONE'S COMPLIMENT ##########################
	negOnesComp($s0)
	################# NEGATIVE SIGNED MAGNITUDE #######################
	negSignMag($s0)
	################ IEEE-752 SINGLE PRECISION ########################
	newline
	move $t0,$s0			# Start with original value	
	printstring(singlePre)		
	tab
	sll $t0,$t0,1			# Shift left one bit
	srl $t0,$t0,24			# Shift right 24 bits
	printDecvalue($t0)		# Print exponent
	tab
	addi $t1,$t0,-127		# Subtract 127 excess
	printDecvalue($t1)		# Print original exponent
	tab
	beq $t0,255,inf			# Branch to infinity if = 255
	beq $t0,$zero,zero		# Branch to zero if = 0
	j done				# Jump to done
inf:	la $t0,($s0)			# Load original value
	sll $t0,$t0,9			# Shift left 9 bits
	bne $t0,$zero,notanum		# Branch to NaN if not equal to zero
	bgtz $s0,posinf			# Branch to +INF if positive
	printstring(negInf)		# Otherwise print -INF
	j done				# Skip to done
posinf: shiftLeft($s0)			# Shift left 9 bits	
	bne $t0,$zero,done		# Branch if not equall to zero
	printstring(posInf)		# Otherwise print +INF
	j done				# Jump to done
zero:   bgtz $s0,poszer			# Branch to +0 if greater then 0
	shiftLeft($s0)			# Shift Left 9 bits
	bne $t0,$zero,done		# Branch to done if not = to zero
	la $t0,($s0)			# Load original value
	srl $t0,$t0,31			# Shift right 31 bits
	beq $t0,$zero,poszer		# Branch to +0 if = to 0
	printstring(negZero)		# Otherwise print -0
	j done				# Jump to done
poszer: shiftLeft($s0)			# Shift left 9 bits
	bne $t0,$zero,done		# if not = to 0 then jump to done
	printstring(posZero)		# otherwise print +0
	j done				# Jumpt to done
notanum: printstring(nan)		# Print NAN
done:	tab 
	newline
	################ IEEE-752 DOUBLE PRECISION ########################
	move $t0,$s0			# Start with original value
	printstring(doublePre)
	tab
	sll $t0,$t0,1			# Shift left 1 bit
	srl $t0,$t0,21			# Shift right 21
	printDecvalue($t0)		# Print value
	tab		
	addi $t0,$t0, -1023		# Subtract excess
	printDecvalue($t0)		# Print value
	tab
	newline
	############## CHARACTER MANIPULATION #############################
	newline
	printstring(inputMsg2)		# Ask for user input
	li $v0,12		
	syscall	
	move $s0,$v0			# Store in $s0
	newline
	printstring(inputMsg2)		# Ask for user input
	li $v0,12		
	syscall	
	move $s1,$v0			# Store in $s1
	newline
	printstring(inputMsg2)		# Ask for user input
	li $v0,12		
	syscall	
	move $s2,$v0			# Store in $s2
	newline
	printstring(inputMsg2)		# Ask for user input
	li $v0,12		
	syscall	
	move $s3,$v0			# Store in $s3
	newline
	move $t2,$s0			# Move value from s0 to t2
	newline
	move $t3,$s1			# Move value from s1 to t3
	sll $t3,$t3,8			# Shift left 8 bits
	add $t2,$t2,$t3			# add t3 to t2
	move $t4,$s2			# Move value from s2 to t4
	sll $t4,$t4,16			# Shift left 16 bits
	add $t2,$t2,$t4			# Add t4 to t2
	move $t5,$s3			# Move s3 to t5
	sll $t5,$t5,24			# Shift left 24 bits
	add $t2,$t2,$t5			# Add t5 to t2
	#################### TWO's COMPLIMENT #############################
	twosComp($t2)
	#################### ONE'S COMPLIMENT #############################
	onesComp($t2)
	############## NEGATIVE ONE'S COMPLIMENT ##########################
	negOnesComp($t2)
	################# NEGATIVE SIGNED MAGNITUDE #######################
	negSignMag($t2)
	exit
.data
	inputMsg: .asciiz "Enter an integer number: "
	inputMsg2: .asciiz "Enter a character: "
	twosComp: .asciiz "2's compliment: "
	onesComp: .asciiz "1's compliment: "
	negOnesComp: .asciiz "Neg 1's compliment: "
	negSignedMag: .asciiz "Neg signed magnitude: "
	singlePre: .asciiz "IEEE-754 single precision: "
	doublePre: .asciiz "IEEE-754 double precision: "
	negInf:	.asciiz "-INF"
	posInf: .asciiz "+INF"
	posZero: .asciiz "+0"
	negZero: .asciiz "-0"
	nan: .asciiz "NaN"
	nl: .asciiz "\n"
	tb: .asciiz "\t"
