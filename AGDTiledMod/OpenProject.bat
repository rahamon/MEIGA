@echo off

	cd /d "%cd%"

	:: configuracion inicial
		setlocal enabledelayedexpansion
		set "model="
		set "version_extraida="
		
	:: VERSION MEIGA de PRODUCCION
		rem set "version_meiga=8"
		call AGDTiledMod\VersionMeiga
		echo MEIGA version %version_meiga% 2026
		
	:: Load Script form
		if exist AGDTiledMod\seleccionar_archivo.py copy AGDTiledMod\seleccionar_archivo.py seleccionar_archivo.py >nul

	:: Ejecutar el script Python
		python seleccionar_archivo.py tiled >nul

	:: Limpieza final
		if exist seleccionar_archivo.py del seleccionar_archivo.py

	:: obtener datos de seleccion
		call seleccion
		
		if "%project_name%" == "" exit

	:: Check Updates para AGD
		call UpdateAGD %version_meiga%
		if %instalando% == 1 (
			echo ejecutando Instalador
			exit
			)
		
	:: Chequea Updates para el Poryecto
		call UpdateProject
		
:Terminado
	:: Copiar seleccion.txt
		cd /d "%meiga_dir%"
		copy seleccion.bat "%project_dir%" >nul

	:: Check OpenProject Command ("") o OpenProject-GeneraAGD Compiler Command ("genera")
		set "opcion=%1"
		if "%opcion%" == "" (
			:: Abre Proyecto
				cd /d "%project_dir%"
				start "MEIGA" "%project_name%.tiled-project"
		) else (
			if "%opcion%" == "genera" (
				echo Generando proyecto
				cd /d "%project_dir%"
				rem start "MEIGA COMPILADOR" cmd /c GeneraAGD.bat
				call GeneraAGD.bat
			)
		)
		
	:: reset configuracion
		endlocal
		
	GOTO:EOF
	EXIT

	
