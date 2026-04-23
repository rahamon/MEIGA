; Sprites positions in screen
UpdeteSpritespositions
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,EneDataCode
			
				; ld hl,Lbank
				; ld a,ZERObank
				; cp (hl)				; estamos mirando al banco ZERO?
				; jp nz,UpdateLevelBankformatSpritespositions
				; ld bc,0				; si. No ajustes valores
			ENDIF
			
UpdateLevelBankformatSpritespositions			
	; Adress pointers
		; nmedat
			ld hl,(EneDataCode + 2)
				add hl,bc
			ld (EneDataCode + 2),hl
			ld (nmeptr),hl
			ret

