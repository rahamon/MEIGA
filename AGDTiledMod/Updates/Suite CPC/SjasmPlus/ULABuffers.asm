; Estoy en este momento funcionando con AGD.
; No hay colisión entre memoria base y bancos.

; 	Estoy acercándome; pero no tengo el flujo de
; programa de flipULABuffers claro.




; En AGD.asm

; Prepara room, sprites, objetos, etc
		call ConectA			; empieza en Buffer5
		call VIDEOToRAM7		; ldir destino RAM7
mloop
	    call vsync          ; synchronise with display.
; scrolling
		ld a,32
		call user
; Impresion desprites 1
	    ld ix,sprtab        ; address of sprite table, even sprites.
        call dspr           ; display even sprites.
	    call proshr			; extra
        ;call plsnd          ; play sounds.
	   
; Impresion desprites 2	   
        ld ix,sprtab+TABSIZ ; address of first odd sprite.
        call dspr           ; display odd sprites.

        call vsync          ; synchronise with display.
; Conmuta Screen Buffer
		call bankP			; Conmuta. Además hace ldir destino RAM7 si estamos en 5
		call bank0
		
;			.
;			.
;			.
;			jp mloop


; En Routines.asm	(en la dirección $6148 de memoria base)
; subroutines 

bank0:	; swap to bank 0 - original @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or 0 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret

bank4:	; swap to bank 4 @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or 4 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret 

bankb:	; swap to bank asigned in b @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or b 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret

bankP:	; flip ULA Buffers
		; di
		ld a,(ULABank)		; get ULABank
		cp %00001111		; Shadow Buffer is on?...
		jr z,ConectA
BufferOn
		ld a,%00001111		; ...no, Set it On
banka		
		ld (23388),a		; necesario para trabajar con interrupciones
		ld bc,32765
		out (c),a
		ld (ULABank),a
		;ei
		ret
ConectA
		ld a,%00000101		; Buffer A (bank5)
		call banka
		call VIDEOToRAM7
		ret

ULABank	defb %00001111				; Ultuma ULAScreen

VIDEOToRAM7:
		ld     a,%00001111
		call   banka
		;jp VIDEOToRAM7DOS
		;
		di
		ld     hl, $4000			; desde 5
		ld     de, $c000			; hasta 7on
		ld     bc, 6912
		ldir
		ei
		ret

VIDEOToRAM7DOS
		; aquí algo más rápido TODO
		ret
		