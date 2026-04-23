; Redibuja sprites
redrwsprites
		push ix             ; place sprite pointer on stack.

		ld b,NUMSPR         ; sprites to draw.
		ld ix,sprtab        ; sprite table.
rdrwsp0 ld a,(ix+0)         ; old sprite type.
		inc a               ; is it enabled?
		jr z,rdrwsp1         ; no, find next one.

; limpia (redraw) old sprites and special effects
		push bc             ; store sprite counter.
		call sspria         ; show single sprite. ***
		pop bc              ; retrieve sprite counter.

rdrwsp1 ld de,TABSIZ        ; distance to next odd/even entry.
		add ix,de           ; next sprite.
		djnz rdrwsp0         ; repeat for remaining sprites.
		;call rbloc           redraw blocks if in adventure mode. LIMITACION
		call dshrp          ; redraw shrapnel.
		pop ix              ; retrieve sprite pointer.
		ret
		