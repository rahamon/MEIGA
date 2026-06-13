	; ===== Espera VBlank comienzo de frame (con ISR player)=====
waitIRQ	halt
		ld a,(TickFlag)
		or a
		jr z,waitIRQ
		xor a
		ld (TickFlag),a
		ret

TickFlag	defb 0
		
banka	;di
		ld (23388),a
		ld bc,32765
		out (c),a
		ld (ULABank),a		; set ULABank
		;ei
		ret

bankP	; flip ULA Buffers
		ld a,(ULABank)
		cp %00001111		; Shadow Buffer is on?...
		jr z,ConectA
BufferOn
		ld a,%00001111		; ...no, Set it On BufferB 0000 1111(Shadow-Bank7)
		call banka			; MUESTRA la pantalla de RAM 7
		ret
ConectA
		call VIDEOToRAM7	; COPIA en buffer
		ld a,%00001101
		call banka			; ULABank = BufferA (screen) 0000 1101(normal-bank5)
		ret

VIDEOToRAM7
		ld a,%00001111
		call banka
		di
		ld     hl, $4000			; desde 5
		ld     de, $c000			; hasta 7on
		ld     bc, 6912
		ldir
		ei
		ret
		
InitULABuffers:
        ld a,(23388)
        push af
			;call bankP
			;call VIDEOToRAM7
			;call VIDEOToRAM7DOS
			;call bank0
        pop af
		call banka
        ret
		
FlipBufferSafe
		;di
			call bankP
			call bank0
		;ei
        ret

ULABank	defb %00001111			; Ultuma ULAScreen, defecto 7 Shadow buffer
								;la ULA muestra la pantalla de RAM 7
								;el banco paginado en 0xC000 es también RAM 7

VIDEOToRAM7DOS
        ret
		

PrepareVideoWrite
FinishVideoWrite
FixHLBackBuffer
		ret
		
		