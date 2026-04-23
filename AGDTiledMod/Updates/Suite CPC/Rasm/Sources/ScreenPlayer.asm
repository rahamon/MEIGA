
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

ScrBuffer	equ $4000
Screenbank	equ nBank4

UserScreen
			ld a,(vara)
			call SLoader
			call SetHardwarePalette
			ret

SLoader
			include "ScreenSelector.asm"

			; rutinas para mover memoria entre bloques del modelo 128k
			include "swappingS.asm"
			; rutinas para cambiar de páginado de bloques
			include	"routines.asm"
