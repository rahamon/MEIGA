; Prototipos
; Limitaciones: Funciona si mejor si no hay colisiones
;				No puedes coger objetos ni colectables
; Recomendacion: Escoge la manera mascara en las pantallas adecuadas
; Puede sincronizar con NUMSPR/2 pero falta resolver las colisiones

LASTIX	equ (NUMSPR -1 ) * TABSIZ
; -----------------------------------------------------------------
; dspra: Borrar sprites. Recupera fondos desde detras hacia delante
; -----------------------------------------------------------------
dspra   ld b,NUMSPR      ; number of sprites to display.
        ld de,LASTIX		; tamaño de cada entrada
        add ix,de
dspra0  push bc             ; store loop counter for now.

       ld a,(ix+0)         ; get sprite type.
       inc a               ; is it enabled?
       jr nz,dspra1         ; yes, it needs deleting.
dspra5 ld a,(ix+5)          ; tipo nuevo
       inc a
       jp nz,dspra4         ; si está habilitado, dibujar

dspra2 ld de,-TABSIZ       ; distance to next odd/even entry.
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
		; call sspria
		; pop ix
		; call sspria
		jp dspra2
	   
dspra7 call sspria         ; delete old sprite, nada mas.
       jp dspra2

; -----------------------------------------------------------------
; dsprb: Imprimir sprites. Desde delante hacia atrás
; -----------------------------------------------------------------
dsprb	ld b,NUMSPR          ; contador de sprites
dsprb0: push bc                ; guarda el contador

        ld a,(ix+0)          ; tipo antiguo
        inc a
        jr nz,dsprb1         ; si estaba habilitado, borrado
dsprb5: ld a,(ix+5)          ; tipo nuevo
        inc a
        jr nz,dsprb4         ; si está habilitado, dibujar

dsprb2: push ix
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
        ld de,TABSIZ        ; tambien: ld de,65536 - TABSIZ
        add ix,de             ; IX -= TABSIZ
        pop bc
	   djnz dsprb0
        ret
	
dsprb1 ld a,(ix+5)         ; type of new sprite.
       inc a               ; is this enabled?
       jr nz,dsprb4         ; yes, display.

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
dsprb3  call ssprib         ; show single sprite.
		;call svprib
		;call srprib_or
       jp dsprb2
	   
;-----------------------------------------
; sspria
; Restaura fondo desde spritebk. borra siempre
;-----------------------------------------
sspria:
		call gsprad          ; HL = pantalla donde estaba sprite viejo
							 ; DE = grafico
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

dline_bk_restore:
		; Restaurar 3 bytes
		ld a,(ix+18)
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
		
;-----------------------------------------
; gspram
; Recoge en DE el gráfico de la máscara
; DE apunta al grafico frame
; BC es SPMASK (b:right-c:left) SIMASK
; HL la posicion en pantalla
; Despues necesito DE en BC -> Sprite mask
;-----------------------------------------
gsprm ld l,(ix+8)          ; new x coordinate.
       ld h,(ix+9)         ; new y coordinate.
       ld (dispx),hl       ; set display coordinates.
       ld a,(ix+66)        ; mask sprite image.
	   
       call gfrm           ; fetch start frame for mask sprite.
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
; ssprib
; Guarda fondo en spritebk y pinta sprite nuevo
;-----------------------------------------
ssprib
		call gsprm           ; DE = sprite mascara, BC = SIMASK
		exx
		call gspran          ; HL = pantalla destino, DE = sprite, BC = SIMASK
		
		push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
sspri01	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
dlbptr	defw dline_savebk_and_print_new
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,sspri01
		pop ix               ; restaurar IX original
		ret

;-----------------------------------------
; sspric
; Restaura fondo del sprite viejo y pinta el sprite nuevo
;-----------------------------------------
sspric:
		call sspria
		call ssprib
		ret

; -----------------------------------------------------------------
; prototipo con mascara plana: bc SP
; DE apunta al grafico frame
; BC es SPMASK (b:right-c:left) SIMASK
; HL la posicion en pantalla
; -----------------------------------------------------------------
dline_savebk_and_print_new
;Primer byte
		ld a,(hl)			; craga fondo 
		ld (ix+18),a		;+0 guarda en buffer sprite
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
		and (hl)
		pop bc
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	  
		exx
		ld (hl),a			;***
		;sigue
		ld a,(de)           ; carga el primer byte del sprite
		and c               ; aplica SIMASK lateral derecha
		or (hl)             ; OR with what's there.
		ld (hl),a           ; bung it in.
		
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	   
;Segundo byte
		ld a,(hl)			; craga linea
		ld (ix+19),a		;+1
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
		exx
		ld (hl),a
		;sigue
		ld a,(de)           ; vuelve a cargar grafico (porque DE no se ha incrementado)
		and b               ; aplica SIMASK lateral izquierda
		or (hl)             ; OR with what's there.
		ld (hl),a           ; bung it in.
		
		inc de              ; point to next line of data
		dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
		ld a,(hl)
		ld (ix+20),a		;+2
		; maskSprite
		exx
		ld a,(de)
		and (hl)
		inc de              ; point to next line of data
		dec l               ; mueve cursor de pantalla una celda a la izquierda
		exx
		ld (hl),a
		;sigue
		ld a,(de)           ; second bit of data.
		or (hl)             ; OR with what's there.
		ld (hl),a           ; bung it in.
		
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
; srprib_or
; Pinta sprite nuevo sin guardar el fondo
;-----------------------------------------
srprib_or
		call gspran          ; HL = pantalla destino, DE = sprite, BC = máscara

		push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
srpri01	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
		defw dline_print_new2
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,srpri01
		pop ix               ; restaurar IX original
		ret

;-----------------------------------------
; svprib
; Guarda el nuevo fondo
;-----------------------------------------
svprib
		call gspran          ; HL = pantalla destino, DE = sprite, BC = máscara

		push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
svpri01	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
		defw dline_savebk_new3
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,svpri01
		pop ix               ; restaurar IX original
		ret

dline_print_new2
;Primer byte
		ld a,(hl)			; cambiar por xor a para test
		and b               ; aplica la inversa a la máscara lateral derecha
		ld (hl),a           ; bung it in masked.
		ld a,(de)           ; carga el primer byte del sprite
		and c               ; aplica máscara lateral derecha
		or (hl)            ; XOR with what's there.
		ld (hl),a           ; bung it in.
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	   
;Segundo byte
		ld a,(hl)
		and c               ; aplica la inversa a la máscara lateral izquierda
		ld (hl),a           ; bung it in masked.
		ld a,(de)           ; vuelve a cargar (porque DE no se ha incrementado)
		and b               ; aplica máscara lateral izquierda
		or (hl)            ; XOR with what's there.
		ld (hl),a           ; bung it in.	   
		inc de              ; next graphic.
		dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
		ld a,(hl)
		and 0               ;  aplica la máscara central
		ld (hl),a           ; bung it in masked.
		ld a,(de)           ; second bit of data.
		or (hl)            ; XOR with what's there.
		ld (hl),a           ; bung it in.
		inc de              ; point to next line of data.
		dec l               ; retrocede una más, para próxima línea
	   
		; Avanzar IX
		push bc
		ld bc,3
		add ix,bc
		pop bc
		
		jp nline

dline_savebk_new3
;Primer byte
		ld a,(hl)			; cambiar por xor a para test
		ld (ix+18),a		
		inc l               ; pasa a siguiente byte de pantalla
		inc l               ; next screen address.	   
;Segundo byte
		ld a,(hl)
		ld (ix+19),a		   
		inc de              ; next graphic.
		dec l               ; mueve cursor de pantalla una celda a la izquierda
;Tercer byte
		ld a,(hl)
		ld (ix+20),a		
		inc de              ; point to next line of data.
		dec l               ; retrocede una más, para próxima línea
	   
		; Avanzar IX
		push bc
		ld bc,3
		add ix,bc
		pop bc
		
		jp nline

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
		ld hl,dline_savebk_and_print_new
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
