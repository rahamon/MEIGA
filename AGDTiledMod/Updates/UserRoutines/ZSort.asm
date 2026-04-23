; =========================================================
; Orden: NO colisionan primero (ordenados por X ascendente),
;        luego colisionan (orden relativo estable).
; Usa solo el carry de sktyp (C=1 colisiona, NC no colisiona).
; Mantiene Z/X originales (no reescribe).
; NCol = índice del primer sprite ENCENDIDO que colisiona.
; =========================================================

            ; Externos esperados:
            ; NUMSPR, TABSIZ, sprtab
            ; sktyp: examina el sprite en IX y deja C=1 si colisiona, NC si no.

NCol        defb 0

; ---------------------------------------------------------
; Bubble sort (esqueleto original)
; ---------------------------------------------------------

bsort  ld b,NUMSPR - 1     ; sprites to swap
       ld ix,sprtab        ; sprite table base
bsort0 push bc             ; store loop counter for now

       ld a,(ix+0)         ; first sprite type
       inc a               ; is it switched off?
       jr z,swemp          ; yes, may need to switch another in here

       ld a,(ix+TABSIZ)    ; check next slot exists
       inc a               ; is it enabled?
       jr z,bsort2         ; no, nothing to swap

; ======== Comparación nueva: colisión primero, X si ambos no-col ========
; Regla:
;  - Si A no colisiona y B colisiona -> NO SWAP
;  - Si A colisiona y B no colisiona -> SWAP
;  - Si ambos colisionan -> NO SWAP (estable)
;  - Si ambos NO colisionan -> ordenar por X ascendente (swap si X_B < X_A)
; call check_all_types/ld a,(ix+67)
; jr c,/jr nc,

       ld a,(ix+67)              ; estado A: C=1 colisiona, NC no
	   and a
       jr nz,A_collides     ; si A colisiona, tratamos contra B

; ---- A NO colisiona ----
       ld a,(ix+17)           ; X_A
       ld h,a
       push ix
       ld de,TABSIZ
       add ix,de              ; IX = B
       ld a,(ix+67)              ; estado B
	   and a
       jr nz,A_no_B_yes     ; B colisiona -> no swap
       ; Ambos NO colisionan -> comparar X (ascendente)
       ld   a,(ix+17)           ; X_B
       cp   h                  ; ¿X_B < X_A?
       pop  ix
       jr   c,bsort1          ; sí -> swap
       jr   bsort2             ; no -> no swap
A_no_B_yes:
       pop  ix
       jr   bsort2             ; no swap

; ---- A colisiona ----
A_collides:
       push ix
       ld   de,TABSIZ
       add  ix,de              ; IX = B
       ld a,(ix+67)    ; estado B
       pop  ix
	   and a
       jr   nz,bsort2          ; B también colisiona -> no swap
       jr   bsort1             ; B no colisiona -> swap
; ======== Fin comparación ========

bsort2 ld de,TABSIZ            ; distance to next odd/even entry
       add ix,de               ; next sprite
       pop bc                  ; retrieve loop counter
       djnz bsort0             ; repeat for remaining sprites

       ; Tras ordenar, calcular NCol
       call CalcNCol
       ret

bsort1 ld a,(ix+TABSIZ)        ; sprite on/off flag (en siguiente)
       inc a                   ; is it enabled?
       jr z,bsort2             ; no, nothing to swap
       call swspr              ; swap positions
       jr bsort2

swemp  ld a,(ix+TABSIZ)        ; next table entry
       inc a                   ; is that one on?
       jr z,bsort2             ; no, nothing to swap
       call swspr              ; swap positions
       jr bsort2

; ---------------------------------------------------------
; Swap sprites (sin cambios)
; ---------------------------------------------------------
swspr  push ix                 ; table address on stack
       pop hl
       ld d,h
       ld e,l
       ld bc,TABSIZ            ; distance to second entry
       add hl,bc               ; point to second sprite entry
       ld b,TABSIZ             ; bytes to swap
swspr0 ld c,(hl)               ; fetch second byte
       ld a,(de)               ; fetch first byte
       ld (hl),a               ; copy to second
       ld a,c                  ; second byte in accumulator
       ld (de),a               ; copy to first sprite entry
       inc de                  ; next byte
       inc hl                  ; next byte
       djnz swspr0             ; swap all bytes in table entry
       ret

; ---------------------------------------------------------
; CalcNCol: cuenta encendidos iniciales que NO colisionan
;           (índice del primer encendido que colisiona)
; ---------------------------------------------------------
CalcNCol:
       xor  a
       ld   (NCol),a

       ld   b,NUMSPR
       ld   ix,sprtab
CN_Loop:
       push bc

       ; ¿apagado?
       ld   a,(ix+0)
       inc  a
       jr   z,NexCal            ; apagado: no cuenta ni detiene

       ; encendido: preguntar colisión (solo carry)
       ld	a,(ix+67)              ; C=1 si colisiona
	   and a
       jr	nz,mtch_N            ; primer colisionador -> parar

       ; no colisiona -> NCol++
       ld   a,(NCol)
       inc  a
       ld   (NCol),a

NexCal ld   de,TABSIZ
       add  ix,de
       pop  bc
       djnz CN_Loop
       ret                     ; nadie colisiona: NCol = nº de no-colisionadores

mtch_N pop  bc
       ret

