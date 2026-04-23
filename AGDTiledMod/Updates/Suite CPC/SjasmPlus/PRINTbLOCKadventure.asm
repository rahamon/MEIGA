; modificar rutina para interruptor on-off putblock in front
; infront on usa adventure mode asm modificada.
; infront off usa la rutina standard.

; ---------------------- PARA COLOCAR BLOQUES EN FRENTE: -------------------------

; EVENT RESTARTSCREEN

; RESTORE

; LET A = 0

; ; CARGAR FRONT BLOQUES SCREEN
	; ; SALTA LAS ANTERIORES
		; WHILE SCREEN <> A
			; READ B
				; REPEAT B
					; READ B
					; READ B
					; READ B
				; ENDREPEAT
			; ADD 1 TO A
		; ENDWHILE
	
	; ; SCREEN ES NUESTRA PANTALLA
		; USER 4		; INIT BLOCKS DATA
			; READ A
				; REPEAT A
					; READ B		; Y
					; READ A		; X
					; READ C		; BLOCK

					; USER 2			; WRITE BLOCK DATA
				; ENDREPEAT

; ; escribe en orden ascendente los datos:
; ; SCREEN 0
; DATA 8
		; 10 18 21
		; 11 18 21
		
		; 13 18 21
		; 14 18 2
		; 15 18 2
		
		; 13 24 21
		; 14 24 2
		; 15 24 2

; ; SECREEN 1		
; DATA 5
		; 10 18 21
		; 11 18 21
		
		; 13 18 21
		; 14 18 2
		; 15 18 2

; Por último falta insertar este código en el EngineZX.asm para que quede así: (busca la etiqueta dspr4 para localizar el lugar)

; dspr4
       ; ; tiles in front by adventure modification
		 ; ld a,3
		 ; call user


;---fin instrucciones-------------------------------------------


; define máximo numero de datos y reserva espacio.
BlockDataLongitud equ 256		; reserva todos estos bits para datos

; WRITE block
wrbloc
		; AT B A
		ld a,(varb)
        ld l,a
        ld a,(vara)
        ld h,a
        ld (charx),hl
		
		; PUT/WRITE BLOCK C
		ld hl,chgfx
		ld (grbase),hl
		ld hl,(charx)
		ld (dispx),hl				; dispx = charx
		ld a,(varc)					; type = a
		
		; WRITE DATA
		ld hl,(bDatptr)
		push af
		ld de,(dispx)
		ld a,(scno)
		ld (hl),a
		inc hl
		ld (hl),e
		inc hl
		ld (hl),d
		inc hl
		pop af
		ld (hl),a
		inc hl
		ld (bDatptr),hl
		
		; END
		ld hl,(dispx)
		ld (charx),hl

		ret
		
; INIT Block Data	
inibloc	ld hl,BlData
		ld (bDatptr),hl
		ret

; REDRAW Blocks
drawb	ld hl,(blkptr)
		ld (grbase),hl
		ld hl,BlData
drawb2	ld bc,4
		ld de,(bDatptr)
		and a
drawb1	push hl
		sbc hl,de
		pop hl
		ret nc
		ld a,(scno)
		cp (hl)
		jr z,drawb0
		add hl,bc
		jr drawb1
drawb0	inc hl
		ld e,(hl)
		inc hl
		ld d,(hl)
		ld (dispx),de
		inc hl
		ld a,(hl)
		inc hl
		push hl
		call pattr
		pop hl
		jr drawb2

; Pointers and Data
bDatptr	defw BlData
infront	defb 0

BlData	equ $
		defs BlockDataLongitud,0