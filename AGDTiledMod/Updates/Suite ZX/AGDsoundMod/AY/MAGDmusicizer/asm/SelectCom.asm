; Selector de Comandos de usuario
; MEIGA 2025
; rutina en a
; comando en RND
; ejemplo: "PLAYMUSIC 1" "LET RND = 1 USER 100"
; ejemplo: "PLAYFX 5" "LET RND = 5 USER 101"

		cp 100
		jp z,uplaymusic
		cp 101
		jp z,uplayfx
		;ret
		jp user1
		
uplaymusic
		ld a,(varrnd)
		; check monitor
		cp 36
		jp z,monitor
		ld (ctrN),a			; guardamos control en ctrN
	; DELAY 1
		push ix
		ld b,1
		call delay
		pop ix
	; SALIR
		ret

uplayfx		
		ld a,(varrnd)
		ld (ctrF),a
		and a
		ret z				; efect to play. (n>0)
		ld c,a
		ld a,(olFXnum)
		cp c
		jp z,playSelected
		ld (olFXnum),a
		jp FX_Selector

olFXnum	defb 0

