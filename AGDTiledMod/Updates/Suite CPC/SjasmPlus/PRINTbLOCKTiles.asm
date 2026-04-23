; User routine to merge a room on top of the existing one.
; To use, call once in the main loop 1 event following any screen redraw.
; Jonathan Cauldwell, 4th December 2020.

	   ld a,(vara)

mroom  ld hl,(blkptr)      ; blocks.
       ld (grbase),hl      ; set graphics base.
       call groomx         ; get address of current room.
       ld a,(wintop)       ; window top.
       ld (dispx),a        ; set x coordinate.
       xor a               ; zero in accumulator.
       ld (comcnt),a       ; reset compression counter.
       ld a,(winhgt)       ; height of window.
mroom0 push af             ; store row counter.
       ld a,(winlft)       ; window left edge.
       ld (dispy),a        ; set cursor position.
       ld a,(winwid)       ; width of window.
mroom1 push af             ; store column counter.
       call flbyt          ; decompress next byte on the fly.
       push hl             ; store address of cell.
       and a               ; is it the empty block a = 0?
       jr z,mroom2         ; yes, don't draw this block.
	   ;call pattr          ; show attributes and block.
	   jp mpattr          ; show attributes and block.
mroom3 pop hl              ; restore cell address.
       pop af              ; restore loop counter. (column)
       dec a               ; one column fewer.
       jr nz,mroom1        ; repeat for entire line.
       ld a,(dispx)        ; x coord.
       inc a               ; move down one line.
       ld (dispx),a        ; set new position.
       pop af              ; restore row counter. (row)
       dec a               ; one row fewer.
       jr nz,mroom0        ; repeat for all rows.
       ret
	   
	   
mroom2 ld hl,dispy         ; column position.
       inc (hl)            ; proceed right one cell.
       jr mroom3           ; back to decompression loop.

mpattr ld b,a              ; store cell in b register for now.
       ld e,a              ; displacement in e.
       ld d,0              ; no high byte.
       ld hl,(proptr)      ; pointer to properties.
       add hl,de           ; property cell address.
       ld c,(hl)           ; fetch byte.
       ld a,c              ; put into accumulator.
       cp CUSTOM           ; is it a CUSTOM/WATER?
       jp z,mpattr1        ; SI, PASAR AL FRENTE.
	   ld a,b				;
	   ret
       jp mroom2			; no lo paso al frente
	   
mpattr1
       ; write block in-front
	   ld a,(varu)
	   inc a
	   ld (varu),a
       ld a,b              ; get block number.
	   ld (varc),a
	   ld a,(dispy)        ; x coord.
	   ld (vara),a
       ld a,(dispx)        ; x coord.
	   ld (varb),a
	   ld a,2
	   call user
	   ret
	   jp mroom2
