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
		jp beeper
		;ret

uplayfx		
		ld a,(varrnd)
		call fxsnd
		ret
		