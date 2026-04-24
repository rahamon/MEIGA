; Prototipos
; Revision 2026 funciona con Objetos y Colisiones
; Limitacion solo cuando el objeto colisiona con un slo sprite o ninguno
; Recomendacion: Escoge la manera mascara en las pantallas adecuadas

LASTIX	equ (NUMSPR -1 ) * TABSIZ

vsync3f push hl
		ld a,(23672)        ; clock low.
		rra
		rra
		ld hl,clock         ; last clock reading.
vsync3f0
		ld a,(23672)        ; current clock reading.
		cp (hl)             ; are they the same?
		jr z,vsync3f0         ; yes, wait until clock changes.
		ld (hl),a          ; set new clock reading.
		pop hl
		ret

MASKAGDopt	defb MASKAGD

;---------------------------------------------------------------------------
; Bucle entero para mloop
;---------------------------------------------------------------------------
SHOW_Sprites
		ld ix,sprtab
		call RESTAURA_Fondo_C			; borra sprites que clisionan
		ld ix,sprtab
		call PRINT_Sprites_NC			; borra y pinta sprites que no colisionan.
		call PRINT_Sprites_C			; pinte sprites que colisionan
		ret

SHOW_Sprites2
		ld ix,sprtab
		call PRINT_Sprites_NC			; borra y pinta sprites que no colisionan.
		push ix
		ld ix,sprtab
		call RESTAURA_Fondo_C			; borra sprites que clisionan
		pop ix
		call PRINT_Sprites_C			; pinta sprites que colisionan
		ret
;---------------------------------------------------------------------------
; Restaura Fondo en Colisiones: Recupera fondos desde delante hacia detras 
; Despues de ZSort: desde NUMSPR hasta NCol(excluido)
; ejemplo colisiona el 2, no colisionan 2, en pantalla 4 sprites, NUMSPR(12 siempre). despues de Zsort NCol=2
;---------------------------------------------------------------------------
RESTAURA_Fondo_C
resra   ld b,NUMSPR       ; number of sprites to display.
        ld de,LASTIX	; tamaño de cada entrada
        add ix,de
		
resra0	ld a,(NCol)
		;inc a				; a=NCol+1
		
		cp b
		jr z,resrb9			; hasta NCol

		push bc             ; store loop counter for now.

        ld a,(ix+0)         ; get sprite type.
        inc a               ; is it enabled?
        jr nz,resra1        ; yes, habilitado
resra5  ;ld a,(ix+5)         
        ;inc a
        ;jp nz,resra7        ; estaba des-habilitado ahora está habilitado, APARECE
		; VACIO
		
resra2 ld de,-TABSIZ        ; distance to next odd/even entry.
       add ix,de            ; next sprite.
       pop bc               ; retrieve loop counter.
       djnz resra0          ; repeat for remaining sprites.
       ret

resra1 call RESTAURA_Fondo		;***
		;ld a,(ix+5)         ; type of new sprite.
       ;inc a               ; is this enabled?
       ;jr z,resra2         ; DESAPARECE, estaba habilitado ahora está des-habilitado
resra7 ;call RESTAURA_Fondo	; APARECE o SE MUEVE, delete old sprite, nada mas.
       jp resra2

resrb9	ld de,TABSIZ        ; restaura current sprite (IX(NCol+1)=IX(3))
        add ix,de
		push ix
		pop hl
		ld (CSprite),hl
		ret
		
CSprite defw 0
		
;---------------------------------------------------------------------------
; PRINT Strites que colisionan: Imprimir sprites. Desde delante hacia atrás
; Despues de ZSort: desde NCol hasta NUMSPR
; ejemplo colisiona 2. no colisionan 2, total en pantalla 4. despues de Zsort NCol=2
; display 3y4
;---------------------------------------------------------------------------
PRINT_Sprites_C
		ld a,(NCol)
		inc a				; c = NCol+1
		ld c,a
		
prisc0	ld a,c
		cp NUMSPR
		ret z				; hasta NUMSPR					

		push bc

		ld a,(ix+0)          ; tipo antiguo
        inc a
        jr nz,prisc1         ; si, antiguo habilitado
prisc5: ld a,(ix+5)          ; tipo nuevo
        inc a
        jr nz,prisc7         ; APARECE, estaba des-habilitado ahora está habilitado
		; VACIO
prisc2: push ix
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
		inc c
		jr prisc0
	
prisc1 ld a,(ix+5)         ; type of new sprite.
       inc a               ; is this enabled?
       jr z,prisc2         ; REMOVEME, estaba habilitado ahora está des-habilitado.
prisc7 call PRINT_Sprite   ; APARECE o se MUEVE, show single sprite.
       jp prisc2

;---------------------------------------------------------------------------
; Restaura e Imprime sprites.
; (Los que NoColisionan despues de ZSort Desde 0 hasta NCol)
; ejemplo c.3 nc.1 total 4. despues de Zsort NCol=1
; 1
;---------------------------------------------------------------------------
PRINT_Sprites_NC
prisnc	ld b,NUMSPR			; contador de sprites
		ld a,(NCol)
		;ld (varn),a
		and a
		ret z				; lista "nc" vacia
		ld c,0
prisnc0 push bc				; guarda el contador

        ld a,(ix+0)			; tipo antiguo
        inc a
        jr nz,prisnc1		; si estaba habilitado
prisnc5 ld a,(ix+5)			; tipo nuevo
        inc a
        jr nz,prisnc3		; APARECE, está habilitado anteriormente estaba des-habilitado
		; VACIO
prisnc2 push ix
        pop hl
        ld e,l
        ld d,h
        ld bc,5				; distancia a "new type"
        add hl,bc
        ldi
        ldi
        ldi
        ldi
        ldi
        ld de,TABSIZ        ; tambien: ld de,65536 - TABSIZ
        add ix,de             ; IX -= TABSIZ
		pop bc
		ld hl,NCol
		inc c
		ld a,c
		cp (hl)
		ret z				; hasta NCol
prisnc8 djnz prisnc0
        ret
	
	   
prisnc1	ld a,(ix+5)				; type of new sprite.
		inc a					; Nuevo activo?
		jr nz,prisnc4			; SI, antes tambien asi que se MUEVE
prisnc6	CALL RESTAURA_Fondo		; REMOVE: antes habilitado pero ahora des-habilitado
		jp dspr2

prisnc4	ld a,(ix+4)         ; old y.
		cp (ix+9)           ; compare with new value.
		jr nz,prisnc7         ; they differ, need to redraw.
		ld a,(ix+3)         ; old x.
		cp (ix+8)           ; compare against new value.
		jr nz,prisnc7         ; they differ, need to redraw.
		ld a,(ix+2)         ; old frame.
		cp (ix+7)           ; compare against new value.
		jr nz,prisnc7         ; they differ, need to redraw.
		ld a,(ix+1)         ; old image.
		cp (ix+6)           ; compare against new value.
		jp z,prisnc2          ; everything is the same, don't redraw.

prisnc7	CALL RESTAURA_Fondo		; MEIGA 10
		call PRINT_Sprite		; MEIGA 10
		jp prisnc2				; MEIGA 10
   
prisnc3 call PRINT_Sprite		; show single sprite.
		; show
		jp prisnc2
	   
;---------------------------------------------------------------------------
; Restaura fondo
;---------------------------------------------------------------------------
RESTAURA_Fondo_NUEVO
		call gspran
		jr resfo00
RESTAURA_Fondo:
		call gsprad          ; HL = pantalla donde estaba sprite viejo
							 ; DE = grafico
resfo00	push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
resfon0	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
dlaptr	defw dline_bk_restore
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,resfon0
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

;---------------------------------------------------------------------------
; gspram
; Recoge en DE el gráfico de la máscara
; DE apunta al grafico frame
; BC es SPMASK (b:right-c:left) SIMASK
; HL la posicion en pantalla
; Despues necesito DE en BC -> Sprite mask
;---------------------------------------------------------------------------
gsprm	ld l,(ix+8)          ; new x coordinate.
		ld h,(ix+9)         ; new y coordinate.
		ld (dispx),hl       ; set display coordinates.
		
gsprmx	ld a,(ix+66)        ; mask sprite image.
		call gfrm           ; fetch start frame for mask sprite.
		ld a,(hl)
		ld b,a
		; Chequea animacion frames de mascara, en pruebas
		inc hl				; apunta last_mask_frame_number
		ld a,(hl)
		cp 1           		; mascara un solo frame?
		ld a,b
		jr z,gsprm0
		add a,(ix+7)        ; suma new sprite frame number.
		;jr gsprm0
		; inc a				 start_mask_frame + sprite_frame + 1
		; cp (hl)              reached the last_mask_frame?
		; jr nc,gsprm0         no, not yet.
		; ld a,b				 fuera de rengo, frame mask reset
gsprm0	; new frame
		call gspra0			; DE,BC y HL del sprite (image=(ix+66), frame=(ix+7))
		; Necesito DE dentro de BC
		ret
		
;---------------------------------------------------------------------------
; PRINT_Sprite
; Guarda fondo en spritebk y pinta sprite nuevo
;---------------------------------------------------------------------------
PRINT_Sprite
gsmptr	call gsprm           ; HL = pantalla destino, DE = sprite mascara, BC = SIMASK
		exx
		call gspran          ; HL = pantalla destino, DE = sprite, BC = SIMASK
				
prisp00	push ix              ; salvar IX original de la tabla de sprites
		ld a,16             ; vertical lines.
prispr0	ex af,af'           ; 'store line counter away in alternate registers.
		defb $CD
dlbptr	defw dline_savebk_and_print_new
		ex af,af'           ; 'restore line counter.
		dec a
		jp nz,prispr0
		pop ix               ; restaurar IX original
		ret

; ----------------------------------------------------------------------
; prototipo con mascara plana: bc SP
; DE apunta al grafico frame
; BC es SPMASK (b:right-c:left) SIMASK
; HL la posicion en pantalla
; ----------------------------------------------------------------------
dline_savebk_and_print_new
;Primer byte
		ld a,(hl)			; craga fondo 
		ld (ix+18),a		;+0 guarda en buffer sprite
		ld (ix+68),a		;+0 guarda en buffer sprite
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
		ld (ix+69),a		;+1
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
		ld (ix+70),a		;+2
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
; svprib
; Guarda el nuevo fondo
;-----------------------------------------
GUARDA_Nuevo_fondo
svprib	call gspran          ; HL = pantalla destino, DE = sprite, BC = máscara

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

; -----------------------------------------------------------------------
; check_all_types
; Llama a sktyp para todos los tipos 0..8 o a los menos posibles
; Si encuentra colisión, Carry=1 y skptr apunta al sprite que colisiona
; Si no encuentra colisión, Carry=0
; -----------------------------------------------------------------------
; -----------------------------------------------------------------------
; PASS_COLLISIONS
; Recorre sprtab y marca en (ix+67): 0 = no colisión, 1 = colisión
; No destruye IX al terminar. Usa B como contador.
; -----------------------------------------------------------------------
pass_solapamiento
		call switch_col24x32
        ld   ix,sprtab
        ld   b,NUMSPR			; MEIGA10 2026
pc_loop:
        ld   a,(ix+0)
        inc a
        jr   z,pasa             ; slot vacío → saltar
		push bc
        ;call check_all_types
        call skany
		pop bc
        jr  nc,nohit                    ; Carry=1 si colisiona
        ld   a,1
		jr sihit
nohit	xor a
sihit	ld   (ix+67),a			; solapamiento
pasa	ld   de,TABSIZ
        add  ix,de
        djnz pc_loop
		call switch_col16x16
        ret

check_all_types:
		ld b,0              ; empezamos con tipo 0
loop_types:
		;push bc             
		call sktyp          ; chequea colisiones con sprites de tipo B
		jr c,collision_found  ; si Carry=1 → encontró colisión → salir
		;pop bc         
		inc b               ; siguiente tipo
		ld a,b
		cp 9                ; ¿ya llegamos a 9? *** 9,8,7,6,5,4,3 opcional
		jr nz,loop_types   ; no → seguir
		; si llegamos aquí, no hubo colisión con ningún tipo
		xor a               ; A=0 (opcional)
		ret                 ; Carry=0 -> sin colisión
collision_found:
		;pop bc
		scf                 ; aseguramos Carry=1
		ret                 ; devolvemos con Carry=1 y skptr listo

switch_col16x16
		ld a,16
		ld (colc1a+1),a
		ld (colc1b+1),a
		ld a,31			; 32-6
		ld (colc1b+6),a
		 ;ld a,X
		 ;ld (colc16+2),a
		 ;ld a,Y
		 ;ld (colc1a+7),a
		ret
switch_col24x32
		ld a,22
		ld (colc1a+1),a			; dy 16, mejor 22
		ld a,28
		ld (colc1b+1),a			; dx 24, mejor 28
		ld a,49					; 39 (umbral_x-1)+(umbral_y-1)+1, mejor 22+28-1=49
		ld (colc1b+6),a
		 ;ld a,3
		 ;ld (colc16+2),a
		 ;ld a,4
		 ;ld (colc1a+7),a
		ret

swap_dlpoiters
		xor a
		ld (MASKAGDopt),a
		ret
		
sspr_restore_dlpointers
		ld a,2
		ld (MASKAGDopt),a
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


;-------------------------------------------------
; check_any_Object_24x32 (sin AF', okptr global)
; IN : (dispx),(dispy)
; OUT: Carry=1 si HIT y (okptr)=puntero a sprtab
;      Carry=0 si NO HIT y (okptr)=0
;-------------------------------------------------

Objmasked	defb 0
ObjX		defb 0
ObjY		defb 0
okptr		defw 0

check_any_Object
check_any_Object_24x32:
        ld   hl,sprtab
        ld   b,NUMSPR
loopany_Object:
        ; ---- FILTRO SPRITE INACTIVO ----
        ld   a,(hl)              ; tipo/estado
        cp   255
        jr   z,nextany_Object
        ; ---- leer coords del sprite (X,Y) ----
        push hl
        ld   de,X                ; X = offset dentro de entrada
        add  hl,de
        ld   e,(hl)              ; E = Xsprite
        inc  hl
        ld   d,(hl)              ; D = Ysprite
        pop  hl                  ; HL = base sprite
        ; ---- dx = |dispx - E| ----
        ld   a,(dispx)
        sub  e
        jr   nc,$+3
        neg
        cp   16
        jr   nc,nextany_Object
        ld   c,a                 ; C = abs(dx)
        ; ---- dy = |dispy - D| ----
        ld   a,(dispy)
        sub  d
        jr   nc,$+3
        neg
        cp   16
        jr   nc,nextany_Object
        ; ---- abs(dx)+abs(dy) < 49 ----
        add  a,c
        cp   31
        jr   nc,nextany_Object
        ; HIT: okptr = HL (base sprite)
        ld   (okptr),hl
        scf
        ret
nextany_Object:
        ld   de,TABSIZ
        add  hl,de
        djnz loopany_Object
        ; NO HIT
        ld   hl,0
        ld   (okptr),hl
        or   a                    ; Carry=0
        ret


; ------------------------------------------------------------
; skany: CASI
;   IX = sprite actual
;   OUT: Carry=1 si colisiona con alguno, Carry=0 si no
;   SIDE: marca (candidato+67)=1 cuando encuentra colisión
; ------------------------------------------------------------
ckptr  defw 0

skany	ld hl,sprtab
        ld a,NUMSPR
loop	ex af,af'			;'
        ld (ckptr),hl
        ld a,(hl)
        inc a
        jr z,next
        ld a,h
        cp ixh
        jr nz,check
        ld a,l
        cp ixl
        jr z,next
check	ld de,X
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)

        ld a,(ix+X)
        sub e
        jr nc,xpos
        neg
xpos	cp 22
        jr nc,next
        ld c,a

        ld a,(ix+Y)
        sub d
        jr nc,ypos
        neg
ypos	cp 28
        jr nc,next
        add a,c
        cp 49
        jr nc,next
        ; colisión: marcar candidato
        ld hl,(ckptr)
        ld de,67
        add hl,de
        ld a,1
        ld (hl),a
        scf
        ret
next	ld hl,(ckptr)   ; <-- SIEMPRE volver a base antes de avanzar
        ld de,TABSIZ
        add hl,de
        ex af,af'		;'
        dec a
        jr nz,loop
        or a
        ret
