
; ===== Espera VBlank comienzo de frame (con ISR player)=====
waitIRQ	halt
		ld a,(TickFlag)
		or a
		jr z,waitIRQ
		xor a
		ld (TickFlag),a
		ret

TickFlag	defb 0

; ------------------------------------------------------------
; VARIABLES
; ------------------------------------------------------------

ULAScreen       defb 0       ; 0 = visible RAM5
                             ; 1 = visible RAM7

Last7FFD        defb 0

; ------------------------------------------------------------
; ESTADOS COMPLETOS
; ------------------------------------------------------------

STATE_SHOW5_BANK0   equ %00000000   ; visible RAM5, banco 0 en C000
STATE_SHOW5_DRAW7   equ %00000111   ; visible RAM5, RAM7 en C000
STATE_SHOW7_BANK0   equ %00001000   ; visible RAM7, banco 0 en C000
STATE_SHOW7_DRAW5   equ %00001000   ; visible RAM7, se dibuja en RAM5 directa

; ------------------------------------------------------------
; SET 7FFD
; A = valor completo del puerto
; ------------------------------------------------------------
Set7FFD
        ld (23388),a
        ld bc,32765
        out (c),a
        ld (Last7FFD),a
        ret

; ------------------------------------------------------------
; ESTADO NORMAL DEL CICLO %00000000, ULAScreen = 0
; visible RAM5, banco 0
; ------------------------------------------------------------
SetState_Show5_Bank0
		ld a,(23388)
		and %11110000      ; conserva bits altos
		or  %00000000      ; banco 0 + show5
		call Set7FFD
		xor a
		ld (ULAScreen),a
		ret
		
SetState_Show5_Bank02
        ld a,STATE_SHOW5_BANK0
        call Set7FFD
        xor a
        ld (ULAScreen),a
        ret

; ------------------------------------------------------------
; ESTADO NORMAL DEL CICLO %00001000, ULAScreen = 1
; visible RAM7, banco 0
; ------------------------------------------------------------
SetState_Show7_Bank0
		ld a,(23388)
		and %11110000
		or  %00001000
		call Set7FFD
		ld a,1
		ld (ULAScreen),a
		ret
		
SetState_Show7_Bank02
        ld a,STATE_SHOW7_BANK0
        call Set7FFD
        ld a,1
        ld (ULAScreen),a
        ret

; ------------------------------------------------------------
; ESTADO DE TRABAJO
; visible RAM5, dibujar en RAM7
; ------------------------------------------------------------
SetState_Show5_Draw7
		ld a,(23388)
		and %11110000
		or  %00000111
		call Set7FFD
		ret
		
SetState_Show5_Draw72
        ld a,STATE_SHOW5_DRAW7
        call Set7FFD
        ret

; ------------------------------------------------------------
; ESTADO DE TRABAJO
; visible RAM7, dibujar en RAM5
; (mismo valor que estado normal)
; ------------------------------------------------------------
SetState_Show7_Draw5
		ld a,(23388)
		and %11110000
		or  %00001000
		call Set7FFD
		ret
		
SetState_Show7_Draw52
        ld a,STATE_SHOW7_DRAW5
        call Set7FFD
        ret

; ------------------------------------------------------------
; INIT
; arranca con visible RAM5 y banco 0
; ------------------------------------------------------------
InitULABuffers
        call InitCopyScreen5To7
		;call SetState_Show5_Bank0
        ret

FlipBufferSafe
		call FlipBuffers
		ret
; ------------------------------------------------------------
; FLIP BUFFERS
; cambia pantalla visible y deja el ciclo en estado NORMAL
; ------------------------------------------------------------
FlipBuffers
        ld a,(ULAScreen)
        or a
        jr z,to7
to5		call SetState_Show5_Bank0
		ret
to7		call CopyScreen5To7
		call SetState_Show7_Bank0
		ret

; ------------------------------------------------------------
; PREPARE VIDEO WRITE
; Activa el estado correcto para escribir en el backbuffer
; justo antes de pintar
; ------------------------------------------------------------
PrepareVideoWrite
        ld a,(ULAScreen)
        or a
        jr z,prep5
prep7
        call SetState_Show7_Draw5
        ret
prep5
        call SetState_Show5_Draw7
        ret
		
; ------------------------------------------------------------
; PREPARE VIDEO READ		
; ------------------------------------------------------------
PrepareSpriteRead
        ld a,(ULAScreen)
        or a
        jr z,show5
show7
        call SetState_Show7_Bank0
        ret
show5
        call SetState_Show5_Bank0
        ret
		
; ------------------------------------------------------------
; FINISH VIDEO WRITE
; Vuelve al estado NORMAL del ciclo conservando visibilidad
; justo despues de pintar
; ------------------------------------------------------------
FinishVideoWrite
        ld a,(ULAScreen)
        or a
        jr z,fin5
fin7
        call SetState_Show7_Bank0
        ret
fin5
        call SetState_Show5_Bank0
        ret

; ------------------------------------------------------------
; FIX HL BACKBUFFER
; HL calculado como si fuese pantalla base 4000/5800
; ------------------------------------------------------------
FixHLBackBuffer
		ld a,(ULAScreen)
        or a
        ret nz				; ULAScreen = 1,
        set 7,h
        ret

; ------------------------------------------------------------
; FIX DE BACKBUFFER
; ------------------------------------------------------------
FixDEBackBuffer
        ld a,(ULAScreen)
        or a
        ret nz
        set 7,d
        ret

; ------------------------------------------------------------
; COPY SCREEN 5 TO 7
; uso ocasional, no por frame
; ------------------------------------------------------------
InitCopyScreen5To7
CopyScreen5To7
        di
        ld a,STATE_SHOW5_DRAW7
        call Set7FFD
        ld hl,$4000
        ld de,$C000
        ld bc,6912
        ldir
        ld a,STATE_SHOW5_BANK0
        call Set7FFD
        ei
        ret	
		
; ------------------------------------------------------------
; COPY SCREEN 7 TO 5
; uso ocasional
; ------------------------------------------------------------
CopyScreen7To5
        di
        ld a,STATE_SHOW5_DRAW7     ; banco 7 en C000 para leer desde C000
        call Set7FFD
        ld hl,$C000
        ld de,$4000
        ld bc,6912
        ldir
        ei
        ret
		