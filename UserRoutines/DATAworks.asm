; Gestion independiente de Efemerides
; Definimos el numero de eventos puntuables unicos

EFEMERIDES	equ 8*8

; efemerides en Mijadore:
; 8x7 = 56 pantallas
; 8 misiones

; 0 BEBE				
; 1 ARBOL
; 2 MUERTO
; 3 DRAGON
; 4 COFRE
; 5 MAQUINA DEL TIEMO
 
efemer  defs EFEMERIDES,0
iptr	defw efemer

readef	ld hl,(iptr)				;hl=current pointer
		ld de,rptrdat+EFEMERIDES	;limite DATA
		scf
		ex de,hl		; HL=end, DE=ptr
		sbc hl,de		; end - ptr - 1 		
		ex de,hl		; DE=end, HL=ptr
		jr nc,no_wrap	; si aún no hemos llegado al fin, no reiniciar
		ld hl,efemer	; si nos pasamos, reiniciar al inicio
no_wrap ld a,(hl)
		inc hl
		ld (iptr),hl	; apunta al siguiente
		ret

writef	ld hl,(iptr)	; HL = puntero actual
        ld a,(vara)
		ld (hl),a		; guardar A en [HL]
        ret 

resetf	ld hl,efemer
		ld (iptr),hl	; apunta al primero
		ret
		
		