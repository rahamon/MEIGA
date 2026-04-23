@echo off

rem Create World of Stages
	rem ;AGD Stages Cabecera
		echo ;World									>> Stages.asm

	rem Por cada Stage Generada en Stages
		set /a indice=0
		for %%f in ("..\Stages\Stage_*.asm") do (
			type "%%f"								>> Stages.asm
			echo ; update world						>> Stages.asm
			echo 		jp updatepointers			>> Stages.asm
		)
		call :writeStageSelector
		
	goto:eof

:writeStageSelector
	rem ;AGD Stage selector Cabecera
		echo ;AGD Stagesselector.asm				>> Stagesselector.asm
		echo Stageselector							>> Stagesselector.asm
		echo 		ld a,(vara)						>> Stagesselector.asm

	rem Por cada Stage seleccionada
		for %%a in ("..\Stages\Stage_*.asm") do (
			set archivo=%%a
			set nombre_archivo=%%~nxa
			rem nombre sin extension
			set nombre=%%~na
			set size=%%~za
			call :writeSelection
		)
		
	rem Pie
		echo 		ret					>> Stagesselector.asm
		echo lastStage defb 0					>> Stagesselector.asm
		
	goto:eof


:writeSelection
	set /a indice+=1
	rem ;AGD Stage Selector
		echo 		cp %indice%						>> Stagesselector.asm
		echo 		jp z,%nombre%					>> Stagesselector.asm
		rem echo+									>> Stagesselector.asm
	goto:eof

