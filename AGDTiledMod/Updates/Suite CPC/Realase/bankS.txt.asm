# file opened: bankS.asm
  1   0000
  2   0000              ; Installer BankS
  3   0000              ; Cargador en banco 6 adaptado para secreens
  4   0000
  5   0000              			org $2000
  6   2000
  7   2000              ;Bank numbers - platform specific
  8   2000              nBank0 equ $C0
  9   2000              nBank1 equ $C4
 10   2000              nBank2 equ $C5
 11   2000              nBank3 equ $C6
 12   2000              nBank4 equ $C7
 13   2000              nBank5 equ $CC
 14   2000              nBank6 equ $CD
 15   2000              nBank7 equ $CE
 16   2000              nBank8 equ $CF
 17   2000
 18   2000              ScrBuffer	equ 16384
 19   2000              TempBuffer	equ $8000
 20   2000              Databank	equ nBank4
 21   2000
 22   2000 C3 03 20     			jp InstallBankS
 23   2003              InstallBankS:
 24   2003 2A 39 00     			ld hl,(57)          ; fetch interrupt address.
 25   2006 22 56 20     			ld (firmad),hl      ; store firmware address.
 26   2009              LoadPackedData
 27   2009              			; Carga datos
 28   2009              				include "LoadDataScreens.asm"
# file opened: LoadDataScreens.asm
  1+  2009              ; Carga banco Screens
  2+  2009              			; carga presentación pantalla 1.
  3+  2009              			; por cada pantalla en screens directory:
  4+  2009              			; carga presentación pantalla TestFight.
  5+  2009 21 A2 5B     			ld hl,ScrBuffer + 0 + 7090 - 16
  6+  200C 22 85 21     			ld (Palettepoiter),hl
  7+  200F 21 04 22     			ld hl,screeninc1
  8+  2012 01 B2 1B     			ld bc,7090						;LONGSCREENS equ 2796 aprox
  9+  2015 11 00 40     			ld de,ScrBuffer + 0
 10+  2018 CD 58 20     			call SaveToTemp					; swap y vuelve a bank0
 11+  201B 3E C7        			ld a,$C7
 12+  201D CD 26 21     			call SaveToBank					; swap y vuelve a bank0
 13+  2020 CD 77 20     			call ConvertPalette
 14+  2023
 15+  2023              			; carga presentación pantalla 2.
 16+  2023              			; por cada pantalla en screens directory:
 17+  2023              			; carga presentación pantalla TestJoda.
 18+  2023 21 7F 6F     			ld hl,ScrBuffer + 7090 + 5085 - 16
 19+  2026 22 85 21     			ld (Palettepoiter),hl
 20+  2029 21 B6 3D     			ld hl,screeninc2
 21+  202C 01 DD 13     			ld bc,5085						;LONGSCREENS equ 2796 aprox
 22+  202F 11 B2 5B     			ld de,ScrBuffer + 7090
 23+  2032 CD 58 20     			call SaveToTemp					; swap y vuelve a bank0
 24+  2035 3E C7        			ld a,$C7
 25+  2037 CD 26 21     			call SaveToBank					; swap y vuelve a bank0
 26+  203A CD 77 20     			call ConvertPalette
 27+  203D
 28+  203D
# file closed: LoadDataScreens.asm
 29   203D              Drawdirect
 30   203D              			; muestra la primera como pantalla de carga directamente
 31   203D              			; Generar dinamicamente
 32   203D              				include "PackedUno.asm"
# file opened: PackedUno.asm
  1+  203D              		; Muestra primera Screen TestFight
  2+  203D 21 00 40     		ld hl,ScrBuffer	+ 0
  3+  2040 22 87 21     		ld (PackedImgpointer),hl
  4+  2043 21 A2 5B     		ld hl,ScrBuffer + 0 + 7090 - 16
  5+  2046 22 85 21     		ld (Palettepoiter),hl
  6+  2049 CD 11 21     		call showSplash
  7+  204C              	;lights on
  8+  204C CD B8 20     		call ShowPalette
  9+  204F
 10+  204F
# file closed: PackedUno.asm
 33   204F
 34   204F              exit:
 35   204F 2A 56 20     			ld hl,(firmad)      ; firmware interrupt address.
 36   2052 22 39 00     			ld (57),hl          ; restore interrupts.
 37   2055 C9           			ret
 38   2056
 39   2056 00 00        firmad	defw 0
 40   2058
 41   2058              SaveToTemp:
 42   2058              		; Traslada imagen a memoria temporal en TempBuffer, desde hl. Coloca en nuevo puntero en TempBuffer
 43   2058 D5           			push de				; guardar destino
 44   2059 C5           			push bc				; guardar longitud
 45   205A 11 00 80     			ld de,TempBuffer
 46   205D F3           			di					; everyone wait a minute!
 47   205E ED B0        			ldir				; copy data
 48   2060 C1           			pop bc				; restore longitud
 49   2061 D1           			pop de				; restore destino
 50   2062 21 00 80     			ld hl,TempBuffer	; Apunta ahora a TempBuffer
 51   2065 FB           			ei					; you can continue with your things
 52   2066 C9           			ret					; thank you
 53   2067
 54   2067              			; rutinas de color
 55   2067              				include "UpdateFirmware.asm"
# file opened: UpdateFirmware.asm
  1+  2067
  2+  2067              	; Dirección de la tabla interna de la paleta del firmware
  3+  2067              Firmwaere_palette_buffer: equ $
  4+  2067 00 00 00...  		defs 16,0
  5+  2077
  6+  2077              ; Actualiza Firmwaere_palette_buffer con los valores convertidos.
  7+  2077              ConvertPalette:
  8+  2077 CD F1 20     		call bank4
  9+  207A 2A 85 21     		ld hl,(Palettepoiter)	  		; Apuntar a la tabla de hardware
 10+  207D 11 67 20             ld de,Firmwaere_palette_buffer	; Apuntar al buffer de la paleta firmware.
 11+  2080              ;PalCPC4 ld hl,LastPaltab
 12+  2080 01 10 00             ld bc,16						; Contador para 16 colores.
 13+  2083
 14+  2083              UpdateLoop:
 15+  2083 7E                   ld a,(hl)                     ; Cargar valor de hardware.
 16+  2084 E5           		push hl
 17+  2085 C5           		push bc
 18+  2086 CD A4 20             call ConvertHardwareToFirmware ; Convertir a valor de firmware.
 19+  2089 C1           		pop bc
 20+  208A E1           		pop hl
 21+  208B 12                   ld (de),a                     ; Guardar valor de firmware en el buffer.
 22+  208C 23                   inc hl                         ; Avanzar al siguiente valor de hardware.
 23+  208D 13                   inc de                         ; Avanzar al siguiente lugar en el buffer.
 24+  208E 0B                   dec bc                         ; Disminuir el contador.
 25+  208F 78                   ld a,b                        ; Si b = 0 y c = 0, terminamos.
 26+  2090 B1                   or c
 27+  2091 20 F0                jr nz,UpdateLoop              ; Si no, repetir.
 28+  2093
 29+  2093              UpdatePalette:
 30+  2093              	; Colocar un buffer de memoria para la paleta de la ultima screen
 31+  2093              	; Guarda la paleta de colores en LastPaltab
 32+  2093              		;call ShowPalette
 33+  2093 F3           		DI
 34+  2094 21 67 20     		ld hl,Firmwaere_palette_buffer
 35+  2097 ED 5B 85 21  		ld de,(Palettepoiter)
 36+  209B 01 10 00     		ld bc,16
 37+  209E ED B0        		ldir
 38+  20A0 CD E6 20     		call bank0
 39+  20A3
 40+  20A3 C9           		ret                            ; Fin del programa.
 41+  20A4
 42+  20A4              ; Subrutina para convertir valores de hardware a firmware.
 43+  20A4              ConvertHardwareToFirmware:
 44+  20A4 21 CB 20             ld hl,HW_TO_FW_TABLE          ; Apuntar a la tabla de conversión.
 45+  20A7 06 00                ld b,0                        ; Inicializar el índice de la tabla.
 46+  20A9
 47+  20A9              ConvLoop:
 48+  20A9 4E                   ld c,(hl)                     ; Cargar un valor de la tabla.
 49+  20AA B9                   cp c                           ; Comparar con el valor de hardware en A.
 50+  20AB 28 09                jr z,ConvDone                 ; Si es igual, saltar al final.
 51+  20AD 23                   inc hl                         ; Avanzar al siguiente valor.
 52+  20AE 04                   inc b                          ; Incrementar el índice.
 53+  20AF F5           		push af
 54+  20B0 3E 1B                ld a, 27                       ; Cargar 27 en el registro a (límite de la tabla).
 55+  20B2 B8                   cp b
 56+  20B3 F1           		pop af
 57+  20B4 20 F3                jr nz,ConvLoop                ; Si no, repetir hasta encontrar el valor.
 58+  20B6
 59+  20B6              ConvDone:
 60+  20B6 78                   ld a, b                        ; El valor de firmware está en b (índice encontrado).
 61+  20B7 C9                   ret                            ; Retornar el valor convertido.
 62+  20B8
 63+  20B8              		; ES necesario inking TAMBIEN/SOLO/NO EN BASIC si carga desde basic
 64+  20B8              ShowPalette:
 65+  20B8 3E 10        setpal	ld a,16             ; colours to set.
 66+  20BA 21 82 21     		ld hl,LastPaltab+15	; palette.
 67+  20BD 4E           setpa0	ld c,(hl)           ; get colour.
 68+  20BE 2B           		dec hl              ; next in list.
 69+  20BF 41           		ld b,c              ; make sure it's in b and c.
 70+  20C0 3D           		dec a
 71+  20C1 F5           		push af             ; store pen number.
 72+  20C2 E5           		push hl             ; store palette pointer.
 73+  20C3 CD 32 BC     		call 48178          ; set palette colour.
 74+  20C6 E1           		pop hl              ; restore palette pointer.
 75+  20C7 F1           		pop af              ; restore pen.
 76+  20C8 20 F3        		jr nz,setpa0        ; repeat until all colours are set.
 77+  20CA C9           		ret
 78+  20CB
 79+  20CB              ; Tengo una Tabla de conversión de hardware a firmware ordenada, de manera que el firmware 1 es $54, el 2 es $44
 80+  20CB              ; de esta manera el orden de la tabla me resulta el valor firmware correspondiente al hardware.
 81+  20CB              HW_TO_FW_TABLE:
 82+  20CB 54 44 55 5C          DB $54, $44, $55, $5C, $58, $5D, $4C, $45
 82+  20CF 58 5D 4C 45
 83+  20D3 4D 56 46 57          DB $4D, $56, $46, $57, $5E, $40, $5F, $4E
 83+  20D7 5E 40 5F 4E
 84+  20DB 47 4F 52 42          DB $47, $4F, $52, $42, $53, $5A, $59, $5B
 84+  20DF 53 5A 59 5B
 85+  20E3 4A 43 4B             DB $4A, $43, $4B
 86+  20E6
# file closed: UpdateFirmware.asm
 56   20E6
 57   20E6              			; rutinas para mover memoria entre bloques del modelo 128k
 58   20E6              			; rutinas para cambiar de páginado de bloques
 59   20E6              				include	"routines.asm"
# file opened: routines.asm
  1+  20E6              ;Bank numbers - platform specific
  2+  20E6              	; nBank0 equ $C0: 11 000000
  3+  20E6              	; nBank1 equ $C4: 11 000100
  4+  20E6              	; nBank2 equ $C5: 11 000101
  5+  20E6              	; nBank3 equ $C6: 11 000110
  6+  20E6              	; nBank4 equ $C7: 11 000111
  7+  20E6              	; nBank5 equ $CC: 11 001100
  8+  20E6              	; nBank6 equ $CD: 11 001101
  9+  20E6              	; nBank7 equ $CE: 11 001110
 10+  20E6              	; nBank8 equ $CF: 11 001111
 11+  20E6
 12+  20E6              ScreenCPC	equ $c000
 13+  20E6              ; subroutines
 14+  20E6
 15+  20E6              bank0:	; swap to bank 0 - memoria base
 16+  20E6              		;DI
 17+  20E6 3E C0        		ld a,nBank0
 18+  20E8 01 7F 00     		ld bc,$7F
 19+  20EB 32 72 21     		ld (BankCurrent),a
 20+  20EE ED 79        		out (c),a
 21+  20F0              		;ei
 22+  20F0 C9           		ret
 23+  20F1
 24+  20F1              bank4:	; swap to bank 4
 25+  20F1              		;di
 26+  20F1 3E C7        		ld a,nBank4
 27+  20F3 01 7F 00     		ld bc,$7F
 28+  20F6 32 72 21     		ld (BankCurrent),a
 29+  20F9 ED 79        		out (c),a
 30+  20FB              		;ei
 31+  20FB C9           		ret
 32+  20FC
 33+  20FC              bank5:	; swap to bank 4
 34+  20FC              		;di
 35+  20FC 3E CC        		ld a,nBank5
 36+  20FE 01 7F 00     		ld bc,$7F
 37+  2101 32 72 21     		ld (BankCurrent),a
 38+  2104 ED 79        		out (c),a
 39+  2106              		;ei
 40+  2106 C9           		ret
 41+  2107
 42+  2107              bankb:	; swap to bank asigned in b
 43+  2107              		;di
 44+  2107 78           		ld a,b
 45+  2108 01 7F 00     		ld bc,$7F
 46+  210B 32 72 21     		ld (BankCurrent),a
 47+  210E ED 79        		out (c),a
 48+  2110              		;ei
 49+  2110 C9           		ret
 50+  2111
 51+  2111              showSplash
 52+  2111              	; Volcado de pantalla
 53+  2111              	; desde origen = hl
 54+  2111              	; banco origen = a
 55+  2111
 56+  2111              ;lights off
 57+  2111 F5           		PUSH AF
 58+  2112 01 54 7F             LD      BC,$7F54
 59+  2115 3E 11                LD      A,$11
 60+  2117 3D           ClearS  DEC     A
 61+  2118 ED 79                OUT     (C),A
 62+  211A ED 49                OUT     (C),C
 63+  211C 20 F9                JR      NZ,ClearS
 64+  211E F1           		POP AF
 65+  211F
 66+  211F 11 00 C0     		ld de,$C000		; destino pantalla
 67+  2122 CD 34 21     		call UnzipB
 68+  2125 C9           		ret
 69+  2126
 70+  2126              SaveToBank			; Save base to
 71+  2126              LoadFromBank		; Load Base from
 72+  2126              showSplashparam
 73+  2126              		; volcado datos generico
 74+  2126              		; Parámeters:
 75+  2126              		; a = banco origen/destino
 76+  2126              		; hl = direccion origen
 77+  2126              		; de = destino address
 78+  2126              		; bc = longitud
 79+  2126 F3           		di				; everyone wait a minute!
 80+  2127 C5           		push bc
 81+  2128 47           		ld b,a			; I want to see this memory bank, variable a introducida para propósito general
 82+  2129 CD 07 21     		call bankb		; switch to that bank
 83+  212C C1           		pop bc
 84+  212D ED B0        		ldir			; copy data
 85+  212F CD E6 20     		call bank0		; now look at bank 0 (the usual one)
 86+  2132 FB           		ei				; you can continue with your things
 87+  2133 C9           		ret				; thank you
 88+  2134
 89+  2134              UnzipB
 90+  2134              	; descomprime datos en destino (de) longitud datos automático (bc)
 91+  2134              	; Parámeters:
 92+  2134              	; a = banco origen/destino
 93+  2134              	; hl = direccion origen
 94+  2134              	; de = destino address
 95+  2134 CD F1 20     		call bank4		; switch to that bank b
 96+  2137 CD 41 21     		call SaveLastPalette
 97+  213A CD 83 21     		call zx7bin		; hl=source (bank org), de=destination (low adress < bank2), bc=long automática
 98+  213D CD E6 20     		call bank0		; now look at bank 0 (the usual one)
 99+  2140 C9           		ret				; thank you
100+  2141
101+  2141              SaveLastPalette:
102+  2141              	; Colocar un buffer de memoria para la paleta de la ultima screen
103+  2141              	; Guarda la paleta de colores en LastPaltab
104+  2141              		;call ShowPalette
105+  2141 F3           		DI
106+  2142 2A 85 21     		ld hl,(Palettepoiter)
107+  2145 11 73 21     		ld de,LastPaltab
108+  2148 01 10 00     		ld bc,16
109+  214B ED B0        		ldir
110+  214D C9           		ret
111+  214E
112+  214E              showSplashB
113+  214E              	; Volcado de pantalla desde buffer
114+  214E              	; 3b Cambia a modo 0
115+  214E AF                   xor a           				; Mode 0
116+  214F CD 1C BD             CALL    $BD1C                   ; Cambiar modo sin borrar la pantalla
117+  2152
118+  2152              	; Limpia la pantalla (todos los colores a 0)
119+  2152 01 54 7F             LD      BC,$7F54
120+  2155 3E 11                LD      A,$11
121+  2157              ClearLinesScreen:
122+  2157 3D                   DEC     A
123+  2158 ED 79                OUT     (C),A
124+  215A ED 49                OUT     (C),C
125+  215C 20 F9                JR      NZ,ClearLinesScreen
126+  215E
127+  215E              	; 3a UNPACK screenDataPacked to ScreenCPC
128+  215E CD F1 20     		call bank4
129+  2161 CD 41 21     		call SaveLastPalette
130+  2164 2A 87 21     		LD HL,(PackedImgpointer)
131+  2167 11 00 C0     		LD DE,ScreenCPC
132+  216A F3           		di
133+  216B CD BE 21     		CALL Depack
134+  216E              Finik
135+  216E CD E6 20     		call bank0
136+  2171              	; 3c Test teclado
137+  2171              		;call TstSpace1
138+  2171 C9                   RET
139+  2172
140+  2172              BankCurrent:
141+  2172 C0           		defb $C0
142+  2173
143+  2173              	; Dirección de la tabla interna de la paleta del firmware
144+  2173              LastPaltab	equ $
145+  2173 00 00 00...  		defs 16,0
146+  2183
147+  2183              zx7bin
148+  2183              		; des-compresor ZX1
149+  2183              			include	"ZX0.asm"
# file opened: ZX0.asm
  1++ 2183              ; Généré par ConvImgCpcV 1.0.8987.20325 - 09/08/2024 - le 13/09/2024 (10 22 43)
  2++ 2183              ; Mode écran - Mode 0
  3++ 2183              ; Taille (nbColsxNbLignes) 80x200
  4++ 2183
  5++ 2183              TestJoda_pluscode
  6++ 2183
  7++ 2183 18 06        	jr _StartDepack
  8++ 2185
  9++ 2185 00 00        Palettepoiter		defw 0		; org+3
 10++ 2187 00 00        PackedImgpointer	defw 0		; org+6
 11++ 2189 00 00        LogImgData			defw 0
 12++ 218B
 13++ 218B
 14++ 218B              _StartDepack:
 15++ 218B
 16++ 218B 2A 87 21     	LD HL,(PackedImgpointer)
 17++ 218E 11 00 C0     	LD DE,ScreenCPC
 18++ 2191 CD BE 21     	CALL Depack
 19++ 2194 C9           	RET
 20++ 2195
 21++ 2195              TstSpace1:
 22++ 2195 01 0E F4     	LD	BC,#F40E
 23++ 2198 ED 49        	OUT	(C),C
 24++ 219A 01 C0 F6     	LD	BC,#F6C0
 25++ 219D ED 49        	OUT	(C),C
 26++ 219F AF           	XOR	A
 27++ 21A0 ED 79        	OUT	(C),A
 28++ 21A2 01 92 F7     	LD	BC,#F792
 29++ 21A5 ED 49        	OUT	(C),C
 30++ 21A7 01 45 F6     	LD	BC,#F645
 31++ 21AA ED 49        	OUT	(C),C
 32++ 21AC 06 F4        	LD	B,#F4
 33++ 21AE ED 78        	IN	A,(C)
 34++ 21B0 01 82 F7     	LD	BC,#F782
 35++ 21B3 ED 49        	OUT	(C),C
 36++ 21B5 01 00 F6     	LD	BC,#F600
 37++ 21B8 ED 49        	OUT	(C),C
 38++ 21BA 3C           	INC	A
 39++ 21BB 28 D8        	JR	Z,TstSpace1
 40++ 21BD C9           	RET
 41++ 21BE
 42++ 21BE              ; Decompactage
 43++ 21BE              Depack:
 44++ 21BE 01 FF FF     	ld	bc,#ffff			; preserve default offset 1
 45++ 21C1 C5           	push	bc
 46++ 21C2 03           	inc	bc
 47++ 21C3 3E 80        	ld	a,#80
 48++ 21C5              dzx0s_literals:
 49++ 21C5 CD F5 21     	call	dzx0s_elias		; obtain length
 50++ 21C8 ED B0        	ldir					; copy literals
 51++ 21CA 87           	add	a,a					; copy from last offset or new offset?
 52++ 21CB 38 0D        	jr	c,dzx0s_new_offset
 53++ 21CD CD F5 21     	call	dzx0s_elias		; obtain length
 54++ 21D0              dzx0s_copy:
 55++ 21D0 E3           	ex	(sp),hl				; preserve source,restore offset
 56++ 21D1 E5           	push	hl				; preserve offset
 57++ 21D2 19           	add	hl,de				; calculate destination - offset
 58++ 21D3 ED B0        	ldir					; copy from offset
 59++ 21D5 E1           	pop	hl					; restore offset
 60++ 21D6 E3           	ex	(sp),hl				; preserve offset,restore source
 61++ 21D7 87           	add	a,a					; copy from literals or new offset?
 62++ 21D8 30 EB        	jr	nc,dzx0s_literals
 63++ 21DA              dzx0s_new_offset:
 64++ 21DA CD F5 21     	call	dzx0s_elias		; obtain offset MSB
 65++ 21DD 47           	ld b,a
 66++ 21DE F1           	pop	af					; discard last offset
 67++ 21DF AF           	xor	a					; adjust for negative offset
 68++ 21E0 91           	sub	c
 69++ 21E1 C8           	RET	Z		; Plus d'octets à traiter = fini
 70++ 21E2
 71++ 21E2 4F           	ld	c,a
 72++ 21E3 78           	ld	a,b
 73++ 21E4 41           	ld	b,c
 74++ 21E5 4E           	ld	c,(hl)				; obtain offset LSB
 75++ 21E6 23           	inc	hl
 76++ 21E7 CB 18        	rr	b					; last offset bit becomes first length bit
 77++ 21E9 CB 19        	rr	c
 78++ 21EB C5           	push	bc				; preserve new offset
 79++ 21EC 01 01 00     	ld	bc,1				; obtain length
 80++ 21EF D4 FD 21     	call	nc,dzx0s_elias_backtrack
 81++ 21F2 03           	inc	bc
 82++ 21F3 18 DB        	jr	dzx0s_copy
 83++ 21F5              dzx0s_elias:
 84++ 21F5 0C           	inc	c					; interlaced Elias gamma coding
 85++ 21F6              dzx0s_elias_loop:
 86++ 21F6 87           	add	a,a
 87++ 21F7 20 03        	jr	nz,dzx0s_elias_skip
 88++ 21F9 7E           	ld	a,(hl)				; load another group of 8 bits
 89++ 21FA 23           	inc	hl
 90++ 21FB 17           	rla
 91++ 21FC              dzx0s_elias_skip:
 92++ 21FC D8           	ret 	c
 93++ 21FD              dzx0s_elias_backtrack:
 94++ 21FD 87           	add	a,a
 95++ 21FE CB 11        	rl	c
 96++ 2200 CB 10        	rl	b
 97++ 2202 18 F2        	jr	dzx0s_elias_loop
 98++ 2204
 99++ 2204
# file closed: ZX0.asm
150+  2204
# file closed: routines.asm
 60   2204              DATAPackedScreens
 61   2204              			; Seccion de datos
 62   2204              				include "screens.asm"
# file opened: screens.asm
  1+  2204              ; Seccion de datos
  2+  2204              screeninc1:		; presentacion pantalla TestFight.
  3+  2204              			incbin	"TestFight.bin"
  4+  3DB6
  5+  3DB6              screeninc2:		; presentacion pantalla TestJoda.
  6+  3DB6              			incbin	"TestJoda.bin"
  7+  5193
  8+  5193
# file closed: screens.asm
 63   5193
 64   5193
 65   5193
 66   5193
 67   5193
 68   5193
 69   5193
 70   5193
 71   5193
 72   5193
# file closed: bankS.asm
