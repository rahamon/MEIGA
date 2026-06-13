
		org 24832
Offset	equ $
; Cabecera Precargas
		include "Header.asm"
		;jp start

; Map Pointers Stage PLayer
; USER Reload Routiner
USERReloadRoutine equ $
StageInstaller
		include "LPlayer.asm"
UserScrRoutines
		include "ScreenPlayer.asm"
; Prevision para cargador de niveles (org $d800) origen d000 a e800 para definir siempre las mismas direcciones
		;org $d800
		
		;org (Offset + LONGPLAYER + 9)
; ZEROStageData
SlotsDataCode	equ $
		org (SlotsDataCode)
orgSlotDataCode	equ $
		include "SlotOrgs.asm"
		include "Slots.asm"

; ZEROCommonData
COMMONDataCode	equ $
		include "CommonData.asm"
; Game engine code --------------------------------------------------------------
GameEngineCode	equ $		 
		include "Engine0.asm"

;Sound48kBeeperMod

; pie de engine code + adventure mode + debugger?
; ADVENTURE	equ 1

		; IF ADVENTURE = 1
			; include "Adventureblocks.asm"
		; ELSE
			; include "foot.asm"
		; ENDIF

; desplazamiento
		include "trailer.asm"
;eop    equ $
FinDeTransmision	equ $

