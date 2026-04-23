; Print BigTile(c) at b,a
; Based in the MergeRoutine of Jonathan Cauldwell, 4th December 2020.
; By Ramón Fernández Ameijeiras 
; Use in scripts like this:
;		LET C =  BigTile number
;		AT Y X
;		USER n	, (n=0 Default Offset), (n=1 AT Y,X position)
;
; Ejemplo: Pintar un trozo de pantalla:
;		LET C = 5
;		USER 0
;
; Ejemplo: Pintar el Panel 1 EN COORDENADAS 5,2
;		LET C = 1
;		AT 5 2	USER 1
;
; Post de Jonathan: https://arcadegamedesigner.proboards.com/thread/924/merging-screens-create-bigger-maps
;

	
BigTile
	;store Offset
		ld a,(winlft)
		push af
		ld a,(wintop)
		push af
	;print at new position
		call Transpy
		ld a,h
		ld (winlft),a
		ld a,l
		ld (wintop),a	
		ld a,(varc)			; Este Panel C
		call mroom
	;restore Offset
		pop af
		ld (wintop),a		
		pop af
		ld (winlft),a
Opacity	xor a
		ld (mroom2+2),a		; Restore to Transparencia zero
		ret					; end routine
		
MergeRo	call Transpy
		ld a,(varc)			; Este Panel C
		call mroom
		jr Opacity
		
mroom	ld hl,(blkptr)      ; blocks.
		ld (grbase),hl      ; set graphics base.
		call groomx         ; get address of room in accumulator.	   
		ld a,(wintop)       ; window top.
		ld (dispx),a        ; set x coordinate.
		jp mroom0
		
Transpy	ld a,1
		ld (mroom2+2),a		; Transparencia one
		ret
