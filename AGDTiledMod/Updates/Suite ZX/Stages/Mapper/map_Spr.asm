; Sprites
			;jp UpdateScreens
UpdateSprites
	; Adress pointers
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,SprDataCode
			
				; ld hl,Lbank
				; ld a,ZERObank
				; cp (hl)				; estamos mirando al banco ZERO?
				; jp nz,UpdateLevelBankformatSprites
				; ld bc,0				; si. No ajustes valores
			ENDIF
			
UpdateLevelBankformatSprites
		; sprgfx es fija siempre
			ld hl,(SprDataCode + 2)
			add hl,bc
			ld (SprDataCode + 2),hl
			ld (gspra0+10),hl
			;ret 		; MEIGA test, comentar para volver a version original
			
		; frmlst
			ld hl,(SprDataCode + 4)
			add hl,bc
			ld (SprDataCode + 4),hl
			ld (frmptr),hl
			ret

