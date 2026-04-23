; Map
UpdeteWolrdMap
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,MapDataCode
			ENDIF
			
			ld hl,Lbank
			ld a,Levelbank
			cp (hl)				; estamos mirando al banco de niveles?
			jp z,UpdateLevelBankformatMap
			ld bc,0				; no. No ajustes valores
			
UpdateLevelBankformatMap			
; Seccion Map Common candidate
		; MAPWID 8 bits
			ld a,(MapDataCode+2)
			ld (tstsc+5),a
			ld (scru+4),a
			ld (scrd+4),a
			
	; Calculos
		; Adress pointers
		; mapdat-MAPWID cálculo
			ld hl,(MapDataCode + 10)
				add hl,bc
			ld (MapDataCode + 10),hl
			ld (tstsc+1),hl
			
	; Adress pointers
		; mapdat
			ld hl,(MapDataCode + 4)
				add hl,bc
			ld (MapDataCode + 4),hl
			ld (nwscr+1),hl
		; stmap
			ld hl,(MapDataCode + 8)
				add hl,bc
			ld (MapDataCode + 8),hl
			ld (mapst+1),hl
			ret
			