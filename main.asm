.data
message: .asciiz "Ingrese monedas: "
test: .asciiz "You are in main"
title: .asciiz "____Bienvenido____\n"
complete: .asciiz "WE DID IT!!!!\n"
error: .asciiz "ERRORRRR\n"
back: .asciiz "WE ARE BACK OF THE VALIDATION\n"
out: .asciiz "WE ARE OUTTTTT OF THE VALIDATION\n"
zeroFloat: .float 0.0

fiveCents: .float 0.05
tenCents: .float 0.1
quarterDolar: .float 0.25
halfDolar: .float 0.5
oneDolar: .float 1.0
.text
.globl main

main:
	#Display message
	li $v0,4
	la $a0,title
	syscall
	
	jal input
	
	li $v0,4
	la $a0,test
	syscall 
	
	li $v0,2
	#add.s $f12,$f0,$f4
	syscall
	j exit
	

input: #The float number always will be in $f12
	
	#Display message
	li $v0,4
	la $a0,message
	syscall
	
	#Read user input
	li $v0,6 #6 is the code for read float
	syscall
	#Save the PC on the stack
	addi $sp,$sp,-4
	sw $ra,0($sp)
	
	
	#Enter in validation
	
	jal validation
	
	#li $v0,4
	#la $a0,out
	#syscall
	
	lwc1 $f4,zeroFloat
	#Display value
	#li $v0,2 # 2 is the code to display a float
	add.s $f12,$f0,$f4
	
	#Restart the pointer $sp
	lw $ra,0($sp)
	addi $sp,$sp,4
	#Then come back
	jr $ra
	
	
validation: 
	lwc1 $f1,fiveCents
	lwc1 $f2,tenCents
	lwc1 $f3,quarterDolar
	lwc1 $f5,halfDolar
	lwc1 $f6,oneDolar
	
	#It is only a print for DEBUGGING
	li $v0,4
	la $a0,back
	syscall
	
	#Save the PC on the stack
	addi $sp,$sp,-4
	sw $ra,0($sp)
	
	#Compare if the input by the user is the equal to fiveCent
	c.eq.s $f0, $f1    # $f0 == $f1?
	bc1t return          # if true, branch to the label called "return"
	#It is the case that the input is not == to 0.005 (fiveCent)
	li $v0,4
	la $a0,error
	syscall
	
	#li $v0,0
	
	#Restart the pointer $sp
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	jr $ra
	
return:
	li $v0,4
	la $a0,complete
	syscall
	
	li $v0,1
	jr $ra
	
exit: 
	li $v0,10
	syscall
