; Establece nuevos atributos de Tipo para un bloque
;
; Entrada:
; 	el numero de bloque en A
; 	el tipo en B
;	
SetTypeBlock
		ld a,(vara)
		ld e,a			; bloque
		ld d,0
		ld hl,(proptr)
		add hl,de
		ld a,(varb)		; nuevo tipo
		ld (hl),a
		ret
		
; INSTRUCCIONES

; Ejemplo rutina user:
; Control
;		cp 18
;		jp z,SetTypeBlock
;		
;
; Meiga UserRutines
;			include "SetTypeBlock.asm"
			
; Ejemplo 1 en AGD:
; Establece tipo bloque FRONT(=10)
;	LET A = 56	; bloque que queremos cambiar el tipo
; 	LET B = FRONT	; tipo IN-FRONT
;	USER 18		; indice de la rutina user
;
