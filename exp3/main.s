.include "MACROSv24.s"

.data
r1: .string "R(1) = "
r2: .string "R(2) = "
i: .ascii "i"
r: .string "R = "

pergunta_coeficiente_A: .string "Digite o coeficiente A: "
pergunta_coeficiente_B: .string "Digite o coeficiente B: "
pergunta_coeficiente_C: .string "Digite o coeficiente C: "

.text
MAIN:

	la a0, pergunta_coeficiente_A # carrega o texto do coeficiente A
	li a7, 4 # ecall para escrita de string
	ecall
		
	li a7, 6 # ecall para leitura de float
	ecall
	addi sp, sp, -12 # reserva 3 words na pilha para armazenar os coeficientes entre os procedimentos
	fsw fa0, 0(sp) # armazena o A
	
	la a0, pergunta_coeficiente_B # carrega o texto do coeficiente B
	li a7, 4
	ecall
	
	li a7, 6
	ecall
	fsw fa0, 4(sp) # armazena o B
	
	la a0, pergunta_coeficiente_C
	li a7, 4
	ecall
	
	li a7, 6
	ecall
	fsw fa0, 8(sp) # armazena o C
	
	flw fa0, 0(sp) 
	flw fa1, 4(sp)
	flw fa2, 8(sp) # carrega os tres coeficientes para plotar o gráfico
	
	jal ra, plot
	
	flw fa0, 0(sp)
	flw fa1, 4(sp)
	flw fa2, 8(sp) # carrega os três coeficientes para imprimir as raizes reais
	 
	jal ra, baskara	# Chama int baskara
	jal ra, show
	
	addi sp, sp, 12 # restaura o stackpointer ao valor original

	j MAIN # volta o inicio para que o usuario insira outra funcao

.include "baskara.s"
.include "show.s"
.include "SYSTEMv24.s"
.include "plot.s"
