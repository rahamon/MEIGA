; Routines definitions reloaded 2024

		include "Unplugged.asm"

; Header o cabecera para proposito general
TAPEMODE	equ 0
		
			jp initPlayer		;org+0 player start point
			jp StageInstaller	;org+3
			jp UserScreen		;org+6
; IM2 PLayer and FX Player
			include "128kAYEngine.asm"

; reserva memoria para Bank memory en el juego para panic
; kas			equ 8			; modifica este valor si te sales del límite de memoria
; Longitud	equ 1024*kas	; (1024*kas) bytes a reservar en juego para intercambiar
; Level0Add   equ $			; Dirección de volcado

		; defs Longitud,10		; escribe todos estos ceros
; endLevel0
		; defs 4,0



	   
; MASKAGD RUTINAS
	IF MASKAGD = 1
			include "SistemaSpritesAgd_bucle_estable.asm"
	ENDIF

	IF MASKAGD = 1
			include "DobleBuffer_auxiliares.asm"
	ENDIF

; VARIABLES MOTOR
	IF ULABUFFER = 1
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
	ENDIF

; PUNTEROS
	IF ULABUFFER = 1
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
	ENDIF
