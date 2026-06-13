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
		
		ret
		
sksFall
		;call ifall
        call grav
		ret
		
SearchSpriteByParam		; ESTE PROGRAMA NECESITA PASAR EN LA VARA EL PARÁMETRO
		include "sksprparam.asm"


