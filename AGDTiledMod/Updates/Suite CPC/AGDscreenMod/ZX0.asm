; Généré par ConvImgCpcV 1.0.8987.20325 - 09/08/2024 - le 13/09/2024 (10 22 43)
; Mode écran - Mode 0
; Taille (nbColsxNbLignes) 80x200

TestJoda_pluscode
		
	jr _StartDepack

Palettepoiter		defw 0		; org+3
PackedImgpointer	defw 0		; org+6
LogImgData			defw 0


_StartDepack:
	
	LD HL,(PackedImgpointer)
	LD DE,ScreenCPC
	CALL Depack
	RET
		
TstSpace1:
	LD	BC,#F40E
	OUT	(C),C
	LD	BC,#F6C0
	OUT	(C),C
	XOR	A
	OUT	(C),A
	LD	BC,#F792
	OUT	(C),C
	LD	BC,#F645
	OUT	(C),C
	LD	B,#F4
	IN	A,(C)
	LD	BC,#F782
	OUT	(C),C
	LD	BC,#F600
	OUT	(C),C
	INC	A
	JR	Z,TstSpace1
	RET
	
; Decompactage
Depack:
	ld	bc,#ffff			; preserve default offset 1
	push	bc
	inc	bc
	ld	a,#80
dzx0s_literals:
	call	dzx0s_elias		; obtain length
	ldir					; copy literals
	add	a,a					; copy from last offset or new offset?
	jr	c,dzx0s_new_offset
	call	dzx0s_elias		; obtain length
dzx0s_copy:
	ex	(sp),hl				; preserve source,restore offset
	push	hl				; preserve offset
	add	hl,de				; calculate destination - offset
	ldir					; copy from offset
	pop	hl					; restore offset
	ex	(sp),hl				; preserve offset,restore source
	add	a,a					; copy from literals or new offset?
	jr	nc,dzx0s_literals
dzx0s_new_offset:
	call	dzx0s_elias		; obtain offset MSB
	ld b,a
	pop	af					; discard last offset
	xor	a					; adjust for negative offset
	sub	c
	RET	Z		; Plus d'octets à traiter = fini

	ld	c,a
	ld	a,b
	ld	b,c
	ld	c,(hl)				; obtain offset LSB
	inc	hl
	rr	b					; last offset bit becomes first length bit
	rr	c
	push	bc				; preserve new offset
	ld	bc,1				; obtain length
	call	nc,dzx0s_elias_backtrack
	inc	bc
	jr	dzx0s_copy
dzx0s_elias:
	inc	c					; interlaced Elias gamma coding
dzx0s_elias_loop:
	add	a,a
	jr	nz,dzx0s_elias_skip
	ld	a,(hl)				; load another group of 8 bits
	inc	hl
	rla
dzx0s_elias_skip:
	ret 	c
dzx0s_elias_backtrack:
	add	a,a
	rl	c
	rl	b
	jr	dzx0s_elias_loop

	