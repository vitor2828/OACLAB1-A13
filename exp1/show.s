show:
# Configuracoes para impressao no Bitmap Display
	li a1, 0	# Define coluna
	li a2, 223	# Define linha
	li a3, 0x38	# Define cor de fundo e de frente
	li a4, 0	# Define frame

	li t0, 2
	beq a0, t0, showImag

#ShowReal
	la a0, r1	# Pega string "R(1) = "
	li a7, 104	# Printa "R(1) = "
	ecall

	flw fa0, 0(sp)	# Pega raiz2 na pilha
	li a7, 102	# Imprime raiz2
	ecall
	
	li a1, 0	# Redefine para coluna 0
	li a2, 231	# Redefine para linha 231
	
	la a0, r2	# Pega string "R(2) = "
	li a7, 104	# Printa "R(2) = "
	ecall
	
	flw fa0, 4(sp) # Pega raiz1 na pilha
	li a7, 102
	ecall
	
	addi sp, sp, 8	# Libera 2 words na pilha
	ret

showImag:	
	la a0, r1	# Pega string "R(1) = "
	li a7, 104	# Printa "R(1) = "
	ecall
	
	flw fa0, 12(sp) # Pega parte real da raiz1 na pilha
	li a7, 102	# Imprime parte real da raiz1 na pilha
	ecall

	flw fa0, 8(sp)	# Pega parte imaginaria da raiz1 na pilha
	li a7, 102	# Imprime parte imaginaria da raiz1 na pilha
	ecall
	
	la a0, i	# Pega string "i\n"
	li a7, 104	# Printa i
	ecall

	li a1, 0	# Redefine para coluna 0
	li a2, 231	# Redefine para linha 231
	
	la a0, r2	# Pega string "R(2) = "
	li a7, 104	# Printa "R(2) = "
	ecall
	
	flw fa0, 4(sp)	# Pega parte real da raiz2 na pilha
	li a7, 102	# Imprime parte real da raiz2 na pilha
	ecall

	flw fa0, 0(sp)	# Pega parte imaginaria da raiz2 na pilha
	li a7, 102	# Imprime parte imaginaria da raiz2 na pilha
	ecall
	
	la a0, i	# Pega string "i\n"
	li a7, 104	# Printa i
	ecall

	addi sp,sp,16	# Libera 4 words na pilha
	ret