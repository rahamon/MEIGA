@echo off

	set "este_dir=%cd%"
	
:: Debug
	:: configuracion inicial
		setlocal enabledelayedexpansion
		set "model="

	:: VERSION MEIGA de PRODUCCION
		call AGDTiledMod\VersionMeiga
		echo MEIGA version %version_meiga% 2026
		
	:: Check Updates para AGD
		call UpdateAGD %version_meiga%
		if %instalando% == 1 (
			echo ejecutando Instalador
			exit
			)
	
	:: Obtiene datos de seleccion de archivo
		call seleccion
		if "%project_name%" == "" exit

	:: Chequea Actualizaciones para Proyecto, despues de seleccion
		rem necesita %project_name%
		call UpdateProject

	:: Copiar seleccion.txt
		cd /d "%meiga_dir%"
		copy seleccion.bat "%project_dir%" >nul
		
		cd /d "%project_dir%"
		call TestAGD.bat generame
		
	:: Copiar resultado final en Realase
		cd /d "%project_dir%"
			if exist "Resultado.txt" copy "Resultado.txt" "Realase\informe.txt"
		
	GOTO:EOF
	EXIT