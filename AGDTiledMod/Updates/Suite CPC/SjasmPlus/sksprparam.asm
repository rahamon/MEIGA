; Search for OTHER sprite with the same parameter (var A) than mine
; Por ejemplo: para buscar OTHER sprite con parametro SETTINGA (ix+11) igual al mio hacemos LET A = 11: USER n
; Encuentra OTHER sprite y devuelve A = 1 si tiene exito.
; 
; Escrito por Ramón Fernández Ameijeiras. Para mi y para todos.
;
; ---------------------- Emparejar Sprites --------------------------

; 1.-a: COLOCA ESTO EN EL EVENTO EVENT INITSPRITE PARA EMPAREJAR CONTIGUOS POR PARES

; ; EMPAREJA CONTIGUO
	; IF TYPE = 2		; SI ES PANTALON...
		; ;SUBTRACT 1 FROM E
		; LET SETTINGA = E
	; ENDIF

; ; DEFINE CABEZA
	; IF TYPE = 1		; SI ES CABEZA...
		; ADD 1 TO E
		; LET SETTINGA = E
	; ENDIF

; ; INICIA CLOCK SECUENCIA DE ESTADOS	
	; IF TYPE = 0
		; LET E = 0
		; LET SETTINGA = E
	; ENDIF

; 1.-b: OTRA MANERA: COLOCA ESTO EN EL EVENTO EVENT INITSPRITE PARA EMPAREJAR JEFE.

; ; IDENTIFICA AL JEFE
	; IF TYPE = 5		; (NUESTRO JEFE ESTÁ PROGRAMADO EN EVENT SPRITETYPE 5)
		; LET SETTINGA = 1		; ESTE ES EL JEFE, AHORA LAS PIEZAS SE PUEDEN UNIR A EL
	; ENDIF
; ; IDENTIFICAR UNA PIEZA
	; IF TYPE = 6		; PATAS DEL JEFE
		; LET SETTINGA = 1		; AHORA LAS PIEZAS SE PUEDEN UNIR A EL
	; ENDIF
; ; IDENTIFICAR OTRA PIEZA
	; IF TYPE = 7		; BRAZOS DEL JEFE
		; LET SETTINGA = 1		; TAMBIEN LAS PIEZAS SE PUEDEN UNIR A EL DESDE OTRA POSICION CON OTRO COMPORTAMIENTO
	; ENDIF

; 2.- COLOCA SPRITES POR ORDEN EN TU EDITOR.
	; PRIMERO CABEZA Y DESPUES PIES PARA EMPAREJAR POR PARES (a),	O BIEN, POR TIPOS A DISCRECIÓN (b).

; 3.- buasca sprite emparentado:
	; ; ESTO ENCUENTRA UN SPRITE CON MI MISMO SETTINGA
	; ; SEARCH MY HEAD	
		; LET A = 11		; PARAMETRO 11 ES SETTINGA
		; USER 0			; SELECCIONA EL PROGRAMA 0 DE USUARIO

		; IF A = 1		; A ES 1 SI ENCUENTRA ALGUIEN CON MIM MISMA SETTINGA
			; OTHER			; ESTE ES TU PARIENTE!
				; LET A = X
				; LET B = Y
			; ENDSPRITE
		; ENDIF
		
		; ADD 8 TO B
		; ADD 16 TO A
		; LET X = A
		; LET Y = B

; 4.- EN EL EVENTO RESTARTSCREEN PONER LET E = 0













sksprparam
		ld a,(vara)
		ld (spar1),a		; reserva el indice del parametro que queremos buscar (11 es SETTINGA)

		ld hl,sprtab        ; sprite table.
		ld a,NUMSPR         ; number of sprites.
skspr0	ex af,af'           ;' store loop counter.
		ld (skptr),hl       ; store pointer to sprite. It is OTHER variable
		jp chkty1			; we can use this one.
skspr1	ld hl,(skptr)       ; retrieve sprite pointer.
		ld de,TABSIZ        ; size of each entry.
		add hl,de           ; point to NEXT sprite in table.
		ex af,af'           ;' restore loop counter.
		dec a               ; one less iteration.
		jp nz,skspr0        ; keep going until we find a slot.
		ld hl,0             ; default to ROM address - no sprite.
		ld (skptr),hl       ; store pointer to sprite.
		or a                ; DISMATCH
		ld (vara),a			; A = 0
		ret                 ; didn't find one. NO

chkty0	ld de,(spar1)		; distance to parametro in table.
		ld d,0
		add hl,de           ; point to parametro.
		ld a,(hl)           ; fetch parametro.
		
; Check values.

chkpar	push ix
		pop hl
		ld de,(spar1)		; distance to parametro in table.
		ld d,0
		add hl,de			; desplazamiento hasta parametro hl = ix + (spar1)
		cp (hl)				; conicidence a* con este parametro?
		jr z,kpared			; there's a coincidence. SI
		jp skspr1           ; try NEXT sprite in table.
		
kpared	ld a,1				; MATCH -> A = 1
		ld (vara),a
		ret

chkty1	push ix             ; base sprite address onto stack.
		pop de              ; pop it into de.
		ex de,hl            ; flip hl into de.
		sbc hl,de           ; compare the two.
		ex de,hl            ; restore hl.
		jr z,skspr1         ; addresses are identical.try NEXT
		jp chkty0
		
spar1	defb 11				; por defecto para el ejemplo
