
;Bank numbers - platform specific
nBank0 equ $C0
nBank1 equ $C4
nBank2 equ $C5
nBank3 equ $C6
nBank4 equ $C7
nBank5 equ $CC
nBank6 equ $CD
nBank7 equ $CE
nBank8 equ $CF

ScrBuffer	equ 16384
Screenbank	equ nBank6

UserScreen
			ld a,(vara)
			cp 16
			jp z,RestorePalette
			cp 18
			jp z,ShowPalette

			call SLoader
			
ShowPalette			
			ld a,16             ; colours to set.
			ld hl,LastPaltab+15     ; palette.
			call setpa0
			ret
RestorePalette
			call setpal
			ret
			
SLoader
				include "ScreenSelector.asm"				
			
		; rutinas para mover memoria entre bloques del modelo 128k
				include "swappingS.asm"		
		; rutinas para cambiar de páginado de bloques
				include	"routines.asm"
