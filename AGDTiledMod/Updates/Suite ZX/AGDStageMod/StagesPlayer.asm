; Selecciona Stage
; AGD Stageinclude.asm included in (player) to select Stage module to de played
; Codigo en editor AGD:
; let A = n
; Call UserMod + 3
;
STAGES		equ 49152
Levelbank	equ 6
ZERObank	equ 2
RoomBank	equ 1
BlockBank	equ 3		; MODO shadowSCR A

			;call InitZEROBank
;AGD Stagesselector.asm

			; CHECK Comando FixStartPosition
			ld a,(vara)
			cp 32
			jp z,ResetMapStartPo
			cp 33
			jp z,FixScreen
			cp 34
			jp z,SetFixedDe
			
; LastStage Pattern
			ld hl,lastStage
			ld a,(vara)
			cp (hl)
			jp nz,NewStage	; is NOT the same stage -> Load new Stage
			
			ret			; revisar!
		
; Fix screens in this Stage from OffSetDesplazamiento. Solo para screens, no debería estar aqui*** Deberia estar en AGDScript,
;Obtiene scno-FixedDe
FixScreen
			ld hl,FixedDe
			ld a,(scno)
			sub (hl)				; Resta B a la screen numero para fijar las nuevas screens
			ld (scno),a
			
			; TEST
			;ld hl,roomtb
			;ld a,(hl)
			;ld (varn),a
			;call droom
			
			ret

SetFixedDe
			ld a,(varb)
			ld (FixedDe),a			; store B (ofset desplazamiento scno)
			ret
			
ResetMapStartPo
			xor a
			ld (FixedPo),a
			ret		
FixStartPos			
	; Mod
			ld a,(FixedPo)
			and a
			ret nz			; si a <> 0 -> return
		; Fix start position in MAP
			ld hl,(mapst+1)
			ld a,(hl)
			ld (roomtb),a
		; TEST
			;ld (vars),a
			
			ld a,1
			ld (FixedPo),a
			ret
			
NewStage		
			ld (lastStage),a			; last selected screen is this now.
		; resetea para Levelbank por defecto
			ld a,Levelbank
			ld (Lbank),a
			;call FixScreen
			
			ld a,(vara)
		
;SelectStage:		
		include "Stagesselector.asm" ; Colocar aquí lastStage = ZERO
									; olocar tambien ret

;*** Programa a parte ***
;AGD Stages.asm included in (player) to setup Stage module selected
; por cada seccione en Stage\Selected
		include "Stages.asm"

;AGD Setupections.asm in Player to setup section selected ***
	;Por cada seccion en Stages
	; compila y mide
		include "Setupsections.asm"

;Secplayerroutines.asm to be included
SetupStage
debug jr debug
		push hl
		push bc
		
		ld e,6
		ld d,0
		add hl,de
		ld b,Levelbank
		call bankb	
		ld a,(hl)	
		ld e,a		
		call bank0
		ld a,e

		pop bc
		pop hl
		
		; selecciona destino segun tipo de datos
		cp 1
		jp z,setupSpr
		cp 2
		jp z,setupScr
		cp 3
		jp z,setupBlk
		cp 4
		jp z,setupMsg
		cp 5
		jp z,setupEne
		cp 6
		jp z,setupObj
		cp 7
		jp z,setupEve
		
		; ld a,255
		; ld (vara),a
		ret			; error

dataOrg	defw STAGES
dataLon	defw 0	
dataDes	defw 0
FixedPo defb 0		; fijado nuevo mapa flag
FixedDe	defb 0		; Desplazamiento fijado para cálculo de scno
		
;DESTINO seguntipo de datos
setupSpr
		ld de,SprDataCode
		call SetupStagedata
		call UpdateSprites
		ret
setupScr
		ld de,ScrDataCode
		; ld (dataOrg),hl
		; ld (dataLon),bc
		; ld (dataDes),de	
		call SetupStagedata
		call UpdateScreens
		ret
setupBlk
		ld de,BlkDataCode
		call SetupStagedata
		call UpdateBlocks
		ret
setupMsg
		ld de,MsgDataCode
		call SetupStagedata
		call UpdeteMensajes
		ret
setupEne
		ld de,EneDataCode
		call SetupStagedata
		call UpdeteSpritespositions
		ret
setupMap
		ld de,MapDataCode
		call SetupStagedata
		call UpdeteWolrdMap
		call FixStartPos
		ret
setupObj
		ld de,ObjDataCode
		call SetupStagedata
		call UpdeteObjetsRooms
		ret

setupEve
		ld de,EveDataCode
		call SetupStagedata
		call UpdateEvents
		ret

SetupStagedata
		ld a,(Lbank)
		;cp ZERObank
		;jp z,ldZero
		call UnzipB	
		ld a,Levelbank		; resetea para Levelbank por defecto
swLevel	ld (Lbank),a
		ret		
ldZero	;call UnzipB
		;ld a,ZERObank		; continuando en Level ZERO para Pointers
		;jr swLevel
	
updatepointers
		; imitar patron 48k	
		;call StageUpdate

		;call redraw									;***test control FROM scripts
		
		;ld hl,restfl        ; restart screen flag.		***test control FROM scripts
		;ld (hl),2           ; set it.					***test control FROM scripts

		; si viene de LevelZERO entonces incluye evnt12 en la ecuación
		; esto esta incluido en WriteStageZERO
			;call evnt12
		
		; test seccion de evnetos
		
		ret					; update and exit
		
		; include "SECsizes.asm"
		;include "ZEROBankInstaller.asm"
