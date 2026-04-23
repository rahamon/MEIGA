; Events
UpdateEvents
			;IF TAPEMODE = 1
				ld bc,0
			;ELSE
				;ld bc,EveDataCode
			
				; ld hl,Lbank
				; ld a,ZERObank
				; cp (hl)				; estamos mirando al banco ZERO?
				; jp nz,UpdateLevelBankformatSprites
				; ld bc,0				; si. No ajustes valores
			;ENDIF
			
UpdateLevelBankformatEvents
	; Adress pointers
		; evnt00
			ld hl,(EveDataCode + 2)
			add hl,bc
			ld (EveDataCode + 2),hl
			ld (evtyp0),hl
		; evnt01
			ld hl,(EveDataCode + 4)
			add hl,bc
			ld (EveDataCode + 4),hl
			ld (evtyp1),hl
		; evnt02
			ld hl,(EveDataCode + 8)
			add hl,bc
			ld (EveDataCode + 8),hl
			ld (evtyp2),hl
		; evnt03
			ld hl,(EveDataCode + 10)
			add hl,bc
			ld (EveDataCode + 10),hl
			ld (evtyp3),hl
		; evnt04
			ld hl,(EveDataCode + 12)
			add hl,bc
			ld (EveDataCode + 12),hl
			ld (evtyp4),hl
		; evnt05
			ld hl,(EveDataCode + 14)
			add hl,bc
			ld (EveDataCode + 14),hl
			ld (evtyp5),hl
		; evnt06
			ld hl,(EveDataCode + 16)
			add hl,bc
			ld (EveDataCode + 16),hl
			ld (evtyp6),hl
		; evnt07
			ld hl,(EveDataCode + 18)
			add hl,bc
			ld (EveDataCode + 18),hl
			ld (evtyp7),hl
		; evnt08
			ld hl,(EveDataCode + 20)
			add hl,bc
			ld (EveDataCode + 20),hl
			ld (evtyp8),hl
		;test
			ret
