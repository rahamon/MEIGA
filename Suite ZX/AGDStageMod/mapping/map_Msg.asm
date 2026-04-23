; Mensajes
UpdeteMensajes
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,MsgDataCode
			ENDIF
			
			ld hl,Lbank
			ld a,Levelbank
			cp (hl)				; estamos mirando al banco de niveles?
			jp z,UpdateLevelBankformatMensajes
			ld bc,0				; no. No ajustes valores
			
UpdateLevelBankformatMensajes			
		;jp UpdeteSpritespositions
	; Adress pointers
		; msgdat
				ld hl,(MsgDataCode +2)
				add hl,bc
				ld (MsgDataCode +2),hl
				ld (dbox+1),hl
				
				; ld hl,(MsgDataCode +2)
				; add hl,bc
				; ld (MsgDataCode +2),hl
				ld (dmsg+1),hl
				
				; ld hl,(MsgDataCode +2)
				; add hl,bc
				; ld (MsgDataCode +2),hl
				ld (iscrly+4),hl
				
				; ld hl,(MsgDataCode +2)
				; add hl,bc
				; ld (MsgDataCode +2),hl
				ld (txtpos),hl
				
				; ld hl,(MsgDataCode +2)
				; add hl,bc
				; ld (MsgDataCode +2),hl
				ld (txtini),hl
				
		; nummsg: (No se usa)
			; ld(dbox+1),nummsg
			; ld(dmsg+1),nummsg
				ret
			