baskara:
	fcvt.w.s t0, fa0	# t0 = (int)a
	bne t0,zero, QUADRATICA	# Se a funcao for quadratica
	
	fcvt.w.s t0, fa1	# t0 = (int)b
	bne t0, zero, RETAAFIM	# Se a funcao for uma reta
	ret			# Tratamento para caso de funcao constante
	
RETAAFIM:
	# Se a funcao for uma reta
	fneg.s fa2, fa2		# c = -c
	fdiv.s ft0, fa2, fa1	# fa0 = -c/b : Raiz da reta

	addi sp, sp, -4		# Prepara a pilha para receber uma raiz
	fsw ft0, 0(sp)		# Empilha a raiz unica na pilha

	li a0, 1		# a0 = 1 (Retorno inteiro da funcao para raizes reais)
	ret

QUADRATICA:
	# Calculo delta
	fmul.s fs0, fa1, fa1	# fs0 = b^2
	li t0, 4
	fcvt.s.w ft0, t0	# ft0 = 4
	fmul.s fs1, fa0, ft0	# fs1 = 4*a
	fmul.s fs1, fs1, fa2	# fs1 = 4*a*c
	fsub.s fs0, fs0, fs1	# fs0 = b^2 - 4*a*c = delta	
	fcvt.w.s t0, fs0	# t0 = (int)fs0 = (int) delta
	bge t0, zero, REAIS	# if (delta >= 0) -> Rotina Raizes Reais
	j COMPLEXAS		# else -> Rotina Raizes Complexas
	
REAIS: 				# delta >=0. Casos Raizes reais
	fsqrt.s fs0, fs0	# fs0 = sqrt(fa0) = sqrt(delta)
	li t0, 2		
	fcvt.s.w ft0, t0	# ft0 = 2
	fmul.s ft0, ft0, fa0	# ft0 = 2a
	fdiv.s fs0, fs0, ft0	# fs0 = sqrt(delta) / (2*a)
	fneg.s fa1, fa1		# fa1 = -b
	fdiv.s fa1, fa1, ft0	# fa1 = -b / (2*a)
	
	# Calculo e armazenamento das raizes reais
	addi sp, sp, -8		# Prepara a pilha para receber 2 words
	fadd.s ft0, fa1, fs0	# ft0 = raiz1 = -b / (2 * a) + sqrt(delta)/(2*a)
	fsw ft0, 4(sp)		# empilha raiz1
	fneg.s fs0, fs0		# fs0 = -sqrt(delta)/(2*a)
	fadd.s ft0, fa1, fs0	# ft0 = raiz2 = -b / (2 * a) - sqrt(delta)/(2*a)
	fsw ft0, 0(sp)		# empilha raiz2
	
	li a0, 1		# a0 = 1 (Retorno inteiro da funcao para raizes reais)
	ret

COMPLEXAS: 			# delta < 0:
	fabs.s fs0, fs0		# fs0 = abs(fs0) = abs(delta)
	fsqrt.s fs0, fs0	# fs0 = sqrt(fa0) = sqrt(delta)
	li t0, 2		
	fcvt.s.w ft0, t0	# ft0 = 2
	fmul.s ft0, ft0, fa0	# ft0 = 2a
	fdiv.s fs0, fs0, ft0	# fs0 = sqrt(delta) / (2*a)
	
	fneg.s fa1, fa1		# fa1 = -b
	fdiv.s fa1, fa1, ft0	# fa1 = -b / (2*a)
	
	# Calculo e armazenamento das raizes reais
	addi sp, sp, -16	# Prepara a pilha para receber 4 words
	fsw fa1, 12(sp)		# Empilha parte real da raiz1
	fsw fs0, 8(sp)		# Empilha parte imaginaria da raiz1
	fsw fa1, 4(sp)		# Empilha parte real da raiz2
	fneg.s fs0, fs0		# fs0 = -sqrt(delta)/(2*a)
	fsw fs0, 0(sp)		# empilha parte imaginaria da raiz2
	
	li a0, 2		# a0 = 2 (Retorno inteiro da funcao para raizes complexas)
	ret
