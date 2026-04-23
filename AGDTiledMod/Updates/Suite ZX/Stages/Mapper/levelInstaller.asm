; Leveler:

; Variables:
; Level_pointer_address
; Level_long_bites
; Actualiza variables del installer:
; Actualiza código del AGD. 

; LEVELZERO	equ orglevel0 <--------- CLAVE

; Seccion Map Common candidate
	; Variables
		; WINDOWTOP 8 bits
			ld a,(WINDOWTOP_ptr)
			ld (wintop),a      ; top of window.
		; WINDOWLFT 8 bits
			ld a,(WINDOWLFT_ptr)
			ld (winlft),a      ; left edge.
		; WINDOWHGT 8 bits
			ld a,(WINDOWHGT_ptr)
			ld (winhgt),a      ; window height.
		; WINDOWWID 8 bits
			ld a,(WINDOWWID_ptr)
			ld (winwid),a      ; window width.

			ld a,(wntopx_cal_ptr)
			ld (wntopx),a
			ld a,(wnlftx_cal_ptr)
			ld (wnlftx),a
			ld a,(wnbotx_cal_ptr)
			ld (wnbotx),a
			ld a,(wnrgtx_cal_ptr)
			ld (wnrgtx),a
		; MAPWID 8 bits
			ld a,(MAPWID_ptr)
			ld (tstsc+5),a
			ld (scru+4),a
			ld (scrd+4),a
			
	; Calculos
		; Adress pointers
		; mapdat-MAPWID cálculo
			ld hl,(mapdat_menos_MAPWID_cal_ptr)
			ld (tstsc+1),hl
			
	; Adress pointers
		; mapdat
			ld hl,(mapdat_ptr)
			ld (nwscr+1),hl
		; stmap
			ld hl,(stmap_ptr)
			ld (mapst+1),hl

; Events
	; Adress pointers
		; evnt00
			ld hl,(evnt00_ptr)
			ld (evtyp0),hl
		; evnt01
			ld hl,(evnt01_ptr)
			ld (evtyp1),hl
		; evnt02
			ld hl,(evnt02_ptr)
			ld (evtyp2),hl
		; evnt03
			ld hl,(evnt03_ptr)
			ld (evtyp3),hl
		; evnt04
			ld hl,(evnt04_ptr)
			ld (evtyp4),hl
		; evnt05
			ld hl,(evnt05_ptr)
			ld (evtyp5),hl
		; evnt06
			ld hl,(evnt06_ptr)
			ld (evtyp6),hl
		; evnt07
			ld hl,(evnt07_ptr)
			ld (evtyp7),hl
		; evnt08
			ld hl,(evnt08_ptr)
			ld (evtyp8),hl
		
; Arcade events
	; Common
		; Adress pointers
			; evnt09
				ld hl,(evnt09_ptr)
				ld (evis1+1),hl
				ld hl,(evnt09_ptr)
				ld (evis0+1),hl
			; evnt10
				ld hl,(evnt10_ptr)
				ld (evlp1+1),hl
			; evnt11
				ld hl,(evnt11_ptr)
				ld (evlp2+1),hl
			; evnt12
				ld hl,(evnt12_ptr)
				ld (evintr+1),hl
			; evnt13
				ld hl,(evnt13_ptr)
				ld (evini+1),hl
			; evnt14
				ld hl,(evnt14_ptr)
				ld (evrs+1),hl
			; evnt15
				ld hl,(evnt15_ptr)
				ld (evftf+1),hl
			; evnt16
				ld hl,(evnt16_ptr)
				ld (evdie+1),hl
			; evnt17
				ld hl,(evnt17_ptr)
				ld (evfail+1),hl
			; evnt18
				ld hl,(evnt18_ptr)
				ld (evwon+1),hl
			; evnt19
				ld hl,(evnt19_ptr)
				ld (evnewh+1),hl
			; evnt20
				ld hl,(evnt20_ptr)
				ld (getcol+11),hl

; Mensajes
	; Adress pointers
		; msgdat
				ld a,(msgdat_ptr)
				ld (dbox+1),hl
				ld hl,(msgdat_ptr)
				ld (dmsg+1),hl
				ld hl,(msgdat_ptr)
				ld (iscrly+4),hl
				ld hl,(msgdat_ptr)
				ld (txtpos),hl
				ld hl,(msgdat_ptr)
				ld (txtini),hl
		; nummsg: (No se usa)
			; ld(dbox+1),nummsg
			; ld(dmsg+1),nummsg

; Screens
	; Adress pointers
		; scdat
			ld hl,(scdat_ptr)
			ld (scrptr),hl
		; numsc
			ld hl,(numsc_ptr)
			ld (newlev+3),hl
			ld hl,(numsc_ptr)
			ld (groom0+5),hl
				
; Blocks
	; Adress pointers
		; chgfx
			ld hl,(chgfx_ptr)
			ld (blkptr),hl		; en build.bat ..\tools\fart %1.asm "hl,chgfx" "hl,(blkptr)"
		; bcol
			ld hl,(bcol_ptr)
			ld (colptr),hl		; editar ZXEngine para cambiar ld hl,(bcol) por ld hl,(colptr)
		; bprop
			ld hl,(bprop_ptr)
			ld (proptr),hl

; Sprites
	; Adress pointers
		; sprgfx es fija siempre
			ld hl,(sprgfx_ptr)
			ld (gspra0+10),hl
		; frmlst o
			ld hl,(frmlst_ptr)
			ld (frmptr),hl

; Sprites positions in screen
	; Adress pointers
		; nmedat
			ld hl,(nmedat_ptr)
			ld (nmeptr),hl

; Objects
	; Variables
		; NUMOBJ
			ld a,(NUMOBJ_ptr)
			ld (numob),a
	; Adress pointers
		; objdta
			ld hl,(objdta_ptr)
			ld (iniob+1),hl
			ld hl,(objdta_ptr)
			ld (shwob+1),hl
			ld hl,(objdta_ptr)
			ld (findob+1),hl
			ld hl,(objdta_ptr)
			ld (skobj+1),hl
			
; Enviroment
	; common 
		; Adress pointers
			; palett
				ld hl,(palett_ptr)
				ld (setpa1+1),hl
			; font
				ld hl,font_ptr - 256	;****
				ld (start+1),hl
			
; Jump Table
	; Adress pointers
		; jtab
			ld hl,(jtab_ptr)
			ld (iniob+1),hl
		; keys
			ld hl,(keys_ptr)
			ld (iniob+1),hl

ret ;debug
; Installers aquí:
; Los niveles se instalan así mismos, porque tienen los punteros definidos por variables que
; solo ellos conocen.

		include "Level_Map.asm"
