; subroutines 

bank0:	; swap to bank 0 - original @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or 0 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret

bank4:	; swap to bank 4 @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or 4 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret 

bankb:	; swap to bank asigned in b @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or b 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret 

showSplash
		; Volcado de pantalla
		; desde origen = hl
		; banco origen = a
		ld de,$4000		; destino pantalla
		; ld bc,6912 todos estos bites (automatico): aqui sumamos los tres secciones
		call UnzipB
		ret

SaveToBank
LoadFromBank
showSplashparam
		; volcado datos generico
		; Parámeters:
		; a = banco origen/destino
		; hl = direccion origen
		; de = destino address
		; bc = longitud
		push bc
		di				; everyone wait a minute!
		ld b,a			; I want to see this memory bank, variable a introducida para propósito general
		call bankb		; switch to that bank
		pop bc
		ldir			; copy data
		call bank0		; now look at bank 0 (the usual one)
		ei				; you can continue with your things
		ret				; thank you
		
UnzipB
		; descomprime datos en destino (de) longitud datos automático (bc)
		; Parámeters:
		; a = banco origen/destino
		; hl = direccion origen
		; de = destino address

		di				; everyone wait a minute!
		ld b,a			; I want to see this memory bank, variable a introducida para propósito general
		call bankb		; switch to that bank
		call zx7bin		; hl=source (bank org), de=destination (low adress < bank2), bc=longitud automática 
						; -> copy data
		call bank0		; now look at bank 0 (the usual one)
		ei				; you can continue with your things
		ret				; thank you

