; User routine for rotational controls.
; To use, set up the angle (0-255) of travel in DIRECTION, then call USER with a single parameter for speed (eg USER 4).
; This routine uses AIRBORNE and JUMPHEIGHT to store fractional coordinates but leaves SETTINGA and SETTINGB free. 
; Jonathan Cauldwell, 22nd October 2020.

       ld b,a                      ; speed in b for now.
       ld (usrspd),a               ; store speed.
       ld l,(ix+13)                ; x fraction.
       ld h,(ix+14)                ; y fraction.
       push hl                     ; store old fractions.
       ld hl,sintab                ; sine table.
       ld e,(ix+10)                ; direction.
       ld d,0                      ; no high byte.
       add hl,de                   ; point to entry.
       ld a,(hl)                   ; get the sine.
       ld (usrsgn),a               ; store sign.
       and 127                     ; remove sign.
       ld h,a                      ; copy to first multiplier.
       ld d,b                      ; get speed.
       call imul                   ; multiply together.
       ld e,(ix+13)                ; x fraction.
       ld d,(ix+8)                 ; x integer.
       ld a,(usrsgn)               ; get sign.
       rla                         ; is it negative?
       jr nc,user0                 ; yes.
       add hl,de                   ; just add.
       jr user1                    ; skip subtraction.
user0  ex de,hl                    ; inertia in hl, force in de.
       sbc hl,de                   ; subtract force.
user1  ld (ix+8),h                 ; set integer.
       ld (ix+13),l                ; set fraction.
       ld a,(ix+10)                ; direction.
       add a,64                    ; shift 90 degrees to get cosine.
       ld e,a                      ; displacement to value.
       ld d,0                      ; no high byte.
       ld hl,sintab                ; sine table.
       add hl,de                   ; point to entry.
       ld a,(hl)                   ; get the cosine.
       ld (usrsgn),a               ; store sign.
       and 127                     ; remove sign.
       ld h,a                      ; copy to first multiplier.
       ld a,(usrspd)               ; get speed.
       ld d,a                      ; second multiplier.
       call imul                   ; multiply together.
       ld e,(ix+14)                ; y fraction.
       ld d,(ix+9)                 ; y integer.
       ld a,(usrsgn)               ; get sign.
       rla                         ; is it negative?
       jr nc,user2                 ; yes.
       add hl,de                   ; just add.
       jr user3                    ; skip subtraction.
user2  ex de,hl                    ; inertia in hl, force in de.
       sbc hl,de                   ; subtract force.
user3  ld (ix+9),h                 ; set integer.
       ld (ix+14),l                ; set fraction.
       ld a,4                      ; displacement.
       add a,h                     ; add to integer.
       ld h,a                      ; set horizontal.
       ld a,(ix+8)                 ; get x.
       add a,4                     ; add displacement.
       ld l,a                      ; copy to second coordinate register.
       ld (dispx),hl               ; set coordinates to find.
       call tstbl                  ; check block.
       ld b,2                      ; cells to test vertically.
       ld de,31                    ; distance between cell lines minus one.
user5  ld a,(hl)                   ; get block there.
       cp WALL                     ; is it a wall?
       jr z,user4                  ; yes, can't move there.
       inc l                       ; next cell.
       ld a,(hl)                   ; get block there.
       cp WALL                     ; is it a wall?
       jr z,user4                  ; yes, can't move there.
       add hl,de                   ; next row down.
       djnz user5                  ; repeat for all rows.
       pop hl                      ; restore old fractions.
       ret
user4  pop hl                      ; restore old fractions.
       ld (ix+13),l                ; reset x.
       ld (ix+14),h                ; reset y.
       ld a,(ix+3)                 ; previous x.
       ld (ix+8),a                 ; restore it.
       ld a,(ix+4)                 ; previous y.
       ld (ix+9),a                 ; restore that too.
       ret


usrsgn defb 0                      ; sign.
usrspd defb 0                      ; speed.
sintab defb 0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45
       defb 48,51,54,57,59,62,65,67,70,73,75,78,80,82,85,87
       defb 89,91,94,96,98,100,102,103,105,107,108,110,112,113,114,116
       defb 117,118,119,120,121,122,123,123,124,125,125,126,126,126,126,126
       defb 127,126,126,126,126,126,125,125,124,123,123,122,121,120,119,118
       defb 117,116,114,113,112,110,108,107,105,103,102,100,98,96,94,91
       defb 89,87,85,82,80,78,75,73,70,67,65,62,59,57,54,51
       defb 48,45,42,39,36,33,30,27,24,21,18,15,12,9,6,3
       defb 128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173
       defb 176,179,182,185,187,190,193,195,198,201,203,206,208,210,213,215
       defb 217,219,222,224,226,228,230,231,233,235,236,238,240,241,242,244
       defb 245,246,247,248,249,250,251,251,252,253,253,254,254,254,254,254
       defb 255,254,254,254,254,254,253,253,252,251,251,250,249,248,247,246
       defb 245,244,242,241,240,238,236,235,233,231,230,228,226,224,222,219
       defb 217,215,213,210,208,206,203,201,198,195,193,190,187,185,182,179
       defb 176,173,170,167,164,161,158,155,152,149,146,143,140,137,134,131
