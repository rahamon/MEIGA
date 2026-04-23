; Screens
UpdateScreens
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,ScrDataCode
			
				; ld hl,Lbank
				; ld a,ZERObank
				; cp (hl)				; estamos mirando al banco ZERO?
				; jp nz,UpdateLevelBankformatScreens
				; ld bc,0				; si. No ajustes valores
			ENDIF
			
UpdateLevelBankformatScreens
	; Adress pointers
		; scdat
			ld hl,(ScrDataCode + 2)		;hl=2
				add hl,bc				;hl=2+ScrDataCode
			ld (ScrDataCode + 2),hl
			ld (scrptr),hl
		; numsc
			ld hl,(ScrDataCode + 4)
				add hl,bc
			ld (ScrDataCode + 4),hl
			ld (newlev+4),hl
			; ld hl,(ScrDataCode + 4)
				; add hl,bc
			; ld (ScrDataCode + 4),hl
			ld (groom0+5),hl
			;ret
	; Variables
			ld a,(ScrDataCode + 8)
			ld (wntopx),a
			ld a,(ScrDataCode + 9)
			ld (wnlftx),a
			ld a,(ScrDataCode + 10)
			ld (wnbotx),a
			ld a,(ScrDataCode + 11)
			ld (wnrgtx),a
			
		; WINDOWTOP 8 bits
			ld a,(ScrDataCode + 12)
			ld (wintop),a      ; top of window.
		; WINDOWLFT 8 bits
			ld a,(ScrDataCode + 13)
			ld (winlft),a      ; left edge.
		; WINDOWHGT 8 bits
			ld a,(ScrDataCode + 14)
			ld (winhgt),a      ; window height.
		; WINDOWWID 8 bits
			ld a,(ScrDataCode + 15)
			ld (winwid),a      ; window width.
			
			ret
