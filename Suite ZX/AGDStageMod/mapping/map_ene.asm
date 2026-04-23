; Sprites positions in screen
UpdeteSpritespositions
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,EneDataCode
			ENDIF
			
			ld hl,Lbank
			ld a,Levelbank
			cp (hl)				; estamos mirando al banco de niveles?
			jp z,UpdateLevelBankformatSpritespositions
			ld bc,0				; no. No ajustes valores
			
UpdateLevelBankformatSpritespositions			
	; Adress pointers
		; nmedat
			ld hl,(EneDataCode + 2)
				add hl,bc
			ld (EneDataCode + 2),hl
			ld (nmeptr),hl
			ret

