
VIDEOToRAM7AB:

		; pixels
		di
		ld     hl, $4000			; desde 5
		ld     de, $c000			; hasta 7on
		ld     bc, 2048*2
		ldir
		; atributos
		ld     hl, $5800		; desde 5
		ld     de, $d800			; hasta 7on
		ld     bc, 256*2
		ldir
		ei
		ret		

VIDEOToRAM7B:
		ret
		; pixels
		di
		ld     hl, $4800			; desde 5
		ld     de, $c800			; hasta 7on
		ld     bc, 2048
		ldir
		; atributos
		ld     hl, $5900		; desde 5
		ld     de, $d900			; hasta 7on
		ld     bc, 256
		ldir
		ei
		jp VIDEOToRAM7C
		ret

VIDEOToRAM7BC:
		
		; pixels
		di
		ld     hl, $4800			; desde 5
		ld     de, $c800			; hasta 7on
		ld     bc, 2048*2
		ldir
		; atributos
		ld     hl, $5900		; desde 5
		ld     de, $d900			; hasta 7on
		ld     bc, 256*2
		ldir
		ei
		ret

VIDEOToRAM7C:
		ret
		; pixels
		di
		ld     hl, $5000			; desde 5
		ld     de, $d000			; hasta 7on
		ld     bc, 2048
		ldir
		; atributos
		ld     hl, $5a00		; desde 5
		ld     de, $da00			; hasta 7on
		ld     bc, 256
		ldir
		ei
		ret
		
VIDEOToRAM7DOS
; Copia rápida 0x4000 -> 0xC000 (6912 bytes) usando PUSH/POP+SP
; Respeta los registros y SP al terminar
		
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

scrloop:      ld      sp,ix            ; SP -> fuente
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
