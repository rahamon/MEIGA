# file opened: zx0.asm
  1   0000              ; Généré par ConvImgCpcV 1.0.8987.20325 - 09/08/2024 - le 13/09/2024 (10 22 43)
  2   0000              ; Mode écran - Mode 0
  3   0000              ; Taille (nbColsxNbLignes) 80x200
  4   0000
  5   0000              TestJoda_pluscode
  6   0000
  7   0000 18 06        	jr _StartDepack
  8   0002
zx0.asm(9): error: Label not found: UnpackedBuffer8000
  9   0002              BuffTmp				equ UnpackedBuffer8000
 10   0002 00 00        Palettepoiter		defw 0		; org+3
 11   0004 00 00        PackedImgpointer	defw 0		; org+6
 12   0006 00 00        LogImgData			defw 0
 13   0008
 14   0008
 15   0008              _StartDepack:
 16   0008
 17   0008 2A 04 00     	LD	HL,(PackedImgpointer)
 18   000B 11 00 00     	LD	DE,BuffTmp
 19   000E CD 69 00     	CALL	Depack
 20   0011
 21   0011 C3 68 00     	jp skipTest
 22   0014
 23   0014              TstSpace1:
 24   0014 01 0E F4     	LD	BC,#F40E
 25   0017 ED 49        	OUT	(C),C
 26   0019 01 C0 F6     	LD	BC,#F6C0
 27   001C ED 49        	OUT	(C),C
 28   001E AF           	XOR	A
 29   001F ED 79        	OUT	(C),A
 30   0021 01 92 F7     	LD	BC,#F792
 31   0024 ED 49        	OUT	(C),C
 32   0026 01 45 F6     	LD	BC,#F645
 33   0029 ED 49        	OUT	(C),C
 34   002B 06 F4        	LD	B,#F4
 35   002D ED 78        	IN	A,(C)
 36   002F 01 82 F7     	LD	BC,#F782
 37   0032 ED 49        	OUT	(C),C
 38   0034 01 00 F6     	LD	BC,#F600
 39   0037 ED 49        	OUT	(C),C
 40   0039 3C           	INC	A
 41   003A 28 D8        	JR	Z,TstSpace1
 42   003C
 43   003C              TstSpace2:
 44   003C AF           	XOR     A
 45   003D 01 0E F4     	LD      BC,#F40E                ; Registre 14 du PSG
 46   0040 ED 49        	OUT     (C),C
 47   0042 01 C0 F6     	LD      BC,#F6C0                ; Ecriture numéro registre
 48   0045 ED 49        	OUT     (C),C
 49   0047 ED 79        	OUT     (C),A
 50   0049 01 92 F7     	LD      BC,#F792                ; Port A PPI en lecture
 51   004C ED 49        	OUT     (C),C
 52   004E 01 45 F6     	LD      BC,#F645                ; ligne = 5 (pour touche espace)
 53   0051 ED 49        	OUT     (C),C
 54   0053 06 F4        	LD      B,#F4                   ; Lecture registre
 55   0055 ED 78        	IN      A,(C)
 56   0057 01 82 F7     	LD      BC,#F782                ; Repasse port A PPI en écriture
 57   005A ED 49        	OUT     (C),C
 58   005C 17           	RLA                             ; Bit 7 dans Flag C
 59   005D C9           	RET
 60   005E
 61   005E              	;jr skipTest
 62   005E
 63   005E 01 0C BC     	LD	BC,#BC0C
 64   0061 3E 30        	LD	A,#30
 65   0063 ED 49        	OUT	(C),C
 66   0065 04           	INC	B
 67   0066 ED 79        	OUT	(C),A
 68   0068
 69   0068              skipTest:
 70   0068              	;EI
 71   0068 C9           	RET
 72   0069
 73   0069              ; Decompactage
 74   0069              Depack:
 75   0069 01 FF FF     	ld	bc,#ffff			; preserve default offset 1
 76   006C C5           	push	bc
 77   006D 03           	inc	bc
 78   006E 3E 80        	ld	a,#80
 79   0070              dzx0s_literals:
 80   0070 CD A0 00     	call	dzx0s_elias		; obtain length
 81   0073 ED B0        	ldir					; copy literals
 82   0075 87           	add	a,a					; copy from last offset or new offset?
 83   0076 38 0D        	jr	c,dzx0s_new_offset
 84   0078 CD A0 00     	call	dzx0s_elias		; obtain length
 85   007B              dzx0s_copy:
 86   007B E3           	ex	(sp),hl				; preserve source,restore offset
 87   007C E5           	push	hl				; preserve offset
 88   007D 19           	add	hl,de				; calculate destination - offset
 89   007E ED B0        	ldir					; copy from offset
 90   0080 E1           	pop	hl					; restore offset
 91   0081 E3           	ex	(sp),hl				; preserve offset,restore source
 92   0082 87           	add	a,a					; copy from literals or new offset?
 93   0083 30 EB        	jr	nc,dzx0s_literals
 94   0085              dzx0s_new_offset:
 95   0085 CD A0 00     	call	dzx0s_elias		; obtain offset MSB
 96   0088 47           	ld b,a
 97   0089 F1           	pop	af					; discard last offset
 98   008A AF           	xor	a					; adjust for negative offset
 99   008B 91           	sub	c
100   008C C8           	RET	Z		; Plus d'octets à traiter = fini
101   008D
102   008D 4F           	ld	c,a
103   008E 78           	ld	a,b
104   008F 41           	ld	b,c
105   0090 4E           	ld	c,(hl)				; obtain offset LSB
106   0091 23           	inc	hl
107   0092 CB 18        	rr	b					; last offset bit becomes first length bit
108   0094 CB 19        	rr	c
109   0096 C5           	push	bc				; preserve new offset
110   0097 01 01 00     	ld	bc,1				; obtain length
111   009A D4 A8 00     	call	nc,dzx0s_elias_backtrack
112   009D 03           	inc	bc
113   009E 18 DB        	jr	dzx0s_copy
114   00A0              dzx0s_elias:
115   00A0 0C           	inc	c					; interlaced Elias gamma coding
116   00A1              dzx0s_elias_loop:
117   00A1 87           	add	a,a
118   00A2 20 03        	jr	nz,dzx0s_elias_skip
119   00A4 7E           	ld	a,(hl)				; load another group of 8 bits
120   00A5 23           	inc	hl
121   00A6 17           	rla
122   00A7              dzx0s_elias_skip:
123   00A7 D8           	ret 	c
124   00A8              dzx0s_elias_backtrack:
125   00A8 87           	add	a,a
126   00A9 CB 11        	rl	c
127   00AB CB 10        	rl	b
128   00AD 18 F2        	jr	dzx0s_elias_loop
129   00AF
130   00AF
# file closed: zx0.asm
