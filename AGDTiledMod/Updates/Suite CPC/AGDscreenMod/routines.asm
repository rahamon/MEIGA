;Bank numbers - platform specific
	; nBank0 equ $C0: 11 000000
	; nBank1 equ $C4: 11 000100
	; nBank2 equ $C5: 11 000101
	; nBank3 equ $C6: 11 000110
	; nBank4 equ $C7: 11 000111
	; nBank5 equ $CC: 11 001100
	; nBank6 equ $CD: 11 001101
	; nBank7 equ $CE: 11 001110
	; nBank8 equ $CF: 11 001111

ScreenCPC	equ $c000
; subroutines

bank0:	; swap to bank 0 - memoria base
		;DI
		ld a,nBank0
		ld bc,$7F
		ld (BankCurrent),a
		out (c),a
		;ei
		ret

bank4:	; swap to bank 4
		;di
		ld a,nBank4
		ld bc,$7F
		ld (BankCurrent),a
		out (c),a
		;ei
		ret
		
bank5:	; swap to bank 4
		;di
		ld a,nBank1
		ld bc,$7F
		ld (BankCurrent),a
		out (c),a
		;ei
		ret 

bankb:	; swap to bank asigned in b
		;di
		ld a,b
		ld bc,$7F
		ld (BankCurrent),a
		out (c),a
		;ei
		ret 

showSplash
	; Volcado de pantalla
	; desde origen = hl
	; banco origen = a

;lights off
		PUSH AF
        LD      BC,$7F54
        LD      A,$11
ClearS  DEC     A
        OUT     (C),A
        OUT     (C),C
        JR      NZ,ClearS
		POP AF
		
		ld de,$C000		; destino pantalla
		call UnzipB
		ret

SaveToBank			; Save base to
LoadFromBank		; Load Base from
showSplashparam
		; volcado datos generico
		; Parámeters:
		; a = banco origen/destino
		; hl = direccion origen
		; de = destino address
		; bc = longitud
		di				; everyone wait a minute!
		push bc
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
		call bank4		; switch to that bank b
		call SaveLastPalette
		call zx7bin		; hl=source (bank org), de=destination (low adress < bank2), bc=long automática 
		call bank0		; now look at bank 0 (the usual one)
		ret				; thank you

SaveLastPalette:
	; Colocar un buffer de memoria para la paleta de la ultima screen
	; Guarda la paleta de colores en LastPaltab
		;call ShowPalette
		DI
		ld hl,(Palettepoiter)
		ld de,LastPaltab
		ld bc,16
		ldir
		ret
		
showSplashB
	; Volcado de pantalla desde buffer
	; 3b Cambia a modo 0
        xor a           				; Mode 0		
        CALL    $BD1C                   ; Cambiar modo sin borrar la pantalla
		
	; Limpia la pantalla (todos los colores a 0)
        LD      BC,$7F54
        LD      A,$11
ClearLinesScreen:
        DEC     A
        OUT     (C),A
        OUT     (C),C
        JR      NZ,ClearLinesScreen
		
	; 3a UNPACK screenDataPacked to ScreenCPC
		call bank4
		call SaveLastPalette
		LD HL,(PackedImgpointer)
		LD DE,ScreenCPC
		di
		CALL Depack
Finik
		call bank0
	; 3c Test teclado
		;call TstSpace1
        RET
		
BankCurrent:
		defb $C0
		
	; Dirección de la tabla interna de la paleta del firmware
LastPaltab	equ $
		defs 16,0
		
zx7bin		
		; des-compresor ZX1
			include	"ZX0.asm"
