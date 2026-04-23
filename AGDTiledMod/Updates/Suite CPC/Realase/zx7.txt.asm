# file opened: zx7.asm
 1    0000              ; zx7 einar saukas
 2    0000              zx7bin:
 3    0000
 4    0000 CD 04 00     		call dzx7_turbo
 5    0003
 6    0003 C9           		ret
 7    0004
 8    0004              dzx7_turbo:
 9    0004 3E 80                ld      a, $80
10    0006              dzx7s_copy_byte_loop:
11    0006 ED A0                ldi                             		;' copy literal byte
12    0008              dzx7s_main_loop:
13    0008 CD 43 00             call    dzx7s_next_bit
14    000B 30 F9                jr      nc, dzx7s_copy_byte_loop 		;' next bit indicates either literal or sequence
15    000D
16    000D              ; determine number of bits used for length (Elias gamma coding)
17    000D D5                   push    de
18    000E 01 00 00             ld      bc, 0
19    0011 50                   ld      d, b
20    0012              dzx7s_len_size_loop:
21    0012 14                   inc     d
22    0013 CD 43 00             call    dzx7s_next_bit
23    0016 30 FA                jr      nc, dzx7s_len_size_loop
24    0018
25    0018              ; determine length
26    0018              dzx7s_len_value_loop:
27    0018 D4 43 00             call    nc, dzx7s_next_bit
28    001B CB 11                rl      c
29    001D CB 10                rl      b
30    001F 38 1F                jr      c, dzx7s_exit           ; check end marker
31    0021 15                   dec     d
32    0022 20 F4                jr      nz, dzx7s_len_value_loop
33    0024 03                   inc     bc                      ; adjust length
34    0025
35    0025              ; determine offset
36    0025 5E                   ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
37    0026 23                   inc     hl
38    0027 CB 33                defb    $cb, $33                ; opcode for undocumented instruction "SLL E" aka "SLS E"
39    0029 30 0C                jr      nc, dzx7s_offset_end    ; if offset flag is set, load 4 extra bits
40    002B 16 10                ld      d, $10                  ; bit marker to load 4 bits
41    002D              dzx7s_rld_next_bit:
42    002D CD 43 00             call    dzx7s_next_bit
43    0030 CB 12                rl      d                       ; insert next bit into D
44    0032 30 F9                jr      nc, dzx7s_rld_next_bit  ; repeat 4 times, until bit marker is out
45    0034 14                   inc     d                       ; add 128 to DE
46    0035 CB 3A                srl	d							; retrieve fourth bit from D
47    0037              dzx7s_offset_end:
48    0037 CB 1B                rr      e                       ; insert fourth bit into E
49    0039
50    0039              ; copy previous sequence
51    0039 E3                   ex      (sp), hl                ; store source, restore destination
52    003A E5                   push    hl                      ; store destination
53    003B ED 52                sbc     hl, de                  ; HL = destination - offset - 1
54    003D D1                   pop     de                      ; DE = destination
55    003E ED B0                ldir
56    0040              dzx7s_exit:
57    0040 E1                   pop     hl                      ; restore source address (compressed data)
58    0041 30 C5                jr      nc, dzx7s_main_loop
59    0043              dzx7s_next_bit:
60    0043 87                   add     a, a                    ; check next bit
61    0044 C0                   ret     nz                      ; no more bits left?
62    0045 7E                   ld      a, (hl)                 ; load another group of 8 bits
63    0046 23                   inc     hl
64    0047 17                   rla
65    0048 C9                   ret
66    0049
# file closed: zx7.asm
