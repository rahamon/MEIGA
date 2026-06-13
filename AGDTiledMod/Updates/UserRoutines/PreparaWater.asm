; Comprueba agua en el cuadro de colisión.
; Entrada:
;   B = tipo de bloque agua = WATERBLOCK
;   IX = sprite/objeto
;
;	calve 2 pinta, 0 no pinta

WaterMapSprite	defb 0
WaterSwitchLine	defb 8

PrepareWaterMap
		call PrepareWaterSkips_Reset
		
	;test
		; xor a
		; ld (vare),a
		; ld (varf),a
		; ld (varg),a
		; ld (vari),a
		; ld (varj),a
		; ld (vark),a
		
		ld a,(ix+67)
		and %00000001       ; conserva solape con sprites
		ld (ix+67),a
		
twater	ld l,(ix+8)         ; x
		ld h,(ix+9)         ; y
		;ld a,l
        ;and 7
        ;ld b,a
        ;ld a,8
        ;sub b
		;add a,b
        ;ld (WaterSwitchLine),a
		ld (dispx),hl
		call tstbl          ; HL apunta a la celda inicial

		ld b,WATER
		ld de,31            ; distancia por defecto a siguiente fila

; --- Chekea Fila superior fondo ---

twater_1
		cp b                ; celda 1 
		jr nz,twater_2
		;ld (vare),a
		set 1,(ix+67)
		; xor a
		; ld (skpr1+1),a
		; ld (skres1+1),a
		
twater_2
		inc hl              ; celda 2 next cell.
		ld a,(hl)
		cp b
		jr nz,twater_3
		;ld (varf),a
		set 2,(ix+67)
		; xor a
		; ld (skpr3+1),a
		; ld (skres3+1),a
		
twater_3
		ld a,(dispy)        ; posición horizontal, igual que en tded
		ld c,a
		and 7
		jr z,twater_row2    ; si no cruza, no hay celda 3

		inc hl              ; celda 3 extra next cell.
		ld a,(hl)
		cp b
		jr nz,twater_4
		;ld (varg),a
		set 3,(ix+67)
		; xor a
		; ld (skpr2+1),a
		; ld (skres2+1),a
		
twater_4
		dec de              ; salto fila

; --- Fila inferior del fondo ---
twater_row2
		add hl,de           ; celda 4
		ld a,(hl)
		cp b
		jr nz,twater_5
		;ld (vari),a
		set 4,(ix+67)
		; xor a						; NO pinta
		; ld (skpr1+1),a
		; ld (skres1+1),a

twater_5
		inc hl              ; celda 5
		ld a,(hl)
		cp b
		jr nz,twater_6
		;ld (varj),a
		set 5,(ix+67)
		; xor a						; NO pinta
		; ld (skpr3+1),a
		; ld (skres3+1),a
	   
twater_6
		ld a,c              ; misma comprobación horizontal
		and 7
		jr z,twater_end     ; si no cruza, no hay celda 6

		inc hl              ; celda 6 extra
		ld a,(hl)
		cp b
		jr nz,twater_end
		;ld (vark),a
		set 6,(ix+67)
		; xor a						; NO pinta
		; ld (skpr2+1),a
		; ld (skres2+1),a
	   
twater_end
		ld a,(ix+67)
        ld (WaterMapSprite),a
		ret

PrepareWaterSkips_Reset
		ld a,2				; pinta
		ld (skpr3+1),a
		;ld (skres3+1),a
		ld (skpr2+1),a
		;ld (skres2+1),a
		ld (skpr1+1),a
		;ld (skres1+1),a
		ret

; --------------------------------------------------
; Prepara los JR automodificados según (IX+67)
;
; bit = 0 -> guarda 2 -> JR +2 -> pinta
; bit = 1 -> guarda 0 -> JR +0 -> No Pinta
; --------------------------------------------------
PrepareWaterSkips_LineaAlta_Sprites
		push bc
		call PrepareWaterSkips_Reset
		ld a,(ix+67)
		ld c,a
; bit 1 de WaterMap
		ld a,c
		rrca
		rrca
		sbc a,a
		and 2
		xor 2
		ld (skpr1+1),a
		;ld (skres1+1),a
; bit 2 de WaterMap
		ld a,c
		rrca
		rrca
		rrca
		sbc a,a
		and 2
		xor 2
		ld (skpr3+1),a
		;ld (skres3+1),a
; bit 3 de WaterMap
		ld a,c
		rrca
		rrca
		rrca
		rrca
		sbc a,a
		and 2
		xor 2
		ld (skpr2+1),a
		;ld (skres2+1),a
		pop bc
		ret

PrepareWaterSkips_LineaBaja_Sprites
		push bc
		call PrepareWaterSkips_Reset
		;ld a,(ix+67)
		ld a,(WaterMapSprite)
		ld c,a
; bit 4 de WaterMap
		ld a,c
		rlca
		rlca
		rlca
		rlca            ; bit 4 -> carry
		sbc a,a
		and 2
		xor 2
		ld (skpr1+1),a
		;ld (skres1+1),a
; bit 5 de WaterMap
		ld a,c
		rlca
		rlca
		rlca            ; bit 5 -> carry
		sbc a,a
		and 2
		xor 2
		ld (skpr3+1),a
		;ld (skres3+1),a
; bit 6 de WaterMap
		ld a,c
		rlca
		rlca            ; bit 6 -> carry
		sbc a,a
		and 2
		xor 2
		ld (skpr2+1),a
		;ld (skres2+1),a
		pop bc
		ret		
		