@echo off
	:: MEIGA 2025 por Ramón Fernández Ameijeiras
		REM Uso: manager <nombre_base_sin_extension>

		if "%1"=="" (
			echo.
			echo ERROR:
			echo Este script no debe ejecutarse manualmente.
			pause
			exit /b 1
		)
		rem set "compilacion=%1"
		set "compilacion=deleteme"

	:: In Mode Plugin Experimental
		rem 0 = Disable (recomendado)
		rem 1 = Enable
		set PluginMod=0
		
	:: Adventure Mode Plugin
		rem 0 = Disable (recomendado)
		rem 1 = Enable
		set adventure=0
		
	:: Score records Plugin
		rem 0 = Disable (recomendado)
		rem 1 = Enable
		set records=0
		
	:: Convert Stage Zero Mod
		rem 0 = Disable
		rem 1 = Enable 
		set LevelEnabled=0
		rem set "ConvertMode=ConvertGame"
		rem set "ConvertMode=EditStages"
		set "ConvertMode=EditStages"

	:: Sound Mod
		rem 0 = Standard
		rem 1 = ZX Spectrum 48k Beeper
		rem 2 = ZX Spectrum 128/+2/+3 AY-3-8912 Vortex Tracker II PT3
		rem 3 = ZX Spectrum 128/+2/+3 AY-3-8912 Arkos Traker
		set modsnd=0
		
	:: Screens Bank Mod
		rem six additional screens to download from Memory Banks
		rem 1 = Enable (automatico)

	:: Nombre de tu juego que aparecerá en la carga desde cinta
		rem aqui le pasamos selection basename MEIGA10
		rem set gamename=Test
		set "gamename=%~1"
		rem set "gamename=Paco"

:main
	:: PluginMod tests en desarrollo
		rem call PluginSetup %PluginMod%
		
	:: Variables de compilacion en Enviroment Tiled MEIGA10
		if exist "Enviroment.bat" call Enviroment
		
	:: MEIGA 2025
		ReloadZX %compilacion% %adventure% %LevelEnabled% "%gamename%" %modsnd% %records% %ConvertMode%

	:: Cerrar al finalizar
		GOTO:EOF
		rem exit


	