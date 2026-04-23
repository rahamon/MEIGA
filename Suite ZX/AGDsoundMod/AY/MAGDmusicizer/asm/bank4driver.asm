
			org 24832
			
			include "BANK4memorymap.asm"

			include "musicsizes.asm"

			jp InstallBank4 
			
str:		defb	"Basado en AGD Musicizer V2.1.8 by David Saphier (c)2018"

InstallBank4: 	
			ld a,16					; for Divmmc
			ld (23388),a 
			;push iy
			;di
							
			; extract music player to 49152
			; bank 4
			call bank4
			ld hl,ayplaybin
			ld de,49152
			call zx7bin
			
			; extract Fx player and effects to 61440
			; bank 4
			call bank4
			ld hl,fx4bankbin
			ld de,FX4BANK
			call zx7bin
			
			; extract all musics
			di 	
			include "musicdepacks.asm"

			call bank0

exit:
			;pop iy					; for Divmmc
			;ei
			
			ret 

			include 	"routines.asm"
			include		"zx7.asm"
			include 	"music.asm"
			defs 4,0
ayplaybin: 	; vtII playroutine Sergio Bulba
			incbin "vt49152.bin.zx7"
			defs 4,0
fx4bankbin:	; AYFxPlayer and effects
			incbin "FX4BANK.bin.zx7"
			defs 4,0

			
			
