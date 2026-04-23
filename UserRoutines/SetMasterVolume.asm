; ----------------------------------------
; SetMasterVolume
; A = 0 bajo | 1 medio | 2 alto
; ----------------------------------------

SetMasterVolume:
    cp 0
    jr z,VolLow
    cp 1
    jr z,VolMid
    cp 2
    jr z,VolHigh
    ret

VolLow:
    ld a,4
    jr SetAllChannels

VolMid:
    ld a,8
    jr SetAllChannels

VolHigh:
    ld a,12

; ----------------------------------------
; A = volumen (0–15)
; ----------------------------------------
SetAllChannels:
    ld b,a              ; guardar volumen

    ; Canal A (reg 8)
    ld bc,$FFFD         ; seleccionar registro
    ld a,8
    out (c),a
    ld bc,$BFFD         ; escribir dato
    ld a,b
    out (c),a

    ; Canal B (reg 9)
    ld bc,$FFFD
    ld a,9
    out (c),a
    ld bc,$BFFD
    ld a,b
    out (c),a

    ; Canal C (reg 10)
    ld bc,$FFFD
    ld a,10
    out (c),a
    ld bc,$BFFD
    ld a,b
    out (c),a

    ret

