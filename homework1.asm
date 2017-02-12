# HOMEWORK 1
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
		# Print String
	.macro printstring(%x)
		li $v0, 4		
		la $a0, %x
		syscall
	.end_macro
		# Print Value
	.macro printvalue(%x)
		li	$v0, 1
		move	$a0, $t0
		syscall
	.end_macro
		# Print Binary
	.macro printbinary(%x)
		move	$a0, %x
		li	$v0, 35
		syscall
	.end_macro
		# Print Hex
	.macro printhex(%x)
		move $a0, %x
		li   $v0, 34
		syscall
	.end_macro
		# Exit Program
	.macro exit
		li $v0,10
		syscall
	.end_macro

.globl main

main: 
	#################### TWO's COMPLIMENT ############################
	printstring(inputMsg)		# Print msg1
	li $v0, 5			# Get input from user 
	syscall	
	move $s0, $v0			# Save it in register $s0
	move $t0,$s0			# Move value from $s0 to $t0
	printstring(twosComp)		# Print two's comp label
	tab	
	printvalue($t0)			# Print integer value of input	
	tab
	printhex($t0)			# Print Hex value
	tab
	printbinary($t0)		# Print Binary value
	tab
	printvalue($t0)			# Print Value
	newline
	#################### ONE'S COMPLIMENT #############################
	
	move $t0,$s0			# Start with original value
	printstring(onesComp)		# Print one's comp label
	tab
	printvalue($t0)			# Print Value
	tab
	bgtz $t0, next			# Branch to next if $t0 is positive
	addiu $t0,$t0, -1		# Otherwise add -1
next:
	printhex($t0)			# Print Hex value
	tab
	printbinary($t0)		# Print Binary value 
	tab
	printvalue($t0)			# Print Value
	newline
	############## NEGATIVE ONE'S COMPLIMENT ##########################
	move $t0,$s0			# Start with original value
	printstring(negOnesComp)	# Print label
	tab
	bgtz $t0, greater		# Branch to greater if positive
	not $t0,$t0			# Flip the bits
	addi $t0,$t0,1			# Add 1
	j next1				# Jump to next1
greater:  not $t0,$t0			# Flip the bits
next1:	li $v0,100			# Print decimal value syscall 100
	la $a0,($t0)
	syscall
	tab
	printhex($t0)			# Print Hex
	tab
	printbinary($t0)		# Print Binary
	tab
	li $v0,100			# Print decimal value syscall 100
	la $a0,($t0)
	syscall
	newline
	################# NEGATIVE SIGNED MAGNITUDE #####################
	move $t0, $s0			# Start with original value
	printstring(negSignedMag)	# Print label
	tab
	bgtz $t0, greater2		# Branch to greater2 if positive
	not $t0,$t0			# Flip the bits
	addi $t0,$t0,1			# Add 1
	j next2				# Jump to next
greater2: ori $t0, $t0, 0x80000000	# Turn on the sign bit
next2:  li $v0,101			# Print value using syscall 101
	la $a0,($t0)
	syscall
	tab
	printhex($t0)			# Print Hex value
	tab
	printbinary($t0)		# Print Binary value
	tab
	li $v0,101			# Print value using syscall 101
	la $a0,($t0)
	syscall
	newline
	################ IEEE-752 SINGLE PRECISION ####################
	move $t0,$s0			
	printstring(singlePre)
	tab
	sll $t0,$t0,1
	srl $t0,$t0,24
	printvalue($t0)
	tab
	addi $t1,$t0,-127
	li $v0, 1
	move $a0, $t1
	syscall
	tab
	beq $t0,255,inf
	beq $t0,$zero,zero
	j done
inf:	la $t0,($s0)
	sll $t0,$t0,9
	bne $t0,$zero,notanum
	bgtz $s0,posinf
	printstring(negInf)
	j done
posinf: la $t0,($s0)
	sll $t0,$t0,9
	bne $t0,$zero,done
	printstring(posInf)
	j done
zero:   bgtz $s0,poszer
	la $t0,($s0)
	sll $t0,$t0,9
	bne $t0,$zero,done
	la $t0,($s0)
	srl $t0,$t0,31
	beq $t0,$zero,poszer
	printstring(negZero)
	j done
poszer: la $t0,($s0)
	sll $t0,$t0,9
	bne $t0,$zero,done
	printstring(posZero)
	j done
notanum: printstring(nan)
done:	tab 
	newline
	##################################################
	move $t0,$s0
	printstring(doublePre)
	tab
	sll $t0,$t0,1
	srl $t0,$t0,21
	printvalue($t0)
	tab
	addi $t0,$t0, -1023
	printvalue($t0)
	tab
	newline
	#################################################
	newline
	printstring(inputMsg2)
	li $v0, 12		
	syscall	
	move $s0, $v0
	newline
	printstring(inputMsg2)
	li $v0, 12		
	syscall	
	move $s1, $v0
	newline
	printstring(inputMsg2)
	li $v0, 12		
	syscall	
	move $s2, $v0
	newline
	printstring(inputMsg2)
	li $v0, 12		
	syscall	
	move $s3, $v0
	newline
	move $t2,$s0
	newline
	move $t3,$s1
	sll $t3,$t3,8
	add $t2,$t2,$t3
	move $t4,$s2
	sll $t4,$t4,16
	add $t2,$t2,$t4
	move $t5,$s3
	sll $t5,$t5,24
	add $t2,$t2,$t5
	########################################################
	printstring(twosComp)
	tab	
	li $v0,36
	move $a0, $t2
	syscall
	tab
	printhex($t2)
	tab
	printbinary($t2)	
	tab
	li $v0,36
	move $a0, $t2
	syscall
	newline
	###########################################################
	printstring(onesComp)
	tab
	li $v0,36
	move $a0, $t2
	syscall
	tab
	bgtz $t2, next3
	addiu $t2,$t2, -1
next3:  printhex($t2)
	tab
	printbinary($t2)
	tab
	li $v0,36
	move $a0, $t2
	syscall
	newline
	####################################################
	printstring(negOnesComp)
	tab
	bgtz $t2, greater3
	not $t2,$t0
	addi $t2,$t2,1
	j next4
greater3: not $t2,$t2
next4:  li $v0,100
	la $a0,($t2)
	syscall
	tab
	printhex($t2)
	tab
	printbinary($t2)
	tab
	li $v0,100
	la $a0,($t2)
	syscall
	newline
	###################################################
	not $t2,$t2
	printstring(negSignedMag)	# Print label
	tab
	bgtz $t2, greater4		# Branch to greater2 if positive
	not $t2,$t2			# Flip the bits
	addi $t2,$t2,1			# Add 1
	j next5				# Jump to next
greater4:
	ori $t2, $t2, 0x80000000	# Turn on the sign bit
next5:
	li $v0,101			# Print value using syscall 101
	la $a0,($t2)
	syscall
	tab
	printhex($t2)			# Print Hex value
	tab
	printbinary($t2)		# Print Binary value
	tab
	li $v0,101			# Print value using syscall 101
	la $a0,($t2)
	syscall
	newline
	
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

