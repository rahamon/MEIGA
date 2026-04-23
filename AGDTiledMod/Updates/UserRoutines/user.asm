; mijadore 3 routines

;MASKAGD			equ 0		; Masck

; Control
		cp 10
		jp z,BigTile
		cp 11
		jp z,MergeRo
		cp 12
		jp z,evnt20
		cp 13
		jp z,iluob
		cp 14
		jp z,getz
		cp 15
		jp z,swap2mask
		cp 16
		jp z,swap2xor
		cp 17
		jp z,evnt19
		cp 18
		jp z,SetAttr2Water
		cp 19
		jp z,DetectObjPos
		cp 20
		jp z,gravHackLadder
		cp 21
		jp z,RestoreGravHackLadder
		cp 22
		jp z,getZ_counter
		cp 23
		jp z,setMask_image
		
; User routines CRUD para Read Data	
		cp 24
		jp z,writeSP
		cp 25
		jp z,writeNN	; NN escribe e incrementa indice
		cp 26
		jp z,Getptrd	; NN Captura pointers antes de RESTORE
		cp 27
		jp z,SetPtr		; NN Desplaza indice DATA
		cp 28
debuj	jr z,debuj
		CP 29
		JP Z,evintr
		ret
		
		include "WriteDATA.asm"

setMask_image
		ld a,(vara)
		ld (ix+66),a
		ret

getZ_counter
	IF MASKAGD = 1
		ld a,(z_counter)
		ld (vara),a
	ENDIF
		ret

gravHackLadder
		xor a
		ld (plchk+16),a
		ret
		
RestoreGravHackLadder
		ld a,$EC
		ld (plchk+16),a
		ret

DetectObjPos
		; devuelve X coord objetos en VARIABLE A
		call skobj
		ld a,(hl)		; x position
		ld (vara),a
		dec hl			; back to y position.
		ld a,(hl)		; Y position
		ld (varb),a
		ret

swap2mask
	IF MASKAGD > 0
		call sspr_restore_dlpointers
		; swap2xor si existen objetos en fondo
		; solo funciona o es accesible desde STARTSCREEN EVENT
		ld a,1
		ld (vara),a		; monitor
		ret	; testeando*** borrar
		ld hl,swap2xor
		ld (shwob0+7),hl
		call shwob
		ld hl,dobjc
		ld (shwob0+7),hl
	ENDIF
		ret
		
swap2xor
	IF MASKAGD > 0
		call swap_dlpoiters
		xor a
		ld (vara),a		; monitor
	ENDIF
		ret

getz
	ld a,(ix+17)			; profundidad
	ld (varz),a
	ld a,(ix+66)			; rutina mascara
	ld (varn),a
	ret

SetAttr2Water
	ld a,(vara)
	jp SetAttrBlock

; Meiga UserRutines
			include "PanelRoom2.asm"
			include "PrintObject.asm"
			include "SetAttrBlock.asm"
			