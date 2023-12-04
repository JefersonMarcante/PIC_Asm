;******************************* Programa modelo *******************************
;******* AP_EX3.ASM                                                     ********
;******* Contador de 0 a F no display de 7 segmentos                    ********
;********************************* Interrupção *********************************
; RU:3217002 - Jeferson Dariva Marcante
;*************************  Definições do processador **************************
	#include p16F877a.inc 
;inclui as definições do PIC 16F977A	
	
	__config _HS_OSC & _WDT_OFF & _LVP_OFF & _PWRTE_ON 
; Configuration Bits do PIC16F877A	
;_HS_OSC   - HS oscillator - High-Speed Crystal - 4MHz - 20MHz
;            seleção conforme o circuito oscilador utilizado
;_WDT_OFF  - Watchdog Timer Enable Bit - watchdog desligado,
;		     acorda ou reseta o PIC em determinados casos.
;_LVP_OFF  - Low-Voltage ICSP Enable Bit - LVP desligado, 
;            relacionado com as tensões de gravação do PIC
;_PWRTE_ON - Power-up Timer Enable Bit - PWRTE ligado,
;			 mantém oPIC em reset 72ms após energizado.
;**************************** Paginação da memória *****************************
#DEFINE SEL_DISP1	PORTE,0
#DEFINE DISP1		PORTD

;**************************** Memória de programa ******************************
	ORG     0 			;Posiciona o ponteiro para o endereço 0x0 de memória

RESET 					;Bloco de RESET do microcontrolador
	NOP             
	GOTO   SETUP 		;Pula para o marcador SETUP
;******************************** Interrupção **********************************
	ORG 4 				;Endereço do vetor de interrupção
	
;************************** Declaração de variáveis ****************************  
DELAY EQU 0x20 
VEZES EQU 0x21
CONTADOR EQU 0x22

;***************************** Inicio do programa ******************************

;******************************* Configurações *********************************

SETUP					;Bloco de configuração do microcontrolador
	BSF STATUS, RP0		;Seleciona banco de memoria 1

	;Configura portas (IOs)
	MOVLW b'00000000'	;Todas os pinos do PORTA como Saida
	MOVWF TRISA

	MOVLW b'00000000'	;Todas os pinos do PORTB como Saida
	MOVWF TRISB			

	MOVLW b'00000000'	;Todas os pinos do PORTC como Saida
	MOVWF TRISC

	MOVLW b'00000000'	;Todas os pinos do PORTD como Saida
	MOVWF TRISD

	BCF STATUS, RP0		;Retorna ao banco de memoria 0

	;Inicializa Ports
	CLRF PORTA			;Limpa PORTA
	CLRF PORTB			;Limpa PORTB
	CLRF PORTC			;Limpa PORTC
	CLRF PORTD			;Limpa PORTD

	CLRF CONTADOR		;Limpa variavel contador

	BSF SEL_DISP1		;Coloca pino PA5 em nivel alto
	
;***************************** Programa principal ******************************
 
LOOP					;Bloco do principal do programa  
	CALL ATUALIZA		;Carrega valor do display
	MOVWF DISP1			;Escreve valor no DISP1 (PORTD)
	INCF CONTADOR		;Incrementa o contador

	CALL PERDE_TEMPO	;Rotina de delay
	GOTO LOOP			;Volta ao loop principal

ATUALIZA
	MOVF CONTADOR,W		;Carrega valor do contador
	ANDLW b'00001111'	;Ignora nible alto do contador, conta até 15
	ADDWF PCL,F			;Faz o Program Counter pular o programa

	;DISP   HGFEDCBA
	RETLW b'00111111'	;Carrega o numero 0 do Display e retorna
	RETLW b'00000110'	;Carrega o numero 1 do Display e retorna
	RETLW b'01011011'	;Carrega o numero 2 do Display e retorna
	RETLW b'01001111'	;Carrega o numero 3 do Display e retorna
	RETLW b'01100110'	;Carrega o numero 4 do Display e retorna
	RETLW b'01101101'	;Carrega o numero 5 do Display e retorna
	RETLW b'01111101'	;Carrega o numero 6 do Display e retorna
	RETLW b'00000111'	;Carrega o numero 7 do Display e retorna
	RETLW b'01111111'	;Carrega o numero 8 do Display e retorna
	RETLW b'01101111'	;Carrega o numero 9 do Display e retorna
	RETLW b'01110111'	;Carrega o numero A do Display e retorna
	RETLW b'01111100'	;Carrega o numero B do Display e retorna
	RETLW b'00111001'	;Carrega o numero C do Display e retorna
	RETLW b'01011110'	;Carrega o numero D do Display e retorna
	RETLW b'01111001'	;Carrega o numero E do Display e retorna
	RETLW b'01110001'	;Carrega o numero F do Display e retorna
	
PERDE_TEMPO
	MOVLW d'1'
	MOVWF VEZES

LOOP_VEZES
	MOVLW d'1'
	MOVWF DELAY
	CALL DELAY_US
	DECFSZ VEZES,1
	GOTO LOOP_VEZES
	RETURN

DELAY_US
	NOP
	NOP
	DECFSZ DELAY,1
	GOTO DELAY_US
	RETURN
	
	END					;Indica a ultima linha de código do programa
