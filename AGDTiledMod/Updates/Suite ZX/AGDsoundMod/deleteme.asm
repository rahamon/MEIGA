       org 24832


       jp start



WINDOWTOP equ 1
WINDOWLFT equ 1
WINDOWHGT equ 18
WINDOWWID equ 30 ;
MAPWID equ 17
       defb 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
mapdat equ $
       defb 255,255,255,255,255,23,255,255,255,255,255,255,255,12,13,255,255
       defb 255,50,49,48,44,22,21,255,255,255,255,255,255,10,11,255,255
       defb 255,255,255,255,47,20,19,255,255,255,255,255,6,7,8,9,255
       defb 255,255,255,255,46,18,17,16,15,14,1,2,3,4,5,0,255
       defb 255,255,255,255,45,24,25,26,28,29,30,31,32,33,34,35,255
       defb 255,255,255,255,255,255,255,27,255,255,43,42,255,36,37,38,255
       defb 255,255,255,255,255,255,255,255,255,255,255,255,255,39,40,41,255
       defb 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
stmap  defb 63
evnt00 equ $
       xor a
       call 8859
       call ifall
       ld a,255
       cp (ix+11)
       jp nz,a00033
       jp a00121
a00033 ld a,225
       cp (ix+11)
       jp nc,a00075
       ld a,(ix+11)
       dec a
       ld (ix+11),a
       ld a,3
       call animsp
       ret
       jp a00121
a00075 ld a,8
       cp (ix+11)
       jp c,a00121
       jp z,a00121
       ld a,2
       cp (ix+6)
       jp nz,a00121
       ld a,(ix+11)
       dec a
       ld (ix+11),a
       ret
a00121 call skobj
       ld (varobj),a
       ld a,255
       ld hl,varobj
       cp (hl)
       jp z,a00169
       ld a,1
       ld (vara),a
       ld a,12
       call user
       jp a00177
a00169 xor a
       ld (varg),a
a00177 ld a,7
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       xor a
       ld (vara),a
       ld b,3
       call sktyp
       jp nc,a00240
       ld a,1
       ld (vara),a
       jp a00261
a00240 xor a
       cp (ix+13)
       jp nz,a00261
       ld a,1
       ld (vara),a
a00261 ld a,1
       ld (vara),a
       ld a,1
       ld hl,vara
       cp (hl)
       jp nz,a00741
       ld a,4
       cp (ix+6)
       jp z,a00741
       ld a,5
       cp (ix+6)
       jp z,a00741
       ld a,(joyval)
       and 2
       jp z,a00562
       xor a
       ld (ix+12),a
       ld c,2
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       call laddd
       jp nz,a00392
       dec (ix+9)
       dec (ix+9)
       ld a,2
       ld (ix+6),a
       xor a
       ld (ix+7),a
       ld a,3
       ld (ix+10),a
a00392 ld c,2
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       call laddd
       jp nz,a00492
       ld a,2
       cp (ix+6)
       jp nz,a00487
       call cangl
       jp nz,a00487
       ld a,(joyval)
       and 16
       jp z,a00487
       dec (ix+9)
       dec (ix+9)
       ld a,2
       call jump
       xor a
       ld (ix+10),a
       xor a
       ld (ix+6),a
a00487 jp a00558
a00492 xor a
       ld (ix+10),a
       xor a
       ld (ix+6),a
       ld a,(vars)
       ld (loopa),a
a00518 call cangl
       jp nz,a00536
       dec (ix+9)
       dec (ix+9)
a00536 ld hl,loopa
       dec (hl)
       jp nz,a00518
       ld a,1
       call animsp
a00558 jp a00741
a00562 ld a,(joyval)
       and 1
       jp z,a00699
       ld a,1
       ld (ix+10),a
       xor a
       ld (ix+12),a
       call laddd
       jp nz,a00636
       call cangr
       jp nz,a00616
       jp a00632
a00616 ld a,2
       ld (ix+6),a
       xor a
       ld (ix+7),a
a00632 jp a00653
a00636 ld a,1
       ld (ix+6),a
       ld a,1
       call animsp
a00653 ld a,(vars)
       ld (loopa),a
a00662 call cangr
       jp nz,a00681
       inc (ix+9)
       inc (ix+9)
a00681 ld hl,loopa
       dec (hl)
       jp nz,a00662
       jp a00741
a00699 ld a,2
       cp (ix+6)
       jp nz,a00724
       ld a,1
       ld (ix+6),a
       jp a00732
a00724 ld a,20
       call user
a00732 ld a,3
       ld (ix+10),a
a00741 xor a
       cp (ix+6)
       jp nz,a00853
       ld c,10
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       call cangd
       jp nz,a00832
       xor a
       cp (ix+13)
       jp nz,a00832
       call cangl
       jp nz,a00832
       ld a,3
       cp (ix+10)
       jp nz,a00832
       dec (ix+9)
       dec (ix+9)
       ld a,1
       call animsp
a00832 ld c,10
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       jp a00961
a00853 ld a,1
       cp (ix+6)
       jp nz,a00961
       ld c,10
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       call cangd
       jp nz,a00945
       xor a
       cp (ix+13)
       jp nz,a00945
       call cangr
       jp nz,a00945
       ld a,3
       cp (ix+10)
       jp nz,a00945
       inc (ix+9)
       inc (ix+9)
       ld a,1
       call animsp
a00945 ld c,10
       ld a,(ix+9)
       sub c
       ld (ix+9),a
a00961 call laddd
       jp nz,a01043
       ld a,2
       cp (ix+6)
       jp c,a01043
       jp z,a01043
       ld a,2
       ld (ix+6),a
       ld a,3
       cp (ix+10)
       jp z,a01025
       xor a
       ld (ix+7),a
       ld a,3
       ld (ix+10),a
a01025 xor a
       cp (ix+14)
       jp z,a01043
       call gravst
a01043 xor a
       cp (ix+13)
       jp z,a01200
       xor a
       ld hl,vara
       cp (hl)
       jp nz,a01200
       xor a
       cp (ix+10)
       jp nz,a01138
       call cangl
       jp nz,a01107
       dec (ix+9)
       dec (ix+9)
       jp a01134
a01107 ld a,128
       cp (ix+14)
       jp c,a01134
       jp z,a01134
       ld a,3
       ld (ix+10),a
a01134 jp a01200
a01138 ld a,1
       cp (ix+10)
       jp nz,a01200
       call cangr
       jp nz,a01174
       inc (ix+9)
       inc (ix+9)
       jp a01200
a01174 ld a,128
       cp (ix+14)
       jp c,a01200
       jp z,a01200
       ld a,3
       ld (ix+10),a
a01200 xor a
       cp (ix+13)
       jp nz,a01294
       xor a
       cp (ix+14)
       jp nz,a01294
       ld a,2
       cp (ix+6)
       jp c,a01294
       jp z,a01294
       ld a,1
       ld hl,vard
       cp (hl)
       jp nz,a01294
       ld a,(vark)
       call jump
       xor a
       ld (vard),a
       xor a
       ld (ix+12),a
       ld a,60
       ld (sndtyp),a
a01294 ld a,(joyval)
       and 16
       jp z,a01324
       ld a,(vard)
       inc a
       ld (vard),a
       jp a01332
a01324 xor a
       ld (vard),a
a01332 ld a,(joyval)
       and 8
       jp z,a01432
       call laddu
       jp nz,a01427
       ld a,21
       call user
       ld a,2
       ld (ix+10),a
       xor a
       cp (ix+6)
       jp nz,a01392
       ld a,2
       ld (ix+6),a
a01392 call cangu
       jp nz,a01427
       xor a
       call animsp
       dec (ix+8)
       dec (ix+8)
       ld a,1
       ld (ix+11),a
a01427 jp a01462
a01432 call laddd
       jp nz,a01462
       ld a,2
       cp (ix+6)
       jp nz,a01462
       xor a
       ld (ix+7),a
a01462 ld a,(joyval)
       and 4
       jp z,a01627
       xor a
       cp (ix+13)
       jp nz,a01627
       ld a,3
       cp (ix+10)
       jp nz,a01547
       xor a
       cp (ix+6)
       jp nz,a01526
       xor a
       ld (ix+10),a
       jp a01547
a01526 ld a,1
       cp (ix+6)
       jp nz,a01547
       ld a,1
       ld (ix+10),a
a01547 xor a
       cp (ix+10)
       jp nz,a01589
       xor a
       ld (ix+12),a
       ld a,4
       ld (ix+6),a
       ld a,1
       ld (ix+7),a
       jp a01627
a01589 ld a,1
       cp (ix+10)
       jp nz,a01627
       xor a
       ld (ix+12),a
       ld a,5
       ld (ix+6),a
       ld a,1
       ld (ix+7),a
a01627 ld a,(joyval)
       and 4
       jp z,a01692
       call laddd
       jp nz,a01692
       ld a,2
       ld (ix+6),a
       ld a,1
       ld (ix+7),a
       xor a
       ld (ix+12),a
       inc (ix+8)
       inc (ix+8)
       inc (ix+8)
       inc (ix+8)
a01692 ld b,CUSTOM
       call tded
       cp b
       jp nz,a01772
       ld a,5
       cp (ix+6)
       jp nz,a01772
       ld a,1
       cp (ix+10)
       jp nz,a01772
       ld a,1
       ld (ix+7),a
       xor a
       ld (ix+12),a
       ld a,(ix+9)
       inc a
       ld (ix+9),a
       ld a,7
       call animsp
a01772 ld b,CUSTOM
       call tded
       cp b
       jp nz,a01852
       ld a,4
       cp (ix+6)
       jp nz,a01852
       xor a
       cp (ix+10)
       jp nz,a01852
       ld a,1
       ld (ix+7),a
       xor a
       ld (ix+12),a
       ld a,(ix+9)
       dec a
       ld (ix+9),a
       ld a,7
       call animsp
a01852 ld b,CUSTOM
       call tded
       cp b
       jp nz,a01901
       xor a
       cp (ix+6)
       jp nz,a01901
       ld a,(ix+3)
       ld (ix+8),a
       ld a,(ix+4)
       ld (ix+9),a
a01901 ld b,CUSTOM
       call tded
       cp b
       jp nz,a01950
       ld a,1
       cp (ix+6)
       jp nz,a01950
       ld a,(ix+3)
       ld (ix+8),a
       ld a,(ix+4)
       ld (ix+9),a
a01950 ld a,1
       cp (ix+14)
       jp nc,a02060
       ld a,128
       cp (ix+14)
       jp c,a02060
       jp z,a02060
       xor a
       cp (ix+6)
       jp nz,a02014
       ld a,2
       ld (ix+7),a
       xor a
       call animsp
       jp a02060
a02014 ld a,1
       cp (ix+6)
       jp nz,a02047
       ld a,2
       ld (ix+7),a
       xor a
       call animsp
       jp a02060
a02047 ld a,2
       cp (ix+6)
       jp nz,a02060
a02060 ld a,2
       cp (ix+6)
       jp nz,a02096
       call cangl
       jp nz,a02086
       jp a02096
a02086 call cangr
       jp nz,a02096
a02096 ld a,11
       cp (ix+14)
       jp nc,a02149
       ld a,128
       cp (ix+14)
       jp c,a02140
       jp z,a02140
       ld a,1
       ld (ix+11),a
       jp a02149
a02140 ld a,255
       ld (ix+11),a
a02149 xor a
       cp (ix+13)
       jp nz,a02346
       ld a,1
       cp (ix+11)
       jp nz,a02346
       xor a
       cp (ix+6)
       jp nz,a02277
       ld a,13
       ld (ix+6),a
       xor a
       ld (ix+7),a
       ld a,30
       ld (sndtyp),a
       ld a,7
       call 8859
       ld a,(numlif)
       dec a
       ld (numlif),a
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld a,254
       ld (ix+11),a
       jp a02346
a02277 ld a,1
       cp (ix+6)
       jp nz,a02346
       ld a,14
       ld (ix+6),a
       xor a
       ld (ix+7),a
       ld a,20
       ld (sndtyp),a
       ld a,2
       call 8859
       ld a,(numlif)
       dec a
       ld (numlif),a
       ld a,254
       ld (ix+11),a
a02346 ld a,14
       cp (ix+6)
       jp nz,a02372
       ld a,3
       call animsp
       jp a02393
a02372 ld a,13
       cp (ix+6)
       jp nz,a02393
       ld a,3
       call animsp
a02393 ld a,(ix+12)
       inc a
       ld (ix+12),a
       ld a,250
       cp (ix+12)
       jp nc,a02429
       ld a,220
       ld (ix+12),a
a02429 ld a,17
       cp (ix+12)
       jp nc,a02506
       ld a,50
       cp (ix+12)
       jp c,a02506
       jp z,a02506
       xor a
       cp (ix+6)
       jp nz,a02485
       ld a,2
       ld (ix+7),a
       jp a02506
a02485 ld a,1
       cp (ix+6)
       jp nz,a02506
       ld a,2
       ld (ix+7),a
a02506 ld a,(wnbotx)
       cp (ix+8)
       jr z,$+5
       jp nc,a02554
       ld a,(wntopx)
       ld (ix+8),a
       call scrd
       inc (ix+8)
       inc (ix+8)
       ret
       jp a02595
a02554 ld a,(wntopx)
       cp (ix+8)
       jp c,a02595
       ld a,(wnbotx)
       ld (ix+8),a
       call scru
       dec (ix+8)
       dec (ix+8)
       ret
a02595 ld b,DEADLY
       call tded
       cp b
       jp nz,a02642
       ld a,(numlif)
       dec a
       ld (numlif),a
       ld a,20
       ld (sndtyp),a
       ld a,2
       call 8859
a02642 ld a,2
       cp (ix+12)
       jp nz,a02684
       ld a,4
       cp (ix+6)
       jp nz,a02684
       xor a
       ld (ix+6),a
       xor a
       ld (ix+7),a
a02684 ld a,2
       cp (ix+12)
       jp nz,a02726
       ld a,5
       cp (ix+6)
       jp nz,a02726
       ld a,1
       ld (ix+6),a
       xor a
       ld (ix+7),a
a02726 ld a,140
       cp (ix+12)
       jp nz,a02768
       xor a
       cp (ix+6)
       jp nz,a02768
       ld a,6
       ld (ix+6),a
       xor a
       ld (ix+7),a
a02768 ld a,140
       cp (ix+12)
       jp nz,a02811
       ld a,13
       cp (ix+6)
       jp nz,a02811
       ld a,6
       ld (ix+6),a
       xor a
       ld (ix+7),a
a02811 ld a,140
       cp (ix+12)
       jp nz,a02853
       ld a,1
       cp (ix+6)
       jp nz,a02853
       ld a,7
       ld (ix+6),a
       xor a
       ld (ix+7),a
a02853 ld a,140
       cp (ix+12)
       jp nz,a02896
       ld a,14
       cp (ix+6)
       jp nz,a02896
       ld a,7
       ld (ix+6),a
       xor a
       ld (ix+7),a
a02896 ld a,220
       cp (ix+12)
       jp nz,a02956
       ld a,6
       cp (ix+6)
       jp nz,a02935
       ld a,1
       ld (ix+7),a
       jp a02956
a02935 ld a,7
       cp (ix+6)
       jp nz,a02956
       ld a,1
       ld (ix+7),a
a02956 ld a,237
       cp (ix+12)
       jp nz,a03016
       ld a,6
       cp (ix+6)
       jp nz,a02995
       ld a,2
       ld (ix+7),a
       jp a03016
a02995 ld a,7
       cp (ix+6)
       jp nz,a03016
       ld a,2
       ld (ix+7),a
a03016 ld a,(wnlftx)
       cp (ix+9)
       jp c,a03053
       ld a,(wnrgtx)
       ld (ix+9),a
       call scrl
       dec (ix+9)
       dec (ix+9)
a03053 ld a,(wnrgtx)
       cp (ix+9)
       jr z,$+5
       jp nc,a03095
       ld a,(wnlftx)
       ld (ix+9),a
       call scrr
       inc (ix+9)
       inc (ix+9)
a03095 ld a,(ix+9)
       ld (varm),a
       ld a,(ix+8)
       ld (varw),a
       jp grav
evnt01 equ $
       ld a,7
       and 7
       ld c,a
       call cspr
       ld a,8
       cp (ix+9)
       jp nc,b00075
       ld a,3
       call animsp
       ld a,(ix+11)
       ld (loopa),a
b00048 dec (ix+9)
       dec (ix+9)
       ld hl,loopa
       dec (hl)
       jp nz,b00048
       jp b00084
b00075 ld a,228
       ld (ix+9),a
b00084 ld b,0
       call sktyp
       jp nc,b00172
       ld ix,(skptr)
       ld a,4
       cp (ix+6)
       jp nz,b00119
       jp b00167
b00119 ld a,5
       cp (ix+6)
       jp nz,b00136
       jp b00167
b00136 ld a,(numlif)
       dec a
       ld (numlif),a
       ld a,2
       call 8859
       ld a,20
       ld (sndtyp),a
b00167 ld ix,(ogptr)
b00172 ld a,8
       cp (ix+9)
       jp c,b00236
       ld a,3
       ld d,a
       call random
       ld h,a
       call imul
       ld a,h
       ld (varrnd),a
       ld a,(varrnd)
       ld (ix+11),a
       ld a,(ix+11)
       inc a
       ld (ix+11),a
b00236 ld a,2
       and 7
       ld c,a
       call cspr
       ret
evnt02 equ $
       xor a
       cp (ix+10)
       jp nz,c00119
       ld a,11
       ld (ix+6),a
       xor a
       ld (ix+7),a
       call cangl
       jp nz,c00106
       dec (ix+9)
       dec (ix+9)
       ld c,16
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       call cangd
       jp nz,c00085
       ld a,1
       ld (ix+10),a
c00085 ld c,16
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       jp c00115
c00106 ld a,1
       ld (ix+10),a
c00115 jp c00218
c00119 ld a,12
       ld (ix+6),a
       xor a
       ld (ix+7),a
       call cangr
       jp nz,c00210
       inc (ix+9)
       inc (ix+9)
       ld c,16
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       call cangd
       jp nz,c00189
       xor a
       ld (ix+10),a
c00189 ld c,16
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       jp c00218
c00210 xor a
       ld (ix+10),a
c00218 ld a,3
       call animsp
       ld b,0
       call sktyp
       jp nc,c00243
       jp c00243
c00243 ret
evnt03 equ $
       ld a,1
       ld (vara),a
       ld b,2
       call sktyp
       jp nc,d00036
       xor a
       ld (vara),a
       jp d00108
d00036 ld b,4
       call sktyp
       jp nc,d00062
       xor a
       ld (vara),a
       jp d00108
d00062 ld b,0
       call sktyp
       jp nc,d00087
       xor a
       ld (vara),a
       jp d00108
d00087 ld b,3
       call sktyp
       jp nc,d00108
       xor a
       ld (vara),a
d00108 xor a
       ld hl,vara
       cp (hl)
       jp nz,d01058
       ld ix,(skptr)
       ld a,(ix+9)
       ld (chary),a
       ld a,(ix+8)
       ld (charx),a
       ld a,(ix+5)
       ld (varopt),a
       ld ix,(ogptr)
       ld a,(charx)
       cp (ix+8)
       jp nc,d00562
       ld a,(ix+8)
       ld (vara),a
       ld a,(charx)
       ld c,a
       ld a,(vara)
       sub c
       ld (vara),a
       ld a,8
       ld hl,vara
       cp (hl)
       jr z,$+5
       jp nc,d00558
       ld a,(ix+8)
       ld (vara),a
       ld a,(ix+10)
       ld (varb),a
       ld a,(ix+9)
       ld (varc),a
       ld ix,(skptr)
       ld a,(vara)
       ld (ix+8),a
       ld c,12
       ld a,(ix+8)
       sub c
       ld (ix+8),a
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,d00330
       call cangr
       jp nz,d00325
       inc (ix+9)
       inc (ix+9)
d00325 jp d00365
d00330 xor a
       ld hl,varb
       cp (hl)
       jp nz,d00365
       call cangl
       jp nz,d00365
       dec (ix+9)
       dec (ix+9)
d00365 call gravst
       xor a
       ld hl,varopt
       cp (hl)
       jp nz,d00544
       ld a,(joyval)
       and 4
       jp z,d00479
       xor a
       cp (ix+10)
       jp nz,d00441
       xor a
       ld (ix+12),a
       ld a,4
       ld (ix+6),a
       ld a,1
       ld (ix+7),a
       jp d00479
d00441 ld a,1
       cp (ix+10)
       jp nz,d00479
       xor a
       ld (ix+12),a
       ld a,5
       ld (ix+6),a
       xor a
       ld (ix+7),a
d00479 ld a,(joyval)
       and 16
       jp z,d00535
       ld a,2
       cp (ix+6)
       jp c,d00535
       jp z,d00535
       ld c,2
       ld a,(ix+8)
       sub c
       ld (ix+8),a
       ld a,(vark)
       call jump
d00535 ld a,255
       ld (ix+11),a
d00544 ld ix,(ogptr)
       ld a,3
       ld (ix+10),a
d00558 jp d01058
d00562 ld a,(charx)
       ld (vara),a
       ld a,(ix+8)
       ld c,a
       ld a,(vara)
       sub c
       ld (vara),a
       ld a,8
       ld hl,vara
       cp (hl)
       jp c,d01058
       jp z,d01058
       ld a,(chary)
       cp (ix+9)
       jp nc,d00829
       ld a,2
       ld hl,varopt
       cp (hl)
       jp nz,d00664
       ld ix,(skptr)
       xor a
       ld (ix+10),a
       ld ix,(ogptr)
d00664 ld a,4
       ld hl,varopt
       cp (hl)
       jp nz,d00700
       ld ix,(skptr)
       xor a
       ld (ix+10),a
       ld ix,(ogptr)
d00700 call cangr
       jp nz,d00805
       ld c,2
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       ld b,CUSTOM
       call tded
       cp b
       jp nz,d00767
       ld ix,(skptr)
       dec (ix+9)
       dec (ix+9)
       ld ix,(ogptr)
       jp d00785
d00767 inc (ix+9)
       inc (ix+9)
       ld a,1
       ld (ix+10),a
d00785 ld c,2
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       jp d00825
d00805 ld ix,(skptr)
       dec (ix+9)
       dec (ix+9)
       ld ix,(ogptr)
d00825 jp d01058
d00829 ld a,(chary)
       cp (ix+9)
       jp c,d01049
       jp z,d01049
       ld a,2
       ld hl,varopt
       cp (hl)
       jp nz,d00884
       ld ix,(skptr)
       ld a,1
       ld (ix+10),a
       ld ix,(ogptr)
d00884 ld a,4
       ld hl,varopt
       cp (hl)
       jp nz,d00920
       ld ix,(skptr)
       ld a,1
       ld (ix+10),a
       ld ix,(ogptr)
d00920 call cangl
       jp nz,d01025
       ld c,2
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       ld b,CUSTOM
       call tded
       cp b
       jp nz,d00987
       ld ix,(skptr)
       inc (ix+9)
       inc (ix+9)
       ld ix,(ogptr)
       jp d01004
d00987 dec (ix+9)
       dec (ix+9)
       xor a
       ld (ix+10),a
d01004 ld c,2
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       jp d01044
d01025 ld ix,(skptr)
       inc (ix+9)
       inc (ix+9)
       ld ix,(ogptr)
d01044 jp d01058
d01049 inc (ix+9)
       inc (ix+9)
d01058 ld a,3
       cp (ix+10)
       jp nz,d01093
       ld a,2
       cp (ix+11)
       jp nz,d01093
       ld a,(varb)
       ld (ix+10),a
d01093 ld c,10
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       call cangd
       jp nz,d01172
       xor a
       cp (ix+13)
       jp nz,d01172
       call cangl
       jp nz,d01163
       dec (ix+9)
       dec (ix+9)
       xor a
       ld (ix+10),a
       jp d01172
d01163 ld a,1
       ld (ix+10),a
d01172 ld c,10
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       ld c,10
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       call cangd
       jp nz,d01267
       xor a
       cp (ix+13)
       jp nz,d01267
       call cangr
       jp nz,d01259
       inc (ix+9)
       inc (ix+9)
       ld a,1
       ld (ix+10),a
       jp d01267
d01259 xor a
       ld (ix+10),a
d01267 ld c,10
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       ld a,2
       cp (ix+11)
       jp nz,d01389
       ld a,1
       cp (ix+10)
       jp nz,d01345
       call cangr
       jp nz,d01333
       inc (ix+9)
       inc (ix+9)
       jp d01341
d01333 xor a
       ld (ix+10),a
d01341 jp d01389
d01345 xor a
       cp (ix+10)
       jp nz,d01389
       call cangl
       jp nz,d01381
       dec (ix+9)
       dec (ix+9)
       jp d01389
d01381 ld a,1
       ld (ix+10),a
d01389 call ifall
       jp grav
evnt04 equ $
       ld a,7
       and 7
       ld c,a
       call cspr
       xor a
       cp (ix+10)
       jp nz,e00134
       ld a,15
       ld (ix+6),a
       xor a
       ld (ix+7),a
       call cangl
       jp nz,e00121
       dec (ix+9)
       dec (ix+9)
       ld c,16
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       call cangd
       jp nz,e00100
       ld a,1
       ld (ix+10),a
e00100 ld c,16
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       jp e00129
e00121 ld a,1
       ld (ix+10),a
e00129 jp e00232
e00134 ld a,16
       ld (ix+6),a
       xor a
       ld (ix+7),a
       call cangr
       jp nz,e00224
       inc (ix+9)
       inc (ix+9)
       ld c,16
       ld a,(ix+9)
       add a,c
       ld (ix+9),a
       call cangd
       jp nz,e00203
       xor a
       ld (ix+10),a
e00203 ld c,16
       ld a,(ix+9)
       sub c
       ld (ix+9),a
       jp e00232
e00224 xor a
       ld (ix+10),a
e00232 ld a,3
       call animsp
       ld b,0
       call sktyp
       jp nc,e00270
       ld a,2
       call 8859
       ld a,20
       ld (sndtyp),a
e00270 ld a,2
       and 7
       ld c,a
       call cspr
       ret
evnt05 equ $
       ld a,255
       cp (ix+12)
       jp nz,f00085
       ld a,3
       ld d,a
       call random
       ld h,a
       call imul
       ld a,h
       ld (varrnd),a
       ld a,(varrnd)
       ld (ix+7),a
       ld a,(varrnd)
       ld (ix+12),a
       ld a,(ix+12)
       rrca
       rrca
       and 192
       ld (ix+12),a
f00085 ld a,(ix+12)
       dec a
       ld (ix+12),a
       xor a
       cp (ix+12)
       jp nz,f00200
       ld a,17
       cp (ix+6)
       jp nz,f00184
       ld a,19
       ld (ix+6),a
       ld a,2
       ld (ix+7),a
       ld a,128
       ld d,a
       call random
       ld h,a
       call imul
       ld a,h
       ld (varrnd),a
       ld a,(varrnd)
       ld (ix+12),a
       jp f00200
f00184 ld a,17
       ld (ix+6),a
       xor a
       ld (ix+7),a
f00200 ld a,17
       cp (ix+6)
       jp nz,f00221
       ld a,3
       call animsp
f00221 ret
evnt06 equ $
       ld a,7
       and 7
       ld c,a
       call cspr
       xor a
       cp (ix+11)
       jp nz,g00082
       call cangu
       jp nz,g00070
       dec (ix+8)
       dec (ix+8)
       ld a,18
       ld (ix+6),a
       ld a,1
       ld (ix+7),a
       jp g00078
g00070 ld a,1
       ld (ix+11),a
g00078 jp g00139
g00082 call cangd
       jp nz,g00131
       inc (ix+8)
       inc (ix+8)
       inc (ix+8)
       inc (ix+8)
       ld a,18
       ld (ix+6),a
       xor a
       ld (ix+7),a
       jp g00139
g00131 xor a
       ld (ix+11),a
g00139 ld a,3
       call animsp
       ld b,0
       call sktyp
       jp nc,g00194
       ld c,2
       ld a,(numlif)
       sub c
       ld (numlif),a
       ld a,2
       call 8859
       ld a,20
       ld (sndtyp),a
g00194 ld a,2
       and 7
       ld c,a
       call cspr
       ret
evnt07 equ $
       ld a,(varm)
       ld (vara),a
       ld c,16
       ld a,(vara)
       add a,c
       ld (vara),a
       ld a,(ix+9)
       ld hl,vara
       cp (hl)
       jp nc,h00182
       ld a,(ix+9)
       ld c,a
       ld a,(vara)
       sub c
       ld (vara),a
       ld a,32
       ld hl,vara
       cp (hl)
       jp c,h00168
       jp z,h00168
       ld a,255
       cp (ix+11)
       jp nz,h00164
       ld a,8
       ld (vark),a
       ld a,(vari)
       ld (vara),a
       ld a,(vara)
       add a,a
       ld (vara),a
       ld a,(vara)
       ld c,a
       ld a,(vark)
       add a,c
       ld (vark),a
       xor a
       ld (ix+11),a
h00164 jp h00177
h00168 ld a,255
       ld (ix+11),a
h00177 jp h00191
h00182 ld a,255
       ld (ix+11),a
h00191 ld a,255
       cp (ix+11)
       jp nz,h00254
       ld a,8
       ld (vark),a
       ld a,(varv)
       ld c,a
       ld a,(vark)
       sub c
       ld (vark),a
       ld a,2
       call gotob
       jp c,h00254
       ld a,8
       ld (vark),a
h00254 xor a
       cp (ix+11)
       jp nz,h00279
       xor a
       call animsp
       jp h00288
h00279 ld a,7
       call animsp
h00288 ld a,2
       cp (ix+7)
       jp nz,h00308
       xor a
       ld (ix+7),a
h00308 ret
evnt08 equ $
       ld a,(scno)
       ld (vara),a
       ld a,27
       call user
       ld a,2
       ld (varopt),a
       ld a,17
       call user
       ld a,(vara)
       ld (ix+11),a
       ld a,1
       cp (ix+11)
       jp nc,i00117
       ld a,255
       cp (ix+11)
       jp z,i00117
       ld a,(ix+9)
       ld h,a
       ld a,(ix+8)
       ld l,a
       ld (dispx),hl
       ld a,(ix+11)
       call drpob
       ld (ix+5),255
       ret
       jp i00117
i00117 ld (ix+5),255
       ret
       ret
evnt09 equ $
       xor a
       cp (ix+5)
       jp nz,j00090
       ld a,32
       ld hl,scno
       cp (hl)
       jp nz,j00057
       ld a,14
       ld (ix+6),a
       xor a
       ld (ix+7),a
       ld a,3
       call animsp
j00057 ld a,12
       ld (varq),a
       ld a,13
       ld (varr),a
       ld a,2
       ld (vara),a
       ld a,12
       call user
j00090 ld a,3
       cp (ix+5)
       jp nz,j00112
       ld a,3
       ld (ix+11),a
j00112 ld a,8
       cp (ix+5)
       jp nz,j00132
       ld a,16
       call user
j00132 ld a,1
       cp (ix+5)
       jp nz,j00197
       ld a,3
       ld d,a
       call random
       ld h,a
       call imul
       ld a,h
       ld (varrnd),a
       ld a,(varrnd)
       ld (ix+11),a
       ld a,(ix+11)
       inc a
       ld (ix+11),a
j00197 ld a,20
       ld (vara),a
       ld a,23
       call user
       ld a,2
       cp (ix+5)
       jp nz,j00243
       ld a,21
       ld (vara),a
       ld a,23
       call user
j00243 ret
evnt10 equ $
       ld hl,3840
       ld (charx),hl
       xor a
       ld hl,varu
       cp (hl)
       jp nz,k00037
       ld a,64
       call dmsg
k00037 ld a,1
       ld hl,varu
       cp (hl)
       jp nz,k00062
       ld a,65
       call dmsg
k00062 ld hl,3841
       ld (charx),hl
       ld a,(varz)
       ld bc,displ0
       call num2td
       call displ1
       ld a,99
       ld hl,numlif
       cp (hl)
       jp nc,k00162
       ld a,4
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,535
       ld (charx),hl
       ld a,(numlif)
       call disply
       jp k00344
k00162 ld a,100
       ld hl,numlif
       cp (hl)
       jp c,k00344
       jp z,k00344
       ld a,9
       ld hl,numlif
       cp (hl)
       jp nc,k00264
       ld a,4
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,535
       ld (charx),hl
       ld a,66
       call dmsg
       ld a,(numlif)
       call disply
       jp k00344
k00264 ld a,10
       ld hl,numlif
       cp (hl)
       jp c,k00344
       jp z,k00344
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,535
       ld (charx),hl
       ld a,67
       call dmsg
       ld a,(numlif)
       call disply
k00344 ld a,1
       ld hl,numlif
       cp (hl)
       jp c,k00375
       jp z,k00375
       ld hl,gamwon
       ld (hl),h
k00375 xor a
       ld hl,varp
       cp (hl)
       jp nz,k00646
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,790
       ld (charx),hl
       ld bc,814
       call iscrly
       ld a,6
       ld (vara),a
       call 24835
       ld a,38
       ld hl,scno
       cp (hl)
       jp nc,k00521
       ld hl,3840
       ld (charx),hl
       ld a,68
       call dmsg
       ld a,39
       ld (varb),a
       ld a,5
       ld (varu),a
       ld a,3
       ld (vara),a
       call 24835
       jp k00637
k00521 ld a,20
       ld hl,scno
       cp (hl)
       jp nc,k00590
       ld hl,3840
       ld (charx),hl
       ld a,69
       call dmsg
       ld a,21
       ld (varb),a
       ld a,18
       ld (varu),a
       ld a,2
       ld (vara),a
       call 24835
       jp k00637
k00590 ld hl,3840
       ld (charx),hl
       ld a,70
       call dmsg
       xor a
       ld (varb),a
       ld a,21
       ld (varu),a
       ld a,1
       ld (vara),a
       call 24835
k00637 ld a,255
       ld (varp),a
k00646 ret
evnt11 equ $
       ld hl,2304
       ld (charx),hl
       ld a,(varn)
       ld bc,displ0
       call num2dd
       call displ1
       ld hl,0
       ld (charx),hl
       ld a,(scno)
       ld bc,displ0
       call num2dd
       call displ1
       ld a,(varj)
       inc a
       ld (varj),a
       ld a,1
       ld hl,varj
       cp (hl)
       jp nz,l00138
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,1300
       ld (charx),hl
       ld a,49
       call dmsg
l00138 ld a,25
       ld hl,varj
       cp (hl)
       jp nc,l00223
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,1300
       ld (charx),hl
       ld a,50
       call dmsg
       xor a
       ld (varj),a
       ld a,(vart)
       inc a
       ld (vart),a
l00223 xor a
       ld (vara),a
       xor a
       ld hl,vart
       cp (hl)
       jp nz,l00287
       ld hl,1536
       ld (charx),hl
       ld a,71
       call dmsg
       ld a,20
       ld (vara),a
       ld a,1
       ld (vart),a
       jp l00787
l00287 ld a,64
       ld hl,vart
       cp (hl)
       jp nz,l00511
       ld hl,1536
       ld (charx),hl
       ld a,72
       call dmsg
       ld a,21
       ld (vara),a
       ld a,(vara)
       ld (varopt),a
       call silenc
       push ix
       ld b,2
       call delay
       pop ix
       ld a,5
       ld (vara),a
       call 24835
       ld a,1
       ld (varrnd),a
       ld a,100
       call user
       ld a,5
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld a,1
       rla
       rla
       rla
       and 56
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 199
       or c
       ld (hl),a
       ld a,56
       ld (vara),a
       xor a
       ld (varb),a
       ld a,18
       call user
       ld a,(varopt)
       ld (vara),a
       call redraw
       ld a,65
       ld (vart),a
       jp l00787
l00511 ld a,127
       ld hl,vart
       cp (hl)
       jp nz,l00567
       ld hl,1536
       ld (charx),hl
       ld a,73
       call dmsg
       ld a,22
       ld (vara),a
       ld a,128
       ld (vart),a
       jp l00787
l00567 ld a,191
       ld hl,vart
       cp (hl)
       jp nz,l00787
       ld hl,1536
       ld (charx),hl
       ld a,74
       call dmsg
       ld a,23
       ld (vara),a
       ld a,(vara)
       ld (varopt),a
       call silenc
       push ix
       ld b,2
       call delay
       pop ix
       ld a,4
       ld (vara),a
       call 24835
       ld a,1
       ld (varrnd),a
       ld a,100
       call user
       ld a,5
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld a,1
       rla
       rla
       rla
       and 56
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 199
       or c
       ld (hl),a
       ld a,56
       ld (vara),a
       xor a
       ld (varb),a
       ld a,18
       call user
       ld a,(varopt)
       ld (vara),a
       call redraw
       ld a,192
       ld (vart),a
l00787 xor a
       ld hl,vara
       cp (hl)
       jp nc,l01437
       ld a,(vart)
       inc a
       ld (vart),a
       ld a,23
       ld hl,vara
       cp (hl)
       jp nc,l00842
       ld a,20
       ld (vara),a
l00842 ld a,(vara)
       ld l,a
       xor a
       ld h,a
       ld (charx),hl
       ld hl,chgfx
       ld (grbase),hl
       ld hl,(charx)
       ld (dispx),hl
       ld a,120
       call pattr
       ld hl,(dispx)
       ld (charx),hl
       ld a,(vara)
       ld l,a
       ld a,1
       ld h,a
       ld (charx),hl
       ld hl,chgfx
       ld (grbase),hl
       ld hl,(charx)
       ld (dispx),hl
       ld a,121
       call pattr
       ld hl,(dispx)
       ld (charx),hl
       ld a,(vara)
       inc a
       ld (vara),a
       ld a,23
       ld hl,vara
       cp (hl)
       jp nc,l01001
       ld a,20
       ld (vara),a
l01001 ld a,(vara)
       ld l,a
       xor a
       ld h,a
       ld (charx),hl
       ld hl,chgfx
       ld (grbase),hl
       ld hl,(charx)
       ld (dispx),hl
       ld a,124
       call pattr
       ld hl,(dispx)
       ld (charx),hl
       ld a,(vara)
       ld l,a
       ld a,1
       ld h,a
       ld (charx),hl
       ld hl,chgfx
       ld (grbase),hl
       ld hl,(charx)
       ld (dispx),hl
       ld a,125
       call pattr
       ld hl,(dispx)
       ld (charx),hl
       ld a,(vara)
       inc a
       ld (vara),a
       ld a,23
       ld hl,vara
       cp (hl)
       jp nc,l01159
       ld a,20
       ld (vara),a
l01159 ld a,(vara)
       ld l,a
       xor a
       ld h,a
       ld (charx),hl
       ld hl,chgfx
       ld (grbase),hl
       ld hl,(charx)
       ld (dispx),hl
       ld a,122
       call pattr
       ld hl,(dispx)
       ld (charx),hl
       ld a,(vara)
       ld l,a
       ld a,1
       ld h,a
       ld (charx),hl
       ld hl,chgfx
       ld (grbase),hl
       ld hl,(charx)
       ld (dispx),hl
       ld a,84
       call pattr
       ld hl,(dispx)
       ld (charx),hl
       ld a,(vara)
       inc a
       ld (vara),a
       ld a,23
       ld hl,vara
       cp (hl)
       jp nc,l01317
       ld a,20
       ld (vara),a
l01317 ld a,(vara)
       ld l,a
       xor a
       ld h,a
       ld (charx),hl
       ld hl,chgfx
       ld (grbase),hl
       ld hl,(charx)
       ld (dispx),hl
       ld a,83
       call pattr
       ld hl,(dispx)
       ld (charx),hl
       ld a,(vara)
       ld l,a
       ld a,1
       ld h,a
       ld (charx),hl
       ld hl,chgfx
       ld (grbase),hl
       ld hl,(charx)
       ld (dispx),hl
       ld a,104
       call pattr
       ld hl,(dispx)
       ld (charx),hl
l01437 ret
evnt12 equ $
       call cls
       xor a
       call 8859
       xor a
       rla
       rla
       rla
       and 56
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 199
       or c
       ld (hl),a
       ld a,7
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld a,1
       ld (vara),a
       call 24838
       ld a,1
       ld (varrnd),a
       ld a,100
       call user
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld a,71
       ld (23693),a
       ld a,99
       ld (contrl),a
m00161 ld a,99
       ld hl,contrl
       cp (hl)
       jp nz,m00909
       ld a,(vark)
       inc a
       ld (vark),a
       ld a,200
       ld hl,vark
       cp (hl)
       jp nz,m00229
       ld a,(varj)
       inc a
       ld (varj),a
       xor a
       ld (vark),a
m00229 ld a,6
       ld hl,varj
       cp (hl)
       jp nz,m00294
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,6404
       ld (charx),hl
       ld a,50
       call dmsg
m00294 ld a,14
       ld hl,varj
       cp (hl)
       jp nz,m00367
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,6404
       ld (charx),hl
       ld a,49
       call dmsg
       ld a,1
       ld (varj),a
m00367 ld a,(keys+7)
       call ktest
       jp c,m00390
       xor a
       ld (contrl),a
m00390 ld a,(keys+8)
       call ktest
       jp c,m00413
       ld a,1
       ld (contrl),a
m00413 ld a,(keys+9)
       call ktest
       jp c,m00437
       ld a,2
       ld (contrl),a
m00437 ld a,(keys+10)
       call ktest
       jp c,m00905
m00451 ld a,(keys+10)
       call ktest
       jp c,m00470
       jp m00451
m00470 ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld hl,3086
       ld (charx),hl
       ld a,57
       call dmsg
       ld a,90
       ld (sndtyp),a
       call 654
       inc e
       jr z,$-4
       ld hl,keys+1
       dec e
       ld (hl),e
       call debkey
       ld hl,3086
       ld (charx),hl
       ld a,58
       call dmsg
       ld a,82
       ld (sndtyp),a
       call 654
       inc e
       jr z,$-4
       ld hl,keys+0
       dec e
       ld (hl),e
       call debkey
       ld hl,3086
       ld (charx),hl
       ld a,59
       call dmsg
       ld a,74
       ld (sndtyp),a
       call 654
       inc e
       jr z,$-4
       ld hl,keys+3
       dec e
       ld (hl),e
       call debkey
       ld hl,3086
       ld (charx),hl
       ld a,60
       call dmsg
       ld a,66
       ld (sndtyp),a
       call 654
       inc e
       jr z,$-4
       ld hl,keys+2
       dec e
       ld (hl),e
       call debkey
       ld hl,3086
       ld (charx),hl
       ld a,61
       call dmsg
       ld a,58
       ld (sndtyp),a
       call 654
       inc e
       jr z,$-4
       ld hl,keys+4
       dec e
       ld (hl),e
       call debkey
       ld hl,3086
       ld (charx),hl
       ld a,62
       call dmsg
       ld a,50
       ld (sndtyp),a
       call 654
       inc e
       jr z,$-4
       ld hl,keys+5
       dec e
       ld (hl),e
       call debkey
       ld hl,3086
       ld (charx),hl
       ld a,63
       call dmsg
       ld a,40
       ld (sndtyp),a
       call 654
       inc e
       jr z,$-4
       ld hl,keys+5
       dec e
       ld (hl),e
       call debkey
       ld hl,3086
       ld (charx),hl
       ld a,75
       call dmsg
m00905 jp m00161
m00909 call cls
       ret
evnt13 equ $
       ld a,100
       ld (numlif),a
       xor a
       ld (varg),a
       xor a
       ld (vari),a
       xor a
       ld (varj),a
       ld a,6
       ld (vark),a
       ld a,255
       ld (varm),a
       xor a
       ld (varo),a
       ld a,255
       ld hl,varp
       cp (hl)
       jp z,n00086
       xor a
       ld (varp),a
n00086 ld a,12
       ld (varq),a
       ld a,13
       ld (varr),a
       ld a,1
       ld (vars),a
       xor a
       ld (vart),a
       ld a,1
       ld (varv),a
       ld a,2
       ld (vara),a
       call 24838
       ld a,5
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld a,1
       rla
       rla
       rla
       and 56
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 199
       or c
       ld (hl),a
       ld a,56
       ld (vara),a
       xor a
       ld (varb),a
       ld a,18
       call user
       ld a,7
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       xor a
       rla
       rla
       rla
       and 56
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 199
       or c
       ld (hl),a
       xor a
       ld (vara),a
       ld a,1
       ld (varb),a
       ld a,18
       call user
       ld a,1
       ld (varopt),a
       ld a,17
       call user
       ld a,3
       ld (varopt),a
       ld a,17
       call user
       ld h,255
       ld (rptr13),hl
       ld a,4
       ld (loopa),a
n00378 call read13
       ld (varb),a
       ld a,(varb)
       ld (vara),a
       ld a,27
       call user
       ld a,40
       ld (vara),a
       ld a,25
       call user
       ld hl,loopa
       dec (hl)
       jp nz,n00378
       ld h,255
       ld (rptr13),hl
       ld a,12
       ld d,a
       call random
       ld h,a
       call imul
       ld a,h
       ld (varrnd),a
       ld a,(varrnd)
       ld (vara),a
       ld c,5
       ld a,(vara)
       add a,c
       ld (vara),a
       ld a,(vara)
       ld (loopa),a
n00510 call read13
       ld (varb),a
       ld hl,loopa
       dec (hl)
       jp nz,n00510
       ld a,(varb)
       ld (vara),a
       ld a,27
       call user
       ld a,36
       ld (vara),a
       ld a,25
       call user
       call read13
       ld (varb),a
       ld a,(varb)
       ld (vara),a
       ld a,27
       call user
       ld a,42
       ld (vara),a
       ld a,25
       call user
       call read13
       ld (varb),a
       ld a,(varb)
       ld (vara),a
       ld a,27
       call user
       ld a,37
       ld (vara),a
       ld a,25
       call user
       call read13
       ld (varb),a
       ld a,(varb)
       ld (vara),a
       ld a,27
       call user
       ld a,42
       ld (vara),a
       ld a,25
       call user
       call read13
       ld (varb),a
       ld a,(varb)
       ld (vara),a
       ld a,27
       call user
       ld a,38
       ld (vara),a
       ld a,25
       call user
       call read13
       ld (varb),a
       ld a,(varb)
       ld (vara),a
       ld a,27
       call user
       ld a,42
       ld (vara),a
       ld a,25
       call user
       call read13
       ld (varb),a
       ld a,(varb)
       ld (vara),a
       ld a,27
       call user
       ld a,39
       ld (vara),a
       ld a,25
       call user
       ret
rptr13 defw rdat13
rdat13 defb 1,5,13,36,24,25,23,12,30,50,21
       defb 11,47,8,9,46,18,3,0,32,35,42
       defb 40
read13 ld hl,(rptr13)
       ld de,rdat13+23
       scf
       ex de,hl
       sbc hl,de
       ex de,hl
       jr nc,$+5
       ld hl,rdat13
       ld a,(hl)
       inc hl
       ld (rptr13),hl
       ret
       ret
evnt14 equ $
       call silenc
       push ix
       ld b,2
       call delay
       pop ix
       ld a,255
       ld hl,varp
       cp (hl)
       jp nz,o00237
       ld a,38
       ld hl,scno
       cp (hl)
       jp nc,o00109
       ld hl,3840
       ld (charx),hl
       ld a,76
       call dmsg
       ld a,39
       ld (varb),a
       ld a,5
       ld (varu),a
       ld a,3
       ld (vara),a
       call 24835
       jp o00224
o00109 ld a,20
       ld hl,scno
       cp (hl)
       jp nc,o00177
       ld hl,3840
       ld (charx),hl
       ld a,77
       call dmsg
       ld a,21
       ld (varb),a
       ld a,18
       ld (varu),a
       ld a,2
       ld (vara),a
       call 24835
       jp o00224
o00177 ld hl,3840
       ld (charx),hl
       ld a,78
       call dmsg
       xor a
       ld (varb),a
       ld a,21
       ld (varu),a
       ld a,1
       ld (vara),a
       call 24835
o00224 ld a,34
       ld (vara),a
       call 24835
o00237 call silenc
       xor a
       ld (varg),a
       ld a,15
       call user
       xor a
       ld hl,vara
       cp (hl)
       jp nz,o00275
o00275 xor a
       ld (vara),a
       ld a,22
       call user
       ld a,4
       ld hl,vara
       cp (hl)
       jp nc,o00315
       ld a,16
       call user
o00315 ld a,(scno)
       ld (vara),a
       ld a,27
       call user
       ld a,2
       ld (varopt),a
       ld a,17
       call user
       ld hl,1280
       ld (charx),hl
       ld a,(vara)
       call disply
       xor a
       ld hl,vara
       cp (hl)
       jp nz,o00419
       ld a,(scno)
       ld (vara),a
       ld a,27
       call user
       ld a,1
       ld (vara),a
       ld a,25
       call user
o00419 ret
evnt15 equ $
       ret
evnt16 equ $
       ret
evnt17 equ $
       call cls
       ret
evnt18 equ $
       ld a,29
       call user
       ret
evnt19 equ $
       xor a
       ld hl,varopt
       cp (hl)
       jp nz,t00042
       ld hl,0
       ld (charx),hl
       ld a,79
       call dmsg
       call prskey
t00042 ld a,1
       ld hl,varopt
       cp (hl)
       jp nz,t00079
       ld a,26
       call user
       ld h,255
       ld (rptr19),hl
       ret
t00079 ld a,2
       ld hl,varopt
       cp (hl)
       jp nz,t00109
       call read19
       ld (vara),a
       ret
t00109 ld a,3
       ld hl,varopt
       cp (hl)
       jp nz,t00167
       ld a,55
       ld (loopa),a
t00135 xor a
       ld (vara),a
       ld a,25
       call user
       ld hl,loopa
       dec (hl)
       jp nz,t00135
       ret
t00167 ret
rptr19 defw rdat19
rdat19 defb 0,40,0,0,0,40,0,0,0,0,0
       defb 0,0,40,0,0,0,0,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0
       defb 0,0,0,40,0,0,0,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0
       defb 0
read19 ld hl,(rptr19)
       ld de,rdat19+56
       scf
       ex de,hl
       sbc hl,de
       ex de,hl
       jr nc,$+5
       ld hl,rdat19
       ld a,(hl)
       inc hl
       ld (rptr19),hl
       ret
       ret
evnt20 equ $
       ld a,71
       ld (23693),a
       ld hl,4864
       ld (charx),hl
       ld a,(varg)
       call disply
       ld a,2
       ld hl,vara
       cp (hl)
       jp z,u00073
       ld a,22
       ld hl,varobj
       cp (hl)
       jp nc,u00073
       ld a,3
       ld (vara),a
u00073 ld a,1
       ld hl,vara
       cp (hl)
       jp nz,u00373
       xor a
       cp (ix+13)
       jp nz,u00268
       xor a
       ld hl,varg
       cp (hl)
       jp nz,u00207
       ld a,19
       call user
       ld a,(vara)
       ld (varg),a
       ld a,1
       cp (ix+10)
       jp nz,u00171
       ld a,2
       ld hl,vars
       cp (hl)
       jp nz,u00166
u00166 jp u00200
u00171 xor a
       cp (ix+10)
       jp nz,u00200
       ld a,2
       ld hl,vars
       cp (hl)
       jp nz,u00200
u00200 ret
       jp u00263
u00207 ld a,(varg)
       cp (ix+9)
       jp nz,u00261
       ld a,19
       call user
       ld a,(vara)
       ld (varb),a
       ld a,(varobj)
       call getob
       xor a
       ld (varg),a
       jp u00263
u00261 ret
u00263 jp u00279
u00268 ld a,255
       ld (varg),a
       ret
u00279 ld a,15
       ld (sndtyp),a
       ld a,(varr)
       ld (vara),a
       ld a,(varq)
       ld (varr),a
       ld a,(varobj)
       ld (varq),a
       ld a,255
       ld hl,vara
       cp (hl)
       jp z,u00365
       ld a,(varb)
       ld h,a
       ld a,(ix+8)
       ld l,a
       ld (dispx),hl
       ld a,(vara)
       call drpob
u00365 ld a,2
       ld (vara),a
u00373 ld a,2
       ld hl,vara
       cp (hl)
       jp nz,u01424
       ld hl,3604
       ld (charx),hl
       ld a,80
       call dmsg
       ld hl,3605
       ld (charx),hl
       ld a,81
       call dmsg
       ld hl,3606
       ld (charx),hl
       ld a,82
       call dmsg
       ld hl,3607
       ld (charx),hl
       ld a,83
       call dmsg
       ld hl,4372
       ld (charx),hl
       ld a,84
       call dmsg
       ld hl,4373
       ld (charx),hl
       ld a,85
       call dmsg
       ld hl,4374
       ld (charx),hl
       ld a,86
       call dmsg
       ld hl,4375
       ld (charx),hl
       ld a,87
       call dmsg
       ld a,(varq)
       ld (vara),a
       ld hl,28832
       ld (charx),hl
       ld a,13
       call user
       ld a,(vara)
       add a,a
       ld (vara),a
       ld hl,4372
       ld (charx),hl
       ld a,(vara)
       call dmsg
       ld a,(vara)
       inc a
       ld (vara),a
       ld hl,4373
       ld (charx),hl
       ld a,(vara)
       call dmsg
       ld h,255
       ld (rptr20),hl
       ld a,(varq)
       ld (vara),a
       ld a,(vara)
       inc a
       ld (vara),a
       ld a,(vara)
       ld (loopa),a
u00665 call read20
       ld (vari),a
       call read20
       ld (varv),a
       ld hl,loopa
       dec (hl)
       jp nz,u00665
       ld a,(varr)
       ld (vara),a
       ld a,255
       ld hl,vara
       cp (hl)
       jp z,u00923
       ld hl,28848
       ld (charx),hl
       ld a,13
       call user
       ld a,(vara)
       add a,a
       ld (vara),a
       ld hl,4374
       ld (charx),hl
       ld a,(vara)
       call dmsg
       ld a,(vara)
       inc a
       ld (vara),a
       ld hl,4375
       ld (charx),hl
       ld a,(vara)
       call dmsg
       ld h,255
       ld (rptr20),hl
       ld a,(varr)
       ld (vara),a
       ld a,(vara)
       inc a
       ld (vara),a
       ld a,(vara)
       ld (loopa),a
u00847 call read20
       ld (varb),a
       call read20
       ld (varc),a
       ld hl,loopa
       dec (hl)
       jp nz,u00847
       ld a,(varb)
       ld c,a
       ld a,(vari)
       add a,c
       ld (vari),a
       ld a,(varc)
       ld c,a
       ld a,(varv)
       add a,c
       ld (varv),a
u00923 ld a,8
       ld (vark),a
       ld a,(varv)
       ld c,a
       ld a,(vark)
       sub c
       ld (vark),a
       ld a,2
       call gotob
       jp c,u00973
       ld a,8
       ld (vark),a
u00973 ld a,4
       call gotob
       jp c,u00998
       ld a,2
       ld (vars),a
       jp u01006
u00998 ld a,1
       ld (vars),a
u01006 ld a,1
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       xor a
       rla
       rla
       rla
       and 56
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 199
       or c
       ld (hl),a
       ld a,20
       ld (vara),a
       ld a,4
       ld (loopa),a
u01092 ld a,(vara)
       ld l,a
       ld a,9
       ld h,a
       ld (charx),hl
       ld a,88
       call dmsg
       ld a,(vara)
       ld l,a
       ld a,10
       ld h,a
       ld (charx),hl
       ld a,89
       call dmsg
       ld a,(vara)
       inc a
       ld (vara),a
       ld hl,loopa
       dec (hl)
       jp nz,u01092
       xor a
       ld hl,vari
       cp (hl)
       jp nc,u01296
       ld a,5
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld a,23
       ld (vara),a
       ld a,(vari)
       ld (loopa),a
u01241 ld a,(vara)
       ld l,a
       ld a,9
       ld h,a
       ld (charx),hl
       ld a,90
       call dmsg
       ld a,(vara)
       dec a
       ld (vara),a
       ld hl,loopa
       dec (hl)
       jp nz,u01241
u01296 xor a
       ld hl,varv
       cp (hl)
       jp nc,u01416
       ld a,2
       and 7
       ld c,a
       ld hl,23693
       ld a,(hl)
       and 248
       or c
       ld (hl),a
       ld a,23
       ld (vara),a
       ld a,(varv)
       ld (loopa),a
u01361 ld a,(vara)
       ld l,a
       ld a,10
       ld h,a
       ld (charx),hl
       ld a,91
       call dmsg
       ld a,(vara)
       dec a
       ld (vara),a
       ld hl,loopa
       dec (hl)
       jp nz,u01361
u01416 ld a,4
       ld (vara),a
u01424 ld a,3
       ld hl,vara
       cp (hl)
       jp nz,u03207
       ld a,27
       ld hl,varobj
       cp (hl)
       jp nz,u01504
       ld a,(varobj)
       call getob
       ld a,67
       ld (23693),a
       ld a,30
       ld (sndtyp),a
       ld hl,6677
       ld (charx),hl
       ld a,92
       call dmsg
u01504 ld a,28
       ld hl,varobj
       cp (hl)
       jp nz,u01567
       ld a,(varobj)
       call getob
       ld a,70
       ld (23693),a
       ld a,30
       ld (sndtyp),a
       ld hl,6678
       ld (charx),hl
       ld a,93
       call dmsg
u01567 ld a,29
       ld hl,varobj
       cp (hl)
       jp nz,u01629
       ld a,(varobj)
       call getob
       ld a,69
       ld (23693),a
       ld a,30
       ld (sndtyp),a
       ld hl,6676
       ld (charx),hl
       ld a,94
       call dmsg
u01629 ld a,30
       ld hl,varobj
       cp (hl)
       jp nz,u01692
       ld a,(varobj)
       call getob
       ld a,66
       ld (23693),a
       ld a,30
       ld (sndtyp),a
       ld hl,6679
       ld (charx),hl
       ld a,95
       call dmsg
u01692 ld a,27
       call getob
       ld a,28
       call getob
       ld a,29
       call getob
       ld a,30
       call getob
       ld a,23
       ld hl,varobj
       cp (hl)
       jp nz,u01788
       ld a,27
       call gotob
       jp c,u01779
       ld a,(varobj)
       call getob
       ld a,70
       ld (sndtyp),a
       jp u01788
u01779 inc (ix+9)
       inc (ix+9)
u01788 ld a,24
       ld hl,varobj
       cp (hl)
       jp nz,u01850
       ld a,28
       call gotob
       jp c,u01841
       ld a,(varobj)
       call getob
       ld a,70
       ld (sndtyp),a
       jp u01850
u01841 dec (ix+9)
       dec (ix+9)
u01850 ld a,25
       ld hl,varobj
       cp (hl)
       jp nz,u01913
       ld a,29
       call gotob
       jp c,u01904
       ld a,(varobj)
       call getob
       ld a,70
       ld (sndtyp),a
       jp u01913
u01904 inc (ix+9)
       inc (ix+9)
u01913 ld a,26
       ld hl,varobj
       cp (hl)
       jp nz,u02014
       ld a,30
       call gotob
       jp c,u01966
       ld a,(varobj)
       call getob
       ld a,70
       ld (sndtyp),a
       jp u02014
u01966 ld a,1
       cp (ix+10)
       jp nz,u01992
       dec (ix+9)
       dec (ix+9)
       jp u02014
u01992 xor a
       cp (ix+10)
       jp nz,u02014
       inc (ix+9)
       inc (ix+9)
u02014 ld a,41
       ld hl,varobj
       cp (hl)
       jp nz,u02051
       ld a,(varobj)
       call getob
       ld a,100
       ld (numlif),a
u02051 ld a,40
       ld hl,varobj
       cp (hl)
       jp nz,u03207
       xor a
       ld hl,varu
       cp (hl)
       jp nz,u02093
       ld a,21
       ld (varu),a
u02093 ld a,(varu)
       ld (varc),a
       ld a,11
       call user
       ld a,(varobj)
       call getob
       xor a
       ld (varb),a
       ld a,6
       ld hl,varq
       cp (hl)
       jp nz,u02158
       ld a,1
       ld (varb),a
       jp u02183
u02158 ld a,6
       ld hl,varr
       cp (hl)
       jp nz,u02183
       ld a,1
       ld (varb),a
u02183 ld a,1
       ld hl,scno
       cp (hl)
       jp nz,u02337
       xor a
       ld (varh),a
       ld a,7
       call gotob
       jp c,u02333
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,u02333
       ld a,7
       ld hl,varq
       cp (hl)
       jp nz,u02275
       ld a,18
       ld (varq),a
       ld a,18
       call getob
       jp u02308
u02275 ld a,7
       ld hl,varr
       cp (hl)
       jp nz,u02308
       ld a,18
       ld (varr),a
       ld a,18
       call getob
u02308 ld a,2
       ld (vara),a
       ld a,12
       call user
       ld a,255
       ld (varh),a
u02333 jp u02958
u02337 ld a,5
       ld hl,scno
       cp (hl)
       jp nz,u02691
       ld a,18
       call gotob
       jp c,u02472
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,u02472
       ld a,18
       ld hl,varq
       cp (hl)
       jp nz,u02422
       ld a,17
       ld (varq),a
       ld a,17
       call getob
       jp u02456
u02422 ld a,18
       ld hl,varr
       cp (hl)
       jp nz,u02456
       ld a,17
       ld (varr),a
       ld a,17
       call getob
u02456 ld a,2
       ld (vara),a
       ld a,12
       call user
u02472 ld a,21
       call gotob
       jp c,u02590
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,u02590
       ld a,21
       ld hl,varq
       cp (hl)
       jp nz,u02540
       ld a,16
       ld (varq),a
       ld a,16
       call getob
       jp u02573
u02540 ld a,21
       ld hl,varr
       cp (hl)
       jp nz,u02573
       ld a,16
       ld (varr),a
       ld a,16
       call getob
u02573 ld a,2
       ld (vara),a
       ld a,12
       call user
u02590 xor a
       ld (varh),a
       ld a,18
       call gotob
       jp c,u02666
       ld a,21
       call gotob
       jp c,u02653
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,u02649
       ld a,255
       ld (varh),a
u02649 jp u02661
u02653 xor a
       ld (varh),a
u02661 jp u02687
u02666 ld a,21
       call gotob
       jp c,u02687
       ld a,1
       ld (varh),a
u02687 jp u02958
u02691 ld a,37
       ld hl,scno
       cp (hl)
       jp nz,u02771
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,u02767
       ld a,255
       ld (varh),a
       ld a,36
       ld (vara),a
       ld a,27
       call user
       ld a,40
       ld (vara),a
       ld a,25
       call user
u02767 jp u02958
u02771 ld a,36
       ld hl,scno
       cp (hl)
       jp nz,u02958
       xor a
       ld (varh),a
       ld a,4
       call gotob
       jp c,u02958
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,u02958
       ld a,4
       ld hl,varq
       cp (hl)
       jp nz,u02863
       ld a,19
       ld (varq),a
       ld a,19
       call getob
       jp u02897
u02863 ld a,4
       ld hl,varr
       cp (hl)
       jp nz,u02897
       ld a,19
       ld (varr),a
       ld a,19
       call getob
u02897 ld a,2
       ld (vara),a
       ld a,12
       call user
       ld a,255
       ld (varh),a
       ld a,32
       call getob
       ld a,16
       ld h,a
       ld a,120
       ld l,a
       ld (dispx),hl
       ld a,31
       call drpob
u02958 ld a,255
       ld hl,varh
       cp (hl)
       jp nz,u03041
       ld a,(scno)
       ld (vara),a
       ld a,27
       call user
       ld a,255
       ld (vara),a
       ld a,25
       call user
       ld hl,3850
       ld (charx),hl
       ld a,96
       call dmsg
       call prskey
       call redraw
       jp u03207
u03041 ld a,1
       ld hl,varh
       cp (hl)
       jp nz,u03124
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,u03097
       ld hl,3850
       ld (charx),hl
       ld a,97
       call dmsg
       jp u03114
u03097 ld hl,3850
       ld (charx),hl
       ld a,98
       call dmsg
u03114 call prskey
       call redraw
u03124 xor a
       ld hl,varh
       cp (hl)
       jp nz,u03207
       ld a,1
       ld hl,varb
       cp (hl)
       jp nz,u03179
       ld hl,3850
       ld (charx),hl
       ld a,99
       call dmsg
       jp u03197
u03179 ld hl,3850
       ld (charx),hl
       ld a,100
       call dmsg
u03197 call prskey
       call redraw
u03207 ld a,71
       ld (23693),a
       ret
rptr20 defw rdat20
rdat20 defb 1,1,2,2,0,1,1,2,0,1,0
       defb 1,1,1,0,1,0,0,2,2,0,1
       defb 1,1,0,1,0,0,1,0,0,1,1
       defb 1,1,0,0,1,0,1,2,1,0,1
       defb 2,2
read20 ld hl,(rptr20)
       ld de,rdat20+46
       scf
       ex de,hl
       sbc hl,de
       ex de,hl
       jr nc,$+5
       ld hl,rdat20
       ld a,(hl)
       inc hl
       ld (rptr20),hl
       ret
       ret
ptcusr ret
msgdat equ $
       defb 'U',206
       defb 'FARO',204
       defb 'LLAV',197
       defb 'FIJ',193
       defb 'BOTE D',197
       defb 'EUKODA',204
       defb 'U',206
       defb 'PIC',207
       defb 'FRASC',207
       defb 'PERVITI',206
       defb 'ATUEND',207
       defb 'OFICIA',204
       defb 'EL QU',197
       defb 'TRADUC',197
       defb 'OSO D',197
       defb 'PELUCH',197
       defb 'UN',193
       defb 'PLUM',193
       defb 'U',206
       defb 'CUB',207
       defb 'E',204
       defb 'GOT',217
       defb 'UNA MIN',201
       defb 'CAMPAN',193
       defb 'UN',193
       defb 'TIBI',193
       defb 'U',206
       defb 'DIARI',207
       defb '1',176
       defb 'PFENNI',199
       defb 'SANGR',197
       defb 'DRAGO',206
       defb 'OJO DE',204
       defb 'MUERT',207
       defb 'LLAV',197
       defb 'PEQUEN',193
       defb 'TARRO D',197
       defb 'LAGRIM',193
       defb 'FRASC',207
       defb 'VACI',207
       defb 'MECHER',207
       defb 'DE LATO',206
       defb 'GRANO D',197
       defb 'FRESN',207
       defb 'CORON',193
       defb 'MALDIT',193
       defb 'vvwxy',250
       defb 't',245
       defb 246
       defb 232
       defb 233
       defb 'vvv',246
       defb 'DEA',196
       defb '	        ',160
       defb 'abfgcd deahi f',225
       defb ' 	                           ',160
       defb '  		',160
       defb 'LEFT      ',160
       defb 'RIGHT     ',160
       defb 'UP        ',160
       defb 'DOWN      ',160
       defb 'JUMP      ',160
       defb 'PAUSE     ',160
       defb 'MUSIC ON-OF',198
       defb 'XOR',160
       defb 'MAS',203
       defb 160
       defb ' ',160
       defb 'Zona ',195
       defb 'Zona ',194
       defb 'Zona ',193
       defb '                   ',160
       defb 'BRILLA LA NOCHE AZU',204
       defb '                   ',160
       defb 'SOL RADIANTE Y CLAR',207
       defb '           ',160
       defb 'Zona ',195
       defb 'Zona ',194
       defb 'Zona ',193
       defb 'HIGHSCOR',197
       defb ' ',160
       defb ' ',160
       defb ' ',160
       defb ' ',160
       defb '       ',160
       defb '       ',160
       defb '       ',160
       defb '       ',160
       defb 160
       defb 160
       defb 244
       defb 244
       defb 'n',239
       defb 'j',235
       defb 'p',241
       defb 'l',237
       defb 'GOT I',212
       defb 'INFO ',177
       defb '???? ',177
       defb 'INFO ',176
       defb '???? ',176
nummsg defb 101
scdat  equ $
       defw 315,244,276,328,269,299,388,289,323,118
       defb 55,55,12,13,72,73,74,75,12,14,14,13,12,14,13,53,60,1,2,14,14,13,100,101,12,14,14,13,12,13,255,0,13
       defb 1,2,53,60,3,4,19,19,19,0,0,19,12,13,12,30,31,255,0,13,3,4,53,61,1,50,255,0,5,12,13,27,28
       defb 75,57,255,0,17,3,119,255,0,6,12,13,27,54,12,255,0,16,7,1,2,255,0,7,12,13,95,13,255,0,5,7,255,0,9
       defb 1,50,3,4,255,0,8,12,74,12,255,0,4,12,13,255,56,8,5,3,4,255,0,10,27,27,13,0,0,0,63,46,19
       defb 1,50,19,19,46,19,19,19,16,255,0,12,12,1,50,0,0,0,18,1,74,3,4,1,50,75,18,1,50,255,0,13,1
       defb 3,119,0,0,0,18,3,1,50,19,3,119,19,19,3,4,255,0,4,78,5,79,255,0,6,3,4,58,0,0,9,66,12
       defb 3,4,1,2,12,13,18,12,14,13,255,0,4,32,255,0,7,5,1,50,255,0,7,3,16,0,0,66,255,0,15,7,3
       defb 4,255,0,26,12,75,12,13,255,0,25,12,13,95,27,12,255,0,24,1,50,1,2,12,13,255,0,24,3,1,50,4,13
       defb 30,0,0,0,31,30,255,0,5,7,255,0,13,12,3,119,13,12,13,57,58,57,58,57,58,31,30,57,58,1,13,0,0,0
       defb 1,50,58,31,30,57,58,105,105,57,58,57,58,31,30
       defb 55,106,107,55,23,23,23,55,55,29,55,55,55,52,52,45,45,52,55,55,26,55,55,26,55,24,55,24,55,55,55,108,109
       defb 21,41,41,41,22,55,55,55,25,55,0,55,0,0,55,0,0,0,55,55,0,91,41,0,41,55,55,0,106,107,255,126,7
       defb 55,126,126,126,0,0,126,26,126,126,126,55,255,126,8,0,108,109,255,0,28,106,107,255,0,27,255,105,5,255,0,135,1
       defb 14,14,2,255,0,26,102,99,99,103,255,0,13,1,2,1,50,36,56,67,13,255,0,5,255,98,4,255,0,6,1,2,1
       defb 2,1,2,5,3,30,3,4,18,12,14,13,12,50,12,14,13,12,13,1,2,1,2,1,2,1,2,31,9,31,30,31,31
       defb 58,31,30,59,31,20,19,46,19,15,42,19,15,42,19,46,19,19,11,59,3,4,3,4,255,0,67,7,12,13,12,67,56
       defb 14,50,12,14,14,50,67,56,13,12,13,12,13,255,0,4,30,31,58,31,30,31,30,5,58,31,30,31,30,31,58,30,31
       defb 58,30,31,58,57,31,5,31,31,30,31,58,30
       defb 255,55,12,29,255,55,4,52,52,45,45,52,55,24,55,106,107,255,55,6,26,55,55,24,55,55,26,255,55,4,25,55,55,55
       defb 25,51,55,23,55,41,55,108,109,90,91,26,0,0,55,0,0,55,0,55,0,0,0,41,21,0,0,0,55,55,41,255,0,6
       defb 106,107,0,123,255,0,6,55,255,0,11,55,0,0,6,50,1,2,255,105,4,1,2,255,0,19,1,2,4,3,4,255,0,4
       defb 3,4,255,0,18,6,3,4,96,255,0,24,92,94,1,2,255,0,28,3,4,255,0,15,116,255,0,12,1,2,255,0,5
       defb 72,73,72,73,72,255,0,5,117,255,0,12,3,4,255,0,15,117,255,0,29,127,0,0,0,7,255,0,20,1,2,1,2
       defb 5,2,12,13,12,13,12,13,31,30,31,58,255,105,5,31,1,2,1,50,1,2,1,2,3,4,3,12,50,4,49,255,0,8
       defb 32,31,30,31,30,12,13,3,4,3,4,3,31,3,4,255,0,16,59,57,58,0,32,12,13,12,13,12,13,59,12,13,255,0,41
       defb 5,0,33,35,35,34,255,0,13,31,58,31,30,31,30,31,12,36,5,63,62,53,60,58,30,31,12,13,31,58,57,31,30
       defb 31,31,30,31,58,30
       defb 55,55,0,0,0,29,55,55,13,12,13,12,50,12,14,14,13,53,60,7,1,2,57,1,50,53,60,73,74,73,55,55,0,0,0
       defb 55,26,0,12,13,12,13,12,13,105,1,2,53,60,1,2,4,1,3,4,53,61,255,0,4,22,0,0,0,55,0,6,1
       defb 2,0,0,0,17,14,3,4,53,60,3,4,2,3,2,7,255,0,5,1,2,1,2,118,2,1,2,3,4,255,0,4,73
       defb 1,2,53,60,12,13,4,1,2,1,255,0,5,3,4,3,4,3,119,3,4,16,255,0,6,3,119,53,61,12,1,50,3
       defb 4,3,12,255,14,4,255,0,19,1,3,119,255,0,4,48,72,255,0,21,1,2,255,0,6,75,255,0,21,3,36,255,0,6
       defb 75,0,0,72,73,73,105,73,72,56,56,73,72,73,105,75,72,73,76,255,19,4,11,255,0,4,78,74,73,255,0,6,78
       defb 75,74,75,74,75,79,255,0,15,31,79,255,0,62,1,2,78,74,14,14,74,14,74,72,75,13,255,56,4,12,14,13,12
       defb 13,12,50,12,13,12,13,30,31,12,3,4,255,0,4,20,15,42,11,32,59,12,13,12,36,255,56,5,36,12,13,12,13
       defb 31,57,12,13,255,0,15,20,19,15,42,46,19,11,255,0,42,12,13,12,13,12,13,12,13,0,0,7,255,0,15,30,31
       defb 30,31,31,58,31,12,13,57,31,58,12,13,12,13,31,58,57,31,30,12,13,12,14,13,12,13,12,13
       defb 12,13,12,13,12,13,12,13,12,13,12,13,1,2,12,13,12,50,12,13,12,13,18,13,1,50,12,13,55,55,255,0,6
       defb 54,255,0,5,3,1,50,255,0,6,17,18,4,3,4,255,0,17,3,16,255,0,7,66,255,0,37,14,13,255,0,37,28
       defb 255,0,11,7,255,0,16,12,13,1,50,255,0,9,14,36,13,255,0,12,74,75,14,5,3,4,255,0,9,17,18,16,255,0,12
       defb 73,255,0,15,18,255,0,12,1,50,255,0,15,18,255,0,11,39,3,4,0,0,12,13,1,2,13,255,0,8,18,255,0,11
       defb 37,76,75,0,0,1,50,3,4,16,255,0,8,18,255,0,7,13,12,13,12,13,73,74,0,0,3,4,12,13,255,0,9
       defb 18,255,0,7,12,13,12,13,12,13,5,0,0,12,13,255,0,11,18,255,0,16,5,7,255,0,11,18,0,36,255,0,14
       defb 12,13,5,12,13,56,56,68,69,255,56,6,18,255,0,10,28,0,0,0,5,12,13,1,2,255,56,4,67,56,56,56,18
       defb 56,18,255,0,5,57,58,57,58,57,58,31,30,57,58,31,30,3,4,31,30,57,58,31,56,57,58,18,30,57,58,57,58
       defb 31,30
       defb 255,55,9,29,255,55,5,52,52,45,255,55,7,29,255,55,4,0,55,0,55,29,55,55,21,55,22,255,55,6,51,55,55
       defb 25,255,55,9,255,0,5,55,0,55,0,41,0,55,55,55,24,29,55,55,55,0,0,55,0,0,0,55,55,55,21,255,0,43
       defb 7,255,0,9,7,255,0,17,7,0,31,0,7,0,7,0,0,7,0,0,31,255,0,14,7,0,0,31,0,41,0,31,0
       defb 31,0,0,31,0,0,41,0,7,255,0,12,31,0,0,7,0,7,0,70,7,32,7,0,59,0,7,0,0,31,255,0,12
       defb 59,0,7,30,0,31,0,0,31,7,31,0,7,0,30,0,0,7,255,0,14,31,41,0,7,0,0,30,31,7,0,31,0,0
       defb 7,0,31,255,0,12,7,0,32,7,0,31,0,7,57,58,31,0,41,7,0,31,0,30,255,0,12,31,0,0,30,0,7
       defb 0,31,30,31,0,0,0,30,0,70,0,32,255,0,12,32,0,0,70,0,30,0,0,57,58,31,0,0,32,255,0,7,9
       defb 255,0,13,41,0,0,30,31,60,255,0,27,57,58,60,255,0,27,30,31,61,255,0,25,7,7,57,58,7,255,0,7,5
       defb 255,0,5,57,58,57,105,0,0,0,105,57,58,31,30,57,58,31,30,57,58,31,57,12,13,31,30,57,58,57,58,31,30
       defb 255,55,13,29,55,45,52,255,55,7,36,55,51,45,255,55,6,51,45,255,55,4,36,255,55,7,36,55,55,55,36,55,18
       defb 255,55,10,51,55,55,55,12,13,12,13,12,50,105,105,12,14,14,14,13,18,5,1,2,1,2,1,50,255,55,8,12,13
       defb 12,100,101,14,14,13,12,13,18,12,14,14,20,1,50,4,3,4,3,4,45,52,55,55,29,55,55,55,13,105,18,0,0
       defb 19,46,19,15,42,11,255,0,4,3,4,72,73,74,75,72,45,45,51,255,55,5,12,13,18,255,0,19,51,255,55,7,13
       defb 12,18,255,0,10,27,255,0,8,255,55,8,12,13,18,0,0,0,12,14,14,14,9,10,14,14,14,36,105,105,105,12,13
       defb 12,55,55,55,45,52,55,55,55,13,105,18,0,0,0,60,1,2,14,109,63,19,46,19,11,12,13,12,13,12,13,55,55
       defb 51,45,45,45,52,55,12,13,11,0,0,0,61,3,4,106,107,18,255,0,10,255,55,5,45,55,55,13,96,255,0,5,1
       defb 2,1,2,18,255,0,10,255,55,8,12,2,255,0,5,3,4,3,4,18,255,0,10,255,55,7,29,13,7,255,0,8,60
       defb 18,255,0,10,255,55,6,29,55,12,2,255,0,8,60,18,255,0,10,55,55,55,24,255,55,4,13,105,255,0,5,1,2
       defb 53,60,18,255,0,10,55,55,55,41,255,55,4,12,2,255,56,5,3,4,53,60,20,255,56,4,62,0,33,35,34,0,55,55
       defb 0,0,0,55,55,55,13,12,255,56,4,14,14,13,53,60,1,50,30,1,2,18,53,60,75,74,72,55,55,0,0,0,55,55,55
       defb 12,13,3,4,12,13,12,14,13,53,60,3,4,31,58,4,11,53,60,74,73,75
       defb 13,74,53,60,72,12,1,2,118,50,1,2,20,19,19,62,1,2,1,2,1,8,1,2,1,2,1,2,1,2,12,13,53
       defb 60,12,13,3,4,17,4,3,4,1,2,5,18,2,1,3,1,2,1,36,1,50,4,3,4,3,4,1,2,53,60,1,2
       defb 96,0,0,10,0,0,17,4,5,66,4,17,4,3,4,3,18,3,4,16,255,0,4,3,4,53,60,3,1,2,255,0,14
       defb 10,18,255,0,7,73,79,53,61,0,3,119,255,0,15,66,255,0,67,13,12,13,1,2,7,255,0,21,105,105,105,12,13
       defb 1,3,1,2,255,0,9,10,255,0,6,36,0,0,0,1,2,255,0,4,3,4,50,4,255,0,13,7,0,0,18,0,27
       defb 0,3,4,255,0,5,17,4,255,0,14,9,0,0,18,36,56,1,50,255,0,25,18,11,56,3,4,255,0,20,7,36,0,0,0
       defb 18,56,56,1,2,255,0,13,36,27,27,7,36,27,7,36,18,27,7,36,18,1,2,3,4,255,0,13,255,18,11,20,18
       defb 3,4,2,255,0,14,255,99,15,103,0,0,0,1,1,2,255,0,8,255,98,16,0,0,0,3,3,4,13,12,13,12,13
       defb 12,13,1,2,12,13,1,2,1,2,74,75,12,13,12,13,12,13,12,13,12,13,12
       defb 1,2,1,50,12,1,2,53,60,1,2,1,50,12,13,0,0,0,1,2,100,101,13,12,0,0,0,1,13,12,3,4,3
       defb 1,2,3,4,53,60,3,4,3,4,12,16,0,0,0,3,4,0,0,1,2,0,0,0,102,82,81,0,0,0,3,4,13
       defb 7,53,60,1,50,16,255,0,10,3,119,0,0,0,98,98,98,255,0,4,12,14,13,53,60,3,119,255,0,12,1,2,1
       defb 2,1,2,1,255,0,5,1,50,53,60,1,2,255,0,12,3,119,3,1,2,4,3,255,0,5,3,16,53,60,3,118,50
       defb 1,2,5,36,1,2,118,50,255,0,4,1,2,3,119,1,2,255,0,7,53,61,1,3,4,2,4,0,18,3,4,3,119
       defb 255,0,4,3,1,50,1,3,4,105,255,0,8,3,4,3,4,7,7,18,255,0,9,3,4,3,4,3,0,0,0,63,255,19,4
       defb 46,255,19,4,46,19,11,255,0,17,20,19,19,46,19,19,46,19,62,255,0,23,63,19,46,19,19,19,11,255,0,23,20
       defb 19,19,46,62,255,0,27,12,14,13,255,0,80,2,255,0,4,39,0,39,40,0,0,0,40,0,40,39,0,7,255,0,10
       defb 1,2,4,0,7,1,50,37,38,37,38,37,38,37,38,37,38,37,37,1,2,255,0,8,1,50,4,13,12,13,3,4,12
       defb 14,13,12,14,13,12,13,12,13,12,13,3,4,12,13,12,13,12,13,12,13,3,16,12
       defb 255,0,66,134,129,141,142,255,56,9,141,142,142,133,143,255,0,12,135,144,145,146,255,56,10,147,145,148,149,255,0,12,151
       defb 152,255,56,14,153,151,255,0,12,155,156,255,56,14,157,56,255,0,12,155,255,56,17,255,0,12,255,56,17,158,255,0,12
       defb 151,159,255,56,14,160,158,255,0,12,161,152,255,56,14,153,161,255,0,12,162,163,164,165,255,56,10,166,164,167,168,255,0,12
       defb 169,170,141,142,142,142,255,56,4,171,255,142,5,172,173,255,0,186
numsc  defb 10
chgfx  equ $
       defb 0,0,0,0,0,0,0,0
       defb 0,43,127,94,63,91,63,118
       defb 0,236,254,178,252,246,252,216
       defb 43,71,43,21,42,21,2,0
       defb 1,1,35,1,9,161,83,255
       defb 0,118,251,95,237,215,183,122
       defb 0,2,5,10,5,46,86,41
       defb 0,0,0,2,68,52,38,223
       defb 0,64,160,144,104,168,86,180
       defb 0,182,219,126,68,4,0,0
       defb 0,235,125,46,100,32,0,0
       defb 90,246,14,254,252,168,80,0
       defb 0,52,123,45,85,42,21,2
       defb 0,204,250,190,118,236,118,212
       defb 0,230,191,235,221,46,213,163
       defb 0,255,0,255,252,168,80,0
       defb 94,180,148,104,160,64,128,0
       defb 125,42,23,10,13,7,1,0
       defb 90,58,90,58,90,58,90,58
       defb 0,255,0,255,255,170,85,0
       defb 90,61,94,47,87,42,21,0
       defb 1,3,7,15,31,63,127,255
       defb 127,63,31,15,7,3,1,0
       defb 4,28,60,124,108,100,68,4
       defb 0,24,60,60,60,24,126,255
       defb 60,126,195,195,255,102,102,126
       defb 0,0,0,60,24,60,24,60
       defb 0,0,0,0,0,0,84,187
       defb 0,0,0,0,0,0,2,39
       defb 0,0,0,0,0,0,0,0
       defb 67,59,251,251,216,25,28,156
       defb 2,216,221,221,13,236,224,13
       defb 122,44,4,20,0,4,0,0
       defb 0,0,0,0,0,0,1,2
       defb 0,0,0,0,0,4,86,6
       defb 0,0,0,0,0,0,85,0
       defb 0,191,121,187,127,0,94,58
       defb 32,32,36,52,36,166,239,189
       defb 18,18,18,82,82,86,215,247
       defb 0,0,0,0,0,0,0,32
       defb 0,0,0,0,0,0,0,18
       defb 0,0,24,60,60,24,0,0
       defb 0,255,0,255,127,42,21,0
       defb 0,0,255,255,255,255,255,255
       defb 0,165,255,255,255,255,255,255
       defb 0,0,0,0,0,0,0,0
       defb 0,207,0,231,231,162,69,0
       defb 60,0,185,179,167,143,31,63
       defb 60,0,157,205,229,241,248,252
       defb 85,173,81,181,75,167,31,255
       defb 0,220,38,74,18,4,130,194
       defb 0,0,0,0,255,255,255,255
       defb 0,0,0,0,255,255,255,255
       defb 0,0,0,0,0,0,0,0
       defb 118,40,32,0,0,0,0,0
       defb 0,0,0,0,0,0,0,0
       defb 0,0,0,0,0,0,0,0
       defb 126,30,147,144,240,31,24,252
       defb 2,2,143,249,241,192,192,253
       defb 90,86,18,18,0,16,0,0
       defb 0,2,0,2,0,2,0,2
       defb 0,2,0,2,0,6,2,0
       defb 0,248,12,246,250,186,90,186
       defb 0,7,30,61,91,59,91,58
       defb 0,126,189,219,231,247,248,252
       defb 0,126,189,219,231,239,31,63
       defb 90,62,0,127,191,121,191,0
       defb 0,44,126,251,95,171,215,42
       defb 63,93,183,171,87,0,0,0
       defb 17,0,16,0,73,255,255,255
       defb 85,195,201,227,251,163,255,247
       defb 126,189,219,231,231,219,189,126
       defb 0,124,238,222,0,206,239,231
       defb 0,118,254,124,0,231,236,107
       defb 0,178,254,238,4,205,230,223
       defb 0,180,238,126,0,239,238,205
       defb 0,227,205,111,13,202,229,98
       defb 0,205,175,231,242,198,107,237
       defb 0,119,103,50,0,29,7,3
       defb 0,106,238,76,0,120,240,160
       defb 126,129,129,129,129,129,129,126
       defb 67,59,251,251,216,25,28,156
       defb 2,216,221,221,13,236,224,13
       defb 0,0,0,128,128,192,224,248
       defb 0,240,252,254,254,255,255,255
       defb 60,126,255,255,255,255,126,60
       defb 63,63,8,42,89,90,89,95
       defb 3,3,229,69,165,67,163,3
       defb 95,95,95,95,47,8,59,63
       defb 3,3,3,5,5,229,3,3
       defb 7,31,63,127,127,255,255,255
       defb 31,7,3,1,1,0,0,0
       defb 60,126,158,189,254,253,122,52
       defb 63,30,109,67,3,61,62,127
       defb 3,135,78,61,42,65,130,1
       defb 1,34,148,84,88,81,82,218
       defb 127,127,95,63,127,127,191,127
       defb 0,255,255,0,0,85,170,0
       defb 0,0,0,0,0,0,0,0
       defb 0,102,189,219,231,0,0,255
       defb 31,55,111,95,95,94,92,92
       defb 7,3,5,3,5,131,197,195
       defb 43,71,43,149,42,21,2,0
       defb 25,11,19,7,15,159,63,255
       defb 0,0,0,1,1,3,7,31
       defb 0,102,189,219,231,231,24,0
       defb 24,28,24,28,11,6,7,6
       defb 40,48,40,48,168,112,96,16
       defb 7,6,7,6,7,10,25,28
       defb 16,40,16,104,96,176,168,48
       defb 3,1,0,16,24,24,28,39
       defb 63,127,63,159,159,159,47,119
       defb 57,127,240,160,96,163,255,176
       defb 67,1,248,252,252,29,28,252
       defb 96,160,67,62,67,34,1,0
       defb 2,7,253,219,190,251,110,60
       defb 24,60,44,90,124,122,52,0
       defb 24,16,24,16,24,16,24,16
       defb 0,63,100,112,124,87,63,123
       defb 61,45,31,77,5,69,19,255
       defb 0,15,63,127,127,255,255,255
       defb 0,248,252,224,194,200,128,128
       defb 0,15,63,127,127,255,255,255
       defb 0,0,0,1,1,3,7,31
       defb 0,0,0,128,128,192,224,184
       defb 127,63,59,31,15,1,3,15
       defb 0,0,0,0,0,0,0,0
       defb 24,16,24,52,56,20,24,52
       defb 16,140,212,238,255,255,255,255
       defb 0,56,124,127,85,40,18,160
       defb 0,0,127,254,85,42,0,0
       defb 0,0,126,255,85,170,0,0
       defb 5,10,5,43,119,247,255,255
       defb 0,28,62,254,170,20,72,5
       defb 95,185,80,226,212,184,189,195
       defb 1,28,47,94,44,88,42,24
       defb 127,231,83,161,209,225,179,231
       defb 8,28,44,28,44,28,44,20
       defb 0,0,127,254,85,42,0,0
       defb 0,0,126,255,85,170,0,0
       defb 40,28,44,28,44,28,44,24
       defb 0,0,126,255,213,42,0,0
       defb 0,0,126,127,85,170,0,0
       defb 5,98,245,184,212,226,66,60
       defb 0,7,24,35,47,76,88,88
       defb 0,255,0,255,255,0,0,0
       defb 0,85,0,85,85,0,0,0
       defb 0,170,0,170,170,0,0,0
       defb 0,224,24,196,244,50,26,26
       defb 127,199,11,133,203,229,171,231
       defb 8,28,44,28,44,28,44,20
       defb 24,28,44,28,44,28,44,24
       defb 88,88,88,88,88,88,88,88
       defb 26,26,26,26,26,26,26,26
       defb 40,28,44,28,44,28,44,24
       defb 32,28,44,28,44,28,44,24
       defb 0,88,0,88,0,88,0,88
       defb 0,26,0,26,0,26,0,26
       defb 24,44,28,44,28,44,28,32
       defb 88,0,88,0,88,0,88,0
       defb 26,0,26,0,26,0,26,0
       defb 24,44,28,44,28,44,28,24
       defb 24,50,120,116,122,53,24,1
       defb 88,88,76,47,35,24,7,0
       defb 0,0,0,255,255,0,255,0
       defb 0,0,0,85,85,0,85,0
       defb 0,0,0,170,170,0,170,0
       defb 26,26,50,244,196,24,224,0
       defb 24,76,30,46,94,172,24,128
       defb 60,110,117,57,145,169,70,160
       defb 95,237,215,170,128,131,199,255
       defb 0,0,126,255,85,42,0,0
       defb 5,72,20,170,254,62,28,0
       defb 60,118,174,156,137,149,98,5
       defb 0,0,126,255,85,42,0,0
       defb 0,0,127,254,85,170,0,0
       defb 0,0,0,114,181,98,181,96
       defb 0,0,88,184,62,192,40,254
       defb 0,24,24,0,0,24,24,0
       defb 7,31,55,111,95,94,92,92
       defb 31,7,3,5,3,133,195,197
       defb 0,0,52,122,124,94,110,60
       defb 0,0,26,61,190,175,55,30
       defb 0,0,0,32,48,56,108,70
       defb 96,16,0,4,12,28,54,98
       defb 76,156,78,143,254,244,231,196
       defb 1,39,15,254,31,14,229,6
       defb 0,128,0,0,192,192,192,192
       defb 92,92,92,124,0,124,124,0
       defb 60,58,60,58,0,58,58,0
       defb 1,1,0,1,0,2,5,2
       defb 127,127,255,255,167,71,193,63
       defb 70,108,56,48,32,0,0,0
       defb 98,54,28,12,4,0,16,96
       defb 68,74,41,16,0,192,153,43
       defb 2,36,84,136,0,40,148,168
       defb 5,0,3,3,1,0,107,98
       defb 40,254,254,248,240,0,192,224
       defb 0,66,228,108,24,52,110,140
       defb 59,59,50,195,193,152,24,0
       defb 43,45,19,49,17,55,55,255
       defb 1,4,6,0,0,111,0,0
       defb 31,231,225,255,255,1,255,255
       defb 0,0,127,254,85,170,0,0
       defb 0,24,24,0,0,24,24,0
       defb 7,31,55,111,95,94,92,92
       defb 31,7,3,5,3,133,195,197
       defb 0,0,52,122,124,94,110,60
       defb 0,0,26,61,190,175,55,30
       defb 0,0,8,24,21,57,119,235
       defb 7,29,62,111,127,251,255,255
       defb 15,7,3,1,1,2,1,2
       defb 0,0,0,128,128,192,224,250
       defb 5,2,5,11,21,43,87,191
       defb 111,111,111,119,55,59,27,24
       defb 0,128,152,154,128,157,45,107
       defb 92,92,92,124,0,124,124,0
       defb 60,58,60,58,0,58,58,0
       defb 83,187,123,187,115,5,97,116
       defb 67,63,31,31,207,79,103,35
       defb 0,8,124,254,252,158,223,126
       defb 0,32,136,0,0,32,0,16
       defb 3,191,255,255,255,255,255,255
       defb 0,0,16,0,0,0,0,24
       defb 0,0,0,0,0,0,0,38
       defb 15,0,0,0,0,0,0,0
       defb 3,143,255,255,255,255,255,255
       defb 24,0,0,0,0,0,0,0
       defb 0,7,31,124,115,14,63,63
       defb 0,128,192,0,128,192,192,128
       defb 31,64,96,22,118,48,68,240
       defb 0,26,29,126,3,20,127,127
       defb 0,6,77,166,77,166,13,198
       defb 27,15,0,211,198,10,29,61
       defb 50,121,223,63,89,25,47,163
       defb 0,0,0,0,32,0,0,0
       defb 1,2,7,134,205,234,245,234
bcol   equ $
       defb 7
       defb 7
       defb 7
       defb 7
       defb 56
       defb 7
       defb 7
       defb 4
       defb 7
       defb 7
       defb 7
       defb 5
       defb 7
       defb 7
       defb 7
       defb 5
       defb 7
       defb 7
       defb 5
       defb 5
       defb 5
       defb 16
       defb 2
       defb 16
       defb 16
       defb 16
       defb 16
       defb 4
       defb 7
       defb 18
       defb 66
       defb 2
       defb 2
       defb 7
       defb 7
       defb 7
       defb 5
       defb 5
       defb 5
       defb 2
       defb 2
       defb 2
       defb 5
       defb 56
       defb 40
       defb 63
       defb 5
       defb 16
       defb 16
       defb 56
       defb 7
       defb 58
       defb 23
       defb 7
       defb 4
       defb 18
       defb 9
       defb 16
       defb 80
       defb 66
       defb 7
       defb 7
       defb 5
       defb 5
       defb 40
       defb 40
       defb 5
       defb 15
       defb 15
       defb 57
       defb 16
       defb 23
       defb 7
       defb 7
       defb 7
       defb 7
       defb 7
       defb 7
       defb 7
       defb 7
       defb 39
       defb 2
       defb 66
       defb 112
       defb 70
       defb 22
       defb 7
       defb 56
       defb 7
       defb 56
       defb 22
       defb 50
       defb 7
       defb 104
       defb 5
       defb 4
       defb 32
       defb 7
       defb 7
       defb 40
       defb 66
       defb 16
       defb 7
       defb 56
       defb 112
       defb 40
       defb 69
       defb 5
       defb 69
       defb 5
       defb 69
       defb 40
       defb 71
       defb 120
       defb 71
       defb 71
       defb 7
       defb 5
       defb 7
       defb 56
       defb 71
       defb 71
       defb 70
       defb 50
       defb 120
       defb 120
       defb 7
       defb 5
       defb 56
       defb 71
       defb 2
       defb 2
       defb 56
       defb 71
       defb 120
       defb 71
       defb 120
       defb 2
       defb 7
       defb 7
       defb 2
       defb 2
       defb 2
       defb 71
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 120
       defb 7
       defb 2
       defb 2
       defb 2
       defb 7
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 71
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 71
       defb 71
       defb 120
       defb 2
       defb 71
       defb 71
       defb 7
       defb 7
       defb 71
       defb 71
       defb 7
       defb 71
       defb 120
       defb 7
       defb 7
       defb 7
       defb 71
       defb 120
       defb 120
       defb 71
       defb 7
       defb 7
       defb 71
       defb 120
       defb 7
       defb 71
       defb 71
       defb 71
       defb 71
       defb 71
       defb 71
       defb 71
       defb 120
       defb 71
       defb 120
       defb 2
       defb 2
       defb 66
       defb 80
       defb 5
       defb 5
       defb 7
       defb 71
       defb 120
       defb 120
       defb 120
       defb 71
       defb 71
       defb 5
       defb 5
       defb 71
       defb 120
       defb 71
       defb 69
       defb 104
       defb 69
       defb 71
       defb 66
       defb 80
       defb 66
       defb 71
       defb 71
       defb 71
       defb 66
       defb 66
       defb 66
       defb 80
       defb 1
       defb 7
bprop  equ $
       defb 0
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 0
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 0
       defb 0
       defb 0
       defb 0
       defb 0
       defb 0
       defb 0
       defb 0
       defb 0
       defb 2
       defb 2
       defb 2
       defb 0
       defb 0
       defb 0
       defb 2
       defb 5
       defb 5
       defb 5
       defb 5
       defb 2
       defb 2
       defb 1
       defb 2
       defb 0
       defb 2
       defb 2
       defb 2
       defb 0
       defb 2
       defb 0
       defb 0
       defb 3
       defb 0
       defb 0
       defb 7
       defb 2
       defb 2
       defb 3
       defb 3
       defb 3
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 0
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 0
       defb 7
       defb 7
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 1
       defb 2
       defb 0
       defb 0
       defb 8
       defb 8
       defb 7
       defb 2
       defb 2
       defb 6
       defb 7
       defb 2
       defb 2
       defb 7
       defb 7
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 0
       defb 0
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 8
       defb 8
       defb 2
       defb 0
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
       defb 2
sprgfx equ $
       defb 0,0,26,0,29,70,126,173,3,70,20,173,127,6,127,205,27,198,15,141,0,6,211,192,198,198,3,150,24,48,56,96
       defb 0,0,6,128,135,81,95,171,128,209,69,43,159,193,95,243,134,241,67,227,128,1,52,240,177,177,128,229,6,12,14,24
       defb 0,0,1,160,97,212,215,234,96,52,209,74,103,240,215,252,97,188,208,248,96,0,13,60,108,108,96,57,1,131,3,134
       defb 0,0,0,104,24,117,181,250,24,13,180,82,25,252,53,255,24,111,52,62,24,0,3,79,27,27,88,14,192,96,128,225
       defb 0,0,26,0,29,70,126,173,3,70,20,173,127,6,127,205,27,198,15,141,192,6,211,192,14,192,35,140,48,44,24,224
       defb 0,0,6,128,135,81,95,171,128,209,69,43,159,193,95,243,134,241,67,227,176,1,52,240,3,176,8,227,12,11,6,56
       defb 0,0,1,160,97,212,215,234,96,52,209,74,103,240,215,252,97,188,208,248,108,0,13,60,0,236,194,56,195,2,1,142
       defb 0,0,0,104,24,117,181,250,24,13,180,82,25,252,53,255,24,111,52,62,27,0,3,79,0,59,48,142,176,192,128,99
       defb 0,0,26,6,29,77,126,166,3,77,20,166,127,13,127,198,27,205,15,134,0,0,51,216,54,216,3,128,12,48,60,240
       defb 0,0,134,129,71,83,159,169,64,211,133,41,95,195,159,241,70,243,131,225,0,0,12,246,13,182,0,224,3,12,15,60
       defb 0,0,97,160,209,212,103,234,208,52,97,74,215,240,103,252,209,188,96,248,0,0,131,61,131,109,0,56,0,195,3,207
       defb 0,0,24,104,52,117,153,250,52,13,152,82,53,252,25,255,52,111,24,62,0,0,96,207,96,219,0,14,192,48,192,243
       defb 0,0,0,88,98,184,181,126,98,192,181,40,96,254,179,254,99,216,177,240,96,0,3,203,99,99,105,192,12,24,6,28
       defb 0,0,0,22,24,174,173,95,24,176,45,74,152,63,172,255,24,246,44,124,24,0,192,242,216,216,26,112,3,6,1,135
       defb 0,0,128,5,134,43,235,87,6,44,139,82,230,15,235,63,134,61,11,31,6,0,176,60,54,54,6,156,128,193,192,97
       defb 0,0,96,1,225,138,250,213,1,139,162,212,249,131,250,207,97,143,194,199,1,128,44,15,141,141,1,167,96,48,112,24
       defb 0,0,0,88,98,184,181,126,98,192,181,40,96,254,179,254,99,216,177,240,96,3,3,203,3,96,97,196,100,12,7,24
       defb 0,0,0,22,24,174,173,95,24,176,45,74,152,63,172,255,24,246,44,124,216,0,192,242,0,216,24,113,25,3,1,198
       defb 0,0,128,5,134,43,235,87,6,44,139,82,230,15,235,63,134,61,11,31,54,0,176,60,0,54,70,28,198,64,128,113
       defb 0,0,96,1,225,138,250,213,1,139,162,212,249,131,250,207,97,143,194,199,13,128,44,15,128,13,17,135,49,144,96,28
       defb 0,0,96,88,178,184,101,126,178,192,101,40,176,254,99,254,179,216,97,240,0,0,27,204,27,108,1,192,12,48,15,60
       defb 0,0,24,22,44,174,153,95,44,176,25,74,172,63,152,255,44,246,24,124,0,0,6,243,6,219,0,112,3,12,3,207
       defb 0,0,134,5,139,43,230,87,11,44,134,82,235,15,230,63,139,61,6,31,0,0,193,188,193,182,0,28,0,195,192,243
       defb 0,0,97,129,226,202,249,149,2,203,161,148,250,195,249,143,98,207,193,135,0,0,48,111,176,109,0,7,192,48,240,60
       defb 0,88,98,184,181,126,98,192,181,40,96,254,179,254,99,216,177,241,96,5,3,200,3,225,1,203,0,0,0,0,0,0
       defb 0,22,24,174,173,95,24,176,45,74,152,63,172,255,24,246,108,124,88,1,0,242,64,248,192,114,0,0,0,0,0,0
       defb 128,5,134,43,235,87,6,44,139,82,230,15,235,63,134,61,27,31,86,0,128,60,16,62,176,28,0,0,0,0,0,0
       defb 96,1,225,138,250,213,1,139,162,212,249,131,250,207,97,143,198,199,21,128,32,15,132,15,44,7,0,0,0,0,0,0
       defb 0,0,0,88,98,184,181,126,98,192,181,40,96,254,179,254,99,184,177,240,96,0,3,205,3,225,1,208,0,5,0,2
       defb 0,0,0,22,24,174,173,95,24,176,45,74,152,63,172,255,24,238,44,124,24,0,64,243,64,248,0,116,64,1,128,0
       defb 0,0,128,5,134,43,235,87,6,44,139,82,230,15,235,63,134,59,11,31,6,0,208,60,16,62,0,29,80,0,32,0
       defb 0,0,96,1,225,138,250,213,1,139,162,212,249,131,250,207,225,142,194,199,1,128,52,15,132,15,64,7,20,0,8,0
       defb 0,0,0,0,0,0,0,0,0,0,95,222,123,254,0,0,54,120,50,236,17,76,51,140,54,104,62,108,107,254,95,154
       defb 0,0,0,0,0,0,0,0,0,0,151,247,158,255,0,0,13,158,12,187,4,83,12,227,13,154,15,155,154,255,151,230
       defb 0,0,0,0,0,0,0,0,0,0,229,253,231,191,0,0,131,103,195,46,193,20,195,56,131,102,195,230,230,191,165,249
       defb 0,0,0,0,0,0,0,0,0,0,121,127,249,239,0,0,224,217,176,203,48,69,48,206,160,217,176,249,249,175,105,126
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,29,64,126,170,3,69,20,175,127,14,127,208,27,214,143,178
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,80,159,170,64,209,197,43,159,195,31,244,134,245,163,236
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,212,167,234,80,52,241,74,231,240,7,253,97,189,40,251
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,117,169,250,20,13,188,82,57,252,65,255,88,111,202,62
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,58,180,253,74,6,158,41,92,254,0,255,144,59,187,159,105
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,173,191,82,129,167,10,87,63,128,63,228,206,238,103,218
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,67,171,175,212,224,105,194,149,15,224,15,249,179,187,153,246
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,208,234,43,245,120,26,112,165,3,248,67,254,236,238,166,125
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,184,85,126,162,192,245,40,112,254,11,254,107,216,77,241
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,174,149,95,40,176,61,74,156,63,130,255,26,246,83,124
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,43,229,87,10,44,143,82,231,15,224,191,134,189,20,223
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,224,10,249,85,2,139,163,212,249,195,248,47,97,175,197,55
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,45,92,82,191,121,96,58,148,0,127,9,255,221,220,150,249
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,87,212,175,30,88,14,165,192,31,194,127,55,119,101,190
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,194,213,245,43,7,150,67,169,240,7,240,159,205,221,153,111
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,112,181,253,74,129,229,80,234,252,1,252,39,115,119,230,91
       defb 0,0,0,0,0,0,26,0,29,70,126,173,3,70,20,173,127,6,127,205,27,198,15,141,0,6,3,128,146,216,217,88
       defb 0,0,0,0,0,0,6,128,135,81,95,171,128,209,69,43,159,193,95,243,134,241,67,227,128,1,0,224,36,182,54,86
       defb 0,0,0,0,0,0,1,160,97,212,215,234,96,52,209,74,103,240,215,252,97,188,208,248,96,0,0,56,137,45,141,149
       defb 0,0,0,0,0,0,0,104,24,117,181,250,24,13,180,82,25,252,53,255,24,111,52,62,24,0,0,14,98,75,99,101
       defb 0,14,1,194,56,68,8,136,17,15,33,224,60,4,0,100,0,247,25,247,89,118,1,237,57,234,181,212,180,202,214,20
       defb 128,3,128,112,14,17,2,34,196,67,8,120,15,1,0,25,192,61,198,125,150,93,64,123,142,122,45,117,173,50,53,133
       defb 224,0,32,28,67,132,128,136,241,16,2,30,67,192,64,6,112,15,113,159,101,151,208,30,163,158,75,93,171,76,77,97
       defb 56,0,8,7,16,225,32,34,60,68,128,135,16,240,144,1,220,3,220,103,217,101,180,7,168,231,82,215,42,211,83,88
       defb 0,0,0,224,28,32,4,64,8,128,16,240,30,4,0,100,0,247,1,119,25,246,89,237,1,234,185,212,180,202,214,20
       defb 0,0,0,56,7,8,1,16,2,32,4,60,7,129,0,25,192,61,192,93,134,125,86,123,128,122,46,117,173,50,53,133
       defb 0,0,0,14,1,194,0,68,0,136,1,15,65,224,64,6,112,15,112,23,97,159,213,158,160,30,75,157,171,76,77,97
       defb 0,0,128,3,128,112,0,17,0,34,192,67,16,120,144,1,220,3,220,5,216,103,181,103,168,7,82,231,42,211,83,88
       defb 0,0,0,0,0,0,0,88,98,184,181,126,98,192,181,40,96,254,179,254,99,216,177,240,96,0,1,192,27,73,26,155
       defb 0,0,0,0,0,0,0,22,24,174,173,95,24,176,45,74,152,63,172,255,24,246,44,124,24,0,0,112,70,210,198,166
       defb 0,0,0,0,0,0,128,5,134,43,235,87,6,44,139,82,230,15,235,63,134,61,11,31,6,0,0,28,145,180,177,169
       defb 0,0,0,0,0,0,96,1,225,138,250,213,1,139,162,212,249,131,250,207,97,143,194,199,1,128,0,7,36,109,108,106
       defb 112,0,19,128,32,156,65,4,242,8,7,144,32,60,38,0,239,0,239,152,110,154,183,136,87,156,43,173,83,45,40,107
       defb 28,0,4,224,8,39,16,65,60,130,1,228,8,15,9,128,59,192,59,230,155,166,45,226,21,231,74,235,84,203,202,26
       defb 7,0,1,56,194,9,68,16,143,32,0,121,194,3,2,96,14,240,142,249,166,233,139,120,197,121,210,186,213,50,178,134
       defb 1,192,0,78,112,130,17,4,35,200,64,30,240,128,0,152,3,188,99,190,105,186,34,222,113,94,180,174,181,76,172,161
       defb 0,0,7,0,1,56,2,8,4,16,15,32,32,120,38,0,239,0,238,128,111,152,183,154,87,128,43,157,83,45,40,107
       defb 0,0,1,192,0,78,0,130,1,4,3,200,8,30,9,128,59,192,59,160,27,230,173,230,21,224,74,231,84,203,202,26
       defb 0,0,0,112,128,19,128,32,0,65,0,242,130,7,2,96,14,240,14,232,134,249,171,121,5,120,210,185,213,50,178,134
       defb 0,0,0,28,224,4,32,8,64,16,128,60,224,129,0,152,3,188,3,186,97,190,106,222,1,94,116,174,181,76,172,161
       defb 0,0,66,2,7,21,2,2,16,0,128,130,0,0,16,32,42,4,144,14,0,132,1,64,72,130,224,16,64,0,9,4
       defb 0,0,144,128,65,197,128,128,4,0,160,32,0,0,4,8,10,129,164,3,0,33,0,80,146,32,56,4,16,0,2,65
       defb 0,0,36,32,80,113,32,32,1,0,40,8,0,0,1,2,66,160,233,0,64,8,0,20,36,136,14,1,4,0,64,144
       defb 0,0,9,8,84,28,8,8,0,64,10,2,0,0,128,64,16,168,58,64,16,2,0,5,9,34,67,128,1,0,16,36
       defb 64,0,0,68,34,14,80,4,33,0,0,32,16,80,2,34,64,0,160,136,64,0,4,8,65,28,2,136,17,2,0,0
       defb 16,0,0,17,136,131,20,1,8,64,0,8,4,20,128,136,16,0,40,34,16,0,1,2,16,71,0,162,132,64,0,0
       defb 4,0,64,4,226,32,69,0,2,16,0,2,1,5,32,34,4,0,138,8,4,0,128,64,196,17,128,40,33,16,0,0
       defb 1,0,16,1,56,136,17,64,0,132,128,0,64,65,136,8,1,0,34,130,1,0,32,16,113,4,32,10,8,68,0,0
       defb 0,0,0,0,32,0,16,8,24,16,44,40,20,16,42,68,6,104,3,48,1,216,66,120,22,80,9,128,0,0,0,0
       defb 0,0,0,0,8,0,4,2,6,4,11,10,5,4,10,145,1,154,0,204,0,118,16,158,5,148,2,96,0,0,0,0
       defb 0,0,0,0,2,0,129,0,1,129,130,194,1,65,66,164,128,102,0,51,128,29,132,39,1,101,0,152,0,0,0,0
       defb 0,0,0,0,0,128,32,64,64,96,160,176,64,80,16,169,160,25,192,12,96,7,225,9,64,89,0,38,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,32,0,48,136,120,212,44,102,87,178,36,241,68,161,11,0,80,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,8,0,12,34,30,53,139,25,149,236,73,60,81,40,2,192,20,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,2,0,131,8,71,141,98,198,37,123,18,79,20,74,0,176,5,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,128,32,194,81,227,152,177,201,94,196,147,133,18,0,44,1,64,0,0
       defb 0,0,0,0,0,4,16,8,8,24,20,52,8,40,34,84,22,96,12,192,27,128,30,66,10,104,1,144,0,0,0,0
       defb 0,0,0,0,0,1,4,2,2,6,5,13,2,10,8,149,5,152,3,48,6,224,135,144,2,154,0,100,0,0,0,0
       defb 0,0,0,0,64,0,129,0,128,129,65,67,128,130,66,37,1,102,0,204,1,184,33,228,128,166,0,25,0,0,0,0
       defb 0,0,0,0,16,0,32,64,96,32,208,80,160,32,80,137,128,89,0,51,0,110,8,121,160,41,64,6,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,4,17,12,43,30,102,52,77,234,143,36,133,34,0,208,0,10,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,1,4,67,138,199,25,141,147,122,35,201,161,72,0,52,128,2,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,64,0,193,16,226,177,70,99,164,222,72,242,40,82,0,13,160,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,16,0,48,68,120,172,209,152,169,55,146,60,138,20,64,3,40,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,12,0,25,128,55,0,60,128,20,220,3,40
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,3,0,6,96,13,192,15,32,5,55,0,202
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,192,1,152,3,112,3,200,193,77,128,50
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,48,0,102,0,220,0,242,112,83,160,12
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,9,128,31,0,52,132,60,232,19,80
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,2,96,7,192,13,33,15,58,4,212
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,152,1,240,67,72,131,206,1,53
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,38,0,124,16,210,160,243,64,77
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,48,1,152,0,236,33,60,27,40,20,192
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,12,0,102,0,59,8,79,6,202,5,48
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,3,128,25,192,14,194,19,129,178,1,76
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,192,0,96,6,176,3,240,132,160,108,0,83
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,1,144,0,248,1,44,55,60,10,200
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,100,0,62,0,75,13,207,2,178
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,25,128,15,192,18,195,115,128,172
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,64,6,224,3,176,4,240,220,32,43
       defb 1,0,16,8,0,32,26,0,29,70,126,173,3,70,20,173,127,6,127,205,27,198,15,141,0,6,3,128,146,216,217,88
       defb 0,64,4,2,0,8,6,128,135,81,95,171,128,209,69,43,159,193,95,243,134,241,67,227,128,1,0,224,36,182,54,86
       defb 0,16,129,0,0,2,1,160,97,212,215,234,96,52,209,74,103,240,215,252,97,188,208,248,96,0,0,56,137,45,141,149
       defb 0,4,32,64,128,0,0,104,24,117,181,250,24,13,180,82,25,252,53,255,24,111,52,62,24,0,0,14,98,75,99,101
       defb 8,32,0,0,0,132,26,0,29,70,126,173,3,70,20,173,127,6,127,205,27,198,15,141,0,6,3,128,146,216,217,88
       defb 2,8,0,0,0,33,6,128,135,81,95,171,128,209,69,43,159,193,95,243,134,241,67,227,128,1,0,224,36,182,54,86
       defb 0,130,0,0,64,8,1,160,97,212,215,234,96,52,209,74,103,240,215,252,97,188,208,248,96,0,0,56,137,45,141,149
       defb 128,32,0,0,16,2,0,104,24,117,181,250,24,13,180,82,25,252,53,255,24,111,52,62,24,0,0,14,98,75,99,101
       defb 0,128,16,8,4,0,0,88,98,184,181,126,98,192,181,40,96,254,179,254,99,216,177,240,96,0,1,192,27,73,26,155
       defb 0,32,4,2,1,0,0,22,24,174,173,95,24,176,45,74,152,63,172,255,24,246,44,124,24,0,0,112,70,210,198,166
       defb 0,8,129,0,0,64,128,5,134,43,235,87,6,44,139,82,230,15,235,63,134,61,11,31,6,0,0,28,145,180,177,169
       defb 0,2,32,64,0,16,96,1,225,138,250,213,1,139,162,212,249,131,250,207,97,143,194,199,1,128,0,7,36,109,108,106
       defb 4,16,0,0,33,0,0,88,98,184,181,126,98,192,181,40,96,254,179,254,99,216,177,240,96,0,1,192,27,73,26,155
       defb 1,4,0,0,8,64,0,22,24,174,173,95,24,176,45,74,152,63,172,255,24,246,44,124,24,0,0,112,70,210,198,166
       defb 0,65,0,0,2,16,128,5,134,43,235,87,6,44,139,82,230,15,235,63,134,61,11,31,6,0,0,28,145,180,177,169
       defb 64,16,0,0,0,132,96,1,225,138,250,213,1,139,162,212,249,131,250,207,97,143,194,199,1,128,0,7,36,109,108,106
       defb 0,0,26,8,45,88,62,174,3,72,20,168,127,8,127,204,27,207,15,140,0,46,211,192,198,166,10,246,29,208,61,92
       defb 0,0,6,130,11,86,143,171,0,210,5,42,31,194,31,243,198,243,3,227,128,11,52,240,177,169,130,189,7,116,15,87
       defb 0,0,129,160,130,213,227,234,128,52,129,74,135,240,199,252,241,188,192,248,224,2,13,60,108,106,96,175,1,221,195,213
       defb 0,0,32,104,96,181,184,250,32,13,160,82,33,252,49,255,60,111,48,62,184,0,3,79,155,26,216,43,64,119,112,245
       defb 0,8,26,24,45,78,62,168,3,72,20,168,127,12,127,207,27,204,15,142,0,32,3,198,102,166,106,240,29,208,61,92
       defb 0,2,6,134,139,83,15,170,0,210,5,42,31,195,223,243,6,243,131,227,0,8,128,241,153,169,26,188,7,116,15,87
       defb 128,0,129,161,226,212,131,234,128,52,129,74,199,240,247,252,193,188,224,248,0,2,96,60,102,106,6,175,1,221,195,213
       defb 32,0,96,104,56,181,160,250,32,13,160,82,49,252,61,255,48,111,56,62,128,0,24,15,153,154,193,171,64,119,112,245
       defb 0,0,16,88,26,180,117,124,18,192,21,40,16,254,51,254,243,216,49,240,116,0,3,203,101,99,103,80,11,184,58,188
       defb 0,0,4,22,6,173,29,95,4,176,5,74,132,63,140,255,60,246,12,124,29,0,192,242,217,88,25,212,2,238,14,175
       defb 0,0,129,5,65,171,199,87,1,44,129,82,225,15,227,63,143,61,3,31,7,64,176,60,54,86,6,117,128,187,195,171
       defb 0,0,96,65,208,106,241,213,0,75,160,84,248,67,248,207,99,207,192,199,1,208,44,15,141,149,65,157,224,46,240,234
       defb 16,0,24,88,114,180,21,124,18,192,21,40,48,254,243,254,51,216,113,240,4,0,99,192,101,102,15,86,11,184,58,188
       defb 4,0,6,22,28,173,5,95,4,176,5,74,140,63,188,255,12,246,28,124,1,0,24,240,153,89,131,213,2,238,14,175
       defb 1,0,129,133,71,43,193,87,1,44,129,82,227,15,239,63,131,61,7,31,0,64,6,60,102,86,96,245,128,187,195,171
       defb 0,64,96,97,209,202,240,85,0,75,160,84,248,195,251,207,96,207,193,199,0,16,1,143,153,149,88,61,224,46,240,234
       defb 10,160,18,144,36,72,40,68,36,34,34,34,18,66,18,68,36,136,4,136,4,8,4,0,2,0,0,0,0,0,0,0
       defb 2,168,4,164,9,18,10,17,137,8,136,136,132,144,4,145,9,34,1,34,1,2,1,0,0,128,0,0,0,0,0,0
       defb 0,170,1,41,130,68,66,132,34,66,34,34,33,36,65,36,130,72,128,72,128,64,0,64,0,32,0,0,0,0,0,0
       defb 128,42,64,74,32,145,16,161,136,144,136,136,8,73,16,73,32,146,32,18,32,16,0,16,0,8,0,0,0,0,0,0
       defb 10,160,18,144,36,136,73,4,41,4,36,136,18,144,18,144,36,72,72,64,16,32,16,16,8,0,0,0,0,0,0,0
       defb 2,168,4,164,9,34,18,65,10,65,9,34,4,164,4,164,9,18,18,16,4,8,4,4,2,0,0,0,0,0,0,0
       defb 0,170,1,41,130,72,68,144,66,144,130,72,1,41,1,41,130,68,4,132,1,2,1,1,0,128,0,0,0,0,0,0
       defb 128,42,64,74,32,146,17,36,16,164,32,146,64,74,64,74,32,145,1,33,128,64,64,64,0,32,0,0,0,0,0,0
       defb 10,160,18,80,34,40,34,36,17,36,17,20,33,20,34,36,18,72,8,80,8,16,0,8,0,0,0,0,0,0,0,0
       defb 2,168,4,148,8,138,8,137,4,73,4,69,8,69,8,137,4,146,2,20,2,4,0,2,0,0,0,0,0,0,0,0
       defb 0,170,1,37,130,34,66,34,65,18,65,17,66,17,66,34,129,36,0,133,0,129,128,0,0,0,0,0,0,0,0,0
       defb 128,42,64,73,160,136,144,136,144,68,80,68,80,132,144,136,32,73,64,33,64,32,32,0,0,0,0,0,0,0,0,0
       defb 225,7,16,136,9,16,4,160,11,208,125,190,202,83,147,201,50,76,35,196,65,130,67,194,133,161,135,225,130,65,132,33
       defb 248,65,4,34,2,68,1,40,2,244,159,111,242,148,100,242,12,147,8,241,144,96,144,240,97,104,97,248,96,144,97,8
       defb 126,16,129,8,0,145,0,74,0,189,231,219,60,165,153,60,195,36,66,60,36,24,36,60,24,90,24,126,24,36,24,66
       defb 31,132,32,66,64,36,128,18,64,47,249,246,79,41,38,79,48,201,16,143,9,6,9,15,134,22,134,31,6,9,134,16
       defb 96,134,145,9,136,145,5,32,11,208,61,188,106,86,211,203,178,77,33,132,65,130,195,195,133,161,135,225,68,34,34,68
       defb 152,33,100,66,98,36,1,72,2,244,15,111,154,149,244,242,108,147,8,97,144,96,240,240,97,104,97,248,145,8,8,145
       defb 102,8,153,16,24,137,0,82,0,189,195,219,102,165,189,60,219,36,66,24,36,24,60,60,24,90,24,126,36,66,66,36
       defb 25,130,38,68,70,34,128,20,64,47,240,246,89,169,47,79,54,201,16,134,9,6,15,15,134,22,134,31,137,16,16,137
       defb 94,122,94,124,94,122,126,124,0,0,126,126,126,126,0,0,66,128,37,80,40,42,16,4,0,0,0,0,0,0,0,0
       defb 151,158,23,159,151,158,31,159,0,0,159,159,159,159,0,0,16,160,9,84,138,10,4,1,0,0,0,0,0,0,0,0
       defb 165,231,197,231,165,231,199,231,0,0,231,231,231,231,0,0,4,40,2,85,162,130,65,0,0,0,0,0,0,0,0,0
       defb 233,121,241,121,233,121,241,249,0,0,249,249,249,249,0,0,1,10,64,149,168,160,16,64,0,0,0,0,0,0,0,0
       defb 94,122,94,124,94,122,126,124,0,0,126,126,126,126,0,0,0,0,0,0,0,160,65,80,42,10,20,4,0,0,0,0
       defb 151,158,23,159,151,158,31,159,0,0,159,159,159,159,0,0,0,0,0,0,0,40,16,84,138,130,5,1,0,0,0,0
       defb 165,231,197,231,165,231,199,231,0,0,231,231,231,231,0,0,0,0,0,0,0,10,4,21,162,160,65,64,0,0,0,0
       defb 233,121,241,121,233,121,241,249,0,0,249,249,249,249,0,0,0,0,0,0,128,2,65,5,40,168,16,80,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       defb 255,255,192,3,128,1,128,1,128,1,128,1,128,1,128,1,128,1,128,1,128,1,128,1,128,1,128,1,192,3,255,255
       defb 255,255,240,0,96,0,96,0,96,0,96,0,96,0,96,0,96,0,96,0,96,0,96,0,96,0,96,0,240,0,255,255
       defb 255,255,60,0,24,0,24,0,24,0,24,0,24,0,24,0,24,0,24,0,24,0,24,0,24,0,24,0,60,0,255,255
       defb 255,255,15,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,15,0,255,255
       defb 255,255,255,255,255,255,255,255,255,255,255,255,255,255,248,31,224,7,192,3,192,3,128,1,128,1,128,1,128,1,128,1
       defb 255,255,255,255,255,255,255,255,255,255,255,255,255,255,254,7,248,1,240,0,240,0,96,0,96,0,96,0,96,0,96,0
       defb 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,129,126,0,60,0,60,0,24,0,24,0,24,0,24,0,24,0
       defb 255,255,255,255,255,255,255,255,255,255,255,255,255,255,127,224,31,128,15,0,15,0,6,0,6,0,6,0,6,0,6,0
frmlst equ $
       defb 0,3
       defb 3,3
       defb 6,2
       defb 8,1
       defb 9,2
       defb 11,2
       defb 13,3
       defb 16,3
       defb 19,2
       defb 21,2
       defb 23,2
       defb 25,2
       defb 27,2
       defb 29,2
       defb 31,2
       defb 33,2
       defb 35,2
       defb 37,3
       defb 40,2
       defb 42,3
       defb 45,1
       defb 46,1,47,0
nmedat defb 0,0,128,144,7,19,16,184,7,19,168,160,8,20,64,152,255
       defb 0,0,88,224,3,3,88,200,3,3,56,104,5,17,120,152,5,17,120,128,6,18,56,176,8,20,32,48,255
       defb 0,0,88,96,255
       defb 0,0,88,56,5,17,120,64,5,17,128,144,8,20,56,208,255
       defb 0,0,40,72,255
       defb 0,0,128,16,8,20,128,160,255
       defb 0,0,104,128,5,17,48,136,7,19,40,96,255
       defb 0,0,56,128,255
       defb 0,0,120,32,7,19,16,168,8,20,128,192,255
       defb 0,0,120,88,255
NUMOBJ equ 48
objdta equ $
       defb 0,0,1,128,2,64,15,208,7,160,15,208,16,8,50,4,52,8,52,4,52,8,52,4,48,8,55,252,0,0,111,254,6,254,0,0,254,0,0
       defb 0,0,28,0,14,0,70,0,106,0,125,0,62,128,7,64,3,160,1,212,0,234,0,97,0,98,0,97,0,58,0,28,5,254,0,0,254,0,0
       defb 0,0,11,240,15,240,7,160,4,32,8,80,18,8,32,4,87,214,46,246,87,242,45,214,87,118,47,246,85,238,47,188,4,2,56,216,2,56,216
       defb 0,0,1,64,1,128,1,64,1,128,1,64,1,128,1,64,1,128,1,64,1,128,1,64,65,128,96,192,126,42,47,212,5,254,0,0,254,0,0
       defb 0,0,7,160,15,208,0,0,15,208,7,160,0,0,31,248,48,4,96,2,127,234,111,116,123,218,111,244,126,250,63,244,7,6,48,184,6,48,184
       defb 0,0,7,224,24,24,56,28,110,54,108,116,106,86,102,100,110,86,110,100,110,86,46,116,110,118,6,48,14,112,14,112,2,254,0,0,254,0,0
       defb 0,0,0,24,0,24,6,192,15,248,16,4,21,52,52,148,48,4,31,252,21,84,26,172,21,84,26,172,21,84,15,248,6,4,128,32,4,128,32
       defb 0,0,51,204,53,172,15,240,14,112,11,208,100,38,239,247,222,123,29,184,29,184,30,120,111,246,240,15,208,11,96,6,7,254,0,0,254,0,0
       defb 0,0,60,0,107,0,75,128,117,64,73,32,49,80,62,88,16,88,11,152,4,24,3,232,1,244,0,12,0,2,0,1,6,254,0,0,254,0,0
       defb 0,0,0,0,0,0,127,244,127,244,0,0,63,104,62,104,60,24,25,208,19,208,103,208,111,208,0,0,31,208,31,208,5,254,0,0,254,0,0
       defb 0,0,15,240,15,240,58,92,79,242,129,129,135,225,79,178,73,178,63,252,29,184,14,112,15,240,62,124,64,2,127,254,7,254,0,0,254,0,0
       defb 0,0,1,128,0,0,5,160,12,16,25,232,19,208,19,232,51,244,39,232,39,244,39,232,39,244,39,232,0,0,79,250,6,254,0,0,254,0,0
       defb 0,0,0,56,0,104,0,118,0,126,0,234,1,220,3,160,7,64,110,128,253,0,222,0,108,0,30,0,26,0,12,0,7,255,0,0,255,0,0
       defb 0,0,255,255,214,99,239,211,254,127,139,211,142,127,139,225,134,97,255,255,138,65,255,193,146,65,255,193,162,65,255,255,7,255,0,0,255,0,0
       defb 0,0,6,224,28,120,62,124,38,100,88,26,86,106,40,20,110,118,109,182,91,218,58,92,61,188,29,184,14,112,0,0,5,254,0,0,254,0,0
       defb 0,0,7,160,15,208,0,0,15,208,7,160,0,0,31,248,32,4,76,0,92,2,80,0,80,2,119,244,127,250,63,244,2,254,0,0,254,0,0
       defb 0,0,62,0,65,0,144,128,160,160,166,184,142,164,140,130,65,2,62,28,0,96,63,128,96,24,144,228,89,24,38,0,6,254,0,0,254,0,0
       defb 0,0,192,112,224,140,49,2,57,1,76,1,7,2,13,130,12,130,47,129,71,1,64,2,32,2,24,4,7,8,0,240,6,254,0,0,254,0,0
       defb 0,0,3,192,4,160,3,192,0,0,3,192,2,64,4,32,4,32,8,16,12,48,31,216,27,168,55,212,55,168,63,84,5,254,0,0,254,0,0
       defb 0,0,7,160,15,208,0,0,15,208,7,160,0,0,31,248,32,4,76,0,92,2,80,0,80,2,72,0,64,2,63,244,7,254,0,0,254,0,0
       defb 0,0,0,12,0,12,0,4,0,4,67,4,251,100,32,20,127,234,95,244,95,234,95,244,95,234,95,244,103,234,63,212,5,254,0,0,254,0,0
       defb 0,0,1,0,1,128,18,64,12,0,4,0,14,192,30,240,61,232,59,244,123,232,119,244,119,232,59,212,59,168,29,80,70,254,0,0,254,0,0
       defb 0,0,129,129,1,128,128,1,193,130,227,197,183,238,190,253,189,186,190,93,186,122,221,181,103,106,63,212,64,2,63,252,6,254,0,0,254,0,0
       defb 127,254,112,14,53,94,50,174,117,92,127,250,127,253,63,229,63,229,127,253,127,250,127,252,63,254,63,254,120,30,127,254,3,254,0,0,254,0,0
       defb 255,255,128,1,191,253,176,13,146,173,149,93,178,173,181,93,191,253,191,245,191,253,176,13,181,93,146,173,149,93,191,253,6,254,0,0,254,0,0
       defb 63,252,63,252,8,26,42,186,89,90,90,188,89,92,95,252,95,252,95,252,95,252,95,250,47,250,15,250,63,252,63,252,5,2,88,152,2,88,152
       defb 31,252,63,250,8,26,42,186,89,90,90,186,89,92,58,188,57,92,90,188,89,90,90,186,41,90,10,186,63,250,31,252,2,254,0,0,254,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,56,0,84,0,130,128,214,189,214,63,130,128,84,11,56,3,3,255,0,0,255,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,60,2,126,2,195,254,91,166,91,2,195,2,126,1,60,6,255,0,0,255,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,60,0,126,0,231,254,219,170,219,0,231,240,126,208,60,5,255,0,0,255,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,28,0,32,96,174,64,177,255,157,250,117,64,4,101,56,1,2,5,128,176,5,128,176
       defb 0,0,1,224,7,240,31,0,28,160,3,240,15,240,15,160,7,192,16,0,24,0,5,128,29,128,12,0,17,0,60,0,7,254,0,0,254,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,38,0,111,0,111,128,111,152,119,154,55,128,27,157,27,45,24,107,7,254,0,0,254,0,0
       defb 0,0,0,0,0,8,0,124,0,254,0,252,0,158,0,223,0,126,45,188,91,192,43,224,83,48,5,176,97,152,116,220,7,1,32,32,1,32,32
       defb 2,240,1,240,2,240,1,192,2,208,15,252,16,0,3,208,7,252,7,120,7,152,3,224,0,0,7,128,54,146,53,54,7,5,128,144,5,128,144
       defb 0,0,0,0,0,0,0,0,127,246,255,239,223,109,241,239,0,0,251,239,219,107,255,237,223,107,223,109,223,111,255,239,2,254,0,0,254,0,0
       defb 0,0,0,7,0,8,0,7,0,15,0,112,1,143,2,122,5,251,11,250,23,186,23,255,47,255,45,255,47,255,95,255,71,254,0,0,254,0,0
       defb 112,0,143,56,120,196,142,2,197,194,56,100,198,24,123,0,126,128,255,64,119,160,255,160,255,208,254,208,223,208,191,232,71,254,0,0,254,0,0
       defb 83,255,83,252,91,252,83,255,95,255,47,255,45,255,47,255,23,255,23,188,11,253,5,252,2,124,1,143,0,112,0,15,71,254,0,0,254,0,0
       defb 127,42,255,172,255,174,63,42,207,200,243,144,253,144,255,16,254,32,244,32,248,64,240,128,193,0,6,0,56,0,192,0,71,254,0,0,254,0,0
       defb 57,190,127,255,240,7,160,3,96,3,163,226,255,227,176,3,96,2,160,7,67,253,62,235,67,222,34,251,1,110,0,60,7,254,0,0,254,0,0
       defb 0,0,7,160,15,208,0,0,15,208,7,160,0,0,31,248,32,4,76,0,92,2,80,0,80,2,119,244,127,250,63,244,2,254,0,0,254,0,0
       defb 7,160,13,208,7,160,0,0,15,240,16,8,36,68,40,8,73,4,72,74,87,244,117,250,55,116,59,232,31,212,13,168,7,254,0,0,254,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,254,0,0,254,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,254,0,0,254,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,254,0,0,254,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,254,0,0,254,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,254,0,0,254,0,0
palett equ $
       defb 0,3,28,31,224,227,252,255,0,3,28,31,224,227,252,255
       defb 0,3,28,31,224,227,252,255,0,3,28,31,224,227,252,255
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
       defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
font   equ $
       defb 0,0,0,0,0,0,0,0
       defb 24,12,28,24,8,16,48,0
       defb 36,108,76,0,0,0,0,0
       defb 68,108,254,108,254,108,40,0
       defb 8,60,106,112,28,214,124,32
       defb 66,228,108,24,52,110,140,0
       defb 96,208,212,124,206,236,118,0
       defb 24,24,16,0,0,0,0,0
       defb 12,24,48,48,48,56,28,0
       defb 56,28,12,12,12,24,48,0
       defb 0,88,52,254,88,52,0,0
       defb 40,24,24,126,24,16,24,0
       defb 0,0,0,0,0,0,24,48
       defb 0,0,0,240,30,0,0,0
       defb 0,0,0,0,0,0,24,0
       defb 0,6,14,24,48,112,64,0
       defb 24,60,102,214,198,204,120,0
       defb 12,28,12,12,24,24,52,0
       defb 120,236,12,24,112,230,188,0
       defb 118,30,12,60,134,230,124,0
       defb 40,48,48,102,252,78,24,0
       defb 124,98,240,220,6,206,124,0
       defb 28,50,96,124,230,238,124,0
       defb 122,230,12,28,56,24,16,0
       defb 56,108,198,124,198,238,124,0
       defb 120,204,198,126,6,156,120,0
       defb 0,16,24,0,0,8,24,0
       defb 0,8,24,0,0,16,24,48
       defb 6,14,28,112,24,28,14,0
       defb 0,0,56,14,112,30,0,0
       defb 48,56,28,6,12,24,56,0
       defb 124,238,70,28,16,8,24,0
       defb 120,252,150,126,238,222,106,0
       defb 104,56,40,108,124,198,172,0
       defb 184,108,102,124,102,118,220,0
       defb 56,108,194,192,192,102,60,0
       defb 184,108,102,102,102,102,220,0
       defb 188,98,104,120,96,118,220,0
       defb 188,98,104,120,96,96,208,0
       defb 56,108,192,222,204,230,122,0
       defb 170,102,102,126,102,102,204,0
       defb 44,24,24,24,24,24,44,0
       defb 22,12,12,12,140,220,120,0
       defb 170,102,108,120,108,102,204,0
       defb 192,96,96,96,96,102,188,32
       defb 164,254,254,214,214,198,140,0
       defb 170,230,246,254,222,206,132,0
       defb 52,120,204,134,198,236,120,0
       defb 184,236,102,108,112,96,208,0
       defb 56,108,102,198,214,108,54,0
       defb 216,124,102,124,102,102,202,0
       defb 54,110,96,60,142,230,124,0
       defb 118,122,152,24,24,24,52,0
       defb 170,110,102,102,102,102,60,0
       defb 172,198,198,108,108,60,24,0
       defb 108,108,198,214,254,238,68,0
       defb 172,102,108,56,108,204,108,0
       defb 76,198,102,60,24,24,48,0
       defb 184,236,24,48,98,204,124,0
       defb 44,48,48,48,48,48,28,0
       defb 0,96,48,24,24,14,2,0
       defb 52,12,12,12,12,12,56,0
       defb 24,60,126,236,108,88,80,0
       defb 0,0,0,0,0,0,0,255
       defb 60,98,104,188,96,108,218,0
       defb 12,16,16,68,152,128,124,0
       defb 132,120,4,4,66,70,252,0
       defb 16,80,82,248,32,102,60,0
       defb 34,34,82,156,200,216,100,0
       defb 0,4,66,132,120,212,82,0
       defb 28,50,52,248,36,36,72,0
       defb 0,0,118,236,204,124,24,112
       defb 102,255,253,253,251,126,60,24
       defb 0,102,255,253,255,126,60,24
       defb 1,2,2,254,166,2,2,1
       defb 60,126,195,91,91,195,126,60
       defb 28,32,166,165,157,117,4,56
       defb 0,0,0,255,250,64,101,1
       defb 56,84,130,214,214,130,84,56
       defb 0,0,128,189,63,128,11,3
       defb 0,0,0,254,170,0,240,208
       defb 60,126,231,219,219,231,126,60
       defb 254,128,32,62,0,8,14,0
       defb 255,1,4,252,0,16,240,0
       defb 0,90,92,90,0,90,92,90
       defb 0,0,0,0,0,0,0,0
       defb 0,0,0,0,255,0,0,0
       defb 0,0,0,0,240,8,5,2
       defb 0,0,16,40,69,133,2,2
       defb 64,64,161,162,20,8,0,0
       defb 0,0,0,128,71,40,16,0
       defb 12,26,48,224,48,50,28,0
       defb 8,16,24,24,24,24,16,0
       defb 96,176,24,14,24,216,112,0
       defb 0,4,50,126,108,32,0,0
       defb 62,99,221,181,177,155,198,124
jtab   equ $
       defb 99
keys   defb 34,26,38,37,32,31,1,36,28,20,12


; Game engine code --------------------------------------------------------------

; Arcade Game Designer.
; (C) 2008 - 2020 Jonathan Cauldwell.
; ZX Spectrum Engine v0.7.10

; Global definitions.

SIMASK equ 248             ; SPRITEINK mask - allows users to set BRIGHT/FLASH/CLUT as well.
SHRAPN equ 63926           ; shrapnel table, just below screen address table.
SCADTB equ 64256           ; screen address table, just below map.
MAP    equ 64768           ; properties map buffer.
loopa  equ 23681           ; loop counter system variable.
loopb  equ 23728           ; loop counter system variable.
loopc  equ 23729           ; loop counter system variable.

; Block characteristics.

PLATFM equ 1               ; platform.
WALL   equ PLATFM + 1      ; solid wall.
LADDER equ WALL + 1        ; ladder.
FODDER equ LADDER + 1      ; fodder block.
DEADLY equ FODDER + 1      ; deadly block.
CUSTOM equ DEADLY + 1      ; custom block.
WATER  equ CUSTOM + 1      ; water block.
COLECT equ WATER + 1       ; collectable block.
NUMTYP equ COLECT + 1      ; number of types.

; Sprites.

NUMSPR equ 12              ; number of sprites. maximo 10 con MASKAGD

	IF MASKAGD = 0
TABSIZ equ 17              ; size of each entry.
	ELSE
TABSIZ equ 17 + 1 + 48 + 1 + 1 + 48			; size + coor_Z + buffer_fondo + IMask + solapamiento + BufferPrint
	ENDIF
		
SPRBUF equ NUMSPR * TABSIZ ; size of entire table.	
NMESIZ equ 4               ; bytes stored in nmetab for each sprite.
X      equ 8               ; new x coordinate of sprite.
Y      equ X + 1           ; new y coordinate of sprite.
PAM1ST equ 5               ; first sprite parameter, old x (ix+5).
; Particle engine.

NUMSHR equ 55              ; pieces of shrapnel.
SHRSIZ equ 6               ; bytes per particle.

; Game starts here.
; Musicizer relies on distance between start and varm remaining constant at 34 bytes.
; Do not mess with this section or users will be unable to control music with the M variable.

start  equ $

       ld hl,font - 256      ; address of font.
       ld (23606),hl       ; set up game font.

; if you wish to exit to BASIC at the end of each game, change "jp gamelp" to "jp game".
       jp gamelp           ; start the game.

; variables, mover en caso de ULABuffer MEIGA 2026
	IF ULABUFFER = 0
joyval defb 0              ; joystick reading.
frmno  defb 0              ; selected frame.

; Don't change the order of these four.  Menu routine relies on winlft following wintop.

wintop defb WINDOWTOP      ; top of window.
winlft defb WINDOWLFT      ; left edge.
winhgt defb WINDOWHGT      ; window height.
winwid defb WINDOWWID      ; window width.

numob  defb NUMOBJ         ; number of objects in game.

; Variables start here.
; Pixel versions of wintop, winlft, winhgt, winwid.

wntopx defb (8 * WINDOWTOP)
wnlftx defb (8 * WINDOWLFT)
wnbotx defb ((WINDOWTOP * 8) + (WINDOWHGT * 8) - 16)
wnrgtx defb ((WINDOWLFT * 8) + (WINDOWWID * 8) - 16)
scno   defb 0              ; present screen number.
numlif defb 3              ; number of lives.
vara   defb 0              ; general-purpose variable.
varb   defb 0              ; general-purpose variable.
varc   defb 0              ; general-purpose variable.
vard   defb 0              ; general-purpose variable.
vare   defb 0              ; general-purpose variable.
varf   defb 0              ; general-purpose variable.
varg   defb 0              ; general-purpose variable.
varh   defb 0              ; general-purpose variable.
vari   defb 0              ; general-purpose variable.
varj   defb 0              ; general-purpose variable.
vark   defb 0              ; general-purpose variable.
varl   defb 0              ; general-purpose variable.
varm   defb 0              ; general-purpose variable.
varn   defb 0              ; general-purpose variable.
varo   defb 0              ; general-purpose variable.
varp   defb 0              ; general-purpose variable.
varq   defb 0              ; general-purpose variable.
varr   defb 0              ; general-purpose variable.
vars   defb 0              ; general-purpose variable.
vart   defb 0              ; general-purpose variable.
varu   defb 0              ; general-purpose variable.
varv   defb 0              ; general-purpose variable.
varw   defb 0              ; general-purpose variable.
varz   defb 0              ; general-purpose variable.
contrl defb 0              ; control, 0 = keyboard, 1 = Kempston, 2 = Sinclair, 3 = Mouse.
charx  defb 0              ; cursor x position.
chary  defb 0              ; cursor y position.
clock  defb 0              ; last clock reading.
varrnd defb 255            ; last random number.
varobj defb 254            ; last object number.
varopt defb 255            ; last option chosen from menu.
varblk defb 255            ; block type.
nexlev defb 0              ; next level flag.
restfl defb 0              ; restart screen flag.
deadf  defb 0              ; dead flag.
gamwon defb 0              ; game won flag.
dispx  defb 0              ; cursor x position.
dispy  defb 0              ; cursor y position.

; Make sure pointers are arranged in the same order as the data itself.

frmptr defw frmlst         ; sprite frames.
blkptr defw chgfx          ; block graphics.
colptr defw bcol           ; address of char colours.
proptr defw bprop          ; address of char properties.
scrptr defw scdat          ; address of screens.
nmeptr defw nmedat         ; enemy start positions.
	ELSE
		; MOVIDAS a header
	ENDIF
	
; Assorted game routines which can go in contended memory.

	IF INVENTARY = 1				; ContainerMod by Ramon Fernandez Ameijeiras

; Modify for inventory.

minve  ld hl,invdis        ; routine address.
       ld (mod0+1),hl      ; set up menu routine.
       ld (mod2+1),hl      ; set up count routine.
       ld hl,fopt          ; find option from available objects.
       ld (mod1+1),hl      ; set up routine.
       jr dbox             ; do menu routine.

; Modify for menu.

mmenu  ld hl,always        ; routine address.
       ld (mod0+1),hl      ; set up routine.
       ld (mod2+1),hl      ; set up count routine.
       ld hl,fstd          ; standard option selection.
       ld (mod1+1),hl      ; set up routine.

; Drop through into box routine.

; Work out size of box for message or menu.

;dbox   ld hl,nummsg        ; total messages.
;       cp (hl)             ; does this one exist?
;       ret nc              ; no, nothing to display.



dbox   ld hl,msgdat        ; pointer to messages.
       call getwrd         ; get message number.
       push hl             ; store pointer to message.
       ld d,1              ; height.
       xor a               ; start at object zero.
       ld (combyt),a       ; store number of object in combyt.
       ld e,a              ; maximum width.
dbox5  ld b,0              ; this line's width.
mod2   call always         ; item in player's possession?
       jr nz,dbox6         ; not in inventory, skip this line.
       inc d               ; add to tally.
dbox6  ld a,(hl)           ; get character.
       inc hl              ; next character.
       cp ','              ; reached end of line?
       jr z,dbox3          ; yes.
       cp 13               ; reached end of line?
       jr z,dbox3          ; yes.
       inc b               ; add to this line's width.
       and a               ; end of message?
       jp m,dbox4          ; yes, end count.
       jr dbox6            ; repeat until we find the end.
dbox3  ld a,e              ; maximum line width.
       cp b                ; have we exceeded longest so far?
       jr nc,dbox5         ; no, carry on looking.
       ld e,b              ; make this the widest so far.
       jr dbox5            ; keep looking.
dbox4  ld a,e              ; maximum line width.
       cp b                ; have we exceeded longest so far?
       jr nc,dbox8         ; no, carry on looking.
       ld e,b              ; final line is the longest so far.
dbox8  dec d               ; decrement items found.
       jp z,dbox15         ; total was zero.
       ld a,e              ; longest line.
       and a               ; was it zero?
       jp z,dbox15         ; total was zero.
       ld (bwid),de        ; set up size.

; That's set up our box size.

       ld a,(winhgt)       ; window height in characters.
       sub d               ; subtract height of box.
       rra                 ; divide by 2.
       ld hl,wintop        ; top edge of window.
       add a,(hl)          ; add displacement.
       ld (btop),a         ; set up box top.
       ld a,(winwid)       ; window width in characters.
       sub e               ; subtract box width.
       rra                 ; divide by 2.
       inc hl              ; left edge of window.
       add a,(hl)          ; add displacement.
       ld (blft),a         ; box left.
       ld hl,(23606)       ; font.
       ld (grbase),hl      ; set up for text display.
       pop hl              ; restore message pointer.
       ld a,(btop)         ; box top.
       ld (dispx),a        ; set display coordinate.
       xor a               ; start at object zero.
       ld (combyt),a       ; store number of object in combyt.
dbox2  ld a,(combyt)       ; get object number.
mod0   call always         ; check inventory for display.
       jp nz,dbox13        ; not in inventory, skip this line.

       ld a,(blft)         ; box left.
       ld (dispy),a        ; set left display position.
       ld a,(bwid)         ; box width.
       ld b,a              ; store width.
dbox0  ld a,(hl)           ; get character.
       cp ','              ; end of line?
       jr z,dbox1          ; yes, next one.
       cp 13               ; end of option?
       jr z,dbox1          ; yes, on to next.
       dec b               ; one less to display.
       and 127             ; remove terminator.
       push bc             ; store characters remaining.
       push hl             ; store address on stack.
       push af             ; store character.
       call gaadd          ; get attribute address.
       ld a,(23693)        ; current colour.
       ld (hl),a           ; set attribute.
       pop af              ; restore character.
       call pchr           ; display on screen.
       pop hl              ; retrieve address of next character.
       pop bc              ; chars left for this line.
       ld a,(hl)           ; get character.
       inc hl              ; next character.
       cp 128              ; end of message?
       jp nc,dbox7         ; yes, job done.
       ld a,b              ; chars remaining.
       and a               ; are any left?
       jr nz,dbox0         ; yes, continue.

; Reached limit of characters per line.

dbox9  ld a,(hl)           ; get character.
       inc hl              ; next one.
       cp ','              ; another line?
       jr z,dbox10         ; yes, do next line.
       cp 13               ; another line?
       jr z,dbox10         ; yes, on to next.
       cp 128              ; end of message?
       jr nc,dbox11        ; yes, finish message.
       jr dbox9

; Fill box to end of line.

dboxf  push hl             ; store address on stack.
       push bc             ; store characters remaining.
       call gaadd          ; get attribute address.
       ld a,(23693)        ; current colour.
       ld (hl),a           ; set attribute.
       ld a,32             ; space character.
       call pchr           ; display character.
       pop bc              ; retrieve character count.
       pop hl              ; retrieve address of next character.
       djnz dboxf          ; repeat for remaining chars on line.
       ret
dbox1  inc hl              ; skip character.
       call dboxf          ; fill box out to right side.
dbox10 ld a,(dispx)        ; x coordinate.
       inc a               ; down a line.
       ld (dispx),a        ; next position.
       jp dbox2            ; next line.
dbox7  ld a,b              ; chars remaining.
       and a               ; are any left?
       jr z,dbox11         ; no, nothing to draw.
       call dboxf          ; fill message to line.

; Drawn the box menu, now select option.

dbox11 ld a,(btop)         ; box top.
       ld (dispx),a        ; set bar position.
dbox14 call joykey         ; get controls.
       and 31              ; anything pressed?
       jr nz,dbox14        ; yes, debounce it.
       call dbar           ; draw bar.
dbox12 call joykey         ; get controls.
       and 28              ; anything pressed?
       jr z,dbox12         ; no, nothing.
       and 16              ; fire button pressed?
mod1   jp nz,fstd          ; yes, job done.
       call dbar           ; delete bar.
       ld a,(joyval)       ; joystick reading.
       and 8               ; going up?
       jr nz,dboxu         ; yes, go up.
       ld a,(dispx)        ; vertical position of bar.
       inc a               ; look down.
       ld hl,btop          ; top of box.
       sub (hl)            ; find distance from top.
       dec hl              ; point to height.
       cp (hl)             ; are we at end?
       jp z,dbox14         ; yes, go no further.
       ld hl,dispx         ; coordinate.
       inc (hl)            ; move bar.
       jr dbox14           ; continue.
dboxu  ld a,(dispx)        ; vertical position of bar.
       ld hl,btop          ; top of box.
       cp (hl)             ; are we at the top?
       jp z,dbox14         ; yes, go no further.
       ld hl,dispx         ; coordinate.
       dec (hl)            ; move bar.
       jr dbox14           ; continue.
fstd   ld a,(dispx)        ; bar position.
       ld hl,btop          ; top of menu.
       sub (hl)            ; find selected option.
       ld (varopt),a       ; store the option.
       jp redraw           ; redraw the screen.

; Option not available.  Skip this line.

dbox13 ld a,(hl)           ; get character.
       inc hl              ; next one.
       cp ','              ; another line?
       jp z,dbox2          ; yes, do next line.
       cp 13               ; another line?
       jp z,dbox2          ; yes, on to next line.
       and a               ; end of message?
       jp m,dbox11         ; yes, finish message.
       jr dbox13
dbox15 pop hl              ; pop message pointer from the stack.
       ret

dbar   ld a,(blft)         ; box left.
       ld (dispy),a        ; set display coordinate.
       call gprad          ; get printing address.
       ex de,hl            ; flip into hl register pair.
       ld a,(bwid)         ; box width.
       ld c,a              ; loop counter in c.
       ld d,h              ; store screen address high byte.
dbar1  ld b,8              ; pixel height in b.
dbar0  ld a,(hl)           ; get screen byte.
       cpl                 ; reverse all bits.
       ld (hl),a           ; write back to screen.
       inc h               ; next line down.
       djnz dbar0          ; draw rest of character.
       ld h,d              ; rsetore screen address.
       inc l               ; one char right.
       dec c               ; decrement character counter.
       jr nz,dbar1         ; repeat for whole line.
       ret

invdis push hl             ; store message text pointer.
       push de             ; store de pair for line count.
       ld hl,combyt        ; object number.
       ld a,(hl)           ; get object number.
       inc (hl)            ; ready for next one.
       call gotob          ; check if we have object.
       pop de              ; retrieve de pair from stack.
       pop hl              ; retrieve text pointer.
       ret
;always xor a               ; set zero flag.
;       ret

; Find option selected.

fopt   ld a,(dispx)
       ld hl,btop          ; top of menu.
       sub (hl)            ; find selected option.
       inc a               ; object 0 needs one iteration, 1 needs 2 and so on.
       ld b,a              ; option selected in b register.
       ld hl,combyt        ; object number.
       ld (hl),0           ; set to first item.
fopt0  push bc             ; store option counter in b register.
       call fobj           ; find next object in inventory.
       pop bc              ; restore option counter.
       djnz fopt0          ; repeat for relevant steps down the list.
       ld a,(combyt)       ; get option.
       dec a               ; one less, due to where we increment combyt.
       ld (varopt),a       ; store the option.
       jp redraw           ; redraw the screen.

fobj   ld hl,combyt        ; object number.
       ld a,(hl)           ; get object number.
       inc (hl)            ; ready for next item.
       ret z               ; in case we loop back to zero.
       call gotob          ; do we have this item?
       ret z               ; yes, it's on the list.
       jr fobj             ; repeat until we find next item in pockets.

bwid   defb 0              ; box/menu width.
blen   defb 0              ; box/menu height.
btop   defb 0              ; box coordinates.
blft   defb 0

	ELSE				; ContainerMod by Ramon Fernandez Ameijeiras
dbox   ld hl,msgdat        ; pointer to messages.		
	ENDIF				; ContainerMod by Ramon Fernandez Ameijeiras 

; Wait for keypress.

prskey call debkey         ; debounce key.
prsky0 call vsync          ; vertical synch.
       call 654            ; return keyboard state in e.
       inc e               ; is it 255?
       jr z,prsky0         ; yes, repeat until key pressed.

; Debounce keypress.

debkey call vsync          ; update scrolling, sounds etc.
       call 654            ; d=shift, e=key.
       inc e               ; is it 255?
       jr nz,debkey        ; no - loop until key is released.
       ret

; Delay routine.

delay  push bc             ; store loop counter.
       call vsync          ; wait for interrupt.
       pop bc              ; restore counter.
       djnz delay          ; repeat.
       ret

; Clear sprite table.

xspr
		ld hl,sprtab        ; sprite table.
		ld bc,SPRBUF         ; length of table.
xspr0	ld (hl),255         ; clear one byte.
		inc hl              ; move to next byte.
		dec bc
		ld a,b
		or c
		jr nz,xspr0          ; repeat for rest of table.
		ret

; xspr   ld b,NUMSPR         ; sprite slots in table.
       ; ld ix,sprtab        ; sprite table.
       ; ld de,TABSIZ        ; distance to next odd/even entry.
; xspr0  ld (ix+0),255       ; delete sprite.
       ; ld (ix+1),255       
       ; ld (ix+2),255       
       ; ld (ix+3),255       
       ; ld (ix+4),255       
       ; ld (ix+5),255       
       ; ld (ix+6),255       
       ; ld (ix+7),255       
       ; ld (ix+8),255       
       ; ld (ix+9),255       
       ; ld (ix+10),255       
       ; ld (ix+11),255       
       ; ld (ix+12),255       
       ; ld (ix+13),255       
       ; ld (ix+14),255       
       ; ld (ix+15),255       
       ; ld (ix+16),255            
       ; add ix,de           ; next sprite.
       ; djnz xspr0          ; one less space in the table.
       ; ret

; xspr
       ; ld hl,sprtab        ; sprite table.
       ; ld bc,SPRBUF         ; length of table.
; xspr0  ld (hl),255         ; clear one byte.
       ; inc hl              ; move to next byte.
       ; djnz xspr0          ; repeat for rest of table.
       ; ret

; Initialise all objects.

iniob  ld ix,objdta        ; objects table.
       ld a,(numob)        ; number of objects in the game.
       ld b,a              ; loop counter.
       ld de,39            ; distance between objects.
iniob0 ld a,(ix+36)        ; start screen.
       ld (ix+33),a        ; set start screen.
       ld a,(ix+37)        ; find start x.
       ld (ix+34),a        ; set start x.
       ld a,(ix+38)        ; get initial y.
       ld (ix+35),a        ; set y coord.
       add ix,de           ; point to next object.
       djnz iniob0         ; repeat.
       ret

; Screen synchronisation.

vsync  call joykey         ; read joystick/keyboard.
       ld a,(sndtyp)       ; sound to play.
       and a               ; any sound?
       jp z,vsync1         ; no.
       ld b,a              ; outer loop.
       ld a,(23624)        ; border colour.
       rra                 ; put border bits into d0, d1 and d2.
       rra
       rra
       ld c,a              ; first value to write to speaker.
       ld a,b              ; sound.
       and a               ; test it.
       jp m,vsync6         ; play white noise.
vsync2 ld a,c              ; get speaker value.
       out (254),a         ; write to speaker.
       xor 248             ; toggle all except the border bits.
       ld c,a              ; store value for next time.
       ld d,b              ; store loop counter.
vsync3 ld hl,clock         ; previous clock setting.
       ld a,(23672)        ; current clock setting.
       cp (hl)             ; subtract last reading.
       jp nz,vsync4        ; yes, no more processing please.
       djnz vsync3         ; loop.
       ld b,d              ; restore loop counter.
       djnz vsync2         ; continue noise.
vsync4 ld a,d              ; where we got to.
vsynca ld (sndtyp),a       ; remember for next time.

vsync1 ld a,(23672)        ; clock low.
       rra                 ; rotate bit into carry.
       call c,vsync5       ; time to play sound and do shrapnel/ticker stuff.
       ld hl,clock         ; last clock reading.
vsync0 ld a,(23672)        ; current clock reading.
       cp (hl)             ; are they the same?
       jr z,vsync0         ; yes, wait until clock changes.
       ld (hl),a           ; set new clock reading.
       ret

vsync5 call plsnd          ; play sound.

       jp proshr           ; shrapnel and stuff.

; Play white noise.

vsync6 ld a,b              ; 128 - 255.
       sub 127
       ld b,a
       ld hl,clock         ; previous clock setting.
vsync7 ld a,r              ; get random speaker value.
       and 248             ; only retain the speaker/earphone bits.
       or c                ; merge with border colour.
       out (254),a         ; write to speaker.
       ld a,(23672)        ; current clock setting.
       cp (hl)             ; subtract last reading.
       jp nz,vsync8        ; yes, no more processing please.
       ld a,b
       and 127
       inc a
vsync9 dec a
       jr nz,vsync9        ; loop.
       djnz vsync7         ; continue noise.
vsync8 xor a
       jr vsynca
sndtyp defb 0
;clock  defb 0              ; last clock reading.

; Redraw the screen.

; Remove old copy of all sprites for redraw.

redraw push ix             ; place sprite pointer on stack.
	IF ZEROMOD = 1
		call FixScreen		; MEIGA obtiene scno-FixDesplazamiento
	ENDIF
       call droom          ; show screen layout.
	IF ZEROMOD = 1
	   call initsc			; MEIGA obtiene scno global***
	ENDIF
       call shwob          ; draw objects.
	   
numsp0 ld b,NUMSPR         ; sprites to draw.
       ld ix,sprtab        ; sprite table.
redrw0 ld a,(ix+0)         ; old sprite type.
       inc a               ; is it enabled?
       jr z,redrw1         ; no, find next one.
       ld a,(ix+3)         ; sprite x.
       cp 177              ; beyond maximum?
       jr nc,redrw1        ; yes, nothing to draw.
       push bc             ; store sprite counter.
	   call sspria         ; BORRA
       pop bc              ; retrieve sprite counter.
redrw1 ld de,TABSIZ        ; distance to next odd/even entry.
       add ix,de           ; next sprite.
       djnz redrw0         ; repeat for remaining sprites.
       
	   call rbloc          ; redraw blocks if in adventure mode.
       call dshrp          ; redraw shrapnel.
       pop ix              ; retrieve sprite pointer.
       ret

; Clear screen routine.

cls	   ld hl,16384         ; screen address.
       ld (hl),l           ; blank first byte.
       ld de,16385         ; second byte.
       ld bc,6144          ; bytes to copy.
       ldir                ; blank them all.
	   ld a,(23693)        ; fetch attributes.
       ld (hl),a           ; set first attribute cell.
       ld bc,767           ; number of attributes.
	   ldir                ; set all attributes.
       ld hl,0             ; set hl to origin (0, 0).
       ld (charx),hl       ; reset coordinates.
	   ret

; Set palette routine and data.
; Palette.
; 48955 = register select port.
; 65339 = data read/write port.

; 48955 = write to register:
; d0-d5 : select register sub-group.
; d6-d7 : select register group.
;         00 = sub-group determines entry in palette table.
;         64 = mode select, write d0 to 65339 to toggle mode on/off.

; 65339 = data read/write:
; d0-d1 : blue intensity (last bit duplicated so Bb is Bbb)
; d2-d4 : red intensity
; d5-d7 : green intensity

setpal ld bc,48955         ; register select.
       ld a,64             ; mode select.
       out (c),a           ; set ULAplus mode.
       ld b,255            ; data write.
       ;ld a,1              ; mode on.
	   
       ld a,ULAPLUS        ; mode on.
       out (c),a           ; switch on ULAplus.

       ld b,64             ; number of palette table entries to write.
setpa1 ld hl,palett        ; palette we want.
       ld e,0              ; register number.
setpa0 push bc             ; store counter.
       ld b,191            ; register select.
       ld a,e              ; register number to write.
       out (c),a           ; write to port.
       ld b,255            ; data select.
       ld a,(hl)           ; get colour data from table.
       out (c),a           ; write to port.
       inc e               ; next clut entry.
       inc hl              ; next table entry.
       pop bc              ; restore counter from stack.
       djnz setpa0         ; set rest of palette.
       ret

endpal equ $

fdchk  ld a,(hl)           ; fetch cell.
       cp FODDER           ; is it fodder?
       ret nz              ; no.
       ld (hl),0           ; rewrite block type.
       push hl             ; store pointer to block.
       ld de,MAP           ; address of map.
       and a               ; clear carry flag for subtraction.
       sbc hl,de           ; find simple displacement for block.
       ld a,l              ; low byte is y coordinate.
       and 31              ; column position 0 - 31.
       ld (dispy),a        ; set up y position.
       add hl,hl           ; multiply displacement by 8.
       add hl,hl
       add hl,hl
       ld a,h              ; x coordinate now in h.
       ld (dispx),a        ; set the display coordinate.
       ld hl,(blkptr)      ; blocks.
       ld (grbase),hl      ; set graphics base.
       xor a               ; block to write.
       call pattr          ; write block.
       pop hl              ; restore block pointer.
       ret

; Colour a sprite.

cspr   equ $
       ld a,(ix+8)         ; look at the vertical first.
       cp 177              ; is it out-of-range?
       ret nc              ; yes, can't colour it.
       rlca                ; divide by 64.
       rlca                ; quicker than 6 rrca operations.
       ld l,a              ; store in e register for now.
       and 3               ; mask to find segment.
       add a,88            ; attributes start at 88*256=22528.
       ld h,a              ; that's our high byte sorted.
       ld a,l              ; vertical/64 - same as vertical*4.
       and 224             ; want a multiple of 32.
       ld l,a              ; vertical element calculated.
       ld a,(ix+9)         ; get horizontal position.
       rra                 ; divide by 8.
       rra
       rra
       and 31              ; want result in range 0-31.
       add a,l             ; add to existing low byte.
       ld l,a              ; that's the low byte done.
       ld de,30            ; distance to next line down.
       push hl             ; store address of attributes on stack.
       exx                 ; put attributes in alternate bank.
       pop hl              ; retrieve attributes address.
       ld de,MAP-22528     ; distance to properties.
       add hl,de           ; address of first block property.

       ld de,30            ; distance to next line down.
       ld a,(ix+8)         ; x coordinate.
cspr2  ld b,3              ; default rows to write.
       and 7               ; does x straddle cells?
       jr nz,cspr0         ; yes, loop counter is good.
       dec b               ; one fewer rows to write.
cspr0  ld a,(hl)           ; get property.
       and a               ; is it empty space?
       jr nz,cspr6         ; yes, don't paint it.
       exx                 ; switch to attributes.
       ld a,(hl)           ; get attribute.
       and SIMASK          ; remove ink.
       or c                ; put in the new ink.
       ld (hl),a           ; write back again.
       exx                 ; switch to properties.
cspr6  inc l               ; next cell.
       exx                 ; switch to attributes.
       inc l               ; next cell.
       exx                 ; switch to properties.
       ld a,(hl)           ; fetch block property.
       and a               ; is it empty space?
       jr nz,cspr7         ; yes, don't paint it.
       exx                 ; switch to attributes.
       ld a,(hl)           ; get attributes.
       and SIMASK          ; remove ink.
       or c                ; put in the new ink.
       ld (hl),a           ; write back again.
       exx                 ; switch to properties.
cspr7  inc l               ; next cell.
       exx                 ; switch to attributes.
       inc l               ; next cell.
       exx                 ; switch to properties.
       ld a,(ix+9)         ; y coordinate.
       and 7               ; straddling cells?
       jr z,cspr1          ; no, only 2 wide.
       ld a,(hl)           ; get attributes.
       and a               ; is it empty space?
       jr nz,cspr1         ; yes, don't paint it.
       exx                 ; switch to attributes.
       ld a,(hl)           ; get attribute.
       and SIMASK          ; remove ink.
       or c                ; put in the new ink.
       ld (hl),a           ; write back again.
       exx                 ; switch to properties.
cspr1  add hl,de           ; next row.
       exx                 ; switch to attributes.
       add hl,de           ; next row.
       exx                 ; switch to properties.
       djnz cspr0
       ret

; Scrolly text and puzzle variables.

txtbit defb 128            ; bit to write.
txtwid defb 16             ; width of ticker message.
txtpos defw msgdat
txtini defw msgdat
txtscr defw 16406

	IF SPECIALISTS = 1				; ContainerMod by Ramon Fernandez Ameijeiras

; Specialist routines.
; Process shrapnel.

proshr ld ix,SHRAPN        ; table.
       ld b,NUMSHR         ; shrapnel pieces to process.
       ld de,SHRSIZ        ; distance to next.
prosh0 ld a,(ix+0)         ; on/off marker.
       rla                 ; check its status.
proshx call nc,prosh1      ; on, so process it.
       add ix,de           ; point there.
       djnz prosh0         ; round again.
       jp scrly
prosh1 push bc             ; store counter.
       call plot           ; delete the pixel.
       ld a,(ix+0)         ; restore shrapnel type.
       ld hl,shrptr        ; shrapnel routine pointers.
       call prosh2         ; run the routine.
       call chkxy          ; check x and y are good before we redisplay.
       pop bc              ; restore counter.
       ld de,SHRSIZ        ; distance to next.
       ret
prosh2 rlca                ; 2 bytes per address.
       ld e,a              ; copy to de.
       add hl,de           ; point to address of routine.
       ld a,(hl)           ; get address low.
       inc hl              ; point to second byte.
       ld h,(hl)           ; fetch high byte from table.
       ld l,a              ; put low byte in l.
       jp (hl)             ; jump to routine.

shrptr defw laser          ; laser.
       defw trail          ; vapour trail.
       defw shrap          ; shrapnel from explosion.
       defw dotl           ; horizontal starfield left.
       defw dotr           ; horizontal starfield right.
       defw dotu           ; vertical starfield up.
       defw dotd           ; vertical starfield down.
       defw ptcusr         ; user particle.

; Explosion shrapnel.

shrap  ld e,(ix+1)         ; get the angle.
       ld d,0              ; no high byte.
       ld hl,shrsin        ; shrapnel sine table.
       add hl,de           ; point to sine.

       ld e,(hl)           ; fetch value from table.
       inc hl              ; next byte of table.
       ld d,(hl)           ; fetch value from table.
       inc hl              ; next byte of table.
       ld c,(hl)           ; fetch value from table.
       inc hl              ; next byte of table.
       ld b,(hl)           ; fetch value from table.
       ld l,(ix+2)         ; x coordinate in hl.
       ld h,(ix+3)
       add hl,de           ; add sine.
       ld (ix+2),l         ; store new coordinate.
       ld (ix+3),h
       ld l,(ix+4)         ; y coordinate in hl.
       ld h,(ix+5)
       add hl,bc           ; add cosine.
       ld (ix+4),l         ; store new coordinate.
       ld (ix+5),h
       ret

dotl   dec (ix+5)          ; move left.
       ret
dotr   inc (ix+5)          ; move left.
       ret
dotu   dec (ix+3)          ; move up.
       ret
dotd   inc (ix+3)          ; move down.
       ret

; Check coordinates are good before redrawing at new position.

chkxy  ld hl,wntopx        ; window top.
       ld a,(ix+3)         ; fetch shrapnel coordinate.
       cp (hl)             ; compare with top window limit.
       jr c,kilshr         ; out of window, kill shrapnel.
       inc hl              ; left edge.
       ld a,(ix+5)         ; fetch shrapnel coordinate.
       cp (hl)             ; compare with left window limit.
       jr c,kilshr         ; out of window, kill shrapnel.

       inc hl              ; point to bottom.
       ld a,(hl)           ; fetch window limit.
       add a,15            ; add height of sprite.
       cp (ix+3)           ; compare with shrapnel x coordinate.
       jr c,kilshr         ; off screen, kill shrapnel.
       inc hl              ; point to right edge.
       ld a,(hl)           ; fetch shrapnel y coordinate.
       add a,15            ; add width of sprite.
       cp (ix+5)           ; compare with window limit.
       jr c,kilshr         ; off screen, kill shrapnel.

; Drop through.
; Display shrapnel.

plot   ld l,(ix+3)         ; x integer.
       ld h,(ix+5)         ; y integer.
       ld (dispx),hl       ; workspace coordinates.
       ld a,(ix+0)         ; type.
       and a               ; is it a laser?
       jr z,plot1          ; yes, draw laser instead.
plot0  ld a,h              ; which pixel within byte do we
       and 7               ; want to set first?
       ld d,0              ; no high byte.
       ld e,a              ; copy to de.
       ld hl,dots          ; table of small pixel positions.
       add hl,de           ; hl points to values we want to POKE to screen.
       ld e,(hl)           ; get value.
       call scadd          ; screen address.
       ld a,(hl)           ; see what's already there.
       xor e               ; merge with pixels.
       ld (hl),a           ; put back on screen.
       ret
plot1  call scadd          ; screen address.
       ld a,(hl)           ; fetch byte there.
       cpl                 ; toggle all bits.
       ld (hl),a           ; new byte.
       ret

kilshr ld (ix+0),128       ; switch off shrapnel.
       ret

;explc  defb 0              ; explosion counter.

shrsin defw 0,1024,391,946,724,724,946,391
       defw 1024,0,946,65144,724,64811,391,64589
       defw 0,64512,65144,64589,64811,64811,64589,65144
       defw 64512,0,64589,391,64811,724,65144,946

trail  dec (ix+1)          ; time remaining.
       jp z,trailk         ; time to switch it off.
       call qrand          ; get a random number.
       rra                 ; x or y axis?
       jr c,trailv         ; use x.
       rra                 ; which direction?
       jr c,traill         ; go left.
       inc (ix+5)          ; go right.
       ret
traill dec (ix+5)          ; go left.
       ret
trailv rra                 ; which direction?
       jr c,trailu         ; go up.
       inc (ix+3)          ; go down.
       ret
trailu dec (ix+3)          ; go up.
       ret
trailk ld (ix+3),200       ; set off-screen to kill vapour trail.
       ret

laser  ld a,(ix+1)         ; direction.
       rra                 ; left or right?
       jr nc,laserl        ; move left.
       ld b,8              ; distance to travel.
       jr laserm           ; move laser.
laserl ld b,248            ; distance to travel.
laserm ld a,(ix+5)         ; y position.
       add a,b             ; add distance.
       ld (ix+5),a         ; set new y coordinate.

; Test new block.

       ld (dispy),a        ; set y for block collision detection purposes.
       ld a,(ix+3)         ; get x.
       ld (dispx),a        ; set coordinate for collision test.
       call tstbl          ; get block type there.
       cp WALL             ; is it solid?
       jr z,trailk         ; yes, it cannot pass.
       cp FODDER           ; is it fodder?
       ret nz              ; no, ignore it.
       call fdchk          ; remove fodder block.
       jr trailk           ; destroy laser.

dots   defb 128,64,32,16,8,4,2,1

; Plot, preserving de.

plotde push de             ; put de on stack.
       call plot           ; plot pixel.
       pop de              ; restore de from stack.
       ret

; Shoot a laser.

shoot  ld c,a              ; store direction in c register.
       ld a,(ix+8)         ; x coordinate.
shoot1 add a,7             ; down 7 pixels.
       ld l,a              ; puty x coordinate in l.
       ld h,(ix+9)         ; y coordinate in h.
       push ix             ; store pointer to sprite.
       call fpslot         ; find particle slot.
       jr nc,vapou2        ; failed, restore ix.
       ld (ix+0),0         ; set up a laser.
       ld (ix+1),c         ; set the direction.
       ld (ix+3),l         ; set x coordinate.
       rr c                ; check direction we want.
       jr c,shootr         ; shoot right.
       ld a,h              ; y position.
;       dec a               ; left a pixel.
shoot0 and 248             ; align on character boundary.
       ld (ix+5),a         ; set y coordinate.
       jr vapou0           ; draw first image.
shootr ld a,h              ; y position.
       add a,15            ; look right.
       jr shoot0           ; align and continue.

; Create a bit of vapour trail.

vapour push ix             ; store pointer to sprite.
       ld l,(ix+8)         ; x coordinate.
       ld h,(ix+9)         ; y coordinate.
vapou3 ld de,7*256+7       ; mid-point of sprite.
       add hl,de           ; point to centre of sprite.
       call fpslot         ; find particle slot.
       jr c,vapou1         ; no, we can use it.
vapou2 pop ix              ; restore sprite pointer.
       ret                 ; out of slots, can't generate anything.

vapou1 ld (ix+3),l         ; set up x.
       ld (ix+5),h         ; set up y coordinate.
       call qrand          ; get quick random number.
       and 15              ; random time.
       add a,15            ; minimum time on screen.
       ld (ix+1),a         ; set time on screen.
       ld (ix+0),1         ; define particle as vapour trail.
vapou0 call chkxy          ; plot first position.
       jr vapou2

; Create a user particle.

ptusr  ex af,af'           ; 'store timer.
       ld l,(ix+8)         ; x coordinate.
       ld h,(ix+9)         ; y coordinate.
       ld de,7*256+7       ; mid-point of sprite.
       add hl,de           ; point to centre of sprite.
       call fpslot         ; find particle slot.
       jr c,ptusr1         ; no, we can use it.
       ret                 ; out of slots, can't generate anything.

ptusr1 ld (ix+3),l         ; set up x.
       ld (ix+5),h         ; set up y coordinate.
       ex af,af'           ; 'restore timer.
       ld (ix+1),a         ; set time on screen.
       ld (ix+0),7         ; define particle as user particle.
       jp chkxy            ; plot first position.


; Create a vertical or horizontal star.

star   push ix             ; store pointer to sprite.
       call fpslot         ; find particle slot.
       jp c,star7          ; found one we can use.
star0  pop ix              ; restore sprite pointer.
       ret                 ; out of slots, can't generate anything.

star7  ld a,c              ; direction.
       and 3               ; is it left?
       jr z,star1          ; yes, it's horizontal.
       dec a               ; is it right?
       jr z,star2          ; yes, it's horizontal.
       dec a               ; is it up?
       jr z,star3          ; yes, it's vertical.

       ld a,(wntopx)       ; get edge of screen.
       inc a               ; down one pixel.
star8  ld (ix+3),a         ; set x coord.
       call qrand          ; get quick random number.
star9  ld (ix+5),a         ; set y position.
       ld a,c              ; direction.
       and 3               ; zero to three.
       add a,3             ; 3 to 6 for starfield.
       ld (ix+0),a         ; define particle as star.
       call chkxy          ; plot first position.
       jp star0
star1  call qrand          ; get quick random number.
       ld (ix+3),a         ; set x coord.
       ld a,(wnrgtx)       ; get edge of screen.
       add a,15            ; add width of sprite minus 1.
       jp star9
star2  call qrand          ; get quick random number.
       ld (ix+3),a         ; set x coord.
       ld a,(wnlftx)       ; get edge of screen.
       jp star9
star3  ld a,(wnbotx)       ; get edge of screen.
       add a,15            ; height of sprite minus one pixel.
       jp star8


; Find particle slot for lasers or vapour trail.
; Can't use alternate accumulator.

fpslot ld ix,SHRAPN        ; shrapnel table.
       ld de,SHRSIZ        ; size of each particle.
       ld b,NUMSHR         ; number of pieces in table.
fpslt0 ld a,(ix+0)         ; get type.
       rla                 ; is this slot in use?
       ret c               ; no, we can use it.
       add ix,de           ; point to more shrapnel.
       djnz fpslt0         ; repeat for all shrapnel.
       ret                 ; out of slots, can't generate anything.

; Create an explosion at sprite position.

explod ld c,a              ; particles to create.
       push ix             ; store pointer to sprite.
       ld l,(ix+8)         ; x coordinate.
       ld h,(ix+9)         ; y coordinate.
       ld ix,SHRAPN        ; shrapnel table.
       ld de,SHRSIZ        ; size of each particle.
       ld b,NUMSHR         ; number of pieces in table.
expld0 ld a,(ix+0)         ; get type.
       rla                 ; is this slot in use?
       jr c,expld1         ; no, we can use it.
expld2 add ix,de           ; point to more shrapnel.
       djnz expld0         ; repeat for all shrapnel.
expld3 pop ix              ; restore sprite pointer.
       ret                 ; out of slots, can't generate any more.
expld1 ld a,c              ; shrapnel counter.
       and 15              ; 0 to 15.
       add a,l             ; add to x.
       ld (ix+3),a         ; x coord.
       ld a,(seed3)        ; crap random number.
       and 15              ; 0 to 15.
       add a,h             ; add to y.
       ld (ix+5),a         ; y coord.
       ld (ix+0),2         ; switch it on.
       exx                 ; store coordinates.
       call chkxy          ; plot first position.
       call qrand          ; quick random angle.
       and 60              ; keep within range.
       ld (ix+1),a         ; angle.
       exx                 ; restore coordinates.
       dec c               ; one less piece of shrapnel to generate.
       jr nz,expld2        ; back to main explosion loop.
       jr expld3           ; restore sprite pointer and exit.
qrand  ld a,(seed3)        ; random seed.
       ld l,a              ; low byte.
       ld h,0              ; no high byte.
       ld a,r              ; r register.
       xor (hl)            ; combine with seed.
       ld (seed3),a        ; new seed.
       ret
seed3  defb 0

; Display all shrapnel.

dshrp  ld hl,plotde        ; display routine.
       ld (proshx+1),hl    ; modify routine.
       call proshr         ; process shrapnel.
       ld hl,prosh1        ; processing routine.
       ld (proshx+1),hl    ; modify the call.
       ret

; Particle engine.

inishr ld hl,SHRAPN        ; table.
       ld b,NUMSHR         ; shrapnel pieces to process.
       ld de,SHRSIZ        ; distance to next.
inish0 ld (hl),255         ; kill the shrapnel.
       add hl,de           ; point there.
       djnz inish0         ; round again.
       ret

; Check for collision between laser and sprite.

lcol   ld hl,SHRAPN        ; shrapnel table.
       ld de,SHRSIZ        ; size of each particle.
       ld b,NUMSHR         ; number of pieces in table.
lcol0  ld a,(hl)           ; get type.
       and a               ; is this slot a laser?
       jr z,lcol1          ; yes, check collision.
lcol3  add hl,de           ; point to more shrapnel.
       djnz lcol0          ; repeat for all shrapnel.
       ret                 ; no collision, carry not set.
lcol1  push hl             ; store pointer to laser.
       inc hl              ; direction.
       inc hl              ; not used.
       inc hl              ; x position.
       ld a,(hl)           ; get x.
       sub (ix+X)          ; subtract sprite x.
lcolh  cp 16               ; within range?
       jr nc,lcol2         ; no, missed.
       inc hl              ; not used.
       inc hl              ; y position.
       ld a,(hl)           ; get y.
       sub (ix+Y)          ; subtract sprite y.
       cp 16               ; within range?
       jr c,lcol4          ; yes, collision occurred.
lcol2  pop hl              ; restore laser pointer from stack.
       jr lcol3
lcol4  pop hl              ; restore laser pointer.
       ret                 ; return with carry set for collision.

	ELSE				; ContainerMod by Ramon Fernandez Ameijeiras
		
proshr	equ $
inishr	equ $
vapour	equ $
explod	equ $
dshrp	equ $
		jp scrly
		ret

	ENDIF				; ContainerMod by Ramon Fernandez Ameijeiras 

; Main game engine code starts here.

gamelp	call game
       jr gamelp

game   equ $

; Set up screen address table.

setsat ld hl,16384         ; start of screen.
       ld de,SCADTB        ; screen address table.
       ld b,0              ; vertical lines on screen.
setsa0 ex de,hl            ; flip table and screen address.
       ld (hl),d           ; write high byte.
       inc h               ; second table.
       ld (hl),e           ; write low byte.
       dec h               ; back to first table.
       inc l               ; next position in table.
       ex de,hl            ; flip table and screen address back again.
       call nline          ; next line down.
       djnz setsa0         ; repeat for all lines.

       call setpal         ; set up ULAplus palette.
rpblc2 call inishr         ; initialise particle engine.
evintr call evnt12         ; call intro/menu event.

       ld hl,MAP           ; block properties.
       ld de,MAP+1         ; next byte.
       ld bc,767           ; size of property map.
       ld (hl),WALL        ; write default property.
       ldir
	   call iniob          ; initialise objects.
	   xor a               ; put zero in accumulator.
       ld (gamwon),a       ; reset game won flag.

       ld hl,score         ; score.
       call inisc          ; init the score.
mapst  ld a,(stmap)        ; start position on map.
       ld (roomtb),a       ; set up position in table, if there is one.
inipbl call ibloc          ; set up first screen.
       ld ix,ssprit        ; default to spare sprite in table.
evini  call evnt13         ; initialisation.

; Two restarts.
; First restart - clear all sprites and initialise everything.

rstrt  call rsevt          ; restart events.
	IF ZEROMOD = 1
	   call FixScreen		; scno-FixDEsplazamiento Stages Scr
	ENDIF
       call xspr           ; clear sprite table.
       call sprlst         ; fetch pointer to screen sprites.
	IF MASKAGD > 0
		xor a                 ; inicia Z
		ld (z_counter),a
		;CALL sspr_restore_dlpointers
	ENDIF
       call ispr           ; initialise sprite table.
       jr rstrt0

; Second restart - clear all but player, and don't initialise him.

rstrtn call rsevt          ; restart events.
	IF ZEROMOD = 1
	   call FixScreen		; scno-FixDEsplazamiento Stages Scr
	ENDIF
       call nspr           ; clear all non-player sprites.
       call sprlst         ; fetch pointer to screen sprites.
	IF MASKAGD > 0
		xor a                 ; inicia Z
		inc a
		ld (z_counter),a
	ENDIF
	   call kspr           ; initialise sprite table, no more players.

; Set up the player and/or enemy sprites.
rstrt0 xor a               ; zero in accumulator.
       ld (nexlev),a       ; reset next level flag.
       ld (restfl),a       ; reset restart flag.
       ld (deadf),a        ; reset dead flag.
	   
	IF INFRONT = 1
		; equivale a USER 4 en startscreen
		call inibloc			; MEIGA 2025 necesario en scroll en desarrrollo
	ENDIF

	; RAM7 contiene una pantalla de tránsito ya cargada
	; mostrar tránsito en RAM7
		;call SetState_Show7_Bank0

	; dibujar nueva pantalla del juego en 4000
	; fondo, tiles, sprites iniciales, etc.
	   call droom          ; show screen layout.
	   call rbloc          ; redraw blocks if in adventure mode.	
       call inishr         ; initialise particle engine.
	IF ZEROMOD = 1
	   call initsc		   ; MEIGA parche: resolver desplazamiento colocar Objects en screens levels, Obtiene scno global (sin desplazamiento)
	ENDIF
	   call shwob          ; draw objects.

	; ahora se ve RAM5 con la nueva escena
		;call SetState_Show5_Bank0

	IF MASKAGD > 0
		ld ix,sprtab        ; address of sprite table, even sprites.
		ld a,(z_counter)
		ld (ix+17),a		; Player delante de todos
		;call bsort
		; MASK-OFF
		;call swap_dlpoiters
	ELSE
	ENDIF

	IF MASKAGD = 0
       ld ix,sprtab        ; address of sprite table, even sprites.
       call dspr           ; display sprites.
       ld ix,sprtab+TABSIZ ; address of first odd sprite.
       call dspr           ; display sprites.
	ELSE
		IF MASKAGD = 1
			;call SHOW_Sprites
		ENDIF
		; Activa mascara POR DEFECTO, sin control AGDScript
		; MASK-ON aqui	
	ENDIF

rstrt1 ;jp bsortx			; skip screen layout.			*** controll FROM scripts rstrt1
	
	IF ULABUFFER = 1
		call InitULABuffers
		;call bank0
	ENDIF
	
mloop
	IF ULABUFFER = 1
		;call waitIRQ
		;call joykey
		;call vsync
	ENDIF

	IF ULABUFFER = 1
		; Conmuta Screen Buffer debería estar despues de evnt11 despues de In Front Plugin
			;call FlipBufferSafe
	ENDIF

	IF SCROLL = 1
		; movimiento de fondo automatico
			;call EchoReset
			;call Play_one_step
	ENDIF
		
	IF MASKAGD = 0
	; XOR routines
			call vsync
		; A Impresion desprites impares
			ld ix,sprtab        ; address of sprite table, even sprites.
			call dspr           ; display even sprites.
			call vsync
		; B Impresion desprites pares	 
			ld ix,sprtab+TABSIZ ; address of first odd sprite.
			call dspr           ; display odd sprites.
	ELSE
	; AND routines: incluir con rutina mascara _bucle_estable
		ld a,(MASKAGDopt)
		and a
		jr nz,sistmask
		call vsync
	; A Impresion desprites impares
		ld ix,sprtab        ; address of sprite table, even sprites.
		call dspr           ; display even sprites.
		call vsync
	; B Impresion desprites pares	 
		ld ix,sprtab+TABSIZ ; address of first odd sprite.
		call dspr           ; display odd sprites.
		jr endsistmask
sistmask	
		call vsync
		call SHOW_Sprites
		; aqui debería volver a RAMdeJuego desde ULABuffer
		IF ULABUFFER = 1
			; Conmuta Screen Buffer debería estar despues de evnt11 despues de In Front Plugin
				call FlipBufferSafe
		ENDIF
		call vsync
endsistmask
	ENDIF
	
	IF ULABUFFER = 1
		; Conmuta Screen Buffer debería estar despues de evnt11 despues de In Front Plugin
			;call FlipBufferSafe
	ENDIF

	; II En primer plano

		IF INFRONT = 1
			; In Front Plugin, Puede ir aquí o justo despues de dspr7

			; push hl
			; push bc
			; push de
			call drawb		   ; tiles in front ON
			; pop de
			; pop bc
			; pop hl

		ENDIF

		
	; C Impresiones en Fondo: Objetos y bloques
	   ld ix,ssprit        ; point to spare sprite for spawning purposes.
evlp1  call evnt10         ; called once per main loop.

		IF SCROLL = 1
			; movimiento de fondo automatico
			; resetea desplazamiento con el fondo
				call EchoReset
			; play fondo
				call Play_one_step
			IF ULABUFFER = 1
				call FlipBufferSafe
			ENDIF
		ENDIF

	; Main loop events. <Cambia las cosas>
       call pspr           ; procesa sprites.
				
       ld ix,ssprit        ; point to spare sprite for spawning purposes.
evlp2  call evnt11         ; called once per main loop. 

		;include "cassettePlay.asm"

bsortx
	IF MASKAGD = 0
		call bsort          ; sort sprites.
	ELSE

		IF MASKAGD = 1		;incluir con rutina mascara _bucle_estable
			;call bsort_inv
			call bsort          ; sort sprites.
			call pass_solapamiento
			;ld a,(NCol)
			;ld (varn),a	
		ENDIF

	ENDIF
       ld a,(nexlev)       ; finished level flag.
       and a               ; has it been set?
       jp nz,newlev        ; yes, go to next level.
       ld a,(gamwon)       ; finished game flag.
       and a               ; has it been set?
       jp nz,evwon         ; yes, finish the game.
       ld a,(restfl)       ; finished level flag.
       dec a               ; has it been set?
       jp z,rstrt          ; yes, go to next level.
       dec a               ; has it been set?
       jp z,rstrtn         ; yes, go to next screen.
       ld a,(deadf)        ; dead flag.
       and a               ; is it non-zero?
       jr nz,pdead         ; yes, player dead.
       ld hl,frmno         ; game frame.
       inc (hl)            ; advance the frame.

; Back to start of main loop.

       jp DEBUG            ; debug or back to mloop.

newlev ld a,(scno)         ; current screen.
       ld hl,numsc		   ; total number of screens.
       inc a               ; next screen.
       cp (hl)             ; reached the limit?
       jr nc,evwon         ; yes, game finished.
       ld (scno),a         ; set new level number.
       jp rstrt            ; restart, clearing all aliens.
evwon  call evnt18         ; game completed.
       jp tidyup           ; tidy up and return to BASIC/calling routine.

; Player dead.

pdead  xor a               ; zeroise accumulator.
       ld (deadf),a        ; reset dead flag.
evdie  call evnt16         ; death subroutine.
       ld a,(numlif)       ; number of lives.
       and a               ; reached zero yet?
       jp nz,rstrt         ; restart game.
evfail call evnt17         ; failure event.
tidyup ld hl,hiscor        ; high score.
       ld de,score         ; player's score.
       ld b,6              ; digits to check.
tidyu2 ld a,(de)           ; get score digit.
       cp (hl)             ; are we larger than high score digit?
       jr c,tidyu0         ; high score is bigger.
       jr nz,tidyu1        ; score is greater, record new high score.
       inc hl              ; next digit of high score.
       inc de              ; next digit of score.
       djnz tidyu2         ; repeat for all digits.
tidyu0 ld hl,10072         ; BASIC likes this in alternate hl.
       exx                 ; flip hl into alternate registers.
       ld bc,score         ; return pointing to score.
	   ret
tidyu1 ld hl,score         ; score.
       ld de,hiscor        ; high score.
       ld bc,6             ; digits to copy.
       ldir                ; copy score to high score.
evnewh call evnt19         ; new high score event.
       jr tidyu0           ; tidy up.

; Restart event.

rsevt  ld ix,ssprit        ; default to spare element in table.
evrs   jp evnt14           ; call restart event.
		
; Copy number passed in a to string position bc, right-justified.

num2ch ld l,a              ; put accumulator in l.
       ld h,0              ; blank high byte of hl.
       ld a,32             ; leading spaces.
numdg3 ld de,100           ; hundreds column.
       call numdg          ; show digit.
numdg2 ld de,10            ; tens column.
       call numdg          ; show digit.
       or 16               ; last digit is always shown.
       ld de,1             ; units column.
numdg  and 48              ; clear carry, clear digit.
numdg1 sbc hl,de           ; subtract from column.
       jr c,numdg0         ; nothing to show.
       or 16               ; something to show, make it a digit.
       inc a               ; increment digit.
       jr numdg1           ; repeat until column is zero.
numdg0 add hl,de           ; restore total.
       cp 32               ; leading space?
       ret z               ; yes, don't write that.
       ld (bc),a           ; write digit to buffer.
       inc bc              ; next buffer position.
       ret
num2dd ld l,a              ; put accumulator in l.
       ld h,0              ; blank high byte of hl.
       ld a,32             ; leading spaces.
       ld de,100           ; hundreds column.
       call numdg          ; show digit.
       or 16               ; second digit is always shown.
       jr numdg2
num2td ld l,a              ; put accumulator in l.
       ld h,0              ; blank high byte of hl.
       ld a,48             ; leading spaces.
       jr numdg3

inisc  ld b,6              ; digits to initialise.
inisc0 ld (hl),'0'         ; write zero digit.
       inc hl              ; next column.
       djnz inisc0         ; repeat for all digits.
       ret


; Multiply h by d and return in hl.

imul   ld e,d              ; HL = H * D
       ld c,h              ; make c first multiplier.
imul0  ld hl,0             ; zeroise total.
       ld d,h              ; zeroise high byte.
       ld b,8              ; repeat 8 times.
imul1  rr c                ; rotate rightmost bit into carry.
       jr nc,imul2         ; wasn't set.
       add hl,de           ; bit was set, so add de.
       and a               ; reset carry.
imul2  rl e                ; shift de 1 bit left.
       rl d
       djnz imul1          ; repeat 8 times.
       ret

; Divide d by e and return in d, remainder in a.

idiv   xor a
       ld b,8              ; bits to shift.
idiv0  sla d               ; multiply d by 2.
       rla                 ; shift carry into remainder.
       cp e                ; test if e is smaller.
       jr c,idiv1          ; e is greater, no division this time.
       sub e               ; subtract it.
       inc d               ; rotate into d.
idiv1  djnz idiv0
       ret
	
; Objects handling.
; 32 bytes for image
; 1 for colour
; 3 for room, x and y
; 3 for starting room, x and y.
; 254 = disabled.
; 255 = object in player's pockets.

; Show items present.

shwob  ld hl,objdta        ; objects table.
       ld de,33            ; distance to room number.
       add hl,de           ; point to room data.
       ld a,(numob)        ; number of objects in the game.
       ld b,a              ; loop counter.
shwob0 push bc             ; store count.
       push hl             ; store item pointer.
       ld a,(scno)         ; current location.
       cp (hl)             ; same as an item?
       call z,dobjc        ; yes, display object in colour.
       pop hl              ; restore pointer.
       pop bc              ; restore counter.
       ld de,39            ; distance to next item.
       add hl,de           ; point to it.
       djnz shwob0         ; repeat for others.
       ret

; Display object.
; hl must point to object's room data.

dobj   inc hl              ; point to x.
dobj0  ld de,dispx         ; coordinates.
       ldi                 ; transfer x coord.
       ldi                 ; transfer y too.
       ld de,65500         ; minus 36.
       add hl,de           ; point to image.
dobj1  jp sprite           ; draw this sprite. XOR pinta o boora
dobjc  call dobj           ; display object.
       ld c,(hl)           ; put ink in c register.

	
; Need to write attribute routine here.
; set up colour in c register first.

cobj   ld a,(hl)           ; get colour byte.
       and a               ; test it.
       ret m               ; colour not set.
       ld h,22             ; quarter of attrubte address.
       ld a,(dispx)        ; x coord.
       and 248             ; only want multiple of 8.
       rla                 ; multiply by 4.
       rl h
       rla
       rl h                ; high byte now set up.
       ld l,a
       ld a,(dispy)        ; take y position.
       rra                 ; divide it by 8.
       rra
       rra
       and 31              ; remove unwanted bits.
       add a,l             ; add to low byte.
       ld l,a              ; low byte of address.
       ld de,30            ; distance to next line down.
       ld a,(dispx)        ; x coordinate.
       ld b,3              ; default rows to write.
       and 7               ; does x straddle cells?
       jr nz,cobj0         ; yes, loop counter is good.
       dec b               ; one less row to write.
cobj0  ld a,(hl)           ; get attributes.
       and 248             ; remove ink.
       or c                ; put in the new ink.
       ld (hl),a           ; write back again.
       inc l               ; next cell.
       ld a,(hl)           ; get attributes.
       and 248             ; remove ink.
       or c                ; put in the new ink.
       ld (hl),a           ; write back again.
       inc l               ; next cell.
       ld a,(dispy)        ; y coordinate.
       and 7               ; straddling cells?
       jr z,cobj1          ; no, only 2 wide.
       ld a,(hl)           ; get attributes.
       and 248             ; remove ink.
       or c                ; put in the new ink.
       ld (hl),a           ; write back again.
cobj1  add hl,de           ; next row.
       djnz cobj0
       ret

; Remove an object.

remob  ld hl,numob         ; number of objects in game.
       cp (hl)             ; are we checking past the end?
       ret nc              ; yes, can't get non-existent item.
       push af             ; remember object.
       call getob          ; pick it up if we haven't already got it.
       pop af              ; retrieve object number.
       call gotob          ; get its address.
       ld (hl),254         ; remove it.
       ret

; Pick up object number held in the accumulator.

	IF MASKAGD = 1
getob
		ld (Objmasked),a
		ld a,(MASKAGDopt)
		and a
		jr z,getob2
	; borra Sprite
		call RESTAURA_Fondo_NUEVO
	; pinta Objetos
		call getob2
	; Pinta sprite
		call PRINT_Sprite
		ret
		
getob2	ld a,(Objmasked)
	   ld hl,numob         ; number of objects in game.
       cp (hl)             ; are we checking past the end?
       ret nc              ; yes, can't get non-existent item.
       call gotob          ; check if we already have it.
       ret z               ; we already do.
       ex de,hl            ; object address in de.
       ld hl,scno          ; current screen.
       cp (hl)             ; is it on this screen?
       ex de,hl            ; object address back in hl.
       jr nz,getob0        ; not on screen, so nothing to delete.
       ld (hl),255         ; pick it up.
       inc hl              ; point to x coord.
getob1 ld e,(hl)           ; x coord.
       inc hl              ; back to y coord.
       ld d,(hl)           ; y coord.
       ld (dispx),de       ; set display coords.
       ld de,65501         ; minus graphic size.
       add hl,de           ; point to graphics.
       call dobj1          ; delete object sprite.
       ld a,(bcol)         ; first block colour.
       and 7               ; only want ink attribute.
       ld c,a              ; set up colour.
       jp cobj             ; colour object's old position.
getob0 ld (hl),255         ; pick it up.
       ret	
	ELSE
getob  ld hl,numob         ; number of objects in game.
       cp (hl)             ; are we checking past the end?
       ret nc              ; yes, can't get non-existent item.
       call gotob          ; check if we already have it.
       ret z               ; we already do.
       ex de,hl            ; object address in de.
       ld hl,scno          ; current screen.
       cp (hl)             ; is it on this screen?
       ex de,hl            ; object address back in hl.
       jr nz,getob0        ; not on screen, so nothing to delete.
       ld (hl),255         ; pick it up.
       inc hl              ; point to x coord.
getob1 ld e,(hl)           ; x coord.
       inc hl              ; back to y coord.
       ld d,(hl)           ; y coord.
       ld (dispx),de       ; set display coords.
       ld de,65501         ; minus graphic size.
       add hl,de           ; point to graphics.
       call dobj1          ; delete object sprite.
       ld a,(bcol)         ; first block colour.
       and 7               ; only want ink attribute.
       ld c,a              ; set up colour.
       jp cobj             ; colour object's old position.
getob0 ld (hl),255         ; pick it up.
       ret	
	ENDIF

; Got object check.
; Call with object in accumulator, returns zero set if in pockets.

gotob  ld hl,numob         ; number of objects in game.
       cp (hl)             ; are we checking past the end?
       jr nc,gotob0        ; yes, we can't have a non-existent object.
       call findob         ; find the object.
gotob1 cp 255              ; in pockets?
       ret
gotob0 ld a,254            ; missing.
       jr gotob1
findob ld hl,objdta        ; objects.
       ld de,39            ; size of each object.
       and a               ; is it zero?
       jr z,fndob1         ; yes, skip loop.
       ld b,a              ; loop counter in b.
fndob2 add hl,de           ; point to next one.
       djnz fndob2         ; repeat until we find address.
fndob1 ld e,33             ; distance to room it's in.
       add hl,de           ; point to room.
       ld a,(hl)           ; fetch status.
       ret

; Drop object number at (dispx, dispy).

	IF MASKAGD = 1
drpob
		ld (Objmasked),a		; reserva el obj
		ld hl,(dispx)
		ld (ObjX),hl			; guarda posicion obj
		ld a,(MASKAGDopt)
		and a
		jr z,drpob2				; check MASKAGD
	; chequea sprite
		;di
		call check_any_Object	; encuentra sprite por colision
		;ei
		jp nc,drpob2			; ninguno a la vista
		ld ix,(okptr)
	; borralo
		call RESTAURA_Fondo_NUEVO	; restaura okptr-sprite
	; pinta Objetos
		call drpob2					; pinta obj
	; y pinta esprite
		call PRINT_Sprite			; pinta okptr-sprite
		ret
drpob2	
		ld hl,(ObjX)
		ld (dispx),hl
		ld a,(Objmasked)
		ld hl,numob         ; number of objects in game.
		cp (hl)             ; are we checking past the end?
		ret nc              ; yes, can't drop non-existent item.
		call gotob          ; make sure object is in inventory.
		ld a,(scno)         ; screen number.
		cp (hl)             ; already on this screen?
		ret z               ; yes, nothing to do.
		ld (hl),a           ; bring onto screen.
		inc hl              ; point to x coord.
		ld a,(dispx)        ; sprite x coordinate.
		ld (hl),a           ; set x coord.
		inc hl              ; point to object y.
		ld a,(dispy)        ; sprite y coordinate.
		ld (hl),a           ; set the y position.
		ld de,65501         ; minus graphic size.
		add hl,de           ; point to graphics.
		call dobj1          ; delete object sprite.
		ld c,(hl)           ; put ink in c register.
		jp cobj             ; colour the object.
	ELSE
drpob  ld hl,numob         ; number of objects in game.
       cp (hl)             ; are we checking past the end?
       ret nc              ; yes, can't drop non-existent item.
       call gotob          ; make sure object is in inventory.
       ld a,(scno)         ; screen number.
       cp (hl)             ; already on this screen?
       ret z               ; yes, nothing to do.
       ld (hl),a           ; bring onto screen.
       inc hl              ; point to x coord.
       ld a,(dispx)        ; sprite x coordinate.
       ld (hl),a           ; set x coord.
       inc hl              ; point to object y.
       ld a,(dispy)        ; sprite y coordinate.
       ld (hl),a           ; set the y position.
       ld de,65501         ; minus graphic size.
       add hl,de           ; point to graphics.
       call dobj1          ; delete object sprite.
       ld c,(hl)           ; put ink in c register.
       jp cobj             ; colour the object.	
	ENDIF
  
; Seek objects at sprite position.

skobj  ld hl,objdta        ; pointer to objects.
       ld de,33            ; distance to room number.
       add hl,de           ; point to room data.
       ld de,39            ; size of each object.
       ld a,(numob)        ; number of objects in game.
       ld b,a              ; set up the loop counter.
skobj0 ld a,(scno)         ; current room number.
       cp (hl)             ; is object in here?
       call z,skobj1       ; yes, check coordinates.
       add hl,de           ; point to next object in table.
       djnz skobj0         ; repeat for all objects.
       ld a,255            ; end of list and nothing found, return 255.
       ret
skobj1 inc hl              ; point to x coordinate.
       ld a,(hl)           ; get coordinate.
       sub (ix+8)          ; subtract sprite x.
       add a,15            ; add sprite height minus one.
       cp 31               ; within range?
       jp nc,skobj2        ; no, ignore object.
       inc hl              ; point to y coordinate now.
       ld a,(hl)           ; get coordinate.
       sub (ix+9)          ; subtract the sprite y.
       add a,15            ; add sprite width minus one.
       cp 31               ; within range?
       jp nc,skobj3        ; no, ignore object.
       pop de              ; remove return address from stack.
       ld a,(numob)        ; objects in game.
       sub b               ; subtract loop counter.
       ret                 ; accumulator now points to object.
skobj3 dec hl              ; back to y position.
skobj2 dec hl              ; back to room.
       ret


; Spawn a new sprite.

spawn  ld hl,sprtab        ; sprite table.
numsp1 ld a,NUMSPR         ; number of sprites.
       ld de,TABSIZ        ; size of each entry.
spaw0  ex af,af'           ; store loop counter.
       ld a,(hl)           ; get sprite type.
       inc a               ; is it an unused slot?
       jr z,spaw1          ; yes, we can use this one.
       add hl,de           ; point to next sprite in table.
       ex af,af'           ; restore loop counter.
       dec a               ; one less iteration.
       jr nz,spaw0         ; keep going until we find a slot.

; Didn't find one but drop through and set up a dummy sprite instead.

spaw1  push ix             ; existing sprite address on stack.
       ld (spptr),hl       ; store spawned sprite address.
       ld (hl),c           ; set the type.
       inc hl              ; point to image.
       ld (hl),b           ; set the image.
       inc hl              ; next byte.
       ld (hl),0           ; frame zero.
       inc hl              ; next byte.
       ld a,(ix+X)         ; x coordinate.
       ld (hl),a           ; set sprite coordinate.
       inc hl              ; next byte.
       ld a,(ix+Y)         ; y coordinate.
       ld (hl),a           ; set sprite coordinate.
       inc hl              ; next byte.
       ex de,hl            ; swap address into de.
       ld hl,(spptr)       ; restore address of details.
       ld bc,5             ; number of bytes to duplicate.
       ldir                ; copy first version to new version.
       ex de,hl            ; swap address into de.
       ld a,(ix+10)        ; direction of original.
       ld (hl),a           ; set the direction.
       inc hl              ; next byte.
       ld (hl),b           ; reset parameter.
       inc hl              ; next byte.
       ld (hl),b           ; reset parameter.
       inc hl              ; next byte.
       ld (hl),b           ; reset parameter.
       inc hl              ; next byte.
       ld (hl),b           ; reset parameter.
rtssp  ld ix,(spptr)       ; address of new sprite.
evis1  call evnt09         ; call sprite initialisation event.
       ld ix,(spptr)       ; address of new sprite.
	IF MASKAGD = 0
       call sspria         ; display the new sprite.
	ELSE
		; nueva Z posicion
		ld a,(z_counter)
		inc a
		ld (ix+17),a
		; nuevo solapamiento
		xor a
		inc a				; establece uno por defecto
		ld (ix+67),a
		call PRINT_Sprite
		call bsort
	ENDIF
       pop ix              ; address of original sprite.
       ret

spptr  defw 0              ; spawned sprite pointer.
seed   defb 0              ; seed for random numbers.
score  defb '000000'       ; player's score.
hiscor defb '000000'       ; high score.
bonus  defb '000000'       ; bonus.
grbase defw 15360          ; graphics base address.

checkx ld a,e              ; x position.
       cp 24               ; off screen?
       ret c               ; no, it's okay.
       pop hl              ; remove return address from stack.
       ret

; Displays the current score.

dscor  call preprt         ; set up font and print position.
       call checkx         ; make sure we're in a printable range.
       ld a,(prtmod)       ; get print mode.
       and a               ; standard size text?
       jp nz,bscor0        ; no, show double-height.
dscor0 push bc             ; place counter onto the stack.
       push hl
       ld a,(hl)           ; fetch character.
       call pchar          ; display character.
       call gaadd          ; get attribute address.
       ld a,(23693)        ; current cell colours.
       ld (hl),a           ; write to attribute cell.
       ld hl,dispy         ; y coordinate.
       inc (hl)            ; move along one.
       pop hl
       inc hl              ; next score column.
       pop bc              ; retrieve character counter.
       djnz dscor0         ; repeat for all digits.
       ld hl,(blkptr)      ; blocks.
       ld (grbase),hl      ; set graphics base.
dscor2 ld hl,(dispx)       ; general coordinates.
       ld (charx),hl       ; set up display coordinates.
       ret

; Displays the current score in double-height characters.

bscor0 push bc             ; place counter onto the stack.
       push hl
       ld a,(hl)           ; fetch character.
       call bchar          ; display big char.
       pop hl
       inc hl              ; next score column.
       pop bc              ; retrieve character counter.
       djnz bscor0         ; repeat for all digits.
       jp dscor2           ; tidy up line and column variables.

; Adds number in the hl pair to the score.

addsc  ld de,score+1       ; ten thousands column.
       ld bc,10000         ; amount to add each time.
       call incsc          ; add to score.
       inc de              ; thousands column.
       ld bc,1000          ; amount to add each time.
       call incsc          ; add to score.
       inc de              ; hundreds column.
       ld bc,100           ; amount to add each time.
       call incsc          ; add to score.
       inc de              ; tens column.
       ld bc,10            ; amount to add each time.
       call incsc          ; add to score.
       inc de              ; units column.
       ld bc,1             ; units.
incsc  push hl             ; store amount to add.
       and a               ; clear the carry flag.
       sbc hl,bc           ; subtract from amount to add.
       jr c,incsc0         ; too much, restore value.
       pop af              ; delete the previous amount from the stack.
       push de             ; store column position.
       call incsc2         ; do the increment.
       pop de              ; restore column.
       jp incsc            ; repeat until all added.
incsc0 pop hl              ; restore previous value.
       ret
incsc2 ld a,(de)           ; get amount.
       inc a               ; add one to column.
       ld (de),a           ; write new column total.
       cp '9'+1            ; gone beyond range of digits?
       ret c               ; no, carry on.
       ld a,'0'            ; mae it zero.
       ld (de),a           ; write new column total.
       dec de              ; back one column.
       jr incsc2

; Add bonus to score.

addbo  ld de,score+5       ; last score digit.
       ld hl,bonus+5       ; last bonus digit.
       and a               ; clear carry.
       ld bc,6*256+48      ; 6 digits to add, ASCII '0' in c.
addbo0 ld a,(de)           ; get score.
       adc a,(hl)          ; add bonus.
       sub c               ; 0 to 18.
       ld (hl),c           ; zeroise bonus.
       dec hl              ; next bonus.
       cp 58               ; carried?
       jr c,addbo1         ; no, do next one.
       sub 10              ; subtract 10.
addbo1 ld (de),a           ; write new score.
       dec de              ; next score digit.
       ccf                 ; set carry for next digit.
       djnz addbo0         ; repeat for all 6 digits.
       ret

; Swap score and bonus.

swpsb  ld de,score         ; first score digit.
       ld hl,bonus         ; first bonus digit.
       ld b,6              ; digits to add.
swpsb0 ld a,(de)           ; get score and bonus digits.
       ld c,(hl)
       ex de,hl            ; swap pointers.
       ld (hl),c           ; write bonus and score digits.
       ld (de),a
       inc hl              ; next score and bonus.
       inc de
       djnz swpsb0         ; repeat for all 6 digits.
       ret

; Get print address.

gprad  ld a,(dispx)        ; returns scr. add. in de.
       ld e,a              ; place in e for now.
       and 24              ; which of 3 segments do we need?
       add a,64            ; add 64 for start address of screen.
       ld d,a              ; that's our high byte.
       ld a,e              ; restore x coordinate.
       rrca                ; multiply by 32.
       rrca
       rrca
       and 224             ; lines within segment.
       ld e,a              ; set up low byte for x.
       ld a,(dispy)        ; now get y coordinate.
       add a,e             ; add to low byte.
       ld e,a              ; final low byte.
       ret

; Get property buffer address of char at (dispx, dispy) in hl.

pradd  ld a,(dispx)        ; x coordinate.
       rrca                ; multiply by 32.
       rrca
       rrca
       ld l,a              ; store shift in l.
       and 3               ; high byte bits.
       add a,253           ; 88 * 256 = 64768, start of properties map.
       ld h,a              ; that's our high byte.
       ld a,l              ; restore shift result.
       and 224             ; only want low bits.
       ld l,a              ; put into low byte.
       ld a,(dispy)        ; fetch y coordinate.
       and 31              ; should be in range 0 - 31.
       add a,l             ; add to low byte.
       ld l,a              ; new low byte.
       ret

; Get attribute address of char at (dispx, dispy) in hl.

gaadd  ld a,(dispx)        ; x coordinate.
       rrca                ; multiply by 32.
       rrca
       rrca
       ld l,a              ; store shift in l.
       and 3               ; high byte bits.
       add a,88            ; 88 * 256 = 22528, start of screen attributes.
       ld h,a              ; that's our high byte.
       ld a,l              ; restore shift result.
       and 224             ; only want low bits.
       ld l,a              ; put into low byte.
       ld a,(dispy)        ; fetch y coordinate.
       and 31              ; should be in range 0 - 31.
       add a,l             ; add to low byte.
       ld l,a              ; new low byte.
       ret

pchar  rlca                ; multiply char by 8.
       rlca
       rlca
       ld e,a              ; store shift in e.
       and 7               ; only want high byte bits.
       ld d,a              ; store in d.
       ld a,e              ; restore shifted value.
       and 248             ; only want low byte bits.
       ld e,a              ; that's the low byte.
       ld hl,(grbase)      ; address of graphics.
       add hl,de           ; add displacement.
pchark call gprad          ; get screen address.
       ld a,(hl)           ; get image byte.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(hl)           ; get image byte.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(hl)           ; get image byte.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(hl)           ; get image byte.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(hl)           ; get image byte.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(hl)           ; get image byte.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(hl)           ; get image byte.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(hl)           ; get image byte.
       ld (de),a           ; copy to screen.
       ret

; Print attributes, properties and pixels.

colpat defb 0

pattr  ld b,a              ; store cell in b register for now.
       ld e,a              ; displacement in e.
       ld d,0              ; no high byte.
       ld hl,(proptr)      ; pointer to properties.
       add hl,de           ; property cell address.
       ld c,(hl)           ; fetch byte.
       ld a,c              ; put into accumulator.
       cp COLECT           ; is it a collectable?
       jp nz,pattr1        ; no, carry on as normal.
       ld a,b              ; restore cell.
       ld (colpat),a       ; store collectable block.
pattr1 call pradd          ; get property buffer address.
       ld (hl),c           ; write property.
       ld a,b              ; get block number.

; Print attributes, no properties.

panp   ld e,a              ; displacement in e.
       ld d,0              ; no high byte.
       ld hl,(colptr)      ; pointer to colours.
       add hl,de           ; colour cell address.
       ld c,(hl)           ; fetch byte.
       call gaadd          ; get attribute address.
       ld (hl),c           ; write colour.
       ld a,b              ; restore cell.

; Print character pixels, no more.

pchr   call pchar          ; show character in accumulator.
       ld hl,dispy         ; y coordinate.
       inc (hl)            ; move along one.
       ret

; Shifter sprite routine for objects.

sprit7 xor 7
       inc a
sprit3 rl l                ; shift into position.
       rl c
       rl h
       dec a               ; one less iteration.
       jp nz,sprit3
       ld a,l
       ld l,c
       ld c,h
       ld h,a
       jp sprit0           ; now apply to screen.

sprite push hl             ; store sprite graphic address.
       call scadd          ; get screen address in hl.
       ex de,hl            ; switch to de.
       pop hl              ; restore graphic address.
       ld a,(dispy)        ; y position.
       and 7               ; position straddling cells.
       ld b,a              ; store in b register.
       ld a,16             ; pixel height.
sprit1 ex af,af'			;'
       ld c,(hl)           ; fetch first byte.
       inc hl              ; next byte.
       push hl             ; store source address.
       ld l,(hl)
       ld h,0
       ld a,b              ; position straddling cells.
       and a               ; is it zero?
       jr z,sprit0         ; yes, apply to screen.
       cp 5
       jr nc,sprit7
       and a               ; clear carry.
sprit2 rr c
       rr l
       rr h
       dec a
       jp nz,sprit2
sprit0 ld a,(de)           ; fetch screen image.
       xor c               ; merge with graphic.
       ld (de),a           ; write to screen.
       inc e               ; next screen byte.
       ld a,(de)           ; fetch screen image.
       xor l               ; combine with graphic.
       ld (de),a           ; write to screen.
       inc de              ; next screen address.
       ld a,(de)           ; fetch screen image.
       xor h               ; combine with graphic.
       ld (de),a           ; write to screen.
       dec de              ; left to middle byte.
       dec e               ; back to start byte.
       inc d               ; increment line number.
       ld a,d              ; segment address.
       and 7               ; reached end of segment?
       jp nz,sprit6        ; no, just do next line within cell.
       ld a,e              ; low byte.
       add a,32            ; look down.
       ld e,a              ; new address.
       jp c,sprit6         ; done.
       ld a,d              ; high byte.
       sub 8               ; start of segment.
       ld d,a              ; new high byte.
sprit6 pop hl              ; restore source address.
       inc hl              ; next source byte.
	   
       ex af,af'			;'
       dec a
       jp nz,sprit1
       ret

; Get room address.

groom  ld a,(scno)         ; screen number.
groomx ld de,0             ; start at zero.
       ld hl,(scrptr)      ; pointer to screens.
       and a               ; is it the first one?
groom1 jr z,groom0         ; no more screens to skip.
       ld c,(hl)           ; low byte of screen size.
       inc hl              ; point to high byte.
       ld b,(hl)           ; high byte of screen size.
       inc hl              ; next address.
       ex de,hl            ; put total in hl, pointer in de.
       add hl,bc           ; skip a screen.
       ex de,hl            ; put total in de, pointer in hl.
       dec a               ; one less iteration.
       jr groom1           ; loop until we reach the end.
groom0 ld hl,(scrptr)      ; pointer to screens.
       add hl,de           ; add displacement.
       ld a,(numsc)        ; number of screens.
       ld d,0              ; zeroise high byte.
       ld e,a              ; displacement in de.
       add hl,de           ; add double displacement to address.
       add hl,de
       ret

; Draw present room.

droom  ld a,(wintop)       ; window top.
       ld (dispx),a        ; set x coordinate.
droom2 ld hl,(blkptr)      ; blocks.
       ld (grbase),hl      ; set graphics base.
       call groom          ; get address of current room.
mroom0 xor a               ; zero in accumulator.  MEIGA-mroom0 para Panelroom
       ld (comcnt),a       ; reset compression counter.
       ld a,(winhgt)       ; height of window.
droom0 push af             ; store row counter.
       ld a,(winlft)       ; window left edge.
       ld (dispy),a        ; set cursor position.
       ld a,(winwid)       ; width of window.
droom1 push af             ; store column counter.
       call flbyt          ; decompress next byte on the fly.
       push hl             ; store address of cell.
;MergeRoom	   
       and a               ; is it the empty block? es = 0 ?
       jr z,mroom2         ; yes, draw this block Transparency
	   
	IF INFRONT = 1
mroom5 call mpattr		   ; tiles in front ON
	ELSE
mroom5 ; tiles in front off	   
	ENDIF
	   
	   call pattr          ; show attributes and block.
mroom3 pop hl              ; restore cell address.
       pop af              ; restore loop counter.
       dec a               ; one less column.
       jr nz,droom1        ; repeat for entire line.
       ld a,(dispx)        ; x coord.
       inc a               ; move down one line.
       ld (dispx),a        ; set new position.
       pop af              ; restore row counter.
       dec a               ; one less row.
       jr nz,droom0        ; repeat for all rows.
       ret
mroom2 push af				; guarda el bloque
	   ld a,0				; carga Transparencia (mroom2+2)
	   and a
	   jr z,mroom4		   ; Transparency zero, goto draw it
	   ld hl,dispy         ; column position.
       inc (hl)            ; proceed right one cell.
	   pop af				; recupera el bloque y sigue con otro
       jr mroom3           ; back to decompression loop.
mroom4 pop af				; recupera el bloque e imprimelo.
	   jr mroom5
	   
; Decompress bytes on-the-fly.

flbyt  ld a,(comcnt)       ; compression counter.
       and a               ; any more to decompress?
       jr nz,flbyt1        ; yes.
       ld a,(hl)           ; fetch next byte.
       inc hl              ; point to next cell.
       cp 255              ; is this byte a control code?
       ret nz              ; no, this byte is uncompressed.
       ld a,(hl)           ; fetch byte type.
       ld (combyt),a       ; set up the type.
       inc hl              ; point to quantity.
       ld a,(hl)           ; get quantity.
       inc hl              ; point to next byte.
flbyt1 dec a               ; one less.
       ld (comcnt),a       ; store new quantity.
       ld a,(combyt)       ; byte to expand.
       ret


combyt defb 0              ; byte type compressed.
comcnt defb 0              ; compression counter.

; Ladder down check.

laddd  ld a,(ix+8)         ; x coordinate.
       and 254             ; make it even.
       ld (ix+8),a         ; reset it.
       ld h,(ix+9)         ; y coordinate.
numsp5 add a,16            ; look down 16 pixels.
       ld l,a              ; coords in hl.
       jr laddv

; Ladder up check.

laddu  ld a,(ix+8)         ; x coordinate.
       and 254             ; make it even.
       ld (ix+8),a         ; reset it.
       ld h,(ix+9)         ; y coordinate.
numsp6 add a,14            ; look 2 pixels above feet.
       ld l,a              ; coords in hl.
laddv  ld (dispx),hl       ; set up test coordinates.
       call tstbl          ; get map address.
       call ldchk          ; standard ladder check.
       ret nz              ; no way through.
       inc hl              ; look right one cell.
       call ldchk          ; do the check.
       ret nz              ; impassable.
       ld a,(dispy)        ; y coordinate.
       and 7               ; position straddling block cells.
       ret z               ; no more checks needed.
       inc hl              ; look to third cell.
       call ldchk          ; do the check.
       ret                 ; return with zero flag set accordingly.

; Can go up check.

cangu  ld a,(ix+8)         ; x coordinate.
       ld h,(ix+9)         ; y coordinate.
       sub 2               ; look up 2 pixels.
       ld l,a              ; coords in hl.
       ld (dispx),hl       ; set up test coordinates.
       call tstbl          ; get map address.
       call lrchk          ; standard left/right check.
       ret nz              ; no way through.
       inc hl              ; look right one cell.
       call lrchk          ; do the check.
       ret nz              ; impassable.
       ld a,(dispy)        ; y coordinate.
       and 7               ; position straddling block cells.
       ret z               ; no more checks needed.
       inc hl              ; look to third cell.
       call lrchk          ; do the check.
       ret                 ; return with zero flag set accordingly.

; Can go down check.

cangd  ld a,(ix+8)         ; x coordinate.
       ld h,(ix+9)         ; y coordinate.
numsp3 add a,16            ; look down 16 pixels.
       ld l,a              ; coords in hl.
       ld (dispx),hl       ; set up test coordinates.
       call tstbl          ; get map address.
       call plchk          ; block, platform check.
       ret nz              ; no way through.
       inc hl              ; look right one cell.
       call plchk          ; block, platform check.
       ret nz              ; impassable.
       ld a,(dispy)        ; y coordinate.
       and 7               ; position straddling block cells.
       ret z               ; no more checks needed.
       inc hl              ; look to third cell.
       call plchk          ; block, platform check.
       ret                 ; return with zero flag set accordingly.

; Can go left check.

cangl  ld l,(ix+8)         ; x coordinate.
       ld a,(ix+9)         ; y coordinate.
       sub 2               ; look left 2 pixels.
       ld h,a              ; coords in hl.
       jr cangh            ; test if we can go there.

; Can go right check.

cangr  ld l,(ix+8)         ; x coordinate.
       ld a,(ix+9)         ; y coordinate.
       add a,16            ; look right 16 pixels.
       ld h,a              ; coords in hl.

cangh  ld (dispx),hl       ; set up test coordinates.
cangh2 ld b,3              ; default rows to write.
       ld a,l              ; x position.
       and 7               ; does x straddle cells?
       jr nz,cangh0        ; yes, loop counter is good.
       dec b               ; one less row to write.
cangh0 call tstbl          ; get map address.
       ld de,32            ; distance to next cell.
cangh1 call lrchk          ; standard left/right check.
       ret nz              ; no way through.
       add hl,de           ; look down.
       djnz cangh1
       ret

; Check left/right movement is okay.

lrchk  ld a,(hl)           ; fetch map cell.
       cp WALL             ; is it passable?
       jr z,lrchkx         ; no.
       cp FODDER           ; fodder has to be dug.
       jr z,lrchkx         ; not passable.
always xor a               ; report it as okay.
       ret
lrchkx xor a               ; reset all bits.
       inc a
       ret

; Check platform or solid item is not in way.

plchk  ld a,(hl)           ; fetch map cell.
       cp WALL             ; is it passable?
       jr z,lrchkx         ; no.
       cp FODDER           ; fodder has to be dug.
       jr z,lrchkx         ; not passable.
       cp PLATFM           ; platform is solid.
       jr z,plchkx         ; not passable.
       cp LADDER           ; is it a ladder?
       jr z,lrchkx         ; on ladder, deny movement.
plchk0 xor a               ; report it as okay.
       ret
plchkx ld a,(dispx)        ; x coordinate.
       and 7               ; position straddling blocks.
       jr z,lrchkx         ; on platform, deny movement.
       jr plchk0

; Check ladder is available.

ldchk  ld a,(hl)           ; fetch cell.
       cp LADDER           ; is it a ladder?
       ret                 ; return with zero flag set accordingly.

; Get collectables.

	IF MASKAGD = 1
getcol	ld a,(MASKAGDopt)
		and a
		jr z,getcol2
		call skany
		ret c
	; borra Sprite
		call RESTAURA_Fondo_NUEVO
	; pinta Objetos
		call getcol2
	; Pinta sprite
		call PRINT_Sprite
		ret
getcol2 ld b,COLECT         ; collectable blocks.
		call tded           ; test for collectable blocks.
		cp b                ; did we find one?
		ret nz              ; none were found, job done.
		call gtblk          ; get block.
		call evnt20         ; collected block event.
		jr getcol2           ; repeat until none left.
	ELSE
getcol ld b,COLECT         ; collectable blocks.
       call tded           ; test for collectable blocks.
       cp b                ; did we find one?
       ret nz              ; none were found, job done.
       call gtblk          ; get block.
       call evnt20         ; collected block event.
       jr getcol           ; repeat until none left.
	ENDIF


; Get collectable block.

gtblk  ld (hl),0           ; make it empty now.
       ld de,MAP           ; map address.
       and a               ; clear carry.
       sbc hl,de           ; find cell number.
       ld a,l              ; get low byte of cell number.
       and 31              ; 0 - 31 is column.
       ld d,a              ; store y in d register.
       add hl,hl           ; multiply by 8.
       add hl,hl
       add hl,hl           ; x is now in h.
       ld e,h              ; put x in e.
       ld (dispx),de       ; set display coordinates.
		ld (vara),de		; MEIGA 2026 (Paco)
       ld a,(colpat)       ; get collectable block used on this screen.
       rlca                ; multiply char by 8.
       rlca
       rlca
       ld e,a              ; store shift in e.
       and 7               ; only want high byte bits.
       ld d,a              ; store in d.
       ld a,e              ; restore shifted value.
       and 248             ; only want low byte bits.
       ld e,a              ; that's the low byte.
       ld hl,chgfx         ; address of graphics.
       add hl,de           ; add displacement.
       call gprad          ; get screen address.

       ld a,(de)           ; get image byte.
       xor (hl)            ; merge with screen image.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(de)           ; get image byte.
       xor (hl)            ; merge with screen image.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(de)           ; get image byte.
       xor (hl)            ; merge with screen image.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(de)           ; get image byte.
       xor (hl)            ; merge with screen image.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(de)           ; get image byte.
       xor (hl)            ; merge with screen image.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(de)           ; get image byte.
       xor (hl)            ; merge with screen image.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(de)           ; get image byte.
       xor (hl)            ; merge with screen image.
       ld (de),a           ; copy to screen.
       inc hl              ; next image byte.
       inc d               ; next screen row down.
       ld a,(de)           ; get image byte.
       xor (hl)            ; merge with screen image.
       ld (de),a           ; copy to screen.
       call gaadd          ; get attribute address for block.
       ld a,(bcol)         ; first block colour.
       ld (hl),a           ; set block attribute.
       ret

; Touched deadly block check.
; Returns with DEADLY (must be non-zero) in accumulator if true.

tded   ld l,(ix+8)         ; x coordinate.
       ld h,(ix+9)         ; y coordinate.
       ld (dispx),hl       ; set up test coordinates.
       call tstbl          ; get map address.
       ld de,31            ; default distance to next line down.
       cp b                ; is this the required block?
       ret z               ; yes.
       inc hl              ; next cell.
       ld a,(hl)           ; fetch type.
       cp b                ; is this deadly/custom?
       ret z               ; yes.
       ld a,(dispy)        ; horizontal position.
       ld c,a              ; store column in c register.
       and 7               ; is it straddling cells?
       jr z,tded0          ; no.
       inc hl              ; last cell.
       ld a,(hl)           ; fetch type.
       cp b                ; is this the block?
       ret z               ; yes.
       dec de              ; one less cell to next row down.
tded0  add hl,de           ; point to next row.
       ld a,(hl)           ; fetch left cell block.
       cp b                ; is this fatal?
       ret z               ; yes.
       inc hl              ; next cell.
       ld a,(hl)           ; fetch type.
       cp b                ; is this fatal?
       ret z               ; yes.
       ld a,c              ; horizontal position.
       and 7               ; is it straddling cells?
       jr z,tded1          ; no.
       inc hl              ; last cell.
       ld a,(hl)           ; fetch type.
       cp b                ; is this fatal?
       ret z               ; yes.
tded1  ld a,(dispx)        ; vertical position.
       and 7               ; is it straddling cells?
       ret z               ; no, job done.
       add hl,de           ; point to next row.
       ld a,(hl)           ; fetch left cell block.
       cp b                ; is this fatal?
       ret z               ; yes.
       inc hl              ; next cell.
       ld a,(hl)           ; fetch type.
       cp b                ; is this fatal?
       ret z               ; yes.
       ld a,c              ; horizontal position.
       and 7               ; is it straddling cells?
       ret z               ; no.
       inc hl              ; last cell.
       ld a,(hl)           ; fetch final type.
       ret                 ; return with final type in accumulator.


; Fetch block type at (dispx, dispy).

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
       add hl,de           ; point to address.
       ld a,(hl)           ; fetch byte there.
       ret

; Jump - if we can.
; Requires initial speed to be set up in accumulator prior to call.

jump   neg                 ; switch sign so we jump up.
       ld c,a              ; store in c register.
;       ld a,(ix+8)         ; x coordinate.
;       ld h,(ix+9)         ; y coordinate.
;numsp4 add a,16            ; look down 16 pixels.
;       ld l,a              ; coords in hl.
;       and 7               ; are we on platform boundary?
;       ret nz              ; no, cannot jump.
;       ld (dispx),hl       ; set up test coordinates.
;       ld b,a              ; copy to b register.
;       call tstbl          ; get map address.
;       call plchk          ; block, platform check.
;       jr nz,jump0         ; it's solid, we can jump.
;       inc hl              ; look right one cell.
;       call plchk          ; block, platform check.
;       jr nz,jump0         ; it's solid, we can jump.
;       ld a,b              ; y coordinate.
;       and 7               ; position straddling block cells.
;       ret z               ; no more checks needed.
;       inc hl              ; look to third cell.
;       call plchk          ; block, platform check.
;       ret z               ; not solid, don't jump.
jump0  ld a,(ix+13)        ; jumping flag.
       and a               ; is it set?
       ret nz              ; already in the air.
       inc (ix+13)         ; set it.
       ld (ix+14),c        ; set jump height.
       ret

hop    ld a,(ix+13)        ; jumping flag.
       and a               ; is it set?
       ret nz              ; already in the air.
       ld (ix+13),255      ; set it.
       ld (ix+14),0        ; set jump table displacement.
       ret

; Random numbers code.
; Pseudo-random number generator, 8-bit.

random ld hl,seed          ; set up seed pointer.
       ld a,(hl)           ; get last random number.
       ld b,a              ; copy to b register.
       rrca                ; multiply by 32.
       rrca
       rrca
       xor 31
       add a,b
       sbc a,255
       ld (hl),a           ; store new seed.
       ld (varrnd),a       ; return number in variable.
       ret


; Keyboard test routine.

ktest  ld c,a              ; key to test in c.
       and 7               ; mask bits d0-d2 for row.
       inc a               ; in range 1-8.
       ld b,a              ; place in b.
       srl c               ; divide c by 8
       srl c               ; to find position within row.
       srl c
       ld a,5              ; only 5 keys per row.
       sub c               ; subtract position.
       ld c,a              ; put in c.
       ld a,254            ; high byte of port to read.
ktest0 rrca                ; rotate into position.
       djnz ktest0         ; repeat until we've found relevant row.
       in a,(254)          ; read port (a=high, 254=low).
ktest1 rra                 ; rotate bit out of result.
       dec c               ; loop counter.
       jp nz,ktest1        ; repeat until bit for position in carry.
       ret


; Joystick and keyboard reading routines.

joykey ld a,(contrl)       ; control flag.
       dec a               ; is it the keyboard?
       jr z,joyjoy         ; no, it's Kempston joystick.
       dec a               ; Sinclair?
       jr z,joysin         ; read Sinclair joystick.

; Keyboard controls.

       ld hl,keys+6        ; address of last key.
       ld e,0              ; zero reading.
       ld d,7              ; keys to read.
joyke0 ld a,(hl)           ; get key from table.
       call ktest          ; being pressed?
       ccf                 ; complement the carry.
       rl e                ; rotate into reading.
       dec hl              ; next key.
       dec d               ; one less to do.
       jp nz,joyke0        ; repeat for all keys.
       jr joyjo1           ; store the value.

; Kempston joystick controls.

joyjoy ld bc,31            ; port for Kempston interface.
       in a,(c)            ; read it.
joyjo3 ld e,a              ; copy to e register.
       ld a,(keys+5)       ; key six.
       call ktest          ; being pressed?
       jr c,joyjo0         ; not pressed.
       set 5,e             ; set bit d5.
joyjo0 ld a,(keys+6)       ; key seven.
       call ktest          ; being pressed?
       jr c,joyjo1         ; not pressed.
       set 6,e             ; set bit d6.
joyjo1 ld a,e              ; copy e register to accumulator.
joyjo2 ld (joyval),a       ; remember value.
       ret

; Sinclair joystick controls.

joysin ld bc,61438         ; port for Sinclair 2.
       in a,(c)            ; read joystick.
       ld d,a              ; clear values.
       xor a               ; clear accumulator.
       ld e,16             ; Kempston fire bit value.
       bit 0,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       ld e,1              ; Kempston bit value.
       bit 3,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       ld e,2              ; Kempston bit value.
       bit 4,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       ld e,8              ; Kempston bit value.
       bit 1,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       ld e,4              ; Kempston bit value.
       bit 2,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       jr joyjo3           ; read last 2 keys a la Kempston.

joysi0 add a,e             ; add bit value.
       ret

; Display message.

;dmsg   ld hl,nummsg        ; total messages.
;       cp (hl)             ; does this one exist?
;       ret nc              ; no, nothing to display.



dmsg   ld hl,msgdat        ; pointer to messages.
       call getwrd         ; get message number.
dmsg3  call preprt         ; pre-printing stuff.
       call checkx         ; make sure we're in a printable range.
       ld a,(prtmod)       ; print mode.
       and a               ; standard size?
       jp nz,bmsg1         ; no, double-height text.
dmsg0  push hl             ; store string pointer.
       ld a,(hl)           ; fetch byte to display.
       and 127             ; remove any end marker.
       cp 13               ; newline character?
       jr z,dmsg1
       call pchar          ; display character.
       call gaadd          ; get attribute address.
       ld a,(23693)        ; current cell colours.
       ld (hl),a           ; write to attribute cell.
       call nexpos         ; display position.
       jr nz,dmsg2         ; not on a new line.
       call nexlin         ; next line down.
dmsg2  pop hl
       ld a,(hl)           ; fetch last character.
       rla                 ; was it the end?
       jp c,dscor2         ; yes, job done.
       inc hl              ; next character to display.
       jr dmsg0
dmsg1  ld hl,dispx         ; x coordinate.
       inc (hl)            ; newline.
       ld a,(hl)           ; fetch position.
       cp 24               ; past screen edge?
       jr c,dmsg4          ; no, it's okay.
       ld (hl),0           ; restart at top.
dmsg4  inc hl              ; y coordinate.
       ld (hl),0           ; carriage return.
       jr dmsg2
prtmod defb 0              ; print mode, 0 = standard, 1 = double-height.

; Display message in big text.

bmsg1  ld a,(hl)           ; get character to display.
       push hl             ; store pointer to message.
       and 127             ; only want 7 bits.
       cp 13               ; newline character?
       jr z,bmsg2
       call bchar          ; display big char.
bmsg3  pop hl              ; retrieve message pointer.
       ld a,(hl)           ; look at last character.
       inc hl              ; next character in list.
       rla                 ; was terminator flag set?
       jr nc,bmsg1         ; no, keep going.
       ret
bmsg2  ld hl,charx         ; x coordinate.
       inc (hl)            ; newline.
       inc (hl)            ; newline.
       ld a,(hl)           ; fetch position.
       cp 23               ; past screen edge?
       jr c,bmsg3          ; no, it's okay.
       ld (hl),0           ; restart at top.
       inc hl              ; y coordinate.
       ld (hl),0           ; carriage return.
       jr bmsg3


; Big character display.

bchar  rlca                ; multiply char by 8.
       rlca
       rlca
       ld e,a              ; store shift in e.
       and 7               ; only want high byte bits.
       ld d,a              ; store in d.
       ld a,e              ; restore shifted value.
       and 248             ; only want low byte bits.
       ld e,a              ; that's the low byte.
       ld hl,(23606)       ; address of font.
       add hl,de           ; add displacement.
       call gprad          ; get screen address.
       ex de,hl            ; font in de, screen address in hl.
       ld b,8              ; height of character in font.
bchar0 ld a,(de)           ; get a bit of the font.
       inc de              ; next line of font.
       ld (hl),a           ; write to screen.
       inc h               ; down a line.
       ld (hl),a           ; write to screen.
       call nline          ; next line down.
       djnz bchar0         ; repeat.
       call gaadd          ; get attribute address.
       ld a,(23693)        ; current colour.
       ld (hl),a           ; set attribute.
       ld c,a              ; copy colour to c.
       ld de,32            ; distance to next line.
       add hl,de           ; point to second cell.
       ld a,h              ; high byte of address.
       cp 91               ; past edge of screen?
       jr nc,bchar1        ; yes, don't write to printer buffer/sysvars.
       ld (hl),c           ; set second cell's attributes.
bchar1 call nexpos         ; display position.
       jp nz,bchar2        ; not on a new line.
bchar3 inc (hl)            ; newline.
       call nexlin         ; next line check.
bchar2 jp dscor2           ; tidy up line and column variables.

; Display a character.

achar  ld b,a              ; copy to b.
       call preprt         ; get ready to print.
       ld a,(prtmod)       ; print mode.
       and a               ; standard size?
       ld a,b              ; character in accumulator.
       jp nz,bchar         ; no, double-height text.
       call pchar          ; display character.
       call gaadd          ; get attribute address.
       ld a,(23693)        ; current cell colours.
       ld (hl),a           ; write to attribute cell.
       call nexpos         ; display position.
       jp z,bchar3         ; next line down.
       jp bchar2           ; tidy up.

; Get next print column position.

nexpos ld hl,dispy         ; display position.
       ld a,(hl)           ; get coordinate.
       inc a               ; move along one position.
       and 31              ; reached edge of screen?
       ld (hl),a           ; set new position.
       dec hl              ; point to x now.
       ret                 ; return with status in zero flag.

; Get next print line position.

nexlin inc (hl)            ; newline.
       ld a,(hl)           ; vertical position.
       cp 24               ; past screen edge?
       ret c               ; no, still okay.
       ld (hl),0           ; restart at top.
       ret

; Pre-print preliminaries.

preprt ld de,(23606)       ; font pointer.
       ld (grbase),de      ; set up graphics base.
prescr ld de,(charx)       ; display coordinates.
       ld (dispx),de       ; set up general coordinates.
       ret

; On entry: hl points to word list
;           a contains word number.

getwrd and a               ; first word in list?
       ret z               ; yep, don't search.
       ld b,a
getwd0 ld a,(hl)
       inc hl
       cp 128              ; found end?
       jr c,getwd0         ; no, carry on.
       djnz getwd0         ; until we have right number.
       ret

; Bubble sort.
	IF MASKAGD = 1
		include "ZSort.asm"
	ELSE
bsort  ld b,NUMSPR - 1     ; sprites to swap.
       ld ix,sprtab        ; sprite table.
bsort0 push bc             ; store loop counter for now.

       ld a,(ix+0)         ; first sprite type.
       inc a               ; is it switched off?
       jr z,swemp          ; yes, may need to switch another in here.

		push ix				;*
		ld de,TABSIZ		;*
		add ix,de			;*
		ld a,(ix+0)			; next slot.
		pop ix				;*
       ;ld a,(ix+TABSIZ)     check next slot exists.
       inc a               ; is it enabled?
       jr z,bsort2         ; no, nothing to swap.
	   
	IF MASKAGD = 0
	   ld a,(ix+(3+TABSIZ))	; fetch next sprite's coordinate.
	   cp (ix+3)           	; compare with this x coordinate.
	ELSE
		push ix				;*
		ld de,TABSIZ		;*
		add ix,de			;*
		ld a,(ix+17)		; fetch next sprite's z coordinate.
		pop ix				;*
	   ;ld a,(ix+(17+TABSIZ))	fetch next sprite's z coordinate.
	   cp (ix+17)           ; compare with this z coordinate.
	ENDIF
		jr c,bsort1         ; next sprite is higher - may need to switch.
	   
bsort2 ld de,TABSIZ        ; distance to next odd/even entry.
       add ix,de           ; next sprite.
       pop bc              ; retrieve loop counter.
       djnz bsort0         ; repeat for remaining sprites.
       ret


bsort1  push ix				;*
		ld de,TABSIZ		;*
		add ix,de			;*
		ld a,(ix+0)		; next sprite on/off flag.
		pop ix				;*

	   ;ld a,(ix+TABSIZ)     next sprite on/off flag.
       inc a               ; is it enabled?
       jr z,bsort2         ; no, nothing to swap.
       call swspr          ; swap positions.
       jr bsort2

swemp   push ix				;*
		ld de,TABSIZ		;*
		add ix,de			;*
		ld a,(ix+0)		; next table entry.
		pop ix				;*

	   ;ld a,(ix+TABSIZ)    next table entry.
       inc a               ; is that one on?
       jr z,bsort2         ; no, nothing to swap.
       call swspr          ; swap positions.
       jr bsort2

; Swap sprites.

swspr  push ix             ; table address on stack.
       pop hl              ; pop into hl pair.
       ld d,h              ; copy to de pair.
       ld e,l
       ld bc,TABSIZ        ; distance to second entry.
       add hl,bc           ; point to second sprite entry.
       ld b,TABSIZ         ; bytes to swap.
swspr0 ld c,(hl)           ; fetch second byte.
       ld a,(de)           ; fetch first byte.
       ld (hl),a           ; copy to second.
       ld a,c              ; second byte in accumulator.
       ld (de),a           ; copy to first sprite entry.
       inc de              ; next byte.
       inc hl              ; next byte.
       djnz swspr0         ; swap all bytes in table entry.
       ret
	ENDIF

; Process sprites.

pspr   ld b,NUMSPR         ; sprites to process.
       ld ix,sprtab        ; sprite table.
pspr1  push bc             ; store loop counter for now.
       ld a,(ix+0)         ; fetch sprite type.
       cp 9                ; within range of sprite types?
       call c,pspr2        ; yes, process this one.
	IF SCROLL = 1
		or a
		jp nz,pspr5
	; GUARDA ultima posicion en la tabla de Sprites del PLAYER, necesita Scroll2024
		ld (Playerptr),ix
		ld h,(ix+8)
		ld l,(ix+9)
		ld (XPlayer),hl			; save in XPlayer
		; Candidato aquí plyptr = ix, para acceder al Player cuando quieres!! MEIGA 2026	
pspr5
	ENDIF
       ld de,TABSIZ        ; distance to next odd/even entry.
       add ix,de           ; next sprite.
       pop bc              ; retrieve loop counter.
       djnz pspr1          ; repeat for remaining sprites.
       ret
pspr2  
	   ld (ogptr),ix       ; store original sprite pointer.
       call pspr3          ; do the routine.
rtorg  ld ix,(ogptr)       ; restore original pointer to sprite.
rtorg0 ret
pspr3  ld hl,evtyp0        ; sprite type events list.
pspr4  add a,a             ; double accumulator.
       ld e,a              ; copy to de.
       ld d,0              ; no high byte.
       add hl,de           ; point to address of routine.
       ld e,(hl)           ; address low.
       inc hl              ; next byte of address.
       ld d,(hl)           ; address high.
       ex de,hl            ; swap address into hl.
       jp (hl)             ; go there.
	IF ULABUFFER = 0
ogptr  defw 0              ; original sprite pointer.

; Address of each sprite type's routine.

evtyp0 defw evnt00
evtyp1 defw evnt01
evtyp2 defw evnt02
evtyp3 defw evnt03
evtyp4 defw evnt04
evtyp5 defw evnt05
evtyp6 defw evnt06
evtyp7 defw evnt07
evtyp8 defw evnt08
evtyp9 defw $				; en desarrollo
		ret
	ELSE
		; MOVIDO a header
	ENDIF

; Display sprites.

dspr   ld b,NUMSPR/2       ; number of sprites to display.
dspr0  push bc             ; store loop counter for now.

	IF SCROLL = 1
		ld a,(echo)		;echo
		and a			;echo
		jp nz,dspr5		;echo, si
	ENDIF
	
       ld a,(ix+0)         ; get sprite type.
       inc a               ; is it enabled?
       jr nz,dspr1         ; yes, it needs deleting.
dspr5  ld a,(ix+5)         ; new type.
       inc a               ; is it enabled?
       jr nz,dspr3         ; yes, it needs drawing.
	
dspr2  push ix             ; put ix on stack.
       pop hl              ; pop into hl.
       ld e,l              ; copy to de.
       ld d,h
       ld bc,5             ; distance to new type.
       add hl,bc           ; point to new properties.
       ldi                 ; copy to old positions.
       ldi
       ldi
       ldi
       ldi
       ld bc,TABSIZ*2       ; ;warning: value 0x148 is truncated to 8bit value: 0x48 si usamos mascara HACK
       ;ld c,TABSIZ*2       ; distance to next odd/even entry. ORIGINAL
       add ix,bc           ; next sprite.
       pop bc              ; retrieve loop counter.
       djnz dspr0          ; repeat for remaining sprites.
       ret

dspr1  ld a,(ix+5)         ; type of new sprite.
       inc a               ; is this enabled?
       jr nz,dspr4         ; yes, display both.
dspr6  call sspria         ; display the new sprite.
	   jp dspr2

; Displaying two sprites.  Don't bother redrawing if nothing has changed.

dspr4  ld a,(ix+4)         ; old y.
       cp (ix+9)           ; compare with new value.
       jr nz,dspr7         ; they differ, need to redraw.
       ld a,(ix+3)         ; old x.
       cp (ix+8)           ; compare against new value.
       jr nz,dspr7         ; they differ, need to redraw.
       ld a,(ix+2)         ; old frame.
       cp (ix+7)           ; compare against new value.
       jr nz,dspr7         ; they differ, need to redraw.
       ld a,(ix+1)         ; old image.
       cp (ix+6)           ; compare against new value.
       jp z,dspr2          ; everything is the same, don't redraw.

dspr7  call sspric         ; delete old sprite, draw new one simultaneously.
       jp dspr2
	
dspr3  call ssprib         ; show single sprite.
       jp dspr2

	IF MASKAGD = 0
; Get sprite address calculations.
; gspran = new sprite, gsprad = old sprite.

gspran ld l,(ix+8)         ; new x coordinate.
       ld h,(ix+9)         ; new y coordinate.
       ld (dispx),hl       ; set display coordinates.
       ld a,(ix+6)         ; new sprite image.
       call gfrm           ; fetch start frame for this sprite.
       ld a,(hl)           ; frame in accumulator.
       add a,(ix+7)        ; new add frame number.
       jp gspra0

gsprad ld l,(ix+3)         ; x coordinate.
       ld h,(ix+4)         ; y coordinate.
       ld (dispx),hl       ; set display coordinates.
       ld a,(ix+1)         ; sprite image.
       call gfrm           ; fetch start frame for this sprite.
       ld a,(hl)           ; frame in accumulator.
       add a,(ix+2)        ; add frame number.

gspra0 rrca                ; multiply by 128.
       ld d,a              ; store in d.
       and 128             ; low byte bit.
       ld e,a              ; got low byte.
       ld a,d              ; restore result.
       and 127             ; high byte bits.
       ld d,a              ; displacement high byte.
       ld hl,sprgfx        ; address of play sprites.
       add hl,de           ; point to frame.

       ld a,(dispy)        ; y coordinate.
       and 6               ; position within byte boundary.
       ld c,a              ; low byte of table displacement.
       rlca                ; multiply by 32.
       rlca                ; already a multiple
       rlca                ; of 2, so just 4
       rlca                ; shifts needed.
       ld e,a              ; put displacement in low byte of de.
       ld d,0              ; zero the high byte.
       ld b,d              ; no high byte for mask displacement either.
       add hl,de           ; add to sprite address.
       ex de,hl            ; need it in de for now.
	   
       ld hl,spmask        ; pointer to mask table.
       add hl,bc           ; add displacement to pointer.
       ld c,(hl)           ; left mask.
       inc hl
       ld b,(hl)           ; right mask.

; Drop into screen address routine.
; This routine returns a screen address for (dispx, dispy) in hl.

scadd  ld a,(dispx)        ; coordinate.
       ld l,a              ; low byte of table.
       ld h,251            ; high byte of 64256 (SCADTB).
       ld a,(hl)           ; fetch high byte.
       inc h               ; point to low byte table.
       ld l,(hl)           ; fetch low byte.
       ld h,a              ; hl points to start of line.
       ld a,(dispy)        ; y pixel coordinate.
       rrca                ; divide by 8.
       rrca
       rrca
       and 31              ; squares 0 - 31 across screen.
       add a,l             ; add to address.
       ld l,a              ; copy to hl = address of screen.
       ret

spmask defb 255,0,63,192,15,240,3,252
	
; These are the sprite routines.
; sspria = single sprite, old (ix).
; ssprib = single sprite, new (ix+5).
; sspric = both sprites, old (ix) and new (ix+5).

	;IF MASKAGD = 0

sspria call gsprad         ; get old sprite address.
sspri2 ld a,16             ; vertical lines.
sspri0 ex af,af'           ; store line counter away in alternate registers.
       call dline          ; draw a line.
       ex af,af'           ; restore line counter.
       dec a               ; one less to go.
       jp nz,sspri0
       ret

ssprib call gspran         ; get new sprite address.
       jp sspri2
	   
sspric call gsprad         ; get old sprite address.
       exx                 ; store addresses.
       call gspran         ; get new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.
       call dline          ; delete a line.
       exx                 ; flip to new sprite addresses.
       call dline          ; draw a line.
       exx                 ; restore old addresses.

; Drop through.
; Line drawn, now work out next target address.

dline  ld a,(de)           ; graphic data.
       and c               ; mask away what's not needed.
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.
       inc l               ; next screen address.
       inc l               ; next screen address.	   
       ld a,(de)           ; fetch data.
       and b               ; mask away unwanted bits.
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.	   
       inc de              ; next graphic.
       dec l               ; one character cell to the left.   
       ld a,(de)           ; second bit of data.
       xor (hl)            ; XOR with what's there.
       ld (hl),a           ; bung it in.
       inc de              ; point to next line of data.
       dec l               ; another char left.

		
; Line drawn, now work out next target address.

nline  inc h               ; increment pixel.
       ld a,h              ; get pixel address.
       and 7               ; straddling character position?
       ret nz              ; no, we're on next line already.
       ld a,h              ; get pixel address.
       sub 8               ; subtract 8 for start of segment.
       ld h,a              ; new high byte of address.
       ld a,l              ; get low byte of address.
       add a,32            ; one line down.
       ld l,a              ; new low byte.
       ret nc              ; not reached next segment yet.
       ld a,h              ; address high.
       add a,8             ; add 8 to next segment.
       ld h,a              ; new high byte.
       cp 88               ; reached end of screen?
       ret c               ; not yet.
       ld h,56             ; back to ROM.
       ret
	ELSE
		; MOVIDAS a header
	ENDIF
	
; MASKAGD RUTINAS
	;IF MASKAGD = 1
	;		include "SistemaSpritesAgd_bucle_estable.asm"
	;ENDIF
			
; Animates a sprite.

animsp ld hl,frmno         ; game frame.
       and (hl)            ; is it time to change the frame?
       ret nz              ; not this frame.
       ld a,(ix+6)         ; sprite image.
       call gfrm           ; get frame data.
       inc hl              ; point to frames.
       ld a,(ix+7)         ; sprite frame.
       inc a               ; next one along.
       cp (hl)             ; reached the last frame?
       jr c,anims0         ; no, not yet.
       xor a               ; start at first frame.
anims0 ld (ix+7),a         ; new frame.
       ret
animbk ld hl,frmno         ; game frame.
       and (hl)            ; is it time to change the frame?
       ret nz              ; not this frame.
       ld a,(ix+6)         ; sprite image.
       call gfrm           ; get frame data.
       inc hl              ; point to frames.
       ld a,(ix+7)         ; sprite frame.
       and a               ; first one?
       jr nz,rtanb0        ; yes, start at end.
       ld a,(hl)           ; last sprite.
rtanb0 dec a               ; next one along.
       jr anims0           ; set new frame.

; Check for collision with other sprite, strict enforcement.

sktyp  ld hl,sprtab        ; sprite table.
numsp2 ld a,NUMSPR         ; number of sprites.
sktyp0 ex af,af'           ; store loop counter.'
       ld (skptr),hl       ; store pointer to sprite.
       ld a,(hl)           ; get sprite type.
       cp b                ; is it the type we seek?
       jr z,coltyp         ; yes, we can use this one.
sktyp1 ld hl,(skptr)       ; retrieve sprite pointer.
       ld de,TABSIZ        ; size of each entry.
       add hl,de           ; point to next sprite in table.
       ex af,af'           ; restore loop counter.'
       dec a               ; one less iteration.
       jp nz,sktyp0        ; keep going until we find a slot.
       ld hl,0             ; default to ROM address - no sprite.
       ld (skptr),hl       ; store pointer to sprite.
       or h                ; don't return with zero flag set.
       ret                 ; didn't find one.
skptr  defw 0              ; search pointer.

coltyp ld a,(ix+0)         ; current sprite type.
       cp b                ; seeking sprite of same type?
       jr z,colty1         ; yes, need to check we're not detecting ourselves.
colty0 ld de,X             ; distance to x position in table.
       add hl,de           ; point to coords.
       ld e,(hl)           ; fetch x coordinate.
       inc hl              ; now point to y.
       ld d,(hl)           ; that's y coordinate.

; Drop into collision detection.

colc16 ld a,(ix+X)         ; x coord.
       sub e               ; subtract x.
       jr nc,colc1a        ; result is positive.
       neg                 ; make negative positive.
colc1a cp 16		       ; within x range?
       jr nc,sktyp1        ; no - they've missed.
       ld c,a              ; store difference.
       ld a,(ix+Y)         ; y coord.
       sub d               ; subtract y.
       jr nc,colc1b        ; result is positive.
       neg                 ; make negative positive.
colc1b cp 16               ; within y range?
       jr nc,sktyp1        ; no - they've missed.
       add a,c             ; add x difference.
       cp 26               ; only 5 corner pixels touching? MEIGA
       ret c               ; carry set if there's a collision.
       jp sktyp1           ; try next sprite in table.

colty1 push ix             ; base sprite address onto stack.
       pop de              ; pop it into de.
       ex de,hl            ; flip hl into de.
       sbc hl,de           ; compare the two.
       ex de,hl            ; restore hl.
       jr z,sktyp1         ; addresses are identical.
       jp colty0

; Display number.

disply ld bc,displ0        ; display workspace.
       call num2ch         ; convert accumulator to string.
displ1 dec bc              ; back one character.
       ld a,(bc)           ; fetch digit.
       or 128              ; insert end marker.
       ld (bc),a           ; new value.
       ld hl,displ0        ; display space.
       jp dmsg3            ; display the string.
displ0 defb 0,0,0,13+128


; Initialise screen.

initsc ld a,(roomtb)       ; whereabouts in the map are we?
       call tstsc          ; find displacement.
       cp 255              ; is it valid?
       ret z               ; no, it's rubbish.
       ld (scno),a         ; store new room number.
       ret

; Test screen.

tstsc  ld hl,mapdat - MAPWID ; start of map data, subtract width for negative.
       ld b,a              ; store room in b for now.
       add a,MAPWID        ; add width in case we're negative.
       ld e,a              ; screen into e.
       ld d,0              ; zeroise d.
       add hl,de           ; add displacement to map data.
       ld a,(hl)           ; find room number there.
       ret

; Screen left.

scrl   ld a,(roomtb)       ; present room table pointer.
       dec a               ; room left.
scrl0  call tstsc          ; test screen.
       inc a               ; is there a screen this way?
       ret z               ; no, return to loop.
       ld a,b              ; restore room displacement.
       ld (roomtb),a       ; new room table position.
scrl1  call initsc         ; set new screen.
       ld hl,restfl        ; restart screen flag.
       ld (hl),2           ; set it.
       ret
scrr   ld a,(roomtb)       ; room table pointer.
       inc a               ; room right.
       jr scrl0
scru   ld a,(roomtb)       ; room table pointer.
       sub MAPWID          ; room up.
       jr scrl0
scrd   ld a,(roomtb)       ; room table pointer.
       add a,MAPWID        ; room down.
       jr scrl0

; Jump to new screen.

nwscr  ld hl,mapdat        ; start of map data.
       ld bc,256*158       ; zero room count, 160 to search. MEIGA 2025
nwscr0 cp (hl)             ; have we found a match for screen?
       jr z,nwscr1         ; yes, set new point in map.
       inc hl              ; next room.
       inc c               ; count rooms.
       djnz nwscr0         ; keep looking.
       ret
nwscr1 ld a,c              ; room displacement.
       ld (roomtb),a       ; set the map position.
       jr scrl1            ; draw new room.

; Gravity processing.

grav   ld a,(ix+13)        ; in-air flag.
       and a               ; are we in the air?
       ret z               ; no we are not.
       inc a               ; increment it.
       jp z,ogrv           ; set to 255, use old gravity.
       ld (ix+13),a        ; write new setting.
       rra                 ; every other frame.
       jr nc,grav0         ; don't apply gravity this time.
       ld a,(ix+14)        ; pixels to move.
       cp 16               ; reached maximum?
       jr z,grav0          ; yes, continue.
       inc (ix+14)         ; slow down ascent/speed up fall.
grav0  ld a,(ix+14)        ; get distance to move.
       sra a               ; divide by 2.
       and a               ; any movement required?
       ret z               ; no, not this time.
       cp 128              ; is it up or down?
       jr nc,gravu         ; it's up.
gravd  ld b,a              ; set pixels to move.
gravd0 call cangd          ; can we go down?
       jr nz,gravst        ; can't move down, so stop.
       inc (ix+8)          ; adjust new x coord.
       djnz gravd0
       ret
gravu  neg                 ; flip the sign so it's positive.
       ld b,a              ; set pixels to move.
gravu0 call cangu          ; can we go up?
       jp nz,ifalls        ; can't move up, go down next.
       dec (ix+8)          ; adjust new x coord.
       djnz gravu0
       ret
gravst ld a,(ix+14)        ; jump pointer high.
       ld (ix+13),0        ; reset falling flag.
	   ld (ix+14),0        ; store new speed.			MEIGA diference
       cp 8                ; was speed the maximum?
evftf  jp z,evnt15         ; yes, fallen too far.
       ret

; Old gravity processing for compatibility with 4.6 and 4.7.

ogrv   ld e,(ix+14)        ; get index to table.
       ld d,0              ; no high byte.
       ld hl,jtab          ; jump table.
       add hl,de           ; hl points to jump value.
       ld a,(hl)           ; pixels to move.
       cp 99               ; reached the end?
       jr nz,ogrv0         ; no, continue.
       dec hl              ; go back to previous value.
       ld a,(hl)           ; fetch that from table.
       jr ogrv1
ogrv0  inc (ix+14)         ; point to next table entry.
ogrv1  and a               ; any movement required?
       ret z               ; no, not this time.
       cp 128              ; is it up or down?
       jr nc,ogrvu         ; it's up.
ogrvd  ld b,a              ; set pixels to move.
ogrvd0 call cangd          ; can we go down?
       jr nz,ogrvst        ; can't move down, so stop.
       inc (ix+8)          ; adjust new x coord.
       djnz ogrvd0
       ret
ogrvu  neg                 ; flip the sign so it's positive.
       ld b,a              ; set pixels to move.
ogrvu0 call cangu          ; can we go up?
       jr nz,ogrv2         ; can't move up, go down next.
       dec (ix+8)          ; adjust new x coord.
       djnz ogrvu0
       ret
ogrvst ld e,(ix+14)        ; get index to table.
       ld d,0              ; no high byte.
       ld hl,jtab          ; jump table.
       add hl,de           ; hl points to jump value.
       ld a,(hl)           ; fetch byte from table.
       cp 99               ; is it the end marker?
       ld (ix+13),0        ; reset jump flag.
       ld (ix+14),0        ; reset pointer.
       jp evftf
ogrv2  ld hl,jtab          ; jump table.
       ld b,0              ; offset into table.
ogrv4  ld a,(hl)           ; fetch table byte.
       cp 100              ; hit end or downward move?
       jr c,ogrv3          ; yes.
       inc hl              ; next byte of table.
       inc b               ; next offset.
       jr ogrv4            ; keep going until we find crest/end of table.
ogrv3  ld (ix+14),b        ; set next table offset.
       ret

; Initiate fall check.

ifall  ld a,(ix+13)        ; jump pointer flag.
       and a               ; are we in the air?
       ret nz              ; if set, we're already in the air.
       ld h,(ix+9)         ; y coordinate.
       ld a,16             ; look down 16 pixels.
       add a,(ix+8)        ; add x coordinate.
       ld l,a              ; coords in hl.
       ld (dispx),hl       ; set up test coordinates.
       call tstbl          ; get map address.
       call plchk          ; block, platform check.
       ret nz              ; it's solid, don't fall.
       inc hl              ; look right one cell.
       call plchk          ; block, platform check.
       ret nz              ; it's solid, don't fall.
       ld a,(dispy)        ; y coordinate.
       and 7               ; position straddling block cells.
       jr z,ifalls         ; no more checks needed.
       inc hl              ; look to third cell.
       call plchk          ; block, platform check.
       ret nz              ; it's solid, don't fall.
ifalls inc (ix+13)         ; set in air flag.
       ld (ix+14),0        ; initial speed = 0.
       ret
tfall  ld a,(ix+13)        ; jump pointer flag.
       and a               ; are we in the air?
       ret nz              ; if set, we're already in the air.
       call ifall          ; do fall test.
       ld a,(ix+13)        ; get falling flag.
       and a               ; is it set?
       ret z               ; no.
       ld (ix+13),255      ; we're using the table.
       jr ogrv2            ; find position in table.

	IF MASKAGD = 0
; Get frame data for a particular sprite.

gfrm   rlca                ; multiple of 2.
       ld e,a              ; copy to de.
       ld d,0              ; no high byte as max sprite is 128.
       ld hl,(frmptr)      ; frames used by game.
       add hl,de           ; point to frame start.
       ret
	ELSE
		; MOVIDO a header
	ENDIF
	
; Find sprite list for current room.

sprlst ld a,(scno)         ; screen number.
sprls2 ld hl,(nmeptr)      ; pointer to enemies.
       ld b,a              ; loop counter in b register.
       and a               ; is it the first screen?
       ret z               ; yes, don't need to search data.
       ld de,NMESIZ        ; bytes to skip.
sprls1 ld a,(hl)           ; fetch type of sprite.
       inc a               ; is it an end marker?
       jr z,sprls0         ; yes, end of this room.
       add hl,de           ; point to next sprite in list.
       jr sprls1           ; continue until end of room.
sprls0 inc hl              ; point to start of next screen.
       djnz sprls1         ; continue until room found.
       ret


; Clear all but a single player sprite.

nspr   ld b,NUMSPR         ; sprite slots in table.
       ld ix,sprtab        ; sprite table.
       ld de,TABSIZ        ; distance to next odd/even entry.
nspr0  ld a,(ix+0)         ; fetch sprite type.
       and a               ; is it a player?
       jr z,nspr1          ; yes, keep this one.
       ld (ix+0),255       ; delete sprite.
       ld (ix+5),255       ; remove next type.
       add ix,de           ; next sprite.
       djnz nspr0          ; one less space in the table.
       ret
nspr1  ld (ix+0),255       ; delete sprite.
       add ix,de           ; point to next sprite.
       djnz nspr2          ; one less to do.
       ret
nspr2  ld (ix+0),255       ; delete sprite.
       ld (ix+5),255       ; remove next type.
       add ix,de           ; next sprite.
       djnz nspr2          ; one less space in the table.
       ret


; Two initialisation routines.
; Initialise sprites - copy everything from list to table.

ispr   ld b,NUMSPR         ; sprite slots in table.
       ld ix,sprtab        ; sprite table.
ispr2  ld a,(hl)           ; fetch byte.
       cp 255              ; is it an end marker?
       ret z               ; yes, no more to do.
ispr1  ld a,(ix+0)         ; fetch sprite type.
       cp 255              ; is it enabled yet?
       jr nz,ispr4         ; yes, try another slot.
       ld a,(ix+5)         ; next type.
       cp 255              ; is it enabled yet?
       jr z,ispr3          ; no, process this one.
ispr4  ld de,TABSIZ        ; distance to next odd/even entry.
       add ix,de           ; next sprite.
       djnz ispr1          ; repeat for remaining sprites.
       ret                 ; no more room in table.
ispr3  call cpsp           ; initialise a sprite.
       djnz ispr2          ; one less space in the table.
       ret

; Initialise sprites - but not player, we're keeping the old one.

kspr   ld b,NUMSPR         ; sprite slots in table.
       ld ix,sprtab        ; sprite table.
kspr2  ld a,(hl)           ; fetch byte.
       cp 255              ; is it an end marker?
       ret z               ; yes, no more to do.
       and a               ; is it a player sprite?
       jr nz,kspr1         ; no, add to table as normal.
       ld de,NMESIZ        ; distance to next item in list.
       add hl,de           ; point to next one.
       jr kspr2
kspr1  ld a,(ix+0)         ; fetch sprite type.
       cp 255              ; is it enabled yet?
       jr nz,kspr4         ; yes, try another slot.
       ld a,(ix+5)         ; next type.
       cp 255              ; is it enabled yet?
       jr z,kspr3          ; no, process this one.
kspr4  ld de,TABSIZ        ; distance to next odd/even entry.
       add ix,de           ; next sprite.
       djnz kspr1          ; repeat for remaining sprites.
       ret                 ; no more room in table.
kspr3  call cpsp           ; copy sprite to table.
       djnz kspr2          ; one less space in the table.
       ret

; Copy sprite from list to table.

cpsp   ld a,(hl)           ; fetch byte from table.
       ld (ix+0),a         ; set up type.
       ld (ix+PAM1ST),a    ; set up type.
       inc hl              ; move to next byte.
       ld a,(hl)           ; fetch byte from table.
       ld (ix+6),a         ; set up image.
       inc hl              ; move to next byte.
       ld a,(hl)           ; fetch byte from table.
       ld (ix+3),200       ; set initial coordinate off screen.
       ld (ix+8),a         ; set up coordinate.
       inc hl              ; move to next byte.
       ld a,(hl)           ; fetch byte from table.
       ld (ix+9),a         ; set up coordinate.
       inc hl              ; move to next byte.
       xor a               ; zeroes in accumulator.
       ld (ix+7),a         ; reset frame number.
       ld (ix+10),a        ; reset direction.
;       ld (ix+12),a        ; reset parameter B.
       ld (ix+13),a        ; reset jump pointer low.
       ld (ix+14),a        ; reset jump pointer high.
       ld (ix+16),255      ; reset data pointer to auto-restore.
	   
	IF MASKAGD > 0
		;ld a,(ix+6)
		xor a
		ld (ix+66),a		; reset mask image
		ld a,(z_counter)    ; lee Z global actual
		ld (ix+17),a        ; asigna Z al sprite
		inc a               ; incrementa para el siguiente sprite
		ld (z_counter),a
		; TEST
	ENDIF
		
       push ix             ; store ix pair.
       push hl             ; store hl pair.
       push bc
evis0  call evnt09         ; perform event.
       pop bc
       pop hl              ; restore hl.
       pop ix              ; restore ix.
       ld de,TABSIZ        ; distance to next odd/even entry.
       add ix,de           ; next sprite.
       ret
	IF MASKAGD > 0
z_counter: defb 0    ; Contador global de Z
	ENDIF

; Clear the play area window.

clw    ld hl,(wintop)      ; get coordinates of window.
       ld (dispx),hl       ; put into dispx for calculation.
       ld a,(winhgt)       ; height of window.
       ld b,a              ; copy to b register.
clw3   push bc             ; store lines on stack.
       ld a,(winwid)       ; width of window.
clw2   ex af,af'           ; store column counter.'
       call gprad          ; get print address.
       xor a               ; zero byute to write.
       ld b,8              ; pixel height of each cell.
clw1   ld (de),a           ; copy to screen.
       inc d               ; next screen row down.
       djnz clw1
       call gaadd          ; get attribute address.
       ld a,(23693)        ; get colour.
       ld (hl),a           ; write colour.
       ld hl,dispy         ; column position.
       inc (hl)            ; next column.
       ex af,af'           ; restore column counter.'
       dec a               ; one less to do.
       jr nz,clw2          ; repeat for remaining columns.
       ld a,(winlft)       ; get left edge.
       ld (dispy),a        ; reset y.
       ld hl,dispx         ; line.
       inc (hl)            ; next line down.
       pop bc              ; restore line counter.
       djnz clw3           ; repeat down the screen.
       ld hl,(wintop)      ; get coordinates of window.
       ld (charx),hl       ; put into display position.
       ret

; Effects code.
; Ticker routine is called 25 times per second.

scrly  ret
       defw txtscr         ; get screen address.
       ld b,8              ; 8 pixel rows.
       push hl             ; store screen address.
scrly1 push bc             ; store rows on stack.
       push hl
       ld a,(txtwid)       ; characters wide.
       ld b,a              ; put into the loop counter.
       and a               ; reset carry flag.
scrly0 rl (hl)             ; rotate left.
       dec l               ; char left.
       djnz scrly0         ; repeat for width of ticker message.
       pop hl
       inc h               ; next row down.
       pop bc              ; retrieve row counter from stack.
       djnz scrly1         ; repeat for all rows.
       ld hl,(txtpos)      ; get text pointer.
       ld a,(hl)           ; find character we're displaying.
       and 127             ; remove end marker bit if applicable.
       cp 13               ; is it newline?
       jr nz,scrly5        ; no, it's okay.
       ld a,32             ; convert to a space instead.
scrly5 rlca
       rlca
       rlca                ; multiply by 8 to find char.
       ld b,a              ; store shift in b.
       and 3               ; keep within 768-byte range of font.
       ld d,a              ; that's our high byte.
       ld a,b              ; restore the shift.
       and 248
       ld e,a
       ld hl,(23606)       ; font address.
       add hl,de           ; point to image of character.
       ex de,hl            ; need the address in de.
       pop hl

       ld a,(txtbit)
       ld c,a
       ld b,8
scrly3 ld a,(de)           ; get image of char line.
       and c               ; test relevant bit of char.
       jr z,scrly2         ; not set - skip.
       inc (hl)            ; set bit.
scrly2 inc h               ; next line of window.
       inc de              ; next line of char.
       djnz scrly3
       ld hl,txtbit        ; bit of text to display.
       rrc (hl)            ; next bit of char to use.
       ret nc              ; not reached end of character yet.
       ld hl,(txtpos)      ; text pointer.
       ld a,(hl)           ; what was the character?
       inc hl              ; next character in message.
       rla                 ; end of message?
       ;ret nc              ; not yet, exit here.
       ;ld a,201            ; code for ret.
       ;ld (scrly),a        ; disable scrolling routine.
       jr nc,scrly6        ; not yet - continue.
scrly4 ld hl,(txtini)      ; start of scrolling message.
scrly6 ld (txtpos),hl      ; new text pointer position.
       ret

iscrly call prescr         ; set up display position.
       ld hl,msgdat        ; text messages.
       ld a,b              ; width.
       dec a               ; subtract one.
       cp 32               ; is it between 1 and 32?
       jr nc,iscrl0        ; no, disable messages.
       ld a,c              ; message number.
       ld d,b              ; copy width to d.
       call getwrd         ; find message start.
       ld b,d              ; restore width to b register.
       ld (txtini),hl      ; set initial text position.
       ld a,42             ; code for ld hl,(nn).
iscrl0 ld (scrly),a        ; enable/disable scrolling routine.
       call prescr         ; set up display position.
       call gprad          ; get print address.
       ld l,b              ; width in b so copy to hl.
       ld h,0              ; no high byte.
       dec hl              ; width minus one.
       add hl,de           ; add width.
       ld (txtscr),hl      ; set text screen address.
       ld a,b              ; width.
       ld (txtwid),a       ; set width in working storage.
       ld hl,txtbit        ; bit of text to display.
       ld (hl),128         ; start with leftmost bit.
       jr scrly4

; Sprite table.
; ix+0  = type.
; ix+1  = sprite image number.
; ix+2  = frame.
; ix+3  = x coord.
; ix+4  = y coord.

; ix+5  = new type.
; ix+6  = new image number.
; ix+7  = new frame.
; ix+8  = new x coord.
; ix+9  = new y coord.

; ix+10 = direction.
; ix+11 = parameter 1.
; ix+12 = parameter 2.
; ix+13 = jump pointer low.
; ix+14 = jump pointer high.
; ix+15 = data pointer low.
; ix+16 = data pointer high.
	IF MASKAGD > 0
		; IX+17 = Z coord
		; ix+18 = buffer background
		; ix+66 = imageMask
		; ix+67 = solapamiento
		; ix+68 = BufferPrint
		; ix+116 = BufferNuevoFondo
	ENDIF

sprtab equ $
       defs SPRBUF,255

ssprit defb 255,255,255,255,255,255,255,0,192,120,0,0,0,255,255,255,255 

roomtb defb 34                     ; room number.

; Sounds.
fx1

Sound48kBeeperMod

PluginMod
	IF INFRONT = 1
		include "PRINTinFRONTadventureMOD.asm"
	ENDIF

UserMod
user
		include "SelectCom.asm"

user1
	IF SCROLL = 1
		include "scroll_2024.asm"
	ENDIF

;user0				
		include "user.asm"


plsnd  ret
DEBUG  equ mloop
ibloc  jp initsc
rbloc  ret
eop    equ $
