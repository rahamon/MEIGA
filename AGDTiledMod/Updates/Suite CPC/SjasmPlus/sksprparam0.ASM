; Check for sprite with parameter (var A) and type (var B)
; Por ejemplo para buscar TIPO 2 Y parametro SETTINGA (ix+11) hacemos LET A = 11: LET B = 2: USER n
; Establece skptr que es OTHER sprite y devuelve A = 1 si tiene exito.

		ld a,(vara)			; ejemplo A = 11
		ld (spar1),a		; e guarda ahora el indice del parametro que queremos buscar (11 es SETTINGA)
		ld a,(varb)			; ejemplo B = 2 corresponde al tipo 2
		ld b,a				; e guarda ahora el indice del parametro que queremos buscar (11 es SETTINGA)

sksprparam
		ld hl,sprtab        ; sprite table.
		ld a,NUMSPR         ; number of sprites.
skspr0	ex af,af'           ;' store loop counter.
		ld (skptr),hl       ; store pointer to sprite. It is OTHER variable
		ld a,(hl)           ; get sprite type.
		cp b                ; is it the type we seek?
		jr z,chktyp         ; yes, we can use this one.
skspr1	ld hl,(skptr)       ; retrieve sprite pointer.
		ld de,TABSIZ        ; size of each entry.
		add hl,de           ; point to next sprite in table.
		ex af,af'           ;' restore loop counter.
		dec a               ; one less iteration.
		jp nz,skspr0        ; keep going until we find a slot.
		ld hl,0             ; default to ROM address - no sprite.
		ld (skptr),hl       ; store pointer to sprite.
		or a                ; DISMATCH
		ld (vara),a
		ret                 ; didn't find one. NO

chktyp	ld a,(ix+0)         ; current sprite type.
		cp b                ; seeking sprite of same type?
		jr z,chkty1         ; yes, need to check we're not detecting ourselves.
chkty0	ld de,(spar1)		; distance to parametro in table.
		ld d,0
		add hl,de           ; point to parametro.
		ld a,(hl)           ; fetch parametro.
; Check values.

chkpar
		push ix
		pop hl
		ld de,(spar1)		; distance to parametro in table.
		ld d,0
		add hl,de			; desplazamiento hasta parametro hl = ix + (spar1)
		cp (hl)				; conicidence a* con este parametro?
		jr z,kpared			; there's a coincidence. SI
		jp skspr1           ; try next sprite in table.
		
kpared	ld (varf),a
		ld a,1				; MATCH
		ld (vara),a
		ret

chkty1	push ix             ; base sprite address onto stack.
		pop de              ; pop it into de.
		ex de,hl            ; flip hl into de.
		sbc hl,de           ; compare the two.
		ex de,hl            ; restore hl.
		jr z,skspr1         ; addresses are identical.
		jp chkty0
		
spar1	defb 11				; por defecto para el ejemplo
