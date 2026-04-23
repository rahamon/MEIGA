rot_right:
      
      ld hl, 16384 + 31   ; Última columna
      ld b, 8
   loop:
      scf
      ccf
      bit 0, (hl)   ; Compruebo el último píxel
      jr z,nocarry
      scf

   nocarry:      
      push af      ; Grabo el flag de acarreo
      ld a, l
      and %00000   ; Vuelvo a la primera columna
      ld l, a
      pop af      ; Recupero el flag de accarreo

      rr (hl)      
      inc l
      rr (hl)
      inc l
      ; ... 32 veces
      
      inc h   ; Siguiente scanline de la última columna
      djnz loop      
      
      ret
