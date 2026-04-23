
; Bank numbers - platform specific
nBank0 equ $C0
nBank1 equ $C4
nBank2 equ $C5
nBank3 equ $C6
nBank4 equ $C7
nBank5 equ $CC
nBank6 equ $CD
nBank7 equ $CE
nBank8 equ $CF

			org $2000
			
			jp InstallBank4 

InstallBank4:
			; ld a,16							; for Divmmc
			; ld (23388),a 
			; push iy
			;di
			
			; extract Arkplayer pack to 49152 en bank 4
			call bank5
			ld hl,ayplaybin
			ld de,$4000
			call zx7bin
			call bank0			
			
exit:
			; pop iy							; for Divmmc
			;ei
			
			ret
			
			;include "routines.asm"

bank5:	; swap to bank 5
			;di
			ld a,nBank1
			ld bc,$7F
			ld (BankCurrent),a
			out (c),a
			;ei
			ret
bank0:	; swap to bank 0 - memoria base
			;DI
			ld a,nBank0
			ld bc,$7F
			ld (BankCurrent),a
			out (c),a
			;ei
			ret
BankCurrent:
		defb $C0
		
zx7bin:			
			include	"zx7.asm"
			
ayplaybin: 	; ARK Block playroutine
			incbin "PLAY4BANK.bin.zx7"

