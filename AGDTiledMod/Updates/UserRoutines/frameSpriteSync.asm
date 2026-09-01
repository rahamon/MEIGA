; Prototipo en pruebas
FRAME_TSTATES   equ 69888
SPRITE_WINDOW   equ 14000
FRAME_LIMIT     equ FRAME_TSTATES-SPRITE_WINDOW     ; 63888

vsync3f push hl
        call vsync	; frena el tiempo
		ld hl,clock
vsync30 ld a,(23672)
		;rra
		rra			; acelera el tiempo, Usar con cautela
        cp (hl)
        jr z,vsync30
        ld (hl),a
        pop hl
        ret

;MEIGA 12 si es tipo 9 o menos sincroniza
vsynct	;ld a,(ix+5)
	; hasta Ncol sprites
		;ld hl,NCol
		;cp (hl)
	; hasta 5 tipos de sprites
		;cp 5
		;jp nc,prisnc2
		;jp nz,prisnc2
		;call vsync3f
		;ret

; MEIGA 12: si Y < salta para sincronizar con TV, SOLO PARA PACO TIME ATTACK
vsyncy	;ld a,(ix+8)      		
		;cp 144            		
		;jr nc,prisnc9
		;cp 64
		;jr c,prisnc9
		;call vsync3f
		;ret

vsync3g
        ld hl,(frame_time)      ; T-states consumidos en este frame
        ld de,FRAME_LIMIT
        or a                    ; limpia carry
        sbc hl,de
        jr c,hay_tiempo        ; si frame_time < 63888,
                                ; quedan al menos 6000 T-states
        ; No queda ventana suficiente.
        ; Esperamos a que cambie FRAMES.
        ld a,(23672)
        ld b,a
espera
        ld a,(23672)
        cp b
        jr z,espera
        ; Ha empezado un nuevo frame.
        xor a
        ld (frame_time),a
        ld (frame_time+1),a
hay_tiempo

	; Hemos estimado que este bloque consume 6000 T-states.
        ld hl,(frame_time)
        ld de,SPRITE_WINDOW
        add hl,de
        ld (frame_time),hl
        ret

frame_time
        dw 0
		