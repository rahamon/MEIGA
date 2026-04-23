@echo off

	cd /d "%cd%"

	:: configuracion inicial
		setlocal enabledelayedexpansion
		set "model="

	:: VERSION MEIGA de PRODUCCION
		rem set "version_meiga=8"
		call AGDTiledMod\VersionMeiga
		echo MEIGA version %version_meiga% 2026

	:: Load proyect form
		call OpenAGD
		
	:: Obtiene datos de seleccion de archivo
		call seleccion

		if "%project_name%" == "" exit
		
		REM echo meiga_dir: %meiga_dir%
		REM echo nombre: %project_name%.agd       
		REM echo project_dir: %project_dir%       
		REM echo project_name: %project_name%
		REM echo world_dir: %world_dir%
		REM pause
		
	:: Check Updates para AGD
		call UpdateAGD %version_meiga%
		if %instalando% == 1 (
			echo ejecutando Instalador
			exit
			)
		
	:: Chequea Actualizaciones para Proyecto, preparar en version 9
		call UpdateProject
		:: mientras forzar acualizacion TestAGD.bat version 9
		rem copy AGDTiledMod\TestAGD.bat "%project_dir%\TestAGD.bat" >nul
	
	:: Test
		:: Load Parser log
			cd /d "%meiga_dir%"
			copy TiledAGDMod\ParserLog.py "%project_dir%\ParserLog.py"
			
		cd /d "%project_dir%"
		if exist Resultado.txt del Resultado.txt

		call TestAGD "%project_name%"

	:: reset configuracion
		endlocal
	
	:: Regresa
		cd /d "%meiga_dir%"

	GOTO:EOF
	EXIT
	