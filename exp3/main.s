.include "MACROSv24.s"

.data
a: .float 0
b: .float 0
c: .float 0
r1: .string "R(1) = "
r2: .string "R(2) = "
i: .ascii "i"
r: .string "R = "

pergunta_coeficiente_A: .string "Digite o coeficiente A: "
pergunta_coeficiente_B: .string "Digite o coeficiente B: "
pergunta_coeficiente_C: .string "Digite o coeficiente C: "

.text
MAIN:

	la a0, pergunta_coeficiente_A
	li a7, 4
	ecall
	
	li a7, 6
	ecall
	la t0, a
	fsw fa0, 0(t0)
	
	la a0, pergunta_coeficiente_B
	li a7, 4
	ecall
	
	li a7, 6
	ecall
	la t0, b
	fsw fa0, 0(t0)
	
	
	la a0, pergunta_coeficiente_C
	li a7, 4
	ecall
	
	li a7, 6
	ecall
	la t0, c
	fsw fa0, 0(t0)
	
	la t0, a
	flw fa0 0(t0)
	la t0, b
	flw fa1, 0(t0)
	la t0, c
	flw fa2, 0(t0)
	
	jal ra, plot
	
	la t0, a
	flw fa0, 0(t0)
	la t0, b
	flw fa1, 0(t0)
	la t0, c
	flw fa2, 0(t0)
	
	jal ra, baskara	# Chama int baskara
	jal ra, show

	j MAIN		# Devolve controle ao SO

.include "baskara.s"
.include "show.s"
.include "SYSTEMv24.s"
.include "plot.s"
