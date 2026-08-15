; -----------------------------------------------------------------------------
; Initialise a sound.
; -----------------------------------------------------------------------------

isnd	ret

		include "isnd.asm"

; Mute music Player On-Off.
silenc	ld a,(ctrN)
		;ld a,(UMuted)
		cp 31
		jr z,MuteOff
		cp 32
		jr z,MuteOff
MuteOn	ld a,31					; MUTE music EmptySong USER Command
		;ld (ctrN),a
		jr silenc1
MuteOff	ld a,30
silenc1	ld (ctrN),a
		;ld (UMuted),a
		ret
		
; restaura player			
msetup:
		;di			 ; MEIGA11 comentar di
		ld a,10					; clave new check ciclo+
		ld (ctrN),a
		call bank4
		xor a
		ld (49152+10),a				; set VTPlayerLoopFlag = 1, loopOFF.
		push hl 
		call 49152 + 8			; MUTE	
		pop hl 
		call 49152 + 3			; POINTING TO Module
		;ei	; Recomendacion MEIGA11
		ret 	

; -----------------------------------------------------------------------------
; AY FX Routines
; -----------------------------------------------------------------------------

			
fxsnd	ret

FXsetup						; inicializacion de FXplayer
		
		call bank4
		ld hl,(FX4BANK)
		call FX4BANK + 2	; AFXINIT
		call bank0
				
		xor a
		ld (isOkfx),a		; RESET flag PLAY
		
		ret
		
Selectfx					; SELECT efecto
		call bank4
		ld a,(ctrF)			; efect to play.(n>0)
		ld c,a
		dec c				; c = ctrF -1
		; Chequera FX (c)	***
		ld hl,(FX4BANK)
		ld a,(hl)
		dec a				; a = total_FX - 1
		cp c				; verifique el efecto (c) existe en el banco
		jr c,playSfx2		; el banco no tiene tantos efectos
		; lanzar el efecto (c)
		ld a,c
		;call FX4BANK + 5	 AFXPLAY
		ld e,MODECANAL
		call FX4BANK + 11	; AFXPLAYChannel
		call bank0
playSelected
		ld (isOkfx),a		; ALGO para PLAYFX
		ret
playSfx2
		call bank0
		xor a
		ld (isOkfx),a		; NADA para PLAYFX
		ret

	
	
