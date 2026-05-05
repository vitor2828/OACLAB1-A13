.include "MACROSv24.s"

.data
a: .float 0.0
b: .float 10.0
c: .float 100.0
r1: .string "R(1) = "
r2: .string "R(2) = "
i: .ascii "i"
r: .string "R = "

.text
MAIN:
	la t0, a	# Pega endereco do coef. a
	flw fa0, 0(t0)	# fa0 = a
	
	la t0, b	# Pega endereco do coef. b
	flw fa1, 0(t0)	# fa1 = b
	
	la t0, c	# Pega endereco do coef. c
	flw fa2, 0(t0)	# fa2 = c
	
	jal ra,baskara	# Chama int baskara
	jal ra,show	# Chama void show

	li a7, 10
	ecall		# Devolve controle ao SO

.include "baskara.s"
.include "show.s"
.include "SYSTEMv24.s"
