; ============================================================
; Solapamiento sprite vs sprite (IX contra todos)
; usando IX + skptr y llamando a sktyp
; ============================================================

; --- Ajusta estos símbolos a tu proyecto ---
; sprtab:   tabla de sprites
; NUMSPR:   total de slots (tú usas NUMSPR/2)
; TABSIZ:   tamaño de datos por sprite (stride)
; skptr:    variable 16-bit donde apuntas al sprite candidato
; sktyp:    rutina existente: colisión entre IX y (skptr) -> Carry=1 si colisiona


; ------------------------------------------------------------
; pass_solapamiento
;   Recorre todos los sprites activos, para cada uno:
;     - llama skany (IX contra todos)
;     - marca (ix+67)=1 si colisiona con alguno, si no 0
; ------------------------------------------------------------
pass_solapamiento:
        call switch_col24x32

        ld   ix,sprtab
        ld   b,NUMSPR/2           ; MEIGA10 2026

pc_loop:
        ld   a,(ix+0)
        inc  a
        jr   z,pasa               ; slot vacío → saltar

        push bc
        call skany                ; Carry=1 si IX colisiona con algún otro
        pop  bc

        jr   nc,nohit             ; Carry=0 -> no colisión
        ld   a,1
        jr   sihit

nohit:  xor  a

sihit:  ld   (ix+67),a

pasa:
        ld   de,TABSIZ
        add  ix,de
        djnz pc_loop

        call switch_col16x16
        ret


; ------------------------------------------------------------
; skany
;   IN:  IX = sprite actual
;   OUT: Carry=1 si colisiona con alguno, Carry=0 si no
;
;   Recorre sprtab:
;     - salta vacíos
;     - salta si candidato == IX
;     - skptr = candidato
;     - call sktyp
;     - si colisión: marca (candidato+67)=1 y sale con Carry=1
; ------------------------------------------------------------
skany:
        ld   hl,sprtab
        ld   c,NUMSPR/2

skany_loop:
        ; slot vacío -> saltar
        ld   a,(hl+0)
        inc  a
        jr   z,skany_next

        ; saltar si HL == IX (no compararse consigo mismo)
        ld   a,l
        cp   ixl
        jr   nz,skany_check
        ld   a,h
        cp   ixh
        jr   z,skany_next

skany_check:
        ; skptr = HL (sprite candidato)
        ld   (skptr),hl

        ; comprobar colisión usando tu rutina existente
        ; (IX vs (skptr))
        call sktyp
        jr   nc,skany_next

        ; colisión: marcar el candidato (usar skptr por seguridad)
        ld   de,(skptr)
        ex   de,hl
        ld   a,1
        ld   (hl+67),a

        scf
        ret

skany_next:
        ld   de,TABSIZ
        add  hl,de
        dec  c
        jr   nz,skany_loop

        or   a                    ; Carry=0
        ret


; ------------------------------------------------------------
; (Opcional) Tu rutina vieja por tipos (ya no se usa aquí)
; ------------------------------------------------------------
check_all_types:
        ld b,0
loop_types:
        call sktyp
        jr c,collision_found
        inc b
        ld a,b
        cp 9
        jr nz,loop_types
        xor a
        ret
collision_found:
        scf
        ret


; ------------------------------------------------------------
; Switches de umbral (como los tienes)
; ------------------------------------------------------------
switch_col16x16:
        ld a,16
        ld (colc1a+1),a
        ld (colc1b+1),a
        ld a,31                  ; 32-1
        ld (colc1b+6),a
        ret

switch_col24x32:
        ld a,22
        ld (colc1a+1),a          ; dy
        ld a,28
        ld (colc1b+1),a          ; dx
        ld a,49                  ; dy+dx-1
        ld (colc1b+6),a
        ret


; ------------------------------------------------------------
; Datos / variables
; ------------------------------------------------------------

