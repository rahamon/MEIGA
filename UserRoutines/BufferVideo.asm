; Rutinas de Volcado de pantalla

; flip ULA Buffers
; Implementar en 3 pasos 1:copyA, 2:CopyB, 3:CopyCandSwap <----!!
bankP:	ld a,(ULABank)		; get ULABank
		cp %00001111		; Shadow Buffer(7) is on?...
		jp z,SwapVid		; Swap to 5 and copy to
		ld a,%00001111		; ...no, Set it On(7)
banka
		ld (23388),a
		ld bc,32765
		out (c),a
		ld (ULABank),a
		ret
		
SwapVid
		ld a,%00000101		; Set it On(5)
		call banka
		call VIDEOToRAM7AB
		ret

GetHLVideo
		ld a,(ULABank)
		call banka
		;push de
		;ld de,$c000 - $4000
		;add hl,de
		;pop de
		ret

ULABank	defb %00001111				; Ultuma ULAScreen

VIDEOToRAM7:
		;ret
		ld a,%00001111		; (bank7)
		call banka
		; Copy
		ld     hl, $4000			; desde 5
		ld     de, $c000			; hasta 7on
		ld     bc, 6912
		di
		ldir
		ei
		ret

VIDEOToRAM7BC:
		; set to RAM 7
		ld     a,%00001111
		call   banka
		
		; pixels
		ld     hl, $4800			; desde 5
		ld     de, $c800			; hasta 7on
		ld     bc, 2048*2
		di
		ldir
		EI
		; atributos
		ld     hl, $5900		; desde 5
		ld     de, $d900			; hasta 7on
		ld     bc, 256*2
		DI
		ldir
		ei
		ret

VIDEOToRAM7AB:
		; set to RAM 7
		ld     a,%00001111
		call   banka

		; pixels
		ld     hl, $4000			; desde 5
		ld     de, $c000			; hasta 7on
		ld     bc, 2048*2
		di
		ldir
		EI
		; atributos
		ld     hl, $5800		; desde 5
		ld     de, $d800			; hasta 7on
		ld     bc, 256*2
		DI
		ldir
		ei
		ret		


VIDEOToRAM7A:

		ld     a,%00001111
		call   banka
		; pixels
		ld     hl, $4000			; desde 5
		ld     de, $c000			; hasta 7on
		ld     bc, 2048
		di
		ldir
		EI
		; atributos
		ld     hl, $5800		; desde 5
		ld     de, $d800			; hasta 7on
		ld     bc, 256
		DI
		ldir
		ei
		jp VIDEOToRAM7B
		ret		

VIDEOToRAM7B:
		; pixels
		ld     hl, $4800			; desde 5
		ld     de, $c800			; hasta 7on
		ld     bc, 2048
		di
		ldir
		ei
		; atributos
		ld     hl, $5900		; desde 5
		ld     de, $d900			; hasta 7on
		ld     bc, 256
		di
		ldir
		ei
		jp VIDEOToRAM7C
		ret

VIDEOToRAM7C:
		; pixels
		ld     hl, $5000			; desde 5
		ld     de, $d000			; hasta 7on
		ld     bc, 2048
		di
		ldir
		ei
		; atributos
		ld     hl, $5a00		; desde 5
		ld     de, $da00			; hasta 7on
		ld     bc, 256
		di
		ldir
		ei
		ret

VIDEOToRAM7DOS
; Copia rápida 0x4000 -> 0xC000 (6912 bytes) usando PUSH/POP+SP
; Respeta los registros y SP al terminar
		
		ld     a,%00001111
		call   banka

            di
; --- Salvar todos los registros ---
            push    af
            push    bc
            push    de
            push    hl
            push    ix
            push    iy

            exx
            push    bc
            push    de
            push    hl
            exx
            push    af

            ld      (save_sp),sp     ; guardar SP original

; --- Inicialización de punteros y contador ---
			DEFW $21DD	;ld ix,$4000	FUENTE
			DEFW $4000
			DEFW $21FD	;ld iy,$C000+8	DESTINO
			DEFW $C008

            exx
            ld      bc,864           ; 6912 / 8 = 864 iteraciones
            exx

scrloop:    ld      sp,ix            ; SP -> fuente
            pop     af               ; extrae 8 bytes
            pop     bc
            pop     de
            pop     hl

            ld      sp,iy            ; SP -> destino
            push    hl               ; vuelca los 8 bytes
            push    de
            push    bc
            push    af

            ld      de,8             ; avanza punteros
            add     ix,de
            add     iy,de

            exx
            dec     bc
            ld      a,b
            or      c
            exx
            jr      nz,scrloop

; --- Restaurar SP ---
            ld      sp,(save_sp)

; --- Restaurar registros ---
            pop     af
            exx
            pop     hl
            pop     de
            pop     bc
            exx
            pop     iy
            pop     ix
            pop     hl
            pop     de
            pop     bc
            pop     af

            ei
            ret

; --- Variables ---
save_sp:    dw     0

