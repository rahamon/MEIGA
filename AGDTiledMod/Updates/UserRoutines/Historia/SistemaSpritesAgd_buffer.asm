; Prototipo mascara con bufferPrint y bufferfondo
; secuencia:
;		0- Room
;		*GUARDA_Fondo_inicial(pos_actual) en (ix+18) y COPIA_Fondo(pos_actual) en (ix+116)
;		*GUARDA_buffer_inicial(pos_actual) en (ix+68)
;		
;
; mloop 
;		1- RESTAURA_Fondo(pos_anterior): COPIA (ix+18) en SCREEN(pos_anterior)
;		*2- GUARDA_Fondo_nuevo(pos_actual) en (ix+116)
;		3- RESTAURA_Sprites(pos_anterior): COPIA (ix+68) en SCREEN(pos_anterior)
;
;		*4- GUARDA_buffer(pos_actual) en (ix+68)
;			(ix+116) AND Mascara OR Sprite
;		
;			vsync
;		5- RESTAURA_Fondo(pos_anterior):  COPIA (ix+18) en SCREEN(pos_anterior)
;		*7- PRINT_buffer(pos_actual): COPIA (ix+68) en SCREEN(pos_actual)
;		
;			vsync
;		8- PROCESA_Datos() y SWAPBuffer_Fondo()
;			pos_anterior = pos_actual
;			fondo(ix+18)=fondo_nuevo(ix+116)
;	
; Limitaciones: Funciona si mejor si no hay colisiones
;				No puedes coger objetos ni colectables
; Recomendacion: Escoge la manera mascara en las pantallas adecuadas

LASTIX	equ (NUMSPR -1 ) * TABSIZ
; -----------------------------------------------------------------
; dspra: Borrar sprites. Recupera fondos desde detras hacia delante, o de alante a atrás?
; -----------------------------------------------------------------
RESTAURA_Fondo
dspra   ld b,NUMSPR       ; number of sprites to display de alante a atrás?
        ;ld de,LASTIX		; tamaño de cada entrada de detras hacia delante?
        ;add ix,de
dspra0  push bc             ; store loop counter for now.

       ld a,(ix+0)         ; get sprite type.
       inc a               ; is it enabled?
       jr nz,dspra1         ; yes, it needs deleting.
dspra5 ld a,(ix+5)          ; tipo nuevo
       inc a
       jp nz,dspra4         ; si está habilitado, dibujar

dspra2 ;ld de,-TABSIZ       ; distance to next odd/even entry. de detras hacia delante?
		ld de,TABSIZ		;de alante a atrás?
       add ix,de           ; next sprite.
       pop bc              ; retrieve loop counter.
       djnz dspra0          ; repeat for remaining sprites.
       ret

dspra1 ld a,(ix+5)         ; type of new sprite.
       inc a               ; is this enabled?
       jr nz,dspra4         ; yes, display both.

dspra6 jr dspra2

dspra4 jp dspra7
		ld a,(ix+4)         ; old y.
       cp (ix+9)           ; compare with new value.
       jr nz,dspra7         ; they differ, need to redraw.
       ld a,(ix+3)         ; old x.
       cp (ix+8)           ; compare against new value.
       jr nz,dspra7         ; they differ, need to redraw.
       ld a,(ix+2)         ; old frame.
       cp (ix+7)           ; compare against new value.
       jr nz,dspra7         ; they differ, need to redraw.
	   ; ld a,(ix+13)
	   ; and a
	   ; jp nz,dspra2			
       ld a,(ix+1)         ; old image.
       cp (ix+6)           ; compare against new value.
       jr z,dspra2          ; everything is the same, don't redraw.
	   
dspra8	; estatico
		call check_all_types
		jr c,dspra7
		
		; push ix
		; ld ix,(skptr)
		; call restore_background
		; pop ix
		; call restore_background
		jp dspra2
	   
dspra7 call restore_background
       jp dspra2

;-----------------------------------------
; restore_background
; Restaura fondo desde BufferFondo. borra siempre
;-----------------------------------------
sspria
restore_background
		ld l,(ix+3)         ; new x coordinate.
		ld h,(ix+4)         ; new y coordinate.
		ld (dispx),hl       ; set display coordinates.

		call scadd          ; HL = pantalla donde estaba sprite viejo
		;call gsprad           HL = pantalla donde estaba sprite viejo
							 ; DE = grafico, no hace falta, por eso pasamos de gsprad a scadd
		push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
sspri0	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
dlaptr	defw dline_bk_restore
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,sspri0
		pop ix               ; restaurar IX original
		ret

;-----------------------------
; Copia BufferFondo (IX+18) en SCREEN
dline_bk_restore:
		; Restaurar 3 bytes
		ld a,(ix+18)		; buffer fondo
		ld (hl),a
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.

		ld a,(ix+19)
		ld (hl),a
		;inc de              ; next graphic.
		dec l               ; mueve cursor de pantalla una celda a la izquierda

		ld a,(ix+20)
		ld (hl),a
		;inc de              ; point to next line of data.
		dec l               ; retrocede una más, para próxima línea
		
		; Avanzar IX
		push bc
		ld bc,3
		add ix,bc
		pop bc
		
		jp nline

; -----------------------------------------------------------------
; GUARDA_buffer_inicial: Imprimir sprites en buffer.
; Desde delante hacia atrás desde la posicion inicial
; GUARDA desde posicion inicial a bufferPrint (ix+68)
; -----------------------------------------------------------------
GUARDA_buffer_inicial
		;ld hl,gsprmd
		;ld (gspmptr),hl
		;ld hl,gsprad
		;ld (gspaptr),hl
		
		call GUARDA_buffer
		;ld ix,sprtab
		;call PROCESA_Datos
		
		;ld hl,gsprm
		;ld (gspaptr),hl		
		;ld hl,gspran
		;ld (gspaptr),hl		
		ret

; -----------------------------------------------------------------
; dsprb: Guardar sprites en buffer. Desde delante hacia atrás
; (ix+116) AND maskSprite OR sprite en (ix+68)
; -----------------------------------------------------------------
GUARDA_buffer
dsprb	ld b,NUMSPR          ; contador de sprites
dsprb0: push bc                ; guarda el contador

        ld a,(ix+0)          ; tipo antiguo
        inc a
        jr nz,dsprb1         ; si estaba habilitado, borrado
dsprb5: ld a,(ix+5)          ; tipo nuevo
        inc a
        jr nz,dsprb4         ; si está habilitado, dibujar

dsprb2  jp dsprb22
		push ix
        pop hl
        ld e,l
        ld d,h
        ld bc,5              ; distancia a "new type"
        add hl,bc
        ldi
        ldi
        ldi
        ldi
        ldi

dsprb22 ld de,TABSIZ        ; tambien: ld de,65536 - TABSIZ
        add ix,de             ; IX -= TABSIZ
        pop bc
        djnz dsprb0	
        ret
	
dsprb1 ld a,(ix+5)         ; type of new sprite.
       inc a               ; is this enabled?
       jr nz,dsprb4         ; yes, borra y pinta

dsprb6 jp dsprb2

dsprb4 jp dsprb7
		ld a,(ix+4)         ; old y.
       cp (ix+9)           ; compare with new value.
       jr nz,dsprb7         ; they differ, need to redraw.
       ld a,(ix+3)         ; old x.
       cp (ix+8)           ; compare against new value.
       jr nz,dsprb7         ; they differ, need to redraw.
       ld a,(ix+2)         ; old frame.
       cp (ix+7)           ; compare against new value.
       jr nz,dsprb7         ; they differ, need to redraw.
	   ; ld a,(ix+13)
	   ; and a
	   ; jp nz,dsprb2			
       ld a,(ix+1)         ; old image.
       cp (ix+6)           ; compare against new value.
       jr z,dsprb2          ; everything is the same, don't redraw.
	   
dsprb8	; estatico
		call check_all_types
		jr c,dsprb7

		; push ix
		; ld ix,(skptr)
		; call ssprib
		; pop ix
		;call ssprib
		jp dsprb2
		
dsprb7	
dsprb3  call sprite_save_buffer
		;call save_background_new
		;call srprib_or
       jp dsprb2

; -----------------------------------------------------------------
; PROCESA datos: Guardar datos sprites nuevos en sprite viejos
; (ix+0) = (ix+5)
; -----------------------------------------------------------------
PROCESA_Datos
		ld b,NUMSPR          ; contador de sprites
prospr0	push bc                ; guarda el contador

		push ix
        pop hl
        ld e,l
        ld d,h
        ld bc,5              ; distancia a "new type"
        add hl,bc
        ldi
        ldi
        ldi
        ldi
        ldi

prospr2 ld de,TABSIZ        ; tambien: ld de,65536 - TABSIZ
        add ix,de             ; IX -= TABSIZ
        pop bc
        djnz prospr0
        ret

;-----------------------------------------
; SWAPBuffer_Fondo
;-----------------------------------------
SWAPBuffer_Fondo
		ld b,NUMSPR          ; contador de sprites
swapbu0	push bc                ; guarda el contador

        push ix
        pop hl              ; HL = IX
        ld de,18
        add hl,de           ; HL = IX + 18  (DESTINO)
        ex de,hl            ; DE = destino
        push ix
        pop hl              ; HL = IX
        ld bc,116
        add hl,bc           ; HL = IX + 116 (ORIGEN)
        ld bc,48            ; número de bytes a copiar
        ldir

swapbu2 ld de,TABSIZ        ; tambien: ld de,65536 - TABSIZ
        add ix,de             ; IX -= TABSIZ
        pop bc
        djnz swapbu0
        ret
		
;-----------------------------------------
; gspram
; Recoge en DE el gráfico de la máscara
; DE apunta al grafico frame
; BC es SPMASK (b:right-c:left) SIMASK
; HL la posicion en pantalla
; Despues necesito DE en BC -> Sprite mask
;-----------------------------------------
gsprmd ld l,(ix+3)          ; new x coordinate.
       ld h,(ix+4)         ; new y coordinate.
       ld (dispx),hl       ; set display coordinates.
       ld a,(ix+66)        ; mask sprite image.
		jp gsprm1
		
gsprm  ld l,(ix+8)          ; new x coordinate.
       ld h,(ix+9)         ; new y coordinate.
       ld (dispx),hl       ; set display coordinates.
       ld a,(ix+66)        ; mask sprite image.
	   
gsprm1 call gfrm           ; fetch start frame for mask sprite.
       ld a,(hl)           ; start mask frame in accumulator.
	   call gspra0
	   ret
	   inc hl				; apunta al last mask frame de la mascara
       add a,(ix+7)        ; suma new sprite frame number.
	   inc a				;+1
       cp (hl)             ; reached the last mask frame?
       jr nc,gsprm0         ; no, not yet.
	   dec hl 				; fuera de rengo, frame mask reset
	   ld a,(hl)
gsprm0 dec a
		call gspra0			; DE,BC y HL del sprite (image=(ix+66), frame=(ix+7))
		; Necesito DE dentro de BC
	   ret
	   
;-----------------------------------------
; sprite_save_buffer pinta sprite nuevo en buffer
; desde posicion (ix+5) con el fondo (ix+116) en bufferPrint (ix+68) 
; ssprib
;-----------------------------------------
sprite_save_buffer
ssprib	defb $CD
gspmptr	defw gsprm           ; DE = sprite mascara, BC = SIMASK
		exx
		defb $CD
gspaptr	defw gspran          ; HL = pantalla destino, DE = sprite, BC = SIMASK
		
		push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
sspri01	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
dlbptr	defw dline_saveBuffer_new
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,sspri01
		pop ix               ; restaurar IX original
		ret

; -----------------------------------------------------------------
; prototipo con mascara plana: bc SP
; DE apunta al grafico frame
; BC es SPMASK (b:right-c:left) SIMASK
; HL la posicion en pantalla
; -----------------------------------------------------------------
dline_saveBuffer_new
;Primer byte
		ld a,(ix+116)		; CARGA FONDO
	; maskSprite
		exx
		push bc
		ld a,(de)
		and c
		push af				; guarda resultado
		ld a,c
		cpl
		ld c,a				; cpl c
		pop af				; recupera resultado
		or c
		and (hl)		; OPERA AND MASCARA
		pop bc
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	  
	; Sprite
		exx
		ld (ix+68),a		; PRINT FONDO CON MASCARA
		ld a,(de)           ; carga el primer byte del sprite
		and c               ; aplica SIMASK lateral derecha
		or (ix+68)		; OPERA OR SPRITE
		ld (ix+68),a	; GUARDA BYTE en BufferPrint
		
		;ld a,(ix+68)       	; LOAD BYTE desde BufferPrint
		;ld (hl),a				; PRINT BYTE: bung it in.
		
		
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	   
;Segundo byte
		ld a,(ix+117)			; craga fondo linea
	; maskSprite
		exx
		push bc
		ld a,(de)
		and b
		push af				; guarda resultado
		ld a,b
		cpl
		ld b,a				; cpl c
		pop af				; recupera resultado
		or b
		and (hl)
		pop bc
		inc de              ; point to next line of data
		dec l               ; mueve cursor de pantalla una celda a la izquierda
	;Sprite
		exx
		ld (ix+69),a
		ld a,(de)           ; vuelve a cargar grafico (porque DE no se ha incrementado)
		and b               ; aplica SIMASK lateral izquierda
		or (ix+69)             ; OR with what's there.
		ld (ix+69),a           ; bung it in.
		
		inc de              ; point to next line of data
		dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
		ld a,(ix+118)		;+2
	; maskSprite
		exx
		ld a,(de)
		and (hl)
		inc de              ; point to next line of data
		dec l               ; mueve cursor de pantalla una celda a la izquierda
	;Sprite
		exx
		ld (ix+70),a
		ld a,(de)           ; second bit of data.
		or (ix+70)             ; OR with what's there.
		ld (ix+70),a           ; bung it in.
		
		inc de              ; point to next line of data.
		dec l               ; retrocede una más, para próxima línea
	   
		; Avanzar IX
		push bc
		ld bc,3
		add ix,bc
		pop bc
		
		exx
		call nline
		exx
		jp nline

;-----------------------------------------
; Restaura Sprites (ix) -> SCREEN
;-----------------------------------------
RESTAURA_Sprites
		ld hl,Restaura_Buffer_sprites
		ld (prbfptr),hl
		
		call PRINT_Buffer
		
		ld hl,PRINT_Buffer_sprites
		ld (prbfptr),hl		
		ret
		
; -----------------------------------------------------------------
; PRINT_Buffer Prototipo : Imprimir sprites. Desde delante hacia atrás desde el BufferPrint
; -----------------------------------------------------------------
PRINT_Buffer
		ld b,NUMSPR          ; contador de sprites
prbuff: push bc                ; guarda el contador

       ld a,(ix+5)         ; get sprite type.
       inc a               ; is it enabled?
       jr z,prbuff2         ; no

		defb $CD
prbfptr	defw PRINT_Buffer_sprites		;<--- ***
		
prbuff2 ld de,TABSIZ        ; tambien: ld de,65536 - TABSIZ
        add ix,de             ; IX -= TABSIZ
        pop bc
		djnz prbuff
        ret

;-----------------------------------------
; RESTAURA_Sprites_buffer (ix) -> SCREEN
;-----------------------------------------
Restaura_Buffer_sprites
		ld l,(ix+3)         ; new x coordinate.
		ld h,(ix+4)         ; new y coordinate.
		ld (dispx),hl       ; set display coordinates.
		jp pbspr00
		
;-----------------------------------------
; PRINT_buffer (ix+5) -> SCREEN
;-----------------------------------------
PRINT_Buffer_sprites
		ld l,(ix+8)         ; new x coordinate.
		ld h,(ix+9)         ; new y coordinate.
		ld (dispx),hl       ; set display coordinates.

pbspr00	call scadd          ; HL = pantalla donde esta sprite new
		;call gspran        ; HL = pantalla destino, DE = sprite, BC = máscara, no hace falta

		push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
pbspr01	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
		defw dline_PRINT_Buffer_sprites
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,pbspr01
		pop ix               ; restaurar IX original
		ret

dline_PRINT_Buffer_sprites
;Primer byte
	; Print byte
		ld a,(ix+68)		
		ld (hl),a			; cambiar por xor a para test
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	   
;Segundo byte
	; Print byte
		ld a,(ix+69)		   
		ld (hl),a
		;inc de              next graphic.
		dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
	; Print byte
		ld a,(ix+70)		
		ld (hl),a
		;inc de              point to next line of data.
		dec l               ; retrocede una más, para próxima línea
	   
		; Avanzar IX
		push bc
		ld bc,3
		add ix,bc
		pop bc
		
		jp nline

;-----------------------------------------
; save_background_new
; GUARDA el fondo nuevo (ix+5)->(ix+116)
;-----------------------------------------
GUARDA_Fondo_nuevo
		ld hl,save_background_new
		ld (sbgptr),hl
		ld hl,dline_save_background_new
		ld (sbgdptr),hl
		
		call GUARDA_Fondo
		
		ld hl,save_background
		ld (sbgptr),hl		
		ld hl,dline_save_background
		ld (sbgdptr),hl
		ret

;-----------------------------------------
; save_background_ini
; GUARDA el fondo Inicial en (ix+18)(ix+116)
;-----------------------------------------
GUARDA_Fondo_inicial
		ld hl,save_background_new
		ld (sbgptr),hl
		;push hl
		ld hl,dline_save_background_ini
		ld (sbgdptr),hl
		;pop hl
		
		call GUARDA_Fondo
		
		ld hl,save_background
		ld (sbgptr),hl		
		;push hl
		ld hl,dline_save_background
		ld (sbgdptr),hl
		;pop hl
		ret

;-----------------------------------------
; save_background
; GUARDA el fondo (ix)->(ix+18)
;-----------------------------------------
GUARDA_Fondo
		ld b,NUMSPR          ; contador de sprites
svbckg	push bc                ; guarda el contador

		ld a,(ix+5)			; get sprite type.
		inc a				; is it enabled?
		jr z,svbckg2         ; no

		defb $CD
sbgptr	defw save_background
		
svbckg2 ld de,TABSIZ        ; tambien: ld de,65536 - TABSIZ
        add ix,de             ; IX -= TABSIZ
        pop bc
		djnz svbckg
        ret
		
;-----------------
; posicion (ix+5)
save_background_new
		ld l,(ix+8)         ; x coordinate.
		ld h,(ix+9)         ; y coordinate.
		ld (dispx),hl       ; set display coordinates.

		jp svpri00
;-----------------
; posicion (ix)
save_background
		ld l,(ix+3)         ; x coordinate.
		ld h,(ix+4)         ; y coordinate.
		ld (dispx),hl       ; set display coordinates.

svpri00	call scadd          ; HL = pantalla donde esta sprite
		;call gspran        ; HL = pantalla destino, DE = sprite, BC = máscara, no hace falta

		push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
svpri01	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
sbgdptr	defw dline_save_background
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,svpri01
		pop ix               ; restaurar IX original
		ret

;-----------------------------------------
; GUARDA el fondo (ix)->(ix+18)
dline_save_background
;Primer byte
		ld a,(hl)			; cambiar por xor a para test
		ld (ix+18),a		
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	   
;Segundo byte
		ld a,(hl)
		ld (ix+19),a		   
		;inc de              ; next graphic.
		dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
		ld a,(hl)
		ld (ix+20),a		
		;inc de              ; point to next line of data.
		dec l               ; retrocede una más, para próxima línea
	   
		; Avanzar IX
		push bc
		ld bc,3
		add ix,bc
		pop bc
		
		jp nline

;-----------------------------------------
; GUARDA el fondo Inicial (ix)->(ix+18)(ix+116)
dline_save_background_ini
;Primer byte
		ld a,(hl)			; cambiar por xor a para test
		ld (ix+18),a		
		ld (ix+116),a		
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	   
;Segundo byte
		ld a,(hl)
		ld (ix+19),a		   
		ld (ix+117),a		   
		;inc de              ; next graphic.
		dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
		ld a,(hl)
		ld (ix+20),a		
		ld (ix+118),a		
		;inc de              ; point to next line of data.
		dec l               ; retrocede una más, para próxima línea
	   
		; Avanzar IX
		push bc
		ld bc,3
		add ix,bc
		pop bc
		
		jp nline

;-----------------------------------------
; GUARDA el fondo nuevo (ix+5)->(ix+116)
dline_save_background_new
;Primer byte
		ld a,(hl)			; cambiar por xor a para test
		ld (ix+116),a		
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	   
;Segundo byte
		ld a,(hl)
		ld (ix+117),a		   
		;inc de              ; next graphic.
		dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
		ld a,(hl)
		ld (ix+118),a		
		;inc de              ; point to next line of data.
		dec l               ; retrocede una más, para próxima línea
	   
		; Avanzar IX
		push bc
		ld bc,3
		add ix,bc
		pop bc
		
		jp nline
		
;-----------------------------------------
; sspric
; Restaura fondo del sprite viejo y pinta el sprite nuevo
;-----------------------------------------
sspric:
		call restore_background
		call ssprib
		ret

dline_org
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

		jp nline

dline_or
;Primer byte
	   ld a,(de)           ; carga el primer byte del sprite
       and c               ; aplica máscara lateral derecha
       or (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.
       inc l               ; pasa a siguiente byte de pantalla
       inc l               ; next screen address.	   
;Segundo byte
       ld a,(de)           ; vuelve a cargar (porque DE no se ha incrementado)
       and b               ; aplica máscara lateral izquierda
       or (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.	   
       inc de              ; next graphic.
       dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
       ld a,(de)           ; second bit of data.
       or (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.
       inc de              ; point to next line of data.
       dec l               ; retrocede una más, para próxima línea

		jp nline

; -----------------------------------------------------------------
; Rutinas
; -----------------------------------------------------------------

; -----------------------------------------------------------------
; check_all_types
; Llama a sktyp para todos los tipos 0..8
; Si encuentra colisión, Carry=1 y skptr apunta al sprite que colisiona
; Si no encuentra colisión, Carry=0
; -----------------------------------------------------------------

check_all_types:
		ld b,0              ; empezamos con tipo 0
loop_types:
		push bc             ; guardar B (tipo actual)
		call sktyp          ; chequea colisiones con sprites de tipo B
		jr c,collision_found  ; si Carry=1 → encontró colisión → salir
		pop bc              ; recuperar B
		inc b               ; siguiente tipo
		ld a,b
		cp 9                ; ¿ya llegamos a 9?
		jr nz,loop_types   ; no → seguir
		; si llegamos aquí, no hubo colisión con ningún tipo
		xor a               ; A=0 (opcional)
		ret                 ; Carry=0 -> sin colisión
collision_found:
		pop bc              ; limpiar pila
		scf                 ; aseguramos Carry=1
		ret                 ; devolvemos con Carry=1 y skptr listo

swap_dlpoiters
		push hl
		ld hl,dline_org
		ld (dlaptr),hl
		ld (dlbptr),hl
		pop hl
		ret
		
sspr_restore_dlpointers
		push hl
		ld hl,dline_saveBuffer_new
		ld (dlbptr),hl
		ld hl,dline_bk_restore
		ld (dlaptr),hl
		pop hl
		ret

bsort_inv
		ld a,30				; 30 = JR NC,n
		ld (bsort2 - 2),a
		call bsort
		ret
		
bsort_org
		ld a,38				; 38 = JR C,n
		ld (bsort2 - 2),a
		call bsort
		ret
