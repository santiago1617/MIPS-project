.data
message: .asciiz "Ingrese monedas: "
#messageError: .asciiz "Mensaje de error"
test: .asciiz "You are in main\n"
title: .asciiz "____Bienvenido____\n"
complete: .asciiz "WE DID IT!!!!\n"
error: .asciiz "Entrada incorrecta, vuelva a intentarlo.\n"
back: .asciiz "WE ARE BACK OF THE VALIDATION\n"
out: .asciiz "FINISHING THE ENTRY OF THE INPUT.......\n"
saldo: .asciiz "Saldo: $"
enter: .asciiz "\n"
number: .asciiz "Ingrese numero a llamar:"

zeroFloat: .float 0.0
fiveCents: .float 0.05
tenCents: .float 0.10
quarterDollar: .float 0.25
halfDollar: .float 0.5
oneDollar: .float 1.0
close: .float -1.0

.text
.globl main

main:
	#Display message
	li $v0,4
	la $a0,title
	syscall
	
	li $t0,2
	lwc1 $f10,zeroFloat #Acumulador del monto
	while: 
		#Go to the "input" function or label
		jal input 
		#Validate the value of $v1 if it is -1
		beq $v1,$t0,call
		#Validate if the value of $v1 is valid
		beq $v1,$zero,while
		#Sumar el dinero ingresado por el input al monto
		add.s $f10,$f10,$f12
		j while
		
		
	
	call:
		#Print the actualk balance
		li $v0,4
		la $a0,saldo
		syscall
	
		li $v0,2 # 2 is the code to display a float in $f12
		lwc1 $f4,zeroFloat
		add.s $f12,$f10,$f4
		syscall
	
		li $v0,4
		la $a0,enter
		syscall
		
		#Phone number input
		li $v0,4
		la $a0,number
		syscall
		
		li $v0,5
		syscall
		
		li $v0,4
		la $a0,enter
		syscall
	
	#Display value
	#li $v0,2 # 2 is the code to display a float in $f12
	#add.s $f12,$f0,$f4
	#syscall
	j exit
	

input: #The float number always will be in $f12 which we gonna print
	
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
	
	#Restart the $f4 value to 0.0
	lwc1 $f4,zeroFloat # lwcl -> li ponerle un valor predefinido
	#Move $f12-> $f0 + $f4
	add.s $f12,$f0,$f4
	
	#Restart the pointer $sp
	lw $ra,0($sp)
	addi $sp,$sp,4
	#Then we return
	jr $ra
	
	
validation: 
	#Have in mind that the input of the user is in $f0
	lwc1 $f1,fiveCents
	lwc1 $f2,tenCents
	lwc1 $f3,quarterDollar
	lwc1 $f4,halfDollar
	lwc1 $f5,oneDollar
	lwc1 $f6,close
	
	#It is only a print for DEBUGGING
	#li $v0,4
	#la $a0,back
	#syscall
	
	#Save the PC on the stack
	addi $sp,$sp,-4
	sw $ra,0($sp)
	
	#Compare if the input by the user is the equal to -1 to end the input
	c.eq.s $f0, $f6    # $f0 == $f6? # somthing like beq
	bc1t end_input          # if true, branch to the label called "end_input"
	
	#When input != ($f6 or -1)
	
	#Compare if the input by the user is the equal to fiveCent
	c.eq.s $f0, $f1    # $f0 == $f1?
	bc1t return          # if true, branch to the label called "return"
	#It is the case that the input is not == to 0.005 (fiveCent) or $f1
		#Comparation with 0.10 (tenCents)
		c.eq.s $f0, $f2    # $f0 == $f2?
		bc1t return          # if true, branch to the label called "return"
		#When input != $f2
			#Comparation with 0.25(quarterDollar)
			c.eq.s $f0, $f3    # $f0 == $f3?
			bc1t return          # if true, branch to the label called "return"
			#When input != $f3
				#Comparation with 0.50 (halfDolar)
				c.eq.s $f0, $f4    # $f0 == $f4?
				bc1t return          # if true, branch to the label called "return"
				#When input!= $f4
					#Comparation with 1.00 (oneDollar)
					c.eq.s $f0, $f5    # $f0 == $f5?
					bc1t return          # if true, branch to the label called "return"
					#When input!= $f5
					
						li $v0,4
						la $a0,error
						syscall
						#Change the value of $v1=0 which means a invalid entry
						li $v1,0
	
	#Restart the pointer $sp
	lw $ra,0($sp)
	addi $sp,$sp,4
	#Return 
	jr $ra
	
return:
	#It is only a print for DEBUGGING
	#li $v0,4
	#la $a0,complete
	#syscall
	#Change the value of $v1=0 which means a valid entry
	li $v1,1
	
	#Return
	jr $ra

end_input:
	#It is only a print for DEBUGGING
	#li $v0,4
	#la $a0,out
	#syscall
	#change the value of $v1=2 which means end the entry of the input
	li $v1,2
	#Return
	jr $ra
	
exit: 
	li $v0,10
	syscall
