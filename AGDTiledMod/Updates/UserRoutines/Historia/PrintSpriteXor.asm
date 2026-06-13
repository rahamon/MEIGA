; inicia imagen pantalla	   
       ld ix,sprtab        ; address of sprite table, even sprites.
       call dspr           ; display sprites.
       ld ix,sprtab+TABSIZ ; address of first odd sprite.
       call dspr           ; display sprites.
rstrt1 ;jp bsortx			; skip screen layout.			*** controll FROM scripts rstrt1

	IF ULABUFFER = 1
		call ConectA		;echo
		call VIDEOToRAM7	;echo
	ENDIF

mloop
	   call vsync          ; synchronise with display.

; Impresion desprites 1
	   ld ix,sprtab        ; address of sprite table, even sprites.
       call dspr           ; display even sprites.
	   
	IF SCROLL = 1
		call proshr			; echo, sustituye a call vsync
	   ;call vsync
	ELSE
       ;call plsnd           play sounds.
	   call vsync
	ENDIF
	   
; Impresion desprites 2	   
       ld ix,sprtab+TABSIZ ; address of first odd sprite.
       call dspr           ; display odd sprites.
	   
	   IF INFRONT = 1
; In Front Plugin, Puede ir aquí o justo despues de dspr7
	   call drawb		   ; tiles in front ON
	   ENDIF

; Conmuta Screen Buffer
	IF ULABUFFER = 1
		call bankP			;echo
		call bank0			;echo
	ENDIF
		
	   ld ix,ssprit        ; point to spare sprite for spawning purposes.
evlp1  call evnt10         ; called once per main loop.

	IF SCROLL = 1
; scrolling
		call resetecho		;echo scrolling
		call Play_one_step
	ENDIF

       call pspr           ; procesa sprites.
	   
; Main loop events.
		
       ld ix,ssprit        ; point to spare sprite for spawning purposes.
evlp2  call evnt11         ; called once per main loop.
		 
		;include "cassettePlay.asm"
			
bsortx call bsort          ; sort sprites.
       ld a,(nexlev)       ; finished level flag.
       and a               ; has it been set?
       jp nz,newlev        ; yes, go to next level.
       ld a,(gamwon)       ; finished game flag.
       and a               ; has it been set?
       jp nz,evwon         ; yes, finish the game.
       ld a,(restfl)       ; finished level flag.
       dec a               ; has it been set?
       jp z,rstrt          ; yes, go to next level.
       dec a               ; has it been set?
       jp z,rstrtn         ; yes, go to next level.
       ld a,(deadf)        ; dead flag.
       and a               ; is it non-zero?
       jr nz,pdead         ; yes, player dead.
       ld hl,frmno         ; game frame.
       inc (hl)            ; advance the frame.

; Back to start of main loop.

       jp mloop            ; debug or back to mloop.
	   
; Display sprites.

;Idea general: El sistema compara el sprite anterior (ix+0) con el nuevo (ix+5). Si el anterior está activo, se borra. Si el nuevo está activo, se dibuja.

dspr   ld b,NUMSPR/2       ; número de sprites (dos entradas por sprite)
dspr0  push bc             ; guarda el contador de bucle

		IF SCROLL = 1
			ld a,(echo)		;echo
			and a			;echo
			jp nz,dspr5		;echo, si
		ENDIF

       ld a,(ix+0)         ; lee el tipo del sprite anterior
       inc a               ; ¿estaba activo?
       jr nz,dspr1         ; sí: hay que borrarlo con XOR
;Si no hay sprite anterior, pero sí uno nuevo, lo dibuja directamente (sin borrar).
dspr5  ld a,(ix+5)         ; lee el tipo del nuevo sprite
       inc a               ; ¿está activo?
       jr nz,dspr3         ; sí: hay que dibujarlo
;Actualiza el estado del sprite viejo: copia las propiedades nuevas a las viejas (posiciones, tipo, etc.)
dspr2  push ix             ; guarda IX
       pop hl              ; copia IX a HL
       ld e,l              ; copy to de.
       ld d,h
       ld bc,5             ; offset entre campos viejos y nuevos
       add hl,bc           ; HL apunta al campo de nuevo sprite
       ldi                 ; copia los 5 bytes de posición nueva → antigua
       ldi
       ldi
       ldi
       ldi

       ld c,TABSIZ*2       ; salto a la siguiente entrada de sprite
       add ix,bc           ; next sprite.
       pop bc              ; retrieve loop counter.
       djnz dspr0          ; repeat for remaining sprites.
       ret
	   
;Si hay sprite anterior y nuevo:
;Hay que borrar el sprite viejo (con XOR) y luego pintar el nuevo.
dspr1  ld a,(ix+5)         ; type of new sprite.
       inc a               ; is this enabled?
       jr nz,dspr4         ; yes, display both.
	   
dspr6  call sspria         ; solo había sprite anterior: bórralo
	   jp dspr2

; Displaying two sprites.  Don't bother redrawing if nothing has changed.

dspr4
;Compara la posición vertical anterior con la nueva. Si no coinciden redibujar.
	   ld a,(ix+4)         ; old y.
       cp (ix+9)           ; compare with new value.
       jr nz,dspr7         ; they differ, need to redraw.
;Lo mismo con la coordenada X.
       ld a,(ix+3)         ; old x.
       cp (ix+8)           ; compare against new value.
       jr nz,dspr7         ; they differ, need to redraw.
;Aquí compara el número de frame (para animaciones).
       ld a,(ix+2)         ; old frame.
       cp (ix+7)           ; compare against new value.
       jr nz,dspr7         ; they differ, need to redraw.
;Y por último, la imagen base. Si todo coincide, no hace falta redibujar nada.
       ld a,(ix+1)         ; old image.
       cp (ix+6)           ; compare against new value.
       jp z,dspr2          ; everything is the same, don't redraw.
	   
;Si algo cambió, pasa a dspr7
;Este es el punto de interés principal si queremos transformar la rutina para usar fondo y máscara.
;sspric es la rutina actual que: Borra el sprite anterior (probablemente con XOR) y Dibuja el nuevo sprite actualizado.
dspr7  call sspric         ; borra sprite anterior y dibuja nuevo al mismo tiempo
       jp dspr2			   ; copia datos nuevos sobre antiguos
;Si solo hay que dibujar, no borrar (caso de dspr3)
dspr3  call ssprib         ; dibuja nuevo sprite (no había anterior)
       jp dspr2

;| Situación                                | Acción                     | Rutina   |
;| ---------------------------------------- | -------------------------- | -------- |
;| No hay cambio entre estado viejo y nuevo | Nada                       | dspr2    |
;| Hay cambio (coordenadas, imagen, frame)  | Borrar viejo, pintar nuevo | sspric   |
;| Solo hay sprite nuevo (no anterior)      | Pintar nuevo               | ssprib   |
;| Solo hay sprite viejo (no nuevo)         | Borrar sprite              | sspria   |



; Get sprite address calculations.
; gspran = new sprite, gsprad = old sprite.

gspran ld l,(ix+8)         ; new x coordinate.
       ld h,(ix+9)         ; new y coordinate.
       ld (dispx),hl       ; set display coordinates.
       ld a,(ix+6)         ; new sprite image.
       call gfrm           ; fetch start frame for this sprite.
       ld a,(hl)           ; frame in accumulator.
       add a,(ix+7)        ; new add frame number.
       jp gspra0

gsprad ld l,(ix+3)         ; x coordinate.
       ld h,(ix+4)         ; y coordinate.
       ld (dispx),hl       ; set display coordinates.
       ld a,(ix+1)         ; sprite image.
       call gfrm           ; fetch start frame for this sprite.
       ld a,(hl)           ; frame in accumulator.
       add a,(ix+2)        ; add frame number.

gspra0 rrca                ; multiply by 128.
       ld d,a              ; store in d.
       and 128             ; low byte bit.
       ld e,a              ; got low byte.
       ld a,d              ; restore result.
       and 127             ; high byte bits.
       ld d,a              ; displacement high byte.
       ld hl,sprgfx        ; address of play sprites.
       add hl,de           ; point to frame.

       ld a,(dispy)        ; y coordinate.
       and 6               ; position within byte boundary.
       ld c,a              ; low byte of table displacement.
       rlca                ; multiply by 32.
       rlca                ; already a multiple
       rlca                ; of 2, so just 4
       rlca                ; shifts needed.
       ld e,a              ; put displacement in low byte of de.
       ld d,0              ; zero the high byte.
       ld b,d              ; no high byte for mask displacement either.
       add hl,de           ; add to sprite address.
       ex de,hl            ; need it in de for now.
       ld hl,spmask        ; pointer to mask table.
       add hl,bc           ; add displacement to pointer.
       ld c,(hl)           ; left mask.
       inc hl
       ld b,(hl)           ; right mask.

; Drop into screen address routine.
; This routine returns a screen address for (dispx, dispy) in hl.

scadd  ld a,(dispx)        ; coordinate.
       ld l,a              ; low byte of table.
       ld h,251            ; high byte of 64256 (SCADTB).
       ld a,(hl)           ; fetch high byte.
       inc h               ; point to low byte table.
       ld l,(hl)           ; fetch low byte.
       ld h,a              ; hl points to start of line.
       ld a,(dispy)        ; y pixel coordinate.
       rrca                ; divide by 8.
       rrca
       rrca
       and 31              ; squares 0 - 31 across screen.
       add a,l             ; add to address.
       ld l,a              ; copy to hl = address of screen.
       ret

spmask defb 255,0,63,192,15,240,3,252


; These are the sprite routines.
; sspria = single sprite, old (ix).
; ssprib = single sprite, new (ix+5).
; sspric = both sprites, old (ix) and new (ix+5).

sspria call gsprad         ; obtiene dirección del sprite viejo (DE y HL secundarios)
    exx
sspri2 ld a,16             ; vertical lines.
sspri0 ex af,af'           ; store line counter away in alternate registers.
       call dline          ; draw a line.
       ex af,af'           ; restore line counter.
       dec a               ; one less to go.
       jp nz,sspri0
       ret

ssprib call gspran         ; obtiene dirección del sprite nuevo (DE y HL primarios)
       jp sspri2

;RESUMEN GENERAL
;sspric pinta un sprite de 16 líneas usando la técnica XOR, alternando entre fondo viejo y nuevo.
;gsprad y gspran calculan las direcciones de pantalla para el sprite viejo y nuevo.
;dline pinta una línea de sprite usando XOR.
;Usa exx para alternar los registros primarios/secundarios y así mantener dos contextos de dirección activos.

sspric call gsprad         ; obtiene dirección del sprite viejo (DE y HL secundarios)
    exx
       exx                 ; store addresses.
       call gspran         ; obtiene dirección del sprite nuevo (DE y HL primarios)
;dline (con exx) para pintar una línea del sprite nuevo
;exx seguido de dline para borrar la misma línea del sprite anterior
;nuevo - viejo - nuevo - viejo - ... (x8 pares)
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.

; Drop through.
; Line drawn, now work out next target address.
;dline está acoplado a un sistema de impresión por bytes con desplazamientos que simula perfectamente las 3 columnas del sprite.
dline
;Primer byte
	   ld a,(de)           ; carga el primer byte del sprite
       and c               ; aplica máscara lateral derecha
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.
       inc l               ; pasa a siguiente byte de pantalla
       inc l               ; next screen address.	   
;Segundo byte
       ld a,(de)           ; vuelve a cargar (porque DE no se ha incrementado)
       and b               ; aplica máscara lateral izquierda
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.	   
       inc de              ; next graphic.
       dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
       ld a,(de)           ; second bit of data.
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.
       inc de              ; point to next line of data.
       dec l               ; retrocede una más, para próxima línea

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

animsp ld hl,frmno         ; game frame.
       and (hl)            ; is it time to change the frame?
       ret nz              ; not this frame.
       ld a,(ix+6)         ; sprite image.
       call gfrm           ; get frame data.
       inc hl              ; point to frames.
       ld a,(ix+7)         ; sprite frame.
       inc a               ; next one along.
       cp (hl)             ; reached the last frame?
       jr c,anims0         ; no, not yet.
       xor a               ; start at first frame.
anims0 ld (ix+7),a         ; new frame.
       ret
animbk ld hl,frmno         ; game frame.
       and (hl)            ; is it time to change the frame?
       ret nz              ; not this frame.
       ld a,(ix+6)         ; sprite image.
       call gfrm           ; get frame data.
       inc hl              ; point to frames.
       ld a,(ix+7)         ; sprite frame.
       and a               ; first one?
       jr nz,rtanb0        ; yes, start at end.
       ld a,(hl)           ; last sprite.
rtanb0 dec a               ; next one along.
       jr anims0           ; set new frame.

; Sprite table.
; ix+0  = type.
; ix+1  = sprite image number.
; ix+2  = frame.
; ix+3  = x coord.
; ix+4  = y coord.

; ix+5  = new type.
; ix+6  = new image number.
; ix+7  = new frame.
; ix+8  = new x coord.
; ix+9  = new y coord.

; ix+10 = direction.
; ix+11 = parameter 1.
; ix+12 = parameter 2.
; ix+13 = jump pointer low.
; ix+14 = jump pointer high.
; ix+15 = data pointer low.
; ix+16 = data pointer high.


sprtab equ $

       defs SPRBUF,255 

ssprit defb 255,255,255,255,255,255,255,0,192,120,0,0,0,255,255,255,255 