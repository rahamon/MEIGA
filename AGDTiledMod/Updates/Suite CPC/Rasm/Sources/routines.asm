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

UnpackedBuffer8000	equ $c000
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
		ld a,nBank5
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
		di
		ld de,$C000		; destino pantalla
	; ld bc,6912 todos estos bites (automatico): aqui sumamos los tres secciones
		call UnzipB
		
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
		
	; 3a UNPACK screenDataPacked to UnpackedBuffer8000
		call bank4
		LD HL,(PackedImgpointer)
		di
		LD DE,UnpackedBuffer8000
		CALL Depack

		call SetHardwarePalette

Finik
		call bank0
	; 3c Test teclado
		call TstSpace1
        RET

		
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
		DI
		ld b,a			; I want to see this memory bank, variable a introducida para propósito general
		call bankb		; switch to that bank b
	
	; Colocar un buffer de memoria para la paleta de la ultima screen
	; Guarda la paleta de colores en LastPaltab
		;call SetHardwarePalette
		ld hl,(Palettepoiter)
		ld de,LastPaltab
		ld bc,16
		ldir
		call zx7bin		; hl=source (bank org), de=destination (low adress < bank2), bc=long automática 
		call bank0		; now look at bank 0 (the usual one)
		EI
		ret				; thank you

BankCurrent:
		defb $C0
LastPaltab	equ $
		defb 0,3,9,21,15,12,18,24,6,26,25,1,16,4,22,13		; JodaFirm = LastPaltab		+15
		defb 0,2,6,8,18,20,24,26,0,5,15,3,24,11,16,25		; AGD = LastPaltab		+15+16
		DB	#54,#5C,#56,#5A,#4E								; JodaHard = LastPaltab	+15+16+16
		DB 	#5E,#52,#4A,#4C,#4B
		DB	#43,#44,#47,#58,#59
		DB	#40,#54,#8C
		
zx7bin		
		; des-compresor ZX1
			include	"ZX0.asm"

SetHardwarePalette:
	; Pinta paleta screen (Hardware values)
		LD	HL,(Palettepoiter)
		LD	B,#7F
		XOR	A
PalCPC2 OUT	(C),A
		INC	B
		OUTI
		INC	A
		CP	18
		JR	C,PalCPC2
		ret
