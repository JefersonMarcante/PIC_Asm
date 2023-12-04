;******************************* Programa modelo *******************************
;******* AP_EX2.ASM                                                     ********
;******* Acender o número 2 no display de 7 segmentos                   ********
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

	BSF SEL_DISP1		;Coloca pino PE0 em nivel alto
	
;***************************** Programa principal ******************************
 
LOOP					;Bloco do principal do programa      
	
	;       HGFEDCBA
	MOVLW b'01011011'	;Carrega o numero 2
	MOVWF DISP1			;Escreve valor no DISP1 (PORTD)

	CALL PERDE_TEMPO	;Rotina de delay
	GOTO LOOP			;Volta ao loop principal


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