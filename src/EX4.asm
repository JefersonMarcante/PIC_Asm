;******************************* Programa modelo *******************************
;******* AP_EX4.ASM                                                     ********
;******* Lendo um botão e acendendo LEDs                                ********
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
#DEFINE SEL_LEDS	PORTA,5
#DEFINE BOTAO_S2	PORTB,0

;**************************** Memória de programa ******************************
	ORG     0 			;Posiciona o ponteiro para o endereço 0x0 de memória

RESET 					;Bloco de RESET do microcontrolador
	NOP             
	GOTO   SETUP 		;Pula para o marcador SETUP
;******************************** Interrupção **********************************
	ORG 4 				;Endereço do vetor de interrupção
	
;************************** Declaração de variáveis ****************************
		
;***************************** Inicio do programa ******************************

;******************************* Configurações *********************************

SETUP					;Bloco de configuração do microcontrolador
	BSF STATUS, RP0		;Seleciona banco de memoria 1

	;Configura portas (IOs)
	MOVLW b'00000000'	;Todas os pinos do PORTA como Saida
	MOVWF TRISA

	MOVLW b'00000011'	;Apenas os pinos RB0 e RB1 do PORTB são Entradas
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

	BSF SEL_LEDS		;Coloca pino PA5 em nivel alto
	
;***************************** Programa principal ******************************
 
LOOP					;Bloco do principal do programa 
	
	BTFSC BOTAO_S2 		;Pula se BOTAO_S2 não for precionado
	GOTO TESTA_VERDADEIRO

TESTE_FALSO
	MOVLW b'10101010'	;Carrega valor p/ acender LEDs D6, D8, D10 E D13
	MOVWF PORTD			;Coloca valor no PORTD

	GOTO LOOP			;Volta ao loop principal

TESTA_VERDADEIRO
	MOVLW b'01010101'	;Carrega valor p/ acender LEDs D7, D9, D11 E D14
	MOVWF PORTD			;Coloca valor no PORTD

	GOTO LOOP			;Volta ao loop principal

	END					;Indica a ultima linha de código do programa