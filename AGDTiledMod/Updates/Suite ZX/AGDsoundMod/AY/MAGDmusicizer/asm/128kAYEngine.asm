; Modulo para lanzar musica y efectos
; MUSIC AND SOUNDS

			include "BANK4memorymap.asm"

AGame		equ start
IJUMP		equ IJUMPA+$FF 			; location in memory where out jump address will be. ($nnFF<f9b6)
BASICMODE 	equ 0					; funciona desde basic

			include "musicsizes.asm"
		
			jp initPlayer 			; main call org+0 INICIADRIVERS
			
;str:		defb	"Based in AGD Musicizer by David Saphier."
gameloop:
			call IMStart
			call AGame
salirABasicScore:
			call IMOff
			ld bc,score				; return pointing to score.
			ret						; salir

initPlayer:
initSetup:	
			DEFB $3E        	    ; LD A,n
isOkinitSetup
			defb 0
			cp 1
			jp z,endinitSetup

			di
			; write ISR address to the ijunp in RAM
			call bank0
			ld hl,ISR 
			ld (IJUMP),hl
			
			; write ISR address to the ijunp in BANK4
			; call bank4	
			; ld hl,ISR 
			; ld (IJUMP),hl 
			
			
			; MUSIC setup
			call mus1
			;FX setup
			call FXsetup

			call silenc
			
			ld a,1
			ld (isOkinitSetup),a		; todo está bien			
endinitSetup
			jp gameloop
			
			include "musicplayback.asm"
			include	"routines.asm"
			include "IMroutines.asm"
			; des-compresor
			include	"zx7.asm"			
; FX and MUSIC routines
			include "AY.asm"
