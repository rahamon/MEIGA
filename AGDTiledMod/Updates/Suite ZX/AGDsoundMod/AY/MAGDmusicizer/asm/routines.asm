; subroutines 

bank0:	; swap to bank 0 - original @ 49152 - 16k
		ld a,(23388)   
		and 248
		or 0 
		ld bc,32765
		;di
		ld (23388),a
		out (c),a
		;ei
		ret

bank4:	; swap to bank 4 @ 49152 - 16k
		ld a,(23388)   
		and 248
		or 4 
		ld bc,32765
		;di
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
	
			;include "ULABuffer.asm"
			include "DobleBuffer.asm"
	
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

; Mostrar Pantalla en RAM 7 (está vacía inicialmente)
; dibujar pantalla en RAM 5
; Copiar RAM 5 a RAM 7
; Mostrar pantalla en RAM 5:bank0

; INICIO_BUCLE_JUEGO:
  ; Borrar sprites en oculta (*)
  ; Dibujar sprites en oculta
  ; Esperar vsync
  ; Intercambiar pantalla que se muestra (si estoy en 5 paso a 7; si estoy en 7 paso a 5) (**)
  ; Procesar juego (teclado, calcular nueva posición sprites, etc)
  ; SI (hay que hacer scroll)
     ; SI (estoy visualizando RAM 5)
         ; Mostrar RAM 7
     ; FIN_SI
     ; dibujar pantalla en RAM 5 después de hacer scroll
     ; Copiar RAM 5 a RAM 7
     ; Dibujar sprites en RAM 5
     ; Esperar vsync
     ; Mostrar pantalla en RAM 5
  ; FIN_SI
; FIN_BUCLE_JUEGO

; Para copiar la RAM5 a la RAM7 puedes usar esto:
;
; T128_TrRAM5ToRAM7
;
; Copy screen to shadow screen (RAM 5 to RAM 7)
;
