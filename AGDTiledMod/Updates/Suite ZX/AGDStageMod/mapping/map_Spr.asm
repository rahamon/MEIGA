; Sprites
			;jp UpdateScreens
UpdateSprites
	; Adress pointers
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,SprDataCode
			ENDIF
			
			ld hl,Lbank
			ld a,Levelbank
			cp (hl)				; estamos mirando al banco de niveles?
			jp z,UpdateLevelBankformatSprites
			ld bc,0				; no. No ajustes valores
			
UpdateLevelBankformatSprites
		; sprgfx es fija siempre
			ld hl,(SprDataCode + 2)
			add hl,bc
			ld (SprDataCode + 2),hl
			ld (gspra0+10),hl
		; frmlst o
			ld hl,(SprDataCode + 4)
			add hl,bc
			ld (SprDataCode + 4),hl
			ld (frmptr),hl
			ret

