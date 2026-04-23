
; Bank numbers - platform specific
; nBank0 equ $C0
; nBank1 equ $C4
; nBank2 equ $C5
; nBank3 equ $C6
; nBank4 equ $C7
; nBank5 equ $CC
; nBank6 equ $CD
; nBank7 equ $CE
; nBank8 equ $CF

; Driver bank
PLAY4BANK	equ $4000

; Correspondencias
PLY_AKG_Init						equ PLAY4BANK+0
PLY_AKG_PLAY						equ PLAY4BANK+3
PLY_AKG_Stop						equ	PLAY4BANK+6
Music_Start							equ PLAY4BANK+9
Empty_music							equ PLAY4BANK+11
PLY_AKG_InitSoundEffects			equ PLAY4BANK+15
PLY_AKG_PlaySoundEffect				equ PLAY4BANK+18
SoundEffects						equ PLAY4BANK+21
PLY_AKG_StopSoundEffectFromChannel	equ PLAY4BANK+25

; 	Chequear sonido, comando o efecto
		
		; LET A = , CALL 8198
		ld a,(vara)
		ld (chkcom),a		; Guardamos n en chkcom
		; Chequear si es efecto de sonido
		ld a,100
		ld hl,chkcom
		cp (hl)
		jp c,FX_Selector	; if chkcom > 100
		jp z,invalid_fx		; if chkcom = 100
		
no_es_efecto				; chkcom < 100
		ld a,(chkcom)
		cp 96				; play one note
		jp z,PLY_PlaySong
		cp 18				; stop and rewind
		jp z,PLY_StopSong
		cp 19				; no es usado generalmente
		jp z,PLY_StopSfx
		cp 20				; pause on-off
		jp z,PLY_SkipOnOff
		
		jp inicia_musica

es_efecto
FX_Selector
		ld c,100
		ld a,(chkcom)
		sub c			 	; subtract 100 to comando
		ld (SelectedSoundEffect),a
		jp PLY_PlaySfx
invalid_fx
		ret					; efecto 0 no válido
		
chkcom	defb 0				; Comando
		
		;Initializes the music.
inicia_musica
		call bank5
		ld hl,(Music_Start)			; direccion de la musica
		;Subsong in a.
		ld a,(chkcom)
		dec a
		call PLY_AKG_Init
		call bank0
		ld a,1
		ld (music_Started),a			; PLAY flag = 1
		call skipOFF
		ret
	
        ;Calls the player
PLY_PlaySong:
		; check if music is sterted
		DEFB $3E						; LD A,n
music_Started	defb 0
		cp 1
		jp z,Play
Mute_Music:
        ;Initializes the Empty Music. Useful to listen to the sound effects alone.
        call bank5
        ld hl,(Empty_music)
        xor a                   		;Subsong 0.
		call PLY_AKG_Init
		ld a,1
		ld (music_Started),a			; PLAY flag = 1		
		
Setup_SoundEffects:
		;check sound effects setup
		DEFB $3E						; LD A,n
effects_started:	defb 0
		cp 1
		jp z,skipsetup
		
        ;Initializes the sound effects.
		;call bank5
        ld hl,(SoundEffects)
        call PLY_AKG_InitSoundEffects
		;call bank0
		ld a,1
		ld (effects_started),a			; Setup flag = 1
skipsetup
		call bank0
		ret
	
Play:
		di
        ex af,af'	;'
        exx
                ;Only a few registers needs to be saved as the system requires them.
                push af
                push bc
                push ix
                push iy
				DEFB $3E            	; LD A,n
SkipOnOff		defb 0
				cp 1
				jr z,skipplaynote					
				call bank5
				call PLY_AKG_PLAY
				call bank0
skipplaynote    pop iy
                pop ix
                pop bc
                pop af
        ex af,af'	;'
        exx
        ei
        ret

PLY_StopSong:
		call StopMusic
		call Mute_Music
		ret
		
StopMusic:
		;test
        di
        ex af,af'	;'
        exx
                ;Same as above.
                push af
                push bc
                push ix
                push iy
				call bank5
				call PLY_AKG_Stop
                call bank0
				pop iy
                pop ix
                pop bc
                pop af
        ex af,af'	;'
        exx
        ei   
        ret

PLY_PlaySfx:
PlayOnChannel2:
		call bank5
        ld c,0
PlayOnChannelShared:
        ld a,(SelectedSoundEffect)
        ld b,0          ;Full volume.
        call PLY_AKG_PlaySoundEffect 
        call bank0
		ret

PLY_StopSfx:
StopChannel2:
		call bank5
        ld a,1
StopChannelShared:
        call PLY_AKG_StopSoundEffectFromChannel
        call bank0
		ret

PLY_SkipOnOff:
			ld a,(SkipOnOff)
			cp 1
			jr z,switchskip
skipON		ld a,1
			ld (SkipOnOff),a
			call StopMusic
			ret
skipOFF
switchskip	xor a
			ld (SkipOnOff),a
			ret


SelectedSoundEffect: db 1                       ;The selected sound effect (>=1).
SelectedSubsong: db 0                       	;The selected subsong (>=0).
