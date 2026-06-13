
; CHECK cassette KEY COMMAND
		defb $3E							;ld a,N
playkey	defb 255	
		and a
		jp z,loadTape						; si S = 255 -> continua cargando
		

