.data
message: .asciiz "Ingrese monedas: "
test: .asciiz "You are in main"
title: .asciiz "____Bienvenido____\n"
zeroFloat: .float 0.0
oneFloat: .float 1.0
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
	

input:
	lwc1 $f4,zeroFloat
	#Display message
	li $v0,4
	la $a0,message
	syscall
	#Read user input
	li $v0,6 #6 is the code for read float
	syscall
	#Display value
	#li $v0,2 # 2 is the code to display a float
	add.s $f12,$f0,$f4
	
	jr $ra
exit: 
	li $v0,10
	syscall