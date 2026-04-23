# file opened: gezzerCPC.asm
   1  0000              ; Routines definitions reloaded 2024
   2  0000
   3  0000              		include "Unplugged.asm"
# file opened: Unplugged.asm
   1+ 0000              ; ContainerMod by Ramon Fernandez Ameijeiras
   2+ 0000              ; Ahorro de 1188 bytes
   3+ 0000
   4+ 0000              INVENTARY		equ 0		; 441 bytes
   5+ 0000              SPECIALISTS		equ 0		; 747 bytes
   6+ 0000              SOUNDFX			equ 0		; 162 bytes
   7+ 0000
# file closed: Unplugged.asm
   4  0000
   5  0000              ; Game engine code --------------------------------------------------------------
   6  0000
   7  0000              ; Arcade Game Designer.
   8  0000              ; (C) 2008 - 2020 Jonathan Cauldwell.
   9  0000              ; Amstrad CPC Engine v0.7.9
  10  0000
  11  0000              ; Global definitions ------------------------------------------------------------
  12  0000
  13  0000              SHRAPN equ 40630           ; shrapnel table, just below map.
  14  0000              MAP    equ 40960           ; properties map buffer.
  15  0000              MAPHI  equ 160             ; high byte of MAP.
  16  0000
  17  0000
  18  0000              ; Block characteristics.
  19  0000
  20  0000              PLATFM equ 1               ; platform.
  21  0000              WALL   equ PLATFM + 1      ; solid wall.
  22  0000              LADDER equ WALL + 1        ; ladder.
  23  0000              FODDER equ LADDER + 1      ; fodder block.
  24  0000              DEADLY equ FODDER + 1      ; deadly block.
  25  0000              CUSTOM equ DEADLY + 1      ; custom block.
  26  0000              WATER  equ CUSTOM + 1      ; water block.
  27  0000              COLECT equ WATER + 1       ; collectable block.
  28  0000              NUMTYP equ COLECT + 1      ; number of types.
  29  0000
  30  0000              ; Sprites.
  31  0000
  32  0000              NUMSPR equ 12              ; number of sprites.
  33  0000              TABSIZ equ 17              ; size of each entry.
  34  0000              SPRBUF equ NUMSPR * TABSIZ ; size of entire table.
  35  0000              NMESIZ equ 4               ; bytes stored in nmetab for each sprite.
  36  0000              X      equ 8               ; new x coordinate of sprite.
  37  0000              Y      equ X + 1           ; new y coordinate of sprite.
  38  0000              PAM1ST equ 5               ; first sprite parameter, old x (ix+5).
  39  0000
  40  0000              ; Particle engine.
  41  0000
  42  0000              NUMSHR equ 55              ; pieces of shrapnel.
  43  0000              SHRSIZ equ 6               ; bytes per particle.
  44  0000
  45  0000
  46  0000              ; Game starts here.
  47  0000
  48  0000                     org $2000
  49  2000
  50  2000              		include "header.asm"
# file opened: header.asm
   1+ 2000              ; Header o cabecera para proposito general
   2+ 2000
   3+ 2000 C3 3D 22     		jp start									; org+0
   4+ 2003 C3 09 20     		jp UserScrRoutines							; org+3
   5+ 2006 C3 45 21     		jp UserPlayerAkgWithSoundEffect_CPCRoutines	; org+6
   6+ 2009
   7+ 2009              UserScrRoutines
   8+ 2009              		include "ScreenPlayer.asm"
# file opened: ScreenPlayer.asm
   1++2009
   2++2009              ;Bank numbers - platform specific
   3++2009              nBank0 equ $C0
   4++2009              nBank1 equ $C4
   5++2009              nBank2 equ $C5
   6++2009              nBank3 equ $C6
   7++2009              nBank4 equ $C7
   8++2009              nBank5 equ $CC
   9++2009              nBank6 equ $CD
  10++2009              nBank7 equ $CE
  11++2009              nBank8 equ $CF
  12++2009
  13++2009              ScrBuffer	equ 16384
  14++2009              Screenbank	equ nBank6
  15++2009
  16++2009              UserScreen
  17++2009 3A 5C 22     			ld a,(vara)
  18++200C FE 10        			cp 16
  19++200E CA 22 20     			jp z,RestorePalette
  20++2011 FE 12        			cp 18
  21++2013 CA 19 20     			jp z,ShowPalette
  22++2016
  23++2016 CD 26 20     			call SLoader
  24++2019
  25++2019              ShowPalette
  26++2019 3E 10        			ld a,16             ; colours to set.
  27++201B 21 C3 20     			ld hl,LastPaltab+15     ; palette.
  28++201E CD 62 23     			call setpa0
  29++2021 C9           			ret
  30++2022              RestorePalette
  31++2022 CD 5D 23     			call setpal
  32++2025 C9           			ret
  33++2026
  34++2026              SLoader
  35++2026              				include "ScreenSelector.asm"
# file opened: ScreenSelector.asm
   1++2026              ; Screen selector
   2++2026 C9           			ret
   3++2027
# file closed: ScreenSelector.asm
  36++2027
  37++2027              		; rutinas para mover memoria entre bloques del modelo 128k
  38++2027              				include "swappingS.asm"
# file opened: swappingS.asm
   1++2027              ;empty	swappingS
   2++2027
# file closed: swappingS.asm
  39++2027              		; rutinas para cambiar de páginado de bloques
  40++2027              				include	"routines.asm"
# file opened: routines.asm
   1++2027              ;Bank numbers - platform specific
   2++2027              	; nBank0 equ $C0: 11 000000
   3++2027              	; nBank1 equ $C4: 11 000100
   4++2027              	; nBank2 equ $C5: 11 000101
   5++2027              	; nBank3 equ $C6: 11 000110
   6++2027              	; nBank4 equ $C7: 11 000111
   7++2027              	; nBank5 equ $CC: 11 001100
   8++2027              	; nBank6 equ $CD: 11 001101
   9++2027              	; nBank7 equ $CE: 11 001110
  10++2027              	; nBank8 equ $CF: 11 001111
  11++2027
  12++2027              ScreenCPC	equ $c000
  13++2027              ; subroutines
  14++2027
  15++2027              bank0:	; swap to bank 0 - memoria base
  16++2027              		;DI
  17++2027 3E C0        		ld a,nBank0
  18++2029 01 7F 00     		ld bc,$7F
  19++202C 32 B3 20     		ld (BankCurrent),a
  20++202F ED 79        		out (c),a
  21++2031              		;ei
  22++2031 C9           		ret
  23++2032
  24++2032              bank4:	; swap to bank 4
  25++2032              		;di
  26++2032 3E C7        		ld a,nBank4
  27++2034 01 7F 00     		ld bc,$7F
  28++2037 32 B3 20     		ld (BankCurrent),a
  29++203A ED 79        		out (c),a
  30++203C              		;ei
  31++203C C9           		ret
  32++203D
  33++203D              bank5:	; swap to bank 4
  34++203D              		;di
  35++203D 3E C4        		ld a,nBank1
  36++203F 01 7F 00     		ld bc,$7F
  37++2042 32 B3 20     		ld (BankCurrent),a
  38++2045 ED 79        		out (c),a
  39++2047              		;ei
  40++2047 C9           		ret
  41++2048
  42++2048              bankb:	; swap to bank asigned in b
  43++2048              		;di
  44++2048 78           		ld a,b
  45++2049 01 7F 00     		ld bc,$7F
  46++204C 32 B3 20     		ld (BankCurrent),a
  47++204F ED 79        		out (c),a
  48++2051              		;ei
  49++2051 C9           		ret
  50++2052
  51++2052              showSplash
  52++2052              	; Volcado de pantalla
  53++2052              	; desde origen = hl
  54++2052              	; banco origen = a
  55++2052
  56++2052              ;lights off
  57++2052 F5           		PUSH AF
  58++2053 01 54 7F             LD      BC,$7F54
  59++2056 3E 11                LD      A,$11
  60++2058 3D           ClearS  DEC     A
  61++2059 ED 79                OUT     (C),A
  62++205B ED 49                OUT     (C),C
  63++205D 20 F9                JR      NZ,ClearS
  64++205F F1           		POP AF
  65++2060
  66++2060 11 00 C0     		ld de,$C000		; destino pantalla
  67++2063 CD 75 20     		call UnzipB
  68++2066 C9           		ret
  69++2067
  70++2067              SaveToBank			; Save base to
  71++2067              LoadFromBank		; Load Base from
  72++2067              showSplashparam
  73++2067              		; volcado datos generico
  74++2067              		; Parámeters:
  75++2067              		; a = banco origen/destino
  76++2067              		; hl = direccion origen
  77++2067              		; de = destino address
  78++2067              		; bc = longitud
  79++2067 F3           		di				; everyone wait a minute!
  80++2068 C5           		push bc
  81++2069 47           		ld b,a			; I want to see this memory bank, variable a introducida para propósito general
  82++206A CD 48 20     		call bankb		; switch to that bank
  83++206D C1           		pop bc
  84++206E ED B0        		ldir			; copy data
  85++2070 CD 27 20     		call bank0		; now look at bank 0 (the usual one)
  86++2073 FB           		ei				; you can continue with your things
  87++2074 C9           		ret				; thank you
  88++2075
  89++2075              UnzipB
  90++2075              	; descomprime datos en destino (de) longitud datos automático (bc)
  91++2075              	; Parámeters:
  92++2075              	; a = banco origen/destino
  93++2075              	; hl = direccion origen
  94++2075              	; de = destino address
  95++2075 CD 32 20     		call bank4		; switch to that bank b
  96++2078 CD 82 20     		call SaveLastPalette
  97++207B CD C4 20     		call zx7bin		; hl=source (bank org), de=destination (low adress < bank2), bc=long automática
  98++207E CD 27 20     		call bank0		; now look at bank 0 (the usual one)
  99++2081 C9           		ret				; thank you
 100++2082
 101++2082              SaveLastPalette:
 102++2082              	; Colocar un buffer de memoria para la paleta de la ultima screen
 103++2082              	; Guarda la paleta de colores en LastPaltab
 104++2082              		;call ShowPalette
 105++2082 F3           		DI
 106++2083 2A C6 20     		ld hl,(Palettepoiter)
 107++2086 11 B4 20     		ld de,LastPaltab
 108++2089 01 10 00     		ld bc,16
 109++208C ED B0        		ldir
 110++208E C9           		ret
 111++208F
 112++208F              showSplashB
 113++208F              	; Volcado de pantalla desde buffer
 114++208F              	; 3b Cambia a modo 0
 115++208F AF                   xor a           				; Mode 0
 116++2090 CD 1C BD             CALL    $BD1C                   ; Cambiar modo sin borrar la pantalla
 117++2093
 118++2093              	; Limpia la pantalla (todos los colores a 0)
 119++2093 01 54 7F             LD      BC,$7F54
 120++2096 3E 11                LD      A,$11
 121++2098              ClearLinesScreen:
 122++2098 3D                   DEC     A
 123++2099 ED 79                OUT     (C),A
 124++209B ED 49                OUT     (C),C
 125++209D 20 F9                JR      NZ,ClearLinesScreen
 126++209F
 127++209F              	; 3a UNPACK screenDataPacked to ScreenCPC
 128++209F CD 32 20     		call bank4
 129++20A2 CD 82 20     		call SaveLastPalette
 130++20A5 2A C8 20     		LD HL,(PackedImgpointer)
 131++20A8 11 00 C0     		LD DE,ScreenCPC
 132++20AB F3           		di
 133++20AC CD FF 20     		CALL Depack
 134++20AF              Finik
 135++20AF CD 27 20     		call bank0
 136++20B2              	; 3c Test teclado
 137++20B2              		;call TstSpace1
 138++20B2 C9                   RET
 139++20B3
 140++20B3              BankCurrent:
 141++20B3 C0           		defb $C0
 142++20B4
 143++20B4              	; Dirección de la tabla interna de la paleta del firmware
 144++20B4              LastPaltab	equ $
 145++20B4 00 00 00...  		defs 16,0
 146++20C4
 147++20C4              zx7bin
 148++20C4              		; des-compresor ZX1
 149++20C4              			include	"ZX0.asm"
# file opened: ZX0.asm
   1++20C4              ; Généré par ConvImgCpcV 1.0.8987.20325 - 09/08/2024 - le 13/09/2024 (10 22 43)
   2++20C4              ; Mode écran - Mode 0
   3++20C4              ; Taille (nbColsxNbLignes) 80x200
   4++20C4
   5++20C4              TestJoda_pluscode
   6++20C4
   7++20C4 18 06        	jr _StartDepack
   8++20C6
   9++20C6 00 00        Palettepoiter		defw 0		; org+3
  10++20C8 00 00        PackedImgpointer	defw 0		; org+6
  11++20CA 00 00        LogImgData			defw 0
  12++20CC
  13++20CC
  14++20CC              _StartDepack:
  15++20CC
  16++20CC 2A C8 20     	LD HL,(PackedImgpointer)
  17++20CF 11 00 C0     	LD DE,ScreenCPC
  18++20D2 CD FF 20     	CALL Depack
  19++20D5 C9           	RET
  20++20D6
  21++20D6              TstSpace1:
  22++20D6 01 0E F4     	LD	BC,#F40E
  23++20D9 ED 49        	OUT	(C),C
  24++20DB 01 C0 F6     	LD	BC,#F6C0
  25++20DE ED 49        	OUT	(C),C
  26++20E0 AF           	XOR	A
  27++20E1 ED 79        	OUT	(C),A
  28++20E3 01 92 F7     	LD	BC,#F792
  29++20E6 ED 49        	OUT	(C),C
  30++20E8 01 45 F6     	LD	BC,#F645
  31++20EB ED 49        	OUT	(C),C
  32++20ED 06 F4        	LD	B,#F4
  33++20EF ED 78        	IN	A,(C)
  34++20F1 01 82 F7     	LD	BC,#F782
  35++20F4 ED 49        	OUT	(C),C
  36++20F6 01 00 F6     	LD	BC,#F600
  37++20F9 ED 49        	OUT	(C),C
  38++20FB 3C           	INC	A
  39++20FC 28 D8        	JR	Z,TstSpace1
  40++20FE C9           	RET
  41++20FF
  42++20FF              ; Decompactage
  43++20FF              Depack:
  44++20FF 01 FF FF     	ld	bc,#ffff			; preserve default offset 1
  45++2102 C5           	push	bc
  46++2103 03           	inc	bc
  47++2104 3E 80        	ld	a,#80
  48++2106              dzx0s_literals:
  49++2106 CD 36 21     	call	dzx0s_elias		; obtain length
  50++2109 ED B0        	ldir					; copy literals
  51++210B 87           	add	a,a					; copy from last offset or new offset?
  52++210C 38 0D        	jr	c,dzx0s_new_offset
  53++210E CD 36 21     	call	dzx0s_elias		; obtain length
  54++2111              dzx0s_copy:
  55++2111 E3           	ex	(sp),hl				; preserve source,restore offset
  56++2112 E5           	push	hl				; preserve offset
  57++2113 19           	add	hl,de				; calculate destination - offset
  58++2114 ED B0        	ldir					; copy from offset
  59++2116 E1           	pop	hl					; restore offset
  60++2117 E3           	ex	(sp),hl				; preserve offset,restore source
  61++2118 87           	add	a,a					; copy from literals or new offset?
  62++2119 30 EB        	jr	nc,dzx0s_literals
  63++211B              dzx0s_new_offset:
  64++211B CD 36 21     	call	dzx0s_elias		; obtain offset MSB
  65++211E 47           	ld b,a
  66++211F F1           	pop	af					; discard last offset
  67++2120 AF           	xor	a					; adjust for negative offset
  68++2121 91           	sub	c
  69++2122 C8           	RET	Z		; Plus d'octets à traiter = fini
  70++2123
  71++2123 4F           	ld	c,a
  72++2124 78           	ld	a,b
  73++2125 41           	ld	b,c
  74++2126 4E           	ld	c,(hl)				; obtain offset LSB
  75++2127 23           	inc	hl
  76++2128 CB 18        	rr	b					; last offset bit becomes first length bit
  77++212A CB 19        	rr	c
  78++212C C5           	push	bc				; preserve new offset
  79++212D 01 01 00     	ld	bc,1				; obtain length
  80++2130 D4 3E 21     	call	nc,dzx0s_elias_backtrack
  81++2133 03           	inc	bc
  82++2134 18 DB        	jr	dzx0s_copy
  83++2136              dzx0s_elias:
  84++2136 0C           	inc	c					; interlaced Elias gamma coding
  85++2137              dzx0s_elias_loop:
  86++2137 87           	add	a,a
  87++2138 20 03        	jr	nz,dzx0s_elias_skip
  88++213A 7E           	ld	a,(hl)				; load another group of 8 bits
  89++213B 23           	inc	hl
  90++213C 17           	rla
  91++213D              dzx0s_elias_skip:
  92++213D D8           	ret 	c
  93++213E              dzx0s_elias_backtrack:
  94++213E 87           	add	a,a
  95++213F CB 11        	rl	c
  96++2141 CB 10        	rl	b
  97++2143 18 F2        	jr	dzx0s_elias_loop
  98++2145
  99++2145
# file closed: ZX0.asm
 150++2145
# file closed: routines.asm
  41++2145
# file closed: ScreenPlayer.asm
   9+ 2145
  10+ 2145              UserPlayerAkgWithSoundEffect_CPCRoutines
  11+ 2145              		include "UserPlayerAkgWithSoundEffect_CPC.asm"
# file opened: UserPlayerAkgWithSoundEffect_CPC.asm
   1++2145
   2++2145              ; Bank numbers - platform specific
   3++2145              ; nBank0 equ $C0
   4++2145              ; nBank1 equ $C4
   5++2145              ; nBank2 equ $C5
   6++2145              ; nBank3 equ $C6
   7++2145              ; nBank4 equ $C7
   8++2145              ; nBank5 equ $CC
   9++2145              ; nBank6 equ $CD
  10++2145              ; nBank7 equ $CE
  11++2145              ; nBank8 equ $CF
  12++2145
  13++2145              ; Driver bank
  14++2145              PLAY4BANK	equ $4000
  15++2145
  16++2145              ; Correspondencias
  17++2145              PLY_AKG_Init						equ PLAY4BANK+0
  18++2145              PLY_AKG_PLAY						equ PLAY4BANK+3
  19++2145              PLY_AKG_Stop						equ	PLAY4BANK+6
  20++2145              Music_Start							equ PLAY4BANK+9
  21++2145              Empty_music							equ PLAY4BANK+11
  22++2145              PLY_AKG_InitSoundEffects			equ PLAY4BANK+15
  23++2145              PLY_AKG_PlaySoundEffect				equ PLAY4BANK+18
  24++2145              SoundEffects						equ PLAY4BANK+21
  25++2145              PLY_AKG_StopSoundEffectFromChannel	equ PLAY4BANK+25
  26++2145
  27++2145              ; 	Chequear sonido, comando o efecto
  28++2145
  29++2145              		; LET A = , CALL 8198
  30++2145 3A 5C 22     		ld a,(vara)
  31++2148 32 7E 21     		ld (chkcom),a		; Guardamos n en chkcom
  32++214B              		; Chequear si es efecto de sonido
  33++214B 3E 64        		ld a,100
  34++214D 21 7E 21     		ld hl,chkcom
  35++2150 BE           		cp (hl)
  36++2151 DA 71 21     		jp c,FX_Selector	; if chkcom > 100
  37++2154 CA 7D 21     		jp z,invalid_fx		; if chkcom = 100
  38++2157
  39++2157              no_es_efecto				; chkcom < 100
  40++2157 3A 7E 21     		ld a,(chkcom)
  41++215A FE 60        		cp 96				; play one note
  42++215C CA 98 21     		jp z,PLY_PlaySong
  43++215F FE 12        		cp 18				; stop and rewind
  44++2161 CA E6 21     		jp z,PLY_StopSong
  45++2164 FE 13        		cp 19				; no es usado generalmente
  46++2166 CA 1A 22     		jp z,PLY_StopSfx
  47++2169 FE 14        		cp 20				; pause on-off
  48++216B CA 26 22     		jp z,PLY_SkipOnOff
  49++216E
  50++216E C3 7F 21     		jp inicia_musica
  51++2171
  52++2171              es_efecto
  53++2171              FX_Selector
  54++2171 0E 64        		ld c,100
  55++2173 3A 7E 21     		ld a,(chkcom)
  56++2176 91           		sub c			 	; subtract 100 to comando
  57++2177 32 3B 22     		ld (SelectedSoundEffect),a
  58++217A C3 09 22     		jp PLY_PlaySfx
  59++217D              invalid_fx
  60++217D C9           		ret					; efecto 0 no válido
  61++217E
  62++217E 00           chkcom	defb 0				; Comando
  63++217F
  64++217F              		;Initializes the music.
  65++217F              inicia_musica
  66++217F CD 3D 20     		call bank5
  67++2182 2A 09 40     		ld hl,(Music_Start)			; direccion de la musica
  68++2185              		;Subsong in a.
  69++2185 3A 7E 21     		ld a,(chkcom)
  70++2188 3D           		dec a
  71++2189 CD 00 40     		call PLY_AKG_Init
  72++218C CD 27 20     		call bank0
  73++218F 3E 01        		ld a,1
  74++2191 32 99 21     		ld (music_Started),a			; PLAY flag = 1
  75++2194 CD 36 22     		call skipOFF
  76++2197 C9           		ret
  77++2198
  78++2198                      ;Calls the player
  79++2198              PLY_PlaySong:
  80++2198              		; check if music is sterted
  81++2198 3E           		DEFB $3E						; LD A,n
  82++2199 00           music_Started	defb 0
  83++219A FE 01        		cp 1
  84++219C CA C4 21     		jp z,Play
  85++219F              Mute_Music:
  86++219F                      ;Initializes the Empty Music. Useful to listen to the sound effects alone.
  87++219F CD 3D 20             call bank5
  88++21A2 2A 0B 40             ld hl,(Empty_music)
  89++21A5 AF                   xor a                   		;Subsong 0.
  90++21A6 CD 00 40     		call PLY_AKG_Init
  91++21A9 3E 01        		ld a,1
  92++21AB 32 99 21     		ld (music_Started),a			; PLAY flag = 1
  93++21AE
  94++21AE              Setup_SoundEffects:
  95++21AE              		;check sound effects setup
  96++21AE 3E           		DEFB $3E						; LD A,n
  97++21AF 00           effects_started:	defb 0
  98++21B0 FE 01        		cp 1
  99++21B2 CA C0 21     		jp z,skipsetup
 100++21B5
 101++21B5                      ;Initializes the sound effects.
 102++21B5              		;call bank5
 103++21B5 2A 15 40             ld hl,(SoundEffects)
 104++21B8 CD 0F 40             call PLY_AKG_InitSoundEffects
 105++21BB              		;call bank0
 106++21BB 3E 01        		ld a,1
 107++21BD 32 AF 21     		ld (effects_started),a			; Setup flag = 1
 108++21C0              skipsetup
 109++21C0 CD 27 20     		call bank0
 110++21C3 C9           		ret
 111++21C4
 112++21C4              Play:
 113++21C4 F3           		di
 114++21C5 08                   ex af,af'	;'
 115++21C6 D9                   exx
 116++21C7                              ;Only a few registers needs to be saved as the system requires them.
 117++21C7 F5                           push af
 118++21C8 C5                           push bc
 119++21C9 DD E5                        push ix
 120++21CB FD E5                        push iy
 121++21CD 3E           				DEFB $3E            	; LD A,n
 122++21CE 00           SkipOnOff		defb 0
 123++21CF FE 01        				cp 1
 124++21D1 28 09        				jr z,skipplaynote
 125++21D3 CD 3D 20     				call bank5
 126++21D6 CD 03 40     				call PLY_AKG_PLAY
 127++21D9 CD 27 20     				call bank0
 128++21DC FD E1        skipplaynote    pop iy
 129++21DE DD E1                        pop ix
 130++21E0 C1                           pop bc
 131++21E1 F1                           pop af
 132++21E2 08                   ex af,af'	;'
 133++21E3 D9                   exx
 134++21E4 FB                   ei
 135++21E5 C9                   ret
 136++21E6
 137++21E6              PLY_StopSong:
 138++21E6 CD ED 21     		call StopMusic
 139++21E9 CD 9F 21     		call Mute_Music
 140++21EC C9           		ret
 141++21ED
 142++21ED              StopMusic:
 143++21ED              		;test
 144++21ED F3                   di
 145++21EE 08                   ex af,af'	;'
 146++21EF D9                   exx
 147++21F0                              ;Same as above.
 148++21F0 F5                           push af
 149++21F1 C5                           push bc
 150++21F2 DD E5                        push ix
 151++21F4 FD E5                        push iy
 152++21F6 CD 3D 20     				call bank5
 153++21F9 CD 06 40     				call PLY_AKG_Stop
 154++21FC CD 27 20                     call bank0
 155++21FF FD E1        				pop iy
 156++2201 DD E1                        pop ix
 157++2203 C1                           pop bc
 158++2204 F1                           pop af
 159++2205 08                   ex af,af'	;'
 160++2206 D9                   exx
 161++2207 FB                   ei
 162++2208 C9                   ret
 163++2209
 164++2209              PLY_PlaySfx:
 165++2209              PlayOnChannel2:
 166++2209 CD 3D 20     		call bank5
 167++220C 0E 00                ld c,0
 168++220E              PlayOnChannelShared:
 169++220E 3A 3B 22             ld a,(SelectedSoundEffect)
 170++2211 06 00                ld b,0          ;Full volume.
 171++2213 CD 12 40             call PLY_AKG_PlaySoundEffect
 172++2216 CD 27 20             call bank0
 173++2219 C9           		ret
 174++221A
 175++221A              PLY_StopSfx:
 176++221A              StopChannel2:
 177++221A CD 3D 20     		call bank5
 178++221D 3E 01                ld a,1
 179++221F              StopChannelShared:
 180++221F CD 19 40             call PLY_AKG_StopSoundEffectFromChannel
 181++2222 CD 27 20             call bank0
 182++2225 C9           		ret
 183++2226
 184++2226              PLY_SkipOnOff:
 185++2226 3A CE 21     			ld a,(SkipOnOff)
 186++2229 FE 01        			cp 1
 187++222B 28 09        			jr z,switchskip
 188++222D 3E 01        skipON		ld a,1
 189++222F 32 CE 21     			ld (SkipOnOff),a
 190++2232 CD ED 21     			call StopMusic
 191++2235 C9           			ret
 192++2236              skipOFF
 193++2236 AF           switchskip	xor a
 194++2237 32 CE 21     			ld (SkipOnOff),a
 195++223A C9           			ret
 196++223B
 197++223B
 198++223B 01           SelectedSoundEffect: db 1                       ;The selected sound effect (>=1).
 199++223C 00           SelectedSubsong: db 0                       	;The selected subsong (>=0).
 200++223D
# file closed: UserPlayerAkgWithSoundEffect_CPC.asm
  12+ 223D
  13+ 223D              start  equ $
  14+ 223D
# file closed: header.asm
  51  223D
  52  223D 2A 39 00            ld hl,(57)          ; fetch interrupt address.
  53  2240 22 0F 23            ld (firmad),hl      ; store firmware address.
  54  2243                     ;call 48127          ; initialise screen to default settings.
  55  2243 CD 14 BC            call 48148          ; clear the screen.
  56  2246 AF                  xor a               ; mode 0, 16 colours.
  57  2247 CD 0E BC            call 48142          ; set screen mode.
  58  224A
  59  224A CD 9A 23     start0 call game           ; start the game.
  60  224D 18 FB               jr start0
  61  224F
  62  224F 00           joyval defb 0              ; joystick reading.
  63  2250 00           frmno  defb 0              ; selected frame.
  64  2251
  65  2251              ; Don't change the order of these four.  Menu routine relies on winlft following wintop.
  66  2251
  67  2251 01           wintop defb WINDOWTOP      ; top of window.
  68  2252 01           winlft defb WINDOWLFT      ; left edge.
  69  2253 16           winhgt defb WINDOWHGT      ; window height.
  70  2254 16           winwid defb WINDOWWID      ; window width.
  71  2255
  72  2255 01           numob  defb NUMOBJ         ; number of objects in game.
  73  2256
  74  2256              ; Variables start here.
  75  2256              ; Pixel versions of wintop, winlft, winhgt, winwid.
  76  2256
  77  2256 08           wntopx defb 8 * WINDOWTOP
  78  2257 05           wnlftx defb 5 * WINDOWLFT
  79  2258 A8           wnbotx defb WINDOWTOP * 8 + WINH - 16
  80  2259 69           wnrgtx defb WINDOWLFT * 5 + WINW - 10
  81  225A 00           scno   defb 0              ; present screen number.
  82  225B 03           numlif defb 3              ; number of lives.
  83  225C 00           vara   defb 0              ; general-purpose variable.
  84  225D 00           varb   defb 0              ; general-purpose variable.
  85  225E 00           varc   defb 0              ; general-purpose variable.
  86  225F 00           vard   defb 0              ; general-purpose variable.
  87  2260 00           vare   defb 0              ; general-purpose variable.
  88  2261 00           varf   defb 0              ; general-purpose variable.
  89  2262 00           varg   defb 0              ; general-purpose variable.
  90  2263 00           varh   defb 0              ; general-purpose variable.
  91  2264 00           vari   defb 0              ; general-purpose variable.
  92  2265 00           varj   defb 0              ; general-purpose variable.
  93  2266 00           vark   defb 0              ; general-purpose variable.
  94  2267 00           varl   defb 0              ; general-purpose variable.
  95  2268 00           varm   defb 0              ; general-purpose variable.
  96  2269 00           varn   defb 0              ; general-purpose variable.
  97  226A 00           varo   defb 0              ; general-purpose variable.
  98  226B 00           varp   defb 0              ; general-purpose variable.
  99  226C 00           varq   defb 0              ; general-purpose variable.
 100  226D 00           varr   defb 0              ; general-purpose variable.
 101  226E 00           vars   defb 0              ; general-purpose variable.
 102  226F 00           vart   defb 0              ; general-purpose variable.
 103  2270 00           varu   defb 0              ; general-purpose variable.
 104  2271 00           varv   defb 0              ; general-purpose variable.
 105  2272 00           varw   defb 0              ; general-purpose variable.
 106  2273 00           varz   defb 0              ; general-purpose variable.
 107  2274 00           contrl defb 0              ; control, 0 = keyboard, 1 = Joystick 1, 2 = Joystick 2.
 108  2275 00           charx  defb 0              ; cursor x position.
 109  2276 00           chary  defb 0              ; cursor y position.
 110  2277 00           clock  defb 0              ; last clock reading.
 111  2278 FF           varrnd defb 255            ; last random number.
 112  2279 FE           varobj defb 254            ; last object number.
 113  227A FF           varopt defb 255            ; last option chosen from menu.
 114  227B FF           varblk defb 255            ; block type.
 115  227C 00           nexlev defb 0              ; next level flag.
 116  227D 00           restfl defb 0              ; restart screen flag.
 117  227E 00           deadf  defb 0              ; dead flag.
 118  227F 00           gamwon defb 0              ; game won flag.
 119  2280 00           dispx  defb 0              ; cursor x position.
 120  2281 00           dispy  defb 0              ; cursor y position.
 121  2282 00           loopa  defb 0              ; loop counter system variable.
 122  2283 00           loopb  defb 0              ; loop counter system variable.
 123  2284 00           loopc  defb 0              ; loop counter system variable.
 124  2285
 125  2285              ; Make sure pointers are arranged in the same order as the data itself.
 126  2285
 127  2285 7A 40        frmptr defw frmlst         ; sprite frames.
 128  2287 95 39        proptr defw bprop          ; address of char properties.
 129  2289 84 40        scrptr defw scdat          ; address of screens.
 130  228B 65 46        nmeptr defw nmedat         ; enemy start positions.
 131  228D
 132  228D              ; Assorted game routines which can go in contended memory.
 133  228D
 134  228D              		IF INVENTARY == 1				; ContainerMod by Ramon Fernandez Ameijeiras
 135  228D ~
 136  228D ~
 137  228D ~            ; Modify for inventory.
 138  228D ~
 139  228D ~            minve  ld hl,invdis        ; routine address.
 140  228D ~                   ld (mod0+1),hl      ; set up menu routine.
 141  228D ~                   ld (mod2+1),hl      ; set up count routine.
 142  228D ~                   ld hl,fopt          ; find option from available objects.
 143  228D ~                   ld (mod1+1),hl      ; set up routine.
 144  228D ~                   jr dbox             ; do menu routine.
 145  228D ~
 146  228D ~            ; Modify for menu.
 147  228D ~
 148  228D ~            mmenu  ld hl,always        ; routine address.
 149  228D ~                   ld (mod0+1),hl      ; set up routine.
 150  228D ~                   ld (mod2+1),hl      ; set up count routine.
 151  228D ~                   ld hl,fstd          ; standard option selection.
 152  228D ~                   ld (mod1+1),hl      ; set up routine.
 153  228D ~
 154  228D ~            ; Drop through into box routine.
 155  228D ~
 156  228D ~            ; Work out size of box for message or menu.
 157  228D ~
 158  228D ~            ;dbox   ld hl,nummsg        ; total messages.
 159  228D ~            ;       cp (hl)             ; does this one exist?
 160  228D ~            ;       ret nc              ; no, nothing to display.
 161  228D ~            dbox   ld hl,msgdat        ; pointer to messages.
 162  228D ~                   call getwrd         ; get message number.
 163  228D ~                   push hl             ; store pointer to message.
 164  228D ~                   ld d,1              ; height.
 165  228D ~                   xor a               ; start at object zero.
 166  228D ~                   ld (combyt),a       ; store number of object in combyt.
 167  228D ~                   ld e,a              ; maximum width.
 168  228D ~            dbox5  ld b,0              ; this line's width.
 169  228D ~            mod2   call always         ; item in player's possession?
 170  228D ~                   jr nz,dbox6         ; not in inventory, skip this line.
 171  228D ~                   inc d               ; add to tally.
 172  228D ~            dbox6  ld a,(hl)           ; get character.
 173  228D ~                   inc hl              ; next character.
 174  228D ~                   cp ','              ; reached end of line?
 175  228D ~                   jr z,dbox3          ; yes.
 176  228D ~                   cp 13               ; reached end of line?
 177  228D ~                   jr z,dbox3          ; yes.
 178  228D ~                   inc b               ; add to this line's width.
 179  228D ~                   and a               ; end of message?
 180  228D ~                   jp m,dbox4          ; yes, end count.
 181  228D ~                   jr dbox6            ; repeat until we find the end.
 182  228D ~            dbox3  ld a,e              ; maximum line width.
 183  228D ~                   cp b                ; have we exceeded longest so far?
 184  228D ~                   jr nc,dbox5         ; no, carry on looking.
 185  228D ~                   ld e,b              ; make this the widest so far.
 186  228D ~                   jr dbox5            ; keep looking.
 187  228D ~            dbox4  ld a,e              ; maximum line width.
 188  228D ~                   cp b                ; have we exceeded longest so far?
 189  228D ~                   jr nc,dbox8         ; no, carry on looking.
 190  228D ~                   ld e,b              ; final line is the longest so far.
 191  228D ~            dbox8  dec d               ; decrement items found.
 192  228D ~                   jp z,dbox15         ; total was zero.
 193  228D ~                   ld a,e              ; longest line.
 194  228D ~                   and a               ; was it zero?
 195  228D ~                   jp z,dbox15         ; total was zero.
 196  228D ~                   ld (bwid),de        ; set up size.
 197  228D ~
 198  228D ~            ; That's set up our box size.
 199  228D ~
 200  228D ~                   ld a,(winhgt)       ; window height in characters.
 201  228D ~                   sub d               ; subtract height of box.
 202  228D ~                   rra                 ; divide by 2.
 203  228D ~                   ld hl,wintop        ; top edge of window.
 204  228D ~                   add a,(hl)          ; add displacement.
 205  228D ~                   ld (btop),a         ; set up box top.
 206  228D ~                   ld a,(winwid)       ; window width in characters.
 207  228D ~                   sub e               ; subtract box width.
 208  228D ~                   rra                 ; divide by 2.
 209  228D ~                   inc hl              ; left edge of window.
 210  228D ~                   add a,(hl)          ; add displacement.
 211  228D ~                   ld (blft),a         ; box left.
 212  228D ~                   pop hl              ; restore message pointer.
 213  228D ~                   ld a,(btop)         ; box top.
 214  228D ~                   ld (dispx),a        ; set display coordinate.
 215  228D ~                   xor a               ; start at object zero.
 216  228D ~                   ld (combyt),a       ; store number of object in combyt.
 217  228D ~            dbox2  ld a,(combyt)       ; get object number.
 218  228D ~            mod0   call always         ; check inventory for display.
 219  228D ~                   jp nz,dbox13        ; not in inventory, skip this line.
 220  228D ~
 221  228D ~                   ld a,(blft)         ; box left.
 222  228D ~                   ld (dispy),a        ; set left display position.
 223  228D ~                   ld a,(bwid)         ; box width.
 224  228D ~                   ld b,a              ; store width.
 225  228D ~            dbox0  ld a,(hl)           ; get character.
 226  228D ~                   cp ','              ; end of line?
 227  228D ~                   jr z,dbox1          ; yes, next one.
 228  228D ~                   cp 13               ; end of option?
 229  228D ~                   jr z,dbox1          ; yes, on to next.
 230  228D ~                   dec b               ; one less to display.
 231  228D ~                   and 127             ; remove terminator.
 232  228D ~                   push bc             ; store characters remaining.
 233  228D ~                   push hl             ; store address on stack.
 234  228D ~                   call ptxta          ; display on screen and advance.
 235  228D ~                   pop hl              ; retrieve address of next character.
 236  228D ~                   pop bc              ; chars left for this line.
 237  228D ~                   ld a,(hl)           ; get character.
 238  228D ~                   inc hl              ; next character.
 239  228D ~                   cp 128              ; end of message?
 240  228D ~                   jp nc,dbox7         ; yes, job done.
 241  228D ~                   ld a,b              ; chars remaining.
 242  228D ~                   and a               ; are any left?
 243  228D ~                   jr nz,dbox0         ; yes, continue.
 244  228D ~
 245  228D ~            ; Reached limit of characters per line.
 246  228D ~
 247  228D ~            dbox9  ld a,(hl)           ; get character.
 248  228D ~                   inc hl              ; next one.
 249  228D ~                   cp ','              ; another line?
 250  228D ~                   jr z,dbox10         ; yes, do next line.
 251  228D ~                   cp 13               ; another line?
 252  228D ~                   jr z,dbox10         ; yes, on to next.
 253  228D ~                   cp 128              ; end of message?
 254  228D ~                   jr nc,dbox11        ; yes, finish message.
 255  228D ~                   jr dbox9
 256  228D ~
 257  228D ~            ; Fill box to end of line.
 258  228D ~
 259  228D ~            dboxf  push hl             ; store address on stack.
 260  228D ~                   push bc             ; store characters remaining.
 261  228D ~                   ld a,32             ; space character.
 262  228D ~                   call ptxta          ; display character and advance.
 263  228D ~                   pop bc              ; retrieve character count.
 264  228D ~                   pop hl              ; retrieve address of next character.
 265  228D ~                   djnz dboxf          ; repeat for remaining chars on line.
 266  228D ~                   ret
 267  228D ~            dbox1  inc hl              ; skip character.
 268  228D ~                   call dboxf          ; fill box out to right side.
 269  228D ~            dbox10 ld a,(dispx)        ; x coordinate.
 270  228D ~                   inc a               ; down a line.
 271  228D ~                   ld (dispx),a        ; next position.
 272  228D ~                   jp dbox2            ; next line.
 273  228D ~            dbox7  ld a,b              ; chars remaining.
 274  228D ~                   and a               ; are any left?
 275  228D ~                   jr z,dbox11         ; no, nothing to draw.
 276  228D ~                   call dboxf          ; fill message to line.
 277  228D ~
 278  228D ~            ; Drawn the box menu, now select option.
 279  228D ~
 280  228D ~            dbox11 ld a,(btop)         ; box top.
 281  228D ~                   ld (dispx),a        ; set bar position.
 282  228D ~            dbox14 call joykey         ; get controls.
 283  228D ~                   and 63              ; anything pressed?
 284  228D ~                   jr nz,dbox14        ; yes, debounce it.
 285  228D ~                   call dbar           ; draw bar.
 286  228D ~            dbox12 call joykey         ; get controls.
 287  228D ~                   and 19              ; anything pressed?
 288  228D ~                   jr z,dbox12         ; no, nothing.
 289  228D ~                   and 16              ; fire button pressed?
 290  228D ~            mod1   jp nz,fstd          ; yes, job done.
 291  228D ~                   call dbar           ; delete bar.
 292  228D ~                   ld a,(joyval)       ; joystick reading.
 293  228D ~                   and 1               ; going up?
 294  228D ~                   jr nz,dboxu         ; yes, go up.
 295  228D ~                   ld a,(dispx)        ; vertical position of bar.
 296  228D ~                   inc a               ; look down.
 297  228D ~                   ld hl,btop          ; top of box.
 298  228D ~                   sub (hl)            ; find distance from top.
 299  228D ~                   dec hl              ; point to height.
 300  228D ~                   cp (hl)             ; are we at end?
 301  228D ~                   jp z,dbox14         ; yes, go no further.
 302  228D ~                   ld hl,dispx         ; coordinate.
 303  228D ~                   inc (hl)            ; move bar.
 304  228D ~                   jr dbox14           ; continue.
 305  228D ~            dboxu  ld a,(dispx)        ; vertical position of bar.
 306  228D ~                   ld hl,btop          ; top of box.
 307  228D ~                   cp (hl)             ; are we at the top?
 308  228D ~                   jp z,dbox14         ; yes, go no further.
 309  228D ~                   ld hl,dispx         ; coordinate.
 310  228D ~                   dec (hl)            ; move bar.
 311  228D ~                   jr dbox14           ; continue.
 312  228D ~            fstd   ld a,(dispx)        ; bar position.
 313  228D ~                   ld hl,btop          ; top of menu.
 314  228D ~                   sub (hl)            ; find selected option.
 315  228D ~                   ld (varopt),a       ; store the option.
 316  228D ~                   jp redraw           ; redraw the screen.
 317  228D ~
 318  228D ~            ; Option not available.  Skip this line.
 319  228D ~
 320  228D ~            dbox13 ld a,(hl)           ; get character.
 321  228D ~                   inc hl              ; next one.
 322  228D ~                   cp ','              ; another line?
 323  228D ~                   jp z,dbox2          ; yes, do next line.
 324  228D ~                   cp 13               ; another line?
 325  228D ~                   jp z,dbox2          ; yes, on to next line.
 326  228D ~                   and a               ; end of message?
 327  228D ~                   jp m,dbox11         ; yes, finish message.
 328  228D ~                   jr dbox13
 329  228D ~            dbox15 pop hl              ; pop message pointer from the stack.
 330  228D ~                   ret
 331  228D ~
 332  228D ~            dbar   ld a,(blft)         ; box left.
 333  228D ~                   ld (dispy),a        ; set display coordinate.
 334  228D ~                   call gprad          ; get printing address.
 335  228D ~                   ex de,hl            ; flip into hl register pair.
 336  228D ~
 337  228D ~                   ld b,8              ; 8 pixel rows to invert.
 338  228D ~            dbar1  push bc             ; store pixel count on stack.
 339  228D ~                   push hl             ; store address.
 340  228D ~                   ld a,(bwid)         ; box width.
 341  228D ~                   ld e,a              ; copy to e register.
 342  228D ~                   rlca                ; multiple of 2.
 343  228D ~                   rlca                ; multiple of 4.
 344  228D ~                   add a,e             ; multiple of 5.
 345  228D ~                   srl a               ; divide by 2.
 346  228D ~                   ld b,a              ; loop counter in b.
 347  228D ~            dbar0  ld a,(hl)           ; get screen byte.
 348  228D ~                   cpl                 ; reverse all bits.
 349  228D ~                   ld (hl),a           ; write back to screen.
 350  228D ~                   inc hl              ; next bar.
 351  228D ~                   djnz dbar0          ; repeat for whole line.
 352  228D ~                   pop hl              ; restore screen address.
 353  228D ~                   call nline2         ; look down one line.
 354  228D ~                   pop bc              ; restore row count.
 355  228D ~                   djnz dbar1          ; repeat for 8 pixel rows.
 356  228D ~                   ret
 357  228D ~
 358  228D ~            invdis push hl             ; store message text pointer.
 359  228D ~                   push de             ; store de pair for line count.
 360  228D ~                   ld hl,combyt        ; object number.
 361  228D ~                   ld a,(hl)           ; get object number.
 362  228D ~                   inc (hl)            ; ready for next one.
 363  228D ~                   call gotob          ; check if we have object.
 364  228D ~                   pop de              ; retrieve de pair from stack.
 365  228D ~                   pop hl              ; retrieve text pointer.
 366  228D ~                   ret
 367  228D ~            ;always xor a               ; set zero flag.
 368  228D ~            ;       ret
 369  228D ~
 370  228D ~            ; Find option selected.
 371  228D ~
 372  228D ~            fopt   ld a,(dispx)
 373  228D ~                   ld hl,btop          ; top of menu.
 374  228D ~                   sub (hl)            ; find selected option.
 375  228D ~                   inc a               ; object 0 needs one iteration, 1 needs 2 and so on.
 376  228D ~                   ld b,a              ; option selected in b register.
 377  228D ~                   ld hl,combyt        ; object number.
 378  228D ~                   ld (hl),0           ; set to first item.
 379  228D ~            fopt0  push bc             ; store option counter in b register.
 380  228D ~                   call fobj           ; find next object in inventory.
 381  228D ~                   pop bc              ; restore option counter.
 382  228D ~                   djnz fopt0          ; repeat for relevant steps down the list.
 383  228D ~                   ld a,(combyt)       ; get option.
 384  228D ~                   dec a               ; one less, due to where we increment combyt.
 385  228D ~                   ld (varopt),a       ; store the option.
 386  228D ~                   jp redraw           ; redraw the screen.
 387  228D ~
 388  228D ~            fobj   ld hl,combyt        ; object number.
 389  228D ~                   ld a,(hl)           ; get object number.
 390  228D ~                   inc (hl)            ; ready for next item.
 391  228D ~                   ret z               ; in case we loop back to zero.
 392  228D ~                   call gotob          ; do we have this item?
 393  228D ~                   ret z               ; yes, it's on the list.
 394  228D ~                   jr fobj             ; repeat until we find next item in pockets.
 395  228D ~
 396  228D ~            bwid   defb 0              ; box/menu width.
 397  228D ~            blen   defb 0              ; box/menu height.
 398  228D ~            btop   defb 0              ; box coordinates.
 399  228D ~            blft   defb 0
 400  228D ~
 401  228D              		ELSE				; ContainerMod by Ramon Fernandez Ameijeiras
 402  228D 21 C7 38     dbox   ld hl,msgdat        ; pointer to messages.
 403  2290              		ENDIF				; ContainerMod by Ramon Fernandez Ameijeiras
 404  2290
 405  2290              ; Wait for keypress.
 406  2290
 407  2290 CD 9B 22     prskey call debkey         ; debounce key.
 408  2293 CD EC 22     prsky0 call vsync          ; vertical synch.
 409  2296 CD 09 BB            call 47881          ; keyboard state.
 410  2299 30 F8               jr nc,prsky0        ; repeat until key pressed.
 411  229B
 412  229B              ; Debounce keypress.
 413  229B
 414  229B CD EC 22     debkey call vsync          ; update scrolling, sounds etc.
 415  229E CD 09 BB            call 47881          ; read keyboard.
 416  22A1 38 F8               jr c,debkey         ; key pressed - loop until key is released.
 417  22A3 C9                  ret
 418  22A4
 419  22A4              ; Delay routine.
 420  22A4
 421  22A4 C5           delay  push bc             ; store loop counter.
 422  22A5 CD EC 22            call vsync          ; pause for a frame.
 423  22A8                     ;call plsnd          ; time to play sound.
 424  22A8 C1                  pop bc              ; restore counter.
 425  22A9 05                  dec b               ; one less iteration.
 426  22AA C8                  ret z               ; done.
 427  22AB C5                  push bc             ; store loop counter again.
 428  22AC CD EC 22            call vsync          ; pause for a frame.
 429  22AF C1                  pop bc              ; restore counter.
 430  22B0 10 F2               djnz delay          ; repeat.
 431  22B2 C9                  ret
 432  22B3
 433  22B3              ; Clear sprite table.
 434  22B3
 435  22B3 21 D3 32     xspr   ld hl,sprtab        ; sprite table.
 436  22B6 06 CC               ld b,SPRBUF         ; length of table.
 437  22B8 36 FF        xspr0  ld (hl),255         ; clear one byte.
 438  22BA 23                  inc hl              ; move to next byte.
 439  22BB 10 FB               djnz xspr0          ; repeat for rest of table.
 440  22BD C9                  ret
 441  22BE
 442  22BE CD 1D 25     silenc call silen1         ; silence channel 1.
 443  22C1 CD 1D 25            call silen2         ; silence channel 2.
 444  22C4 CD 1D 25            call silen3         ; silence channel 3.
 445  22C7 C3 F1 4A            jp plsnd            ; play all channels to switch them off.
 446  22CA
 447  22CA              ; Initialise all objects.
 448  22CA
 449  22CA DD 21 2B 47  iniob  ld ix,objdta        ; objects table.
 450  22CE 3A 55 22            ld a,(numob)        ; number of objects in the game.
 451  22D1 47                  ld b,a              ; loop counter.
 452  22D2 11 46 00            ld de,70            ; distance between objects.
 453  22D5 DD 7E 43     iniob0 ld a,(ix+67)        ; start screen.
 454  22D8 DD 77 40            ld (ix+64),a        ; set start screen.
 455  22DB DD 7E 44            ld a,(ix+68)        ; find start x.
 456  22DE DD 77 41            ld (ix+65),a        ; set start x.
 457  22E1 DD 7E 45            ld a,(ix+69)        ; get initial y.
 458  22E4 DD 77 42            ld (ix+66),a        ; set y coord.
 459  22E7 DD 19               add ix,de           ; point to next object.
 460  22E9 10 EA               djnz iniob0         ; repeat.
 461  22EB C9                  ret
 462  22EC
 463  22EC              ; Screen synchronisation.
 464  22EC
 465  22EC CD 0D 2C     vsync  call joykey         ; read joystick/keyboard.
 466  22EF 21 0E 23            ld hl,framec        ; frame counter.
 467  22F2 7E                  ld a,(hl)           ; clock reading.
 468  22F3 34                  inc (hl)            ; post-increment frame.
 469  22F4 1F                  rra                 ; rotate bit into carry.
 470  22F5 DC 07 23            call c,vsync5       ; time to play sound and do shrapnel/ticker stuff.
 471  22F8 01 77 22            ld bc,clock         ; last clock reading.
 472  22FB CD 0D BD     vsync0 call 48397          ; get current clock.
 473  22FE 0A                  ld a,(bc)           ; previous clock.
 474  22FF 95                  sub l               ; new reading.
 475  2300 FE FB               cp 251              ; difference of 6?
 476  2302 30 F7               jr nc,vsync0        ; no, wait until clock changes.
 477  2304 7D                  ld a,l              ; clock reading in accumulator.
 478  2305 02                  ld (bc),a           ; set new clock reading.
 479  2306 C9                  ret
 480  2307 CD F1 4A     vsync5 call plsnd          ; play sound.
 481  230A C3 99 23            jp proshr           ; shrapnel and stuff.
 482  230D
 483  230D 00           sndtyp defb 0
 484  230E 00           framec defb 0              ; frame counter.
 485  230F 00 00        firmad defw 0
 486  2311
 487  2311              ; Redraw the screen.
 488  2311
 489  2311              ; Remove old copy of all sprites for redraw.
 490  2311
 491  2311 DD E5        redraw push ix             ; place sprite pointer on stack.
 492  2313 CD 56 29            call droom          ; show screen layout.
 493  2316 CD 1E 25            call shwob          ; draw objects.
 494  2319 06 0C        numsp0 ld b,NUMSPR         ; sprites to draw.
 495  231B DD 21 D3 32         ld ix,sprtab        ; sprite table.
 496  231F DD 7E 00     redrw0 ld a,(ix+0)         ; old sprite type.
 497  2322 3C                  inc a               ; is it enabled?
 498  2323 28 0C               jr z,redrw1         ; no, find next one.
 499  2325 DD 7E 03            ld a,(ix+3)         ; sprite x.
 500  2328 FE B9               cp 185              ; beyond maximum?
 501  232A 30 05               jr nc,redrw1        ; yes, nothing to draw.
 502  232C C5                  push bc             ; store sprite counter.
 503  232D CD 7F 2E            call sspria         ; show single sprite.
 504  2330 C1                  pop bc              ; retrieve sprite counter.
 505  2331 11 11 00     redrw1 ld de,TABSIZ        ; distance to next odd/even entry.
 506  2334 DD 19               add ix,de           ; next sprite.
 507  2336 10 E7               djnz redrw0         ; repeat for remaining sprites.
 508  2338 CD F7 4A     rpblc1 call rbloc          ; redraw blocks if in adventure mode.
 509  233B CD 99 23            call dshrp          ; redraw shrapnel.
 510  233E DD E1               pop ix              ; retrieve sprite pointer.
 511  2340 C9                  ret
 512  2341
 513  2341              ; Clear screen routine.
 514  2341
 515  2341              ;cls    jp 48148            ; clear screen.
 516  2341 26 C0        cls    ld h,192            ; screen base is 256 * 192 = 49152.
 517  2343 06 08               ld b,8              ; 8 rows per character.
 518  2345 C5           cls0   push bc             ; store loop counter.
 519  2346 CD 4D 23            call cls1           ; clear 25 lines.
 520  2349 C1                  pop bc              ; restore loop counter.
 521  234A 10 F9               djnz cls0           ; repeat.
 522  234C C9                  ret
 523  234D 01 CF 07     cls1   ld bc,1999          ; bytes to write.
 524  2350 3A 06 28            ld a,(papmsk)       ; get paper colour.
 525  2353 2E 00        cls2   ld l,0              ; lines start at multiples of 256.
 526  2355 54                  ld d,h              ; copy hl to de.
 527  2356 1E 01               ld e,1              ; add 1 to de so it's pointing to next byte.
 528  2358 77                  ld (hl),a           ; write colour.
 529  2359 ED B0               ldir
 530  235B 24                  inc h               ; point hl at next block of lines.
 531  235C C9                  ret
 532  235D
 533  235D              ; Set palette routine and data.
 534  235D              ; Palette.
 535  235D              ; 0  Black
 536  235D              ; 1  Blue
 537  235D              ; 2  Bright blue
 538  235D              ; 3  Red
 539  235D              ; 4  Magenta
 540  235D              ; 5  Mauve
 541  235D              ; 6  Bright red
 542  235D              ; 7  Purple
 543  235D              ; 8  Bright magenta
 544  235D              ; 9  Green
 545  235D              ; 10 Cyan
 546  235D              ; 11 Sky blue
 547  235D              ; 12 Yellow
 548  235D              ; 13 White
 549  235D              ; 14 Pastel blue
 550  235D              ; 15 Orange
 551  235D              ; 16 Pink
 552  235D              ; 17 Pastel magenta
 553  235D              ; 18 Bright green
 554  235D              ; 19 Sea green
 555  235D              ; 20 Bright cyan
 556  235D              ; 21 Lime
 557  235D              ; 22 Pastel green
 558  235D              ; 23 Pastel cyan
 559  235D              ; 24 Bright yellow
 560  235D              ; 25 Pastel yellow
 561  235D              ; 26 Bright white
 562  235D
 563  235D 3E 10        setpal ld a,16             ; colours to set.
 564  235F 21 80 47            ld hl,palett+15     ; palette.
 565  2362 4E           setpa0 ld c,(hl)           ; get colour.
 566  2363 2B                  dec hl              ; next in list.
 567  2364 41                  ld b,c              ; make sure it's in b and c.
 568  2365 3D                  dec a
 569  2366 F5                  push af             ; store pen number.
 570  2367 E5                  push hl             ; store palette pointer.
 571  2368 CD 32 BC            call 48178          ; set palette colour.
 572  236B E1                  pop hl              ; restore palette pointer.
 573  236C F1                  pop af              ; restore pen.
 574  236D 20 F3               jr nz,setpa0        ; repeat until all colours are set.
 575  236F C9                  ret
 576  2370
 577  2370 7E           fdchk  ld a,(hl)           ; fetch cell.
 578  2371 FE 04               cp FODDER           ; is it fodder?
 579  2373 C0                  ret nz              ; no.
 580  2374 36 00               ld (hl),0           ; rewrite block type.
 581  2376 E5                  push hl             ; store pointer to block.
 582  2377 11 00 A0            ld de,MAP           ; address of map.
 583  237A A7                  and a               ; clear carry flag for subtraction.
 584  237B ED 52               sbc hl,de           ; find simple displacement for block.
 585  237D 7D                  ld a,l              ; low byte is y coordinate.
 586  237E E6 1F               and 31              ; column position 0 - 31.
 587  2380 32 81 22            ld (dispy),a        ; set up y position.
 588  2383 29                  add hl,hl           ; multiply displacement by 8.
 589  2384 29                  add hl,hl
 590  2385 29                  add hl,hl
 591  2386 7C                  ld a,h              ; x coordinate now in h.
 592  2387 32 80 22            ld (dispx),a        ; set the display coordinate.
 593  238A AF                  xor a               ; block to write.
 594  238B CD C9 27            call pattr          ; write block.
 595  238E E1                  pop hl              ; restore block pointer.
 596  238F C9                  ret
 597  2390
 598  2390              ; Routine to colour a sprite is redundant on CPC.
 599  2390
 600  2390 C9           cspr   ret
 601  2391
 602  2391              ; Scrolly text and puzzle variables.
 603  2391
 604  2391 80           txtbit defb 128            ; bit to write.
 605  2392 10           txtwid defb 16             ; width of ticker message.
 606  2393 C7 38        txtpos defw msgdat
 607  2395 C7 38        txtini defw msgdat
 608  2397 16 40        txtscr defw 16406
 609  2399
 610  2399              		IF SPECIALISTS == 1				; ContainerMod by Ramon Fernandez Ameijeiras
 611  2399 ~
 612  2399 ~            ; Specialist routines.
 613  2399 ~            ; Process shrapnel.
 614  2399 ~
 615  2399 ~            proshr ld ix,SHRAPN        ; table.
 616  2399 ~                   ld b,NUMSHR         ; shrapnel pieces to process.
 617  2399 ~                   ld de,SHRSIZ        ; distance to next.
 618  2399 ~            prosh0 ld a,(ix+0)         ; on/off marker.
 619  2399 ~                   rla                 ; check its status.
 620  2399 ~            proshx call nc,prosh1      ; on, so process it.
 621  2399 ~                   add ix,de           ; point there.
 622  2399 ~                   djnz prosh0         ; round again.
 623  2399 ~                   jp scrly
 624  2399 ~            prosh1 push bc             ; store counter.
 625  2399 ~                   call plot           ; delete the pixel.
 626  2399 ~                   ld a,(ix+0)         ; restore shrapnel type.
 627  2399 ~                   ld hl,shrptr        ; shrapnel routine pointers.
 628  2399 ~                   call prosh2         ; run the routine.
 629  2399 ~                   call chkxy          ; check x and y are good before we redisplay.
 630  2399 ~                   pop bc              ; restore counter.
 631  2399 ~                   ld de,SHRSIZ        ; distance to next.
 632  2399 ~                   ret
 633  2399 ~            prosh2 rlca                ; 2 bytes per address.
 634  2399 ~                   ld e,a              ; copy to de.
 635  2399 ~                   add hl,de           ; point to address of routine.
 636  2399 ~                   ld a,(hl)           ; get address low.
 637  2399 ~                   inc hl              ; point to second byte.
 638  2399 ~                   ld h,(hl)           ; fetch high byte from table.
 639  2399 ~                   ld l,a              ; put low byte in l.
 640  2399 ~                   jp (hl)             ; jump to routine.
 641  2399 ~
 642  2399 ~            shrptr defw laser          ; laser.
 643  2399 ~                   defw trail          ; vapour trail.
 644  2399 ~                   defw shrap          ; shrapnel from explosion.
 645  2399 ~                   defw dotl           ; horizontal starfield left.
 646  2399 ~                   defw dotr           ; horizontal starfield right.
 647  2399 ~                   defw dotu           ; vertical starfield up.
 648  2399 ~                   defw dotd           ; vertical starfield down.
 649  2399 ~                   defw ptcusr         ; user particle.
 650  2399 ~
 651  2399 ~            ; Explosion shrapnel.
 652  2399 ~
 653  2399 ~            shrap  ld e,(ix+1)         ; get the angle.
 654  2399 ~                   ld d,0              ; no high byte.
 655  2399 ~                   ld hl,shrsin        ; shrapnel sine table.
 656  2399 ~                   add hl,de           ; point to sine.
 657  2399 ~
 658  2399 ~                   ld e,(hl)           ; fetch value from table.
 659  2399 ~                   inc hl              ; next byte of table.
 660  2399 ~                   ld d,(hl)           ; fetch value from table.
 661  2399 ~                   inc hl              ; next byte of table.
 662  2399 ~                   ld c,(hl)           ; fetch value from table.
 663  2399 ~                   inc hl              ; next byte of table.
 664  2399 ~                   ld b,(hl)           ; fetch value from table.
 665  2399 ~                   ld l,(ix+2)         ; x coordinate in hl.
 666  2399 ~                   ld h,(ix+3)
 667  2399 ~                   add hl,de           ; add sine.
 668  2399 ~                   ld (ix+2),l         ; store new coordinate.
 669  2399 ~                   ld (ix+3),h
 670  2399 ~                   ld l,(ix+4)         ; y coordinate in hl.
 671  2399 ~                   ld h,(ix+5)
 672  2399 ~                   add hl,bc           ; add cosine.
 673  2399 ~                   ld (ix+4),l         ; store new coordinate.
 674  2399 ~                   ld (ix+5),h
 675  2399 ~                   ret
 676  2399 ~
 677  2399 ~            dotl   dec (ix+5)          ; move left.
 678  2399 ~                   ret
 679  2399 ~            dotr   inc (ix+5)          ; move left.
 680  2399 ~                   ret
 681  2399 ~            dotu   dec (ix+3)          ; move up.
 682  2399 ~                   ret
 683  2399 ~            dotd   inc (ix+3)          ; move down.
 684  2399 ~                   ret
 685  2399 ~
 686  2399 ~            ; Check coordinates are good before redrawing at new position.
 687  2399 ~
 688  2399 ~            chkxy  ld hl,wntopx        ; window top.
 689  2399 ~                   ld a,(ix+3)         ; fetch shrapnel coordinate.
 690  2399 ~                   cp (hl)             ; compare with top window limit.
 691  2399 ~                   jr c,kilshr         ; out of window, kill shrapnel.
 692  2399 ~                   inc hl              ; left edge.
 693  2399 ~                   ld a,(ix+5)         ; fetch shrapnel coordinate.
 694  2399 ~                   cp (hl)             ; compare with left window limit.
 695  2399 ~                   jr c,kilshr         ; out of window, kill shrapnel.
 696  2399 ~
 697  2399 ~                   inc hl              ; point to bottom.
 698  2399 ~                   ld a,(hl)           ; fetch window limit.
 699  2399 ~                   add a,15            ; add height of sprite.
 700  2399 ~                   cp (ix+3)           ; compare with shrapnel x coordinate.
 701  2399 ~                   jr c,kilshr         ; off screen, kill shrapnel.
 702  2399 ~                   inc hl              ; point to right edge.
 703  2399 ~                   ld a,(hl)           ; fetch shrapnel y coordinate.
 704  2399 ~                   add a,9             ; add width of sprite.
 705  2399 ~                   cp (ix+5)           ; compare with window limit.
 706  2399 ~                   jr c,kilshr         ; off screen, kill shrapnel.
 707  2399 ~
 708  2399 ~            ; Drop through.
 709  2399 ~            ; Display shrapnel.
 710  2399 ~
 711  2399 ~            plot   ld l,(ix+3)         ; x integer.
 712  2399 ~                   ld h,(ix+5)         ; y integer.
 713  2399 ~                   ld (dispx),hl       ; workspace coordinates.
 714  2399 ~                   ld a,(ix+0)         ; type.
 715  2399 ~                   and a               ; is it a laser?
 716  2399 ~                   jr z,plot2          ; yes, draw laser instead.
 717  2399 ~            plot0  ld a,h              ; which pixel within byte do we
 718  2399 ~                   rra                 ; want to set first?
 719  2399 ~                   ld e,170            ; default to left pixel.
 720  2399 ~                   jr nc,plot1         ; jump to set pixel code.
 721  2399 ~                   ld e,85             ; draw right pixel instead.
 722  2399 ~            plot1  call scadd          ; screen address.
 723  2399 ~                   ld a,(hl)           ; see what's already there.
 724  2399 ~                   xor e               ; merge with pixels.
 725  2399 ~                   ld (hl),a           ; put back on screen.
 726  2399 ~                   ret
 727  2399 ~            plot2  ld a,h              ; get horizontal position.
 728  2399 ~                   rra                 ; start at left or right pixel?
 729  2399 ~                   push af             ; preserve carry.
 730  2399 ~                   call scadd          ; screen address.
 731  2399 ~                   pop af              ; restore carry.
 732  2399 ~                   jr c,plot3          ; start at right pixel.
 733  2399 ~                   ld a,(hl)           ; fetch byte there.
 734  2399 ~                   cpl                 ; toggle 2 pixels.
 735  2399 ~                   ld (hl),a           ; new byte.
 736  2399 ~                   inc hl              ; next byte.
 737  2399 ~                   ld a,(hl)           ; fetch byte there.
 738  2399 ~                   cpl                 ; toggle 2 pixels.
 739  2399 ~                   ld (hl),a           ; write the new byte.
 740  2399 ~                   inc hl              ; next byte.
 741  2399 ~                   ld a,(hl)           ; fetch byte there.
 742  2399 ~                   xor 170             ; merge pixel.
 743  2399 ~                   ld (hl),a           ; set new screen byte value.
 744  2399 ~                   ret
 745  2399 ~            plot3  ld a,(hl)           ; fetch byte there.
 746  2399 ~                   xor 85              ; merge pixel.
 747  2399 ~                   ld (hl),a           ; write new byte.
 748  2399 ~                   inc hl              ; next byte.
 749  2399 ~                   ld a,(hl)           ; fetch byte there.
 750  2399 ~                   cpl                 ; toggle 2 pixels.
 751  2399 ~                   ld (hl),a           ; write the new byte.
 752  2399 ~                   inc hl              ; next byte.
 753  2399 ~                   ld a,(hl)           ; fetch byte there.
 754  2399 ~                   cpl                 ; toggle 2 pixels.
 755  2399 ~                   ld (hl),a           ; write the new byte.
 756  2399 ~                   ret
 757  2399 ~
 758  2399 ~            kilshr ld (ix+0),128       ; switch off shrapnel.
 759  2399 ~                   ret
 760  2399 ~
 761  2399 ~            ;explc  defb 0              ; explosion counter.
 762  2399 ~
 763  2399 ~            shrsin defw 0,1024,391,946,724,724,946,391
 764  2399 ~                   defw 1024,0,946,65144,724,64811,391,64589
 765  2399 ~                   defw 0,64512,65144,64589,64811,64811,64589,65144
 766  2399 ~                   defw 64512,0,64589,391,64811,724,65144,946
 767  2399 ~
 768  2399 ~            trail  dec (ix+1)          ; time remaining.
 769  2399 ~                   jp z,trailk         ; time to switch it off.
 770  2399 ~                   call qrand          ; get a random number.
 771  2399 ~                   rra                 ; x or y axis?
 772  2399 ~                   jr c,trailv         ; use x.
 773  2399 ~                   rra                 ; which direction?
 774  2399 ~                   jr c,traill         ; go left.
 775  2399 ~                   inc (ix+5)          ; go right.
 776  2399 ~                   ret
 777  2399 ~            traill dec (ix+5)          ; go left.
 778  2399 ~                   ret
 779  2399 ~            trailv rra                 ; which direction?
 780  2399 ~                   jr c,trailu         ; go up.
 781  2399 ~                   inc (ix+3)          ; go down.
 782  2399 ~                   ret
 783  2399 ~            trailu dec (ix+3)          ; go up.
 784  2399 ~                   ret
 785  2399 ~            trailk ld (ix+3),200       ; set off-screen to kill vapour trail.
 786  2399 ~                   ret
 787  2399 ~
 788  2399 ~            laser  ld a,(ix+1)         ; direction.
 789  2399 ~                   rra                 ; left or right?
 790  2399 ~                   jr nc,laserl        ; move left.
 791  2399 ~                   ld b,5              ; distance to travel.
 792  2399 ~                   jr laserm           ; move laser.
 793  2399 ~            laserl ld b,251            ; distance to travel.
 794  2399 ~            laserm ld a,(ix+5)         ; y position.
 795  2399 ~                   add a,b             ; add distance.
 796  2399 ~                   ld (ix+5),a         ; set new y coordinate.
 797  2399 ~
 798  2399 ~            ; Test new block.
 799  2399 ~
 800  2399 ~                   ld (dispy),a        ; set y for block collision detection purposes.
 801  2399 ~                   ld a,(ix+3)         ; get x.
 802  2399 ~                   ld (dispx),a        ; set coordinate for collision test.
 803  2399 ~                   call tstbl          ; get block type there.
 804  2399 ~                   cp WALL             ; is it solid?
 805  2399 ~                   jr z,trailk         ; yes, it cannot pass.
 806  2399 ~                   cp FODDER           ; is it fodder?
 807  2399 ~                   ret nz              ; no, ignore it.
 808  2399 ~                   call fdchk          ; remove fodder block.
 809  2399 ~                   jr trailk           ; destroy laser.
 810  2399 ~
 811  2399 ~            ; Plot, preserving de.
 812  2399 ~
 813  2399 ~            plotde push de             ; put de on stack.
 814  2399 ~                   call plot           ; plot pixel.
 815  2399 ~                   pop de              ; restore de from stack.
 816  2399 ~                   ret
 817  2399 ~
 818  2399 ~            ; Shoot a laser.
 819  2399 ~
 820  2399 ~            shoot  ld c,a              ; store direction in c register.
 821  2399 ~                   ld a,(ix+8)         ; x coordinate.
 822  2399 ~            shoot1 add a,7             ; down 7 pixels.
 823  2399 ~                   ld l,a              ; put x coordinate in l.
 824  2399 ~                   ld h,(ix+9)         ; y coordinate in h.
 825  2399 ~                   push ix             ; store pointer to sprite.
 826  2399 ~                   call fpslot         ; find particle slot.
 827  2399 ~                   jr nc,vapou2        ; failed, restore ix.
 828  2399 ~                   ld (ix+0),0         ; set up a laser.
 829  2399 ~                   ld (ix+1),c         ; set the direction.
 830  2399 ~                   ld (ix+3),l         ; set x coordinate.
 831  2399 ~                   rr c                ; check direction we want.
 832  2399 ~                   jr c,shootr         ; shoot right.
 833  2399 ~                   ld a,h              ; y position.
 834  2399 ~            ;       dec a               ; left a pixel.
 835  2399 ~            shoot0 and 248             ; align on character boundary.
 836  2399 ~                   ld (ix+5),a         ; set y coordinate.
 837  2399 ~                   jr vapou0           ; draw first image.
 838  2399 ~            shootr ld a,h              ; y position.
 839  2399 ~                   add a,9             ; look right.
 840  2399 ~                   jr shoot0           ; align and continue.
 841  2399 ~
 842  2399 ~            ; Create a bit of vapour trail.
 843  2399 ~
 844  2399 ~            vapour push ix             ; store pointer to sprite.
 845  2399 ~                   ld l,(ix+8)         ; x coordinate.
 846  2399 ~                   ld h,(ix+9)         ; y coordinate.
 847  2399 ~            vapou3 ld de,5*256+7       ; mid-point of sprite.
 848  2399 ~                   add hl,de           ; point to centre of sprite.
 849  2399 ~                   call fpslot         ; find particle slot.
 850  2399 ~                   jr c,vapou1         ; no, we can use it.
 851  2399 ~            vapou2 pop ix              ; restore sprite pointer.
 852  2399 ~                   ret                 ; out of slots, can't generate anything.
 853  2399 ~
 854  2399 ~            vapou1 ld (ix+3),l         ; set up x.
 855  2399 ~                   ld (ix+5),h         ; set up y coordinate.
 856  2399 ~                   call qrand          ; get quick random number.
 857  2399 ~                   and 15              ; random time.
 858  2399 ~                   add a,15            ; minimum time on screen.
 859  2399 ~                   ld (ix+1),a         ; set time on screen.
 860  2399 ~                   ld (ix+0),1         ; define particle as vapour trail.
 861  2399 ~            vapou0 call chkxy          ; plot first position.
 862  2399 ~                   jr vapou2
 863  2399 ~
 864  2399 ~            ; Create a user particle.
 865  2399 ~
 866  2399 ~            ptusr  ld c,a              ; store timer.
 867  2399 ~                   ld l,(ix+8)         ; x coordinate.
 868  2399 ~                   ld h,(ix+9)         ; y coordinate.
 869  2399 ~                   ld de,5*256+7       ; mid-point of sprite.
 870  2399 ~                   add hl,de           ; point to centre of sprite.
 871  2399 ~                   call fpslot         ; find particle slot.
 872  2399 ~                   jr c,ptusr1         ; free slot.
 873  2399 ~                   ret                 ; out of slots, can't generate anything.
 874  2399 ~
 875  2399 ~            ptusr1 ld (ix+3),l         ; set up x.
 876  2399 ~                   ld (ix+5),h         ; set up y coordinate.
 877  2399 ~                   ld a,c              ; restore timer.
 878  2399 ~                   ld (ix+1),a         ; set time on screen.
 879  2399 ~                   ld (ix+0),7         ; define particle as user particle.
 880  2399 ~                   jp chkxy            ; plot first position.
 881  2399 ~
 882  2399 ~
 883  2399 ~            ; Create a vertical or horizontal star.
 884  2399 ~
 885  2399 ~            star   push ix             ; store pointer to sprite.
 886  2399 ~                   call fpslot         ; find particle slot.
 887  2399 ~                   jp c,star7          ; found one we can use.
 888  2399 ~            star0  pop ix              ; restore sprite pointer.
 889  2399 ~                   ret                 ; out of slots, can't generate anything.
 890  2399 ~
 891  2399 ~            star7  ld a,c              ; direction.
 892  2399 ~                   and 3               ; is it left?
 893  2399 ~                   jr z,star1          ; yes, it's horizontal.
 894  2399 ~                   dec a               ; is it right?
 895  2399 ~                   jr z,star2          ; yes, it's horizontal.
 896  2399 ~                   dec a               ; is it up?
 897  2399 ~                   jr z,star3          ; yes, it's vertical.
 898  2399 ~
 899  2399 ~                   ld a,(wntopx)       ; get edge of screen.
 900  2399 ~                   inc a               ; down one pixel.
 901  2399 ~            star8  ld (ix+3),a         ; set x coord.
 902  2399 ~                   call qrand          ; get quick random number.
 903  2399 ~            star9  ld (ix+5),a         ; set y position.
 904  2399 ~                   ld a,c              ; direction.
 905  2399 ~                   and 3               ; zero to three.
 906  2399 ~                   add a,3             ; 3 to 6 for starfield.
 907  2399 ~                   ld (ix+0),a         ; define particle as star.
 908  2399 ~                   call chkxy          ; plot first position.
 909  2399 ~                   jp star0
 910  2399 ~            star1  call qrand          ; get quick random number.
 911  2399 ~                   ld (ix+3),a         ; set x coord.
 912  2399 ~                   ld a,(wnrgtx)       ; get edge of screen.
 913  2399 ~                   add a,8             ; add width of sprite minus 1.
 914  2399 ~                   jp star9
 915  2399 ~            star2  call qrand          ; get quick random number.
 916  2399 ~                   ld (ix+3),a         ; set x coord.
 917  2399 ~                   ld a,(wnlftx)       ; get edge of screen.
 918  2399 ~                   jp star9
 919  2399 ~            star3  ld a,(wnbotx)       ; get edge of screen.
 920  2399 ~                   add a,15            ; height of sprite minus one pixel.
 921  2399 ~                   jp star8
 922  2399 ~
 923  2399 ~
 924  2399 ~            ; Find particle slot for lasers or vapour trail.
 925  2399 ~            ; Can't use alternate accumulator.
 926  2399 ~
 927  2399 ~            fpslot ld ix,SHRAPN        ; shrapnel table.
 928  2399 ~                   ld de,SHRSIZ        ; size of each particle.
 929  2399 ~                   ld b,NUMSHR         ; number of pieces in table.
 930  2399 ~            fpslt0 ld a,(ix+0)         ; get type.
 931  2399 ~                   rla                 ; is this slot in use?
 932  2399 ~                   ret c               ; no, we can use it.
 933  2399 ~                   add ix,de           ; point to more shrapnel.
 934  2399 ~                   djnz fpslt0         ; repeat for all shrapnel.
 935  2399 ~                   ret                 ; out of slots, can't generate anything.
 936  2399 ~
 937  2399 ~            ; Create an explosion at sprite position.
 938  2399 ~
 939  2399 ~            explod ld c,a              ; particles to create.
 940  2399 ~                   push ix             ; store pointer to sprite.
 941  2399 ~                   ld l,(ix+8)         ; x coordinate.
 942  2399 ~                   ld h,(ix+9)         ; y coordinate.
 943  2399 ~                   ld ix,SHRAPN        ; shrapnel table.
 944  2399 ~                   ld de,SHRSIZ        ; size of each particle.
 945  2399 ~                   ld b,NUMSHR         ; number of pieces in table.
 946  2399 ~            expld0 ld a,(ix+0)         ; get type.
 947  2399 ~                   rla                 ; is this slot in use?
 948  2399 ~                   jr c,expld1         ; no, we can use it.
 949  2399 ~            expld2 add ix,de           ; point to more shrapnel.
 950  2399 ~                   djnz expld0         ; repeat for all shrapnel.
 951  2399 ~            expld3 pop ix              ; restore sprite pointer.
 952  2399 ~                   ret                 ; out of slots, can't generate any more.
 953  2399 ~            expld1 ld a,c              ; shrapnel counter.
 954  2399 ~                   and 15              ; 0 to 15.
 955  2399 ~                   add a,l             ; add to x.
 956  2399 ~                   ld (ix+3),a         ; x coord.
 957  2399 ~                   ld a,(seed3)        ; crap random number.
 958  2399 ~                   and 7               ; 0 to 7.
 959  2399 ~                   inc a               ; 1 to 8.
 960  2399 ~                   add a,h             ; add to y.
 961  2399 ~                   ld (ix+5),a         ; y coord.
 962  2399 ~                   ld (ix+0),2         ; switch it on.
 963  2399 ~                   push hl             ; store coordinates.
 964  2399 ~                   call chkxy          ; plot first position.
 965  2399 ~                   call qrand          ; quick random angle.
 966  2399 ~                   and 60              ; keep within range.
 967  2399 ~                   ld (ix+1),a         ; angle.
 968  2399 ~                   pop hl              ; restore coordinates.
 969  2399 ~                   ld de,SHRSIZ        ; restore size of each particle.
 970  2399 ~                   dec c               ; one piece of shrapnel fewer to generate.
 971  2399 ~                   jr nz,expld2        ; back to main explosion loop.
 972  2399 ~                   jr expld3           ; restore sprite pointer and exit.
 973  2399 ~            qrand  ld a,(seed3)        ; random seed.
 974  2399 ~                   ld l,a              ; low byte.
 975  2399 ~                   ld h,0              ; no high byte.
 976  2399 ~                   ld a,r              ; r register.
 977  2399 ~                   xor (hl)            ; combine with seed.
 978  2399 ~                   ld (seed3),a        ; new seed.
 979  2399 ~                   ret
 980  2399 ~            seed3  defb 0
 981  2399 ~
 982  2399 ~            ; Display all shrapnel.
 983  2399 ~
 984  2399 ~            dshrp  ld hl,plotde        ; display routine.
 985  2399 ~                   ld (proshx+1),hl    ; modify routine.
 986  2399 ~                   call proshr         ; process shrapnel.
 987  2399 ~                   ld hl,prosh1        ; processing routine.
 988  2399 ~                   ld (proshx+1),hl    ; modify the call.
 989  2399 ~                   ret
 990  2399 ~
 991  2399 ~            ; Particle engine.
 992  2399 ~
 993  2399 ~            inishr ld hl,SHRAPN        ; table.
 994  2399 ~                   ld b,NUMSHR         ; shrapnel pieces to process.
 995  2399 ~                   ld de,SHRSIZ        ; distance to next.
 996  2399 ~            inish0 ld (hl),255         ; kill the shrapnel.
 997  2399 ~                   add hl,de           ; point there.
 998  2399 ~                   djnz inish0         ; round again.
 999  2399 ~                   ret
1000  2399 ~
1001  2399 ~            ; Check for collision between laser and sprite.
1002  2399 ~
1003  2399 ~            lcol   ld hl,SHRAPN        ; shrapnel table.
1004  2399 ~                   ld de,SHRSIZ        ; size of each particle.
1005  2399 ~                   ld b,NUMSHR         ; number of pieces in table.
1006  2399 ~            lcol0  ld a,(hl)           ; get type.
1007  2399 ~                   and a               ; is this slot a laser?
1008  2399 ~                   jr z,lcol1          ; yes, check collision.
1009  2399 ~            lcol3  add hl,de           ; point to more shrapnel.
1010  2399 ~                   djnz lcol0          ; repeat for all shrapnel.
1011  2399 ~                   ret                 ; no collision, carry not set.
1012  2399 ~            lcol1  push hl             ; store pointer to laser.
1013  2399 ~                   inc hl              ; direction.
1014  2399 ~                   inc hl              ; not used.
1015  2399 ~                   inc hl              ; x position.
1016  2399 ~                   ld a,(hl)           ; get x.
1017  2399 ~                   sub (ix+X)          ; subtract sprite x.
1018  2399 ~            lcolh  cp 16               ; within range?
1019  2399 ~                   jr nc,lcol2         ; no, missed.
1020  2399 ~                   inc hl              ; not used.
1021  2399 ~                   inc hl              ; y position.
1022  2399 ~                   ld a,(hl)           ; get y.
1023  2399 ~                   add a,4             ; add width of laser.
1024  2399 ~                   sub (ix+Y)          ; subtract sprite y.
1025  2399 ~                   cp 14               ; within range?
1026  2399 ~                   jr c,lcol4          ; yes, collision occurred.
1027  2399 ~            lcol2  pop hl              ; restore laser pointer from stack.
1028  2399 ~                   jr lcol3
1029  2399 ~            lcol4  pop hl              ; restore laser pointer.
1030  2399 ~                   ret                 ; return with carry set for collision.
1031  2399 ~
1032  2399              		ELSE				; ContainerMod by Ramon Fernandez Ameijeiras
1033  2399
1034  2399              inishr	equ $
1035  2399              vapour	equ $
1036  2399              explod	equ $
1037  2399              proshr	equ $
1038  2399 C9           dshrp	ret
1039  239A
1040  239A              		ENDIF				; ContainerMod by Ramon Fernandez Ameijeiras
1041  239A
1042  239A              ; Main game engine code starts here.
1043  239A
1044  239A              game   equ $
1045  239A
1046  239A              	   ; call SetLastHardwarePalette
1047  239A                     ; call setpal         ; set up palette.
1048  239A CD 99 23     rpblc2 call inishr         ; initialise particle engine.
1049  239D CD EA 36     evintr call evnt12         ; call intro/menu event.
1050  23A0
1051  23A0 21 00 A0            ld hl,MAP           ; block properties.
1052  23A3 11 01 A0            ld de,MAP+1         ; next byte.
1053  23A6 01 1F 03            ld bc,799           ; size of properties map = 32 x 25.
1054  23A9 36 02               ld (hl),WALL        ; write default property.
1055  23AB ED B0               ldir
1056  23AD CD CA 22            call iniob          ; initialise objects.
1057  23B0 AF                  xor a               ; put zero in accumulator.
1058  23B1 32 7F 22            ld (gamwon),a       ; reset game won flag.
1059  23B4
1060  23B4 21 4E 26            ld hl,score         ; score.
1061  23B7 CD F1 24            call inisc          ; init the score.
1062  23BA 3A C3 33     mapst  ld a,(stmap)        ; start position on map.
1063  23BD 32 B0 33            ld (roomtb),a       ; set up position in table, if there is one.
1064  23C0 CD F4 4A     inipbl call ibloc          ; set up first screen.
1065  23C3 DD 21 9F 33         ld ix,ssprit        ; default to spare sprite in table.
1066  23C7 CD 8A 37     evini  call evnt13         ; initialisation.
1067  23CA
1068  23CA              ; Two restarts.
1069  23CA              ; First restart - clear all sprites and initialise everything.
1070  23CA
1071  23CA CD AC 24     rstrt  call rsevt          ; restart events.
1072  23CD CD B3 22            call xspr           ; clear sprite table.
1073  23D0 CD F6 30            call sprlst         ; fetch pointer to screen sprites.
1074  23D3 CD 3F 31            call ispr           ; initialise sprite table.
1075  23D6 18 0C               jr rstrt0
1076  23D8
1077  23D8              ; Second restart - clear all but player, and don't initialise him.
1078  23D8
1079  23D8 CD AC 24     rstrtn call rsevt          ; restart events.
1080  23DB CD 0D 31            call nspr           ; clear all non-player sprites.
1081  23DE CD F6 30            call sprlst         ; fetch pointer to screen sprites.
1082  23E1 CD 65 31            call kspr           ; initialise sprite table, no more players.
1083  23E4
1084  23E4
1085  23E4              ; Set up the player and/or enemy sprites.
1086  23E4
1087  23E4 AF           rstrt0 xor a               ; zero in accumulator.
1088  23E5 32 7C 22            ld (nexlev),a       ; reset next level flag.
1089  23E8 32 7D 22            ld (restfl),a       ; reset restart flag.
1090  23EB 32 7E 22            ld (deadf),a        ; reset dead flag.
1091  23EE CD 56 29            call droom          ; show screen layout.
1092  23F1 CD F7 4A     rpblc0 call rbloc          ; redraw blocks if in adventure mode.
1093  23F4 CD 99 23            call inishr         ; initialise particle engine.
1094  23F7 CD 1E 25            call shwob          ; draw objects.
1095  23FA DD 21 D3 32         ld ix,sprtab        ; address of sprite table, even sprites.
1096  23FE CD 95 2D            call dspr           ; display sprites.
1097  2401 DD 21 E4 32         ld ix,sprtab+TABSIZ ; address of first odd sprite.
1098  2405 CD 95 2D            call dspr           ; display sprites.
1099  2408
1100  2408 CD EC 22     mloop  call vsync          ; synchronise with display.
1101  240B
1102  240B DD 21 D3 32         ld ix,sprtab        ; address of sprite table, even sprites.
1103  240F CD 95 2D            call dspr           ; display even sprites.
1104  2412
1105  2412 CD F1 4A            call plsnd          ; play sounds.
1106  2415 CD EC 22            call vsync          ; synchronise with display.
1107  2418 DD 21 E4 32         ld ix,sprtab+TABSIZ ; address of first odd sprite.
1108  241C CD 95 2D            call dspr           ; display odd sprites.
1109  241F DD 21 9F 33         ld ix,ssprit        ; point to spare sprite for spawning purposes.
1110  2423 CD 9E 36     evlp1  call evnt10         ; called once per main loop.
1111  2426 CD 50 2D            call pspr           ; process sprites.
1112  2429
1113  2429              ; Main loop events.
1114  2429
1115  2429 DD 21 9F 33         ld ix,ssprit        ; point to spare sprite for spawning purposes.
1116  242D CD E9 36     evlp2  call evnt11         ; called once per main loop.
1117  2430
1118  2430 CD 01 2D     bsortx call bsort          ; sort sprites.
1119  2433 3A 7C 22            ld a,(nexlev)       ; finished level flag.
1120  2436 A7                  and a               ; has it been set?
1121  2437 20 1D               jr nz,newlev        ; yes, go to next level.
1122  2439 3A 7F 22            ld a,(gamwon)       ; finished game flag.
1123  243C A7                  and a               ; has it been set?
1124  243D 20 27               jr nz,evwon         ; yes, finish the game.
1125  243F 3A 7D 22            ld a,(restfl)       ; finished level flag.
1126  2442 3D                  dec a               ; has it been set?
1127  2443 28 85               jr z,rstrt          ; yes, go to next level.
1128  2445 3D                  dec a               ; has it been set?
1129  2446 28 90               jr z,rstrtn         ; yes, go to next level.
1130  2448
1131  2448 3A 7E 22            ld a,(deadf)        ; dead flag.
1132  244B A7                  and a               ; is it non-zero?
1133  244C 20 1E               jr nz,pdead         ; yes, player dead.
1134  244E
1135  244E 21 50 22            ld hl,frmno         ; game frame.
1136  2451 34                  inc (hl)            ; advance the frame.
1137  2452
1138  2452              ; Back to start of main loop.
1139  2452
1140  2452 C3 08 24     qoff   jp mloop            ; switched to a jp nz,mloop during test mode.
1141  2455 C9                  ret
1142  2456 3A 5A 22     newlev ld a,(scno)         ; current screen.
1143  2459 21 64 46            ld hl,numsc         ; total number of screens.
1144  245C 3C                  inc a               ; next screen.
1145  245D BE                  cp (hl)             ; reached the limit?
1146  245E 30 06               jr nc,evwon         ; yes, game finished.
1147  2460 32 5A 22            ld (scno),a         ; set new level number.
1148  2463 C3 CA 23            jp rstrt            ; restart, clearing all aliens.
1149  2466 CD 83 38     evwon  call evnt18         ; game completed.
1150  2469 C3 7D 24            jp tidyup           ; tidy up and return to BASIC/calling routine.
1151  246C
1152  246C              ; Player dead.
1153  246C
1154  246C AF           pdead  xor a               ; zeroise accumulator.
1155  246D 32 7E 22            ld (deadf),a        ; reset dead flag.
1156  2470 CD 67 38     evdie  call evnt16         ; death subroutine.
1157  2473 3A 5B 22            ld a,(numlif)       ; number of lives.
1158  2476 A7                  and a               ; reached zero yet?
1159  2477 C2 CA 23            jp nz,rstrt         ; restart game.
1160  247A CD 79 38     evfail call evnt17         ; failure event.
1161  247D 21 54 26     tidyup ld hl,hiscor        ; high score.
1162  2480 11 4E 26            ld de,score         ; player's score.
1163  2483 06 06               ld b,6              ; digits to check.
1164  2485 1A           tidyu2 ld a,(de)           ; get score digit.
1165  2486 BE                  cp (hl)             ; are we larger than high score digit?
1166  2487 38 06               jr c,tidyu0         ; high score is bigger.
1167  2489 20 11               jr nz,tidyu1        ; score is greater, record new high score.
1168  248B 23                  inc hl              ; next digit of high score.
1169  248C 13                  inc de              ; next digit of score.
1170  248D 10 F6               djnz tidyu2         ; repeat for all digits.
1171  248F CD 03 BB     tidyu0 call 47875          ; reset key manager, empty buffer.
1172  2492 2A 0F 23            ld hl,(firmad)      ; firmware interrupt address.
1173  2495 22 39 00            ld (57),hl          ; restore interrupts.
1174  2498 21 4E 26            ld hl,score         ; return pointing to score so programmer can store high-score.
1175  249B C9                  ret
1176  249C 21 4E 26     tidyu1 ld hl,score         ; score.
1177  249F 11 54 26            ld de,hiscor        ; high score.
1178  24A2 01 06 00            ld bc,6             ; digits to copy.
1179  24A5 ED B0               ldir                ; copy score to high score.
1180  24A7 CD 8D 38     evnewh call evnt19         ; new high score event.
1181  24AA 18 E3               jr tidyu0           ; tidy up.
1182  24AC
1183  24AC              ; Restart event.
1184  24AC
1185  24AC DD 21 9F 33  rsevt  ld ix,ssprit        ; default to spare element in table.
1186  24B0 C3 1E 38     evrs   jp evnt14           ; call restart event.
1187  24B3
1188  24B3              ; Copy number passed in a to string position bc, right-justified.
1189  24B3
1190  24B3 6F           num2ch ld l,a              ; put accumulator in l.
1191  24B4 26 00               ld h,0              ; blank high byte of hl.
1192  24B6 3E 20               ld a,32             ; leading spaces.
1193  24B8 11 64 00     numdg3 ld de,100           ; hundreds column.
1194  24BB CD C9 24            call numdg          ; show digit.
1195  24BE 11 0A 00     numdg2 ld de,10            ; tens column.
1196  24C1 CD C9 24            call numdg          ; show digit.
1197  24C4 F6 10               or 16               ; last digit is always shown.
1198  24C6 11 01 00            ld de,1             ; units column.
1199  24C9 E6 30        numdg  and 48              ; clear carry, clear digit.
1200  24CB ED 52        numdg1 sbc hl,de           ; subtract from column.
1201  24CD 38 05               jr c,numdg0         ; nothing to show.
1202  24CF F6 10               or 16               ; something to show, make it a digit.
1203  24D1 3C                  inc a               ; increment digit.
1204  24D2 18 F7               jr numdg1           ; repeat until column is zero.
1205  24D4 19           numdg0 add hl,de           ; restore total.
1206  24D5 FE 20               cp 32               ; leading space?
1207  24D7 C8                  ret z               ; yes, don't write that.
1208  24D8 02                  ld (bc),a           ; write digit to buffer.
1209  24D9 03                  inc bc              ; next buffer position.
1210  24DA C9                  ret
1211  24DB 6F           num2dd ld l,a              ; put accumulator in l.
1212  24DC 26 00               ld h,0              ; blank high byte of hl.
1213  24DE 3E 20               ld a,32             ; leading spaces.
1214  24E0 11 64 00            ld de,100           ; hundreds column.
1215  24E3 CD C9 24            call numdg          ; show digit.
1216  24E6 F6 10               or 16               ; second digit is always shown.
1217  24E8 18 D4               jr numdg2
1218  24EA 6F           num2td ld l,a              ; put accumulator in l.
1219  24EB 26 00               ld h,0              ; blank high byte of hl.
1220  24ED 3E 30               ld a,48             ; leading spaces.
1221  24EF 18 C7               jr numdg3
1222  24F1
1223  24F1
1224  24F1 06 06        inisc  ld b,6              ; digits to initialise.
1225  24F3 36 30        inisc0 ld (hl),'0'         ; write zero digit.
1226  24F5 23                  inc hl              ; next column.
1227  24F6 10 FB               djnz inisc0         ; repeat for all digits.
1228  24F8 C9                  ret
1229  24F9
1230  24F9
1231  24F9              ; Multiply h by d and return in hl.
1232  24F9
1233  24F9 5A           imul   ld e,d              ; HL = H * D
1234  24FA 4C                  ld c,h              ; make c first multiplier.
1235  24FB 21 00 00     imul0  ld hl,0             ; zeroise total.
1236  24FE 54                  ld d,h              ; zeroise high byte.
1237  24FF 06 08               ld b,8              ; repeat 8 times.
1238  2501 CB 19        imul1  rr c                ; rotate rightmost bit into carry.
1239  2503 30 02               jr nc,imul2         ; wasn't set.
1240  2505 19                  add hl,de           ; bit was set, so add de.
1241  2506 A7                  and a               ; reset carry.
1242  2507 CB 13        imul2  rl e                ; shift de 1 bit left.
1243  2509 CB 12               rl d
1244  250B 10 F4               djnz imul1          ; repeat 8 times.
1245  250D C9                  ret
1246  250E
1247  250E              ; Divide d by e and return in d, remainder in a.
1248  250E
1249  250E AF           idiv   xor a
1250  250F 06 08               ld b,8              ; bits to shift.
1251  2511 CB 22        idiv0  sla d               ; multiply d by 2.
1252  2513 17                  rla                 ; shift carry into remainder.
1253  2514 BB                  cp e                ; test if e is smaller.
1254  2515 38 02               jr c,idiv1          ; e is greater, no division this time.
1255  2517 93                  sub e               ; subtract it.
1256  2518 14                  inc d               ; rotate into d.
1257  2519 10 F6        idiv1  djnz idiv0
1258  251B C9                  ret
1259  251C
1260  251C              ; Initialise a sound.
1261  251C
1262  251C              		IF SOUNDFX == 1				; ContainerMod by Ramon Fernandez Ameijeiras
1263  251C ~
1264  251C ~            isnd   ld de,(ch1ptr)      ; first pointer.
1265  251C ~                   ld a,(de)           ; get first byte.
1266  251C ~                   inc a               ; reached the end?
1267  251C ~                   jr z,isnd1          ; that'll do.
1268  251C ~                   ld de,(ch2ptr)      ; second pointer.
1269  251C ~                   ld a,(de)           ; get first byte.
1270  251C ~                   inc a               ; reached the end?
1271  251C ~                   jr z,isnd2          ; that'll do.
1272  251C ~                   ld de,(ch3ptr)      ; final pointer.
1273  251C ~                   ld a,(de)           ; get first byte.
1274  251C ~                   inc a               ; reached the end?
1275  251C ~                   jr z,isnd3          ; that'll do.
1276  251C ~                   ret
1277  251C ~            isnd1  ld (ch1ptr),hl      ; set up the sound.
1278  251C ~                   ret
1279  251C ~            isnd2  ld (ch2ptr),hl      ; set up the sound.
1280  251C ~                   ret
1281  251C ~            isnd3  ld (ch3ptr),hl      ; set up the sound.
1282  251C ~                   ret
1283  251C ~
1284  251C ~
1285  251C ~            ch1ptr defw nosnd
1286  251C ~            ch2ptr defw nosnd
1287  251C ~            ch3ptr defw nosnd
1288  251C ~
1289  251C ~            ; Write the contents of our AY buffer to the AY registers.
1290  251C ~
1291  251C ~            w8912  ld hl,snddat        ; start of AY-3-8912 register data.
1292  251C ~                   ld de,14*256        ; start with register 0, 14 to write.
1293  251C ~                   ld c,253            ; low byte of port to write.
1294  251C ~            w8912a ld b,255            ; port 65533=select soundchip register.
1295  251C ~                   ld a,(hl)           ; value to write.
1296  251C ~                   ld c,e              ; register to write.
1297  251C ~
1298  251C ~                   ld b,244            ; setup PSG register number on PPI port A.
1299  251C ~                   out (c),c           ;
1300  251C ~                   ld bc,63168         ; tell PSG to select register from data on PPI port A.
1301  251C ~                   out (c),c           ;
1302  251C ~                   ld bc,62976         ; put PSG into inactive state.
1303  251C ~                   out (c),c           ;
1304  251C ~                   ld b,244            ; setup register data on PPI port A.
1305  251C ~                   out (c),a           ;
1306  251C ~                   ld bc,63104         ; tell PSG to write data on PPI port A into selected register.
1307  251C ~                   out (c),c           ;
1308  251C ~                   ld bc,62976         ; put PSG into inactive state.
1309  251C ~                   out (c),c           ;
1310  251C ~
1311  251C ~                   inc e               ; next sound chip register.
1312  251C ~                   inc hl              ; next byte to write.
1313  251C ~                   dec d               ; decrement loop counter.
1314  251C ~                   jp nz,w8912a        ; repeat until done.
1315  251C ~                   ret
1316  251C ~
1317  251C ~            snddat defw 0              ; tone registers, channel A.
1318  251C ~                   defw 0              ; channel B tone registers.
1319  251C ~                   defw 0              ; as above, channel C.
1320  251C ~            sndwnp defb 0              ; white noise period.
1321  251C ~            sndmix defb 60             ; tone/noise mixer control.
1322  251C ~            sndv1  defb 0              ; channel A amplitude/envelope generator.
1323  251C ~            sndv2  defb 0              ; channel B amplitude/envelope.
1324  251C ~            sndv3  defb 0              ; channel C amplitude/envelope.
1325  251C ~                   defw 0              ; duration of each note.
1326  251C ~                   defb 0
1327  251C ~
1328  251C ~            plwn   inc hl              ; next byte of sound.
1329  251C ~                   and 56              ; check if we're bothering with white noise.
1330  251C ~                   ret nz              ; we're not.
1331  251C ~                   ld a,(hl)           ; fetch byte.
1332  251C ~                   ld (sndwnp),a       ; set white noise period.
1333  251C ~                   ret
1334  251C ~
1335  251C ~
1336  251C ~            plsnd2 call cksnd2         ; check sound for first channel.
1337  251C ~                   cp 255              ; reached end?
1338  251C ~                   jr z,silen2         ; silence this channel.
1339  251C ~                   and 15              ; sound bits.
1340  251C ~                   ld (sndv2),a        ; set volume for channel.
1341  251C ~                   ld a,(sndmix)       ; mixer byte.
1342  251C ~                   and 237             ; remove bits for this channel.
1343  251C ~                   ld b,a              ; store in b register.
1344  251C ~                   call plmix          ; fetch mixer details.
1345  251C ~                   and 18              ; mixer bits we want.
1346  251C ~                   or b                ; combine with mixer bits.
1347  251C ~                   ld (sndmix),a       ; new mixer value.
1348  251C ~                   call plwn           ; white noise check.
1349  251C ~                   inc hl              ; tone low.
1350  251C ~                   ld e,(hl)           ; fetch value.
1351  251C ~                   inc hl              ; tone high.
1352  251C ~                   ld d,(hl)           ; fetch value.
1353  251C ~                   ld (snddat+2),de    ; set tone.
1354  251C ~                   inc hl              ; next bit of sound.
1355  251C ~                   ld (ch2ptr),hl      ; set pointer.
1356  251C ~                   ret
1357  251C ~
1358  251C ~            plsnd3 call cksnd3         ; check sound for first channel.
1359  251C ~                   cp 255              ; reached end?
1360  251C ~                   jr z,silen3         ; silence last channel.
1361  251C ~                   and 15              ; sound bits.
1362  251C ~                   ld (sndv3),a        ; set volume for channel.
1363  251C ~                   ld a,(sndmix)       ; mixer byte.
1364  251C ~                   and 219             ; remove bits for this channel.
1365  251C ~                   ld b,a              ; store in b register.
1366  251C ~                   call plmix          ; fetch mixer details.
1367  251C ~                   and 36              ; mixer bits we want.
1368  251C ~                   or b                ; combine with mixer bits.
1369  251C ~                   ld (sndmix),a       ; new mixer value.
1370  251C ~                   call plwn           ; white noise check.
1371  251C ~                   inc hl              ; tone low.
1372  251C ~                   ld e,(hl)           ; fetch value.
1373  251C ~                   inc hl              ; tone high.
1374  251C ~                   ld d,(hl)           ; fetch value.
1375  251C ~                   ld (snddat+4),de    ; set tone.
1376  251C ~                   inc hl              ; next bit of sound.
1377  251C ~                   ld (ch3ptr),hl      ; set pointer.
1378  251C ~                   ret
1379  251C ~
1380  251C ~            plmix  ld a,(hl)           ; fetch mixer byte.
1381  251C ~                   and 192             ; mix bits are d6 and d7.
1382  251C ~                   rlca                ; rotate into d0 and d1.
1383  251C ~                   rlca
1384  251C ~                   ld e,a              ; displacement in de.
1385  251C ~                   ld d,0
1386  251C ~                   push hl             ; store pointer on stack.
1387  251C ~                   ld hl,mixtab        ; mixer table.
1388  251C ~                   add hl,de           ; point to mixer byte.
1389  251C ~                   ld a,(hl)           ; fetch mixer value.
1390  251C ~                   pop hl              ; restore pointer.
1391  251C ~                   ret
1392  251C ~            mixtab defb 63,56,7,0      ; mixer byte settings.
1393  251C ~
1394  251C ~            silen1 xor a               ; zero.
1395  251C ~                   ld (sndv1),a        ; sound off.
1396  251C ~                   ld a,(sndmix)       ; mixer byte.
1397  251C ~                   or 9                ; mix bits off.
1398  251C ~                   ld (sndmix),a       ; mixer setting for channel.
1399  251C ~                   ret
1400  251C ~            silen2 xor a               ; zero.
1401  251C ~                   ld (sndv2),a        ; sound off.
1402  251C ~                   ld a,(sndmix)       ; mixer byte.
1403  251C ~                   or 18               ; mix bits off.
1404  251C ~                   ld (sndmix),a       ; mixer setting for channel.
1405  251C ~                   ret
1406  251C ~            silen3 xor a               ; zero.
1407  251C ~                   ld (sndv3),a        ; sound off.
1408  251C ~                   ld a,(sndmix)       ; mixer byte.
1409  251C ~                   or 36               ; mix bits off.
1410  251C ~                   ld (sndmix),a       ; mixer setting for channel.
1411  251C ~                   ret
1412  251C ~            cksnd1 ld hl,(ch1ptr)      ; pointer to sound.
1413  251C ~                   ld a,(hl)           ; fetch mixer/flag.
1414  251C ~                   ret
1415  251C ~            cksnd2 ld hl,(ch2ptr)      ; pointer to sound.
1416  251C ~                   ld a,(hl)           ; fetch mixer/flag.
1417  251C ~                   ret
1418  251C ~            cksnd3 ld hl,(ch3ptr)      ; pointer to sound.
1419  251C ~                   ld a,(hl)           ; fetch mixer/flag.
1420  251C ~                   ret
1421  251C ~
1422  251C ~            plsnd1 call cksnd1         ; check sound for first channel.
1423  251C ~                   cp 255              ; reached end?
1424  251C ~                   jr z,silen1         ; silence first channel.
1425  251C ~                   and 15              ; sound bits.
1426  251C ~                   ld (sndv1),a        ; set volume for channel.
1427  251C ~                   ld a,(sndmix)       ; mixer byte.
1428  251C ~                   and 246             ; remove bits for this channel.
1429  251C ~                   ld b,a              ; store in b register.
1430  251C ~                   call plmix          ; fetch mixer details.
1431  251C ~                   and 9               ; mixer bits we want.
1432  251C ~                   or b                ; combine with mixer bits.
1433  251C ~                   ld (sndmix),a       ; new mixer value.
1434  251C ~                   call plwn           ; white noise check.
1435  251C ~                   inc hl              ; tone low.
1436  251C ~                   ld e,(hl)           ; fetch value.
1437  251C ~                   inc hl              ; tone high.
1438  251C ~                   ld d,(hl)           ; fetch value.
1439  251C ~                   ld (snddat),de      ; set tone.
1440  251C ~                   inc hl              ; next bit of sound.
1441  251C ~                   ld (ch1ptr),hl      ; set pointer.
1442  251C ~                   ret
1443  251C ~
1444  251C              		ELSE
1445  251C C9           isnd	ret
1446  251D              silen1
1447  251D              silen2
1448  251D C9           silen3	ret
1449  251E              		ENDIF
1450  251E
1451  251E              ; Objects handling.
1452  251E              ; 32 bytes for image
1453  251E              ; 1 for colour
1454  251E              ; 3 for room, x and y
1455  251E              ; 3 for starting room, x and y.
1456  251E              ; 254 = disabled.
1457  251E              ; 255 = object in player's pockets.
1458  251E
1459  251E              ; Show items present.
1460  251E
1461  251E 21 2B 47     shwob  ld hl,objdta        ; objects table.
1462  2521 11 40 00            ld de,64            ; distance to room number.
1463  2524 19                  add hl,de           ; point to room data.
1464  2525 3A 55 22            ld a,(numob)        ; number of objects in the game.
1465  2528 47                  ld b,a              ; loop counter.
1466  2529 C5           shwob0 push bc             ; store count.
1467  252A E5                  push hl             ; store item pointer.
1468  252B 3A 5A 22            ld a,(scno)         ; current location.
1469  252E BE                  cp (hl)             ; same as an item?
1470  252F CC 3B 25            call z,dobj         ; yes, display object.
1471  2532 E1                  pop hl              ; restore pointer.
1472  2533 C1                  pop bc              ; restore counter.
1473  2534 11 46 00            ld de,70            ; distance to next item.
1474  2537 19                  add hl,de           ; point to it.
1475  2538 10 EF               djnz shwob0         ; repeat for others.
1476  253A C9                  ret
1477  253B
1478  253B              ; Display object.
1479  253B              ; hl must point to object's room number.
1480  253B
1481  253B 23           dobj   inc hl              ; point to x.
1482  253C 11 80 22     dobj0  ld de,dispx         ; coordinates.
1483  253F ED A0               ldi                 ; transfer x coord.
1484  2541 ED A0               ldi                 ; transfer y too.
1485  2543 11 BD FF            ld de,65469         ; minus 67.
1486  2546 19                  add hl,de           ; point to image.
1487  2547 C3 1B 29     dobj1  jp sprite           ; draw this sprite.
1488  254A
1489  254A              ; Remove an object.
1490  254A
1491  254A 21 55 22     remob  ld hl,numob         ; number of objects in game.
1492  254D BE                  cp (hl)             ; are we checking past the end?
1493  254E D0                  ret nc              ; yes, can't get non-existent item.
1494  254F F5                  push af             ; remember object.
1495  2550 CD 5A 25            call getob          ; pick it up if we haven't already got it.
1496  2553 F1                  pop af              ; retrieve object number.
1497  2554 CD 7F 25            call gotob          ; get its address.
1498  2557 36 FE               ld (hl),254         ; remove it.
1499  2559 C9                  ret
1500  255A
1501  255A              ; Pick up object number held in the accumulator.
1502  255A
1503  255A 21 55 22     getob  ld hl,numob         ; number of objects in game.
1504  255D BE                  cp (hl)             ; are we checking past the end?
1505  255E D0                  ret nc              ; yes, can't get non-existent item.
1506  255F CD 7F 25            call gotob          ; check if we already have it.
1507  2562 C8                  ret z               ; we already do.
1508  2563 EB                  ex de,hl            ; object address in de.
1509  2564 21 5A 22            ld hl,scno          ; current screen.
1510  2567 BE                  cp (hl)             ; is it on this screen?
1511  2568 EB                  ex de,hl            ; object address back in hl.
1512  2569 20 11               jr nz,getob0        ; not on screen, so nothing to delete.
1513  256B 36 FF               ld (hl),255         ; pick it up.
1514  256D 23                  inc hl              ; point to x coord.
1515  256E 5E           getob1 ld e,(hl)           ; x coord.
1516  256F 23                  inc hl              ; back to y coord.
1517  2570 56                  ld d,(hl)           ; y coord.
1518  2571 ED 53 80 22         ld (dispx),de       ; set display coords.
1519  2575 11 BE FF            ld de,65470         ; minus graphic size.
1520  2578 19                  add hl,de           ; point to graphics.
1521  2579 C3 47 25            jp dobj1            ; delete object sprite.
1522  257C 36 FF        getob0 ld (hl),255         ; pick it up.
1523  257E C9                  ret
1524  257F
1525  257F              ; Got object check.
1526  257F              ; Call with object in accumulator, returns zero set if in pockets.
1527  257F
1528  257F 21 55 22     gotob  ld hl,numob         ; number of objects in game.
1529  2582 BE                  cp (hl)             ; are we checking past the end?
1530  2583 30 06               jr nc,gotob0        ; yes, we can't have a non-existent object.
1531  2585 CD 8F 25            call findob         ; find the object.
1532  2588 FE FF        gotob1 cp 255              ; in pockets?
1533  258A C9                  ret
1534  258B 3E FE        gotob0 ld a,254            ; missing.
1535  258D 18 F9               jr gotob1
1536  258F
1537  258F 21 2B 47     findob ld hl,objdta        ; objects.
1538  2592 11 46 00            ld de,70            ; size of each object.
1539  2595 A7                  and a               ; is it zero?
1540  2596 28 04               jr z,fndob1         ; yes, skip loop.
1541  2598 47                  ld b,a              ; loop counter in b.
1542  2599 19           fndob2 add hl,de           ; point to next one.
1543  259A 10 FD               djnz fndob2         ; repeat until we find address.
1544  259C 1E 40        fndob1 ld e,64             ; distance to room it's in.
1545  259E 19                  add hl,de           ; point to room.
1546  259F 7E                  ld a,(hl)           ; fetch status.
1547  25A0 C9                  ret
1548  25A1
1549  25A1              ; Drop object number at (dispx, dispy).
1550  25A1
1551  25A1 21 55 22     drpob  ld hl,numob         ; number of objects in game.
1552  25A4 BE                  cp (hl)             ; are we checking past the end?
1553  25A5 D0                  ret nc              ; yes, can't drop non-existent item.
1554  25A6 CD 7F 25            call gotob          ; make sure object is in inventory.
1555  25A9 3A 5A 22            ld a,(scno)         ; screen number.
1556  25AC BE                  cp (hl)             ; already on this screen?
1557  25AD C8                  ret z               ; yes, nothing to do.
1558  25AE 77                  ld (hl),a           ; bring onto screen.
1559  25AF 23                  inc hl              ; point to x coord.
1560  25B0 3A 80 22            ld a,(dispx)        ; sprite x coordinate.
1561  25B3 77                  ld (hl),a           ; set x coord.
1562  25B4 23                  inc hl              ; point to object y.
1563  25B5 3A 81 22            ld a,(dispy)        ; sprite y coordinate.
1564  25B8 77                  ld (hl),a           ; set the y position.
1565  25B9 11 BE FF            ld de,65470         ; minus graphic size.
1566  25BC 19                  add hl,de           ; point to graphics.
1567  25BD C3 47 25            jp dobj1            ; delete object sprite.
1568  25C0
1569  25C0              ; Seek objects at sprite position.
1570  25C0
1571  25C0 21 2B 47     skobj  ld hl,objdta        ; pointer to objects.
1572  25C3 11 40 00            ld de,64            ; distance to room number.
1573  25C6 19                  add hl,de           ; point to room data.
1574  25C7 11 46 00            ld de,70            ; size of each object.
1575  25CA 3A 55 22            ld a,(numob)        ; number of objects in game.
1576  25CD 47                  ld b,a              ; set up the loop counter.
1577  25CE 3A 5A 22     skobj0 ld a,(scno)         ; current room number.
1578  25D1 BE                  cp (hl)             ; is object in here?
1579  25D2 CC DB 25            call z,skobj1       ; yes, check coordinates.
1580  25D5 19                  add hl,de           ; point to next object in table.
1581  25D6 10 F6               djnz skobj0         ; repeat for all objects.
1582  25D8 3E FF               ld a,255            ; end of list and nothing found, return 255.
1583  25DA C9                  ret
1584  25DB 23           skobj1 inc hl              ; point to x coordinate.
1585  25DC 7E                  ld a,(hl)           ; get coordinate.
1586  25DD DD 96 08            sub (ix+8)          ; subtract sprite x.
1587  25E0 C6 0F               add a,15            ; add sprite height minus one.
1588  25E2 FE 1F               cp 31               ; within range?
1589  25E4 D2 FA 25            jp nc,skobj2        ; no, ignore object.
1590  25E7 23                  inc hl              ; point to y coordinate now.
1591  25E8 7E                  ld a,(hl)           ; get coordinate.
1592  25E9 DD 96 09            sub (ix+9)          ; subtract the sprite y.
1593  25EC C6 08               add a,8             ; add sprite width minus one.
1594  25EE FE 12               cp 18               ; within range?
1595  25F0 D2 F9 25            jp nc,skobj3        ; no, ignore object.
1596  25F3 D1                  pop de              ; remove return address from stack.
1597  25F4 3A 55 22            ld a,(numob)        ; objects in game.
1598  25F7 90                  sub b               ; subtract loop counter.
1599  25F8 C9                  ret                 ; accumulator now points to object.
1600  25F9 2B           skobj3 dec hl              ; back to y position.
1601  25FA 2B           skobj2 dec hl              ; back to room.
1602  25FB C9                  ret
1603  25FC
1604  25FC
1605  25FC              ; Spawn a new sprite.
1606  25FC
1607  25FC 21 D3 32     spawn  ld hl,sprtab        ; sprite table.
1608  25FF C5                  push bc             ; store parameters on stack.
1609  2600 06 0C               ld b,NUMSPR         ; number of sprites.
1610  2602 11 11 00            ld de,TABSIZ        ; size of each entry.
1611  2605 7E           spaw0  ld a,(hl)           ; get sprite type.
1612  2606 3C                  inc a               ; is it an unused slot?
1613  2607 28 03               jr z,spaw1          ; yes, we can use this one.
1614  2609 19                  add hl,de           ; point to next sprite in table.
1615  260A 10 F9               djnz spaw0          ; keep going until we find a slot.
1616  260C
1617  260C              ; Didn't find one but drop through and set up a dummy sprite instead.
1618  260C
1619  260C C1           spaw1  pop bc              ; take image and type back off the stack.
1620  260D DD E5               push ix             ; existing sprite address on stack.
1621  260F 22 4A 26            ld (spptr),hl       ; store spawned sprite address.
1622  2612 71                  ld (hl),c           ; set the type.
1623  2613 23                  inc hl              ; point to image.
1624  2614 70                  ld (hl),b           ; set the image.
1625  2615 23                  inc hl              ; next byte.
1626  2616 36 00               ld (hl),0           ; frame zero.
1627  2618 23                  inc hl              ; next byte.
1628  2619 DD 7E 08            ld a,(ix+X)         ; x coordinate.
1629  261C 77                  ld (hl),a           ; set sprite coordinate.
1630  261D 23                  inc hl              ; next byte.
1631  261E DD 7E 09            ld a,(ix+Y)         ; y coordinate.
1632  2621 77                  ld (hl),a           ; set sprite coordinate.
1633  2622 23                  inc hl              ; next byte.
1634  2623 EB                  ex de,hl            ; swap address into de.
1635  2624 2A 4A 26            ld hl,(spptr)       ; restore address of details.
1636  2627 01 05 00            ld bc,5             ; number of bytes to duplicate.
1637  262A ED B0               ldir                ; copy first version to new version.
1638  262C EB                  ex de,hl            ; swap address into de.
1639  262D DD 7E 0A            ld a,(ix+10)        ; direction of original.
1640  2630 77                  ld (hl),a           ; set the direction.
1641  2631 23                  inc hl              ; next byte.
1642  2632 70                  ld (hl),b           ; reset parameter.
1643  2633 23                  inc hl              ; next byte.
1644  2634 70                  ld (hl),b           ; reset parameter.
1645  2635 23                  inc hl              ; next byte.
1646  2636 70                  ld (hl),b           ; reset parameter.
1647  2637 23                  inc hl              ; next byte.
1648  2638 70                  ld (hl),b           ; reset parameter.
1649  2639 DD 2A 4A 26  rtssp  ld ix,(spptr)       ; address of new sprite.
1650  263D CD 85 36     evis1  call evnt09         ; call sprite initialisation event.
1651  2640 DD 2A 4A 26         ld ix,(spptr)       ; address of new sprite.
1652  2644 CD 7F 2E            call sspria         ; display the new sprite.
1653  2647 DD E1               pop ix              ; address of original sprite.
1654  2649 C9                  ret
1655  264A
1656  264A 00 00        spptr  defw 0              ; spawned sprite pointer.
1657  264C 00           seed   defb 0              ; seed for random numbers.
1658  264D 00           seed2  defb 0              ; second seed.
1659  264E 30 30 30 30  score  defb '000000'       ; player's score.
1659  2652 30 30
1660  2654 30 30 30 30  hiscor defb '000000'       ; high score.
1660  2658 30 30
1661  265A 30 30 30 30  bonus  defb '000000'       ; bonus.
1661  265E 30 30
1662  2660
1663  2660 7B           checkx ld a,e              ; x position.
1664  2661 FE 18               cp 24               ; off screen?
1665  2663 D8                  ret c               ; no, it's okay.
1666  2664 E1                  pop hl              ; remove return address from stack.
1667  2665 C9                  ret
1668  2666
1669  2666              ; Displays the current score.
1670  2666
1671  2666 CD EC 2C     dscor  call preprt         ; set up font and print position.
1672  2669 CD 60 26            call checkx         ; make sure we're in a printable range.
1673  266C 3A 9E 2C            ld a,(prtmod)       ; get print mode.
1674  266F A7                  and a               ; standard size text?
1675  2670 C2 85 26            jp nz,bscor0        ; no, show double-height.
1676  2673 C5           dscor0 push bc             ; place counter onto the stack.
1677  2674 E5                  push hl
1678  2675 7E                  ld a,(hl)           ; fetch character.
1679  2676 CD 3D 28            call ptxta          ; display character and advance one.
1680  2679 E1                  pop hl
1681  267A 23                  inc hl              ; next score column.
1682  267B C1                  pop bc              ; retrieve character counter.
1683  267C 10 F5               djnz dscor0         ; repeat for all digits.
1684  267E 2A 80 22     dscor2 ld hl,(dispx)       ; general coordinates.
1685  2681 22 75 22            ld (charx),hl       ; set up display coordinates.
1686  2684 C9                  ret
1687  2685
1688  2685              ; Displays the current score in double-height characters.
1689  2685
1690  2685 C5           bscor0 push bc             ; place counter onto the stack.
1691  2686 E5                  push hl
1692  2687 7E                  ld a,(hl)           ; fetch character.
1693  2688 CD 47 28            call btxt           ; display big char.
1694  268B E1                  pop hl
1695  268C 23                  inc hl              ; next score column.
1696  268D C1                  pop bc              ; retrieve character counter.
1697  268E 10 F5               djnz bscor0         ; repeat for all digits.
1698  2690 C3 7E 26            jp dscor2           ; tidy up line and column variables.
1699  2693
1700  2693              ; Adds number in the hl pair to the score.
1701  2693
1702  2693 11 4F 26     addsc  ld de,score+1       ; ten thousands column.
1703  2696 01 10 27            ld bc,10000         ; amount to add each time.
1704  2699 CD B5 26            call incsc          ; add to score.
1705  269C 13                  inc de              ; thousands column.
1706  269D 01 E8 03            ld bc,1000          ; amount to add each time.
1707  26A0 CD B5 26            call incsc          ; add to score.
1708  26A3 13                  inc de              ; hundreds column.
1709  26A4 01 64 00            ld bc,100           ; amount to add each time.
1710  26A7 CD B5 26            call incsc          ; add to score.
1711  26AA 13                  inc de              ; tens column.
1712  26AB 01 0A 00            ld bc,10            ; amount to add each time.
1713  26AE CD B5 26            call incsc          ; add to score.
1714  26B1 13                  inc de              ; units column.
1715  26B2 01 01 00            ld bc,1             ; units.
1716  26B5 E5           incsc  push hl             ; store amount to add.
1717  26B6 A7                  and a               ; clear the carry flag.
1718  26B7 ED 42               sbc hl,bc           ; subtract from amount to add.
1719  26B9 38 09               jr c,incsc0         ; too much, restore value.
1720  26BB F1                  pop af              ; delete the previous amount from the stack.
1721  26BC D5                  push de             ; store column position.
1722  26BD CD C6 26            call incsc2         ; do the increment.
1723  26C0 D1                  pop de              ; restore column.
1724  26C1 C3 B5 26            jp incsc            ; repeat until all added.
1725  26C4 E1           incsc0 pop hl              ; restore previous value.
1726  26C5 C9                  ret
1727  26C6 1A           incsc2 ld a,(de)           ; get amount.
1728  26C7 3C                  inc a               ; add one to column.
1729  26C8 12                  ld (de),a           ; write new column total.
1730  26C9 FE 3A               cp '9'+1            ; gone beyond range of digits?
1731  26CB D8                  ret c               ; no, carry on.
1732  26CC 3E 30               ld a,'0'            ; mae it zero.
1733  26CE 12                  ld (de),a           ; write new column total.
1734  26CF 1B                  dec de              ; back one column.
1735  26D0 18 F4               jr incsc2
1736  26D2
1737  26D2              ; Add bonus to score.
1738  26D2
1739  26D2 11 53 26     addbo  ld de,score+5       ; last score digit.
1740  26D5 21 5F 26            ld hl,bonus+5       ; last bonus digit.
1741  26D8 A7                  and a               ; clear carry.
1742  26D9 01 30 06            ld bc,6*256+48      ; 6 digits to add, ASCII '0' in c.
1743  26DC 1A           addbo0 ld a,(de)           ; get score.
1744  26DD 8E                  adc a,(hl)          ; add bonus.
1745  26DE 91                  sub c               ; 0 to 18.
1746  26DF 71                  ld (hl),c           ; zeroise bonus.
1747  26E0 2B                  dec hl              ; next bonus.
1748  26E1 FE 3A               cp 58               ; carried?
1749  26E3 38 02               jr c,addbo1         ; no, do next one.
1750  26E5 D6 0A               sub 10              ; subtract 10.
1751  26E7 12           addbo1 ld (de),a           ; write new score.
1752  26E8 1B                  dec de              ; next score digit.
1753  26E9 3F                  ccf                 ; set carry for next digit.
1754  26EA 10 F0               djnz addbo0         ; repeat for all 6 digits.
1755  26EC C9                  ret
1756  26ED
1757  26ED              ; Swap score and bonus.
1758  26ED
1759  26ED 11 4E 26     swpsb  ld de,score         ; first score digit.
1760  26F0 21 5A 26            ld hl,bonus         ; first bonus digit.
1761  26F3 06 06               ld b,6              ; digits to add.
1762  26F5 1A           swpsb0 ld a,(de)           ; get score and bonus digits.
1763  26F6 4E                  ld c,(hl)
1764  26F7 EB                  ex de,hl            ; swap pointers.
1765  26F8 71                  ld (hl),c           ; write bonus and score digits.
1766  26F9 12                  ld (de),a
1767  26FA 23                  inc hl              ; next score and bonus.
1768  26FB 13                  inc de
1769  26FC 10 F7               djnz swpsb0         ; repeat for all 6 digits.
1770  26FE C9                  ret
1771  26FF
1772  26FF              ; Get print address.
1773  26FF              ; Returns screen address in de.
1774  26FF
1775  26FF E5           gprad  push hl             ; store hl pair.
1776  2700 3A 80 22            ld a,(dispx)        ; get vertical position.
1777  2703 07                  rlca                ; multiply by 8, max is 192.
1778  2704 07                  rlca
1779  2705 07                  rlca
1780  2706 6F                  ld l,a              ; put into hl.
1781  2707 26 00               ld h,0              ; still 8 bits, no high byte.
1782  2709 29                  add hl,hl           ; hl is now coordinate * 16.
1783  270A 54                  ld d,h              ; make de 16 * coordinate also.
1784  270B 5D                  ld e,l
1785  270C 29                  add hl,hl           ; hl is coordinate * 32.
1786  270D 29                  add hl,hl           ; hl is coordinate * 64.
1787  270E 19                  add hl,de           ; now it's coordinate * 80.
1788  270F 11 00 C0            ld de,49152         ; screen base address.
1789  2712 19                  add hl,de           ; add x displacement.
1790  2713
1791  2713 3A 81 22            ld a,(dispy)        ; y coordinate.
1792  2716 16 00               ld d,0              ; no displacement for odd position.
1793  2718 1F                  rra                 ; shift odd char position into carry.
1794  2719 30 02               jr nc,gprad0        ; at even position.
1795  271B 16 02               ld d,2              ; odd position is two bytes along.
1796  271D E6 0F        gprad0 and 15              ; character position / 2.
1797  271F 5F                  ld e,a              ; copy to e.
1798  2720 07                  rlca                ; multiple of 2.
1799  2721 07                  rlca                ; multiple of 4.
1800  2722 83                  add a,e             ; multiple of 5.
1801  2723 82                  add a,d             ; add on any odd displacement.
1802  2724 5F                  ld e,a              ; copy to de.
1803  2725 16 00               ld d,0              ; high byte of displacement is zero.
1804  2727 19                  add hl,de           ; point to even char position.
1805  2728 EB                  ex de,hl            ; flip result into de.
1806  2729 E1                  pop hl              ; retrieve hl.
1807  272A C9                  ret
1808  272B
1809  272B              ; Get property buffer address of char at (dispx, dispy) in hl.
1810  272B
1811  272B 3A 80 22     pradd  ld a,(dispx)        ; x coordinate.
1812  272E 0F                  rrca                ; multiply by 32.
1813  272F 0F                  rrca
1814  2730 0F                  rrca
1815  2731 6F                  ld l,a              ; store shift in l.
1816  2732 E6 03               and 3               ; high byte bits.
1817  2734 C6 A0               add a,MAPHI         ; 160 * 256 = 40960, start of properties map.
1818  2736 67                  ld h,a              ; that's our high byte.
1819  2737 7D                  ld a,l              ; restore shift result.
1820  2738 E6 E0               and 224             ; only want low bits.
1821  273A 6F                  ld l,a              ; put into low byte.
1822  273B 3A 81 22            ld a,(dispy)        ; fetch y coordinate.
1823  273E E6 1F               and 31              ; should be in range 0 - 31.
1824  2740 85                  add a,l             ; add to low byte.
1825  2741 6F                  ld l,a              ; new low byte.
1826  2742 C9                  ret
1827  2743
1828  2743              ; Display character block on screen.
1829  2743
1830  2743 CD B6 27     pchar  call gchadd         ; get character address.
1831  2746 CD FF 26     pchark call gprad          ; get screen address.
1832  2749 3A 81 22            ld a,(dispy)        ; get horizontal position.
1833  274C 1F                  rra                 ; are we displaying block at an odd position?
1834  274D DA 76 27            jp c,pchar0         ; yes, need to shift everything then.
1835  2750 CD 65 27            call pchare         ; even pixel position.
1836  2753 CD 65 27            call pchare
1837  2756 CD 65 27            call pchare
1838  2759 CD 65 27            call pchare
1839  275C CD 65 27            call pchare
1840  275F CD 65 27            call pchare
1841  2762 CD 65 27            call pchare
1842  2765
1843  2765 ED A0        pchare ldi                 ; transfer byte.
1844  2767 ED A0               ldi                 ; transfer byte.
1845  2769 1A                  ld a,(de)           ; get data on screen.
1846  276A E6 55               and 85              ; lose the left pixel colours.
1847  276C B6                  or (hl)             ; merge in third byte of data.
1848  276D 23                  inc hl              ; postincrement to next byte of data.
1849  276E 12                  ld (de),a           ; write third byte.
1850  276F EB                  ex de,hl            ; flip source and target.
1851  2770 01 FE 07            ld bc,2046          ; distance to next line.
1852  2773 09                  add hl,bc           ; look down one pixel.
1853  2774 EB                  ex de,hl            ; source and target back again.
1854  2775 C9                  ret
1855  2776
1856  2776 EB           pchar0 ex de,hl            ; screen in hl, block image in de.
1857  2777 CD 8C 27            call pcharo         ; odd pixel position.
1858  277A CD 8C 27            call pcharo
1859  277D CD 8C 27            call pcharo
1860  2780 CD 8C 27            call pcharo
1861  2783 CD 8C 27            call pcharo
1862  2786 CD 8C 27            call pcharo
1863  2789 CD 8C 27            call pcharo
1864  278C
1865  278C 7E           pcharo ld a,(hl)           ; get data from screen.
1866  278D E6 AA               and 170             ; lose the right pixel colours.
1867  278F 47                  ld b,a              ; store result.
1868  2790 1A                  ld a,(de)           ; get first byte of data to write.
1869  2791 1F                  rra                 ; shift into right position.
1870  2792 E6 55               and 85              ; get right pixel colour.
1871  2794 B0                  or b                ; merge onto screen.
1872  2795 77                  ld (hl),a           ; write that byte.
1873  2796
1874  2796 23                  inc hl              ; next screen byte.
1875  2797 1A                  ld a,(de)           ; get first byte of image again.
1876  2798 17                  rla                 ; shift second pixel into left position.
1877  2799 E6 AA               and 170             ; remove right bits.
1878  279B 47                  ld b,a              ; store for now.
1879  279C 13                  inc de              ; point to next byte of data.
1880  279D 1A                  ld a,(de)           ; get third pixel.
1881  279E 1F                  rra                 ; shift into right pixel position.
1882  279F E6 55               and 85              ; remove left pixel.
1883  27A1 B0                  or b                ; merge with previous pixel.
1884  27A2 77                  ld (hl),a           ; write to screen.
1885  27A3 23                  inc hl              ; third screen byte.
1886  27A4 1A                  ld a,(de)           ; get second byte of image again.
1887  27A5 17                  rla                 ; shift fourth pixel into left position.
1888  27A6 E6 AA               and 170             ; remove right bits.
1889  27A8 47                  ld b,a              ; store for now.
1890  27A9 13                  inc de              ; point to next byte of data.
1891  27AA 1A                  ld a,(de)           ; get fifth pixel.
1892  27AB 1F                  rra                 ; shift into right pixel position.
1893  27AC E6 55               and 85              ; remove left pixel.
1894  27AE B0                  or b                ; merge with previous pixel.
1895  27AF 77                  ld (hl),a           ; write to screen.
1896  27B0 13                  inc de              ; point to next byte of data.
1897  27B1
1898  27B1 01 FE 07            ld bc,2046          ; distance to next line.
1899  27B4 09                  add hl,bc           ; look down one pixel.
1900  27B5 C9                  ret
1901  27B6
1902  27B6              ; Get character address.
1903  27B6
1904  27B6 07           gchadd rlca                ; multiply char by 8.
1905  27B7 07                  rlca
1906  27B8 07                  rlca
1907  27B9 5F                  ld e,a              ; store shift in e.
1908  27BA E6 07               and 7               ; only want high byte bits.
1909  27BC 57                  ld d,a              ; store in d.
1910  27BD 7B                  ld a,e              ; restore shifted value.
1911  27BE E6 F8               and 248             ; only want low byte bits.
1912  27C0 5F                  ld e,a              ; that's the low byte.
1913  27C1 21 1D 39            ld hl,chgfx         ; address of graphics.
1914  27C4 19                  add hl,de           ; 8 * block number.
1915  27C5 19                  add hl,de           ; 16 * block number.
1916  27C6 19                  add hl,de           ; 24 * block number.
1917  27C7 C9                  ret
1918  27C8
1919  27C8              ; Print property attributes and pixels.
1920  27C8
1921  27C8 00           colpat defb 0
1922  27C9
1923  27C9 47           pattr  ld b,a              ; store cell in b register for now.
1924  27CA 5F                  ld e,a              ; displacement in e.
1925  27CB 16 00               ld d,0              ; no high byte.
1926  27CD 2A 87 22            ld hl,(proptr)      ; pointer to properties.
1927  27D0 19                  add hl,de           ; property cell address.
1928  27D1 4E                  ld c,(hl)           ; fetch byte.
1929  27D2 79                  ld a,c              ; put into accumulator.
1930  27D3 FE 08               cp COLECT           ; is it a collectable?
1931  27D5 C2 DC 27            jp nz,pattr1        ; no, carry on as normal.
1932  27D8 78                  ld a,b              ; restore cell.
1933  27D9 32 C8 27            ld (colpat),a       ; store collectable block.
1934  27DC CD 2B 27     pattr1 call pradd          ; get property buffer address.
1935  27DF 71                  ld (hl),c           ; write property.
1936  27E0 78                  ld a,b              ; get block number.
1937  27E1
1938  27E1              ; Print character pixels, no more.
1939  27E1
1940  27E1 CD 43 27     pchr   call pchar          ; show character in accumulator.
1941  27E4 21 81 22            ld hl,dispy         ; y coordinate.
1942  27E7 34                  inc (hl)            ; move along one.
1943  27E8 C9                  ret
1944  27E9
1945  27E9              ; Convert ink colour 0 - 15 to bitmask, 0 - 255.
1946  27E9
1947  27E9 0E 00        conink ld c,0              ; clear destination.
1948  27EB 1F                  rra                 ; test lowest bit of colour.
1949  27EC CB 11               rl c                ; shift carry into colour.
1950  27EE CB 11               rl c                ; rotate again.
1951  27F0 0F                  rrca                ; get bit d1 out of the way.
1952  27F1 1F                  rra                 ; test bit d2 of colour.
1953  27F2 CB 11               rl c                ; shift carry into mask colour.
1954  27F4 CB 11               rl c                ; rotate again.
1955  27F6 17                  rla                 ; shift original d1 bit back to d7.
1956  27F7 17                  rla                 ; rotate into carry.
1957  27F8 CB 11               rl c                ; shift carry into colour.
1958  27FA CB 11               rl c                ; rotate again.
1959  27FC 1F                  rra                 ; put original bit d3 in d0.
1960  27FD 1F                  rra
1961  27FE 1F                  rra                 ; shift into carry.
1962  27FF CB 11               rl c                ; shift carry into colour.
1963  2801 79                  ld a,c              ; copy colour to accumulator.
1964  2802 17                  rla                 ; create copy for higher bit of the pair.
1965  2803 B1                  or c                ; merge colours for both pixels.
1966  2804 C9                  ret
1967  2805
1968  2805              ; Ink and paper masks.  Don't move these around, keep together in this order.
1969  2805
1970  2805 FF           inkmsk defb 255            ; ink mask.
1971  2806 00           papmsk defb 0              ; paper mask.
1972  2807
1973  2807              ; Print text, standard 5x8 pixel size.
1974  2807
1975  2807 07           ptxt   rlca                ; multiply char by 8.
1976  2808 07                  rlca
1977  2809 07                  rlca
1978  280A 5F                  ld e,a              ; store shift in e.
1979  280B E6 07               and 7               ; only want high byte bits.
1980  280D 57                  ld d,a              ; store in d.
1981  280E 7B                  ld a,e              ; restore shifted value.
1982  280F E6 F8               and 248             ; only want low byte bits.
1983  2811 5F                  ld e,a              ; that's the low byte.
1984  2812 21 81 46            ld hl,font-256      ; address of charset.
1985  2815 19                  add hl,de           ; point to character.
1986  2816 CD FF 26            call gprad          ; get screen address in de.
1987  2819 EB                  ex de,hl            ; screen address in hl, font in de.
1988  281A
1989  281A 06 08               ld b,8              ; height.
1990  281C C5           ptxt0  push bc             ; store row counter.
1991  281D
1992  281D ED 4B 05 28         ld bc,(inkmsk)      ; get ink and paper colours.
1993  2821 3A 81 22            ld a,(dispy)        ; get y coordinate.
1994  2824 1F                  rra                 ; odd or even alignment?
1995  2825 1A                  ld a,(de)           ; get byte of image.
1996  2826 D5                  push de             ; store pointer to font data.
1997  2827 38 06               jr c,ptxt2          ; odd alignment.
1998  2829 CD D6 28            call ptxte          ; print at even cell position.
1999  282C C3 32 28            jp ptxt1
2000  282F CD 8F 28     ptxt2  call ptxto          ; print at odd cell position.
2001  2832 2B           ptxt1  dec hl              ; back to left edge of character.
2002  2833 2B                  dec hl
2003  2834 CD F9 2E            call nline2         ; down one line.
2004  2837
2005  2837 D1                  pop de              ; restore text image address.
2006  2838 13                  inc de              ; next byte.
2007  2839 C1                  pop bc              ; retrieve row counter.
2008  283A 10 E0               djnz ptxt0          ; repeat for all rows.
2009  283C C9                  ret
2010  283D CD 07 28     ptxta  call ptxt           ; show character in accumulator.
2011  2840 21 81 22            ld hl,dispy         ; y coordinate.
2012  2843 34                  inc (hl)            ; move along one.
2013  2844 CB AE               res 5,(hl)          ; don't spill over line.
2014  2846 C9                  ret
2015  2847
2016  2847
2017  2847              ; Print big text, stretched to 5x16 pixels.
2018  2847
2019  2847 07           btxt   rlca                ; multiply char by 8.
2020  2848 07                  rlca
2021  2849 07                  rlca
2022  284A 5F                  ld e,a              ; store shift in e.
2023  284B E6 07               and 7               ; only want high byte bits.
2024  284D 57                  ld d,a              ; store in d.
2025  284E 7B                  ld a,e              ; restore shifted value.
2026  284F E6 F8               and 248             ; only want low byte bits.
2027  2851 5F                  ld e,a              ; that's the low byte.
2028  2852 21 81 46            ld hl,font-256      ; address of charset.
2029  2855 19                  add hl,de           ; point to character.
2030  2856 CD FF 26            call gprad          ; get screen address in de.
2031  2859 EB                  ex de,hl            ; screen address in hl, font in de.
2032  285A
2033  285A 06 08               ld b,8              ; pixel rows.
2034  285C C5           btxt0  push bc             ; store row counter.
2035  285D 06 02               ld b,2              ; vertical stretch factor.
2036  285F C5           btxt3  push bc             ; store row counter.
2037  2860
2038  2860 ED 4B 05 28         ld bc,(inkmsk)      ; get ink and paper colours.
2039  2864 3A 81 22            ld a,(dispy)        ; get y coordinate.
2040  2867 1F                  rra                 ; odd or even alignment?
2041  2868 1A                  ld a,(de)           ; get byte of image.
2042  2869 D5                  push de             ; store pointer to font data.
2043  286A 38 06               jr c,btxt2          ; odd alignment.
2044  286C CD D6 28            call ptxte          ; print at even cell position.
2045  286F C3 75 28            jp btxt1
2046  2872 CD 8F 28     btxt2  call ptxto          ; print at odd cell position.
2047  2875 2B           btxt1  dec hl              ; back to left edge of character.
2048  2876 2B                  dec hl
2049  2877 CD F9 2E            call nline2         ; down one line.
2050  287A
2051  287A D1                  pop de              ; restore text image address.
2052  287B C1                  pop bc              ; retrieve stretch counter.
2053  287C 10 E1               djnz btxt3          ; repeat for all rows.
2054  287E 13                  inc de              ; next byte.
2055  287F C1                  pop bc              ; retrieve row counter.
2056  2880 10 DA               djnz btxt0          ; repeat for all rows.
2057  2882 CD DA 2C     bchr1  call nexpos         ; display position.
2058  2885 C2 8C 28            jp nz,bchr2         ; not on a new line.
2059  2888 34           bchr3  inc (hl)            ; newline.
2060  2889 CD E4 2C            call nexlin         ; next line check.
2061  288C C3 7E 26     bchr2  jp dscor2           ; tidy up line and column variables.
2062  288F
2063  288F
2064  288F              ; Print text at odd cell.
2065  288F
2066  288F 17           ptxto  rla                 ; test bit.
2067  2890 57                  ld d,a              ; store font data.
2068  2891 7E                  ld a,(hl)           ; get screen data.
2069  2892 38 06               jr c,ptxto8         ; it was set.
2070  2894 E6 AA               and 170             ; preserve left pixels.
2071  2896 5F                  ld e,a              ; store in e.
2072  2897 78                  ld a,b              ; paper colour.
2073  2898 18 04               jr ptxto9
2074  289A E6 AA        ptxto8 and 170             ; preserve left pixels.
2075  289C 5F                  ld e,a              ; store in e.
2076  289D 79                  ld a,c              ; ink colour.
2077  289E E6 55        ptxto9 and 85              ; right bits only.
2078  28A0 B3                  or e                ; merge with screen.
2079  28A1 77                  ld (hl),a           ; write first bit.
2080  28A2 23                  inc hl              ; next two pixels.
2081  28A3 7A                  ld a,d              ; get data again.
2082  28A4 17                  rla                 ; test bit.
2083  28A5 38 03               jr c,ptxto0         ; it was set.
2084  28A7 70                  ld (hl),b           ; set paper.
2085  28A8 18 01               jr ptxto1
2086  28AA 71           ptxto0 ld (hl),c           ; set to ink.
2087  28AB 17           ptxto1 rla                 ; test bit.
2088  28AC 57                  ld d,a              ; store data.
2089  28AD 38 03               jr c,ptxto2         ; it was set.
2090  28AF 78                  ld a,b              ; paper colour.
2091  28B0 18 01               jr ptxto3
2092  28B2 79           ptxto2 ld a,c              ; ink colour.
2093  28B3 E6 55        ptxto3 and 85              ; right bits.
2094  28B5 5F                  ld e,a              ; store in e.
2095  28B6 7E                  ld a,(hl)           ; get screen colours.
2096  28B7 E6 AA               and 170             ; left bits only.
2097  28B9 B3                  or e                ; merge with right bits.
2098  28BA 77                  ld (hl),a           ; write to screen.
2099  28BB 7A                  ld a,d              ; get bit of image data again.
2100  28BC 23                  inc hl              ; next two pixels.
2101  28BD 7A                  ld a,d              ; get data again.
2102  28BE 17                  rla                 ; test bit.
2103  28BF 38 03               jr c,ptxto4         ; it was set.
2104  28C1 70                  ld (hl),b           ; set paper.
2105  28C2 18 01               jr ptxto5
2106  28C4 71           ptxto4 ld (hl),c           ; set to ink.
2107  28C5 17           ptxto5 rla                 ; test bit.
2108  28C6 57                  ld d,a              ; store data.
2109  28C7 38 03               jr c,ptxto6         ; it was set.
2110  28C9 78                  ld a,b              ; paper colour.
2111  28CA 18 01               jr ptxto7
2112  28CC 79           ptxto6 ld a,c              ; ink colour.
2113  28CD E6 55        ptxto7 and 85              ; right bits.
2114  28CF 5F                  ld e,a              ; store in e.
2115  28D0 7E                  ld a,(hl)           ; get screen colours.
2116  28D1 E6 AA               and 170             ; left bits only.
2117  28D3 B3                  or e                ; merge with right bits.
2118  28D4 77                  ld (hl),a           ; write to screen.
2119  28D5 C9                  ret
2120  28D6
2121  28D6              ; Print text at even cell.
2122  28D6
2123  28D6 17           ptxte  rla                 ; test bit.
2124  28D7 38 03               jr c,ptxte0         ; it was set.
2125  28D9 70                  ld (hl),b           ; set paper.
2126  28DA 18 01               jr ptxte1
2127  28DC 71           ptxte0 ld (hl),c           ; set to ink.
2128  28DD 17           ptxte1 rla                 ; test bit.
2129  28DE 57                  ld d,a              ; store data.
2130  28DF 38 03               jr c,ptxte2         ; it was set.
2131  28E1 78                  ld a,b              ; paper colour.
2132  28E2 18 01               jr ptxte3
2133  28E4 79           ptxte2 ld a,c              ; ink colour.
2134  28E5 E6 55        ptxte3 and 85              ; right bits.
2135  28E7 5F                  ld e,a              ; store in e.
2136  28E8 7E                  ld a,(hl)           ; get screen colours.
2137  28E9 E6 AA               and 170             ; left bits only.
2138  28EB B3                  or e                ; merge with right bits.
2139  28EC 77                  ld (hl),a           ; write to screen.
2140  28ED 7A                  ld a,d              ; get bit of image data again.
2141  28EE 23                  inc hl              ; next screen address.
2142  28EF 17                  rla                 ; test bit.
2143  28F0 38 03               jr c,ptxte4         ; it was set.
2144  28F2 70                  ld (hl),b           ; set paper.
2145  28F3 18 01               jr ptxte5
2146  28F5 71           ptxte4 ld (hl),c           ; set to ink.
2147  28F6 17           ptxte5 rla                 ; test bit.
2148  28F7 57                  ld d,a              ; store data.
2149  28F8 38 03               jr c,ptxte6         ; it was set.
2150  28FA 78                  ld a,b              ; paper colour.
2151  28FB 18 01               jr ptxte7
2152  28FD 79           ptxte6 ld a,c              ; ink colour.
2153  28FE E6 55        ptxte7 and 85              ; right bits.
2154  2900 5F                  ld e,a              ; store in e.
2155  2901 7E                  ld a,(hl)           ; get screen colours.
2156  2902 E6 AA               and 170             ; left bits only.
2157  2904 B3                  or e                ; merge with right bits.
2158  2905 77                  ld (hl),a           ; write to screen.
2159  2906 7A                  ld a,d              ; get bit of image data again.
2160  2907 23                  inc hl              ; next screen address.
2161  2908 17                  rla                 ; test bit.
2162  2909 7E                  ld a,(hl)           ; get screen data.
2163  290A 38 06               jr c,ptxte8         ; it was set.
2164  290C E6 55               and 85              ; preserve right pixels.
2165  290E 5F                  ld e,a              ; store in e.
2166  290F 78                  ld a,b              ; paper colour.
2167  2910 18 04               jr ptxte9
2168  2912 E6 55        ptxte8 and 85              ; preserve right pixels.
2169  2914 5F                  ld e,a              ; store in e.
2170  2915 79                  ld a,c              ; ink colour.
2171  2916 E6 AA        ptxte9 and 170             ; left bits only.
2172  2918 B3                  or e                ; merge with screen.
2173  2919 77                  ld (hl),a           ; write final bit.
2174  291A C9                  ret
2175  291B
2176  291B
2177  291B              ; Sprite routine for objects, only appears at even pixel positions.
2178  291B
2179  291B E5           sprite push hl             ; store sprite graphic address.
2180  291C CD 5C 2E            call scadd          ; get screen address in hl.
2181  291F D1                  pop de              ; restore graphic address in de pair.
2182  2920 06 10               ld b,16             ; pixel height.
2183  2922 C5           sprit1 push bc             ; store row counter.
2184  2923 06 04               ld b,4              ; pixel width.
2185  2925 1A           sprit0 ld a,(de)           ; fetch graphic data.
2186  2926 AE                  xor (hl)            ; merge with what's on screen.
2187  2927 77                  ld (hl),a           ; bung it onto the screen.
2188  2928 13                  inc de              ; point to next piece of image.
2189  2929 2C                  inc l               ; next screen address.
2190  292A 10 F9               djnz sprit0         ; repeat for all columns.
2191  292C CD EC 2E            call nline          ; next line down.
2192  292F C1                  pop bc              ; restore row counter.
2193  2930 10 F0               djnz sprit1         ; repeat for all rows.
2194  2932 C9                  ret
2195  2933
2196  2933              ; Get room address.
2197  2933
2198  2933 3A 5A 22     groom  ld a,(scno)         ; screen number.
2199  2936 11 00 00     groomx ld de,0             ; start at zero.
2200  2939 2A 89 22            ld hl,(scrptr)      ; pointer to screens.
2201  293C A7                  and a               ; is it the first one?
2202  293D 28 0A        groom1 jr z,groom0         ; no more screens to skip.
2203  293F 4E                  ld c,(hl)           ; low byte of screen size.
2204  2940 23                  inc hl              ; point to high byte.
2205  2941 46                  ld b,(hl)           ; high byte of screen size.
2206  2942 23                  inc hl              ; next address.
2207  2943 EB                  ex de,hl            ; put total in hl, pointer in de.
2208  2944 09                  add hl,bc           ; skip a screen.
2209  2945 EB                  ex de,hl            ; put total in de, pointer in hl.
2210  2946 3D                  dec a               ; one less iteration.
2211  2947 18 F4               jr groom1           ; loop until we reach the end.
2212  2949 2A 89 22     groom0 ld hl,(scrptr)      ; pointer to screens.
2213  294C 19                  add hl,de           ; add displacement.
2214  294D 3A 64 46            ld a,(numsc)        ; number of screens.
2215  2950 16 00               ld d,0              ; zeroise high byte.
2216  2952 5F                  ld e,a              ; displacement in de.
2217  2953 19                  add hl,de           ; add double displacement to address.
2218  2954 19                  add hl,de
2219  2955 C9                  ret
2220  2956
2221  2956              ; Draw present room.
2222  2956
2223  2956 3A 51 22     droom  ld a,(wintop)       ; window top.
2224  2959 32 80 22            ld (dispx),a        ; set x coordinate.
2225  295C CD 33 29     droom2 call groom          ; get address of current room.
2226  295F AF                  xor a               ; zero in accumulator.
2227  2960 32 A4 29            ld (comcnt),a       ; reset compression counter.
2228  2963 3A 53 22            ld a,(winhgt)       ; height of window.
2229  2966 F5           droom0 push af             ; store row counter.
2230  2967 3A 52 22            ld a,(winlft)       ; window left edge.
2231  296A 32 81 22            ld (dispy),a        ; set cursor position.
2232  296D 3A 54 22            ld a,(winwid)       ; width of window.
2233  2970 F5           droom1 push af             ; store column counter.
2234  2971 CD 89 29            call flbyt          ; decompress next byte on the fly.
2235  2974 E5                  push hl             ; store address of cell.
2236  2975 CD C9 27            call pattr          ; show attributes and block.
2237  2978 E1                  pop hl              ; restore cell address.
2238  2979 F1                  pop af              ; restore loop counter.
2239  297A 3D                  dec a               ; one less column.
2240  297B 20 F3               jr nz,droom1        ; repeat for entire line.
2241  297D 3A 80 22            ld a,(dispx)        ; x coord.
2242  2980 3C                  inc a               ; move down one line.
2243  2981 32 80 22            ld (dispx),a        ; set new position.
2244  2984 F1                  pop af              ; restore row counter.
2245  2985 3D                  dec a               ; one less row.
2246  2986 20 DE               jr nz,droom0        ; repeat for all rows.
2247  2988 C9                  ret
2248  2989
2249  2989              ; Decompress bytes on-the-fly. bank6 candidate
2250  2989
2251  2989 3A A4 29     flbyt  ld a,(comcnt)       ; compression counter.
2252  298C A7                  and a               ; any more to decompress?
2253  298D 20 0C               jr nz,flbyt1        ; yes.
2254  298F 7E                  ld a,(hl)           ; fetch next byte.
2255  2990 23                  inc hl              ; point to next cell.
2256  2991 FE FF               cp 255              ; is this byte a control code?
2257  2993 C0                  ret nz              ; no, this byte is uncompressed.
2258  2994 7E                  ld a,(hl)           ; fetch byte type.
2259  2995 32 A3 29            ld (combyt),a       ; set up the type.
2260  2998 23                  inc hl              ; point to quantity.
2261  2999 7E                  ld a,(hl)           ; get quantity.
2262  299A 23                  inc hl              ; point to next byte.
2263  299B 3D           flbyt1 dec a               ; one less.
2264  299C 32 A4 29            ld (comcnt),a       ; store new quantity.
2265  299F 3A A3 29            ld a,(combyt)       ; byte to expand.
2266  29A2 C9                  ret
2267  29A3
2268  29A3 00           combyt defb 0              ; byte type compressed.
2269  29A4 00           comcnt defb 0              ; compression counter.
2270  29A5
2271  29A5              ; Ladder down check.
2272  29A5
2273  29A5 DD 7E 08     laddd  ld a,(ix+8)         ; x coordinate.
2274  29A8 DD 66 09            ld h,(ix+9)         ; y coordinate.
2275  29AB C6 10               add a,16            ; look down 16 pixels.
2276  29AD 6F                  ld l,a              ; coords in hl.
2277  29AE 18 09               jr laddv
2278  29B0
2279  29B0              ; Ladder up check.
2280  29B0
2281  29B0 DD 7E 08     laddu  ld a,(ix+8)         ; x coordinate.
2282  29B3 DD 66 09            ld h,(ix+9)         ; y coordinate.
2283  29B6 C6 0E               add a,14            ; look 2 pixels above feet.
2284  29B8 6F                  ld l,a              ; coords in hl.
2285  29B9 22 80 22     laddv  ld (dispx),hl       ; set up test coordinates.
2286  29BC CD 6F 2B            call tstbl          ; get map address.
2287  29BF CD 7B 2A            call ldchk          ; standard ladder check.
2288  29C2 C0                  ret nz              ; no way through.
2289  29C3 23                  inc hl              ; look right one cell.
2290  29C4 CD 7B 2A            call ldchk          ; do the check.
2291  29C7 C0                  ret nz              ; impassable.
2292  29C8 3A 81 22            ld a,(dispy)        ; y coordinate.
2293  29CB CD B5 2B            call rem5           ; position straddling block cells.
2294  29CE C8                  ret z               ; no more checks needed.
2295  29CF 3D                  dec a               ; one pixel to right?
2296  29D0 C8                  ret z               ; no more checks needed.
2297  29D1 23                  inc hl              ; look to third cell.
2298  29D2 CD 7B 2A            call ldchk          ; do the check.
2299  29D5 C9                  ret                 ; return with zero flag set accordingly.
2300  29D6
2301  29D6              ; Can go up check.
2302  29D6
2303  29D6 DD 7E 08     cangu  ld a,(ix+8)         ; x coordinate.
2304  29D9 DD 66 09            ld h,(ix+9)         ; y coordinate.
2305  29DC D6 02               sub 2               ; look up 2 pixels.
2306  29DE 6F                  ld l,a              ; coords in hl.
2307  29DF 22 80 22            ld (dispx),hl       ; set up test coordinates.
2308  29E2 CD 6F 2B            call tstbl          ; get map address.
2309  29E5 CD 51 2A            call lrchk          ; standard left/right check.
2310  29E8 C0                  ret nz              ; no way through.
2311  29E9 23                  inc hl              ; look right one cell.
2312  29EA CD 51 2A            call lrchk          ; do the check.
2313  29ED C0                  ret nz              ; impassable.
2314  29EE 3A 81 22            ld a,(dispy)        ; y coordinate.
2315  29F1 CD B5 2B            call rem5           ; position straddling block cells.
2316  29F4 C8                  ret z               ; no more checks needed.
2317  29F5 3D                  dec a               ; one pixel to right?
2318  29F6 C8                  ret z               ; no more checks needed.
2319  29F7 23                  inc hl              ; look to third cell.
2320  29F8 CD 51 2A            call lrchk          ; do the check.
2321  29FB C9                  ret                 ; return with zero flag set accordingly.
2322  29FC
2323  29FC              ; Can go down check.
2324  29FC
2325  29FC DD 7E 08     cangd  ld a,(ix+8)         ; x coordinate.
2326  29FF DD 66 09            ld h,(ix+9)         ; y coordinate.
2327  2A02 C6 10               add a,16            ; look down 16 pixels.
2328  2A04 6F                  ld l,a              ; coords in hl.
2329  2A05 22 80 22            ld (dispx),hl       ; set up test coordinates.
2330  2A08 CD 6F 2B            call tstbl          ; get map address.
2331  2A0B CD 5F 2A            call plchk          ; block, platform check.
2332  2A0E C0                  ret nz              ; no way through.
2333  2A0F 23                  inc hl              ; look right one cell.
2334  2A10 CD 5F 2A            call plchk          ; block, platform check.
2335  2A13 C0                  ret nz              ; impassable.
2336  2A14 3A 81 22            ld a,(dispy)        ; y coordinate.
2337  2A17 CD B5 2B            call rem5           ; position straddling block cells.
2338  2A1A C8                  ret z               ; no more checks needed.
2339  2A1B 3D                  dec a               ; one pixel to right?
2340  2A1C C8                  ret z               ; no more checks needed.
2341  2A1D 23                  inc hl              ; look to third cell.
2342  2A1E CD 5F 2A            call plchk          ; block, platform check.
2343  2A21 C9                  ret                 ; return with zero flag set accordingly.
2344  2A22
2345  2A22              ; Can go left check.
2346  2A22
2347  2A22 DD 6E 08     cangl  ld l,(ix+8)         ; x coordinate.
2348  2A25 DD 66 09            ld h,(ix+9)         ; y coordinate.
2349  2A28 25                  dec h               ; look left 1 pixel.
2350  2A29 18 09               jr cangh            ; test if we can go there.
2351  2A2B
2352  2A2B              ; Can go right check.
2353  2A2B
2354  2A2B DD 6E 08     cangr  ld l,(ix+8)         ; x coordinate.
2355  2A2E DD 7E 09            ld a,(ix+9)         ; y coordinate.
2356  2A31 C6 09               add a,9             ; look right 9 pixels.
2357  2A33 67                  ld h,a              ; coords in hl.
2358  2A34
2359  2A34 22 80 22     cangh  ld (dispx),hl       ; set up test coordinates.
2360  2A37 CD 6F 2B            call tstbl          ; get map address.
2361  2A3A CD 51 2A            call lrchk          ; standard left/right check.
2362  2A3D C0                  ret nz              ; no way through.
2363  2A3E 11 20 00            ld de,32            ; distance to next cell.
2364  2A41 19                  add hl,de           ; look down.
2365  2A42 CD 51 2A            call lrchk          ; do the check.
2366  2A45 C0                  ret nz              ; impassable.
2367  2A46 3A 80 22            ld a,(dispx)        ; x coordinate.
2368  2A49 E6 07               and 7               ; position straddling block cells.
2369  2A4B C8                  ret z               ; no more checks needed.
2370  2A4C 19                  add hl,de           ; look down to third cell.
2371  2A4D CD 51 2A            call lrchk          ; do the check.
2372  2A50 C9                  ret                 ; return with zero flag set accordingly.
2373  2A51
2374  2A51              ; Check left/right movement is okay.
2375  2A51
2376  2A51 7E           lrchk  ld a,(hl)           ; fetch map cell.
2377  2A52 FE 02               cp WALL             ; is it passable?
2378  2A54 28 06               jr z,lrchkx         ; no.
2379  2A56 FE 04               cp FODDER           ; fodder has to be dug.
2380  2A58 28 02               jr z,lrchkx         ; not passable.
2381  2A5A AF           always xor a               ; report it as okay.
2382  2A5B C9                  ret
2383  2A5C AF           lrchkx xor a               ; reset all bits.
2384  2A5D 3C                  inc a
2385  2A5E C9                  ret
2386  2A5F
2387  2A5F              ; Check platform or solid item is not in way.
2388  2A5F
2389  2A5F 7E           plchk  ld a,(hl)           ; fetch map cell.
2390  2A60 FE 02               cp WALL             ; is it passable?
2391  2A62 28 F8               jr z,lrchkx         ; no.
2392  2A64 FE 04               cp FODDER           ; fodder has to be dug.
2393  2A66 28 F4               jr z,lrchkx         ; not passable.
2394  2A68 FE 01               cp PLATFM           ; platform is solid.
2395  2A6A 28 06               jr z,plchkx         ; not passable.
2396  2A6C FE 03               cp LADDER           ; is it a ladder?
2397  2A6E 28 EC               jr z,lrchkx         ; on ladder, deny movement.
2398  2A70 AF           plchk0 xor a               ; report it as okay.
2399  2A71 C9                  ret
2400  2A72 3A 80 22     plchkx ld a,(dispx)        ; x coordinate.
2401  2A75 E6 07               and 7               ; position straddling blocks.
2402  2A77 28 E3               jr z,lrchkx         ; on platform, deny movement.
2403  2A79 18 F5               jr plchk0
2404  2A7B
2405  2A7B              ; Check ladder is available.
2406  2A7B
2407  2A7B 7E           ldchk  ld a,(hl)           ; fetch cell.
2408  2A7C FE 03               cp LADDER           ; is it a ladder?
2409  2A7E C9                  ret                 ; return with zero flag set accordingly.
2410  2A7F
2411  2A7F              ; Get collectables.
2412  2A7F
2413  2A7F 06 08        getcol ld b,COLECT         ; collectable blocks.
2414  2A81 CD 1C 2B            call tded           ; test for collectable blocks.
2415  2A84 B8                  cp b                ; did we find one?
2416  2A85 C0                  ret nz              ; none were found, job done.
2417  2A86 CD 8E 2A            call gtblk          ; get block.
2418  2A89 CD C0 38            call evnt20         ; collected block event.
2419  2A8C 18 F1               jr getcol           ; repeat until none left.
2420  2A8E
2421  2A8E              ; Get collectable block.
2422  2A8E
2423  2A8E 36 00        gtblk  ld (hl),0           ; make it empty now.
2424  2A90 11 00 A0            ld de,MAP           ; map address.
2425  2A93 A7                  and a               ; clear carry.
2426  2A94 ED 52               sbc hl,de           ; find cell number.
2427  2A96 7D                  ld a,l              ; get low byte of cell number.
2428  2A97 E6 1F               and 31              ; 0 - 31 is column.
2429  2A99 57                  ld d,a              ; store y in d register.
2430  2A9A 29                  add hl,hl           ; multiply by 8.
2431  2A9B 29                  add hl,hl
2432  2A9C 29                  add hl,hl           ; x is now in h.
2433  2A9D 5C                  ld e,h              ; put x in e.
2434  2A9E ED 53 80 22         ld (dispx),de       ; set display coordinates.
2435  2AA2
2436  2AA2 3A C8 27            ld a,(colpat)       ; get collectable block number for this screen.
2437  2AA5 CD A9 2A            call xorbk          ; xor block from the screen.
2438  2AA8 AF                  xor a               ; block zero.
2439  2AA9
2440  2AA9              ; Now drop through and xor block onto screen.
2441  2AA9
2442  2AA9 CD B6 27     xorbk  call gchadd         ; get character address.
2443  2AAC CD FF 26            call gprad          ; get screen address in de.
2444  2AAF EB                  ex de,hl            ; screen in hl, block image in de.
2445  2AB0
2446  2AB0 3A 81 22            ld a,(dispy)        ; get horizontal position.
2447  2AB3 1F                  rra                 ; are we displaying block at an odd position?
2448  2AB4 DA DF 2A            jp c,xorbk0         ; yes, need to shift everything then.
2449  2AB7 01 FE 07            ld bc,2046          ; distance to next line.
2450  2ABA CD CF 2A            call xorbke         ; even pixel position.
2451  2ABD CD CF 2A            call xorbke
2452  2AC0 CD CF 2A            call xorbke
2453  2AC3 CD CF 2A            call xorbke
2454  2AC6 CD CF 2A            call xorbke
2455  2AC9 CD CF 2A            call xorbke
2456  2ACC CD CF 2A            call xorbke
2457  2ACF
2458  2ACF 1A           xorbke ld a,(de)           ; get image byte.
2459  2AD0 AE                  xor (hl)            ; merge with screen.
2460  2AD1 77                  ld (hl),a           ; write to screen.
2461  2AD2 23                  inc hl              ; next screen byte.
2462  2AD3 13                  inc de              ; next image byte.
2463  2AD4 1A                  ld a,(de)           ; get image byte.
2464  2AD5 AE                  xor (hl)            ; merge with screen.
2465  2AD6 77                  ld (hl),a           ; write to screen.
2466  2AD7 23                  inc hl              ; next screen byte.
2467  2AD8 13                  inc de              ; next image byte.
2468  2AD9 1A                  ld a,(de)           ; get image byte.
2469  2ADA AE                  xor (hl)            ; merge in final pixel data.
2470  2ADB 13                  inc de              ; postincrement to next byte of data.
2471  2ADC 77                  ld (hl),a           ; write third byte.
2472  2ADD 09                  add hl,bc           ; look down one pixel.
2473  2ADE C9                  ret
2474  2ADF
2475  2ADF CD F4 2A     xorbk0 call xorbko         ; odd pixel position.
2476  2AE2 CD F4 2A            call xorbko
2477  2AE5 CD F4 2A            call xorbko
2478  2AE8 CD F4 2A            call xorbko
2479  2AEB CD F4 2A            call xorbko
2480  2AEE CD F4 2A            call xorbko
2481  2AF1 CD F4 2A            call xorbko
2482  2AF4
2483  2AF4 1A           xorbko ld a,(de)           ; get first byte of data to write.
2484  2AF5 1F                  rra                 ; shift into right position.
2485  2AF6 E6 55               and 85              ; get right pixel colour.
2486  2AF8 AE                  xor (hl)            ; merge with screen byte.
2487  2AF9 77                  ld (hl),a           ; write that byte.
2488  2AFA
2489  2AFA 23                  inc hl              ; next screen byte.
2490  2AFB 1A                  ld a,(de)           ; get first byte of image again.
2491  2AFC 17                  rla                 ; shift second pixel into left position.
2492  2AFD E6 AA               and 170             ; remove right bits.
2493  2AFF 47                  ld b,a              ; store for now.
2494  2B00 13                  inc de              ; point to next byte of data.
2495  2B01 1A                  ld a,(de)           ; get third pixel.
2496  2B02 1F                  rra                 ; shift into right pixel position.
2497  2B03 E6 55               and 85              ; remove left pixel.
2498  2B05 B0                  or b                ; merge with previous pixel.
2499  2B06 AE                  xor (hl)            ; merge with screen.
2500  2B07 77                  ld (hl),a           ; write to screen.
2501  2B08 23                  inc hl              ; third screen byte.
2502  2B09 1A                  ld a,(de)           ; get second byte of image again.
2503  2B0A 17                  rla                 ; shift fourth pixel into left position.
2504  2B0B E6 AA               and 170             ; remove right bits.
2505  2B0D 47                  ld b,a              ; store for now.
2506  2B0E 13                  inc de              ; point to next byte of data.
2507  2B0F 1A                  ld a,(de)           ; get fifth pixel.
2508  2B10 1F                  rra                 ; shift into right pixel position.
2509  2B11 E6 55               and 85              ; remove left pixel.
2510  2B13 B0                  or b                ; merge with previous pixel.
2511  2B14 AE                  xor (hl)            ; merge with screen.
2512  2B15 77                  ld (hl),a           ; write to screen.
2513  2B16 13                  inc de              ; point to next byte of data.
2514  2B17
2515  2B17 01 FE 07            ld bc,2046          ; distance to next line.
2516  2B1A 09                  add hl,bc           ; look down one pixel.
2517  2B1B C9                  ret
2518  2B1C
2519  2B1C              ; Touched deadly block check.
2520  2B1C              ; Returns with DEADLY (must be non-zero) in accumulator if true.
2521  2B1C
2522  2B1C DD 6E 08     tded   ld l,(ix+8)         ; x coordinate.
2523  2B1F DD 66 09            ld h,(ix+9)         ; y coordinate.
2524  2B22 22 80 22            ld (dispx),hl       ; set up test coordinates.
2525  2B25 CD 6F 2B            call tstbl          ; get map address.
2526  2B28 11 1F 00            ld de,31            ; default distance to next line down.
2527  2B2B B8                  cp b                ; is this the required block?
2528  2B2C C8                  ret z               ; yes.
2529  2B2D 23                  inc hl              ; next cell.
2530  2B2E 7E                  ld a,(hl)           ; fetch type.
2531  2B2F B8                  cp b                ; is this deadly/custom?
2532  2B30 C8                  ret z               ; yes.
2533  2B31 3A 81 22            ld a,(dispy)        ; horizontal position.
2534  2B34 4F                  ld c,a              ; store column in c register.
2535  2B35 CD B5 2B            call rem5           ; is it straddling cells?
2536  2B38 28 08               jr z,tded0          ; no.
2537  2B3A 3D                  dec a               ; one pixel to right?
2538  2B3B 28 05               jr z,tded0          ; no more checks needed.
2539  2B3D 23                  inc hl              ; last cell.
2540  2B3E 7E                  ld a,(hl)           ; fetch type.
2541  2B3F B8                  cp b                ; is this the block?
2542  2B40 C8                  ret z               ; yes.
2543  2B41 1B                  dec de              ; one less cell to next row down.
2544  2B42 19           tded0  add hl,de           ; point to next row.
2545  2B43 7E                  ld a,(hl)           ; fetch left cell block.
2546  2B44 B8                  cp b                ; is this fatal?
2547  2B45 C8                  ret z               ; yes.
2548  2B46 23                  inc hl              ; next cell.
2549  2B47 7E                  ld a,(hl)           ; fetch type.
2550  2B48 B8                  cp b                ; is this fatal?
2551  2B49 C8                  ret z               ; yes.
2552  2B4A 79                  ld a,c              ; horizontal position.
2553  2B4B CD B5 2B            call rem5           ; is it straddling cells?
2554  2B4E 28 07               jr z,tded1          ; no.
2555  2B50 3D                  dec a               ; one pixel to right?
2556  2B51 28 04               jr z,tded1          ; no more checks needed.
2557  2B53 23                  inc hl              ; last cell.
2558  2B54 7E                  ld a,(hl)           ; fetch type.
2559  2B55 B8                  cp b                ; is this fatal?
2560  2B56 C8                  ret z               ; yes.
2561  2B57 3A 80 22     tded1  ld a,(dispx)        ; vertical position.
2562  2B5A E6 07               and 7               ; is it straddling cells?
2563  2B5C C8                  ret z               ; no, job done.
2564  2B5D 19                  add hl,de           ; point to next row.
2565  2B5E 7E                  ld a,(hl)           ; fetch left cell block.
2566  2B5F B8                  cp b                ; is this fatal?
2567  2B60 C8                  ret z               ; yes.
2568  2B61 23                  inc hl              ; next cell.
2569  2B62 7E                  ld a,(hl)           ; fetch type.
2570  2B63 B8                  cp b                ; is this fatal?
2571  2B64 C8                  ret z               ; yes.
2572  2B65 79                  ld a,c              ; horizontal position.
2573  2B66 CD B5 2B            call rem5           ; is it straddling cells?
2574  2B69 C8                  ret z               ; no.
2575  2B6A 3D                  dec a               ; one pixel to right?
2576  2B6B C8                  ret z               ; no more checks needed.
2577  2B6C 23                  inc hl              ; last cell.
2578  2B6D 7E                  ld a,(hl)           ; fetch final type.
2579  2B6E C9                  ret                 ; return with final type in accumulator.
2580  2B6F
2581  2B6F
2582  2B6F              ; Fetch block type at (dispx, dispy).
2583  2B6F
2584  2B6F 3A 80 22     tstbl  ld a,(dispx)        ; fetch x coord.
2585  2B72 07                  rlca                ; divide by 8,
2586  2B73 07                  rlca                ; and multiply by 32.
2587  2B74 57                  ld d,a              ; store in d.
2588  2B75 E6 E0               and 224             ; mask off high bits.
2589  2B77 5F                  ld e,a              ; low byte.
2590  2B78 7A                  ld a,d              ; restore shift result.
2591  2B79 E6 03               and 3               ; high bits.
2592  2B7B 57                  ld d,a              ; got displacement in de.
2593  2B7C 3A 81 22            ld a,(dispy)        ; y coord.
2594  2B7F CD 8A 2B            call div5           ; divide by 5.
2595  2B82 83                  add a,e             ; add to displacement.
2596  2B83 5F                  ld e,a              ; displacement in de.
2597  2B84 21 00 A0            ld hl,MAP           ; position of dummy screen.
2598  2B87 19                  add hl,de           ; point to address.
2599  2B88 7E                  ld a,(hl)           ; fetch byte there.
2600  2B89 C9                  ret
2601  2B8A
2602  2B8A              ; Divide y coordinate by 5 to give block position.
2603  2B8A
2604  2B8A C5           div5   push bc             ; store bc.
2605  2B8B 06 00               ld b,0              ; reset result.
2606  2B8D FE 50               cp 80               ; more than 80?
2607  2B8F 38 04               jr c,div5a          ; no.
2608  2B91 D6 50               sub 80              ; subtract 80.
2609  2B93 CB E0               set 4,b             ; set bit for 16.
2610  2B95 FE 28        div5a  cp 40               ; more than 40?
2611  2B97 38 04               jr c,div5b          ; no.
2612  2B99 D6 28               sub 40              ; subtract 40.
2613  2B9B CB D8               set 3,b             ; set bit for 8.
2614  2B9D FE 14        div5b  cp 20               ; more than 20?
2615  2B9F 38 04               jr c,div5c          ; no.
2616  2BA1 D6 14               sub 20              ; subtract 20.
2617  2BA3 CB D0               set 2,b             ; set bit for 4.
2618  2BA5 FE 0A        div5c  cp 10               ; more than 10?
2619  2BA7 38 04               jr c,div5d          ; no.
2620  2BA9 D6 0A               sub 10              ; subtract 10.
2621  2BAB CB C8               set 1,b             ; set bit for 2.
2622  2BAD FE 05        div5d  cp 5                ; more than 5?
2623  2BAF 38 01               jr c,div5e          ; no.
2624  2BB1 04                  inc b               ; set bit for 1.
2625  2BB2 78           div5e  ld a,b              ; get result.
2626  2BB3 C1                  pop bc              ; restore bc.
2627  2BB4 C9                  ret
2628  2BB5
2629  2BB5              ; Find remainder when coordinate divided by 5 to establish block alignment.
2630  2BB5
2631  2BB5 FE 50        rem5   cp 80               ; is coordinate more than 80?
2632  2BB7 38 02               jr c,rem5a          ; no.
2633  2BB9 D6 50               sub 80              ; subtract amount.
2634  2BBB FE 28        rem5a  cp 40               ; is coordinate more than 40?
2635  2BBD 38 02               jr c,rem5b          ; no.
2636  2BBF D6 28               sub 40              ; subtract amount.
2637  2BC1 FE 14        rem5b  cp 20               ; is coordinate more than 20?
2638  2BC3 38 02               jr c,rem5c          ; no.
2639  2BC5 D6 14               sub 20              ; subtract amount.
2640  2BC7 FE 0A        rem5c  cp 10               ; is coordinate more than 10?
2641  2BC9 38 02               jr c,rem5d          ; no.
2642  2BCB D6 0A               sub 10              ; subtract amount.
2643  2BCD FE 05        rem5d  cp 5                ; is coordinate more than 5?
2644  2BCF 38 02               jr c,rem5e          ; no.
2645  2BD1 D6 05               sub 5               ; subtract amount.
2646  2BD3 A7           rem5e  and a               ; remainder in accumulator, set zero flag accordingly.
2647  2BD4 C9                  ret
2648  2BD5
2649  2BD5
2650  2BD5              ; Jump - if we can.
2651  2BD5              ; Requires initial speed to be set up in accumulator prior to call.
2652  2BD5
2653  2BD5 ED 44        jump   neg                 ; switch sign so we jump up.
2654  2BD7 4F                  ld c,a              ; store in c register.
2655  2BD8              ;       ld a,(ix+8)         ; x coordinate.
2656  2BD8              ;       ld h,(ix+9)         ; y coordinate.
2657  2BD8              ;numsp4 add a,16            ; look down 16 pixels.
2658  2BD8              ;       ld l,a              ; coords in hl.
2659  2BD8              ;       and 7               ; are we on platform boundary?
2660  2BD8              ;       ret nz              ; no, cannot jump.
2661  2BD8              ;       ld (dispx),hl       ; set up test coordinates.
2662  2BD8              ;       ld b,a              ; copy to b register.
2663  2BD8              ;       call tstbl          ; get map address.
2664  2BD8              ;       call plchk          ; block, platform check.
2665  2BD8              ;       jr nz,jump0         ; it's solid, we can jump.
2666  2BD8              ;       inc hl              ; look right one cell.
2667  2BD8              ;       call plchk          ; block, platform check.
2668  2BD8              ;       jr nz,jump0         ; it's solid, we can jump.
2669  2BD8              ;       ld a,b              ; y coordinate.
2670  2BD8              ;       call rem5           ; position straddling block cells.
2671  2BD8              ;       ret z               ; no more checks needed.
2672  2BD8              ;       inc hl              ; look to third cell.
2673  2BD8              ;       call plchk          ; block, platform check.
2674  2BD8              ;       ret z               ; not solid, don't jump.
2675  2BD8 DD 7E 0D     jump0  ld a,(ix+13)        ; jumping flag.
2676  2BDB A7                  and a               ; is it set?
2677  2BDC C0                  ret nz              ; already in the air.
2678  2BDD DD 34 0D            inc (ix+13)         ; set it.
2679  2BE0 DD 71 0E            ld (ix+14),c        ; set jump height.
2680  2BE3 C9                  ret
2681  2BE4
2682  2BE4 DD 7E 0D     hop    ld a,(ix+13)        ; jumping flag.
2683  2BE7 A7                  and a               ; is it set?
2684  2BE8 C0                  ret nz              ; already in the air.
2685  2BE9 DD 36 0D FF         ld (ix+13),255      ; set it.
2686  2BED DD 36 0E 00         ld (ix+14),0        ; set jump table displacement.
2687  2BF1 C9                  ret
2688  2BF2
2689  2BF2
2690  2BF2              ; Random numbers code.
2691  2BF2              ; Pseudo-random number generator, 8-bit.
2692  2BF2
2693  2BF2 21 4C 26     random ld hl,seed          ; set up seed pointer.
2694  2BF5 7E                  ld a,(hl)           ; get last random number.
2695  2BF6 47                  ld b,a              ; copy to b register.
2696  2BF7 0F                  rrca                ; multiply by 32.
2697  2BF8 0F                  rrca
2698  2BF9 0F                  rrca
2699  2BFA EE 1F               xor 31
2700  2BFC 80                  add a,b
2701  2BFD DE FF               sbc a,255
2702  2BFF 77                  ld (hl),a           ; store new seed.
2703  2C00 32 78 22            ld (varrnd),a       ; return number in variable.
2704  2C03 C9                  ret
2705  2C04
2706  2C04              ; Joystick and keyboard reading routines.
2707  2C04              ; General keyboard test routine used by compiler.
2708  2C04
2709  2C04 CD 1E BB     ktest  call 47902          ; check if keycode is pressed.
2710  2C07 20 02               jr nz,ktest0        ; pressed, reset carry.
2711  2C09 37                  scf                 ; set carry.
2712  2C0A C9                  ret
2713  2C0B A7           ktest0 and a               ; clear carry flag.
2714  2C0C C9                  ret
2715  2C0D
2716  2C0D              ; Joystick states:
2717  2C0D              ; 1 - up.
2718  2C0D              ; 2 - down.
2719  2C0D              ; 4 - left.
2720  2C0D              ; 8 - right.
2721  2C0D              ; 16 - fire 1.
2722  2C0D              ; 32 - fire 2.
2723  2C0D
2724  2C0D CD 24 BB     joykey call 47908          ; get joystick states in hl.
2725  2C10 3A 74 22            ld a,(contrl)       ; controls.
2726  2C13 A7                  and a               ; keyboard?
2727  2C14 CA 24 2C            jp z,keyb           ; read keys.
2728  2C17 3D                  dec a               ; joystick zero?
2729  2C18 28 05               jr z,joy0           ; just want joystick 0.
2730  2C1A 7D                  ld a,l              ; joystick 1.
2731  2C1B 32 4F 22            ld (joyval),a       ; store joystick reading.
2732  2C1E C9                  ret
2733  2C1F 7C           joy0   ld a,h              ; value of joystick 0.
2734  2C20 32 4F 22            ld (joyval),a       ; remember value.
2735  2C23 C9                  ret
2736  2C24 06 00        keyb   ld b,0              ; default value.
2737  2C26 3A 87 4A            ld a,(keys+5)       ; fire 2.
2738  2C29 CD 59 2C            call keybck         ; check if pressed.
2739  2C2C CB 20               sla b               ; shift result byte.
2740  2C2E 3A 86 4A            ld a,(keys+4)       ; fire 1.
2741  2C31 CD 59 2C            call keybck         ; check if pressed.
2742  2C34 CB 20               sla b               ; shift result byte.
2743  2C36 3A 85 4A            ld a,(keys+3)       ; right.
2744  2C39 CD 59 2C            call keybck         ; check if pressed.
2745  2C3C CB 20               sla b               ; shift result byte.
2746  2C3E 3A 84 4A            ld a,(keys+2)       ; left.
2747  2C41 CD 59 2C            call keybck         ; check if pressed.
2748  2C44 CB 20               sla b               ; shift result byte.
2749  2C46 3A 83 4A            ld a,(keys+1)       ; down.
2750  2C49 CD 59 2C            call keybck         ; check if pressed.
2751  2C4C CB 20               sla b               ; shift result byte.
2752  2C4E 3A 82 4A            ld a,(keys)         ; up.
2753  2C51 CD 59 2C            call keybck         ; check if pressed.
2754  2C54 78                  ld a,b              ; put result in accumulator.
2755  2C55 32 4F 22            ld (joyval),a       ; set the joystick reading.
2756  2C58 C9                  ret
2757  2C59 CD 1E BB     keybck call 47902          ; check if key pressed.
2758  2C5C C8                  ret z               ; not pressed.
2759  2C5D 04                  inc b               ; set bit to say pressed.
2760  2C5E C9                  ret
2761  2C5F
2762  2C5F
2763  2C5F              ; Display message.
2764  2C5F
2765  2C5F 21 C7 38     dmsg   ld hl,msgdat        ; pointer to messages.
2766  2C62 CD F5 2C            call getwrd         ; get message number.
2767  2C65 CD EC 2C     dmsg3  call preprt         ; pre-printing stuff.
2768  2C68 CD 60 26            call checkx         ; make sure we're in a printable range.
2769  2C6B 3A 9E 2C            ld a,(prtmod)       ; print mode.
2770  2C6E A7                  and a               ; standard size?
2771  2C6F C2 9F 2C            jp nz,bmsg1         ; no, double-height text.
2772  2C72 E5           dmsg0  push hl             ; store string pointer.
2773  2C73 7E                  ld a,(hl)           ; fetch byte to display.
2774  2C74 E6 7F               and 127             ; remove any end marker.
2775  2C76 FE 0D               cp 13               ; newline character?
2776  2C78 28 14               jr z,dmsg1
2777  2C7A CD 07 28            call ptxt           ; display character.
2778  2C7D CD DA 2C            call nexpos         ; display position.
2779  2C80 20 03               jr nz,dmsg2         ; not on a new line.
2780  2C82 CD E4 2C            call nexlin         ; next line down.
2781  2C85 E1           dmsg2  pop hl
2782  2C86 7E                  ld a,(hl)           ; fetch last character.
2783  2C87 17                  rla                 ; was it the end?
2784  2C88 DA 7E 26            jp c,dscor2         ; yes, job done.
2785  2C8B 23                  inc hl              ; next character to display.
2786  2C8C 18 E4               jr dmsg0
2787  2C8E 21 80 22     dmsg1  ld hl,dispx         ; x coordinate.
2788  2C91 34                  inc (hl)            ; newline.
2789  2C92 7E                  ld a,(hl)           ; fetch position.
2790  2C93 FE 19               cp 25               ; past screen edge?
2791  2C95 38 02               jr c,dmsg4          ; no, it's okay.
2792  2C97 36 00               ld (hl),0           ; restart at top.
2793  2C99 23           dmsg4  inc hl              ; y coordinate.
2794  2C9A 36 00               ld (hl),0           ; carriage return.
2795  2C9C 18 E7               jr dmsg2
2796  2C9E 00           prtmod defb 0              ; print mode, 0 = standard, 1 = double-height.
2797  2C9F
2798  2C9F              ; Display message in big text.
2799  2C9F
2800  2C9F 7E           bmsg1  ld a,(hl)           ; get character to display.
2801  2CA0 E5                  push hl             ; store pointer to message.
2802  2CA1 E6 7F               and 127             ; only want 7 bits.
2803  2CA3 FE 0D               cp 13               ; newline character?
2804  2CA5 28 0A               jr z,bmsg2          ; newline instead.
2805  2CA7 CD 47 28            call btxt           ; display big char.
2806  2CAA E1           bmsg3  pop hl              ; retrieve message pointer.
2807  2CAB 7E                  ld a,(hl)           ; look at last character.
2808  2CAC 23                  inc hl              ; next character in list.
2809  2CAD 17                  rla                 ; was terminator flag set?
2810  2CAE 30 EF               jr nc,bmsg1         ; no, keep going.
2811  2CB0 C9                  ret
2812  2CB1 21 75 22     bmsg2  ld hl,charx         ; x coordinate.
2813  2CB4 34                  inc (hl)            ; newline.
2814  2CB5 34                  inc (hl)            ; newline.
2815  2CB6 7E                  ld a,(hl)           ; fetch position.
2816  2CB7 FE 18               cp 24               ; past screen edge?
2817  2CB9 38 EF               jr c,bmsg3          ; no, it's okay.
2818  2CBB 36 00               ld (hl),0           ; restart at top.
2819  2CBD 23                  inc hl              ; y coordinate.
2820  2CBE 36 00               ld (hl),0           ; carriage return.
2821  2CC0 18 E8               jr bmsg3
2822  2CC2
2823  2CC2              ; Display a character.
2824  2CC2
2825  2CC2 47           achar  ld b,a              ; copy to b.
2826  2CC3 CD EC 2C            call preprt         ; get ready to print.
2827  2CC6 3A 9E 2C            ld a,(prtmod)       ; print mode.
2828  2CC9 A7                  and a               ; standard size?
2829  2CCA 78                  ld a,b              ; character in accumulator.
2830  2CCB C2 47 28            jp nz,btxt          ; no, double-height text.
2831  2CCE CD 07 28            call ptxt           ; display character.
2832  2CD1 CD DA 2C            call nexpos         ; display position.
2833  2CD4 CA 5F 28            jp z,btxt3          ; next line down.
2834  2CD7 C3 72 28            jp btxt2            ; tidy up.
2835  2CDA
2836  2CDA              ; Get next print column position.
2837  2CDA
2838  2CDA 21 81 22     nexpos ld hl,dispy         ; display position.
2839  2CDD 7E                  ld a,(hl)           ; get coordinate.
2840  2CDE 3C                  inc a               ; move along one position.
2841  2CDF E6 1F               and 31              ; reached edge of screen?
2842  2CE1 77                  ld (hl),a           ; set new position.
2843  2CE2 2B                  dec hl              ; point to x now.
2844  2CE3 C9                  ret                 ; return with status in zero flag.
2845  2CE4
2846  2CE4              ; Get next print line position.
2847  2CE4
2848  2CE4 34           nexlin inc (hl)            ; newline.
2849  2CE5 7E                  ld a,(hl)           ; vertical position.
2850  2CE6 FE 18               cp 24               ; past screen edge?
2851  2CE8 D8                  ret c               ; no, still okay.
2852  2CE9 36 00               ld (hl),0           ; restart at top.
2853  2CEB C9                  ret
2854  2CEC
2855  2CEC              ; Pre-print preliminaries.
2856  2CEC
2857  2CEC ED 5B 75 22  preprt ld de,(charx)       ; display coordinates.
2858  2CF0 ED 53 80 22         ld (dispx),de       ; set up general coordinates.
2859  2CF4 C9                  ret
2860  2CF5
2861  2CF5              ; On entry  hl points to word list
2862  2CF5              ;           a contains word number.
2863  2CF5
2864  2CF5 A7           getwrd and a               ; first word in list?
2865  2CF6 C8                  ret z               ; yep, don't search.
2866  2CF7 47                  ld b,a
2867  2CF8 7E           getwd0 ld a,(hl)
2868  2CF9 23                  inc hl
2869  2CFA FE 80               cp 128              ; found end?
2870  2CFC 38 FA               jr c,getwd0         ; no, carry on.
2871  2CFE 10 F8               djnz getwd0         ; until we have right number.
2872  2D00 C9                  ret
2873  2D01
2874  2D01
2875  2D01              ; Bubble sort.
2876  2D01
2877  2D01 06 0B        bsort  ld b,NUMSPR - 1     ; sprites to swap.
2878  2D03 DD 21 D3 32         ld ix,sprtab        ; sprite table.
2879  2D07 C5           bsort0 push bc             ; store loop counter for now.
2880  2D08
2881  2D08 DD 7E 00            ld a,(ix+0)         ; first sprite type.
2882  2D0B 3C                  inc a               ; is it switched off?
2883  2D0C 28 22               jr z,swemp          ; yes, may need to switch another in here.
2884  2D0E
2885  2D0E DD 7E 11            ld a,(ix+TABSIZ)    ; check next slot exists.
2886  2D11 3C                  inc a               ; is it enabled?
2887  2D12 28 08               jr z,bsort2         ; no, nothing to swap.
2888  2D14
2889  2D14 DD 7E 14            ld a,(ix+3+TABSIZ)  ; fetch next sprite's coordinate.
2890  2D17 DD BE 03            cp (ix+3)           ; compare with this x coordinate.
2891  2D1A 38 09               jr c,bsort1         ; next sprite is higher - may need to switch.
2892  2D1C 11 11 00     bsort2 ld de,TABSIZ        ; distance to next odd/even entry.
2893  2D1F DD 19               add ix,de           ; next sprite.
2894  2D21 C1                  pop bc              ; retrieve loop counter.
2895  2D22 10 E3               djnz bsort0         ; repeat for remaining sprites.
2896  2D24 C9                  ret
2897  2D25
2898  2D25 DD 7E 11     bsort1 ld a,(ix+TABSIZ)    ; sprite on/off flag.
2899  2D28 3C                  inc a               ; is it enabled?
2900  2D29 28 F1               jr z,bsort2         ; no, nothing to swap.
2901  2D2B CD 3B 2D            call swspr          ; swap positions.
2902  2D2E 18 EC               jr bsort2
2903  2D30
2904  2D30 DD 7E 11     swemp  ld a,(ix+TABSIZ)    ; next table entry.
2905  2D33 3C                  inc a               ; is that one on?
2906  2D34 28 E6               jr z,bsort2         ; no, nothing to swap.
2907  2D36 CD 3B 2D            call swspr          ; swap positions.
2908  2D39 18 E1               jr bsort2
2909  2D3B
2910  2D3B              ; Swap sprites.
2911  2D3B
2912  2D3B DD E5        swspr  push ix             ; table address on stack.
2913  2D3D E1                  pop hl              ; pop into hl pair.
2914  2D3E 54                  ld d,h              ; copy to de pair.
2915  2D3F 5D                  ld e,l
2916  2D40 01 11 00            ld bc,TABSIZ        ; distance to second entry.
2917  2D43 09                  add hl,bc           ; point to second sprite entry.
2918  2D44 06 11               ld b,TABSIZ         ; bytes to swap.
2919  2D46 4E           swspr0 ld c,(hl)           ; fetch second byte.
2920  2D47 1A                  ld a,(de)           ; fetch first byte.
2921  2D48 77                  ld (hl),a           ; copy to second.
2922  2D49 79                  ld a,c              ; second byte in accumulator.
2923  2D4A 12                  ld (de),a           ; copy to first sprite entry.
2924  2D4B 13                  inc de              ; next byte.
2925  2D4C 23                  inc hl              ; next byte.
2926  2D4D 10 F7               djnz swspr0         ; swap all bytes in table entry.
2927  2D4F C9                  ret
2928  2D50
2929  2D50
2930  2D50              ; Process sprites.
2931  2D50
2932  2D50 06 0C        pspr   ld b,NUMSPR         ; sprites to process.
2933  2D52 DD 21 D3 32         ld ix,sprtab        ; sprite table.
2934  2D56 C5           pspr1  push bc             ; store loop counter for now.
2935  2D57 DD 7E 00            ld a,(ix+0)         ; fetch sprite type.
2936  2D5A FE 09               cp 9                ; within range of sprite types?
2937  2D5C DC 68 2D            call c,pspr2        ; yes, process this one.
2938  2D5F 11 11 00            ld de,TABSIZ        ; distance to next odd/even entry.
2939  2D62 DD 19               add ix,de           ; next sprite.
2940  2D64 C1                  pop bc              ; retrieve loop counter.
2941  2D65 10 EF               djnz pspr1          ; repeat for remaining sprites.
2942  2D67 C9                  ret
2943  2D68 DD 22 81 2D  pspr2  ld (ogptr),ix       ; store original sprite pointer.
2944  2D6C CD 74 2D            call pspr3          ; do the routine.
2945  2D6F DD 2A 81 2D  rtorg  ld ix,(ogptr)       ; restore original pointer to sprite.
2946  2D73 C9           rtorg0 ret
2947  2D74 21 83 2D     pspr3  ld hl,evtyp0        ; sprite type events list.
2948  2D77 87           pspr4  add a,a             ; double accumulator.
2949  2D78 5F                  ld e,a              ; copy to de.
2950  2D79 16 00               ld d,0              ; no high byte.
2951  2D7B 19                  add hl,de           ; point to address of routine.
2952  2D7C 5E                  ld e,(hl)           ; address low.
2953  2D7D 23                  inc hl              ; next byte of address.
2954  2D7E 56                  ld d,(hl)           ; address high.
2955  2D7F EB                  ex de,hl            ; swap address into hl.
2956  2D80 E9                  jp (hl)             ; go there.
2957  2D81 00 00        ogptr  defw 0              ; original sprite pointer.
2958  2D83
2959  2D83              ; Address of each sprite type's routine.
2960  2D83
2961  2D83 C4 33        evtyp0 defw evnt00
2962  2D85 5E 34        evtyp1 defw evnt01
2963  2D87 A1 35        evtyp2 defw evnt02
2964  2D89 7F 36        evtyp3 defw evnt03
2965  2D8B 80 36        evtyp4 defw evnt04
2966  2D8D 81 36        evtyp5 defw evnt05
2967  2D8F 82 36        evtyp6 defw evnt06
2968  2D91 83 36        evtyp7 defw evnt07
2969  2D93 84 36        evtyp8 defw evnt08
2970  2D95
2971  2D95
2972  2D95              ; Display sprites.
2973  2D95
2974  2D95 06 06        dspr   ld b,NUMSPR/2       ; number of sprites to display.
2975  2D97 C5           dspr0  push bc             ; store loop counter for now.
2976  2D98 DD 7E 00            ld a,(ix+0)         ; get sprite type.
2977  2D9B 3C                  inc a               ; is it enabled?
2978  2D9C 20 21               jr nz,dspr1         ; yes, it needs deleting.
2979  2D9E DD 7E 05     dspr5  ld a,(ix+5)         ; new type.
2980  2DA1 3C                  inc a               ; is it enabled?
2981  2DA2 20 5C               jr nz,dspr3         ; yes, it needs drawing.
2982  2DA4
2983  2DA4 DD E5        dspr2  push ix             ; put ix on stack.
2984  2DA6 E1                  pop hl              ; pop into hl.
2985  2DA7 5D                  ld e,l              ; copy to de.
2986  2DA8 54                  ld d,h
2987  2DA9
2988  2DA9              ;dspr2  ld e,ixl            ; copy ix to de.
2989  2DA9              ;       ld d,ixh
2990  2DA9              ;       ld l,e              ; copy to hl.
2991  2DA9              ;       ld h,d
2992  2DA9 01 05 00            ld bc,5             ; distance to new type.
2993  2DAC 09                  add hl,bc           ; point to new properties.
2994  2DAD ED A0               ldi                 ; copy to old positions.
2995  2DAF ED A0               ldi
2996  2DB1 ED A0               ldi
2997  2DB3 ED A0               ldi
2998  2DB5 ED A0               ldi
2999  2DB7 0E 22               ld c,TABSIZ*2       ; distance to next odd/even entry.
3000  2DB9 DD 09               add ix,bc           ; next sprite.
3001  2DBB C1                  pop bc              ; retrieve loop counter.
3002  2DBC 10 D9               djnz dspr0          ; repeat for remaining sprites.
3003  2DBE C9                  ret
3004  2DBF              ;dspr1  ld a,(ix+3)         ; old x coord.
3005  2DBF              ;       cp 177              ; beyond maximum?
3006  2DBF              ;       jr nc,dspr5         ; yes, don't delete it.
3007  2DBF DD 7E 03     dspr1  ld a,(ix+3)         ; old x coord.
3008  2DC2 FE B9               cp 185              ; beyond maximum?
3009  2DC4 30 D8               jr nc,dspr5         ; yes, don't delete it.
3010  2DC6 DD 7E 05            ld a,(ix+5)         ; type of new sprite.
3011  2DC9 3C                  inc a               ; is this enabled?
3012  2DCA 20 06               jr nz,dspr4         ; yes, display both.
3013  2DCC CD 7F 2E     dspr6  call sspria         ; show single sprite.
3014  2DCF C3 A4 2D            jp dspr2
3015  2DD2 DD 7E 08     dspr4  ld a,(ix+8)         ; new x coord.
3016  2DD5 FE B9               cp 185              ; beyond maximum?
3017  2DD7 30 F3               jr nc,dspr6         ; yes, don't display it.
3018  2DD9
3019  2DD9              ; Displaying two sprites.  Don't bother redrawing if nothing has changed.
3020  2DD9
3021  2DD9 DD 7E 04            ld a,(ix+4)         ; old y.
3022  2DDC DD BE 09            cp (ix+9)           ; compare with new value.
3023  2DDF 20 19               jr nz,dspr7         ; they differ, need to redraw.
3024  2DE1 DD 7E 03            ld a,(ix+3)         ; old x.
3025  2DE4 DD BE 08            cp (ix+8)           ; compare against new value.
3026  2DE7 20 11               jr nz,dspr7         ; they differ, need to redraw.
3027  2DE9 DD 7E 02            ld a,(ix+2)         ; old frame.
3028  2DEC DD BE 07            cp (ix+7)           ; compare against new value.
3029  2DEF 20 09               jr nz,dspr7         ; they differ, need to redraw.
3030  2DF1 DD 7E 01            ld a,(ix+1)         ; old image.
3031  2DF4 DD BE 06            cp (ix+6)           ; compare against new value.
3032  2DF7 CA A4 2D            jp z,dspr2          ; everything is the same, don't redraw.
3033  2DFA CD 94 2E     dspr7  call sspric         ; delete old sprite, draw new one simultaneously.
3034  2DFD C3 A4 2D            jp dspr2
3035  2E00 DD 7E 08     dspr3  ld a,(ix+8)         ; new x coord.
3036  2E03 FE B9               cp 185              ; beyond maximum?
3037  2E05 30 9D               jr nc,dspr2         ; yes, don't display it.
3038  2E07 CD 8E 2E            call ssprib         ; show single sprite.
3039  2E0A C3 A4 2D            jp dspr2
3040  2E0D
3041  2E0D
3042  2E0D              ; Get sprite address calculations.
3043  2E0D              ; gspran = new sprite, gsprad = old sprite.
3044  2E0D
3045  2E0D DD 6E 08     gspran ld l,(ix+8)         ; new x coordinate.
3046  2E10 DD 66 09            ld h,(ix+9)         ; new y coordinate.
3047  2E13 22 80 22            ld (dispx),hl       ; set display coordinates.
3048  2E16 7D                  ld a,l              ; x coordinate.
3049  2E17 FE B9               cp 185              ; beyond maximum?
3050  2E19 D0                  ret nc              ; yes, don't display it.
3051  2E1A
3052  2E1A DD 7E 06            ld a,(ix+6)         ; new sprite image.
3053  2E1D CD ED 30            call gfrm           ; fetch start frame for this sprite.
3054  2E20 7E                  ld a,(hl)           ; frame in accumulator.
3055  2E21 DD 86 07            add a,(ix+7)        ; new add frame number.
3056  2E24 C3 3E 2E            jp gspra0
3057  2E27
3058  2E27 DD 6E 03     gsprad ld l,(ix+3)         ; x coordinate.
3059  2E2A DD 66 04            ld h,(ix+4)         ; y coordinate.
3060  2E2D 22 80 22            ld (dispx),hl       ; set display coordinates.
3061  2E30 7D                  ld a,l              ; x coordinate.
3062  2E31 FE B9               cp 185              ; beyond lowest point on screen?
3063  2E33 D0                  ret nc              ; yes, don't display it.
3064  2E34
3065  2E34 DD 7E 01            ld a,(ix+1)         ; sprite image.
3066  2E37 CD ED 30            call gfrm           ; fetch start frame for this sprite.
3067  2E3A 7E                  ld a,(hl)           ; frame in accumulator.
3068  2E3B DD 86 02            add a,(ix+2)        ; add frame number.
3069  2E3E 0F           gspra0 rrca                ; multiply by 32.
3070  2E3F 0F                  rrca
3071  2E40 0F                  rrca
3072  2E41 57                  ld d,a              ; store in d.
3073  2E42 E6 E0               and 224             ; low byte bits.
3074  2E44 5F                  ld e,a              ; got low byte.
3075  2E45 7A                  ld a,d              ; restore result.
3076  2E46 E6 1F               and 31              ; high byte bits.
3077  2E48 57                  ld d,a              ; displacement high byte.
3078  2E49 21 9A 39            ld hl,sprgfx        ; address of play sprites.
3079  2E4C 19                  add hl,de           ; frame * 32.
3080  2E4D 19                  add hl,de           ; frame * 64.
3081  2E4E 19                  add hl,de           ; frame * 96.
3082  2E4F 19                  add hl,de           ; frame * 128.
3083  2E50 19                  add hl,de           ; frame * 160.
3084  2E51
3085  2E51 3A 81 22            ld a,(dispy)        ; y coordinate.
3086  2E54 1F                  rra                 ; test odd pixel number.
3087  2E55 30 04               jr nc,gspra1        ; it's even, this address is good.
3088  2E57
3089  2E57 11 50 00            ld de,80            ; displacement to second frame.
3090  2E5A 19                  add hl,de           ; add to sprite address.
3091  2E5B EB           gspra1 ex de,hl            ; need it in de for now.
3092  2E5C
3093  2E5C              ; Drop into screen address routine.
3094  2E5C              ; This routine returns a mode 0 screen address for (dispx, dispy) in hl.
3095  2E5C
3096  2E5C 3A 80 22     scadd  ld a,(dispx)        ; x position.
3097  2E5F E6 F8               and 248             ; get character row (multiple of 8), only 25 so only need 5 bits.
3098  2E61 6F                  ld l,a              ; copy to hl.
3099  2E62 26 00               ld h,0
3100  2E64 29                  add hl,hl           ; * 16.
3101  2E65 44                  ld b,h              ; copy to bc.
3102  2E66 4D                  ld c,l              ; bc = * 16.
3103  2E67 29                  add hl,hl           ; * 32.
3104  2E68 29                  add hl,hl           ; * 64.
3105  2E69 09                  add hl,bc           ; * 80.
3106  2E6A
3107  2E6A              ; Done character row, now work out pixel position.
3108  2E6A
3109  2E6A 3A 80 22            ld a,(dispx)        ; restore x position.
3110  2E6D E6 07               and 7               ; line 0-7 within character square.
3111  2E6F 07                  rlca                ; multiply by 2048.
3112  2E70 07                  rlca
3113  2E71 07                  rlca
3114  2E72 84                  add a,h             ; add to high byte.
3115  2E73 C6 C0               add a,192           ; add base address of screen.
3116  2E75 67                  ld h,a              ; store in high byte.
3117  2E76 3A 81 22            ld a,(dispy)        ; y coordinate.
3118  2E79 1F                  rra                 ; divide by 2, carry already cleared.
3119  2E7A 4F                  ld c,a              ; low byte.
3120  2E7B 06 00               ld b,0              ; no high byte.
3121  2E7D 09                  add hl,bc           ; add to address.
3122  2E7E C9                  ret
3123  2E7F
3124  2E7F              ; These are the sprite routines.
3125  2E7F              ; sspria = single sprite, old (ix).
3126  2E7F              ; ssprib = single sprite, new (ix+5).
3127  2E7F              ; sspric = both sprites, old (ix) and new (ix+5).
3128  2E7F
3129  2E7F CD 27 2E     sspria call gsprad         ; get old sprite address.
3130  2E82 3E 10        sspri2 ld a,16             ; vertical lines.
3131  2E84 F5           sspri0 push af             ; store line counter on stack.
3132  2E85 CD D4 2E            call dline          ; draw a line.
3133  2E88 F1                  pop af              ; restore line counter.
3134  2E89 3D                  dec a               ; one less to go.
3135  2E8A C2 84 2E            jp nz,sspri0
3136  2E8D C9                  ret
3137  2E8E
3138  2E8E CD 0D 2E     ssprib call gspran         ; get new sprite address.
3139  2E91 C3 82 2E            jp sspri2
3140  2E94
3141  2E94 CD 27 2E     sspric call gsprad         ; get old sprite address.
3142  2E97 22 CC 2E            ld (spad1),hl       ; store addresses.
3143  2E9A ED 53 CE 2E         ld (spad2),de
3144  2E9E CD 0D 2E            call gspran         ; get new sprite addresses.
3145  2EA1 3E 10               ld a,16             ; vertical lines.
3146  2EA3 F5           sspri1 push af             ; store line counter.
3147  2EA4 CD D4 2E            call dline          ; draw a line.
3148  2EA7 22 D0 2E            ld (spad3),hl       ; store these addresses.
3149  2EAA ED 53 D2 2E         ld (spad4),de
3150  2EAE 2A CC 2E            ld hl,(spad1)       ; restore old addresses.
3151  2EB1 ED 5B CE 2E         ld de,(spad2)
3152  2EB5 CD D4 2E            call dline          ; delete a line.
3153  2EB8 22 CC 2E            ld (spad1),hl       ; store addresses.
3154  2EBB ED 53 CE 2E         ld (spad2),de
3155  2EBF 2A D0 2E            ld hl,(spad3)       ; flip to new sprite addresses.
3156  2EC2 ED 5B D2 2E         ld de,(spad4)
3157  2EC6 F1                  pop af              ; restore line counter.
3158  2EC7 3D                  dec a               ; one less to go.
3159  2EC8 C2 A3 2E            jp nz,sspri1
3160  2ECB C9                  ret
3161  2ECC
3162  2ECC              ; Storage space for addresses.
3163  2ECC
3164  2ECC 00 00        spad1  defw 0
3165  2ECE 00 00        spad2  defw 0
3166  2ED0 00 00        spad3  defw 0
3167  2ED2 00 00        spad4  defw 0
3168  2ED4
3169  2ED4 1A           dline  ld a,(de)           ; graphic data.
3170  2ED5 AE                  xor (hl)            ; XOR with what's there.
3171  2ED6 77                  ld (hl),a           ; bung it in.
3172  2ED7 13                  inc de              ; next graphic.
3173  2ED8 23                  inc hl              ; next screen address.
3174  2ED9 1A                  ld a,(de)           ; fetch data.
3175  2EDA AE                  xor (hl)            ; XOR with what's there.
3176  2EDB 77                  ld (hl),a           ; bung it in.
3177  2EDC 13                  inc de              ; next graphic.
3178  2EDD 23                  inc hl              ; next destination address.
3179  2EDE 1A                  ld a,(de)           ; third bit of data.
3180  2EDF AE                  xor (hl)            ; XOR with what's there.
3181  2EE0 77                  ld (hl),a           ; bung it in.
3182  2EE1 13                  inc de              ; point to next piece of image.
3183  2EE2 23                  inc hl              ; next screen address.
3184  2EE3 1A                  ld a,(de)           ; fetch fourth byte.
3185  2EE4 AE                  xor (hl)            ; XOR with what's on screen.
3186  2EE5 77                  ld (hl),a           ; write it back.
3187  2EE6 13                  inc de              ; next graphic address.
3188  2EE7 23                  inc hl              ; next screen address.
3189  2EE8 1A                  ld a,(de)           ; fetch last byte.
3190  2EE9 AE                  xor (hl)            ; XOR with screen image.
3191  2EEA 77                  ld (hl),a           ; copy new image to screen.
3192  2EEB 13                  inc de              ; next graphic address.
3193  2EEC
3194  2EEC              ; Line drawn, now work out next target address.
3195  2EEC
3196  2EEC 01 FC 07     nline  ld bc,2044          ; distance to next pixel minus width.
3197  2EEF 09                  add hl,bc           ; point to new screen address.
3198  2EF0 7C                  ld a,h              ; get pixel address.
3199  2EF1 E6 38               and 56              ; straddling character position?
3200  2EF3 C0                  ret nz              ; no, address is okay.
3201  2EF4 01 50 C0            ld bc,49232         ; distance to next pixel.
3202  2EF7              ;       ld bc,49216         ; distance to next pixel.
3203  2EF7 09                  add hl,bc           ; point to new screen address.
3204  2EF8 C9                  ret
3205  2EF9
3206  2EF9 01 00 08     nline2 ld bc,2048          ; distance to next pixel minus width.
3207  2EFC 09                  add hl,bc           ; point to new screen address.
3208  2EFD 7C                  ld a,h              ; get pixel address.
3209  2EFE E6 38               and 56              ; straddling character position?
3210  2F00 C0                  ret nz              ; no, address is okay.
3211  2F01 01 50 C0            ld bc,49232         ; distance to next pixel.
3212  2F04 09                  add hl,bc           ; point to new screen address.
3213  2F05 C9                  ret
3214  2F06
3215  2F06
3216  2F06              ; Animates a sprite.
3217  2F06
3218  2F06 21 50 22     animsp ld hl,frmno         ; game frame.
3219  2F09 A6                  and (hl)            ; is it time to change the frame?
3220  2F0A C0                  ret nz              ; not this frame.
3221  2F0B DD 7E 06            ld a,(ix+6)         ; sprite image.
3222  2F0E CD ED 30            call gfrm           ; get frame data.
3223  2F11 23                  inc hl              ; point to frames.
3224  2F12 DD 7E 07            ld a,(ix+7)         ; sprite frame.
3225  2F15 3C                  inc a               ; next one along.
3226  2F16 BE                  cp (hl)             ; reached the last frame?
3227  2F17 38 01               jr c,anims0         ; no, not yet.
3228  2F19 AF                  xor a               ; start at first frame.
3229  2F1A DD 77 07     anims0 ld (ix+7),a         ; new frame.
3230  2F1D C9                  ret
3231  2F1E 21 50 22     animbk ld hl,frmno         ; game frame.
3232  2F21 A6                  and (hl)            ; is it time to change the frame?
3233  2F22 C0                  ret nz              ; not this frame.
3234  2F23 DD 7E 06            ld a,(ix+6)         ; sprite image.
3235  2F26 CD ED 30            call gfrm           ; get frame data.
3236  2F29 23                  inc hl              ; point to frames.
3237  2F2A DD 7E 07            ld a,(ix+7)         ; sprite frame.
3238  2F2D A7                  and a               ; first one?
3239  2F2E 20 01               jr nz,rtanb0        ; yes, start at end.
3240  2F30 7E                  ld a,(hl)           ; last sprite.
3241  2F31 3D           rtanb0 dec a               ; next one along.
3242  2F32 18 E6               jr anims0           ; set new frame.
3243  2F34
3244  2F34              ; Check for collision with other sprite, strict enforcement.
3245  2F34
3246  2F34 21 D3 32     sktyp  ld hl,sprtab        ; sprite table.
3247  2F37 0E 0C               ld c,NUMSPR         ; number of sprites.
3248  2F39 22 53 2F     sktyp0 ld (skptr),hl       ; store pointer to sprite.
3249  2F3C 7E                  ld a,(hl)           ; get sprite type.
3250  2F3D B8                  cp b                ; is it the type we seek?
3251  2F3E 28 15               jr z,coltyp         ; yes, we can use this one.
3252  2F40 2A 53 2F     sktyp1 ld hl,(skptr)       ; retrieve sprite pointer.
3253  2F43 11 11 00            ld de,TABSIZ        ; size of each entry.
3254  2F46 19                  add hl,de           ; point to next sprite in table.
3255  2F47 0D                  dec c               ; one iteration fewer.
3256  2F48 C2 39 2F            jp nz,sktyp0        ; keep going until we find a slot.
3257  2F4B 21 00 00            ld hl,0             ; default to ROM address - no sprite.
3258  2F4E 22 53 2F            ld (skptr),hl       ; store pointer to sprite.
3259  2F51 B4                  or h                ; don't return with zero flag set.
3260  2F52 C9                  ret                 ; didn't find one.
3261  2F53 00 00        skptr  defw 0              ; search pointer.
3262  2F55
3263  2F55 DD 7E 00     coltyp ld a,(ix+0)         ; current sprite type.
3264  2F58 B8                  cp b                ; seeking sprite of same type?
3265  2F59 28 27               jr z,colty1         ; yes, need to check we're not detecting ourselves.
3266  2F5B 11 08 00     colty0 ld de,X             ; distance to x position in table.
3267  2F5E 19                  add hl,de           ; point to coords.
3268  2F5F 5E                  ld e,(hl)           ; fetch x coordinate.
3269  2F60 23                  inc hl              ; now point to y.
3270  2F61 56                  ld d,(hl)           ; that's y coordinate.
3271  2F62
3272  2F62              ; Drop into collision detection.
3273  2F62
3274  2F62 DD 7E 08     colc16 ld a,(ix+X)         ; x coord.
3275  2F65 93                  sub e               ; subtract x.
3276  2F66 30 02               jr nc,colc1a        ; result is positive.
3277  2F68 ED 44               neg                 ; make negative positive.
3278  2F6A FE 10        colc1a cp 16               ; within x range?
3279  2F6C 30 D2               jr nc,sktyp1        ; no - they've missed.
3280  2F6E 67                  ld h,a              ; store difference.
3281  2F6F DD 7E 09            ld a,(ix+Y)         ; y coord.
3282  2F72 92                  sub d               ; subtract y.
3283  2F73 30 02               jr nc,colc1b        ; result is positive.
3284  2F75 ED 44               neg                 ; make negative positive.
3285  2F77 FE 0A        colc1b cp 10               ; within y range?
3286  2F79 30 C5               jr nc,sktyp1        ; no - they've missed.
3287  2F7B 84                  add a,h             ; add x difference.
3288  2F7C FE 15               cp 21               ; only 4 corner pixels touching?
3289  2F7E D8                  ret c               ; carry set if there's a collision.
3290  2F7F C3 40 2F            jp sktyp1           ; try next sprite in table.
3291  2F82
3292  2F82 DD E5        colty1 push ix             ; base sprite address onto stack.
3293  2F84 D1                  pop de              ; pop it into de.
3294  2F85 EB                  ex de,hl            ; flip hl into de.
3295  2F86 ED 52               sbc hl,de           ; compare the two.
3296  2F88 EB                  ex de,hl            ; restore hl.
3297  2F89 28 B5               jr z,sktyp1         ; addresses are identical.
3298  2F8B C3 5B 2F            jp colty0
3299  2F8E
3300  2F8E              ; Display number.
3301  2F8E
3302  2F8E 01 9F 2F     disply ld bc,displ0        ; display workspace.
3303  2F91 CD B3 24            call num2ch         ; convert accumulator to string.
3304  2F94 0B           displ1 dec bc              ; back one character.
3305  2F95 0A                  ld a,(bc)           ; fetch digit.
3306  2F96 F6 80               or 128              ; insert end marker.
3307  2F98 02                  ld (bc),a           ; new value.
3308  2F99 21 9F 2F            ld hl,displ0        ; display space.
3309  2F9C C3 65 2C            jp dmsg3            ; display the string.
3310  2F9F 00 00 00 8D  displ0 defb 0,0,0,13+128
3311  2FA3
3312  2FA3
3313  2FA3              ; Initialise screen.
3314  2FA3
3315  2FA3 3A B0 33     initsc ld a,(roomtb)       ; whereabouts in the map are we?
3316  2FA6 CD B0 2F            call tstsc          ; find displacement.
3317  2FA9 FE FF               cp 255              ; is it valid?
3318  2FAB C8                  ret z               ; no, it's rubbish.
3319  2FAC 32 5A 22            ld (scno),a         ; store new room number.
3320  2FAF C9                  ret
3321  2FB0
3322  2FB0              ; Test screen.
3323  2FB0
3324  2FB0 21 B4 33     tstsc  ld hl,mapdat-MAPWID ; start of map data, subtract width for negative.
3325  2FB3 47                  ld b,a              ; store room in b for now.
3326  2FB4 C6 05               add a,MAPWID        ; add width in case we're negative.
3327  2FB6 5F                  ld e,a              ; screen into e.
3328  2FB7 16 00               ld d,0              ; zeroise d.
3329  2FB9 19                  add hl,de           ; add displacement to map data.
3330  2FBA 7E                  ld a,(hl)           ; find room number there.
3331  2FBB C9                  ret
3332  2FBC
3333  2FBC              ; Screen left.
3334  2FBC
3335  2FBC 3A B0 33     scrl   ld a,(roomtb)       ; present room table pointer.
3336  2FBF 3D                  dec a               ; room left.
3337  2FC0 CD B0 2F     scrl0  call tstsc          ; test screen.
3338  2FC3 3C                  inc a               ; is there a screen this way?
3339  2FC4 C8                  ret z               ; no, return to loop.
3340  2FC5 78                  ld a,b              ; restore room displacement.
3341  2FC6 32 B0 33            ld (roomtb),a       ; new room table position.
3342  2FC9 CD A3 2F     scrl1  call initsc         ; set new screen.
3343  2FCC 21 7D 22            ld hl,restfl        ; restart screen flag.
3344  2FCF 36 02               ld (hl),2           ; set it.
3345  2FD1 C9                  ret
3346  2FD2 3A B0 33     scrr   ld a,(roomtb)       ; room table pointer.
3347  2FD5 3C                  inc a               ; room right.
3348  2FD6 18 E8               jr scrl0
3349  2FD8 3A B0 33     scru   ld a,(roomtb)       ; room table pointer.
3350  2FDB D6 05               sub MAPWID          ; room up.
3351  2FDD 18 E1               jr scrl0
3352  2FDF 3A B0 33     scrd   ld a,(roomtb)       ; room table pointer.
3353  2FE2 C6 05               add a,MAPWID        ; room down.
3354  2FE4 18 DA               jr scrl0
3355  2FE6
3356  2FE6              ; Jump to new screen.
3357  2FE6
3358  2FE6 21 B9 33     nwscr  ld hl,mapdat        ; start of map data.
3359  2FE9 01 00 50            ld bc,256*80        ; zero room count, 80 to search.
3360  2FEC BE           nwscr0 cp (hl)             ; have we found a match for screen?
3361  2FED 28 05               jr z,nwscr1         ; yes, set new point in map.
3362  2FEF 23                  inc hl              ; next room.
3363  2FF0 0C                  inc c               ; count rooms.
3364  2FF1 10 F9               djnz nwscr0         ; keep looking.
3365  2FF3 C9                  ret
3366  2FF4 79           nwscr1 ld a,c              ; room displacement.
3367  2FF5 32 B0 33            ld (roomtb),a       ; set the map position.
3368  2FF8 18 CF               jr scrl1            ; draw new room.
3369  2FFA
3370  2FFA
3371  2FFA              ; Gravity processing.
3372  2FFA
3373  2FFA DD 7E 0D     grav   ld a,(ix+13)        ; in-air flag.
3374  2FFD A7                  and a               ; are we in the air?
3375  2FFE C8                  ret z               ; no we are not.
3376  2FFF 3C                  inc a               ; increment it.
3377  3000 CA 4A 30            jp z,ogrv           ; set to 255, use old gravity.
3378  3003 DD 77 0D            ld (ix+13),a        ; write new setting.
3379  3006 1F                  rra                 ; every other frame.
3380  3007 30 0A               jr nc,grav0         ; don't apply gravity this time.
3381  3009 DD 7E 0E            ld a,(ix+14)        ; pixels to move.
3382  300C FE 10               cp 16               ; reached maximum?
3383  300E 28 03               jr z,grav0          ; yes, continue.
3384  3010 DD 34 0E            inc (ix+14)         ; slow down ascent/speed up fall.
3385  3013 DD 7E 0E     grav0  ld a,(ix+14)        ; get distance to move.
3386  3016 CB 2F               sra a               ; divide by 2.
3387  3018 A7                  and a               ; any movement required?
3388  3019 C8                  ret z               ; no, not this time.
3389  301A FE 80               cp 128              ; is it up or down?
3390  301C 30 0C               jr nc,gravu         ; it's up.
3391  301E 47           gravd  ld b,a              ; set pixels to move.
3392  301F CD FC 29     gravd0 call cangd          ; can we go down?
3393  3022 20 15               jr nz,gravst        ; can't move down, so stop.
3394  3024 DD 34 08            inc (ix+8)          ; adjust new x coord.
3395  3027 10 F6               djnz gravd0
3396  3029 C9                  ret
3397  302A ED 44        gravu  neg                 ; flip the sign so it's positive.
3398  302C 47                  ld b,a              ; set pixels to move.
3399  302D CD D6 29     gravu0 call cangu          ; can we go up?
3400  3030 C2 D2 30            jp nz,ifalls        ; can't move up, go down next.
3401  3033 DD 35 08            dec (ix+8)          ; adjust new x coord.
3402  3036 10 F5               djnz gravu0
3403  3038 C9                  ret
3404  3039 DD 7E 0E     gravst ld a,(ix+14)        ; jump pointer high.
3405  303C DD 36 0D 00         ld (ix+13),0        ; reset falling flag.
3406  3040 DD 36 0E 00         ld (ix+14),0        ; store new speed.
3407  3044 FE 08               cp 8                ; was speed the maximum?
3408  3046 CA 5B 38     evftf  jp z,evnt15         ; yes, fallen too far.
3409  3049 C9                  ret
3410  304A
3411  304A              ; Old gravity processing for compatibility with Spectrum versions 4.6 and 4.7.
3412  304A
3413  304A DD 5E 0E     ogrv   ld e,(ix+14)        ; get index to table.
3414  304D 16 00               ld d,0              ; no high byte.
3415  304F 21 81 4A            ld hl,jtab          ; jump table.
3416  3052 19                  add hl,de           ; hl points to jump value.
3417  3053 7E                  ld a,(hl)           ; pixels to move.
3418  3054 FE 63               cp 99               ; reached the end?
3419  3056 20 04               jr nz,ogrv0         ; no, continue.
3420  3058 2B                  dec hl              ; go back to previous value.
3421  3059 7E                  ld a,(hl)           ; fetch that from table.
3422  305A 18 03               jr ogrv1
3423  305C DD 34 0E     ogrv0  inc (ix+14)         ; point to next table entry.
3424  305F A7           ogrv1  and a               ; any movement required?
3425  3060 C8                  ret z               ; no, not this time.
3426  3061 FE 80               cp 128              ; is it up or down?
3427  3063 30 0C               jr nc,ogrvu         ; it's up.
3428  3065 47           ogrvd  ld b,a              ; set pixels to move.
3429  3066 CD FC 29     ogrvd0 call cangd          ; can we go down?
3430  3069 20 14               jr nz,ogrvst        ; can't move down, so stop.
3431  306B DD 34 08            inc (ix+8)          ; adjust new x coord.
3432  306E 10 F6               djnz ogrvd0
3433  3070 C9                  ret
3434  3071 ED 44        ogrvu  neg                 ; flip the sign so it's positive.
3435  3073 47                  ld b,a              ; set pixels to move.
3436  3074 CD D6 29     ogrvu0 call cangu          ; can we go up?
3437  3077 20 1D               jr nz,ogrv2         ; can't move up, go down next.
3438  3079 DD 35 08            dec (ix+8)          ; adjust new x coord.
3439  307C 10 F6               djnz ogrvu0
3440  307E C9                  ret
3441  307F DD 5E 0E     ogrvst ld e,(ix+14)        ; get index to table.
3442  3082 16 00               ld d,0              ; no high byte.
3443  3084 21 81 4A            ld hl,jtab          ; jump table.
3444  3087 19                  add hl,de           ; hl points to jump value.
3445  3088 7E                  ld a,(hl)           ; fetch byte from table.
3446  3089 FE 63               cp 99               ; is it the end marker?
3447  308B DD 36 0D 00         ld (ix+13),0        ; reset jump flag.
3448  308F DD 36 0E 00         ld (ix+14),0        ; reset pointer.
3449  3093 C3 46 30            jp evftf
3450  3096 21 81 4A     ogrv2  ld hl,jtab          ; jump table.
3451  3099 06 00               ld b,0              ; offset into table.
3452  309B 7E           ogrv4  ld a,(hl)           ; fetch table byte.
3453  309C FE 64               cp 100              ; hit end or downward move?
3454  309E 38 04               jr c,ogrv3          ; yes.
3455  30A0 23                  inc hl              ; next byte of table.
3456  30A1 04                  inc b               ; next offset.
3457  30A2 18 F7               jr ogrv4            ; keep going until we find crest/end of table.
3458  30A4 DD 70 0E     ogrv3  ld (ix+14),b        ; set next table offset.
3459  30A7 C9                  ret
3460  30A8
3461  30A8              ; Initiate fall check.
3462  30A8
3463  30A8 DD 7E 0D     ifall  ld a,(ix+13)        ; jump pointer flag.
3464  30AB A7                  and a               ; are we in the air?
3465  30AC C0                  ret nz              ; if set, we're already in the air.
3466  30AD DD 66 09            ld h,(ix+9)         ; y coordinate.
3467  30B0 3E 10               ld a,16             ; look down 16 pixels.
3468  30B2 DD 86 08            add a,(ix+8)        ; add x coordinate.
3469  30B5 6F                  ld l,a              ; coords in hl.
3470  30B6 22 80 22            ld (dispx),hl       ; set up test coordinates.
3471  30B9 CD 6F 2B            call tstbl          ; get map address.
3472  30BC CD 5F 2A            call plchk          ; block, platform check.
3473  30BF C0                  ret nz              ; it's solid, don't fall.
3474  30C0 23                  inc hl              ; look right one cell.
3475  30C1 CD 5F 2A            call plchk          ; block, platform check.
3476  30C4 C0                  ret nz              ; it's solid, don't fall.
3477  30C5 3A 81 22            ld a,(dispy)        ; y coordinate.
3478  30C8 CD B5 2B            call rem5           ; position straddling block cells.
3479  30CB 28 05               jr z,ifalls         ; no more checks needed.
3480  30CD 23                  inc hl              ; look to third cell.
3481  30CE CD 5F 2A            call plchk          ; block, platform check.
3482  30D1 C0                  ret nz              ; it's solid, don't fall.
3483  30D2 DD 34 0D     ifalls inc (ix+13)         ; set in air flag.
3484  30D5 DD 36 0E 00         ld (ix+14),0        ; initial speed = 0.
3485  30D9 C9                  ret
3486  30DA DD 7E 0D     tfall  ld a,(ix+13)        ; jump pointer flag.
3487  30DD A7                  and a               ; are we in the air?
3488  30DE C0                  ret nz              ; if set, we're already in the air.
3489  30DF CD A8 30            call ifall          ; do fall test.
3490  30E2 DD 7E 0D            ld a,(ix+13)        ; get falling flag.
3491  30E5 A7                  and a               ; is it set?
3492  30E6 C8                  ret z               ; no.
3493  30E7 DD 36 0D FF         ld (ix+13),255      ; we're using the table.
3494  30EB 18 A9               jr ogrv2            ; find position in table.
3495  30ED
3496  30ED
3497  30ED              ; Get frame data for a particular sprite.
3498  30ED
3499  30ED 07           gfrm   rlca                ; multiple of 2.
3500  30EE 5F                  ld e,a              ; copy to de.
3501  30EF 16 00               ld d,0              ; no high byte as max sprite is 128.
3502  30F1 2A 85 22            ld hl,(frmptr)      ; frames used by game.
3503  30F4 19                  add hl,de           ; point to frame start.
3504  30F5 C9                  ret
3505  30F6
3506  30F6              ; Find sprite list for current room.
3507  30F6
3508  30F6 3A 5A 22     sprlst ld a,(scno)         ; screen number.
3509  30F9 2A 8B 22     sprls2 ld hl,(nmeptr)      ; pointer to enemies.
3510  30FC 47                  ld b,a              ; loop counter in b register.
3511  30FD A7                  and a               ; is it the first screen?
3512  30FE C8                  ret z               ; yes, don't need to search data.
3513  30FF 11 04 00            ld de,NMESIZ        ; bytes to skip.
3514  3102 7E           sprls1 ld a,(hl)           ; fetch type of sprite.
3515  3103 3C                  inc a               ; is it an end marker?
3516  3104 28 03               jr z,sprls0         ; yes, end of this room.
3517  3106 19                  add hl,de           ; point to next sprite in list.
3518  3107 18 F9               jr sprls1           ; continue until end of room.
3519  3109 23           sprls0 inc hl              ; point to start of next screen.
3520  310A 10 F6               djnz sprls1         ; continue until room found.
3521  310C C9                  ret
3522  310D
3523  310D
3524  310D              ; Clear all but a single player sprite.
3525  310D
3526  310D 06 0C        nspr   ld b,NUMSPR         ; sprite slots in table.
3527  310F DD 21 D3 32         ld ix,sprtab        ; sprite table.
3528  3113 11 11 00            ld de,TABSIZ        ; distance to next odd/even entry.
3529  3116 DD 7E 00     nspr0  ld a,(ix+0)         ; fetch sprite type.
3530  3119 A7                  and a               ; is it a player?
3531  311A 28 0D               jr z,nspr1          ; yes, keep this one.
3532  311C DD 36 00 FF         ld (ix+0),255       ; delete sprite.
3533  3120 DD 36 05 FF         ld (ix+5),255       ; remove next type.
3534  3124 DD 19               add ix,de           ; next sprite.
3535  3126 10 EE               djnz nspr0          ; one less space in the table.
3536  3128 C9                  ret
3537  3129 DD 36 00 FF  nspr1  ld (ix+0),255       ; delete sprite.
3538  312D DD 19               add ix,de           ; point to next sprite.
3539  312F 10 01               djnz nspr2          ; one less to do.
3540  3131 C9                  ret
3541  3132 DD 36 00 FF  nspr2  ld (ix+0),255       ; delete sprite.
3542  3136 DD 36 05 FF         ld (ix+5),255       ; remove next type.
3543  313A DD 19               add ix,de           ; next sprite.
3544  313C 10 F4               djnz nspr2          ; one less space in the table.
3545  313E C9                  ret
3546  313F
3547  313F
3548  313F              ; Two initialisation routines.
3549  313F              ; Initialise sprites - copy everything from list to table.
3550  313F
3551  313F 06 0C        ispr   ld b,NUMSPR         ; sprite slots in table.
3552  3141 DD 21 D3 32         ld ix,sprtab        ; sprite table.
3553  3145 7E           ispr2  ld a,(hl)           ; fetch byte.
3554  3146 FE FF               cp 255              ; is it an end marker?
3555  3148 C8                  ret z               ; yes, no more to do.
3556  3149 DD 7E 00     ispr1  ld a,(ix+0)         ; fetch sprite type.
3557  314C FE FF               cp 255              ; is it enabled yet?
3558  314E 20 07               jr nz,ispr4         ; yes, try another slot.
3559  3150 DD 7E 05            ld a,(ix+5)         ; next type.
3560  3153 FE FF               cp 255              ; is it enabled yet?
3561  3155 28 08               jr z,ispr3          ; no, process this one.
3562  3157 11 11 00     ispr4  ld de,TABSIZ        ; distance to next odd/even entry.
3563  315A DD 19               add ix,de           ; next sprite.
3564  315C 10 EB               djnz ispr1          ; repeat for remaining sprites.
3565  315E C9                  ret                 ; no more room in table.
3566  315F CD 94 31     ispr3  call cpsp           ; initialise a sprite.
3567  3162 10 E1               djnz ispr2          ; one less space in the table.
3568  3164 C9                  ret
3569  3165
3570  3165              ; Initialise sprites - but not player, we're keeping the old one.
3571  3165
3572  3165 06 0C        kspr   ld b,NUMSPR         ; sprite slots in table.
3573  3167 DD 21 D3 32         ld ix,sprtab        ; sprite table.
3574  316B 7E           kspr2  ld a,(hl)           ; fetch byte.
3575  316C FE FF               cp 255              ; is it an end marker?
3576  316E C8                  ret z               ; yes, no more to do.
3577  316F A7                  and a               ; is it a player sprite?
3578  3170 20 06               jr nz,kspr1         ; no, add to table as normal.
3579  3172 11 04 00            ld de,NMESIZ        ; distance to next item in list.
3580  3175 19                  add hl,de           ; point to next one.
3581  3176 18 F3               jr kspr2
3582  3178 DD 7E 00     kspr1  ld a,(ix+0)         ; fetch sprite type.
3583  317B FE FF               cp 255              ; is it enabled yet?
3584  317D 20 07               jr nz,kspr4         ; yes, try another slot.
3585  317F DD 7E 05            ld a,(ix+5)         ; next type.
3586  3182 FE FF               cp 255              ; is it enabled yet?
3587  3184 28 08               jr z,kspr3          ; no, process this one.
3588  3186 11 11 00     kspr4  ld de,TABSIZ        ; distance to next odd/even entry.
3589  3189 DD 19               add ix,de           ; next sprite.
3590  318B 10 EB               djnz kspr1          ; repeat for remaining sprites.
3591  318D C9                  ret                 ; no more room in table.
3592  318E CD 94 31     kspr3  call cpsp           ; copy sprite to table.
3593  3191 10 D8               djnz kspr2          ; one less space in the table.
3594  3193 C9                  ret
3595  3194
3596  3194              ; Copy sprite from list to table.
3597  3194
3598  3194 7E           cpsp   ld a,(hl)           ; fetch byte from table.
3599  3195 DD 77 00            ld (ix+0),a         ; set up type.
3600  3198 DD 77 05            ld (ix+PAM1ST),a    ; set up type.
3601  319B 23                  inc hl              ; move to next byte.
3602  319C 7E                  ld a,(hl)           ; fetch byte from table.
3603  319D DD 77 06            ld (ix+6),a         ; set up image.
3604  31A0 23                  inc hl              ; move to next byte.
3605  31A1 7E                  ld a,(hl)           ; fetch byte from table.
3606  31A2 DD 36 03 C8         ld (ix+3),200       ; set initial coordinate off screen.
3607  31A6 DD 77 08            ld (ix+8),a         ; set up coordinate.
3608  31A9 23                  inc hl              ; move to next byte.
3609  31AA 7E                  ld a,(hl)           ; fetch byte from table.
3610  31AB DD 77 09            ld (ix+9),a         ; set up coordinate.
3611  31AE 23                  inc hl              ; move to next byte.
3612  31AF AF                  xor a               ; zeroes in accumulator.
3613  31B0 DD 77 07            ld (ix+7),a         ; reset frame number.
3614  31B3 DD 77 0A            ld (ix+10),a        ; reset direction.
3615  31B6              ;       ld (ix+12),a        ; reset parameter B.
3616  31B6 DD 77 0D            ld (ix+13),a        ; reset jump pointer low.
3617  31B9 DD 77 0E            ld (ix+14),a        ; reset jump pointer high.
3618  31BC DD 36 10 FF         ld (ix+16),255      ; reset data pointer to auto-restore.
3619  31C0 DD E5               push ix             ; store ix pair.
3620  31C2 E5                  push hl             ; store hl pair.
3621  31C3 C5                  push bc
3622  31C4 CD 85 36     evis0  call evnt09         ; perform event.
3623  31C7 C1                  pop bc
3624  31C8 E1                  pop hl              ; restore hl.
3625  31C9 DD E1               pop ix              ; restore ix.
3626  31CB 11 11 00            ld de,TABSIZ        ; distance to next odd/even entry.
3627  31CE DD 19               add ix,de           ; next sprite.
3628  31D0 C9                  ret
3629  31D1
3630  31D1              ; Clear the play area window.
3631  31D1
3632  31D1 2A 51 22     clw    ld hl,(wintop)      ; get coordinates of window.
3633  31D4 22 80 22            ld (dispx),hl       ; put into dispx for calculation.
3634  31D7 3A 06 28            ld a,(papmsk)       ; get paper colour.
3635  31DA 4F                  ld c,a              ; set colour in c register.
3636  31DB CD FF 26            call gprad          ; get print address.
3637  31DE EB                  ex de,hl            ; flip screen address into hl.
3638  31DF 3A 53 22            ld a,(winhgt)       ; height of window.
3639  31E2 07                  rlca                ; multiply by 8 for block height.
3640  31E3 07                  rlca
3641  31E4 07                  rlca
3642  31E5 47                  ld b,a              ; copy to b register.
3643  31E6 C5           clw1   push bc             ; store lines on stack.
3644  31E7 3A 54 22            ld a,(winwid)       ; width of window.
3645  31EA 5F                  ld e,a              ; copy to e.
3646  31EB 07                  rlca                ; multiply by 4.
3647  31EC 07                  rlca
3648  31ED 83                  add a,e             ; multiple of 5 = pixels to write.
3649  31EE CB 3F               srl a               ; divide by 2 = bytes to write.
3650  31F0 E5                  push hl             ; store screen address.
3651  31F1 71           clw0   ld (hl),c           ; write to screen.
3652  31F2 23                  inc hl              ; next 2 pixels.
3653  31F3 3D                  dec a               ; one less byte.
3654  31F4 20 FB               jr nz,clw0          ; repeat to end of window.
3655  31F6 E1                  pop hl              ; restore screen address.
3656  31F7 CD F9 2E            call nline2         ; down one line.
3657  31FA C1                  pop bc              ; restore line counter.
3658  31FB 10 E9               djnz clw1           ; repeat down the screen.
3659  31FD 2A 51 22            ld hl,(wintop)      ; get coordinates of window.
3660  3200 22 75 22            ld (charx),hl       ; put into display position.
3661  3203 C9                  ret
3662  3204
3663  3204              ; Redefine key.
3664  3204              ; Go through table of 80 keys testing each one.
3665  3204              ; Return code for first detected keypress.
3666  3204
3667  3204 CD 9B 22     redky  call debkey         ; debounce previous key.
3668  3207 06 50               ld b,80             ; codes to check.
3669  3209 78           redky0 ld a,b              ; put code in accumulator.
3670  320A 3D                  dec a               ; test 0 - 79, not 1 - 80.
3671  320B CD 1E BB            call 47902          ; check if key pressed.
3672  320E 20 04               jr nz,redky1        ; pressed.
3673  3210 10 F7               djnz redky0         ; repeat until we've scanned them all.
3674  3212 18 F0               jr redky            ; repeat until something is pressed.
3675  3214 05           redky1 dec b               ; always one less.
3676  3215 C9                  ret
3677  3216
3678  3216
3679  3216              ; Effects code.
3680  3216              ; Ticker routine is called 25 times per second.
3681  3216
3682  3216 C9           scrly  ret
3683  3217 97 23               defw txtscr         ; get screen address.
3684  3219 06 08               ld b,8              ; 8 pixel rows.
3685  321B E5                  push hl             ; store screen address.
3686  321C C5           scrly1 push bc             ; store rows on stack.
3687  321D E5                  push hl
3688  321E
3689  321E 3A 92 23            ld a,(txtwid)       ; characters wide.
3690  3221 47                  ld b,a              ; copy to b.
3691  3222 07                  rlca                ; double it.
3692  3223 07                  rlca                ; now quadruple it.
3693  3224 80                  add a,b             ; quintuple width.
3694  3225 CB 3F               srl a               ; divide by 2 for number of bytes to shift.
3695  3227 47                  ld b,a              ; put into the loop counter.
3696  3228 16 00               ld d,0              ; clear previous pixels byte.
3697  322A 7E           scrly0 ld a,(hl)           ; get byte from screen.
3698  322B 5F                  ld e,a              ; copy to e.
3699  322C E6 55               and 85              ; take right pixel.
3700  322E 07                  rlca                ; shift into left position.
3701  322F 77                  ld (hl),a           ; write to screen.
3702  3230 7A                  ld a,d              ; value of 2 pixels to our right.
3703  3231 E6 AA               and 170             ; we want the left pixel of that.
3704  3233 0F                  rrca                ; shift into right position.
3705  3234 B6                  or (hl)             ; merge with screen image.
3706  3235 77                  ld (hl),a           ; write to screen.
3707  3236 53                  ld d,e              ; get old value for next time round.
3708  3237 2B                  dec hl              ; 2 pixels left.
3709  3238 10 F0               djnz scrly0         ; repeat for width of ticker message.
3710  323A E1                  pop hl
3711  323B CD F9 2E            call nline2         ; next screen row down.
3712  323E
3713  323E C1                  pop bc              ; retrieve row counter from stack.
3714  323F 10 DB               djnz scrly1         ; repeat for all rows.
3715  3241 2A 93 23            ld hl,(txtpos)      ; get text pointer.
3716  3244 7E                  ld a,(hl)           ; find character we're displaying.
3717  3245 E6 7F               and 127             ; remove end marker bit if applicable.
3718  3247 FE 0D               cp 13               ; is it newline?
3719  3249 20 02               jr nz,scrly5        ; no, it's okay.
3720  324B 3E 20               ld a,32             ; convert to a space instead.
3721  324D 07           scrly5 rlca
3722  324E 07                  rlca
3723  324F 07                  rlca                ; multiply by 8 to find char.
3724  3250 47                  ld b,a              ; store shift in b.
3725  3251 E6 03               and 3               ; keep within 768-byte range of font.
3726  3253 57                  ld d,a              ; that's our high byte.
3727  3254 78                  ld a,b              ; restore the shift.
3728  3255 E6 F8               and 248
3729  3257 5F                  ld e,a
3730  3258 21 81 46            ld hl,font-256      ; font address.
3731  325B 19                  add hl,de           ; point to image of character.
3732  325C EB                  ex de,hl            ; need the address in de.
3733  325D E1                  pop hl              ; restore screen address.
3734  325E
3735  325E 3A 91 23            ld a,(txtbit)
3736  3261 4F                  ld c,a
3737  3262 06 08               ld b,8              ; height of ticker in pixels.
3738  3264 7E           scrly3 ld a,(hl)           ; get screen byte.
3739  3265 E6 AA               and 170             ; mask off right bit colours.
3740  3267 77                  ld (hl),a           ; write back to screen.
3741  3268 1A                  ld a,(de)           ; get image of char line.
3742  3269 A1                  and c               ; test relevant bit of char.
3743  326A 28 05               jr z,scrly7         ; not set, write paper pixel.
3744  326C 3A 05 28            ld a,(inkmsk)       ; get ink colour.
3745  326F 18 03               jr scrly2
3746  3271 3A 06 28     scrly7 ld a,(papmsk)       ; get paper colour.
3747  3274 E6 55        scrly2 and 85              ; remove left bit.
3748  3276 B6                  or (hl)             ; merge with screen.
3749  3277 77                  ld (hl),a           ; write new bit.
3750  3278 C5                  push bc             ; preserve row number and column bit.
3751  3279 CD F9 2E            call nline2         ; next screen row down.
3752  327C C1                  pop bc              ; restore row number and column bit.
3753  327D 13                  inc de              ; next line of char.
3754  327E 10 E4               djnz scrly3
3755  3280 21 91 23            ld hl,txtbit        ; bit of text to display.
3756  3283 CB 1E               rr (hl)             ; next bit of char to use.
3757  3285 7E                  ld a,(hl)           ; get bit value.
3758  3286 FE 08               cp 8                ; last valid value.
3759  3288 D0                  ret nc              ; not reached end of character yet.
3760  3289 36 80               ld (hl),128         ; start at leftmost bit again.
3761  328B 2A 93 23            ld hl,(txtpos)      ; text pointer.
3762  328E 7E                  ld a,(hl)           ; what was the character?
3763  328F 23                  inc hl              ; next character in message.
3764  3290 17                  rla                 ; end of message?
3765  3291              ;       ret nc              ; not yet, exit here.
3766  3291              ;       ld a,201            ; code for ret.
3767  3291              ;       ld (scrly),a        ; disable scrolling routine.
3768  3291 30 03               jr nc,scrly6        ; not yet - continue.
3769  3293 2A 95 23     scrly4 ld hl,(txtini)      ; start of scrolling message.
3770  3296 22 93 23     scrly6 ld (txtpos),hl      ; new text pointer position.
3771  3299 C9                  ret
3772  329A
3773  329A CD EC 2C     iscrly call preprt         ; set up display position.
3774  329D 21 C7 38            ld hl,msgdat        ; text messages.
3775  32A0 78                  ld a,b              ; width.
3776  32A1 3D                  dec a               ; subtract one.
3777  32A2 FE 20               cp 32               ; is it between 1 and 32?
3778  32A4 30 0B               jr nc,iscrl0        ; no, disable messages.
3779  32A6 79                  ld a,c              ; message number.
3780  32A7 50                  ld d,b              ; copy width to d.
3781  32A8 CD F5 2C            call getwrd         ; find message start.
3782  32AB 42                  ld b,d              ; restore width to b register.
3783  32AC 22 95 23            ld (txtini),hl      ; set initial text position.
3784  32AF 3E 2A               ld a,42             ; code for ld hl,(nn).
3785  32B1 32 16 32     iscrl0 ld (scrly),a        ; enable/disable scrolling routine.
3786  32B4 CD EC 2C            call preprt         ; set up display position.
3787  32B7 CD FF 26            call gprad          ; get print address.
3788  32BA 78                  ld a,b              ; width of ticker.
3789  32BB 07                  rlca                ; multiple of 2.
3790  32BC 07                  rlca                ; multiple of 4.
3791  32BD 80                  add a,b             ; now a multiple of 5.
3792  32BE CB 3F               srl a               ; divide by 2 for number of bytes.
3793  32C0 6F                  ld l,a              ; copy to hl.
3794  32C1 26 00               ld h,0              ; no high byte.
3795  32C3 2B                  dec hl              ; left to end of ticker display.
3796  32C4 19                  add hl,de           ; add width.
3797  32C5 22 97 23            ld (txtscr),hl      ; set text screen address.
3798  32C8 78                  ld a,b              ; width.
3799  32C9 32 92 23            ld (txtwid),a       ; set width in working storage.
3800  32CC 21 91 23            ld hl,txtbit        ; bit of text to display.
3801  32CF 36 80               ld (hl),128         ; start with leftmost bit.
3802  32D1 18 C0               jr scrly4
3803  32D3
3804  32D3              lstrnd equ $               ; end of "random" area.
3805  32D3
3806  32D3              ; Sprite table.
3807  32D3              ; ix+0  = type.
3808  32D3              ; ix+1  = sprite image number.
3809  32D3              ; ix+2  = frame.
3810  32D3              ; ix+3  = x coord.
3811  32D3              ; ix+4  = y coord.
3812  32D3
3813  32D3              ; ix+5  = new type.
3814  32D3              ; ix+6  = new image number.
3815  32D3              ; ix+7  = new frame.
3816  32D3              ; ix+8  = new x coord.
3817  32D3              ; ix+9  = new y coord.
3818  32D3
3819  32D3              ; ix+10 = direction.
3820  32D3              ; ix+11 = parameter 1.
3821  32D3              ; ix+12 = parameter 2.
3822  32D3              ; ix+13 = jump pointer low.
3823  32D3              ; ix+14 = jump pointer high.
3824  32D3              ; ix+15 = data pointer low.
3825  32D3              ; ix+16 = data pointer high.
3826  32D3
3827  32D3
3828  32D3              sprtab equ $
3829  32D3
3830  32D3 FF FF FF...         defs SPRBUF,255
3831  339F
3832  339F FF FF FF FF  ssprit defb 255,255,255,255,255,255,255,0,192,120,0,0,0,255,255,255,255
3832  33A3 FF FF FF 00
3832  33A7 C0 78 00 00
3832  33AB 00 FF FF FF
3832  33AF FF
3833  33B0
3834  33B0 22           roomtb defb 34                     ; room number.
3835  33B1 FF           nosnd  defb 255
3836  33B2
3837  33B2              ; Everything below here will be generated by the editors.
3838  33B2
3839  33B2              ; Sounds.
3840  33B2
3841  33B2              fx1
3842  33B2
3843  33B2 63                  defb 99             ; temporary marker.
3844  33B3
3845  33B3                     include "user.asm"
# file opened: user.asm
   1+ 33B3 C9           user   ret
   2+ 33B4
# file closed: user.asm
3846  33B4
3847  33B4
3848  33B4              WINDOWTOP equ 1
3849  33B4              WINDOWLFT equ 1
3850  33B4              WINDOWHGT equ 22
3851  33B4              WINDOWWID equ 22 ;
3852  33B4              MAPWID equ 5
3853  33B4 FF FF FF FF         defb 255,255,255,255,255
3853  33B8 FF
3854  33B9              mapdat equ $
3855  33B9 FF 00 01 02         defb 255,0,1,2,255
3855  33BD FF
3856  33BE FF FF FF FF         defb 255,255,255,255,255
3856  33C2 FF
3857  33C3 04           stmap  defb 4
3858  33C4              evnt00 equ $
3859  33C4 3E 07               ld a,7
3860  33C6 3A 4F 22            ld a,(joyval)
3861  33C9 E6 01               and 1
3862  33CB CA E3 33            jp z,a00054
3863  33CE CD B0 29            call laddu
3864  33D1 C2 E3 33            jp nz,a00054
3865  33D4 3E 01               ld a,1
3866  33D6 DD 77 06            ld (ix+6),a
3867  33D9 AF                  xor a
3868  33DA CD 06 2F            call animsp
3869  33DD DD 35 08            dec (ix+8)
3870  33E0 DD 35 08            dec (ix+8)
3871  33E3 3A 4F 22     a00054 ld a,(joyval)
3872  33E6 E6 02               and 2
3873  33E8 CA 00 34            jp z,a00102
3874  33EB CD A5 29            call laddd
3875  33EE C2 00 34            jp nz,a00102
3876  33F1 3E 01               ld a,1
3877  33F3 DD 77 06            ld (ix+6),a
3878  33F6 AF                  xor a
3879  33F7 CD 06 2F            call animsp
3880  33FA DD 34 08            inc (ix+8)
3881  33FD DD 34 08            inc (ix+8)
3882  3400 3A 4F 22     a00102 ld a,(joyval)
3883  3403 E6 08               and 8
3884  3405 CA 2C 34            jp z,a00179
3885  3408 CD 2B 2A            call cangr
3886  340B C2 1F 34            jp nz,a00155
3887  340E CD 99 23            call vapour
3888  3411 AF                  xor a
3889  3412 DD 77 06            ld (ix+6),a
3890  3415 AF                  xor a
3891  3416 CD 06 2F            call animsp
3892  3419 DD 34 09            inc (ix+9)
3893  341C C3 2C 34            jp a00179
3894  341F AF           a00155 xor a
3895  3420 21 66 22            ld hl,vark
3896  3423 BE                  cp (hl)
3897  3424 D2 2C 34            jp nc,a00179
3898  3427 3E 03               ld a,3
3899  3429 CD 8D 4A            call dig
3900  342C 3A 4F 22     a00179 ld a,(joyval)
3901  342F E6 04               and 4
3902  3431 CA 58 34            jp z,a00255
3903  3434 CD 22 2A            call cangl
3904  3437 C2 4B 34            jp nz,a00231
3905  343A CD 99 23            call vapour
3906  343D AF                  xor a
3907  343E DD 77 06            ld (ix+6),a
3908  3441 AF                  xor a
3909  3442 CD 06 2F            call animsp
3910  3445 DD 35 09            dec (ix+9)
3911  3448 C3 58 34            jp a00255
3912  344B AF           a00231 xor a
3913  344C 21 66 22            ld hl,vark
3914  344F BE                  cp (hl)
3915  3450 D2 58 34            jp nc,a00255
3916  3453 3E 02               ld a,2
3917  3455 CD 8D 4A            call dig
3918  3458 3E 06        a00255 ld a,6
3919  345A CD 7F 2A            call getcol
3920  345D C9                  ret
3921  345E              evnt01 equ $
3922  345E AF                  xor a
3923  345F DD BE 0A            cp (ix+10)
3924  3462 C2 9C 34            jp nz,b00114
3925  3465 CD B0 29            call laddu
3926  3468 C2 74 34            jp nz,b00038
3927  346B DD 35 08            dec (ix+8)
3928  346E DD 35 08            dec (ix+8)
3929  3471 C3 9C 34            jp b00114
3930  3474 3E 02        b00038 ld a,2
3931  3476 57                  ld d,a
3932  3477 CD F2 2B            call random
3933  347A 67                  ld h,a
3934  347B CD F9 24            call imul
3935  347E 7C                  ld a,h
3936  347F 32 78 22            ld (varrnd),a
3937  3482 AF                  xor a
3938  3483 21 78 22            ld hl,varrnd
3939  3486 BE                  cp (hl)
3940  3487 C2 92 34            jp nz,b00096
3941  348A 3E 02               ld a,2
3942  348C DD 77 0A            ld (ix+10),a
3943  348F C3 97 34            jp b00105
3944  3492 3E 03        b00096 ld a,3
3945  3494 DD 77 0A            ld (ix+10),a
3946  3497 3E 32        b00105 ld a,50
3947  3499 DD 77 0B            ld (ix+11),a
3948  349C 3E 01        b00114 ld a,1
3949  349E DD BE 0A            cp (ix+10)
3950  34A1 C2 DB 34            jp nz,b00225
3951  34A4 CD A5 29            call laddd
3952  34A7 C2 B3 34            jp nz,b00149
3953  34AA DD 34 08            inc (ix+8)
3954  34AD DD 34 08            inc (ix+8)
3955  34B0 C3 DB 34            jp b00225
3956  34B3 3E 02        b00149 ld a,2
3957  34B5 57                  ld d,a
3958  34B6 CD F2 2B            call random
3959  34B9 67                  ld h,a
3960  34BA CD F9 24            call imul
3961  34BD 7C                  ld a,h
3962  34BE 32 78 22            ld (varrnd),a
3963  34C1 AF                  xor a
3964  34C2 21 78 22            ld hl,varrnd
3965  34C5 BE                  cp (hl)
3966  34C6 C2 D1 34            jp nz,b00207
3967  34C9 3E 02               ld a,2
3968  34CB DD 77 0A            ld (ix+10),a
3969  34CE C3 D6 34            jp b00216
3970  34D1 3E 03        b00207 ld a,3
3971  34D3 DD 77 0A            ld (ix+10),a
3972  34D6 3E 32        b00216 ld a,50
3973  34D8 DD 77 0B            ld (ix+11),a
3974  34DB 3E 02        b00225 ld a,2
3975  34DD DD BE 0A            cp (ix+10)
3976  34E0 C2 37 35            jp nz,b00388
3977  34E3 CD 22 2A            call cangl
3978  34E6 C2 F3 34            jp nz,b00264
3979  34E9 DD 35 09            dec (ix+9)
3980  34EC AF                  xor a
3981  34ED DD 77 07            ld (ix+7),a
3982  34F0 C3 F8 34            jp b00272
3983  34F3 3E 03        b00264 ld a,3
3984  34F5 DD 77 0A            ld (ix+10),a
3985  34F8 AF           b00272 xor a
3986  34F9 DD BE 0B            cp (ix+11)
3987  34FC D2 09 35            jp nc,b00303
3988  34FF DD 7E 0B            ld a,(ix+11)
3989  3502 3D                  dec a
3990  3503 DD 77 0B            ld (ix+11),a
3991  3506 C3 37 35            jp b00388
3992  3509 3E 04        b00303 ld a,4
3993  350B 57                  ld d,a
3994  350C CD F2 2B            call random
3995  350F 67                  ld h,a
3996  3510 CD F9 24            call imul
3997  3513 7C                  ld a,h
3998  3514 32 78 22            ld (varrnd),a
3999  3517 AF                  xor a
4000  3518 21 78 22            ld hl,varrnd
4001  351B BE                  cp (hl)
4002  351C C2 37 35            jp nz,b00388
4003  351F CD B0 29            call laddu
4004  3522 C2 2C 35            jp nz,b00370
4005  3525 AF                  xor a
4006  3526 DD 77 0A            ld (ix+10),a
4007  3529 C3 37 35            jp b00388
4008  352C CD A5 29     b00370 call laddd
4009  352F C2 37 35            jp nz,b00388
4010  3532 3E 01               ld a,1
4011  3534 DD 77 0A            ld (ix+10),a
4012  3537 3E 03        b00388 ld a,3
4013  3539 DD BE 0A            cp (ix+10)
4014  353C C2 94 35            jp nz,b00551
4015  353F CD 2B 2A            call cangr
4016  3542 C2 50 35            jp nz,b00427
4017  3545 DD 34 09            inc (ix+9)
4018  3548 3E 01               ld a,1
4019  354A DD 77 07            ld (ix+7),a
4020  354D C3 55 35            jp b00436
4021  3550 3E 02        b00427 ld a,2
4022  3552 DD 77 0A            ld (ix+10),a
4023  3555 AF           b00436 xor a
4024  3556 DD BE 0B            cp (ix+11)
4025  3559 D2 66 35            jp nc,b00466
4026  355C DD 7E 0B            ld a,(ix+11)
4027  355F 3D                  dec a
4028  3560 DD 77 0B            ld (ix+11),a
4029  3563 C3 94 35            jp b00551
4030  3566 3E 04        b00466 ld a,4
4031  3568 57                  ld d,a
4032  3569 CD F2 2B            call random
4033  356C 67                  ld h,a
4034  356D CD F9 24            call imul
4035  3570 7C                  ld a,h
4036  3571 32 78 22            ld (varrnd),a
4037  3574 AF                  xor a
4038  3575 21 78 22            ld hl,varrnd
4039  3578 BE                  cp (hl)
4040  3579 C2 94 35            jp nz,b00551
4041  357C CD B0 29            call laddu
4042  357F C2 89 35            jp nz,b00533
4043  3582 AF                  xor a
4044  3583 DD 77 0A            ld (ix+10),a
4045  3586 C3 94 35            jp b00551
4046  3589 CD A5 29     b00533 call laddd
4047  358C C2 94 35            jp nz,b00551
4048  358F 3E 01               ld a,1
4049  3591 DD 77 0A            ld (ix+10),a
4050  3594 06 00        b00551 ld b,0
4051  3596 CD 34 2F            call sktyp
4052  3599 D2 A0 35            jp nc,b00573
4053  359C 21 7E 22            ld hl,deadf
4054  359F 74                  ld (hl),h
4055  35A0 C9           b00573 ret
4056  35A1              evnt02 equ $
4057  35A1 AF                  xor a
4058  35A2 DD BE 0B            cp (ix+11)
4059  35A5 C2 C2 35            jp nz,c00059
4060  35A8 3E 42               ld a,66
4061  35AA DD BE 0C            cp (ix+12)
4062  35AD C2 B8 35            jp nz,c00042
4063  35B0 3E 01               ld a,1
4064  35B2 DD 77 0B            ld (ix+11),a
4065  35B5 C3 BF 35            jp c00055
4066  35B8 DD 7E 0C     c00042 ld a,(ix+12)
4067  35BB 3D                  dec a
4068  35BC DD 77 0C            ld (ix+12),a
4069  35BF C3 D8 35     c00055 jp c00098
4070  35C2 3E 46        c00059 ld a,70
4071  35C4 DD BE 0C            cp (ix+12)
4072  35C7 C2 D1 35            jp nz,c00085
4073  35CA AF                  xor a
4074  35CB DD 77 0B            ld (ix+11),a
4075  35CE C3 D8 35            jp c00098
4076  35D1 DD 7E 0C     c00085 ld a,(ix+12)
4077  35D4 3C                  inc a
4078  35D5 DD 77 0C            ld (ix+12),a
4079  35D8 DD 7E 0C     c00098 ld a,(ix+12)
4080  35DB 06 00               ld b,0
4081  35DD CD 34 2F            call sktyp
4082  35E0 D2 7E 36            jp nc,c00389
4083  35E3 DD 36 05 FF         ld (ix+5),255
4084  35E7 3E 19               ld a,25
4085  35E9 CD 99 23            call explod
4086  35EC 3E 07               ld a,7
4087  35EE 21 64 00            ld hl,100
4088  35F1 CD 93 26            call addsc
4089  35F4 3A 5C 22            ld a,(vara)
4090  35F7 3D                  dec a
4091  35F8 32 5C 22            ld (vara),a
4092  35FB AF                  xor a
4093  35FC 21 5C 22            ld hl,vara
4094  35FF BE                  cp (hl)
4095  3600 C2 66 36            jp nz,c00349
4096  3603 DD E5               push ix
4097  3605 06 32               ld b,50
4098  3607 CD A4 22            call delay
4099  360A DD E1               pop ix
4100  360C AF           c00187 xor a
4101  360D 21 6F 22            ld hl,vart
4102  3610 BE                  cp (hl)
4103  3611 D2 62 36            jp nc,c00340
4104  3614 3A 6F 22            ld a,(vart)
4105  3617 3D                  dec a
4106  3618 32 6F 22            ld (vart),a
4107  361B 21 01 00            ld hl,1
4108  361E CD 93 26            call addsc
4109  3621 21 0C 1A            ld hl,6668
4110  3624 22 75 22            ld (charx),hl
4111  3627 3A 6F 22            ld a,(vart)
4112  362A 57                  ld d,a
4113  362B 1E 3C               ld e,60
4114  362D CD 0E 25            call idiv
4115  3630 F5                  push af
4116  3631 7A                  ld a,d
4117  3632 CD 8E 2F            call disply
4118  3635 21 76 22            ld hl,chary
4119  3638 34                  inc (hl)
4120  3639 F1                  pop af
4121  363A 01 9F 2F            ld bc,displ0
4122  363D CD DB 24            call num2dd
4123  3640 CD 94 2F            call displ1
4124  3643 21 03 19            ld hl,6403
4125  3646 22 75 22            ld (charx),hl
4126  3649 21 4E 26            ld hl,score
4127  364C 06 06               ld b,6
4128  364E CD 66 26            call dscor
4129  3651 3E 32               ld a,50
4130  3653 32 0D 23            ld (sndtyp),a
4131  3656 DD E5               push ix
4132  3658 06 02               ld b,2
4133  365A CD A4 22            call delay
4134  365D DD E1               pop ix
4135  365F C3 0C 36            jp c00187
4136  3662 21 7C 22     c00340 ld hl,nexlev
4137  3665 74                  ld (hl),h
4138  3666 21 B2 33     c00349 ld hl,fx1
4139  3669 11 29 00            ld de,41
4140  366C 19                  add hl,de
4141  366D CD 1C 25            call isnd
4142  3670 21 03 19            ld hl,6403
4143  3673 22 75 22            ld (charx),hl
4144  3676 21 4E 26            ld hl,score
4145  3679 06 06               ld b,6
4146  367B CD 66 26            call dscor
4147  367E C9           c00389 ret
4148  367F              evnt03 equ $
4149  367F C9                  ret
4150  3680              evnt04 equ $
4151  3680 C9                  ret
4152  3681              evnt05 equ $
4153  3681 C9                  ret
4154  3682              evnt06 equ $
4155  3682 C9                  ret
4156  3683              evnt07 equ $
4157  3683 C9                  ret
4158  3684              evnt08 equ $
4159  3684 C9                  ret
4160  3685              evnt09 equ $
4161  3685 3E 02               ld a,2
4162  3687 DD BE 05            cp (ix+5)
4163  368A C2 9D 36            jp nz,j00045
4164  368D 3A 5C 22            ld a,(vara)
4165  3690 3C                  inc a
4166  3691 32 5C 22            ld (vara),a
4167  3694 AF                  xor a
4168  3695 DD 77 0B            ld (ix+11),a
4169  3698 3E 45               ld a,69
4170  369A DD 77 0C            ld (ix+12),a
4171  369D C9           j00045 ret
4172  369E              evnt10 equ $
4173  369E 3A 6E 22            ld a,(vars)
4174  36A1 3C                  inc a
4175  36A2 32 6E 22            ld (vars),a
4176  36A5 3E 19               ld a,25
4177  36A7 21 6E 22            ld hl,vars
4178  36AA BE                  cp (hl)
4179  36AB D2 E8 36            jp nc,k00143
4180  36AE 0E 19               ld c,25
4181  36B0 3A 6E 22            ld a,(vars)
4182  36B3 91                  sub c
4183  36B4 32 6E 22            ld (vars),a
4184  36B7 AF                  xor a
4185  36B8 21 6F 22            ld hl,vart
4186  36BB BE                  cp (hl)
4187  36BC D2 C6 36            jp nc,k00078
4188  36BF 3A 6F 22            ld a,(vart)
4189  36C2 3D                  dec a
4190  36C3 32 6F 22            ld (vart),a
4191  36C6 21 0C 1A     k00078 ld hl,6668
4192  36C9 22 75 22            ld (charx),hl
4193  36CC 3A 6F 22            ld a,(vart)
4194  36CF 57                  ld d,a
4195  36D0 1E 3C               ld e,60
4196  36D2 CD 0E 25            call idiv
4197  36D5 F5                  push af
4198  36D6 7A                  ld a,d
4199  36D7 CD 8E 2F            call disply
4200  36DA 21 76 22            ld hl,chary
4201  36DD 34                  inc (hl)
4202  36DE F1                  pop af
4203  36DF 01 9F 2F            ld bc,displ0
4204  36E2 CD DB 24            call num2dd
4205  36E5 CD 94 2F            call displ1
4206  36E8 C9           k00143 ret
4207  36E9              evnt11 equ $
4208  36E9 C9                  ret
4209  36EA              evnt12 equ $
4210  36EA 3E 0F               ld a,15
4211  36EC CD E9 27            call conink
4212  36EF 32 05 28            ld (inkmsk),a
4213  36F2 AF                  xor a
4214  36F3 CD E9 27            call conink
4215  36F6 32 06 28            ld (papmsk),a
4216  36F9 CD 41 23            call cls
4217  36FC 21 04 09            ld hl,2308
4218  36FF 22 75 22            ld (charx),hl
4219  3702 3E 63               ld a,99
4220  3704 32 74 22            ld (contrl),a
4221  3707 3E 63        m00053 ld a,99
4222  3709 21 74 22            ld hl,contrl
4223  370C BE                  cp (hl)
4224  370D 28 03               jr z,$+5
4225  370F D2 86 37            jp nc,m00270
4226  3712 CD 41 23            call cls
4227  3715 21 05 09            ld hl,2309
4228  3718 22 75 22            ld (charx),hl
4229  371B 3E 01               ld a,1
4230  371D 32 9E 2C            ld (prtmod),a
4231  3720 AF                  xor a
4232  3721 CD 5F 2C            call dmsg
4233  3724 AF                  xor a
4234  3725 32 9E 2C            ld (prtmod),a
4235  3728 21 09 0A            ld hl,2569
4236  372B 22 75 22            ld (charx),hl
4237  372E 3E 01               ld a,1
4238  3730 CD 5F 2C            call dmsg
4239  3733 21 0B 0A            ld hl,2571
4240  3736 22 75 22            ld (charx),hl
4241  3739 3E 02               ld a,2
4242  373B CD 5F 2C            call dmsg
4243  373E 21 0D 0A            ld hl,2573
4244  3741 22 75 22            ld (charx),hl
4245  3744 3E 03               ld a,3
4246  3746 CD 5F 2C            call dmsg
4247  3749 3E 63               ld a,99
4248  374B 32 74 22            ld (contrl),a
4249  374E 3E 63        m00174 ld a,99
4250  3750 21 74 22            ld hl,contrl
4251  3753 BE                  cp (hl)
4252  3754 C2 83 37            jp nz,m00265
4253  3757 3A 89 4A            ld a,(keys+7)
4254  375A CD 04 2C            call ktest
4255  375D DA 64 37            jp c,m00215
4256  3760 AF                  xor a
4257  3761 32 74 22            ld (contrl),a
4258  3764 3A 8A 4A     m00215 ld a,(keys+8)
4259  3767 CD 04 2C            call ktest
4260  376A DA 72 37            jp c,m00238
4261  376D 3E 01               ld a,1
4262  376F 32 74 22            ld (contrl),a
4263  3772 3A 8B 4A     m00238 ld a,(keys+9)
4264  3775 CD 04 2C            call ktest
4265  3778 DA 80 37            jp c,m00261
4266  377B 3E 02               ld a,2
4267  377D 32 74 22            ld (contrl),a
4268  3780 C3 4E 37     m00261 jp m00174
4269  3783 C3 07 37     m00265 jp m00053
4270  3786 CD 41 23     m00270 call cls
4271  3789 C9                  ret
4272  378A              evnt13 equ $
4273  378A 3E 03               ld a,3
4274  378C 32 5B 22            ld (numlif),a
4275  378F AF                  xor a
4276  3790 32 5A 22            ld (scno),a
4277  3793 CD E6 2F            call nwscr
4278  3796 3E 07               ld a,7
4279  3798 CD E9 27            call conink
4280  379B 32 05 28            ld (inkmsk),a
4281  379E 3E 02               ld a,2
4282  37A0 CD E9 27            call conink
4283  37A3 32 06 28            ld (papmsk),a
4284  37A6 3E 02               ld a,2
4285  37A8 4F                  ld c,a
4286  37A9 47                  ld b,a
4287  37AA CD 38 BC            call 48184
4288  37AD CD 41 23            call cls
4289  37B0 21 02 19            ld hl,6402
4290  37B3 22 75 22            ld (charx),hl
4291  37B6 3E 04               ld a,4
4292  37B8 CD 5F 2C            call dmsg
4293  37BB 21 05 19            ld hl,6405
4294  37BE 22 75 22            ld (charx),hl
4295  37C1 3E 05               ld a,5
4296  37C3 CD 5F 2C            call dmsg
4297  37C6 21 08 1A            ld hl,6664
4298  37C9 22 75 22            ld (charx),hl
4299  37CC 3E 06               ld a,6
4300  37CE CD 5F 2C            call dmsg
4301  37D1 21 0B 1A            ld hl,6667
4302  37D4 22 75 22            ld (charx),hl
4303  37D7 3E 07               ld a,7
4304  37D9 CD 5F 2C            call dmsg
4305  37DC 21 0C 1B            ld hl,6924
4306  37DF 22 75 22            ld (charx),hl
4307  37E2 3E 08               ld a,8
4308  37E4 CD 5F 2C            call dmsg
4309  37E7 21 0E 19            ld hl,6414
4310  37EA 22 75 22            ld (charx),hl
4311  37ED 3E 09               ld a,9
4312  37EF CD 5F 2C            call dmsg
4313  37F2 AF                  xor a
4314  37F3 CD E9 27            call conink
4315  37F6 32 05 28            ld (inkmsk),a
4316  37F9 3E 06               ld a,6
4317  37FB CD E9 27            call conink
4318  37FE 32 06 28            ld (papmsk),a
4319  3801 21 03 19            ld hl,6403
4320  3804 22 75 22            ld (charx),hl
4321  3807 21 4E 26            ld hl,score
4322  380A 06 06               ld b,6
4323  380C CD 66 26            call dscor
4324  380F 21 09 19            ld hl,6409
4325  3812 22 75 22            ld (charx),hl
4326  3815 21 54 26            ld hl,hiscor
4327  3818 06 06               ld b,6
4328  381A CD 66 26            call dscor
4329  381D C9                  ret
4330  381E              evnt14 equ $
4331  381E 21 06 1B            ld hl,6918
4332  3821 22 75 22            ld (charx),hl
4333  3824 3A 5B 22            ld a,(numlif)
4334  3827 CD 8E 2F            call disply
4335  382A 3A 5A 22            ld a,(scno)
4336  382D 32 6E 22            ld (vars),a
4337  3830 3A 6E 22            ld a,(vars)
4338  3833 3C                  inc a
4339  3834 32 6E 22            ld (vars),a
4340  3837 21 0F 1A            ld hl,6671
4341  383A 22 75 22            ld (charx),hl
4342  383D 3A 6E 22            ld a,(vars)
4343  3840 01 9F 2F            ld bc,displ0
4344  3843 CD EA 24            call num2td
4345  3846 CD 94 2F            call displ1
4346  3849 AF                  xor a
4347  384A 32 5C 22            ld (vara),a
4348  384D 3E 3C               ld a,60
4349  384F 32 6F 22            ld (vart),a
4350  3852 AF                  xor a
4351  3853 32 6E 22            ld (vars),a
4352  3856 AF                  xor a
4353  3857 32 66 22            ld (vark),a
4354  385A C9                  ret
4355  385B              evnt15 equ $
4356  385B AF                  xor a
4357  385C DD BE 05            cp (ix+5)
4358  385F C2 66 38            jp nz,p00024
4359  3862 21 7E 22            ld hl,deadf
4360  3865 74                  ld (hl),h
4361  3866 C9           p00024 ret
4362  3867              evnt16 equ $
4363  3867 21 B2 33            ld hl,fx1
4364  386A 11 00 00            ld de,0
4365  386D 19                  add hl,de
4366  386E CD 1C 25            call isnd
4367  3871 3A 5B 22            ld a,(numlif)
4368  3874 3D                  dec a
4369  3875 32 5B 22            ld (numlif),a
4370  3878 C9                  ret
4371  3879              evnt17 equ $
4372  3879 DD E5               push ix
4373  387B 06 32               ld b,50
4374  387D CD A4 22            call delay
4375  3880 DD E1               pop ix
4376  3882 C9                  ret
4377  3883              evnt18 equ $
4378  3883 DD E5               push ix
4379  3885 06 32               ld b,50
4380  3887 CD A4 22            call delay
4381  388A DD E1               pop ix
4382  388C C9                  ret
4383  388D              evnt19 equ $
4384  388D 3E 05               ld a,5
4385  388F CD E9 27            call conink
4386  3892 32 05 28            ld (inkmsk),a
4387  3895 AF                  xor a
4388  3896 CD E9 27            call conink
4389  3899 32 06 28            ld (papmsk),a
4390  389C CD D1 31            call clw
4391  389F CD 99 23            call inishr
4392  38A2 3E 01               ld a,1
4393  38A4 32 9E 2C            ld (prtmod),a
4394  38A7 21 04 05            ld hl,1284
4395  38AA 22 75 22            ld (charx),hl
4396  38AD 3E 0A               ld a,10
4397  38AF CD 5F 2C            call dmsg
4398  38B2 AF                  xor a
4399  38B3 32 9E 2C            ld (prtmod),a
4400  38B6 DD E5               push ix
4401  38B8 06 64               ld b,100
4402  38BA CD A4 22            call delay
4403  38BD DD E1               pop ix
4404  38BF C9                  ret
4405  38C0              evnt20 equ $
4406  38C0 3E 01               ld a,1
4407  38C2 32 66 22            ld (vark),a
4408  38C5 C9                  ret
4409  38C6 C9           ptcusr ret
4410  38C7              WINH   equ WINDOWHGT * 8
4411  38C7              WINW   equ WINDOWWID * 5
4412  38C7              msgdat equ $
4413  38C7 44 49 41 4D         defb 'DIAMOND GEEZE',210
4413  38CB 4F 4E 44 20
4413  38CF 47 45 45 5A
4413  38D3 45 D2
4414  38D5 31 2E 20 4B         defb '1. KEYBOAR',196
4414  38D9 45 59 42 4F
4414  38DD 41 52 C4
4415  38E0 32 2E 20 4B         defb '2. KEMPSTO',206
4415  38E4 45 4D 50 53
4415  38E8 54 4F CE
4416  38EB 33 2E 20 53         defb '3. SINCLAI',210
4416  38EF 49 4E 43 4C
4416  38F3 41 49 D2
4417  38F6 53 43 4F 52         defb 'SCOR',197
4417  38FA C5
4418  38FB 4C 49 56 45         defb 'LIVE',211
4418  38FF D3
4419  3900 48 49 47 C8         defb 'HIG',200
4420  3904 54 49 4D C5         defb 'TIM',197
4421  3908 BA                  defb 186
4422  3909 4C 45 56 45         defb 'LEVE',204
4422  390D CC
4423  390E 4E 45 57 20         defb 'NEW HIGH SCOR',197
4423  3912 48 49 47 48
4423  3916 20 53 43 4F
4423  391A 52 C5
4424  391C 0B           nummsg defb 11
4425  391D              chgfx  equ $
4426  391D 03 03 02 03         defb 3,3,2,3,3,2,3,3,2,3,3,2,3,3,2,3,3,2,3,3,2,3,3,2
4426  3921 03 02 03 03
4426  3925 02 03 03 02
4426  3929 03 03 02 03
4426  392D 03 02 03 03
4426  3931 02 03 03 02
4427  3935 0D 06 08 0D         defb 13,6,8,13,132,8,15,133,10,129,192,128,12,13,2,12,13,128,15,15,128,192,129,128
4427  3939 84 08 0F 85
4427  393D 0A 81 C0 80
4427  3941 0C 0D 02 0C
4427  3945 0D 80 0F 0F
4427  3949 80 C0 81 80
4428  394D 03 03 02 03         defb 3,3,2,3,3,2,255,255,170,3,3,2,3,3,2,3,3,2,255,255,170,3,3,2
4428  3951 03 02 FF FF
4428  3955 AA 03 03 02
4428  3959 03 03 02 03
4428  395D 03 02 FF FF
4428  3961 AA 03 03 02
4429  3965 33 23 22 23         defb 51,35,34,35,51,34,51,35,34,35,51,34,51,35,34,35,51,34,51,35,34,35,51,34
4429  3969 33 22 33 23
4429  396D 22 23 33 22
4429  3971 33 23 22 23
4429  3975 33 22 33 23
4429  3979 22 23 33 22
4430  397D 00 55 00 00         defb 0,85,0,0,170,170,0,255,0,85,0,0,171,170,0,87,0,0,0,0,0,0,0,0
4430  3981 AA AA 00 FF
4430  3985 00 55 00 00
4430  3989 AB AA 00 57
4430  398D 00 00 00 00
4430  3991 00 00 00 00
4431  3995              bprop  equ $
4432  3995 00                  defb 0
4433  3996 02                  defb 2
4434  3997 03                  defb 3
4435  3998 04                  defb 4
4436  3999 08                  defb 8
4437  399A              sprgfx equ $
4438  399A 0B 13 23 03         defb 11,19,35,3,3
4438  399E 03
4439  399F 07 13 33 07         defb 7,19,51,7,11
4439  39A3 0B
4440  39A4 0F 13 3B 03         defb 15,19,59,3,11
4440  39A8 0B
4441  39A9 07 13 33 07         defb 7,19,51,7,11
4441  39AD 0B
4442  39AE 07 13 33 07         defb 7,19,51,7,3
4442  39B2 03
4443  39B3 03 1B 33 23         defb 3,27,51,35,3
4443  39B7 03
4444  39B8 03 03 33 23         defb 3,3,51,35,3
4444  39BC 03
4445  39BD 03 03 33 23         defb 3,3,51,35,3
4445  39C1 03
4446  39C2 03 13 33 23         defb 3,19,51,35,3
4446  39C6 03
4447  39C7 03 13 33 03         defb 3,19,51,3,3
4447  39CB 03
4448  39CC 03 13 33 03         defb 3,19,51,3,3
4448  39D0 03
4449  39D1 03 1B 33 03         defb 3,27,51,3,3
4449  39D5 03
4450  39D6 07 13 33 0B         defb 7,19,51,11,3
4450  39DA 03
4451  39DB 07 13 23 0B         defb 7,19,35,11,3
4451  39DF 03
4452  39E0 07 0B 03 0B         defb 7,11,3,11,3
4452  39E4 03
4453  39E5 0F 0B 07 0F         defb 15,11,7,15,3
4453  39E9 03
4454  39EA 05 03 33 03         defb 5,3,51,3,3
4454  39EE 03
4455  39EF 01 0B 33 23         defb 1,11,51,35,15
4455  39F3 0F
4456  39F4 05 0B 37 23         defb 5,11,55,35,7
4456  39F8 07
4457  39F9 01 0B 33 23         defb 1,11,51,35,15
4457  39FD 0F
4458  39FE 01 0B 33 23         defb 1,11,51,35,11
4458  3A02 0B
4459  3A03 01 07 33 33         defb 1,7,51,51,3
4459  3A07 03
4460  3A08 01 03 13 33         defb 1,3,19,51,3
4460  3A0C 03
4461  3A0D 01 03 13 33         defb 1,3,19,51,3
4461  3A11 03
4462  3A12 01 03 33 33         defb 1,3,51,51,3
4462  3A16 03
4463  3A17 01 03 33 23         defb 1,3,51,35,3
4463  3A1B 03
4464  3A1C 01 03 33 23         defb 1,3,51,35,3
4464  3A20 03
4465  3A21 01 07 33 23         defb 1,7,51,35,3
4465  3A25 03
4466  3A26 01 0B 33 27         defb 1,11,51,39,3
4466  3A2A 03
4467  3A2B 01 0B 33 07         defb 1,11,51,7,3
4467  3A2F 03
4468  3A30 01 0F 03 07         defb 1,15,3,7,3
4468  3A34 03
4469  3A35 05 0F 03 0F         defb 5,15,3,15,11
4469  3A39 0B
4470  3A3A 03 03 03 03         defb 3,3,3,3,3
4470  3A3E 03
4471  3A3F 03 46 89 03         defb 3,70,137,3,3
4471  3A43 03
4472  3A44 03 46 CC 03         defb 3,70,204,3,3
4472  3A48 03
4473  3A49 F0 46 CC 52         defb 240,70,204,82,161
4473  3A4D A1
4474  3A4E 52 46 CC 03         defb 82,70,204,3,161
4474  3A52 A1
4475  3A53 F0 46 CC D8         defb 240,70,204,216,161
4475  3A57 A1
4476  3A58 03 E4 CC 89         defb 3,228,204,137,161
4476  3A5C A1
4477  3A5D 03 03 CC 89         defb 3,3,204,137,3
4477  3A61 03
4478  3A62 03 03 CC 89         defb 3,3,204,137,3
4478  3A66 03
4479  3A67 03 46 CC 89         defb 3,70,204,137,3
4479  3A6B 03
4480  3A6C 03 46 CC 03         defb 3,70,204,3,3
4480  3A70 03
4481  3A71 03 46 CC 03         defb 3,70,204,3,3
4481  3A75 03
4482  3A76 03 E4 CC A1         defb 3,228,204,161,3
4482  3A7A 03
4483  3A7B 52 46 CC A1         defb 82,70,204,161,3
4483  3A7F 03
4484  3A80 F0 46 89 52         defb 240,70,137,82,161
4484  3A84 A1
4485  3A85 F0 03 03 F0         defb 240,3,3,240,161
4485  3A89 A1
4486  3A8A 01 03 03 03         defb 1,3,3,3,3
4486  3A8E 03
4487  3A8F 01 03 CC 03         defb 1,3,204,3,3
4487  3A93 03
4488  3A94 01 03 CC 89         defb 1,3,204,137,3
4488  3A98 03
4489  3A99 50 A1 CC 89         defb 80,161,204,137,240
4489  3A9D F0
4490  3A9E 01 A1 CC 89         defb 1,161,204,137,82
4490  3AA2 52
4491  3AA3 50 A1 CC CC         defb 80,161,204,204,240
4491  3AA7 F0
4492  3AA8 01 52 CC CC         defb 1,82,204,204,82
4492  3AAC 52
4493  3AAD 01 03 46 CC         defb 1,3,70,204,3
4493  3AB1 03
4494  3AB2 01 03 46 CC         defb 1,3,70,204,3
4494  3AB6 03
4495  3AB7 01 03 CC CC         defb 1,3,204,204,3
4495  3ABB 03
4496  3ABC 01 03 CC 89         defb 1,3,204,137,3
4496  3AC0 03
4497  3AC1 01 03 CC 89         defb 1,3,204,137,3
4497  3AC5 03
4498  3AC6 01 52 CC D8         defb 1,82,204,216,3
4498  3ACA 03
4499  3ACB 01 A1 CC D8         defb 1,161,204,216,3
4499  3ACF 03
4500  3AD0 50 A1 CC 03         defb 80,161,204,3,240
4500  3AD4 F0
4501  3AD5 50 A1 03 52         defb 80,161,3,82,240
4501  3AD9 F0
4502  3ADA 03 46 89 03         defb 3,70,137,3,3
4502  3ADE 03
4503  3ADF 03 46 CC 03         defb 3,70,204,3,3
4503  3AE3 03
4504  3AE4 03 46 CC 03         defb 3,70,204,3,3
4504  3AE8 03
4505  3AE9 03 46 CC 03         defb 3,70,204,3,3
4505  3AED 03
4506  3AEE A9 46 CC 03         defb 169,70,204,3,3
4506  3AF2 03
4507  3AF3 56 46 CC 89         defb 86,70,204,137,169
4507  3AF7 A9
4508  3AF8 FC EC CC 89         defb 252,236,204,137,169
4508  3AFC A9
4509  3AFD 56 03 CC DC         defb 86,3,204,220,169
4509  3B01 A9
4510  3B02 03 46 CC 89         defb 3,70,204,137,169
4510  3B06 A9
4511  3B07 03 46 CC 03         defb 3,70,204,3,169
4511  3B0B A9
4512  3B0C 03 46 CC 03         defb 3,70,204,3,3
4512  3B10 03
4513  3B11 03 EC CC 03         defb 3,236,204,3,3
4513  3B15 03
4514  3B16 56 46 CC A9         defb 86,70,204,169,3
4514  3B1A 03
4515  3B1B 56 46 89 A9         defb 86,70,137,169,3
4515  3B1F 03
4516  3B20 56 A9 03 A9         defb 86,169,3,169,3
4516  3B24 03
4517  3B25 FC A9 56 FC         defb 252,169,86,252,3
4517  3B29 03
4518  3B2A 01 03 CC 03         defb 1,3,204,3,3
4518  3B2E 03
4519  3B2F 01 03 CC 89         defb 1,3,204,137,3
4519  3B33 03
4520  3B34 01 03 CC 89         defb 1,3,204,137,3
4520  3B38 03
4521  3B39 01 03 CC 89         defb 1,3,204,137,3
4521  3B3D 03
4522  3B3E 54 03 CC 89         defb 84,3,204,137,3
4522  3B42 03
4523  3B43 01 A9 CC CC         defb 1,169,204,204,86
4523  3B47 56
4524  3B48 54 FC CC CC         defb 84,252,204,204,86
4524  3B4C 56
4525  3B4D 01 A9 46 CC         defb 1,169,70,204,252
4525  3B51 FC
4526  3B52 01 03 CC CC         defb 1,3,204,204,86
4526  3B56 56
4527  3B57 01 03 CC 89         defb 1,3,204,137,86
4527  3B5B 56
4528  3B5C 01 03 CC 89         defb 1,3,204,137,3
4528  3B60 03
4529  3B61 01 56 CC 89         defb 1,86,204,137,3
4529  3B65 03
4530  3B66 01 A9 CC DC         defb 1,169,204,220,3
4530  3B6A 03
4531  3B6B 01 A9 CC 56         defb 1,169,204,86,3
4531  3B6F 03
4532  3B70 01 FC 03 56         defb 1,252,3,86,3
4532  3B74 03
4533  3B75 54 FC 03 FC         defb 84,252,3,252,169
4533  3B79 A9
4534  3B7A 03 46 89 03         defb 3,70,137,3,3
4534  3B7E 03
4535  3B7F 03 46 CC 03         defb 3,70,204,3,3
4535  3B83 03
4536  3B84 03 46 CC 03         defb 3,70,204,3,3
4536  3B88 03
4537  3B89 FC 46 CC 56         defb 252,70,204,86,169
4537  3B8D A9
4538  3B8E 56 46 CC 03         defb 86,70,204,3,169
4538  3B92 A9
4539  3B93 FC 46 CC DC         defb 252,70,204,220,169
4539  3B97 A9
4540  3B98 03 EC CC 89         defb 3,236,204,137,169
4540  3B9C A9
4541  3B9D 03 03 CC 89         defb 3,3,204,137,3
4541  3BA1 03
4542  3BA2 03 46 CC 89         defb 3,70,204,137,3
4542  3BA6 03
4543  3BA7 03 46 CC 03         defb 3,70,204,3,3
4543  3BAB 03
4544  3BAC 03 46 CC 03         defb 3,70,204,3,3
4544  3BB0 03
4545  3BB1 03 46 CC 03         defb 3,70,204,3,3
4545  3BB5 03
4546  3BB6 03 46 CC 03         defb 3,70,204,3,3
4546  3BBA 03
4547  3BBB 03 56 DC 03         defb 3,86,220,3,3
4547  3BBF 03
4548  3BC0 03 FC FC A9         defb 3,252,252,169,3
4548  3BC4 03
4549  3BC5 03 FC FC A9         defb 3,252,252,169,3
4549  3BC9 03
4550  3BCA 01 03 CC 03         defb 1,3,204,3,3
4550  3BCE 03
4551  3BCF 01 03 CC 89         defb 1,3,204,137,3
4551  3BD3 03
4552  3BD4 01 03 CC 89         defb 1,3,204,137,3
4552  3BD8 03
4553  3BD9 54 A9 CC 89         defb 84,169,204,137,252
4553  3BDD FC
4554  3BDE 01 A9 CC 89         defb 1,169,204,137,86
4554  3BE2 56
4555  3BE3 54 A9 CC CC         defb 84,169,204,204,252
4555  3BE7 FC
4556  3BE8 01 56 CC CC         defb 1,86,204,204,86
4556  3BEC 56
4557  3BED 01 03 46 CC         defb 1,3,70,204,3
4557  3BF1 03
4558  3BF2 01 03 CC CC         defb 1,3,204,204,3
4558  3BF6 03
4559  3BF7 01 03 CC 89         defb 1,3,204,137,3
4559  3BFB 03
4560  3BFC 01 03 CC 89         defb 1,3,204,137,3
4560  3C00 03
4561  3C01 01 03 CC 89         defb 1,3,204,137,3
4561  3C05 03
4562  3C06 01 03 CC 89         defb 1,3,204,137,3
4562  3C0A 03
4563  3C0B 01 03 EC A9         defb 1,3,236,169,3
4563  3C0F 03
4564  3C10 01 56 FC FC         defb 1,86,252,252,3
4564  3C14 03
4565  3C15 01 56 FC FC         defb 1,86,252,252,3
4565  3C19 03
4566  3C1A 03 03 CC 03         defb 3,3,204,3,3
4566  3C1E 03
4567  3C1F A9 46 CC 03         defb 169,70,204,3,3
4567  3C23 03
4568  3C24 A9 46 CC 03         defb 169,70,204,3,3
4568  3C28 03
4569  3C29 56 46 CC 03         defb 86,70,204,3,3
4569  3C2D 03
4570  3C2E 56 CC CC 03         defb 86,204,204,3,3
4570  3C32 03
4571  3C33 56 CC DC A9         defb 86,204,220,169,169
4571  3C37 A9
4572  3C38 03 CC 89 FC         defb 3,204,137,252,169
4572  3C3C A9
4573  3C3D 03 CC 89 03         defb 3,204,137,3,3
4573  3C41 03
4574  3C42 03 CC CC 03         defb 3,204,204,3,3
4574  3C46 03
4575  3C47 03 46 CC A9         defb 3,70,204,169,3
4575  3C4B 03
4576  3C4C 03 46 CC FC         defb 3,70,204,252,169
4576  3C50 A9
4577  3C51 03 46 CC FC         defb 3,70,204,252,169
4577  3C55 A9
4578  3C56 56 EC CC 03         defb 86,236,204,3,3
4578  3C5A 03
4579  3C5B 56 03 CC 03         defb 86,3,204,3,3
4579  3C5F 03
4580  3C60 FC 03 03 03         defb 252,3,3,3,3
4580  3C64 03
4581  3C65 FC 03 03 03         defb 252,3,3,3,3
4581  3C69 03
4582  3C6A 01 03 46 89         defb 1,3,70,137,3
4582  3C6E 03
4583  3C6F 54 03 CC 89         defb 84,3,204,137,3
4583  3C73 03
4584  3C74 54 03 CC 89         defb 84,3,204,137,3
4584  3C78 03
4585  3C79 01 A9 CC 89         defb 1,169,204,137,3
4585  3C7D 03
4586  3C7E 01 EC CC 89         defb 1,236,204,137,3
4586  3C82 03
4587  3C83 01 EC CC FC         defb 1,236,204,252,86
4587  3C87 56
4588  3C88 01 46 CC 56         defb 1,70,204,86,252
4588  3C8C FC
4589  3C8D 01 46 CC 03         defb 1,70,204,3,3
4589  3C91 03
4590  3C92 01 46 CC 89         defb 1,70,204,137,3
4590  3C96 03
4591  3C97 01 03 CC DC         defb 1,3,204,220,3
4591  3C9B 03
4592  3C9C 01 03 CC DC         defb 1,3,204,220,252
4592  3CA0 FC
4593  3CA1 01 03 CC DC         defb 1,3,204,220,252
4593  3CA5 FC
4594  3CA6 01 FC CC 89         defb 1,252,204,137,3
4594  3CAA 03
4595  3CAB 01 A9 46 89         defb 1,169,70,137,3
4595  3CAF 03
4596  3CB0 54 A9 03 03         defb 84,169,3,3,3
4596  3CB4 03
4597  3CB5 54 A9 03 03         defb 84,169,3,3,3
4597  3CB9 03
4598  3CBA 03 03 CC 03         defb 3,3,204,3,3
4598  3CBE 03
4599  3CBF 03 46 CC 03         defb 3,70,204,3,3
4599  3CC3 03
4600  3CC4 03 46 CC 03         defb 3,70,204,3,3
4600  3CC8 03
4601  3CC9 A9 46 CC 03         defb 169,70,204,3,169
4601  3CCD A9
4602  3CCE A9 CC CC FC         defb 169,204,204,252,169
4602  3CD2 A9
4603  3CD3 56 CC DC A9         defb 86,204,220,169,3
4603  3CD7 03
4604  3CD8 03 CC 89 03         defb 3,204,137,3,3
4604  3CDC 03
4605  3CDD 03 CC 89 03         defb 3,204,137,3,3
4605  3CE1 03
4606  3CE2 03 CC CC 03         defb 3,204,204,3,3
4606  3CE6 03
4607  3CE7 03 46 CC 03         defb 3,70,204,3,3
4607  3CEB 03
4608  3CEC 56 46 CC A9         defb 86,70,204,169,3
4608  3CF0 03
4609  3CF1 56 EC CC FC         defb 86,236,204,252,3
4609  3CF5 03
4610  3CF6 FC 46 CC 56         defb 252,70,204,86,169
4610  3CFA A9
4611  3CFB FC 03 CC 56         defb 252,3,204,86,169
4611  3CFF A9
4612  3D00 03 03 03 03         defb 3,3,3,3,3
4612  3D04 03
4613  3D05 03 03 03 03         defb 3,3,3,3,3
4613  3D09 03
4614  3D0A 01 03 46 89         defb 1,3,70,137,3
4614  3D0E 03
4615  3D0F 01 03 CC 89         defb 1,3,204,137,3
4615  3D13 03
4616  3D14 01 03 CC 89         defb 1,3,204,137,3
4616  3D18 03
4617  3D19 54 03 CC 89         defb 84,3,204,137,86
4617  3D1D 56
4618  3D1E 54 46 CC DC         defb 84,70,204,220,252
4618  3D22 FC
4619  3D23 01 EC CC FC         defb 1,236,204,252,3
4619  3D27 03
4620  3D28 01 46 CC 03         defb 1,70,204,3,3
4620  3D2C 03
4621  3D2D 01 46 CC 03         defb 1,70,204,3,3
4621  3D31 03
4622  3D32 01 46 CC 89         defb 1,70,204,137,3
4622  3D36 03
4623  3D37 01 03 CC 89         defb 1,3,204,137,3
4623  3D3B 03
4624  3D3C 01 A9 CC DC         defb 1,169,204,220,3
4624  3D40 03
4625  3D41 01 FC CC DC         defb 1,252,204,220,169
4625  3D45 A9
4626  3D46 54 A9 CC 89         defb 84,169,204,137,252
4626  3D4A FC
4627  3D4B 54 A9 46 89         defb 84,169,70,137,252
4627  3D4F FC
4628  3D50 01 03 03 03         defb 1,3,3,3,3
4628  3D54 03
4629  3D55 01 03 03 03         defb 1,3,3,3,3
4629  3D59 03
4630  3D5A 03 03 CC 03         defb 3,3,204,3,3
4630  3D5E 03
4631  3D5F 03 46 CC 03         defb 3,70,204,3,169
4631  3D63 A9
4632  3D64 03 46 CC 03         defb 3,70,204,3,169
4632  3D68 A9
4633  3D69 03 46 CC 56         defb 3,70,204,86,3
4633  3D6D 03
4634  3D6E 03 CC CC A9         defb 3,204,204,169,3
4634  3D72 03
4635  3D73 A9 CC DC A9         defb 169,204,220,169,3
4635  3D77 03
4636  3D78 FC CC 89 03         defb 252,204,137,3,3
4636  3D7C 03
4637  3D7D 56 CC 89 03         defb 86,204,137,3,3
4637  3D81 03
4638  3D82 03 CC CC 03         defb 3,204,204,3,3
4638  3D86 03
4639  3D87 56 EC CC 03         defb 86,236,204,3,3
4639  3D8B 03
4640  3D8C FC 46 CC 03         defb 252,70,204,3,3
4640  3D90 03
4641  3D91 FC 46 CC A9         defb 252,70,204,169,3
4641  3D95 03
4642  3D96 03 46 CC A9         defb 3,70,204,169,3
4642  3D9A 03
4643  3D9B 03 03 CC 56         defb 3,3,204,86,3
4643  3D9F 03
4644  3DA0 03 03 03 56         defb 3,3,3,86,169
4644  3DA4 A9
4645  3DA5 03 03 03 56         defb 3,3,3,86,169
4645  3DA9 A9
4646  3DAA 01 03 46 89         defb 1,3,70,137,3
4646  3DAE 03
4647  3DAF 01 03 CC 89         defb 1,3,204,137,86
4647  3DB3 56
4648  3DB4 01 03 CC 89         defb 1,3,204,137,86
4648  3DB8 56
4649  3DB9 01 03 CC 89         defb 1,3,204,137,169
4649  3DBD A9
4650  3DBE 01 46 CC DC         defb 1,70,204,220,3
4650  3DC2 03
4651  3DC3 54 46 CC FC         defb 84,70,204,252,3
4651  3DC7 03
4652  3DC8 54 EC CC 03         defb 84,236,204,3,3
4652  3DCC 03
4653  3DCD 01 EC CC 03         defb 1,236,204,3,3
4653  3DD1 03
4654  3DD2 01 46 CC 89         defb 1,70,204,137,3
4654  3DD6 03
4655  3DD7 01 FC CC 89         defb 1,252,204,137,3
4655  3DDB 03
4656  3DDC 54 A9 CC 89         defb 84,169,204,137,3
4656  3DE0 03
4657  3DE1 54 A9 CC DC         defb 84,169,204,220,3
4657  3DE5 03
4658  3DE6 01 03 CC DC         defb 1,3,204,220,3
4658  3DEA 03
4659  3DEB 01 03 46 89         defb 1,3,70,137,169
4659  3DEF A9
4660  3DF0 01 03 03 03         defb 1,3,3,3,252
4660  3DF4 FC
4661  3DF5 01 03 03 03         defb 1,3,3,3,252
4661  3DF9 FC
4662  3DFA 03 03 CC 03         defb 3,3,204,3,3
4662  3DFE 03
4663  3DFF 03 46 CC 03         defb 3,70,204,3,3
4663  3E03 03
4664  3E04 03 46 CC 03         defb 3,70,204,3,3
4664  3E08 03
4665  3E09 A9 46 CC 03         defb 169,70,204,3,169
4665  3E0D A9
4666  3E0E A9 CC CC FC         defb 169,204,204,252,169
4666  3E12 A9
4667  3E13 56 CC DC A9         defb 86,204,220,169,3
4667  3E17 03
4668  3E18 03 CC 89 03         defb 3,204,137,3,3
4668  3E1C 03
4669  3E1D 03 CC 89 03         defb 3,204,137,3,3
4669  3E21 03
4670  3E22 03 CC CC 03         defb 3,204,204,3,3
4670  3E26 03
4671  3E27 03 46 CC 03         defb 3,70,204,3,3
4671  3E2B 03
4672  3E2C 56 46 CC A9         defb 86,70,204,169,3
4672  3E30 03
4673  3E31 56 EC CC FC         defb 86,236,204,252,3
4673  3E35 03
4674  3E36 FC 46 CC 56         defb 252,70,204,86,169
4674  3E3A A9
4675  3E3B FC 03 CC 56         defb 252,3,204,86,169
4675  3E3F A9
4676  3E40 03 03 03 03         defb 3,3,3,3,3
4676  3E44 03
4677  3E45 03 03 03 03         defb 3,3,3,3,3
4677  3E49 03
4678  3E4A 01 03 46 89         defb 1,3,70,137,3
4678  3E4E 03
4679  3E4F 01 03 CC 89         defb 1,3,204,137,3
4679  3E53 03
4680  3E54 01 03 CC 89         defb 1,3,204,137,3
4680  3E58 03
4681  3E59 54 03 CC 89         defb 84,3,204,137,86
4681  3E5D 56
4682  3E5E 54 46 CC DC         defb 84,70,204,220,252
4682  3E62 FC
4683  3E63 01 EC CC FC         defb 1,236,204,252,3
4683  3E67 03
4684  3E68 01 46 CC 03         defb 1,70,204,3,3
4684  3E6C 03
4685  3E6D 01 46 CC 03         defb 1,70,204,3,3
4685  3E71 03
4686  3E72 01 46 CC 89         defb 1,70,204,137,3
4686  3E76 03
4687  3E77 01 03 CC 89         defb 1,3,204,137,3
4687  3E7B 03
4688  3E7C 01 A9 CC DC         defb 1,169,204,220,3
4688  3E80 03
4689  3E81 01 FC CC DC         defb 1,252,204,220,169
4689  3E85 A9
4690  3E86 54 A9 CC 89         defb 84,169,204,137,252
4690  3E8A FC
4691  3E8B 54 A9 46 89         defb 84,169,70,137,252
4691  3E8F FC
4692  3E90 01 03 03 03         defb 1,3,3,3,3
4692  3E94 03
4693  3E95 01 03 03 03         defb 1,3,3,3,3
4693  3E99 03
4694  3E9A 56 FC FC A9         defb 86,252,252,169,3
4694  3E9E 03
4695  3E9F 57 FC FC FC         defb 87,252,252,252,3
4695  3EA3 03
4696  3EA4 FF FC FC FC         defb 255,252,252,252,169
4696  3EA8 A9
4697  3EA9 AB FE FF FC         defb 171,254,255,252,169
4697  3EAD A9
4698  3EAE AA 54 03 FC         defb 170,84,3,252,169
4698  3EB2 A9
4699  3EB3 AF FC 0B FC         defb 175,252,11,252,169
4699  3EB7 A9
4700  3EB8 FE FC FC FC         defb 254,252,252,252,169
4700  3EBC A9
4701  3EBD FE 56 FC FC         defb 254,86,252,252,169
4701  3EC1 A9
4702  3EC2 FE 02 FC FC         defb 254,2,252,252,169
4702  3EC6 A9
4703  3EC7 FE FC FC FC         defb 254,252,252,252,169
4703  3ECB A9
4704  3ECC 57 FD AB FC         defb 87,253,171,252,1
4704  3ED0 01
4705  3ED1 AB AA 54 A9         defb 171,170,84,169,3
4705  3ED5 03
4706  3ED6 AA 03 56 01         defb 170,3,86,1,3
4706  3EDA 03
4707  3EDB FE 54 FC 03         defb 254,84,252,3,3
4707  3EDF 03
4708  3EE0 FE FC FC 03         defb 254,252,252,3,3
4708  3EE4 03
4709  3EE5 55 FF FF 03         defb 85,255,255,3,3
4709  3EE9 03
4710  3EEA 01 FC FC FC         defb 1,252,252,252,3
4710  3EEE 03
4711  3EEF 01 FE FC FC         defb 1,254,252,252,169
4711  3EF3 A9
4712  3EF4 55 FE FC FC         defb 85,254,252,252,252
4712  3EF8 FC
4713  3EF9 55 57 FD FE         defb 85,87,253,254,252
4713  3EFD FC
4714  3EFE 55 00 A9 56         defb 85,0,169,86,252
4714  3F02 FC
4715  3F03 55 5E AD 56         defb 85,94,173,86,252
4715  3F07 FC
4716  3F08 55 FC FC FC         defb 85,252,252,252,252
4716  3F0C FC
4717  3F0D 55 A9 FC FC         defb 85,169,252,252,252
4717  3F11 FC
4718  3F12 55 A9 54 FC         defb 85,169,84,252,252
4718  3F16 FC
4719  3F17 55 FC FC FC         defb 85,252,252,252,252
4719  3F1B FC
4720  3F1C 01 FE FF 56         defb 1,254,255,86,168
4720  3F20 A8
4721  3F21 55 57 00 FC         defb 85,87,0,252,3
4721  3F25 03
4722  3F26 55 01 03 A8         defb 85,1,3,168,3
4722  3F2A 03
4723  3F2B 55 A8 FC A9         defb 85,168,252,169,3
4723  3F2F 03
4724  3F30 55 FC FC A9         defb 85,252,252,169,3
4724  3F34 03
4725  3F35 00 FF FF AB         defb 0,255,255,171,3
4725  3F39 03
4726  3F3A 03 FC FC FC         defb 3,252,252,252,3
4726  3F3E 03
4727  3F3F 56 FC FC FD         defb 86,252,252,253,3
4727  3F43 03
4728  3F44 FC FC FC FD         defb 252,252,252,253,171
4728  3F48 AB
4729  3F49 FC FD FE AB         defb 252,253,254,171,171
4729  3F4D AB
4730  3F4E FC A9 56 00         defb 252,169,86,0,171
4730  3F52 AB
4731  3F53 FC A9 5E AD         defb 252,169,94,173,171
4731  3F57 AB
4732  3F58 FC FC FC FC         defb 252,252,252,252,171
4732  3F5C AB
4733  3F5D FC FC FC 56         defb 252,252,252,86,171
4733  3F61 AB
4734  3F62 FC FC A8 56         defb 252,252,168,86,171
4734  3F66 AB
4735  3F67 FC FC FC FC         defb 252,252,252,252,171
4735  3F6B AB
4736  3F6C 54 A9 FF FD         defb 84,169,255,253,3
4736  3F70 03
4737  3F71 03 FC 00 AB         defb 3,252,0,171,171
4737  3F75 AB
4738  3F76 03 54 03 02         defb 3,84,3,2,171
4738  3F7A AB
4739  3F7B 03 56 FC 54         defb 3,86,252,84,171
4739  3F7F AB
4740  3F80 03 56 FC FC         defb 3,86,252,252,171
4740  3F84 AB
4741  3F85 03 57 FF FF         defb 3,87,255,255,1
4741  3F89 01
4742  3F8A 01 56 FC FC         defb 1,86,252,252,169
4742  3F8E A9
4743  3F8F 01 FC FC FC         defb 1,252,252,252,171
4743  3F93 AB
4744  3F94 54 FC FC FC         defb 84,252,252,252,255
4744  3F98 FF
4745  3F99 54 FC FF FD         defb 84,252,255,253,87
4745  3F9D 57
4746  3F9E 54 FC 03 A8         defb 84,252,3,168,85
4746  3FA2 55
4747  3FA3 54 FC 07 FC         defb 84,252,7,252,95
4747  3FA7 5F
4748  3FA8 54 FC FC FC         defb 84,252,252,252,253
4748  3FAC FD
4749  3FAD 54 FC FC A9         defb 84,252,252,169,253
4749  3FB1 FD
4750  3FB2 54 FC FC 01         defb 84,252,252,1,253
4750  3FB6 FD
4751  3FB7 54 FC FC FC         defb 84,252,252,252,253
4751  3FBB FD
4752  3FBC 00 FC 57 FE         defb 0,252,87,254,171
4752  3FC0 AB
4753  3FC1 01 56 A8 55         defb 1,86,168,85,87
4753  3FC5 57
4754  3FC6 01 02 A9 03         defb 1,2,169,3,85
4754  3FCA 55
4755  3FCB 01 03 FC A8         defb 1,3,252,168,253
4755  3FCF FD
4756  3FD0 01 03 FC FC         defb 1,3,252,252,253
4756  3FD4 FD
4757  3FD5 01 03 FF FF         defb 1,3,255,255,170
4757  3FD9 AA
4758  3FDA 03 03 AB 03         defb 3,3,171,3,3
4758  3FDE 03
4759  3FDF 03 57 FF 03         defb 3,87,255,3,3
4759  3FE3 03
4760  3FE4 57 FA FA FF         defb 87,250,250,255,3
4760  3FE8 03
4761  3FE9 FA F0 FA F0         defb 250,240,250,240,171
4761  3FED AB
4762  3FEE FA F5 FF F0         defb 250,245,255,240,171
4762  3FF2 AB
4763  3FF3 FF FA F0 FF         defb 255,250,240,255,171
4763  3FF7 AB
4764  3FF8 FA FA F0 FA         defb 250,250,240,250,171
4764  3FFC AB
4765  3FFD FA FA F0 FA         defb 250,250,240,250,171
4765  4001 AB
4766  4002 FA F5 F5 F0         defb 250,245,245,240,171
4766  4006 AB
4767  4007 FA F5 F5 F5         defb 250,245,245,245,171
4767  400B AB
4768  400C 57 F5 F5 F5         defb 87,245,245,245,3
4768  4010 03
4769  4011 57 F0 FA F5         defb 87,240,250,245,3
4769  4015 03
4770  4016 03 FA FA AB         defb 3,250,250,171,3
4770  401A 03
4771  401B 03 57 F5 03         defb 3,87,245,3,3
4771  401F 03
4772  4020 03 57 F5 03         defb 3,87,245,3,3
4772  4024 03
4773  4025 03 03 AB 03         defb 3,3,171,3,3
4773  4029 03
4774  402A 01 03 57 03         defb 1,3,87,3,3
4774  402E 03
4775  402F 01 03 FF AB         defb 1,3,255,171,3
4775  4033 03
4776  4034 01 FF F5 F5         defb 1,255,245,245,171
4776  4038 AB
4777  4039 55 F0 F5 F0         defb 85,240,245,240,245
4777  403D F5
4778  403E 55 F0 FF FA         defb 85,240,255,250,245
4778  4042 F5
4779  4043 55 FF F0 F5         defb 85,255,240,245,255
4779  4047 FF
4780  4048 55 F5 F0 F5         defb 85,245,240,245,245
4780  404C F5
4781  404D 55 F5 F0 F5         defb 85,245,240,245,245
4781  4051 F5
4782  4052 55 F0 FA FA         defb 85,240,250,250,245
4782  4056 F5
4783  4057 55 F0 FA FA         defb 85,240,250,250,255
4783  405B FF
4784  405C 01 FA FA FA         defb 1,250,250,250,171
4784  4060 AB
4785  4061 01 FA F5 F0         defb 1,250,245,240,171
4785  4065 AB
4786  4066 01 57 F5 F5         defb 1,87,245,245,3
4786  406A 03
4787  406B 01 03 FA AB         defb 1,3,250,171,3
4787  406F 03
4788  4070 01 03 FA AB         defb 1,3,250,171,3
4788  4074 03
4789  4075 01 03 57 03         defb 1,3,87,3,3
4789  4079 03
4790  407A              frmlst equ $
4791  407A 00 04               defb 0,4
4792  407C 04 04               defb 4,4
4793  407E 08 02               defb 8,2
4794  4080 0A 01 0B 00         defb 10,1,11,0
4795  4084              scdat  equ $
4796  4084 D3 00 CE 00         defw 211,206,259,246,289,281
4796  4088 03 01 F6 00
4796  408C 21 01 19 01
4797  4090 01 FF 00 14         defb 1,255,0,20,1,1,255,0,20,1,1,255,0,20,1,1,255,0,20,1,1,255,0,20,255,1,8,2,2,255,1,10,2,2
4797  4094 01 01 FF 00
4797  4098 14 01 01 FF
4797  409C 00 14 01 01
4797  40A0 FF 00 14 01
4797  40A4 01 FF 00 14
4797  40A8 FF 01 08 02
4797  40AC 02 FF 01 0A
4797  40B0 02 02
4798  40B2 01 01 FF 00         defb 1,1,255,0,6,2,2,255,0,10,2,2,1,1,255,0,6,2,2,255,0,10,2,2,1,1,2,2,255,1,11,2,2
4798  40B6 06 02 02 FF
4798  40BA 00 0A 02 02
4798  40BE 01 01 FF 00
4798  40C2 06 02 02 FF
4798  40C6 00 0A 02 02
4798  40CA 01 01 02 02
4798  40CE FF 01 0B 02
4798  40D2 02
4799  40D3 FF 01 07 02         defb 255,1,7,2,2,255,0,11,2,2,255,0,5,1,1,2,2,255,0,11,2,2,255,0,5,255,1,4,2,2,255,1,13
4799  40D7 02 FF 00 0B
4799  40DB 02 02 FF 00
4799  40DF 05 01 01 02
4799  40E3 02 FF 00 0B
4799  40E7 02 02 FF 00
4799  40EB 05 FF 01 04
4799  40EF 02 02 FF 01
4799  40F3 0D
4800  40F4 02 02 01 01         defb 2,2,1,1,1,0,0,2,2,255,0,13,2,2,0,1,1,0,0,2,2,255,0,13,2,2,0,255,1,6,2,2,255,1,6
4800  40F8 01 00 00 02
4800  40FC 02 FF 00 0D
4800  4100 02 02 00 01
4800  4104 01 00 00 02
4800  4108 02 FF 00 0D
4800  410C 02 02 00 FF
4800  4110 01 06 02 02
4800  4114 FF 01 06
4801  4117 02 02 FF 01         defb 2,2,255,1,8,255,0,4,2,2,255,0,6,2,2,255,0,6,1,1,255,0,4,2,2,255,0,6,2,2,255,0,6
4801  411B 08 FF 00 04
4801  411F 02 02 FF 00
4801  4123 06 02 02 FF
4801  4127 00 06 01 01
4801  412B FF 00 04 02
4801  412F 02 FF 00 06
4801  4133 02 02 FF 00
4801  4137 06
4802  4138 FF 01 0A 02         defb 255,1,10,2,2,255,1,7,2,2,1,1,1,255,0,8,2,2,255,0,7,2,2,0,1,1,255,0,8,2,2,255,0,7
4802  413C 02 FF 01 07
4802  4140 02 02 01 01
4802  4144 01 FF 00 08
4802  4148 02 02 FF 00
4802  414C 07 02 02 00
4802  4150 01 01 FF 00
4802  4154 08 02 02 FF
4802  4158 00 07
4803  415A 02 02 00 FF         defb 2,2,0,255,1,23,255,0,22
4803  415E 01 17 FF 00
4803  4162 16
4804  4163 01 FF 00 14         defb 1,255,0,20,1,1,255,0,20,1,1,255,0,20,1,1,255,0,20,1,1,255,0,20,1,1,2,2,255,1,16,2,2
4804  4167 01 01 FF 00
4804  416B 14 01 01 FF
4804  416F 00 14 01 01
4804  4173 FF 00 14 01
4804  4177 01 FF 00 14
4804  417B 01 01 02 02
4804  417F FF 01 10 02
4804  4183 02
4805  4184 01 01 02 02         defb 1,1,2,2,255,0,16,2,2,1,1,2,2,255,0,16,2,2,255,1,11,2,2,255,1,11,255,0,9,2,2,1,1,1
4805  4188 FF 00 10 02
4805  418C 02 01 01 02
4805  4190 02 FF 00 10
4805  4194 02 02 FF 01
4805  4198 0B 02 02 FF
4805  419C 01 0B FF 00
4805  41A0 09 02 02 01
4805  41A4 01 01
4806  41A6 FF 00 06 01         defb 255,0,6,1,1,255,0,9,2,2,1,1,1,255,0,6,255,1,9,2,2,255,1,7,2,2,255,1,4,255,0,7,2,2
4806  41AA 01 FF 00 09
4806  41AE 02 02 01 01
4806  41B2 01 FF 00 06
4806  41B6 FF 01 09 02
4806  41BA 02 FF 01 07
4806  41BE 02 02 FF 01
4806  41C2 04 FF 00 07
4806  41C6 02 02
4807  41C8 FF 00 07 02         defb 255,0,7,2,2,0,0,1,1,255,0,7,2,2,255,0,7,2,2,0,0,255,1,5,2,2,255,1,7,2,2,255,1,8
4807  41CC 02 00 00 01
4807  41D0 01 FF 00 07
4807  41D4 02 02 FF 00
4807  41D8 07 02 02 00
4807  41DC 00 FF 01 05
4807  41E0 02 02 FF 01
4807  41E4 07 02 02 FF
4807  41E8 01 08
4808  41EA 00 00 00 02         defb 0,0,0,2,2,255,0,7,2,2,255,0,6,1,1,0,0,0,2,2,255,0,7,2,2,255,0,6,255,1,8,2,2
4808  41EE 02 FF 00 07
4808  41F2 02 02 FF 00
4808  41F6 06 01 01 00
4808  41FA 00 00 02 02
4808  41FE FF 00 07 02
4808  4202 02 FF 00 06
4808  4206 FF 01 08 02
4808  420A 02
4809  420B FF 01 09 02         defb 255,1,9,2,2,1,1,1,255,0,6,2,2,255,0,9,2,2,0,1,1,255,0,6,2,2,255,0,9,2,2,0,255,1,23
4809  420F 02 01 01 01
4809  4213 FF 00 06 02
4809  4217 02 FF 00 09
4809  421B 02 02 00 01
4809  421F 01 FF 00 06
4809  4223 02 02 FF 00
4809  4227 09 02 02 00
4809  422B FF 01 17
4810  422E FF 00 16            defb 255,0,22
4811  4231 FF 01 04 FF         defb 255,1,4,255,0,10,1,255,0,6,255,1,5,255,0,10,1,255,0,6,255,1,5,255,0,10,1,255,0,6,255,1,9
4811  4235 00 0A 01 FF
4811  4239 00 06 FF 01
4811  423D 05 FF 00 0A
4811  4241 01 FF 00 06
4811  4245 FF 01 05 FF
4811  4249 00 0A 01 FF
4811  424D 00 06 FF 01
4811  4251 09
4812  4252 02 02 FF 01         defb 2,2,255,1,9,2,2,1,1,255,0,7,2,2,255,0,8,1,2,2,1,1,255,0,7,2,2,255,0,8,1,2,2
4812  4256 09 02 02 01
4812  425A 01 FF 00 07
4812  425E 02 02 FF 00
4812  4262 08 01 02 02
4812  4266 01 01 FF 00
4812  426A 07 02 02 FF
4812  426E 00 08 01 02
4812  4272 02
4813  4273 FF 01 04 02         defb 255,1,4,2,2,255,1,8,2,2,255,1,4,2,2,1,1,0,0,2,2,255,0,8,2,2,255,0,4,2,2,1,1
4813  4277 02 FF 01 08
4813  427B 02 02 FF 01
4813  427F 04 02 02 01
4813  4283 01 00 00 02
4813  4287 02 FF 00 08
4813  428B 02 02 FF 00
4813  428F 04 02 02 01
4813  4293 01
4814  4294 00 00 02 02         defb 0,0,2,2,255,0,8,2,2,255,0,4,2,2,255,1,8,2,2,255,1,14,255,0,6,2,2,255,0,12,1,1,255,0,6
4814  4298 FF 00 08 02
4814  429C 02 FF 00 04
4814  42A0 02 02 FF 01
4814  42A4 08 02 02 FF
4814  42A8 01 0E FF 00
4814  42AC 06 02 02 FF
4814  42B0 00 0C 01 01
4814  42B4 FF 00 06
4815  42B7 02 02 FF 00         defb 2,2,255,0,12,255,1,5,2,2,255,1,9,2,2,255,1,6,0,0,0,2,2,255,0,9,2,2,255,0,4,1,1
4815  42BB 0C FF 01 05
4815  42BF 02 02 FF 01
4815  42C3 09 02 02 FF
4815  42C7 01 06 00 00
4815  42CB 00 02 02 FF
4815  42CF 00 09 02 02
4815  42D3 FF 00 04 01
4815  42D7 01
4816  42D8 00 00 00 02         defb 0,0,0,2,2,255,0,9,2,2,255,0,4,1,1,2,2,255,1,16,2,2,1,1,2,2,255,0,16,2,2,1,1
4816  42DC 02 FF 00 09
4816  42E0 02 02 FF 00
4816  42E4 04 01 01 02
4816  42E8 02 FF 01 10
4816  42EC 02 02 01 01
4816  42F0 02 02 FF 00
4816  42F4 10 02 02 01
4816  42F8 01
4817  42F9 02 02 FF 00         defb 2,2,255,0,16,2,2,255,1,6,2,2,255,1,8,2,2,255,1,6,255,0,4,2,2,255,0,4,1,0,0,0,2,2
4817  42FD 10 02 02 FF
4817  4301 01 06 02 02
4817  4305 FF 01 08 02
4817  4309 02 FF 01 06
4817  430D FF 00 04 02
4817  4311 02 FF 00 04
4817  4315 01 00 00 00
4817  4319 02 02
4818  431B FF 00 04 01         defb 255,0,4,1,1,255,0,4,2,2,255,0,4,1,0,0,0,2,2,255,0,4,255,1,23
4818  431F 01 FF 00 04
4818  4323 02 02 FF 00
4818  4327 04 01 00 00
4818  432B 00 02 02 FF
4818  432F 00 04 FF 01
4818  4333 17
4819  4334 01 FF 00 14         defb 1,255,0,20,1,1,255,0,20,1,1,255,0,20,255,1,12,2,2,1,2,2,255,1,7,255,0,10,2,2,1,2,2
4819  4338 01 01 FF 00
4819  433C 14 01 01 FF
4819  4340 00 14 FF 01
4819  4344 0C 02 02 01
4819  4348 02 02 FF 01
4819  434C 07 FF 00 0A
4819  4350 02 02 01 02
4819  4354 02
4820  4355 FF 00 05 01         defb 255,0,5,1,1,255,0,10,2,2,1,2,2,255,0,5,255,1,6,2,2,255,1,10,2,2,255,1,4,255,0,4,2,2
4820  4359 01 FF 00 0A
4820  435D 02 02 01 02
4820  4361 02 FF 00 05
4820  4365 FF 01 06 02
4820  4369 02 FF 01 0A
4820  436D 02 02 FF 01
4820  4371 04 FF 00 04
4820  4375 02 02
4821  4377 FF 00 0A 02         defb 255,0,10,2,2,0,0,1,1,255,0,4,2,2,255,0,10,2,2,0,0,255,1,15,2,2,255,1,7,255,0,6,1
4821  437B 02 00 00 01
4821  437F 01 FF 00 04
4821  4383 02 02 FF 00
4821  4387 0A 02 02 00
4821  438B 00 FF 01 0F
4821  438F 02 02 FF 01
4821  4393 07 FF 00 06
4821  4397 01
4822  4398 FF 00 06 02         defb 255,0,6,2,2,255,0,5,1,1,255,0,6,1,255,0,6,2,2,255,0,5,255,1,6,2,2,1,1,2,2,255,1,8
4822  439C 02 FF 00 05
4822  43A0 01 01 FF 00
4822  43A4 06 01 FF 00
4822  43A8 06 02 02 FF
4822  43AC 00 05 FF 01
4822  43B0 06 02 02 01
4822  43B4 01 02 02 FF
4822  43B8 01 08
4823  43BA 02 02 01 01         defb 2,2,1,1,255,0,4,2,2,0,0,2,2,255,0,8,2,2,1,1,255,0,4,2,2,0,0,2,2,255,0,8,2,2
4823  43BE FF 00 04 02
4823  43C2 02 00 00 02
4823  43C6 02 FF 00 08
4823  43CA 02 02 01 01
4823  43CE FF 00 04 02
4823  43D2 02 00 00 02
4823  43D6 02 FF 00 08
4823  43DA 02 02
4824  43DC 01 01 02 02         defb 1,1,2,2,255,1,11,2,2,255,1,7,2,2,255,0,11,2,2,1,255,0,4,1,1,2,2,255,0,11,2,2,1
4824  43E0 FF 01 0B 02
4824  43E4 02 FF 01 07
4824  43E8 02 02 FF 00
4824  43EC 0B 02 02 01
4824  43F0 FF 00 04 01
4824  43F4 01 02 02 FF
4824  43F8 00 0B 02 02
4824  43FC 01
4825  43FD FF 00 04 FF         defb 255,0,4,255,1,5,2,2,255,1,11,2,2,255,1,4,0,0,0,2,2,255,0,11,2,2,0,0,1,1,0,0,0
4825  4401 01 05 02 02
4825  4405 FF 01 0B 02
4825  4409 02 FF 01 04
4825  440D 00 00 00 02
4825  4411 02 FF 00 0B
4825  4415 02 02 00 00
4825  4419 01 01 00 00
4825  441D 00
4826  441E 02 02 FF 00         defb 2,2,255,0,11,2,2,0,0,255,1,23
4826  4422 0B 02 02 00
4826  4426 00 FF 01 17
4827  442A 01 FF 00 05         defb 1,255,0,5,255,1,17,255,0,4,4,1,0,0,0,3,255,0,10,1,1,255,0,5,1,0,0,0,3,255,0,10,1,1
4827  442E FF 01 11 FF
4827  4432 00 04 04 01
4827  4436 00 00 00 03
4827  443A FF 00 0A 01
4827  443E 01 FF 00 05
4827  4442 01 00 00 00
4827  4446 03 FF 00 0A
4827  444A 01 01
4828  444C 02 02 FF 01         defb 2,2,255,1,8,2,2,255,1,10,2,2,1,255,0,7,2,2,255,0,8,1,1,2,2,1,255,0,7,2,2,255,0,8
4828  4450 08 02 02 FF
4828  4454 01 0A 02 02
4828  4458 01 FF 00 07
4828  445C 02 02 FF 00
4828  4460 08 01 01 02
4828  4464 02 01 FF 00
4828  4468 07 02 02 FF
4828  446C 00 08
4829  446E 01 01 02 02         defb 1,1,2,2,255,1,5,2,2,255,1,4,2,2,1,1,1,2,2,1,1,2,2,255,0,5,2,2,255,0,4,2,2
4829  4472 FF 01 05 02
4829  4476 02 FF 01 04
4829  447A 02 02 01 01
4829  447E 01 02 02 01
4829  4482 01 02 02 FF
4829  4486 00 05 02 02
4829  448A FF 00 04 02
4829  448E 02
4830  448F 00 00 00 02         defb 0,0,0,2,2,1,1,2,2,255,0,5,2,2,255,0,4,2,2,0,0,0,2,2,255,1,6,2,2,255,1,4,2,2
4830  4493 02 01 01 02
4830  4497 02 FF 00 05
4830  449B 02 02 FF 00
4830  449F 04 02 02 00
4830  44A3 00 00 02 02
4830  44A7 FF 01 06 02
4830  44AB 02 FF 01 04
4830  44AF 02 02
4831  44B1 FF 01 0B 00         defb 255,1,11,0,0,0,2,2,255,0,4,2,2,255,0,8,1,1,1,0,0,0,2,2,255,0,4,2,2,255,0,8,1,1,1
4831  44B5 00 00 02 02
4831  44B9 FF 00 04 02
4831  44BD 02 FF 00 08
4831  44C1 01 01 01 00
4831  44C5 00 00 02 02
4831  44C9 FF 00 04 02
4831  44CD 02 FF 00 08
4831  44D1 01 01 01
4832  44D4 02 02 FF 01         defb 2,2,255,1,13,2,2,255,1,5,2,2,255,0,13,2,2,0,0,1,1,1,2,2,255,0,13,2,2,0,0,255,1,6
4832  44D8 0D 02 02 FF
4832  44DC 01 05 02 02
4832  44E0 FF 00 0D 02
4832  44E4 02 00 00 01
4832  44E8 01 01 02 02
4832  44EC FF 00 0D 02
4832  44F0 02 00 00 FF
4832  44F4 01 06
4833  44F6 02 02 FF 01         defb 2,2,255,1,6,2,2,255,1,8,255,0,4,2,2,255,0,5,1,2,2,255,0,6,1,1,255,0,4,2,2,255,0,5
4833  44FA 06 02 02 FF
4833  44FE 01 08 FF 00
4833  4502 04 02 02 FF
4833  4506 00 05 01 02
4833  450A 02 FF 00 06
4833  450E 01 01 FF 00
4833  4512 04 02 02 FF
4833  4516 00 05
4834  4518 01 02 02 FF         defb 1,2,2,255,0,6,1,1,2,2,255,1,7,2,2,255,1,7,2,2,1,1,2,2,255,0,7,2,2,255,0,7,2,2
4834  451C 00 06 01 01
4834  4520 02 02 FF 01
4834  4524 07 02 02 FF
4834  4528 01 07 02 02
4834  452C 01 01 02 02
4834  4530 FF 00 07 02
4834  4534 02 FF 00 07
4834  4538 02 02
4835  453A 01 01 02 02         defb 1,1,2,2,255,0,7,2,2,255,0,7,2,2,255,1,23
4835  453E FF 00 07 02
4835  4542 02 FF 00 07
4835  4546 02 02 FF 01
4835  454A 17
4836  454B 01 04 00 00         defb 1,4,0,0,0,1,255,0,15,1,1,255,0,20,255,1,4,2,2,255,0,16,255,1,8,2,2,255,1,8,2,2,255,1,4
4836  454F 00 01 FF 00
4836  4553 0F 01 01 FF
4836  4557 00 14 FF 01
4836  455B 04 02 02 FF
4836  455F 00 10 FF 01
4836  4563 08 02 02 FF
4836  4567 01 08 02 02
4836  456B FF 01 04
4837  456E FF 00 06 02         defb 255,0,6,2,2,255,0,8,2,2,0,0,1,1,255,0,6,2,2,255,0,8,2,2,0,0,255,1,4,2,2,255,1,6
4837  4572 02 FF 00 08
4837  4576 02 02 00 00
4837  457A 01 01 FF 00
4837  457E 06 02 02 FF
4837  4582 00 08 02 02
4837  4586 00 00 FF 01
4837  458A 04 02 02 FF
4837  458E 01 06
4838  4590 02 02 FF 01         defb 2,2,255,1,10,0,0,2,2,255,0,6,2,2,255,0,8,1,1,0,0,2,2,255,0,6,2,2,255,0,8,255,1,7
4838  4594 0A 00 00 02
4838  4598 02 FF 00 06
4838  459C 02 02 FF 00
4838  45A0 08 01 01 00
4838  45A4 00 02 02 FF
4838  45A8 00 06 02 02
4838  45AC FF 00 08 FF
4838  45B0 01 07
4839  45B2 02 02 FF 01         defb 2,2,255,1,11,2,2,1,1,255,0,5,2,2,255,0,4,3,255,0,6,2,2,1,1,255,0,5,2,2,255,0,4
4839  45B6 0B 02 02 01
4839  45BA 01 FF 00 05
4839  45BE 02 02 FF 00
4839  45C2 04 03 FF 00
4839  45C6 06 02 02 01
4839  45CA 01 FF 00 05
4839  45CE 02 02 FF 00
4839  45D2 04
4840  45D3 03 FF 00 06         defb 3,255,0,6,2,2,1,1,2,2,255,1,7,2,2,1,2,2,255,1,8,2,2,255,0,7,2,2,1,2,2,255,0,6
4840  45D7 02 02 01 01
4840  45DB 02 02 FF 01
4840  45DF 07 02 02 01
4840  45E3 02 02 FF 01
4840  45E7 08 02 02 FF
4840  45EB 00 07 02 02
4840  45EF 01 02 02 FF
4840  45F3 00 06
4841  45F5 01 01 02 02         defb 1,1,2,2,255,0,7,2,2,1,2,2,255,0,6,255,1,8,2,2,255,1,7,2,2,1,2,2,1,1,255,0,6
4841  45F9 FF 00 07 02
4841  45FD 02 01 02 02
4841  4601 FF 00 06 FF
4841  4605 01 08 02 02
4841  4609 FF 01 07 02
4841  460D 02 01 02 02
4841  4611 01 01 FF 00
4841  4615 06
4842  4616 02 02 00 00         defb 2,2,0,0,0,1,0,0,0,2,2,1,2,2,1,1,255,0,6,2,2,0,0,0,1,0,0,0,2,2,1,2,2
4842  461A 00 01 00 00
4842  461E 00 02 02 01
4842  4622 02 02 01 01
4842  4626 FF 00 06 02
4842  462A 02 00 00 00
4842  462E 01 00 00 00
4842  4632 02 02 01 02
4842  4636 02
4843  4637 01 01 02 02         defb 1,1,2,2,255,1,10,2,2,255,1,4,2,2,1,1,2,2,255,0,10,2,2,255,0,4,2,2,1,1,2,2,255,0,10
4843  463B FF 01 0A 02
4843  463F 02 FF 01 04
4843  4643 02 02 01 01
4843  4647 02 02 FF 00
4843  464B 0A 02 02 FF
4843  464F 00 04 02 02
4843  4653 01 01 02 02
4843  4657 FF 00 0A
4844  465A 02 02 FF 00         defb 2,2,255,0,4,2,2,255,1,23
4844  465E 04 02 02 FF
4844  4662 01 17
4845  4664 06           numsc  defb 6
4846  4665 00 00 68 4B  nmedat defb 0,0,104,75,1,2,128,10,2,3,152,10,2,3,56,50,2,3,80,100,2,3,32,10,255
4846  4669 01 02 80 0A
4846  466D 02 03 98 0A
4846  4671 02 03 38 32
4846  4675 02 03 50 64
4846  4679 02 03 20 0A
4846  467D FF
4847  467E 00 00 50 28         defb 0,0,80,40,1,2,128,10,1,2,32,10,2,3,32,50,2,3,56,70,2,3,80,80,2,3,128,55,255
4847  4682 01 02 80 0A
4847  4686 01 02 20 0A
4847  468A 02 03 20 32
4847  468E 02 03 38 46
4847  4692 02 03 50 50
4847  4696 02 03 80 37
4847  469A FF
4848  469B 00 00 40 55         defb 0,0,64,85,1,2,40,35,1,2,112,40,2,3,16,25,2,3,16,80,2,3,88,95,2,3,136,55,2,3,160,10,2,3,160,100,255
4848  469F 01 02 28 23
4848  46A3 01 02 70 28
4848  46A7 02 03 10 19
4848  46AB 02 03 10 50
4848  46AF 02 03 58 5F
4848  46B3 02 03 88 37
4848  46B7 02 03 A0 0A
4848  46BB 02 03 A0 64
4848  46BF FF
4849  46C0 00 00 A0 0A         defb 0,0,160,10,1,2,16,65,1,2,64,50,1,2,112,70,2,3,16,10,2,3,88,10,2,3,136,100,2,3,16,95,2,3,64,15,255
4849  46C4 01 02 10 41
4849  46C8 01 02 40 32
4849  46CC 01 02 70 46
4849  46D0 02 03 10 0A
4849  46D4 02 03 58 0A
4849  46D8 02 03 88 64
4849  46DC 02 03 10 5F
4849  46E0 02 03 40 0F
4849  46E4 FF
4850  46E5 00 00 70 64         defb 0,0,112,100,1,2,88,45,1,2,16,100,1,2,160,40,2,3,88,100,2,3,40,25,2,3,16,40,2,3,160,65,255
4850  46E9 01 02 58 2D
4850  46ED 01 02 10 64
4850  46F1 01 02 A0 28
4850  46F5 02 03 58 64
4850  46F9 02 03 28 19
4850  46FD 02 03 10 28
4850  4701 02 03 A0 41
4850  4705 FF
4851  4706 00 00 58 37         defb 0,0,88,55,1,2,16,100,1,2,136,10,1,2,112,100,2,3,40,100,2,3,64,10,2,3,40,10,2,3,136,55,2,3,160,85,255
4851  470A 01 02 10 64
4851  470E 01 02 88 0A
4851  4712 01 02 70 64
4851  4716 02 03 28 64
4851  471A 02 03 40 0A
4851  471E 02 03 28 0A
4851  4722 02 03 88 37
4851  4726 02 03 A0 55
4851  472A FF
4852  472B              NUMOBJ equ 1
4853  472B              objdta equ $
4854  472B C0 C0 C0 C0         defb 192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192
4854  472F C0 C0 C0 C0
4854  4733 C0 C0 C0 C0
4854  4737 C0 C0 C0 C0
4855  473B C0 C0 C0 C0         defb 192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192
4855  473F C0 C0 C0 C0
4855  4743 C0 C0 C0 C0
4855  4747 C0 C0 C0 C0
4856  474B C0 C0 C0 C0         defb 192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192
4856  474F C0 C0 C0 C0
4856  4753 C0 C0 C0 C0
4856  4757 C0 C0 C0 C0
4857  475B C0 C0 C0 C0         defb 192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192
4857  475F C0 C0 C0 C0
4857  4763 C0 C0 C0 C0
4857  4767 C0 C0 C0 C0
4858  476B FE 38 4B FE         defb 254,56,75,254,56,75
4858  476F 38 4B
4859  4771              palett equ $
4860  4771 00 02 06 08         defb 0,2,6,8,18,20,24,26,0,5,15,3,24,11,16,25
4860  4775 12 14 18 1A
4860  4779 00 05 0F 03
4860  477D 18 0B 10 19
4861  4781              font   equ $
4862  4781 00 00 00 00         defb 0,0,0,0,0,0,0,0
4862  4785 00 00 00 00
4863  4789 00 20 20 20         defb 0,32,32,32,32,0,32,0
4863  478D 20 00 20 00
4864  4791 50 50 00 00         defb 80,80,0,0,0,0,0,0
4864  4795 00 00 00 00
4865  4799 00 50 F8 50         defb 0,80,248,80,248,80,0,0
4865  479D F8 50 00 00
4866  47A1 20 70 C0 60         defb 32,112,192,96,48,224,32,0
4866  47A5 30 E0 20 00
4867  47A9 00 A0 20 40         defb 0,160,32,64,64,128,160,0
4867  47AD 40 80 A0 00
4868  47B1 00 40 A0 40         defb 0,64,160,64,176,160,112,0
4868  47B5 B0 A0 70 00
4869  47B9 40 40 00 00         defb 64,64,0,0,0,0,0,0
4869  47BD 00 00 00 00
4870  47C1 00 20 40 40         defb 0,32,64,64,64,64,32,0
4870  47C5 40 40 20 00
4871  47C9 00 40 20 20         defb 0,64,32,32,32,32,64,0
4871  47CD 20 20 40 00
4872  47D1 00 20 F8 70         defb 0,32,248,112,248,32,0,0
4872  47D5 F8 20 00 00
4873  47D9 00 40 40 E0         defb 0,64,64,224,64,64,0,0
4873  47DD 40 40 00 00
4874  47E1 00 00 00 00         defb 0,0,0,0,0,0,32,64
4874  47E5 00 00 20 40
4875  47E9 00 00 00 E0         defb 0,0,0,224,0,0,0,0
4875  47ED 00 00 00 00
4876  47F1 00 00 00 00         defb 0,0,0,0,0,0,64,0
4876  47F5 00 00 40 00
4877  47F9 00 20 20 40         defb 0,32,32,64,64,128,128,0
4877  47FD 40 80 80 00
4878  4801 00 60 90 B0         defb 0,96,144,176,208,144,96,0
4878  4805 D0 90 60 00
4879  4809 00 40 C0 40         defb 0,64,192,64,64,64,224,0
4879  480D 40 40 E0 00
4880  4811 00 60 90 10         defb 0,96,144,16,96,128,240,0
4880  4815 60 80 F0 00
4881  4819 00 60 90 20         defb 0,96,144,32,16,144,96,0
4881  481D 10 90 60 00
4882  4821 00 20 60 A0         defb 0,32,96,160,240,32,32,0
4882  4825 F0 20 20 00
4883  4829 00 F0 80 E0         defb 0,240,128,224,16,16,224,0
4883  482D 10 10 E0 00
4884  4831 00 60 80 E0         defb 0,96,128,224,144,144,96,0
4884  4835 90 90 60 00
4885  4839 00 F0 10 20         defb 0,240,16,32,32,64,64,0
4885  483D 20 40 40 00
4886  4841 00 60 90 60         defb 0,96,144,96,144,144,96,0
4886  4845 90 90 60 00
4887  4849 00 60 90 90         defb 0,96,144,144,112,16,96,0
4887  484D 70 10 60 00
4888  4851 00 00 40 00         defb 0,0,64,0,0,64,0,0
4888  4855 00 40 00 00
4889  4859 00 00 40 00         defb 0,0,64,0,0,64,128,0
4889  485D 00 40 80 00
4890  4861 00 00 20 40         defb 0,0,32,64,128,64,32,0
4890  4865 80 40 20 00
4891  4869 00 00 80 40         defb 0,0,128,64,32,64,128,0
4891  486D 20 40 80 00
4892  4871 00 00 00 E0         defb 0,0,0,224,0,224,0,0
4892  4875 00 E0 00 00
4893  4879 00 E0 10 20         defb 0,224,16,32,64,0,64,0
4893  487D 40 00 40 00
4894  4881 00 60 90 B0         defb 0,96,144,176,176,128,112,0
4894  4885 B0 80 70 00
4895  4889 00 60 90 90         defb 0,96,144,144,240,144,144,0
4895  488D F0 90 90 00
4896  4891 00 E0 90 E0         defb 0,224,144,224,144,144,224,0
4896  4895 90 90 E0 00
4897  4899 00 60 90 80         defb 0,96,144,128,128,144,96,0
4897  489D 80 90 60 00
4898  48A1 00 C0 A0 90         defb 0,192,160,144,144,144,224,0
4898  48A5 90 90 E0 00
4899  48A9 00 F0 80 E0         defb 0,240,128,224,128,128,240,0
4899  48AD 80 80 F0 00
4900  48B1 00 F0 80 E0         defb 0,240,128,224,128,128,128,0
4900  48B5 80 80 80 00
4901  48B9 00 60 90 80         defb 0,96,144,128,176,144,112,0
4901  48BD B0 90 70 00
4902  48C1 00 90 90 F0         defb 0,144,144,240,144,144,144,0
4902  48C5 90 90 90 00
4903  48C9 00 E0 40 40         defb 0,224,64,64,64,64,224,0
4903  48CD 40 40 E0 00
4904  48D1 00 30 10 10         defb 0,48,16,16,16,144,96,0
4904  48D5 10 90 60 00
4905  48D9 00 90 A0 C0         defb 0,144,160,192,160,144,144,0
4905  48DD A0 90 90 00
4906  48E1 00 80 80 80         defb 0,128,128,128,128,128,240,0
4906  48E5 80 80 F0 00
4907  48E9 00 88 D8 A8         defb 0,136,216,168,136,136,136,0
4907  48ED 88 88 88 00
4908  48F1 00 90 D0 D0         defb 0,144,208,208,176,176,144,0
4908  48F5 B0 B0 90 00
4909  48F9 00 60 90 90         defb 0,96,144,144,144,144,96,0
4909  48FD 90 90 60 00
4910  4901 00 E0 90 90         defb 0,224,144,144,224,128,128,0
4910  4905 E0 80 80 00
4911  4909 00 60 90 90         defb 0,96,144,144,176,144,112,0
4911  490D B0 90 70 00
4912  4911 00 E0 90 A0         defb 0,224,144,160,192,160,144,0
4912  4915 C0 A0 90 00
4913  4919 00 70 80 40         defb 0,112,128,64,32,16,224,0
4913  491D 20 10 E0 00
4914  4921 00 F8 20 20         defb 0,248,32,32,32,32,32,0
4914  4925 20 20 20 00
4915  4929 00 90 90 90         defb 0,144,144,144,144,144,96,0
4915  492D 90 90 60 00
4916  4931 00 88 88 50         defb 0,136,136,80,80,32,32,0
4916  4935 50 20 20 00
4917  4939 00 88 88 88         defb 0,136,136,136,168,168,80,0
4917  493D A8 A8 50 00
4918  4941 00 90 90 60         defb 0,144,144,96,96,144,144,0
4918  4945 60 90 90 00
4919  4949 00 88 88 50         defb 0,136,136,80,32,32,32,0
4919  494D 20 20 20 00
4920  4951 00 F0 10 20         defb 0,240,16,32,64,128,240,0
4920  4955 40 80 F0 00
4921  4959 00 60 40 40         defb 0,96,64,64,64,64,96,0
4921  495D 40 40 60 00
4922  4961 00 80 80 40         defb 0,128,128,64,64,32,32,0
4922  4965 40 20 20 00
4923  4969 00 60 20 20         defb 0,96,32,32,32,32,96,0
4923  496D 20 20 60 00
4924  4971 40 A0 00 00         defb 64,160,0,0,0,0,0,0
4924  4975 00 00 00 00
4925  4979 00 00 00 00         defb 0,0,0,0,0,0,0,248
4925  497D 00 00 00 F8
4926  4981 30 40 40 E0         defb 48,64,64,224,64,64,240,0
4926  4985 40 40 F0 00
4927  4989 00 E0 10 70         defb 0,224,16,112,144,144,112,0
4927  498D 90 90 70 00
4928  4991 00 80 80 E0         defb 0,128,128,224,144,144,224,0
4928  4995 90 90 E0 00
4929  4999 00 00 60 80         defb 0,0,96,128,128,144,96,0
4929  499D 80 90 60 00
4930  49A1 00 10 10 70         defb 0,16,16,112,144,144,112,0
4930  49A5 90 90 70 00
4931  49A9 00 00 60 90         defb 0,0,96,144,240,128,112,0
4931  49AD F0 80 70 00
4932  49B1 00 30 40 E0         defb 0,48,64,224,64,64,64,0
4932  49B5 40 40 40 00
4933  49B9 00 00 70 90         defb 0,0,112,144,144,112,16,96
4933  49BD 90 70 10 60
4934  49C1 00 80 80 80         defb 0,128,128,128,224,144,144,0
4934  49C5 E0 90 90 00
4935  49C9 00 40 00 C0         defb 0,64,0,192,64,64,224,0
4935  49CD 40 40 E0 00
4936  49D1 00 20 00 60         defb 0,32,0,96,32,32,32,192
4936  49D5 20 20 20 C0
4937  49D9 00 80 90 A0         defb 0,128,144,160,192,160,144,0
4937  49DD C0 A0 90 00
4938  49E1 00 40 40 40         defb 0,64,64,64,64,64,32,0
4938  49E5 40 40 20 00
4939  49E9 00 00 50 A8         defb 0,0,80,168,168,136,136,0
4939  49ED A8 88 88 00
4940  49F1 00 00 E0 90         defb 0,0,224,144,144,144,144,0
4940  49F5 90 90 90 00
4941  49F9 00 00 60 90         defb 0,0,96,144,144,144,96,0
4941  49FD 90 90 60 00
4942  4A01 00 00 E0 90         defb 0,0,224,144,144,224,128,128
4942  4A05 90 E0 80 80
4943  4A09 00 00 70 90         defb 0,0,112,144,144,112,16,16
4943  4A0D 90 70 10 10
4944  4A11 00 00 60 80         defb 0,0,96,128,128,128,128,0
4944  4A15 80 80 80 00
4945  4A19 00 00 70 80         defb 0,0,112,128,96,16,224,0
4945  4A1D 60 10 E0 00
4946  4A21 00 40 E0 40         defb 0,64,224,64,64,64,32,0
4946  4A25 40 40 20 00
4947  4A29 00 00 90 90         defb 0,0,144,144,144,144,96,0
4947  4A2D 90 90 60 00
4948  4A31 00 00 88 88         defb 0,0,136,136,80,80,32,0
4948  4A35 50 50 20 00
4949  4A39 00 00 88 88         defb 0,0,136,136,136,168,80,0
4949  4A3D 88 A8 50 00
4950  4A41 00 00 90 90         defb 0,0,144,144,96,144,144,0
4950  4A45 60 90 90 00
4951  4A49 00 00 90 90         defb 0,0,144,144,144,112,16,224
4951  4A4D 90 70 10 E0
4952  4A51 00 00 F0 20         defb 0,0,240,32,64,128,240,0
4952  4A55 40 80 F0 00
4953  4A59 00 60 40 C0         defb 0,96,64,192,64,64,96,0
4953  4A5D 40 40 60 00
4954  4A61 00 40 40 40         defb 0,64,64,64,64,64,64,0
4954  4A65 40 40 40 00
4955  4A69 00 C0 40 60         defb 0,192,64,96,64,64,192,0
4955  4A6D 40 40 C0 00
4956  4A71 00 50 A0 00         defb 0,80,160,0,0,0,0,0
4956  4A75 00 00 00 00
4957  4A79 70 88 20 40         defb 112,136,32,64,64,32,136,112
4957  4A7D 40 20 88 70
4958  4A81              jtab   equ $
4959  4A81 63                  defb 99
4960  4A82 41 3B 21 20  keys   defb 65,59,33,32,38,71,44,64,65,57,56
4960  4A86 26 47 2C 40
4960  4A8A 41 39 38
4961  4A8D E6 03        dig    and 3
4962  4A8F 28 40               jr z,digu
4963  4A91 3D                  dec a
4964  4A92 28 32               jr z,digd
4965  4A94 3D                  dec a
4966  4A95 28 24               jr z,digl
4967  4A97 DD 6E 08     digr   ld l,(ix+8)
4968  4A9A DD 7E 09            ld a,(ix+9)
4969  4A9D C6 09               add a,9
4970  4A9F 67                  ld h,a
4971  4AA0 22 80 22     digh   ld (dispx),hl
4972  4AA3 7D                  ld a,l
4973  4AA4 E6 07               and 7
4974  4AA6 3E 03               ld a,3
4975  4AA8 20 01               jr nz,digh1
4976  4AAA 3D                  dec a
4977  4AAB 47           digh1  ld b,a
4978  4AAC CD 6F 2B            call tstbl
4979  4AAF C5           digh0  push bc
4980  4AB0 CD 70 23            call fdchk
4981  4AB3 11 20 00            ld de,32
4982  4AB6 19                  add hl,de
4983  4AB7 C1                  pop bc
4984  4AB8 10 F5               djnz digh0
4985  4ABA C9                  ret
4986  4ABB DD 6E 08     digl   ld l,(ix+8)
4987  4ABE DD 7E 09            ld a,(ix+9)
4988  4AC1 D6 02               sub 2
4989  4AC3 67                  ld h,a
4990  4AC4 18 DA               jr digh
4991  4AC6 DD 66 09     digd   ld h,(ix+9)
4992  4AC9 3E 10               ld a,16
4993  4ACB DD 86 08            add a,(ix+8)
4994  4ACE 6F                  ld l,a
4995  4ACF 18 09               jr digv
4996  4AD1 DD 7E 08     digu   ld a,(ix+8)
4997  4AD4 DD 66 09            ld h,(ix+9)
4998  4AD7 D6 02               sub 2
4999  4AD9 6F                  ld l,a
5000  4ADA 22 80 22     digv   ld (dispx),hl
5001  4ADD CD 6F 2B            call tstbl
5002  4AE0 CD 70 23            call fdchk
5003  4AE3 23                  inc hl
5004  4AE4 CD 70 23            call fdchk
5005  4AE7 3A 81 22            ld a,(dispy)
5006  4AEA E6 07               and 7
5007  4AEC C8                  ret z
5008  4AED 23                  inc hl
5009  4AEE C3 70 23            jp fdchk
5010  4AF1              	   include "plsnd.asm"
# file opened: plsnd.asm
   1+ 4AF1              plsnd	;ret
   2+ 4AF1 C3 98 21     		jp PLY_PlaySong
   3+ 4AF4              		;ret
   4+ 4AF4
# file closed: plsnd.asm
5011  4AF4 C3 A3 2F     ibloc  jp initsc
5012  4AF7 C9           rbloc  ret
5013  4AF8              eop    equ $
5014  4AF8
# file closed: gezzerCPC.asm
