@echo off
rem Edita un Escenario con las secciones incluidas en Stages\Selected
:writeStage
	set/A indice=0
	rem echo writeStage %1

	if "%1" == "ZERO" goto writeStageZero

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
	goto:eof
exit

:writeStageSections
	rem ;AGD Stages
		echo 		call %nombre%						>> Stage_%1.asm
	goto:eof

:writeStageZero
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
	