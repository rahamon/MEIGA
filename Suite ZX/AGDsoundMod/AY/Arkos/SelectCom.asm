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
		; check MONITOR command
		cp 36
		jp z,monitor
		ld (ctrN),a			; guardamos control en ctrN
		; Check Mute music
		cp 31					; MEIGA 2025 (antes cp 18)
		jp z,NoMusic_yesEffects
		; Chek LoopOFF command
		and a
		jp z,SetLoopOFF
		; music
		jp AY

uplayfx
		ld a,(varrnd)
		; effect: Selected effect in RND
		ld (ctrF),a
		and a
		ret z
		jp AYFX
		