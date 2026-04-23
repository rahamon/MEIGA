; Establece nuevos atributos de color a partir de Current Color guardado en 23693
	
; mascaras 
FLASH    EQU 128    ; bit 7
NOFLASH  EQU 127    ; 0x7F, limpia bit 7
BRIGHT   EQU 64     ; bit 6
NOBRIGHT EQU 191    ; 255-64 = 0xBF, limpia bit 6

SetAttrBlock
		ld e,a			; bloque en a
		ld d,0
		ld hl,(colptr)
		add hl,de
		ld a,(varb)
		ld c,a			; brillo en c
		and a
		jr z,bright0
		ld a,(23693)	; color en 23693
		or BRIGHT
		jr setattr
bright0 ld a,(23693)	; color en 23693
		and NOBRIGHT
setattr	;or FLASH
		and NOFLASH
		ld (hl),a
		ret
		
; INSTRUCCIONES

; Ejemplo rutina user:
; Control
;		cp 18
;		jp z,SetAttr2Water
;		
;SetAttr2Water
;		ld a,(vara)
;		jp SetAttrBlock
;
; Meiga UserRutines
;			include "SetAttrBlock.asm"
			
; Ejemplo 1 en AGD:
; Establece color bloque de agua
;	INK 5
;	PAPER 1
; 	LET B = 0	; BRILLO 0
;	LET A = 56	; bloque de agua
;	USER 18		; indice de la rutina user
;

; Ejemplo 2 en AGD:
; Establece color bloque de background
;	INK 7
;	PAPER 0
;	LET A = 0	; bloque base background
;	LET B = 1	; BRILLO
;	USER 18
;
		