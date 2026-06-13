@echo off
rem Edita un Escenario con las secciones incluidas en Stages\Selected
:writeStage
	set/A indice=0
	rem echo writeStage %1

rem MODELO D: Sin ZERO
	if "%1" == "ZERO" goto writeStagefin
	
rem MODELO A: Crea un Banco ZERO en un Chip de memoria PRIVADO, con TODO. DEPRECATED
	if "%1" == "ZERO" goto writeStageZero

rem MODELO B: Crea un Banco BASE como los demas Stages
	rem contiene los Datos de la primera carga desde cinta.
	rem Es un Stage con SOLO los que tienen mas Versiones en otras Stages
	if "%1" == "ZERO" goto writeStageZeroMini

rem MEDELO C: Sin ZERO ni BASE
	if "%1" == "ZERO" goto writeStageBase

	rem ;AGD Stages Cabecera
		echo Stage_%1:								>> Stage_%1.asm

	rem Por cada Seccion seleccionada en Stages/Selected
		for %%a in ("..\Stages\Selected\SEC_*.asm") do (
			set archivo=%%a
			set nombre_archivo=%%~nxa
			rem nombre sin extension
			set nombre=%%~na
			set size=%%~za
			call :writeStageSections %1
		)

	rem Stage Pie
		rem echo 		ret 							>> Stage_%1.asm
	rem guarda en Stages
		copy Stage_%1.asm ..\Stages\		>nul
	rem limpia Stage_%1.asm en AssemblyStages
		if exist Stage_%1.asm del Stage_%1.asm		>nul
		
:writeStagefin
	goto:eof
exit

:writeStageSections
	rem ;AGD Stages
		echo 		call %nombre%						>> Stage_%1.asm
	goto:eof

:writeStageZeroOldVersion
	rem escribe Stage_ZERO.asm
		echo ; Stage ZERO						>> Stage_%1.asm
		echo Stage_ZERO:						>> Stage_%1.asm
		echo 			ld a,ZERObank			>> Stage_%1.asm
		echo 			ld (Lbank),a			>> Stage_%1.asm
		echo 			call SEC_ZERO_Blk		>> Stage_%1.asm
		echo 			call SEC_ZERO_Ene		>> Stage_%1.asm
		echo 			call SEC_ZERO_Scr		>> Stage_%1.asm
		echo 			call SEC_ZERO_Map		>> Stage_%1.asm
		echo 			call SEC_ZERO_Spr		>> Stage_%1.asm
		echo 			call SEC_ZERO_Obj		>> Stage_%1.asm
		echo 			call SEC_ZERO_Msg		>> Stage_%1.asm
		echo 			call SEC_ZERO_Eve		>> Stage_%1.asm
		echo 			ld a,Levelbank			>> Stage_%1.asm
		echo 			ld (Lbank),a			>> Stage_%1.asm
		echo ; Incluye menu Intro cuando cargamos ZERO 		>> Stage_%1.asm
		echo 		;call evnt12 							>> Stage_%1.asm
		REM echo ; update world						>> Stage_%1.asm
		REM echo 			jp updatepointers		>> Stage_%1.asm
		REM echo+							>> Stage_%1.asm
	
	rem guarda en Stages
		copy Stage_%1.asm ..\Stages\		>nul
	goto:eof

:writeStageZero
	rem ;AGD Stages Cabecera
		echo Stage_ZERO:								>> Stage_ZERO.asm
		
	rem Por cada tipoSlot
		for %%t in (Spr Scr Blk Msg Ene Map Obj Eve) do (
			set "tipoSlot=%%t"
			set /a Versiones=0
			rem mide 
				echo 		call SEC_ZERO_!tipoSlot!
				echo 		call SEC_ZERO_!tipoSlot! 	>> Stage_ZERO.asm
			)
			
	rem guarda en Stages
		copy "Stage_ZERO.asm" "..\Stages\"		>nul
	goto:eof
	
:writeStageZeroMini
	rem ;AGD Stages Cabecera
		echo Stage_ZERO:								>> Stage_ZERO.asm
		
	rem Por cada tipoSlot
		for %%t in (Spr Scr Blk Msg Ene Map Obj Eve) do (
			set "tipoSlot=%%t"
			set /a Versiones=0
			rem mide 
				call :CuentaVersiones
				echo Total !tipoSlot! !Versiones!
				if !Versiones! gtr 1 (
					echo 		call SEC_ZERO_!tipoSlot!
					echo 		call SEC_ZERO_!tipoSlot! 	>> Stage_ZERO.asm
				)
			)
			
	rem guarda en Stages
		copy "Stage_ZERO.asm" "..\Stages\"		>nul
	goto:eof

:writeStageBase
	rem ;AGD Stages Cabecera
		echo Stage_BASE:								>> Stage_BASE.asm
		
	rem Por cada tipoSlot
		for %%t in (Spr Scr Blk Msg Ene Map Obj Eve) do (
			set "tipoSlot=%%t"
			set /a Versiones=0
			rem mide 
				call :CuentaVersiones
				echo Total !tipoSlot! !Versiones!
				if !Versiones! gtr 1 (
					echo 		call SEC_BASE_!tipoSlot!
					echo 		call SEC_BASE_!tipoSlot! 	>> Stage_BASE.asm
					copy "..\Stages\SEC_ZERO_!tipoSlot!.asm" "..\Stages\SEC_BASE_!tipoSlot!.asm"
				)
			)
			
	rem guarda en Stages
		copy "Stage_BASE.asm" "..\Stages\"		>nul
	goto:eof

:CuentaVersiones
	rem Por cada seccion compilada de ese tipo cuenta
		for %%a in ("..\Stages\Bank\*%tipoSlot%.asm") do (
			rem
			set /a Versiones+=1
			)

	GOTO:EOF