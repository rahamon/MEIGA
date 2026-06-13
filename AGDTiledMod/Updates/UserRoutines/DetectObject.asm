; PROTOTIPO
; DETECTOBJ rutine especialista
; Obtiene en el acumulador el objeto, o bien, 255 si no hay nada
; ademas recoge en la variable A la coordenada x del objeto
; la coordenada y del objeto en la variable B 
		
DetectObject
		call skobj
		push af
		dec hl				; back to x
		ld a,(hl)
		ld (vara),a
		dec hl				; back to y
		ld a,(hl)
		ld (varb),a
		pop af				; accumulator now points to object
		ret
		