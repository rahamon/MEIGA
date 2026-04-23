; Search for OTHER sprite with the same parameter (var A) than mine
; Por ejemplo: para buscar OTHER sprite con parametro SETTINGA (ix+11) igual al mio hacemos LET A = 11: USER n
; Encuentra OTHER sprite y devuelve A = 1 si tiene exito.
;
; 
user	equ $
		; Search Sprite program
		cp 0
		jp z,sksprparam
		
		; Tiles in front program
		cp 2
		jp z,wrbloc			; write data
		cp 3
		jp z,drawb			; redraw blocks
		cp 4
		jp z,inibloc		; clear data

		ret

SearchSpriteByParam		; ESTE PROGRAMA NECESITA PASAR EN LA VARA EL PARÁMETRO
		include "sksprparam.asm"
		
printblockAdventureMod
		include "PRINTinFRONTadventureMOD.asm"

