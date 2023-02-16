.data
  novaLinha:   .asciiz "\n"
  total:     .asciiz "Soma: "
  media:     .asciiz "Media: "
  mediana:   .asciiz "Mediana: "
  moda:      .asciiz "Moda: "
  array:     .word 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 
	 
  length:    .word 26

  soma:      .word 0
  average:   .word 0
    
.text
.globl main
main:

#loop através do array para calcular soma

  la $t0 array   #endereço inicial do array
  li $t1 0       #loop index, i=0
  lw $t2 length  #tamanho
  li $t3 0       #iniciar sum =0

somaLoop:
  lw $t4 ($t0)      #get array[i]
  add $t3 $t3 $t4   #sum = sum+array[i]

  addi $t1 $t1 1    #i = i+1
  add $t0 $t0 4     #atualização do endereço do array

  blt $t1 $t2 somaLoop

  sw $t3 soma       #salvar suma

#print soma

  li $v0,4
  la $a0, total
  syscall

  move $a0 $t3
  li $v0 1
  syscall

#cálculo da média

  div $t5 $t3 $t2
  sw $t5 average

#espaço de linha
  li $v0,4
  la $a0, novaLinha
  syscall

#print para declarar média
  li $v0,4
  la $a0, media
  syscall

  move $a0 $t5
  li $v0 1
  syscall

#cálculo mediana

  la $t0, array 
  lw $t1, length 
  li $t3 4
  div $t2, $t1, 2     #tamanho / 2
  mul $t3, $t3, $t2   #index*4
  add $t4, $t0, $t3   #pegar endereço do array[15]
  lw $t5, ($t4)       #pegar valor do array[15]
  sub $t4, $t4, 4     #pegar endereço do array[14]
  lw $t6, ($t4)       #pegar valor do array[14]
  add $t7, $t6, $t5   #array[14] + array[15]
  div $t8, $t7, 2     #mediana

#espaço de linha

  li $v0,4
  la $a0, novaLinha
  syscall

#print mediana

  li $v0,4
  la $a0, mediana
  syscall

  move $a0 $t8
  li $v0 1
  syscall



#calculo moda

  la $t0 array #endereço inicial do Array
  li $t1 0     #loop index, i=0
  lw $t2 length  #length
  li $t4, 1 #previous
  li $t6, 1 #intial
  li $t7, 0 #individualCount
  li $t8, 0 #modeValue
  li $t9, 0 #modeCount

ModaLoop:
  lw $t5 ($t0)   #get array[i]

#quando um novo valor é encontrado array
bne $t4 ,$t5 , atualizaSePrecisa

back:
addi $t7 $t7 1 #contagemIndividual++
addi $t1 $t1 1 #i = i+1
add $t0 $t0 4 #atualiza endereço array
li $t4 ,0
addi $t4 , $t5, 0

blt $t1 $t2 ModaLoop

#espaço de linha
  li $v0,4
  la $a0, novaLinha
  syscall

#Imprime moda
li $v0,4
la $a0, moda
syscall

move $a0 $t8
li $v0 1
syscall

li $v0 10
syscall

atualizaSePrecisa:
#se a contagem for maior que a contagem da moda anterior
bgt $t7, $t9, mudaModa
next:
li $t6 ,0
addi $t6 , $t5, 0
#reinicializa contagem individual
li $t7, 0
j back

mudaModa:
#muda valor da moda
li $t8 ,0
addi $t8 , $t4, 0
#muda contagem moda
li $t9 ,0
addi $t9 , $t7, 0
j next
