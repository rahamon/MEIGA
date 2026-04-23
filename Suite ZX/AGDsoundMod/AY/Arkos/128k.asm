;IJUMP		equ	$f8FF
IJUMP		equ IJUMPA+$FF
PLAY4BANK	equ 49152
AGame		equ start

gameloop:
			call InitPLayer				; con EmtySong
			call IMStart
			call AGame					; Arcade Game
salirABasicScore:
			call IMOff
			ld bc,score					; return pointing to score.
			ret							; salir
			
; -----------------------------------------------------
; Fx routines 	
; -----------------------------------------------------

comando_InitSoundEffects	equ PLAY4BANK+15
comando_PlaySoundEffect		equ PLAY4BANK+18
dir_SoundEffects			equ PLAY4BANK+21

; Main effects
AYFX
	; selecciona efecto
		ld a,(ctrF)						; sound to play.
		and a							; any sound?
		jp z,exitFX						; no.
		call bank4
		ld c,1
		ld b,0							; Full volume.
		ld a,(ctrF)						; sound to play.
		call comando_PlaySoundEffect
		call bank0
fxsnded	xor a
		ld (ctrF),a						; ready again
exitFX	ret
	

; -----------------------------------------------------
; Music Routines
; -----------------------------------------------------

comando_Init			equ PLAY4BANK+0
comando_Play			equ PLAY4BANK+3
comando_STOP			equ PLAY4BANK+6
dir_MUSICDATA			equ PLAY4BANK+9
dir_EMPTYSONG			equ PLAY4BANK+11
dir_EndofthesongAddr	equ PLAY4BANK+13

; User_command
isnd	ret

		include "isnd.asm"

; Main_music
AY
		; Inicia Musica Subsong:
		call bank4
		ld a,(ctrN)						; Subsong a. GUARDAR EN ROM
        ld hl,(dir_MUSICDATA)
		dec a
        call comando_Init				; INIT
		call ResetEndofthesongflag
		call bank0
		; reset LoopTunflag (1 por defecto)
		ld a,1
		ld (LoopTun),a 
		; skipoff
		call skipOFF
		ret

ISR
 	; ISR pre:
		di
		push af               			; store registers.
		push hl
		push bc
		push de
		push ix
		push iy
			exx
			ex af,af'				;'
				push af
				push hl
				push bc
				push de
												; set for use in basic 
				ld a,(23672)					; store frames in a 
				inc a							; inc a 
				ld (23672),a					; write back to frames 

	; check if music is started
				DEFB $3E				; LD A,n
music_Started	defb 0
				and a
				jr z,skipplay
				
	; check sound MUTED
				DEFB $3E            	; LD A,n
SkipOnOff		defb 0
				cp 1
				jr z,skipplay
				
				call bank4
				call comando_Play		; PLAY
				;call bank0***
				; checkloop
				DEFB $3E            	; LD A,n
LoopTun			defb 0
				cp 1
				jr z,skipchekend
				; check final de musica
				;call bank4***
				ld hl,(dir_EndofthesongAddr)
				ld a,(hl)
				cp 1					; 1 = ended
				call z,Mute_Music
skipchekend
skipplay
				call bank0

	; ISR post: restore registers.
				pop de                  ; restore registers.
				pop bc
				pop hl
				pop af		
			ex af,af'				;'
			exx
		pop iy
		pop ix
		pop de
		pop bc
		pop hl
		pop af
		ei
		reti
		;jp 56					; set for use in basic 

silenc
		call PLY_SkipOnOff
		ret
		
NoMusic_yesEffects
		call bank4
		call Mute_Music
		call bank0
		ret

Mute_Music
		;InitEmptySong
		;call bank4
		ld hl,(dir_EMPTYSONG)
		xor a                   ; Subsong 0.
		call comando_Init		; INIT
		call ResetEndofthesongflag
		;call bank0
		ld a,1
		ld (LoopTun),a			; LoopTun = 1 (por defecto)
		ret

PLY_SkipOnOff:
		ld a,(SkipOnOff)
		cp 1
		jr z,skipOFF
skipON	ld a,1
		ld (SkipOnOff),a
		call StopMusic
		ret
skipOFF xor a
		ld (SkipOnOff),a
		ret

ResetEndofthesongflag
		; reset Endofthesongflag
		xor a
		ld hl,(dir_EndofthesongAddr)
		ld (hl),a
		ret

StopMusic:
		; test
        ; di
        ; ex af,af'	;'
        ; exx
                ; ;Same as above.
                ; push af
                ; push bc
				; push de
				; push hl
                ; push ix
                ; push iy
					call bank4
					call comando_STOP
					call bank0
                ; pop iy
                ; pop ix
				; pop hl
				; pop de
                ; pop bc
                ; pop af
        ; ex af,af'	;'
        ; exx
        ; ei   
        ret

;Initializes the music and the effects.

InitPLayer:
		call bank4
		call Mute_Music
		call ResetEndofthesongflag
		;call bank0
		; PLAY flag = 1
		ld a,1
		ld (music_Started),a
InitFX:			
		;call bank4
		ld hl,(dir_SoundEffects)
		call comando_InitSoundEffects
		call bank0
		; skipOFF
		call skipOFF
		ret
			
; subroutines 

IMStart:             			; initializes interrupts
		ld hl,ISR				; poke IJUMP con ISR address
		ld (IJUMP),hl
		di
		ld hl,IJUMP   			; i table (256 bytes buffer) at this address, must 	not exceed 64768 (AGD sprite buffer)
		ld a,h
		ld i,a
		im 2
		ei
		ret

IMOff:							; disables music - CALL point here in the Lost Game and Completed Game events
		di
		im 1	
		ei
		ret	
	
;routines
		include "routines.asm"
; des-compresor
		include	"zx7.asm"
