;---------------------------
;
; Rutina User para savixan games Company 2022
; Requiere MPAGD Sound Mod
;
;---------------------------
;
; Rutina User para presentar Splash screen y FlashBlink
;
;---------------------------

		cp 12
		jp z,showSplash1	; si acumulador (registro a) es 1 entonces salta a showSplash
		cp 16
		jp z,showSplash2	; si es 16 salta para pintar la otra pantalla
		cp 45
		jp z,afbk			; en cambio si vale 45
		ret

afbk 	ld c,a				; Set BC=blockcolour pointer
		ld b,0
		ld hl,bcol			; Set HL=blockcolour table address
		add hl,bc			; Point to blockcolour
		ld a,(23693)		; Get COLOUR
		ld (hl),a			; Store COLOUR as blockcolour
		ret

showSplash1
		ld hl,$c000
		call showSplash
		ret
		
showSplash2					
		ld hl,$c000	+ 8000	; desde origen mas 8000 bites, donde está almacenada la segunda pantalla.
		call showSplash
		ret
