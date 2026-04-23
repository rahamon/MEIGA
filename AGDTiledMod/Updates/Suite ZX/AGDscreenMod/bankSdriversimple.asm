; Installer BankS
; Cargador en banco 6 adaptado para secreens

			org 24832

Databank	equ 6

			jp InstallBankS 

InstallBankS: 	
			ld a,16					; for Divmmc
			ld (23388),a 
			;push iy
			;di
			
			; carga presentación pantalla.
			ld b,Databank
			call bankb
			ld hl,screeninc
			ld de,$c000
			call zx7bin
			; muestrala
			ld hl,$c000
			ld a,Databank
			call showSplash

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
screeninc:	; presentación pantalla.
			incbin	"screen.scr.zx7"

			
			
			
			
