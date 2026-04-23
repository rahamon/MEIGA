; Search for OTHER sprite with the same parameter (var A) than mine
; Por ejemplo: para buscar OTHER sprite con parametro SETTINGA (ix+11) igual al mio hacemos LET A = 11: USER n
; Encuentra OTHER sprite y devuelve A = 1 si tiene exito.
;
; 

		; Search Sprite program
		cp 0
		jp z,sksprparam
		cp 1
		jp z,sksFall
		ret

sksFall
		;call ifall
        call grav
		ret
		
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
