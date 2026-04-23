
; MEIGA 2024 Ramon Fernandez Ameijeiras
; StageUser48k

	; check loading cassette
	; Indica si el Escenario tiene varias cargas desde cinta de paginas de datos 0=ready,255=Stop
		ld a,(playkey)
		cp 255
		ret nz						; is loading -> Back to
		
	; CHECK Comando ResetMapStartPo
		ld a,(vara)
		cp 32
		jp z,ResetMapStartPo
		cp 33
		jp z,FixScreen
		cp 34
		jp z,SetFixedDe48
		
	; Check lastStage
		ld hl,lastStage
		ld a,(vara)
		cp (hl)	
		jp nz,NewStage48	; is NOT the same stage -> Load new Stage
		
		ret					; revisar!
			
	; Fix screens in this Stage from OffSetDesplazamiento
FixScreen		; no debería estar aqui***
		ld hl,FixedDe48
		ld a,(scno)
		sub (hl)
		ld (scno),a					; SCNO-DESPL
		; TEST
		;ld hl,roomtb
		;ld a,(hl)
		ld (varn),a
		;call droom	
		ret
		
SetFixedDe48
		ld a,(varb)
		ld (FixedDe48),a			; store B (ofset desplazamiento scno)
		ret
			
FixedDe48	
		defb 0					; Desplazamiento fijado para cálculo de scno
			
NewStage48		
		ld (lastStage),a			; last selected Stage is this now.
		
	; Tapeselector
	; CHECK Stage number
		ld a,(vara)
		
		include "Tapselector.asm"
	; setup nombres de pista en cinta
		include "SetupTaps.asm"

setupStageTape
		ld (TapeNamePointer),hl		; actualiza StagePointer
		
	;playcassete
		ld a,0
		ld (playkey),a				; S = 0 -> "play again"
		ret
   
TapeNamePointer
		defw TapZERO

; world
; Tapename
names
		include "Taps.asm"

