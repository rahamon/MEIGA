; Metro para medir commonData para Hicks

; etiquetas para incluir
isnd	equ $
silenc	equ $
StageUpdate	equ $
;playkey	equ $
;cassette	equ $
TapeNamePointer	equ $
FixScreen	equ $
fxsnd	equ $
eop	equ $

; mas etiquetas
		include "Mapa_UnCommon.asm"
		
; mas etiquetas: SeletCom User Sound Mod Rutinas
ctrN		equ $
ctrF		equ $
monitor 	equ $
beeper 		equ $
FX_Selector equ $
NoMusic_yesEffects 	equ $
SetLoopOFF 	equ $
AY 			equ $
AYFX 		equ $
playSelected	equ $

;
bankP	equ $				;echo
ConectA	equ $			;echo
VIDEOToRAM7	equ $		;echo
bank0	equ $				;echo
resetecho	equ $			;echo
waitIRQ	equ $			;echo

; lo que vamos a medir
		include "CommonData.asm"
		include "Engine0.asm"

