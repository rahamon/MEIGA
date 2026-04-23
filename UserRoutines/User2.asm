
; Search for OTHER sprite with the same parameter (var A) than mine
; Por ejemplo: para buscar OTHER sprite con parametro SETTINGA (ix+11) igual al mio hacemos LET A = 11: USER n
; Encuentra OTHER sprite y devuelve A = 1 si tiene exito.
;
; 

		; Search Sprite program
		cp 0
		jp z,sksprparam
		cp 1
		jp z,sksFall
		
		; Tiles in front program
		cp 2
		jp z,wrbloc			; write data
		cp 3
		jp z,drawb			; redraw blocks
		cp 4
		jp z,inibloc		; clear data
		cp 5				; = 0 + plugin order.!
		jp z,MergeRo
		cp 6
		jp z,BigTile

		; Bring object to screen program
		cp 7
		jp z,bringobON
		cp 8
		jp z,bringobOFF		
		cp 9
		jp z,ilustrarobjeto
		cp 10
		jp z,screenjump	
		ret
		
screenjump
		;xor a
		;ld (restfl),a
		ld a,(roomtb)
		ld (vara),a
		ret
		
sksFall
		;call ifall
        call grav
		ret
		
SearchSpriteByParam		; ESTE PROGRAMA NECESITA PASAR EN LA VARA EL PARÁMETRO
		include "sksprparam.asm"
		
printblockAdventureMod
		include "PRINTinFRONTadventureMOD.asm"

Panel
		include "PanelRoom.asm"

bringob
		include "BringObjToScreen.asm"

ilustrarobjeto
		include "ilustrarobjeto.asm"

