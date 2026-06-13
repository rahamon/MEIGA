; PROTOTIPO
; Trae un objeto a una pantalla en la posición indicada sin pintar/Borrar
; Necesita un objeto, su posición y la pantalla: En AGD Script: LET SCREEN = N
; Pensado para EdD. Usa las pantallas como tablas y guardas ahí los objetos.

bringobON
		ld a,$C9
		ld (drpob+24),a		; escribe ret en la posición drpob+24 para no dibujar objeto.
		call setscno
		ret
bringobOFF
		ld a,$11
		ld (drpob+24),a		; restaura ld de,xxxx en la posición drpob+24 como estaba.
		xor a
		ld (restfl),a		; bloquea los cambios de screen
		ret
setscno	ld a,(vara)
		ld (scno),a
		ret
		