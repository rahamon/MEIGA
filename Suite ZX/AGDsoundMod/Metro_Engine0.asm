; EngineZX 6411 aproximadamente.
; Engine0 6416	aproximadamente
; AGD	6844	aproximadamente

; descomentar si quieres medir EngineZX
; plsnd	equ $
; rbloc	equ $
; ibloc	equ $
; DEBUG	equ $


; etiquetas para medir Engine0
eop			equ $
StageUpdate	equ $
;playkey	equ $
ptcusr		equ $
;cassette	equ $
TapeNamePointer	equ $
FixScreen	equ $
fxsnd	equ $

; mas etiquetas
		include "Unplugged.asm"
		include "Mapa_Engine0.asm"
	
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

bankP	equ $				;echo
ConectA	equ $			;echo
VIDEOToRAM7	equ $		;echo
bank0	equ $				;echo
resetecho	equ $			;echo
waitIRQ	equ $			;echo
		

; El propio Engine0 que queremos medir
		include "Engine0.asm"
		
; En el caso de querer medir EngineZX
		;include "EngineZX.asm"