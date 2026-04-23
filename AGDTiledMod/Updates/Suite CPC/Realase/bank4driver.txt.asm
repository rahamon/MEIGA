# file opened: bank4driver.asm
 1    0000
 2    0000              ; Bank numbers - platform specific
 3    0000              nBank0 equ $C0
 4    0000              nBank1 equ $C4
 5    0000              nBank2 equ $C5
 6    0000              nBank3 equ $C6
 7    0000              nBank4 equ $C7
 8    0000              nBank5 equ $CC
 9    0000              nBank6 equ $CD
10    0000              nBank7 equ $CE
11    0000              nBank8 equ $CF
12    0000
13    0000              			org $2000
14    2000
15    2000 C3 03 20     			jp InstallBank4
16    2003
17    2003              InstallBank4:
18    2003              			; ld a,16							; for Divmmc
19    2003              			; ld (23388),a
20    2003              			; push iy
21    2003              			;di
22    2003
23    2003              			; extract Arkplayer pack to 49152 en bank 4
24    2003 CD 13 20     			call bank5
25    2006 21 73 20     			ld hl,ayplaybin
26    2009 11 00 40     			ld de,$4000
27    200C CD 2A 20     			call zx7bin
28    200F CD 1E 20     			call bank0
29    2012
30    2012              exit:
31    2012              			; pop iy							; for Divmmc
32    2012              			;ei
33    2012
34    2012 C9           			ret
35    2013
36    2013              			;include "routines.asm"
37    2013
38    2013              bank5:	; swap to bank 5
39    2013              			;di
40    2013 3E C4        			ld a,nBank1
41    2015 01 7F 00     			ld bc,$7F
42    2018 32 29 20     			ld (BankCurrent),a
43    201B ED 79        			out (c),a
44    201D              			;ei
45    201D C9           			ret
46    201E              bank0:	; swap to bank 0 - memoria base
47    201E              			;DI
48    201E 3E C0        			ld a,nBank0
49    2020 01 7F 00     			ld bc,$7F
50    2023 32 29 20     			ld (BankCurrent),a
51    2026 ED 79        			out (c),a
52    2028              			;ei
53    2028 C9           			ret
54    2029              BankCurrent:
55    2029 C0           		defb $C0
56    202A
57    202A              zx7bin:
58    202A              			include	"zx7.asm"
# file opened: zx7.asm
 1+   202A              ; zx7 einar saukas
 2+   202A CD 2E 20     		call dzx7_turbo
 3+   202D
 4+   202D C9           		ret
 5+   202E
 6+   202E              dzx7_turbo:
 7+   202E 3E 80                ld      a, $80
 8+   2030              dzx7s_copy_byte_loop:
 9+   2030 ED A0                ldi                             		;' copy literal byte
10+   2032              dzx7s_main_loop:
11+   2032 CD 6D 20             call    dzx7s_next_bit
12+   2035 30 F9                jr      nc, dzx7s_copy_byte_loop 		;' next bit indicates either literal or sequence
13+   2037
14+   2037              ; determine number of bits used for length (Elias gamma coding)
15+   2037 D5                   push    de
16+   2038 01 00 00             ld      bc, 0
17+   203B 50                   ld      d, b
18+   203C              dzx7s_len_size_loop:
19+   203C 14                   inc     d
20+   203D CD 6D 20             call    dzx7s_next_bit
21+   2040 30 FA                jr      nc, dzx7s_len_size_loop
22+   2042
23+   2042              ; determine length
24+   2042              dzx7s_len_value_loop:
25+   2042 D4 6D 20             call    nc, dzx7s_next_bit
26+   2045 CB 11                rl      c
27+   2047 CB 10                rl      b
28+   2049 38 1F                jr      c, dzx7s_exit           ; check end marker
29+   204B 15                   dec     d
30+   204C 20 F4                jr      nz, dzx7s_len_value_loop
31+   204E 03                   inc     bc                      ; adjust length
32+   204F
33+   204F              ; determine offset
34+   204F 5E                   ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
35+   2050 23                   inc     hl
36+   2051 CB 33                defb    $cb, $33                ; opcode for undocumented instruction "SLL E" aka "SLS E"
37+   2053 30 0C                jr      nc, dzx7s_offset_end    ; if offset flag is set, load 4 extra bits
38+   2055 16 10                ld      d, $10                  ; bit marker to load 4 bits
39+   2057              dzx7s_rld_next_bit:
40+   2057 CD 6D 20             call    dzx7s_next_bit
41+   205A CB 12                rl      d                       ; insert next bit into D
42+   205C 30 F9                jr      nc, dzx7s_rld_next_bit  ; repeat 4 times, until bit marker is out
43+   205E 14                   inc     d                       ; add 128 to DE
44+   205F CB 3A                srl	d							; retrieve fourth bit from D
45+   2061              dzx7s_offset_end:
46+   2061 CB 1B                rr      e                       ; insert fourth bit into E
47+   2063
48+   2063              ; copy previous sequence
49+   2063 E3                   ex      (sp), hl                ; store source, restore destination
50+   2064 E5                   push    hl                      ; store destination
51+   2065 ED 52                sbc     hl, de                  ; HL = destination - offset - 1
52+   2067 D1                   pop     de                      ; DE = destination
53+   2068 ED B0                ldir
54+   206A              dzx7s_exit:
55+   206A E1                   pop     hl                      ; restore source address (compressed data)
56+   206B 30 C5                jr      nc, dzx7s_main_loop
57+   206D              dzx7s_next_bit:
58+   206D 87                   add     a, a                    ; check next bit
59+   206E C0                   ret     nz                      ; no more bits left?
60+   206F 7E                   ld      a, (hl)                 ; load another group of 8 bits
61+   2070 23                   inc     hl
62+   2071 17                   rla
63+   2072 C9                   ret
64+   2073
# file closed: zx7.asm
59    2073
60    2073              ayplaybin: 	; ARK Block playroutine
61    2073              			incbin "PLAY4BANK.bin.zx7"
62    3909
# file closed: bank4driver.asm
