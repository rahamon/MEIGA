
	; Dirección de la tabla interna de la paleta del firmware
Firmwaere_palette_buffer: equ $
		defs 16,0
		
; Actualiza Firmwaere_palette_buffer con los valores convertidos.
ConvertPalette:
		call bank4
		ld hl,(Palettepoiter)	  		; Apuntar a la tabla de hardware
        ld de,Firmwaere_palette_buffer	; Apuntar al buffer de la paleta firmware.
;PalCPC4 ld hl,LastPaltab
        ld bc,16						; Contador para 16 colores.

UpdateLoop:
        ld a,(hl)                     ; Cargar valor de hardware.
		push hl
		push bc
        call ConvertHardwareToFirmware ; Convertir a valor de firmware.
		pop bc
		pop hl
        ld (de),a                     ; Guardar valor de firmware en el buffer.
        inc hl                         ; Avanzar al siguiente valor de hardware.
        inc de                         ; Avanzar al siguiente lugar en el buffer.
        dec bc                         ; Disminuir el contador.
        ld a,b                        ; Si b = 0 y c = 0, terminamos.
        or c
        jr nz,UpdateLoop              ; Si no, repetir.
		
UpdatePalette:
	; Colocar un buffer de memoria para la paleta de la ultima screen
	; Guarda la paleta de colores en LastPaltab
		;call ShowPalette
		DI
		ld hl,Firmwaere_palette_buffer
		ld de,(Palettepoiter)
		ld bc,16
		ldir
		call bank0

		ret                            ; Fin del programa.

; Subrutina para convertir valores de hardware a firmware.
ConvertHardwareToFirmware:
        ld hl,HW_TO_FW_TABLE          ; Apuntar a la tabla de conversión.
        ld b,0                        ; Inicializar el índice de la tabla.

ConvLoop:
        ld c,(hl)                     ; Cargar un valor de la tabla.
        cp c                           ; Comparar con el valor de hardware en A.
        jr z,ConvDone                 ; Si es igual, saltar al final.
        inc hl                         ; Avanzar al siguiente valor.
        inc b                          ; Incrementar el índice.
		push af
        ld a, 27                       ; Cargar 27 en el registro a (límite de la tabla).
        cp b  
		pop af
        jr nz,ConvLoop                ; Si no, repetir hasta encontrar el valor.

ConvDone:
        ld a, b                        ; El valor de firmware está en b (índice encontrado).
        ret                            ; Retornar el valor convertido.
		
		; ES necesario inking TAMBIEN/SOLO/NO EN BASIC si carga desde basic
ShowPalette:
setpal	ld a,16             ; colours to set.
		ld hl,LastPaltab+15	; palette.
setpa0	ld c,(hl)           ; get colour.
		dec hl              ; next in list.
		ld b,c              ; make sure it's in b and c.
		dec a
		push af             ; store pen number.
		push hl             ; store palette pointer.
		call 48178          ; set palette colour.
		pop hl              ; restore palette pointer.
		pop af              ; restore pen.
		jr nz,setpa0        ; repeat until all colours are set.
		ret
		
; Tengo una Tabla de conversión de hardware a firmware ordenada, de manera que el firmware 1 es $54, el 2 es $44
; de esta manera el orden de la tabla me resulta el valor firmware correspondiente al hardware.
HW_TO_FW_TABLE:
        DB $54, $44, $55, $5C, $58, $5D, $4C, $45
        DB $4D, $56, $46, $57, $5E, $40, $5F, $4E
        DB $47, $4F, $52, $42, $53, $5A, $59, $5B
        DB $4A, $43, $4B
