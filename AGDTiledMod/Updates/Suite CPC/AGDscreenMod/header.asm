; Header o cabecera para proposito general

		jp start									; org+0
		jp UserScrRoutines							; org+3
		jp UserPlayerAkgWithSoundEffect_CPCRoutines	; org+6
		
UserScrRoutines
		include "ScreenPlayer.asm"
		
UserPlayerAkgWithSoundEffect_CPCRoutines
		include "UserPlayerAkgWithSoundEffect_CPC.asm"
		
start  equ $
