
; Installer BankS
; Cargador en banco 6 adaptado para secreens

			org $2000

;Bank numbers - platform specific
nBank0 equ $C0
nBank1 equ $C4
nBank2 equ $C5
nBank3 equ $C6
nBank4 equ $C7
nBank5 equ $CC
nBank6 equ $CD
nBank7 equ $CE
nBank8 equ $CF

ScrBuffer	equ 16384
TempBuffer	equ $8000
Databank	equ nBank4

			jp InstallBankS
InstallBankS:
			ld hl,(57)          ; fetch interrupt address.
			ld (firmad),hl      ; store firmware address.
LoadPackedData
			; Carga datos
				include "LoadDataScreens.asm"
Drawdirect
			; muestra la primera como pantalla de carga directamente
			; Generar dinamicamente
				include "PackedUno.asm"
			
exit:
			ld hl,(firmad)      ; firmware interrupt address.
			ld (57),hl          ; restore interrupts.
			ret
			
firmad	defw 0

SaveToTemp:
		; Traslada imagen a memoria temporal en TempBuffer, desde hl. Coloca en nuevo puntero en TempBuffer
			push de				; guardar destino
			push bc				; guardar longitud
			ld de,TempBuffer
			di					; everyone wait a minute!
			ldir				; copy data
			pop bc				; restore longitud			
			pop de				; restore destino
			ld hl,TempBuffer	; Apunta ahora a TempBuffer
			ei					; you can continue with your things
			ret					; thank you
			
			; rutinas de color
				include "UpdateFirmware.asm"
				
			; rutinas para mover memoria entre bloques del modelo 128k
			; rutinas para cambiar de páginado de bloques
				include	"routines.asm"
DATAPackedScreens
			; Seccion de datos
				include "screens.asm"










