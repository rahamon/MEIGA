; Blocks
UpdateBlocks
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,BlkDataCode
			
				; ld hl,Lbank
				; ld a,ZERObank
				; cp (hl)				; estamos mirando al banco ZERO?
				; jp nz,UpdateLevelBankformatBlocks
				; ld bc,0				; si. No ajustes valores
			ENDIF
			
UpdateLevelBankformatBlocks			
	; Adress pointers
		; chgfx
			ld hl,(BlkDataCode + 2)
				add hl,bc
			ld (BlkDataCode + 2),hl
			ld (blkptr),hl		; en build.bat ..\tools\fart %1.asm "hl,chgfx" "hl,(blkptr)"
		; bcol
			ld hl,(BlkDataCode + 4)
				add hl,bc
			ld (BlkDataCode + 4),hl
			ld (colptr),hl		; editar ZXEngine para cambiar ld hl,(bcol) por ld hl,(colptr)
		; bprop
			ld hl,(BlkDataCode + 8)
				add hl,bc
			ld (BlkDataCode + 8),hl
			ld (proptr),hl
			ret
			