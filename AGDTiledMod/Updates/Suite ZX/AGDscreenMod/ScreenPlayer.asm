;
; Rutina User para presentar Splash screen divided by 3 pieces
; Bank Locations: $c000 First Screen, $c000+8000 Second Screen
;

Screenbank equ 6

UserScreen
		ld a,(vara)
		call SLoader
		ret

SLoader
		include "ScreenSelector.asm"

		; cp 211
		; jp z,SwapSeccion211
		cp 212		; SAMPLE: A ZONE IN THE MIDLE OF TV, mira tabla adjunta VIDEO DATA
					; 212 (significado claves:2=screen2(bank6),1=zonaA(bank6),2=zonaB(TV))
		jp z,SwapSeccion212
		; cp 213
		; jp z,SwapSeccion213
		; cp 221
		; jp z,SwapSeccion221
		cp 222
		jp z,SwapSeccion222
		; cp 223
		; jp z,SwapSeccion223
		; cp 231
		; jp z,SwapSeccion231
		; cp 232
		; jp z,SwapSeccion232
		; cp 233
		; jp z,SwapSeccion233
		ret

		include "swappingS.asm"
		
; no funciona
SwapSeccion212
		; llena bits de la seccion B de pantalla TV
		ld hl,$c000 + 8000 ; pixel desde la seccion A origen pantalla secundaria
		ld de,$4800 ; hasta la seccion B de la pantalla TV
		ld bc,2048 ; todos estos bites
		ld a,Screenbank		; Banco Origen
		
		call showSplashparam
		
		; llena atributos de la seccion B de pantalla TV
		ld hl,$d800 + 8000 ; atributos desde la seccion A origen pantalla secundaria
		ld de,$5900 ; hasta la seccion B de la pantalla TV
		ld bc,256 ; todos estos bites
		ld a,Screenbank		; Banco Origen
		
		call showSplashparam
		
		ret

SwapSeccion222
		; llena bits de la seccion B de pantalla TV
		ld hl,$c800 + 8000 ; pixel desde la seccion B origen pantalla secundaria
		ld de,$4800 ; hasta la seccion B de la pantalla TV
		ld bc,2048 ; todos estos bites
		ld a,Screenbank		; Banco Origen
		
		call showSplashparam
		
		; llena atributos de la seccion B de pantalla TV
		ld hl,$d900 + 8000 ; atributos desde la seccion B origen pantalla secundaria
		ld de,$5900 ; hasta la seccion B de la pantalla TV
		ld bc,256 ; todos estos bites
		ld a,Screenbank		; Banco Origen
		
		call showSplashparam
		
		ret
