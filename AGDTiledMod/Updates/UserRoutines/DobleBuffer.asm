; ============================================================
; Espera VBlank comienzo de frame
; La ISR debe poner TickFlag = 1
; ============================================================

waitIRQ:
        halt
        ld a,(TickFlag)
        or a
        jr z,waitIRQ
        xor a
        ld (TickFlag),a
        ret

TickFlag    defb 0

; ============================================================
; ZX Spectrum 128K
; Servicio normal / shadow screen
; Siempre deja RAM 0 paginada en $C000
; ============================================================

PORT_7FFD   equ $7FFD
SYS_7FFD    equ 23388

SCREEN_5    equ $4000
SCREEN_7    equ $C000
SCR_SIZE    equ 6912
SCR_GFX_THIRD   equ 2048
SCR_ATTR_THIRD  equ 256

Last7FFD    defb 0
ULAScreen   defb 0       ; 0 = visible RAM5
                         ; 1 = visible RAM7

; ------------------------------------------------------------
; Escribir puerto 7FFD y actualizar copias espejo
; ------------------------------------------------------------

Set7FFD:
        ld (SYS_7FFD),a
        ld (Last7FFD),a
        ld bc,PORT_7FFD
        out (c),a
        ret

; ------------------------------------------------------------
; Mostrar pantalla normal RAM5 y dejar banco 0 en $C000
; ------------------------------------------------------------
SetState_Show5_Bank0
ShowNormal:
        push af
        push bc
        ld a,(SYS_7FFD)
        and %11110000      ; conserva ROM/lock, limpia pantalla y banco
                            ; bit 3 = 0, banco 0
        call Set7FFD
        xor a
        ld (ULAScreen),a
        pop bc
        pop af
        ret

; ------------------------------------------------------------
; Mostrar shadow RAM7 y dejar banco 0 en $C000
; ------------------------------------------------------------
SetState_Show7_Bank0
ShowShadow:
        push af
        push bc
        ld a,(SYS_7FFD)
        and %11110000      ; conserva ROM/lock, limpia pantalla y banco
        or  %00001000      ; bit 3 = 1, banco 0
        call Set7FFD
        ld a,1
        ld (ULAScreen),a
        pop bc
        pop af
        ret

; ------------------------------------------------------------
; Copiar pantalla completa RAM5 -> RAM7
; Copia bitmap + atributos: 6912 bytes
; Al salir deja banco 0 en $C000
; Conserva si estaba visible RAM5 o RAM7
; ------------------------------------------------------------

CopyScreen5ToShadow
		di
        push af
        push bc
        push de
        push hl
        ; Poner RAM7 en $C000
        ; Conserva el bit 3 de pantalla visible
        ld a,(SYS_7FFD)
        and %11111000      ; limpia bits 0-2
        or  %00000111      ; banco 7 en $C000
        call Set7FFD
        ; Copiar pantalla normal a shadow
        ld hl,SCREEN_5
        ld de,SCREEN_7
        ld bc,SCR_SIZE
        ldir
		; Restaurar banco 0 en $C000
        ; Mantiene el bit 3 tal como esté
        ld a,(SYS_7FFD)
        and %11111000      ; banco 0
        call Set7FFD
        pop hl
        pop de
        pop bc
        pop af
		ei
        ret


; ------------------------------------------------------------
; Inicializar buffers
; Copia la pantalla actual de RAM5 a RAM7
; y empieza mostrando shadow
; ------------------------------------------------------------

InitULABuffers:
        di
        call CopyScreen5ToShadow
        ei
        call ShowShadow
        ret


; ------------------------------------------------------------
; Final de frame seguro
; Muestra RAM5 y guarda copia en shadow para el siguiente frame
; ------------------------------------------------------------

FlipBufferSafe
        call ShowNormal
        call CopyScreen5ToShadow
        ret

FlipBufferSafe2
        ld a,(ULAScreen)
        or a
        jr z,to7
to5		call ShowShadow
		ret
to7		call ShowNormal
        call CopyScreen5ToShadow
        ret
		
; ; ============================================================
; ; Ejemplo de bucle principal
; ; ============================================================

; MainLoop:
        ; call waitIRQ

        ; ; Mostrar frame anterior guardado en shadow RAM7
        ; call ShowShadow

        ; ; Dibujar nuevo frame en pantalla normal RAM5/$4000
        ; call DrawFrame

        ; ; Mostrar el frame terminado
        ; call FlipBufferSafe
				;call ShowNormal
				;call CopyScreen5ToShadow

        ; jp MainLoop

; ------------------------------------------------------------
; Copiar primer tercio RAM5 -> RAM7
; Bitmap:    $4000-$47FF  -> $C000-$C7FF
; Atributos: $5800-$58FF  -> $D800-$D8FF
; Al salir deja banco 0 en $C000
; ------------------------------------------------------------

CopyScreen5ToShadow_Third1:
        di
        push af
        push bc
        push de
        push hl

        ld a,(SYS_7FFD)
        and %11111000
        or  %00000111
        call Set7FFD

        ld hl,$4000
        ld de,$C000
        ld bc,SCR_GFX_THIRD
        ldir

        ld hl,$5800
        ld de,$D800
        ld bc,SCR_ATTR_THIRD
        ldir

        ld a,(SYS_7FFD)
        and %11111000
        call Set7FFD

        pop hl
        pop de
        pop bc
        pop af
        ei
        ret


; ------------------------------------------------------------
; Copiar segundo tercio RAM5 -> RAM7
; Bitmap:    $4800-$4FFF  -> $C800-$CFFF
; Atributos: $5900-$59FF  -> $D900-$D9FF
; ------------------------------------------------------------

CopyScreen5ToShadow_Third2:
        di
        push af
        push bc
        push de
        push hl

        ld a,(SYS_7FFD)
        and %11111000
        or  %00000111
        call Set7FFD

        ld hl,$4800
        ld de,$C800
        ld bc,SCR_GFX_THIRD
        ldir

        ld hl,$5900
        ld de,$D900
        ld bc,SCR_ATTR_THIRD
        ldir

        ld a,(SYS_7FFD)
        and %11111000
        call Set7FFD

        pop hl
        pop de
        pop bc
        pop af
        ei
        ret


; ------------------------------------------------------------
; Copiar tercer tercio RAM5 -> RAM7
; Bitmap:    $5000-$57FF  -> $D000-$D7FF
; Atributos: $5A00-$5AFF  -> $DA00-$DAFF
; ------------------------------------------------------------

CopyScreen5ToShadow_Third3:
        di
        push af
        push bc
        push de
        push hl

        ld a,(SYS_7FFD)
        and %11111000
        or  %00000111
        call Set7FFD

        ld hl,$5000
        ld de,$D000
        ld bc,SCR_GFX_THIRD
        ldir

        ld hl,$5A00
        ld de,$DA00
        ld bc,SCR_ATTR_THIRD
        ldir

        ld a,(SYS_7FFD)
        and %11111000
        call Set7FFD

        pop hl
        pop de
        pop bc
        pop af
        ei
        ret

CopyThirdCounter defb 0

FlipBufferSafe_ByThirds:
        ld a,(CopyThirdCounter)
        or a
        jr z,third1

        cp 1
        jr z,third2

third3:
        call CopyScreen5ToShadow_Third3
        xor a
        ld (CopyThirdCounter),a
        call ShowShadow
        ret

third1:
        call CopyScreen5ToShadow_Third1
        ld a,1
        ld (CopyThirdCounter),a
        call ShowShadow
        ret

third2:
        call CopyScreen5ToShadow_Third2
        ld a,2
        ld (CopyThirdCounter),a
        call ShowShadow
        ret
		
		