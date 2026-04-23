; Installer BankS
; Cargador en banco 6 adaptado para secreens

			org 24832

Databank	equ 6
			;include "screensizes.asm"
			jp InstallBankS 

InstallBankS: 	
			ld a,16					; for Divmmc
			ld (23388),a 
			;push iy
			;di
			
			include "LoadDataScreens.asm"
			
			; muestra la primera como pantalla de carga
			;ld hl,$c000						;ld de,SCREEN1
			;ld a,Databank
			;call showSplash
		
exit:
			;pop iy					; for Divmmc
			;ei
			
			ret 
			; rutinas para mover memoria entre bloques del modelo 128k
			; rutinas para cambiar de páginado de bloques
			include	"routines.asm"
			; des-compresor
			include	"zx7.asm"

; Seccion de datos
			include "screens.asm"

			
			
			
