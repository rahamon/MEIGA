; Fetch block type at (dispx, dispy) y guarda LINE/COLUMN xustas en blockx.
;

tstbl  ld a,(dispx)        ; fetch x coord.
       rlca                ; divide by 8,
       rlca                ; and multiply by 32.
       ld d,a              ; store in d.
       and 224             ; mask off high bits.
       ld e,a              ; low byte.
       ld a,d              ; restore shift result.
       and 3               ; high bits.
       ld d,a              ; got displacement in de.
       ld a,(dispy)        ; y coord.
       rra                 ; divide by 8.
       rra
       rra
       and 31              ; only want 0 - 31.
       add a,e             ; add to displacement.
       ld e,a              ; displacement in de.
       ld hl,MAP           ; position of dummy screen.
       add hl,de           ; point to address (HL xa ten a cela xusta).
       ld a,(hl)           ; fetch byte there.

       ; --- NOVA EXTRACTION PARA BLOCKX (Estilo Paco gtblk) ---
       push af             ; Gardamos o ID do bloque atopado.
       push hl             ; Gardamos o HL actual.
       ld de,MAP           ; Enderezo base do mapa.
       and a               ; Limpa carry.
       sbc hl,de           ; HL = Número de cela lineal (0 a 1023).
       ld a,l              ; Byte baixo da cela.
       and 31              ; A = COLUMNA exacta (0-31).
       ld d,a              ; D = COLUMNA.
       add hl,hl           ; Multiplicamos por 8...
       add hl,hl
       add hl,hl           ; H = FILA EN PÍXELES (múltiplo de 8 exacto).
       ld e,h              ; E = FILA EN PÍXELES.
       ld (blockx),de      ; ¡Gardado! Byte baixo=COLUMNA, Byte alto=FILA_PIX.
       pop hl              ; Recuperamos o HL orixinal.
       pop af              ; Recuperamos o ID do bloque no acumulador.
       ret

blockx  defw 0              ; Gardará (FILA_PIX, COLUMNA) para propósito xeral.

