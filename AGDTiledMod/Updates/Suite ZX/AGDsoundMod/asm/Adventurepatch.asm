;
; Write block adventure plugin on-off patch
; MEIGA by Ramon Fernandez Ameijeiras 2024
;
; To switch on: call wonoon
; To switch off: call wonoof
; Include this commands in your UserSelector Routines.
;
wbloc	ld hl,(pbptr)
		ld b,a
		defb $3E
wonof	defb 0			; interruptor adventure on-off
		and a			; it is off?
		jr nz,wonof0	; no, continue.
		ld a,b
		ret				; it is off, go back
; switcher on-off
wonoon	ld a,1
		jr swono
wonoof	xor a
swono	ld (wonof),a
		ret
; continue
wonof0	ld a,b

