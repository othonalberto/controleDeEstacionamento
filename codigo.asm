list p = 16f877


org 0x00
	goto inicio

org 0x04
	btfsc 0x0b, 2	; verifica se a interrupcao ocorreu pelo TMR0
 	goto timer0
	
	interRB0:
		; bloco 1
		btfss 0x0b, 1
		goto interPORTB
		
		bcf 0x0b, 1
		
		; testa se ja e zero
		incf 0x20
		decf 0x20
		btfsc 0x03, 2
		goto ret

		; testa se aux ja e zero
		incf 0x32
		decf 0x32
		btfss 0x03, 2
		goto continua1
			
		jaEraZero1:
			movlw .10
			movwf 0x32
			
		continua1:
			decf 0x20	; decrementa controle inteiro
			decf 0x24	; decrementa unidade display
			decfsz 0x32
			goto ret
			
			decf 0x25	; decrementa dezena display
			movlw .9
			movwf 0x24

			movlw .10
			movlw 0x32	; reinicia variavel contadora auxiliar para 10

			goto ret

	interPORTB:
 		bcf 0x0b, 0
		
		bloco2:	; rb4
			btfss 0x06, 4
			goto bloco3

			; testa se ja e zero
			incf 0x21
			decf 0x21
			btfsc 0x03, 2
			goto ret

			; testa se aux ja e zero
			incf 0x33
			decf 0x33
			btfss 0x03, 2
			goto continua2
			goto jaEraZero2
			
			jaEraZero2:
				movlw .10
				movwf 0x33
			
			continua2:
				decf 0x21	; decrementa controle inteiro
				decf 0x26	; decrementa unidade display
			
				decfsz 0x33
				goto ret
			
				decf 0x27	; decrementa dezena display
				movlw .9
				movwf 0x26

				movlw .10
				movlw 0x33	; reinicia variavel contadora auxiliar para 10

			goto ret

		bloco3:	; rb5
			btfss 0x06, 5
			goto bloco4

			; testa se ja e zero 
			incf 0x22
			decf 0x22
			btfsc 0x03, 2
			goto ret

			; testa se aux ja e zero
			incf 0x34
			decf 0x34
			btfss 0x03, 2
			goto continua3
			goto jaEraZero3
			
			jaEraZero3:
				movlw .10
				movwf 0x34
			
			continua3:
				decf 0x22	; decrementa controle inteiro
				decf 0x28	; decrementa unidade display
				decfsz 0x34 
				goto ret
			
				decf 0x29	; decrementa dezena display
				movlw .9
				movwf 0x28

				movlw .10
				movlw 0x34	; reinicia variavel contadora auxiliar para 10

			goto ret

		bloco4:	; rb6
			btfss 0x06, 6
			goto ret

			; testa se ja e zero
			incf 0x23
			decf 0x23
			btfsc 0x03, 2
			goto ret

			; testa se aux ja e zero
			incf 0x35
			decf 0x35
			btfss 0x03, 2
			goto continua4
			
			jaEraZero4:
				movlw .10
				movwf 0x35
			
			continua4:
				decf 0x23	; decrementa controle inteiro
				decf 0x30	; decrementa unidade display
			
				decfsz 0x35
				goto ret
			
				decf 0x31	; decrementa dezena display
				movlw .9
				movwf 0x30

				movlw .10
				movlw 0x35	; reinicia variavel contadora auxiliar para 10

		ret: retfie

	
	timer0:	; atualizacao dos display
		bcf 0x0b, 2

		unidadeBloco1:
			bcf 0x07, 7	; desliga display anterior

			movfw 0x24
			movwf 0x05	; move valor da unidade para o PORTA
  			bsf 0x07, 0	; liga display

		dezenaBloco1:
			bcf 0x07, 0

			movfw 0x25
			movwf 0x05
			bsf 0x07, 1

		unidadeBloco2:
			bcf 0x07, 1

			movfw 0x26
			movwf 0x05
			bsf 0x07, 2

		dezenaBloco2:
			bcf 0x07, 2

			movfw 0x27
			movwf 0x05
			bsf 0x07, 3

		unidadeBloco3:
			bcf 0x07, 3

			movfw 0x28
			movwf 0x05
			bsf 0x07, 4

		dezenaBloco3:
			bcf 0x07, 4

			movfw 0x29
			movwf 0x05
			bsf 0x07, 5

		unidadeBloco4:
			bcf 0x07, 5

			movfw 0x30
			movwf 0x05
			bsf 0x07, 6

		dezenaBloco4:
			bcf 0x07, 6

			movfw 0x31
			movwf 0x05
			bsf 0x07, 7

		; reinicia o timer0
		movlw 0x00
		movwf 0x01
		goto ret

inicio:

	bcf 0x03, 6
	bsf 0x03, 5 ; banco 1

	; tris
	clrf 0x85	; tris a - valores dos display
	movlw 0xff	; 11111111
	movwf 0x86	; tris b - sensores
	clrf 0x87	; tris c - selecao dos bits
	movlw B'00001111'
	movwf 0x88	; tris d - botoes de saida dos carros
	clrf 0x89	; tris e - nada

	movlw 0x07
	movwf 0x9f	; desliga porta analogica no PORTA

	movlw B'11000110'
	movwf 0x81	; option reg
	
	bcf 0x03, 6
	bcf 0x03, 5 ; banco 0

	clrf 0x05	; port a - valores jogados 
	clrf 0x06	; port b - sensores
	clrf 0x07	; port c - selecao dos bits
	movlw 0x00
	movwf 0x08	; port d - botoes de saida
	clrf 0x09	; port e
	
	movlw 0xB8
	movwf 0x0B ; intcon
	
	; variaveis internas de qtd de vagas
	movlw .30
	movwf 0x20	; bloco 1
	movwf 0x21	; bloco 2
	movwf 0x22	; bloco 3
	movwf 0x23	; bloco 4
	
	movlw .0
	movwf 0x24	; unidadeB1
	movwf 0x26	; unidadeB2
	movwf 0x28	; unidadeB3
	movwf 0x30	; unidadeB4

	movlw .3
	movwf 0x25	; dezenaB1
	movwf 0x27	; dezenaB2
	movwf 0x29	; dezenaB3
	movwf 0x31	; dezenaB4

	; auxiliares para o decremento nos displays
	movlw .1
	movwf 0x32	
 	movwf 0x33
	movwf 0x34
	movwf 0x35

	movlw .10
	movwf 0x40	; aux para devolucao

	movlw 0x00
	movwf 0x01 ; tmr0
	
	loop:
		btfsc 0x08, 0	; verifica se foi apertado botao 1
		goto botao1
		btfsc 0x08, 1	; verifica se foi apertado botao 2	
		goto botao2
		btfsc 0x08, 2	; verifica se foi apertado botao 3
 		goto botao3
		btfsc 0x08, 3 	; verifica se foi apertado botao 4
		goto botao4	
		goto loop

	; logica similar a do decremento
	botao1:
		incf 0x20	; incrementa controle interno

		incf 0x32
		decf 0x32
		btfsc 0x03, 2
		goto testa

		incf 0x24	; incrementa unidade display
		
		movf 0x24, 0	; testa se foi pra 10
	    subwf 0x40, 0
		btfsc 0x03, 2
		goto testa

		incf 0x32	; se nao foi para 10, apenas decrementa variavel interna de contagem
		goto loop

		
		testa: incf 0x25	; incrementa dezena display
		       movlw .0
		       movwf 0x24

		       movlw .1
		       movwf 0x32

		       goto loop

			

	botao2:
		incf 0x21	; incrementa controle interno

		incf 0x33
		decf 0x33
		btfsc 0x03, 2
		goto testa2

		incf 0x26	; incrementa unidade display

		movf 0x26, 0	; testa se foi pra 10
		subwf 0x40, 0
		btfsc 0x03, 2
		goto testa2

		incf 0x33	; se nao foi para 10, apenas incrementa variavel interna de contagem
		goto loop

		testa2: incf 0x27	; incrementa dezena display
				movlw .0
		        movwf 0x26

		        movlw .1
		        movwf 0x33

		        goto loop

	botao3:
		incf 0x22	; incrementa controle interno

		incf 0x34
		decf 0x34
		btfsc 0x03, 2
		goto testa3

		incf 0x28	; incrementa unidade display

		movf 0x28, 0	; testa se foi pra 10
		subwf 0x40, 0
		btfsc 0x03, 2
		goto testa3

		incf 0x34	; se nao foi para 10, apenas incrementa variavel interna de contagem
		goto loop
		
		testa3: incf 0x29	; incrementa dezena display
				movlw .0
		        movwf 0x28

		       	movlw .1
		       	movwf 0x34

		       	goto loop

	botao4:
		incf 0x23	; incrementa controle interno

		incf 0x35
		decf 0x35
		btfsc 0x03, 2
		goto testa4

		incf 0x30	; incrementa unidade display

		movf 0x30, 0	; testa se foi pra 10
		subwf 0x40, 0
		btfsc 0x03, 2
		goto testa4

		incf 0x34	; se nao foi para 10, apenas incrementa variavel interna de contagem
		goto loop
		
		testa4: incf 0x31	; incrementa dezena display
				movlw .0
		        movwf 0x30

		        movlw .1
		        movwf 0x35

		        goto loop
end
