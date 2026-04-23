; Search for OTHER sprite with the same parameter (var A) than mine
; Por ejemplo: para buscar OTHER sprite con parametro SETTINGA (ix+11) igual al mio hacemos LET A = 11: USER n
; Encuentra OTHER sprite y devuelve A = 1 si tiene exito.
;
; USER 4 CODIGO AGD:
;	GETBLOCK X Y
;				IF BLOCK = 0
;					LET LINE = Y
;					LET COLUMN = X
;					DIVIDE LINE BY 8
;					DIVIDE COLUMN BY 8
;					USER 3			; checquea si existen colisones
;					IF C = 1		; NO colisionan
;						PUTBLOCK 7
;					ENDIF
;				ENDIF 


		; Search Sprite program
		cp 0
		jp z,sksprparam
		cp 1
		jp z,sksFall
		; mask prototipo
		cp 2
		jp z,mascara
		; check colisiones prototipo
		cp 3
		jp z,checkcollisions
		; print block 7
		cp 4
		jp z,putmaskblock
		; check múltiplo de 8
		cp 5
		jp z,CheckMultiplo8
		; mask sin collision
		cp 6
		jp z,putmaskblocksincollision
		ret

mascara
		call evnt20
		ret

CheckMultiplo8
		ld a,(vara)			; Cargar el número en A
		and 7				; Aplicar AND con 00000111 (7 en decimal)
		jr z,EsMult8		; Si el resultado es 0, es múltiplo de 8
		xor a				; no es múltiplo de 8
		jr Mult8
EsMult8 ld a,1				; si es múltiplo de 8
Mult8	ld (vara),a
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

; chequea colisiones entre player,sprites 5,6,7 y 8, devuelve 0 si existe alguna
checkcollisions
		xor a
		ld (varc),a
		ld b,0
		call sktyp
		jp nc,chcls1
		jp chcls6
chcls1	ld b,5
		call sktyp
		jp nc,chcls2
		jp chcls6
chcls2	ld b,6
		call sktyp
		jp nc,chcls3
		jp chcls6
chcls3	ld b,7
		call sktyp
		jp nc,chcls4
		jp chcls6
chcls4	ld b,8
		call sktyp
		jp nc,chcls5
		jp chcls6
chcls5	ld b,2
		call sktyp
		jp nc,chcls7
		jp chcls6
chcls7	ld a,1
		ld (varc),a		; no colisionan
chcls6	ret

; pinta un bloque en x,y
; tambien test si colisiona con alguien ahi
; usa la variable C del AGD
putmaskblock
		ld a,(ix+9)
		ld h,a
		ld a,(ix+8)
		ld l,a
		ld (dispx),hl
		call tstbl
		ld (varblk),a
		xor a
		ld hl,varblk
		cp (hl)
		jp nz,pmbloc
		ld a,(ix+8)
		ld (charx),a
		ld a,(ix+9)
		ld (chary),a
		ld a,(charx)
		rra
		rra
		rra
		and 31
		ld (charx),a
		ld a,(chary)
		rra
		rra
		rra
		and 31
		ld (chary),a
		call checkcollisions		; chequea que no hay nadie ahi
colisxx	ld a,1
		ld hl,varc
		cp (hl)
		jp nz,pmbloc			; si varc distinta de 1 (1 = no colisiona) no pintes
		ld hl,chgfx
		ld (grbase),hl
		ld hl,(charx)
		ld (dispx),hl
		ld a,7
		call pattr
		ld hl,(dispx)
		ld (charx),hl
pmbloc	ret

putmaskblocksincollision
		ld a,0
		ld (colisxx+1),a
		call putmaskblock
		ld a,1
		ld (colisxx+1),a
		ret

		