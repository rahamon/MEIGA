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

; Mas desde 
FlipBuffers			equ $
PrepareVideoWrite   equ $
PrepareVideoWrite   equ $
PrepareSpriteRead   equ $
PrepareSpriteRead   equ $
FinishVideoWrite	equ $
FinishVideoWrite    equ $

; lo que vamos a medir
		include "CommonData.asm"
		include "Engine0.asm"

