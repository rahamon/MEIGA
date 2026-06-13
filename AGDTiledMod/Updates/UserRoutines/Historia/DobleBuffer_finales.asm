
; ===== Espera VBlank comienzo de frame (con ISR player)=====
waitIRQ	halt
		ld a,(TickFlag)
		or a
		jr z,waitIRQ
		xor a
		ld (TickFlag),a
		ret

TickFlag	defb 0
Last7FFD        defb 0
ULAScreen       defb 0       ; 0 = visible RAM5
                             ; 1 = visible RAM7
							 
; ============================================================
; ZX Spectrum 128K
; Servicio de pantalla normal / shadow
; Siempre deja paginada la RAM 0 en $C000
; ============================================================

PORT_7FFD   equ $7FFD
SCREEN_5    equ $4000
SCREEN_7    equ $C000
SCR_SIZE    equ 6912        ; 6144 bitmap + 768 atributos

; Copia espejo del puerto 7FFD.
; Debe inicializarse con el estado real usado por tu programa.
; Página 0 en $C000, pantalla normal, ROM 0:
ulaport    db %00000000
		
Set7FFD
        ld (23388),a
        ld bc,32765
        out (c),a
        ld (Last7FFD),a
        ret
		
SetState_Show5_Bank0
		ld a,(23388)
		and %11110000      ; conserva bits altos
		or  %00000000      ; banco 0 + show5
		call Set7FFD
		xor a
		ld (ULAScreen),a
		ret
		
SetState_Show7_Bank0
		ld a,(23388)
		and %11110000
		or  %00001000
		call Set7FFD
		ld a,1
		ld (ULAScreen),a
		ret

FlipBuffers
        ld a,(ULAScreen)
        or a
        jr z,to7
to5		call SetState_Show5_Bank0
		ret
to7		call CopyScreen5To7
		call SetState_Show7_Bank0
		ret
		
ShowShadow
		push af
		push bc

		ld a,(ulaport)
		and %11111000         ;despues bits 0-2 = 0 -> dejar página 0 en $C000
		or	%00001000          ;antes bit 3 = 1 -> mostrar shadow screen
		ld (ulaport),a

		ld bc,PORT_7FFD
		out (c),a

		pop bc
		pop af
		ret
		
ShowNormal
		push af
		push bc

		ld a,(ulaport)
	; bit 3 = 0 -> mostrar pantalla normal
		;and %11110111
	; bits 0-2 = 0 -> dejar página 0 en $C000
		;and %11110000
		and %11110000      ; conserva bits altos
		or  %00000000      ; banco 0 + show5
		ld (ulaport),a

		ld bc,PORT_7FFD
		out (c),a

		pop bc
		pop af
		ret

CopyScreen5To7
CopyScreen5ToShadow:

		push af
		push bc
		push de
		push hl

		; Paginamos RAM 7 en $C000,
		; pero sin tocar el bit de pantalla ni el de ROM.
		ld a,(ulaport)
		and %11111000         ; limpiar bits 0-2
		or  %00000111         ; página 7 en $C000
		ld (ulaport),a

		ld bc,PORT_7FFD
		out (c),a

		; Copia completa: bitmap + atributos
		ld hl,SCREEN_5        ; origen: pantalla normal RAM 5
		ld de,SCREEN_7        ; destino: RAM 7 paginada en $C000
		ld bc,SCR_SIZE
		ldir

		; Restaurar página 0 en $C000
		ld a,(ulaport)
		and %11111000         ; bits 0-2 = 0
		ld (ulaport),a

		ld bc,PORT_7FFD
		out (c),a

		pop hl
		pop de
		pop bc
		pop af
		ret

;-------main
InitULABuffers
		di
		call CopyScreen5ToShadow
		ei
		call ShowShadow
		ret

FlipBufferSafe
		call ShowNormal
		di
		call CopyScreen5ToShadow
		ei
		ret
