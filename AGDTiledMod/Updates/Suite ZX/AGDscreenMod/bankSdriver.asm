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
			
			; por cada pantalla en screens directory:
			; carga presentación pantalla.
			ld hl,screeninc
			ld de,$c000						;ld de,SCREEN1
			ld bc,2800						;LONGSCREEN1 equ 2796 aprox
			ld a,Databank
			call SaveToBank					; swap y vuelve a bank0
			
			; muestra la primera como pantalla de carga
			ld hl,$c000						;ld de,SCREEN1
			ld a,Databank
			call showSplash
			
			; carga presentación pantalla 2.
			; por cada pantalla en screens directory:
			; carga presentación pantalla.
			ld hl,screeninc2
			ld de,$c000 + 2800				;ld de,SCREEN2
			ld bc,2800						;LONGSCREEN2 equ 2796 aprox
			ld a,Databank
			call SaveToBank					; swap y vuelve a bank0


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
screeninc2:	; presentación pantalla 2. Para xavisan
			incbin	"screen2.scr.zx7"
			
			
			
			
