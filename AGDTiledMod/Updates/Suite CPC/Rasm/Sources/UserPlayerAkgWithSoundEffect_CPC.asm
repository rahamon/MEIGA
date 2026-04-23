; 	Chequear sonido, comando o efecto
		
		; USER n
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
		ld hl,Music_Start
		;Subsong in a.
		call PLY_AKG_Init
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
        ld hl,Empty_music
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
        ld hl,SoundEffects
        call PLY_AKG_InitSoundEffects
		ld a,1
		ld (effects_started),a			; Setup flag = 1
skipsetup
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
				call PLY_AKG_PLAY				
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
		; test
        di
        ex af,af'	;'
        exx
                ;Same as above.
                push af
                push bc
                push ix
                push iy
				call PLY_AKG_Stop
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
        ld c,0
PlayOnChannelShared:
        ld a,(SelectedSoundEffect)
        ld b,0          ;Full volume.
        call PLY_AKG_PlaySoundEffect 
        ret

PLY_StopSfx:
StopChannel2:
        ld a,1
StopChannelShared:
        call PLY_AKG_StopSoundEffectFromChannel
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

Main_Player_Start:
        ;IMPORTANT: enables the sound effects in the player. This must be declared BEFORE the player itself.
        PLY_AKG_MANAGE_SOUND_EFFECTS equ 1
        
        ;Want a ROM player (a player without automodification)?
        ;PLY_AKG_Rom = 1                         ;Must be set BEFORE the player is included.
            
        ;Include here the Player Configuration source of the songs (you can generate them with AT2 while exporting the songs).
        ;If you don't have any, the player will use a default Configuration (full code used), which may not be optimal.
        ;If you have several songs, include all their configuration here, their flags will stack up!
        ;Warning, this must be included BEFORE the player is compiled.
        ;Warning, if you use player configuration, you must ALSO include the configuration file for the sound effects.
        ;include "../resources/AKMusic_playerconfig.asm"

        include "PlayerAkg.asm"
                
Main_Player_End:

Music_Start:       
        include "../resources/AKMusic.asm"
Empty_music:
        include "../resources/Music_Empty.asm"		;Useful to listen to the sound effects alone.	
Music_End:

SoundEffects:
        include "../resources/AKFX.asm"

		defs 10,0
		
