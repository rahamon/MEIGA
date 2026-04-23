; el programa pinta un objeto call drpob2, para ello busca el primer sprite que
; colisione con la posicion del objeto y lo borra, despues pinta el objeto en
; dicha posicion limpia de sprite para finalmente reponer el sprite.
; Lo hace bien, aun asi me planteo borrar todos los sprites colisionando en la posicion si es que los
; hay, asi que estoy pensando en cambiar check_any_Object para que recorra todos los sprites y si 
; colisiona en vez de devolver el bit de acarreo directamente borre el sprite con RESTAURA_Fondo_NUEVO

; Drop object number at (dispx, dispy).

		ld (Objmasked),a
		; ld a,(dispy)
		; ld (ObjY),a
		; ld a,(dispx)
		; ld (ObjX),a
		ld hl,(dispx)
		ld (ObjX),hl

	; chequea sprite
		call check_any_Object
		jp nc,drpob2
	;->borralo
		ld ix,(skptr)
		call RESTAURA_Fondo_NUEVO
	;pinta Objetos
		call drpob2
	; y pinta esprite
		call PRINT_Sprite
		ret

;------------------------------
;------------------------------
; check_any_Object_24x32: CORRECTA
; Entrada:
;   (dispx),(dispy) = posición a comprobar
; Salida:
;   Carry=1 si encuentra alguien (incluido self)
;   (skptr)=puntero a su entrada en sprtab
;   Carry=0 si no hay nadie, (skptr)=0
;------------------------------
Objmasked	defb 0
ObjX		defb 0
ObjY		defb 0

check_any_Object
check_any_Object_24x32:
        ld hl,sprtab
        ld a,NUMSPR
loopany:
        ex af,af'              ; A' = contador
        ld (skptr),hl          ; por si hay hit, que quede el puntero listo
        ; ---- FILTRO SPRITE INACTIVO ----
        ld a,(hl)              ; tipo/estado
        cp 255
        jr z,next_sprite
        ; ---- leer coords del sprite (X,Y) ----
        push hl
        ld de,X
        add hl,de
        ld e,(hl)              ; E = Xsprite
        inc hl
        ld d,(hl)              ; D = Ysprite
        pop hl
        ; ---- dx = |dispx - E| ----
        ld a,(dispx)
        sub e
        jr nc,$+3
        neg
        cp 28
        jr nc,next_sprite
        ld c,a                 ; C = abs(dx)
        ; ---- dy = |dispy - D| ----
        ld a,(dispy)
        sub d
        jr nc,$+3
        neg
        cp 22
        jr nc,next_sprite
        ; ---- abs(dx)+abs(dy) < 49 ----
        add a,c
        cp 49
        ret c                  ; HIT -> Carry=1, skptr ya apunta
next_sprite:
        ld hl,(skptr)
        ld de,TABSIZ
        add hl,de
        ex af,af'			;'
        dec a
        jp nz,loopany
        ; NO HIT
        ld hl,0
        ld (skptr),hl
        or h
        ret                    ; Carry=0

;GPT 

HITCOUNT    defb 0
HITLIST_MAX equ 16              ; <-- pon aquí NUMSPR si quieres
HitList     defs HITLIST_MAX*2  ; lista de punteros (word) a sprtab

;---------------------------------------------------------
; clear_all_colliding_sprites_24x32
; Entrada:
;   (dispx),(dispy) = posición a comprobar
; Salida:
;   (HITCOUNT) = número de sprites borrados
;   HitList[]  = punteros (HL) a entradas en sprtab borradas
;---------------------------------------------------------
clear_all_colliding_sprites_24x32:
        xor a
        ld (HITCOUNT),a

        ld hl,sprtab
        ld a,NUMSPR
loop:
        ex af,af'                  ; A' = contador

        ; ---- FILTRO SPRITE INACTIVO ----
        ld a,(hl)                  ; tipo/estado
        cp 255
        jr z,next

        ; ---- leer coords del sprite (X,Y) ----
        push hl
        ld de,X
        add hl,de
        ld e,(hl)                  ; E = Xsprite
        inc hl
        ld d,(hl)                  ; D = Ysprite
        pop hl

        ; ---- dx = |dispx - E| ----
        ld a,(dispx)               ; (si dispx es word, aquí usas el low byte)
        sub e
        jr nc,$+3
        neg
        cp 28
        jr nc,next
        ld c,a                     ; C = abs(dx)

        ; ---- dy = |dispy - D| ----
        ld a,(dispy)
        sub d
        jr nc,$+3
        neg
        cp 22
        jr nc,next

        ; ---- abs(dx)+abs(dy) < 49 ----
        add a,c
        cp 49
        jr nc,next                ; si >=49, no hay hit

        ; ===== HIT =====
        ; Guarda puntero HL en HitList si hay hueco
        ld a,(HITCOUNT)
        cp HITLIST_MAX
        jr nc,skip_store           ; si se llena, al menos borra igual (o decide qué hacer)

        ; DE = &HitList[HITCOUNT*2]
        ld e,a
        ld d,0
        add hl,hl                   ; NO! (no queremos tocar HL)
        ; Mejor: calcula DE con una pequeña rutina sin destruir HL:
        ; (lo hacemos abajo con pushes)

        push hl                     ; guarda puntero al sprite (entrada en sprtab)
        ld a,(HITCOUNT)
        ld e,a
        ld d,0
        ld hl,HitList
        add hl,de
        add hl,de                   ; HL = HitList + 2*count
        pop de                      ; DE = puntero sprite (sprtab entry)
        ld (hl),e
        inc hl
        ld (hl),d

        ld a,(HITCOUNT)
        inc a
        ld (HITCOUNT),a

skip_store:
        ; Borra el sprite restaurando fondo
        ; Necesitas IX = puntero a su entrada en sprtab
        push hl
        push de
        pop ix                      ; IX = puntero sprite
        call RESTAURA_Fondo_NUEVO
        pop hl

next:
        ; avanzar a siguiente sprite
        ld de,TABSIZ
        add hl,de

        ex af,af'		;'
        dec a
        jp nz,loop
        ret

;---------------------------------------------------------
; redraw_cleared_sprites
; Entrada:
;   (HITCOUNT), HitList[]
;---------------------------------------------------------
redraw_cleared_sprites:
        ld a,(HITCOUNT)
        or a
        ret z

        ld b,a                      ; B = count
        ld hl,HitList
loop:
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        push hl
        push bc

        push de
        pop ix                      ; IX = puntero sprite
        call PRINT_Sprite

        pop bc
        pop hl
        djnz loop
        ret


; Drop object number at (dispx, dispy).

        ld (Objmasked),a
        ld hl,(dispx)
        ld (ObjX),hl

        ; 1) Borra todos los sprites que colisionan
        call clear_all_colliding_sprites_24x32

        ; 2) Pinta objeto
        call drpob2

        ; 3) Reimprime todos los sprites que quitaste
        call redraw_cleared_sprites
        ret





