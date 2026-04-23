; chequear sonido, comando o efecto

monitor
		; check final de musica
		ld a,(SkipOnOff)
		ld (vara),a
		ret

SetLoopOFF
		xor a
		ld (LoopTun),a			; LoopTun = 0 -> desactiva loop
		ret
		
chkcom	defb 0
ctrN	defb 0					; SOUND CONTROL
ctrF	defb 0					; FX CONTROL
