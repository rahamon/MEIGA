
; Ilustrar object (a) en (dispx, dispy).
; AT X Y
; LET A = objeto

iluob	ld hl,(charx)
		ld (dispx),hl

		ld a,(vara)
		
		; chequea numero de objeto valido 
		;ld hl,numob         ; number of objects in game.
		;cp (hl)             ; are we checking past the end?
		;ret nc              ; yes, can't drop non-existent item.
		
		

		; returns: a = zero set if in pockets or it is MISSISNG, hl = objdata + 33		
		call gotob

		; chequea si ya esta en pantalla
		;ld a,(scno)         ; screen number.
		;cp (hl)             ; already on this screen?
		;ret z               ; yes, nothing to do.
		
		

		ld de,65503			; minus + 3  
		add hl,de    
		call dobj1   
		ld c,(hl)    
		jp cobj      
		