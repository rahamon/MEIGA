; User routine to merge a room on top of the existing one.
; To use, call once in the main loop 1 event following any screen redraw.
; Jonathan Cauldwell, 4th December 2020.

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
       and a               ; is it the empty block? es = 0 ?
       jr z,mroom2         ; yes, don't draw this block.
       call pattr          ; show attributes and block.
mroom3 pop hl              ; restore cell address.
       pop af              ; restore loop counter.
       dec a               ; one column fewer.
       jr nz,mroom1        ; repeat for entire line.
       ld a,(dispx)        ; x coord.
       inc a               ; move down one line.
       ld (dispx),a        ; set new position.
       pop af              ; restore row counter.
       dec a               ; one row fewer.
       jr nz,mroom0        ; repeat for all rows.
       ret
mroom2 ld hl,dispy         ; column position.
       inc (hl)            ; proceed right one cell.
       jr mroom3           ; back to decompression loop.
        