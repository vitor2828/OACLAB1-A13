.include "MACROSv24.s"

.data

## A escala eh o tamanho dos semieixos x e y
ESCALA_XM: .float 1.0
ESCALA_YM: .float 1.0
ESPACO: .string " "


A: .float 1
B: .float 1
C: .float 1

## plot -> procedimento para desenhar o grafico no bitmap display

# fa0 - a
# fa1 - b
# fa2 - c

.text

# primeiro passo: limpar a tela e desenhar os eixos

			la t0, A
			flw fa0, 0(t0)
			
			la t0, B
			flw fa1, 0(t0)
			
			la t0, C
			flw fa2, 0(t0)
			
			
			li a0, 255
			li a1, 0
			li a7, 148
			ecall
			
			li a0, 160
			li a1, 220
			li a2, 160
			li a3, 20
			li a4, 0
			li a5, 0
			li a7, 147
			ecall
			
			li a0, 20
			li a1, 120
			li a2, 300
			li a3, 120
			li a4, 0
			li a5, 0
			li a7, 147
			ecall

# segundo passo: definir a escala (o intervalo real que cada pixel representa)
# usa-se a distância do ponto médio a origem para isso

### CALCULAR PONTO MEDIO ###

# Xm = -b/2a
# ft0 = Xm

			fdiv.s ft0, fa1, fa0
			li t0, 2
			fcvt.s.w ft1, t0
			fdiv.s ft0, ft0, ft1
			li t0, -1
			fcvt.s.w ft1, t0
			fmul.s ft0, ft0, ft1

# Ym = -(b² - 4ac)/4a
# ft1 = Ym

			fmul.s ft1, fa1, fa1
			li t0, 4
			fcvt.s.w ft2, t0
			fmul.s ft2, ft2, fa0
			fmul.s ft2, ft2, fa2
			li t0, -1
			fcvt.s.w ft3, t0
			fmul.s ft2, ft2, ft3
			fadd.s ft1, ft1, ft2
			fmul.s ft1, ft1, ft3
			li t0, 4
			fcvt.s.w ft2, t0
			fmul.s ft2, ft2, fa0
			fdiv.s ft1, ft1, ft2

### CRIAR ESCALA A DEPENDER DO PONTO MEDIO ###

			li t0, 0
			fcvt.s.w ft2, t0
			feq.s t0, ft0, ft2
			bne t0, zero, EXIT_ESCALA_XM # exceçao: caso Xm for 0, usar escala padrao

			fadd.s ft0, ft0, ft0 # dobro do ponto medio
					
			li t0, 0
			fcvt.s.w ft2, t0
			flt.s t0, ft0, ft2
			beq t0, zero, SEM_XM_NEGATIVO # tratamento para escalas negativas
			
## OBS: depois pesquisar se existem instrucoes unsigned para reduzir esse codigo
			
			li t1, -2
			fcvt.s.w ft2, t1
			fmul.s ft2, ft2, ft0
			fadd.s ft0, ft0, ft2
			
SEM_XM_NEGATIVO: 
			
			la t0, ESCALA_XM # salvar a escala no .data
			fsw ft0, 0(t0)

EXIT_ESCALA_XM:		
## Em seguida, todos os passos serao os mesmos, mas para o eixo y

			li t0, 0
			fcvt.s.w ft2, t0
			feq.s t0, ft1, ft2
			bne t0, zero, EXIT_ESCALA_YM

			fadd.s ft1, ft1, ft1
			
			li t0, 0
			fcvt.s.w ft2, t0
			flt.s t0, ft1, ft2
			beq t0, zero, SEM_YM_NEGATIVO
			
			li t1, -2
			fcvt.s.w ft2, t1
			fmul.s ft2, ft2, ft1
			fadd.s ft1, ft1, ft2
			
SEM_YM_NEGATIVO:
			
			la t0, ESCALA_YM
			fsw ft1, 0(t0)
			
			
EXIT_ESCALA_YM:		
			la t0, A
			flw fa1, 0(t0)
			
			la t0, B
			flw fa2, 0(t0)
			
			la t0, C
			flw fa3, 0(t0)

			li s0, 300 # contador do loop, quando chegar a 0 para
			li s1, 20
			
			li t1, 140
			fcvt.s.w ft0, t1
			la t1, ESCALA_YM
			flw ft4, 0(t1)
			fmv.s ft2, ft4
			fdiv.s ft5, ft4, ft0 # divide a escala pela constante para obter o valor real
						
# ft2 armazena a escala				
# ft4 eh o valor inicial
# ft5 eh o valor que deve ser subtraido de ft4 a cada loop

GRAFICO_LOOP:		fmv.s fa0, ft4
			jal FX
			
			li a7, 2
			#ecall
			
			mv a0, s0
			
			addi s0, s0, -1
			fsub.s ft4, ft4, ft5
						
			fsub.s fa0, ft2, fa0
			li t1, 100
			fcvt.s.w ft3, t1
			fmul.s fa0, fa0, ft3
			fdiv.s fa0, fa0, ft2
			fcvt.w.s a1, fa0
			addi a1, a1, 20
			
			fmv.s fa0, ft4
			jal FX
			mv a2, s0
									
			addi s0, s0, -1
			fsub.s ft4, ft4, ft5
			
			fsub.s fa0, ft2, fa0
			li t1, 100
			fcvt.s.w ft3, t1
			fmul.s fa0, fa0, ft3
			fdiv.s fa0, fa0, ft2
			fcvt.w.s a3, fa0
			addi a3, a3, 20
				
			li t1, 20
			blt a1, t1, GRAFICO_LOOP
			blt a3, t1, GRAFICO_LOOP
			
			li t1, 220
			bgt a1, t1, GRAFICO_LOOP
			bgt a3, t1, GRAFICO_LOOP
				
			li a4, 0
			li a5, 0
			li a7, 147
			ecall

			addi s0, s0, 1
			fadd.s ft4, ft4, ft5
			
			bge s0, s1, GRAFICO_LOOP
			
			li a7, 10
			ecall
			

.include "fx.s"
.include "SYSTEMv24.s"

