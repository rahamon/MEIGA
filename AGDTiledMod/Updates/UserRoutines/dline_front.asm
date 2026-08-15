; Mod IN-FRONT WATER BLOCK
;---------------------------------------------------------------------------
; PRINT_Sprite
;---------------------------------------------------------------------------
PrepareWaterMap_Old
        ld l,(ix+3)
        ld h,(ix+4)
        jp PrepareWaterMap

PrepareWaterMap_New
        ld l,(ix+8)
        ld h,(ix+9)
        jp PrepareWaterMap

sspria
        call PrepareWaterMap_Old
        call PrepareWaterSkips_LineaAlta_Sprites
        call gsprad
        jp prisp00

ssprib
        call PrepareWaterMap_New
        call PrepareWaterSkips_LineaAlta_Sprites
        call gspran
        jp prisp00

sspric
        call sspria
        call ssprib
        ret
		
prisp00	;push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines contador.
prispr0	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
dlbptr	defw dline
		ex af,af'           ; 'restore line counter.
		dec a
		push af
		;push hl
		;ld hl,WaterSwitchLine
		;cp (hl)
        cp 7
		call z,PrepareWaterSkips_LineaBaja_Sprites
		;pop hl
		pop af
		;or a
		jp nz,prispr0
		call PrepareWaterSkips_Reset
		;pop ix               ; restaurar IX original
		ret
		
dline
print_Primer_byte
skpr1	defb $18
		defb $02 			;jr $+4
		jr skipbit1
	   ld a,(de)           ; graphic data.
       and c               ; mask away what's not needed.
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.
       inc l               ; next screen address.
       inc l               ; next screen address.
		jr print_Segundo_byte
skipbit1
	   inc l               ; pasa a siguiente byte de pantalla
	   inc l               ; next screen address.
print_Segundo_byte
skpr2	defb $18
		defb $02 			;jr $+4
		jr skipbit2
       ld a,(de)           ; fetch data.
       and b               ; mask away unwanted bits.
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.	   
       inc de              ; next graphic.
       dec l               ; one character cell to the left.
		jr print_Tercer_byte
skipbit2	   
       inc de              ; next graphic.
       dec l               ; one character cell to the left.
print_Tercer_byte
skpr3	defb $18
		defb $02 			;jr $+4
		jr skipbit3	   
       ld a,(de)           ; second bit of data.
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.
       inc de              ; point to next line of data.
       dec l               ; another char left.
		jr Avanzar_IX
skipbit3
       inc de              ; point to next line of data.
       dec l               ; another char left.
Avanzar_IX
	   
; Line drawn, now work out next target address.

nline  inc h               ; increment pixel.
       ld a,h              ; get pixel address.
       and 7               ; straddling character position?
       ret nz              ; no, we're on next line already.
       ld a,h              ; get pixel address.
       sub 8               ; subtract 8 for start of segment.
       ld h,a              ; new high byte of address.
       ld a,l              ; get low byte of address.
       add a,32            ; one line down.
       ld l,a              ; new low byte.
       ret nc              ; not reached next segment yet.
       ld a,h              ; address high.
       add a,8             ; add 8 to next segment.
       ld h,a              ; new high byte.
       cp 88               ; reached end of screen?
       ret c               ; not yet.
       ld h,56             ; back to ROM.
       ret

			include "PreparaWater.asm"
			
	