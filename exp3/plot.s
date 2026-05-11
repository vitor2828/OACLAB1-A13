.include "MACROSv24.s"

.data

## A escala eh o tamanho dos semieixos x e y
ESCALA: .float 1.0
ESPACO: .string " "


A: .float 1
B: .float 1
C: .float 1

## plot -> procedimento para desenhar o grafico no bitmap display
## TODO: criar procedimento para converter valor real para valor em pixel
## TODO: deixar codigo mais elegante

# fa0 - a
# fa1 - b
# fa2 - c 

.text

# primeiro passo: limpar a tela e desenhar os eixos


			la t0, A
			flw fa0, 0(t0) # carrega o coeficiente A
						
			la t0, B
			flw fa1, 0(t0) # carrega o coeficiente B
			
			la t0, C
			flw fa2, 0(t0) # carrega o coeficiente C
			
# esses carregamentos sao provisorios, apenas para o funcionamento desse codigo independentemente
			
			li a0, 255
			li a1, 0
			li a7, 148
			ecall # pinta a tela toda de branco
			
			li a0, 160
			li a1, 220
			li a2, 160
			li a3, 20
			li a4, 0
			li a5, 0
			li a7, 147
			ecall # desenha o eixo y
			
			li a0, 20
			li a1, 120
			li a2, 300
			li a3, 120
			li a4, 0
			li a5, 0
			li a7, 147
			ecall # desenha o eixo x
			
			li t0, 0
			fcvt.s.w ft0, t0
			feq.s t0, fa0, ft0 # ve se o coeficiente A eh igual a zero. Caso for verdade, trata-se de uma funcao linear, que tem outro procedimento de desenho
			bnez t0, CASO_FUNCAO_LINEAR # chama o procedimento linear

# segundo passo: definir a escala (o intervalo real que cada pixel representa)
# usa-se a distância do ponto médio a origem para isso

### CALCULAR PONTO MEDIO ###

# Xm = -b/2a
# ft0 = Xm

# o codigo abaixo simplesmente calcula o Xm com a formula acima

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

# aqui, definimos a escala como o dobro do maior ponto medio multiplicado pelo coeficiente B. Usamos o ponto médio
# para garantir que a curva sera mostrada, elemento principal de uma funcao quadratica. Dessa forma, a escala sera o 
# maior ponto medio multiplicado pelo coeficiente B

			li t0, 0
			fcvt.s.w ft2, t0
			feq.s t0, ft0, ft2
			bne t0, zero, EXIT_ESCALA_XM # exceçao: caso Xm for 0, usar escala padrao

			fadd.s ft0, ft0, ft0 # dobro do ponto medio
			
			li t0, 0
			fcvt.s.w ft2, t0
			feq.s t1, fa1, ft2 # se B for zero, nao podemos multiplica-lo. Caso contrario, perderemos a escala
			bnez t1, B_IGUAL_0_X
			fmul.s ft0, fa1, ft0
			
			
B_IGUAL_0_X:		flt.s t0, ft0, ft2
			beqz t0, EXIT_ESCALA_XM # tratamento para escalas negativas. Os valores devem sempre ser positivos, visto que estamos
			# tratando de proporcao
			
			
			li t1, -1
			fcvt.s.w ft2, t1
			fmul.s ft0, ft0, ft2
			
EXIT_ESCALA_XM:		
## Em seguida, todos os passos serao os mesmos, mas para o eixo y

			li t0, 0
			fcvt.s.w ft2, t0
			feq.s t0, ft1, ft2
			bne t0, zero, INICIO_GRAFICO

			fadd.s ft1, ft1, ft1
				
			li t0, 0
			fcvt.s.w ft2, t0
			feq.s t1, fa1, ft2
			bnez t1, B_IGUAL_0_Y
			fmul.s ft1, ft1, fa1
			
B_IGUAL_0_Y:		flt.s t0, ft1, ft2	
			beqz t0, EXIT_ESCALA_YM
				
			li t1, -1
			fcvt.s.w ft2, t1
			fmul.s ft1, ft1, ft2
					
EXIT_ESCALA_YM:		la t0, ESCALA
			fge.s t1, ft0, ft1 # pegamos o maior valor entre X e Y para definir a escala. Optamos por uma unica proporcao entre os eixos, para garantir que sempre sera
			# quadrada
			bnez t1, X_MAIOR_Y
			j Y_MAIOR_X
			
X_MAIOR_Y:		fsw ft0, 0(t0) # salvando o valor de X caso seja maior
			j INICIO_GRAFICO
			
						
Y_MAIOR_X:		fsw ft1, 0(t0) # salvando o valor de Y caso seja maior


			
INICIO_GRAFICO:		la t0, A
			flw fa1, 0(t0) # carregando os valores de X para chamar o procedimento FX
			
			la t0, B
			flw fa2, 0(t0)
			
			la t0, C
			flw fa3, 0(t0)

			li s0, 300 # contador do loop. Fiz de 300 a 20 para ja usar como coordenadas do eixo x
			li s1, 20
			
			li t1, 140
			fcvt.s.w ft0, t1
			la t1, ESCALA
			flw ft4, 0(t1)
			
			fmv.s fa0, ft4
			li a7, 2
			ecall
			
			fmv.s ft2, ft4
			fdiv.s ft5, ft4, ft0 # divide a escala pela constante para obter o valor real
			
						
# ft2 armazena a escala				
# ft4 eh o valor inicial
# ft5 eh o valor que deve ser subtraido de ft4 a cada loop

# a cada iterecao teremos dois pontos, para que possamos construir a reta

GRAFICO_LOOP:		blt s0, s1, EXIT		
	
			fmv.s fa0, ft4 # em fa0 teremos o f(x) atual
			jal FX
			
			mv a0, s0
			
			addi s0, s0, -1 # atualiza o contador do loop
			fsub.s ft4, ft4, ft5 # atualiza o x real
			
### CONVERSAO DE VALOR REAL PARA VALOR EM PIXEL ###

# Vpixel = ((ESCALA - f(x) . 100) / ESCALA) + 20

# Usamos essa formula para garantir que o ponto estara dentro dos limites da memoria de video.
						
			fsub.s fa0, ft2, fa0
			li t1, 100
			fcvt.s.w ft3, t1
			fmul.s fa0, fa0, ft3
			fdiv.s fa0, fa0, ft2
			fcvt.w.s a1, fa0
			addi a1, a1, 20
			
# Calculo do segundo ponto
			
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
			
# As verificacoes a seguir garantem que o ponto estara abaixo do limite do eixo Y. Caso nao estejam, simplesmente o ignoramos e passamos para o proximo
				
			li t1, 20
			blt a1, t1, GRAFICO_LOOP
			blt a3, t1, GRAFICO_LOOP
			
			li t1, 220
			bgt a1, t1, GRAFICO_LOOP
			bgt a3, t1, GRAFICO_LOOP
				
			li a4, 0
			li a5, 0
			li a7, 147
			ecall # desenhamos a reta
			
			addi s0, s0, 1 # adicao para que o segundo ponto dessa iteracao seja o primeiro da proxima. Isso garante que as linhas sejam continuas.
			fadd.s ft4, ft4, ft5
			j GRAFICO_LOOP
			
CASO_FUNCAO_LINEAR:

## a escala serah o dobro do C, para garantirmos que o ponto em que a funcao corta o eixo y seja bem representado. Alem disso, a multiplicamos pelo coeficiente B, para funcoes lineares
## de crescimento excessivamente rapido
## feito em caso separado para maior eficiencia: o algoritmo geral para funcoes quadraticas eh excessivamente custoso para funcoes lineares e constantes

			li t0, 0
			fcvt.s.w ft0, t0
			
			la t0, C
			flw ft1, 0(t0)
			
			feq.s t0, ft0, ft1
			bnez t0, EXCECAO_C_ZERO # caso C for zero, temos que a funcao corta a origem. Portanto, a escala sera a padrao definida no .data
			
			fadd.s ft1, ft1, ft1
			flt.s t0, ft1, ft0
			beqz t0, SEM_C_NEGATIVO # tratamento caso o C seja negativo
			
			li t0, -1
			fcvt.s.w ft0, t0
			fmul.s ft1, ft1, ft0
			
SEM_C_NEGATIVO:		

			la t0, ESCALA
			fsw ft1, 0(t0) # atualizando o valor de ESCALA
			
EXCECAO_C_ZERO:

# aqui, o a0 e a2 serao os limites do eixo x, ou seja, 20 e 300
# o a1 e a3 serao o valor real no eixo y convertido para a escala em pixels

			li a0, 20
			li a1, 300
						
			la t0, A
			flw fa1, 0(t0)
			
			la t0, B
			flw fa2, 0(t0)
			
			la t0, C
			flw fa3, 0(t0)
			
			la t0, ESCALA
			flw fs2, 0(t0)
			fmv.s fs3, fs2
			li t1, 0
			fcvt.s.w ft2, t1
			feq.s t1, fa2, ft2
			bnez t1, FUNCAO_CONSTANTE # caso a funcao seja constante, nao multiplicamos pelo coeficiente angular, visto que zeraria a escala
			fmul.s fs2, fs2, fa2 
			
FUNCAO_CONSTANTE:
			
			li t1, -1
			fcvt.s.w ft3, t1 # transformando o limite positivo em negativo
			
			fmul.s fs1, fs3, ft3 # fs3 sera o limite positivo, fs1 o negativo, fs2 sera a escala pura
			
			fmv.s fa0, fs3
			jal FX
			
			fsub.s fa0, fs2, fa0 # a logica de conversao de valor real para pixel eh a mesma da funcao quadratica
			li t1, 100
			fcvt.s.w ft3, t1
			fmul.s fa0, fa0, ft3
			fdiv.s fa0, fa0, fs2
			fcvt.w.s a3, fa0
			addi a3, a3, 20
											
			fmv.s fa0, fs1
			jal FX
			
			fsub.s fa0, fs2, fa0
			li t1, 100
			fcvt.s.w ft3, t1
			fmul.s fa0, fa0, ft3
			fdiv.s fa0, fa0, fs2
			fcvt.w.s a1, fa0
			addi a1, a1, 20
			
			li a4, 0
			li a5, 0
			li a7, 147 
			ecall # desenhando a reta
		
EXIT:			li a7, 10
			ecall
			
.include "fx.s"
.include "SYSTEMv24.s"

