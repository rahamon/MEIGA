
; Al ejecutar Game()
; cassette.asm
    ;Install pointers of Stage: Todas las secciones: candidato a setupZero!*
				call StageUpdate

    ;---> entonces apaga el cassette
				ld a,255
				ld (playkey),a				; Stop cassette: playkey=FF
				
	; Chequea primera carga
				ld a,(FirstGame)
				cp 1							; ya hemos pasado por esto?
				jp nz,firstg					; nunca habia jugado, es mi primera vez: Primera Carga

				;call FixStartPos
	; FixScreen: Corrige offset screen en la seccion de screens
				ld hl,varb
				ld a,(scno)
				sub (hl)
				ld (scno),a					; SCNO - offset data

	; Fija la posición de Inicio en el mapa si no está fijada
				call FixStartPos
				
	; redibuja, depende de donde coloquemos el código!*
				call redraw
				
	; Regresa al mainloop: debería regresar al mismo punto!	callStack!*
				jp mloop

    firstg		ld a,1
				ld (FirstGame),a
				jp game							; start the First game BASIC mode

    FirstGame	defb 0
    FixedPo		defb 0		; fijado nuevo mapa flag

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
			; test
    			ld (vars),a

    			ld a,1
    			ld (FixedPo),a
    			ret
				
; Lplayer
	;Install pointers
	StageUpdate
				;(Spr Scr Blk Msg Ene Map Obj)
				call UpdateSprites
				call UpdateScreens
				call UpdateBlocks
				call UpdeteMensajes
				call UpdeteSpritespositions
				call UpdeteObjetsRooms
				call UpdeteWolrdMap
		
				ret




; Al ejecutar USER org+3(a:seccion,b:offsetSecc)				
; StageUser48k.asm
; User Routine
		USERReloadRoutine equ $
		StageInstaller
					include "LPlayer.asm"

		;
		;Levelbank	equ 1
		;RoomBank	equ 2
		;ZERObank	equ 3
		;Load Stages User Routines
		Stageload
					include "StageUser48k.asm"

		; StageUser48k
		; load""CODE or back to mloop.
			;check loading cassette
					ld a,(playkey)
					cp 255
					ret nz						; is loading -> Back to
					
		; CHECK Comando ResetMapStartPo
					ld a,(vara)
					cp 32
					jp z,ResetMapStartPo
					
		Tapeselector
					ld hl,lastStage
					ld a,(vara)
					cp (hl)
					;ret z						; is the same Stage -> Back to
					
		; MEIGA 2024 Ramon Fernandez Ameijeiras
					jp nz,NewStage				; is NOT the same stage -> Load new Stage
					
		; is the same stage -> Fix and Back to
		; Fix screens in this Stage from OffSetDesplazamiento
		FixScreen
					ld hl,varb
					ld a,(scno)
					sub (hl)
					ld (scno),a			; SCNO-DESPL
				
				; TEST
					ld hl,roomtb
					ld a,(hl)
					ld (vars),a
					;call droom
					ret					; and -> Back to
					
		NewStage
					ld (lastStage),a			; last selected Stage is this now.
					;call FixScreen
			; CHECK Stage number
					ld a,(vara)
					include "Tapselector.asm"

					cp 1
					jp z,Tape1
					cp 2
					jp z,Tape2
					cp 3
					jp z,Tape3
					cp 4
					jp z,Tape4
					cp 5
					jp z,Tape5
					ret

		; setup nombres de pista en cinta
					include "SetupTaps.asm"

		;setup nombres de pista en cinta
		Tape1
					ld hl,TapFinal
					jp setupStageTape
		Tape2
					ld hl,TapInicio
					jp setupStageTape
		Tape3
					ld hl,TapNudo
					jp setupStageTape
		Tape4
					ld hl,TapPanels
					jp setupStageTape
		Tape5
					ld hl,TapZERO
					jp setupStageTape

		setupStageTape
					ld (TapeNamePointer),hl		; actualiza StagePointer
		playcassete
					ld a,0
					ld (playkey),a				; S = 0 -> "play again"
					
					ret



				
				
; En el juego llama una vez a jp cassete por gameloop
		cassette
					ld a,(playkey)
					cp 255
					jp z,skip						; si S = 255 -> back to
		;<--- cut
		; command: Load ""CODE to BASIC
		loadTape
					ld hl,10072
					exx
					ld bc,(TapeNamePointer)
					ret							; return to BASIC
					
		; Stopped :"Stop the TAPE and Press any key"
		skip
					jp DEBUG					; debug or back to mloop
					
		
				
				
				
				
; Variables				
; Indica si el Escenario tiene varias cargas desde cinta de paginas de datos
		playkey		defb 255					; 0=ready,255=Stop
		TapeNamePointer
					defw TapZERO
		; world
		; Tapename
		names
					include "Taps.asm"
		;World
		TapFinal
					defb 1,"Final0000"
		TapFinal2
					defb 0,"Final2000"
		TapInicio
					defb 1,"Inicio000"
		TapInicio1
					defb 0,"Inicio100"
		TapNudo
					defb 1,"Nudo00000"
		TapNudo2
					defb 0,"Nudo20000"
		TapPanels
					defb 1,"Panels000"
		TapPanels2
					defb 0,"Panels200"
		TapZERO
					defb 0,"ZERO00000"
					
		lastStage	defb 5	; TapZERO by default

