; Comprueba agua en el cuadro de colisión.
; Entrada:
;   B = tipo de bloque agua = WATERBLOCK
;   IX = sprite/objeto
;
; Salida:
;   (ix+67) = mapa de contacto con agua
;             bit 1 = celda 1
;             bit 2 = celda 2
;             bit 3 = celda 3 extra
;             bit 4 = celda 4
;             bit 5 = celda 5
;             bit 6 = celda 6 extra
;

PrepareWaterMap
		ld b,WATER
		xor a
		ld (vare),a
		ld (varf),a
		ld (varg),a
		ld (vari),a
		ld (varj),a
		ld (vark),a
		ld a,(ix+67)
		and %00000001       ; conserva solape con sprites
		ld (ix+67),a

twater	ld l,(ix+8)         ; x
		ld h,(ix+9)         ; y
		ld (dispx),hl
		call tstbl          ; HL apunta a la celda inicial

		ld de,31            ; distancia por defecto a siguiente fila

; --- Fila superior ---

twater_1
       cp b                ; celda 1
       jr nz,twater_2
       set 1,(ix+67)
	   ld (vare),a

twater_2
       inc hl              ; celda 2 next cell.
       ld a,(hl)
       cp b
       jr nz,twater_3
       set 2,(ix+67)
	   ld (varf),a
	   
twater_3
       ld a,(dispy)        ; posición horizontal, igual que en tded
       ld c,a
       and 7
       jr z,twater_row2    ; si no cruza, no hay celda 3

       inc hl              ; celda 3 extra next cell.
       ld a,(hl)
       cp b
       jr nz,twater_4
       set 3,(ix+67)
	   ld (varg),a
	   
twater_4
       dec de              ; salto fila

; --- Fila inferior ---
twater_row2
       add hl,de           ; celda 4
       ld a,(hl)
       cp b
       jr nz,twater_5
       set 4,(ix+67)
	   ld (vari),a
		xor a
		ld (skpr1+1),a
		ld (skres1+1),a
	   
twater_5
       inc hl              ; celda 5
       ld a,(hl)
       cp b
       jr nz,twater_6
       set 5,(ix+67)
	   ld (varj),a
		xor a
		ld (skpr3+1),a
		ld (skres3+1),a
	   
twater_6
       ld a,c              ; misma comprobación horizontal
       and 7
       jr z,twater_end     ; si no cruza, no hay celda 6

       inc hl              ; celda 6 extra
       ld a,(hl)
       cp b
       jr nz,twater_end
       set 6,(ix+67)
	   ld (vark),a
		xor a
		ld (skpr2+1),a
		ld (skres2+1),a
	   
twater_end
       ld a,(ix+67)        ; opcional: devuelve también el mapa en A
	   ld (varo),a
       ret

; --------------------------------------------------
; Prepara los JR automodificados según (IX+67)
;
; bit = 0 -> guarda 0 -> JR +0 -> ejecuta JR skipbitX
; bit = 1 -> guarda 3 -> JR +3 -> NO ejecuta JR skipbitX
; --------------------------------------------------

PrepareWaterSkips_Line1

		ld a,(ix+67)
		ld c,a

; bit 1 -> skpr1+1

		ld a,c
		rrca
		rrca
		sbc a,a
		and 2
		ld (skpr1+1),a
		ld (skres1+1),a

; bit 2 -> skpr2+1

		ld a,c
		rrca
		rrca
		rrca
		sbc a,a
		and 2
		ld (skpr3+1),a
		ld (skres3+1),a

; bit 3 -> skpr3+1

		ld a,c
		rrca
		rrca
		rrca
		rrca
		sbc a,a
		and 2
		ld (skpr2+1),a
		ld (skres2+1),a

		ret
	

; --------------------------------------------------
; Prepara los JR para la segunda línea de 8 píxeles
;
; bit 4 -> jumpbit1+1
; bit 5 -> jumpbit2+1
; bit 6 -> jumpbit3+1
;
; bit = 0 -> guarda 0 -> ejecuta JR skipbitX
; bit = 1 -> guarda 3 -> NO ejecuta JR skipbitX
; --------------------------------------------------

PrepareWaterSkips_Line2

		ld a,(ix+67)
		ld c,a

; bit 4

		ld a,c
		rlca
		rlca
		rlca
		rlca            ; bit 4 -> carry
		sbc a,a
		and 2
		ld (skpr1+1),a
		ld (skres1+1),a

; bit 5

		ld a,c
		rlca
		rlca
		rlca            ; bit 5 -> carry
		sbc a,a
		and 2
		ld (skpr3+1),a
		ld (skres3+1),a

; bit 6

		ld a,c
		rlca
		rlca            ; bit 6 -> carry
		sbc a,a
		and 2
		ld (skpr2+1),a
		ld (skres2+1),a

		ret

PrepareWaterSkips_Reset
		ld a,2
		ld (skpr3+1),a
		ld (skres3+1),a
		ld (skpr2+1),a
		ld (skres2+1),a
		ld (skpr1+1),a
		ld (skres1+1),a
		ret
		