
;STOP CASSETTE and Install pointers Stage
		
			call StageUpdate
				
	; STOP el cassette KEY COMMAND
			ld a,255
			ld (playkey),a					; Stop cassette

	; Check First Game
			defb $3E						; ld a,N
FirstGame	defb 0
			and a							; es mi primera carga?
			jp z,firstg					; nunca habia jugado, es mi primera vez

			call SetMapStartPo
			
			; opcional, call evnt12 o call evnt13 para menu de carga o screen X para menu de juego...
			;call redraw			;solucion menos mala
			
			jp mloop
		
firstg		ld a,1
			ld (FirstGame),a
			jp game							; start the First game BASIC mode 
		
ResetMapStartPo
			xor a
			ld (FixedPo),a
			ret
			
SetMapStartPo			
	; Corrige desplazamiento (en registro b) por datos de screens en datos de secciones
			;ld hl,FixedDe48
			;ld a,(scno)
			;sub (hl)
			;ld (scno),a						; SCNO-DESPL

	; check start position corregido
			defb $3E						; ld a,N
FixedPo		defb 0		; fijado nuevo mapa flag
			and a
			ret nz				; si a <> 0 -> return
			
	; Corrige start position in MAP
			ld hl,(mapst+1)
			ld a,(hl)
			ld (roomtb),a
	
			ld a,1				; ahora esta corregido 	
			ld (FixedPo),a
			ret
			
; LOAD ""CODE
loadTape
			ld hl,10072
			exx
			ld bc,(TapeNamePointer)
			ret							; return to BASIC
