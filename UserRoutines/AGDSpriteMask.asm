NUMSPR       EQU 32              ; Número total de sprites
TABSIZ       EQU 10              ; Tamaño en bytes de cada entrada de sprite
background:  defs NUMSPR*48      ; Buffer para 48 bytes por sprite


; === Imprimir sprites (pares o impares) ===
; Entrada:
;   IX: apunta a sprtab (pares) o sprtab+TABSIZ (impares)
; Usa:
;   IY: apunta al buffer de fondo del sprite actual

dspr:
    ld b,NUMSPR/2               ; número de sprites en esta pasada (pares/impares)

dspr0:
    push bc                     ; guarda contador de bucle

IF SCROLL = 1
    ld a,(echo)
    and a
    jp nz,dspr5                 ; saltar borrado si scroll activo
ENDIF

    ld a,(ix+0)                 ; tipo del sprite anterior
    inc a
    jr nz,dspr1                 ; sí: estaba activo → restaurar fondo

; Solo nuevo sprite activo
dspr5:
    ld a,(ix+5)                 ; tipo del nuevo sprite
    inc a
    jr nz,dspr3                 ; sí: dibujar sprite

; Ninguno activo → actualizar campos antiguos
dspr2:
    ; === Calcular IY = background + índice * 48 ===
    ld a,NUMSPR/2
    sub b                       ; índice lógico del sprite actual
    ld d,a
    ld hl,background
    rlca                        ; ×2
    rlca                        ; ×4
    add a,d                     ; A = 5D
    rlca                        ; ×10 (5D×2 = 10D)
    ld c,a
    ld b,0
    add hl,bc
    ld iy,hl

    ; === Copiar propiedades nuevas a las viejas ===
    push ix
    pop hl
    ld e,l
    ld d,h
    ld bc,5
    add hl,bc
    ldi
    ldi
    ldi
    ldi
    ldi

    ld c,TABSIZ*2
    add ix,bc                   ; siguiente sprite
    pop bc
    djnz dspr0
    ret

; Sprite anterior activo, nuevo inactivo
dspr1:
    ld a,(ix+5)
    inc a
    jr nz,dspr4                 ; ambos activos → comparar y redibujar

dspr6:
    call sspribg                ; restaurar fondo
    jp dspr2

; Ambos sprites activos → ¿cambios?
dspr4:
    ld a,(ix+4)
    cp (ix+9)
    jr nz,dspr7
    ld a,(ix+3)
    cp (ix+8)
    jr nz,dspr7
    ld a,(ix+2)
    cp (ix+7)
    jr nz,dspr7
    ld a,(ix+1)
    cp (ix+6)
    jp z,dspr2                  ; sin cambios → no redibujar

dspr7:
    call sspribg
    call sspric_masked
    jp dspr2

; Solo nuevo sprite activo
dspr3:
    call sspric_masked
    jp dspr2

; Entrada:
;   HL y DE secundarios: dirección de pantalla y sprite
;   IY: apunta a la zona del buffer (48 bytes)

sspric_masked:
    call gsprad         ; obtiene direcciones antiguas (DE y HL secundarios)
    exx                 ; cambia a secundarios
    call gspran         ; obtiene nuevas direcciones (DE = sprite, HL = pantalla)
    call sspriam        ; aplica máscara y guarda fondo en IY
    call sspriog        ; dibuja sprite encima con OR
    ret
	
; sspriam: sprite máscara AND-negada
; Entrada:
;   HL: pantalla destino (nueva)
;   DE: sprite máscara
;   IY: buffer donde guardar fondo (48 bytes)

sspriam:
    ld a,16
.ss_m_loop:
    push af
    call dline_mask     ; guarda fondo y aplica máscara
    ld de,3
    add iy,de           ; mover a la siguiente línea del buffer (3 bytes)
    pop af
    dec a
    jp nz,.ss_m_loop
    ret

; sspriog: pintar sprite con OR
; Entrada:
;   HL: pantalla destino (nueva)
;   DE: sprite gráfico

sspriog:
    ld a,16
.ss_o_loop:
    push af
    call dline_or
    pop af
    dec a
    jp nz,.ss_o_loop
    ret

dline_or:
    ; === Primer byte (izquierda) ===
    ld a,(de)
    and c
    or (hl)
    ld (hl),a
    inc l
    inc l

    ; === Segundo byte (centro) ===
    ld a,(de)
    and b
    or (hl)
    ld (hl),a
    ; inc l           ; ← omitido como en rutina base AGD

    ; === Tercer byte (derecha) ===
    inc de
    dec l
    ld a,(de)
    or (hl)
    ld (hl),a
    inc de
    dec l

    jp nline

dline_mask:
    ; === Primer byte (izquierda) ===
    ld a,(hl)         ; leer fondo
    ld (iy+0),a       ; guardar en buffer
    ld a,(de)
    and c             ; aplicar máscara lateral derecha
    cpl
    and (hl)
    ld (hl),a
    inc l
    inc l             ; pasar a siguiente byte de pantalla

    ; === Segundo byte (centro) ===
    ld a,(hl)
    ld (iy+1),a
    ld a,(de)
    and b             ; aplicar máscara lateral izquierda
    cpl
    and (hl)
    ld (hl),a
    ; inc l           ; ← este INC L se omite como en dline original

    ; === Tercer byte (derecha) ===
    ld a,(hl)
    ld (iy+2),a
    inc de
    dec l
    ld a,(de)
    cpl
    and (hl)
    ld (hl),a
    inc de
    dec l             ; volver atrás para la siguiente línea

    ; Avanzar una línea vertical (como en dline original)
nline:
    inc h
    ld a,h
    and 7
    ret nz
    ld a,h
    sub 8
    ld h,a
    ld a,l
    add a,32
    ld l,a
    ret nc
    ld a,h
    add a,8
    ld h,a
    cp 88
    ret c
    ld h,56
    ret

sspribg:
    ld a,16
.sspribg_loop:
    push af
    call dline_restore
    ld de,3
    add iy,de          ; siguiente línea de fondo
    pop af
    dec a
    jp nz,.sspribg_loop
    ret

dline_restore:
    ld a,(iy+0)
    ld (hl),a
    inc l
    inc l
    ld a,(iy+1)
    ld (hl),a
    ; inc l          ; omitido (como en AGD original)
    ld a,(iy+2)
    dec l
    ld (hl),a
    dec l
    jp nline          ; avanzar a la siguiente línea vertical

;| Tarea              | Rutina                     |
;| ------------------ | -------------------------- |
;| Mostrar sprite     | sspric_masked              |
;| Aplicar máscara    | sspriam                    |
;| Pintar gráfico     | sspriog                    |
;| Guardar fondo      | dline_mask                 |
;| Restaurar fondo    | sspribg                    |
;| Imprimir 16 líneas | bucle interno en ca rutina |
;| Pintar línea       | dline_or                   |
;| Restaurar línea    | dline_restore              |
