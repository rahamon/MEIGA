:: MEIGA 2025 por Ramón Fernández Ameijeiras
	rem UserPliginSelector
	rem InFront Plugin setup sample plugin

		if "%1"=="" (
			echo.
			echo ERROR:
			echo Este script no debe ejecutarse manualmente.
			pause
			exit /b 1
		)

		set USelector=%1

	rem si esta activado el PluginMod... o lo que es lo mismo, UserSelector:
		if %USelector% == 1 (
			if exist ..\..\UserRoutines\PluginUserSelector.asm copy ..\..\UserRoutines\PluginUserSelector.asm ..\assembly\		>nul
			Tools\fart AGDsoundMod\EngineZX.asm "PluginMod" "		include \"PluginUserSelector.asm\""		>nul
			Tools\fart ..\user.asm "user" "user0"		>nul
			) else (
				Tools\fart AGDsoundMod\EngineZX.asm "		include \"PluginUserSelector.asm\"" "PluginMod"		>nul
			)

		REM IMPLEMENTAR por cada rutina en user rutinas crear una entrada 
		
	GOTO:EOF
		  
