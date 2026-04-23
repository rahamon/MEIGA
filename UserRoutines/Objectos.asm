objdta	equ $
		defb	[0+]	0,0,0,0,0,32,24,112,36,136,36,140,24,136,5,240,
				[16+]	3,0,7,64,12,160,28,80,58,32,20,0,8,0,0,0,
				[32+]	2,0(*),64,48,
			hl->[36+]	0,64,48

		hl				; store item pointer data: grafics, (colour), ROOM , pixels down, across
		scno			; current location.
		39+				; size of each object. (next)
		33+				; distance to ROOM it's in.(*)
		
		call dobjc		; DISPLAY OBJECT SPRITE in colour.
		call dobj1		; REMOVE OBJECT SPRITE
		call gotob		; get its address (a)
		call getob		; pick it up if we haven't already got it (a)

		call remob		; CRUD-DELETE Object (a) -> getob + gotob -> hl=254 remove it: GET
		call drpob		; Drop object number (a) at (dispx, dispy): PUT
		call skobj		; BUSCA objects at sprite position: DETECTOBJECTS

;--------------------------------------------------------------------	   
dobj   inc hl				; point to x.
dobj0  ld de,dispx			; coordinates.
       ldi					; transfer x coord.
       ldi					; transfer y too.
       ld de,65500			; minus 36.
       add hl,de			; point to image, dispx(x,y)
dobj1  jp sprite			; DISPLAY/REMOVE XOR pinta o borra
dobjc  call dobj			; display object.
       ld c,(hl)			; put ink in c register.   
cobj   	...					; colour routine.
		ret
	   
;--------------------------------------------------------------------	   
getob	...
		call gotob          ; check if we already have it.
		...
		call dobj1          ; is it on this screen? display/REMOVE Object sprite
		ret

;--------------------------------------------------------------------	   
gotob	cp 255              ; in pockets? devuelve z,n. (254 missing)
		hl					; point to room object data
		
;--------------------------------------------------------------------	   
drpob	...(a) at (dispx, dispy)
		ret					; can't drop non-existent item
		ret             	; already on this screen? nothing to do
		SAVE data in CRUD	; actualiza tabla de objetos
		dobj1				; DISPLAY/remove Object sprite

;--------------------------------------------------------------------	   
skobj	...
		a					; Obtiene en el acumulador el objeto, o bien, 255 si no hay nada
		ld (varobj),a
		hl					; apunta a store item pointer data + 1
		dec hl				; coord x
		dec hl				; coord y
		dec hl				; room
; ------------------------------------------------------------
; AlignToCell8x8
; Ajusta dispx/dispy a la celda 8x8 (redondeo hacia abajo).
; Entrada : (dispx), (dispy) en píxeles
; Salida  : (dispx), (dispy) alineadas a múltiplo de 8
; Modifica: A
; ------------------------------------------------------------

AlignToCell8x8:
        ld a,(dispx)
        and %11111000        ; 248
        ld (dispx),a

        ld a,(dispy)
        and %11111000        ; 248
        ld (dispy),a

        ret
		
;---------------------------------------------------------------------------
; SPAWN_Object_Grafic, 	HL apunta al grafico del objeto
;		defb	[0+]	0,0,0,0,0,32,24,112,36,136,36,140,24,136,5,240,
;				[16+]	3,0,7,64,12,160,28,80,58,32,20,0,8,0,0,0,
;				[32+]	2,0(*),64,48,
;				[36+]	0,64,48
;---------------------------------------------------------------------------
NumeroObjeto	defb 0
		
SPAWN_Object
		ld ix,sprtab
spwobj  ld hl,sprtab        ; sprite table.
		ld a,NUMSPR         ; number of sprites.
		ld de,TABSIZ        ; size of each entry.
spwobj0	ex af,af'           ; store loop counter.
		ld a,(hl)           ; get sprite type.
		inc a               ; is it an unused slot?
		jr z,spwobj1		; yes, we can use this one.
		add hl,de           ; point to next sprite in table.
		ex af,af'           ; restore loop counter.
		dec a               ; one less iteration.
		jr nz,spwobj0         ; keep going until we find a slot.
		
spwobj1
		ld (ogptr),ix		; store original sprite address
		ld (spptr),hl       ; store spawned sprite address
		ld ix,(spptr)
		ld a,10
		ld (ix+5),a
		ld a,(NumeroObjeto)
		ld (ix+6),a         ; set up image.
		ld a,(dispx)         ; x coordinate..
		ld (ix+8),a
		ld a,(dispy)
		ld (ix+9),a

		xor a               ; zeroes in accumulator.
		ld (ix+7),a         ; reset frame number.
		ld (ix+10),a        ; reset direction.
		;       ld (ix+11),a        
		;       ld (ix+12),a        
		ld (ix+13),a        ; reset jump pointer low.
		ld (ix+14),a        ; reset jump pointer high.
		;ld (ix+16),a	     reset data pointer to auto-restore.
		ld (ix+66),a		; reset mask image
		ld (ix+67),a		; nuevo solapamiento?
		ld a,(z_counter)    ; lee Z global actual
		ld (ix+17),a        ; asigna Z al sprite
		inc a               ; incrementa para el siguiente sprite
		ld (z_counter),a

		call evnt09         ; call sprite initialisation event.
		ld ix,(ogptr)		; restore original sprite address
		ret
		
;---------------------------------------------------------------------------
; PRINT_Sprite_Object
; Guarda fondo en spritebk y pinta sprite nuevo
;---------------------------------------------------------------------------
PRINT_Sprite
		ld a,(ix+5)
		cp 10
		jp nz,gsmptr		; Es un Sprite-Objeto? No, es un Sprite
		call gsprm			; HL = pantalla destino, DE = sprite mascara, BC = SIMASK
		exx
		call gspran			; HL' = pantalla destino, DE' = sprite, BC' = SIMASK
		push hl
		push bc				
		ld a,(ix+6)			; carga numero objeto
		call findob         ; find the object: hl point to room [33+] fetch status in a
		ld de,65503			; menos 33
		add hl,de			; hl apunta ahora al grafico
		push hl				
		pop de				; DE' = ahora sprite-Objeto
		pop bc				; BC' = SIMASK
		pop hl				; HL' = pantalla destino
		jr prisp00


; Display object.
; hl must point to object's room data.	
	IF MASKAGD = 2
dobjc	;ret	Pinta y colorea
		push hl				; poit to room
		inc hl              ; point to x.
dobj0	ld de,dispx         ; coordinates.
		ldi                 ; transfer x coord.
		ldi                 ; transfer y too.
		ld de,65500         ; minus 36.
		add hl,de           ; point to image.
		call SPAWN_Object	; draw this sprite. XOR pinta con color
		pop hl
		dec hl				; point to colour
		ld c,(hl)           ; put ink in c register.
		jp cobj
dobj1	;ret	Borra
		ld b,10
		call sktyp
		jr nc,dobj2
		ld ix,(skptr)
		call RESTAURA_Fondo
		ld ix,(ogptr)
		ret
dobj2	;ret	Pinta
		push hl				; poit to room
		call SPAWN_Object     ; draw this sprite. XOR pinta o boora
		pop hl
		dec hl				; point to colour
		ret
		;jp cobj
	ELSE
dobj   inc hl              ; point to x.
dobj0  ld de,dispx         ; coordinates.
       ldi                 ; transfer x coord.
       ldi                 ; transfer y too.
       ld de,65500         ; minus 36.
       add hl,de           ; point to image.
dobj1  jp sprite           ; draw this sprite. XOR pinta o boora
dobjc  call dobj           ; display object.
       ld c,(hl)           ; put ink in c register.
	ENDIF

	   