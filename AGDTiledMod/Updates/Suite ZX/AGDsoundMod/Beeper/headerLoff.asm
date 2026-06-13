; Routines definitions reloaded 2024

		include "Unplugged.asm"

; Header o cabecera para proposito general
TAPEMODE	equ 0
			
			jp start				;org+0



	   
; MASKAGD RUTINAS
	IF MASKAGD = 1
			include "SistemaSpritesAgd_bucle_estable.asm"
	ENDIF

	IF MASKAGD = 1
			include "DobleBuffer_auxiliares.asm"
	ENDIF


FinDeCabecera	equ $
