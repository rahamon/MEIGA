; 	Chequear sonido, comando o efecto

FX_Selector
		;
		di
			ld a,(23672)			; store frames in a 
		push af
		push bc
		push de
		push hl
		push ix
			
			call Selectfx			; SELECT FX from banck

		pop ix
		pop hl
		pop de
		pop bc
		pop af
			ld (23672),a			; write back to frames 
		ei
		
invalid_fx
		ret
		
monitor
		; push ix
		; ld b,2
		; call delay
		; pop ix
		ld a,(ctrN)
		cp 30
		jr z,sonando
nosuena	xor a
		jr testigo
sonando	ld a,1
testigo	ld (vara),a
		ret
		
chkcom	defb 0
ctrN	defb 0				; SOUND CONTROL
ctrF	defb 0				; FX CONTROL
;UMuted	defb 0				; silenced by user

