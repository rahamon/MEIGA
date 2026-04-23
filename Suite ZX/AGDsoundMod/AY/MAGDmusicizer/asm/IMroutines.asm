; ---------------------------------------------------------------------
;	IMsubroutines (BANCO 2!)
; ---------------------------------------------------------------------
; interrupt routine itself

Saved7FFD defb 0
 
ISR:
		di
		push af                 ; store registers.
		push hl
		push bc
		push de
		push ix
		push iy
		exx
		ex af,af'		;'
		push af
		push hl
		push bc
		push de
		
	; reservar 7FFD MEIGA 2026 Buffer
		ld a,(23388)
		ld (Saved7FFD),a
		
		IF BASICMODE = 0
			ld a,(23672)			; store frames in a 
			inc a					; inc a 
			ld (23672),a			; write back to frames 	
		ENDIF
		
; Seccion de musica
		ld a,(ctrN)					; load a with ctrN
		; Checking
		cp 30
		jr z,contplay				; clave 30 go to contplay	
		cp 32
		jr z,skipplay				; clave 32 go to skip play IS-MUTED
		; check songs
		include "irinclude.asm"	
		; check LOOP
		ld a,(ctrN)
		and a
		jr z,loopOFF				; clave 0 LoopOff: play una sola vez.
		; check MUTE
		cp 31
		jr z, muteplay				; clave 31 this stops plackback and mutes AY (no music on launch. EmptySong).
		; todo sigue igual
		ld a,30
		ld (ctrN),a					; set clave 30 PLAYING
		jr skipplay
		
loopOFF	ld a,10
		ld (ctrN),a					; set clave new check ciclo+
		call bank4	
		ld a,1
		ld (49152+10),a				; set VTPlayerLoopFlag = 1, loopOFF.
		jr skipplay

muteplay:
		ld a,32
		ld (ctrN),a					; set clave skipplay MUTED
		call bank4				 
		call 49152 + 8				; MUTE audio 
		jr skipplay
		
contplay:
		call bank4	
		call 49152 + 5       		; PLAY the current tune
		; check end of song
		ld a,(49152+10)
		rla
        jr nc,skipCheckLoopFlag		; not ended -> nada más que checkear.
		; check loopFlag
		and a				
		jr z,skipStop				; loopFlag = 0 -> loopON, REPETIR música.
		; Stop (end of song).
		jr muteplay					; MUTE música 
		
skipStop		
skipCheckLoopFlag		
skipplay:
		;call bank0

; fx section		
		DEFB $3E        	    	; LD A,n
isOkfx	defb 0
		and a
		jr z,skipplayFX				; nada que reproducir
		call bank4
		call FX4BANK + 8			; PLAY efectos de juego
		ld a,(FX4BANK + 15)			; y Check RealaseFX
		and a
		jr nz,NextFrameFX			; no he acabado, sigue
		xor a
		ld (isOkfx),a				; al acabar resetea flag
		; Chequea la musica esta en silence?
		ld a,(ctrN)
		cp 31
		jr z,skipplayFX				; continua en silence 
		;
		ld a,30
		ld (ctrN),a					; set clave continuemusic
		;ld (UMuted),a
		jr skipplayFX
		
NextFrameFX
		ld a,32
		ld (ctrN),a					; set clave SKIP musica
		;ld (UMuted),a
		
skipplayFX
		
	; TICKER para ULABuffer y MASK MEIGA
		ld a,1
		ld (TickFlag),a	
		
	; Si hay BUFFER no salir con banco 0	
		call bank0
		
	; restaurar banco exacto anterior MEIGA BUFFER 2026
        ld a,(Saved7FFD)
        ld bc,32765
        ld (23388),a
        out (c),a

		pop de                  ; restore registers.
		pop bc
		pop hl
		pop af
		ex af,af'		;'
		exx
		pop iy
		pop ix
		pop de
		pop bc
		pop hl
		pop af
		ei	   
		IF BASICMODE = 1
		 jp 56					; set for use in basic 
		ELSE 
		 reti	 				; set for use in AGD
		ENDIF 

IMStart:
		di
		ld a, IJUMP/256
		ld i, a
		im 2
		ei
		ret       
IMOff:
		di
		im 1	
		ei
		ret
