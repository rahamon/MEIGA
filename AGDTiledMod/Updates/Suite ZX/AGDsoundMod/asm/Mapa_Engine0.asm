; CLIENTE

LEVELZERO	equ $

LevelPointers_Map
; Map
; Variables
WINDOWTOP	equ LEVELZERO+0
WINDOWLFT	equ LEVELZERO+2
WINDOWHGT	equ LEVELZERO+4
WINDOWWID	equ LEVELZERO+6
MAPWID		equ LEVELZERO+8
; Adress pointers
mapdat		equ LEVELZERO+10
stmap		equ LEVELZERO+12
; Calculos
; Adress pointers
;mapdat-MAPWID	equ LEVELZERO+88

; Events
; Adress pointers
evnt00		equ LEVELZERO+46
evnt01		equ LEVELZERO+48
evnt02		equ LEVELZERO+50
evnt03		equ LEVELZERO+52
evnt04		equ LEVELZERO+54
evnt05		equ LEVELZERO+56
evnt06		equ LEVELZERO+58
evnt07		equ LEVELZERO+60
evnt08		equ LEVELZERO+62

; Mensajes
; Adress pointers
msgdat		equ LEVELZERO+14
nummsg		equ LEVELZERO+16

; Screens
; Adress pointers
scdat  		equ LEVELZERO+18
numsc  		equ LEVELZERO+20

; Sprites
; Adress pointers
sprgfx		equ LEVELZERO+28
frmlst		equ LEVELZERO+30
nmedat		equ LEVELZERO+32

; Objects
; Variables
NUMOBJ		equ LEVELZERO+34
; Adress pointers
objdta		equ LEVELZERO+36

; Enviroment
; common
; Adress pointers
palett		equ LEVELZERO+38
font		equ LEVELZERO+40
jtab		equ LEVELZERO+42
keys		equ LEVELZERO+44
; Blocks
; common
; Adress pointers
chgfx		equ LEVELZERO+22
bcol		equ LEVELZERO+24
bprop		equ LEVELZERO+26
; Arcade events
; Common
; Adress pointers
evnt09		equ LEVELZERO+64
evnt10		equ LEVELZERO+66
evnt11		equ LEVELZERO+68
evnt12		equ LEVELZERO+70
evnt13		equ LEVELZERO+72
evnt14		equ LEVELZERO+74
evnt15		equ LEVELZERO+76
evnt16		equ LEVELZERO+78
evnt17		equ LEVELZERO+80
evnt18		equ LEVELZERO+82
evnt19		equ LEVELZERO+84
evnt20		equ LEVELZERO+86

; ConectA	equ $			;echo
; VIDEOToRAM7	equ $		;echo
; bankP	equ $				;echo
; bank0	equ $				;echo
; resetecho	equ $			;echo

