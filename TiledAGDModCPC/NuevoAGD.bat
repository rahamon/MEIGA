@echo off

	:: Configuracion
		setlocal enabledelayedexpansion
		set PLANTILLA=default-GAME.agd
		
	:: Obtiene el directorio actual
		set "meiga_dir=%cd%"
				
	:: Load Script forms
		if exist TiledAGDMod\crear_proyecto.py copy TiledAGDMod\crear_proyecto.py crear_proyecto.py
	
	python crear_proyecto.py %PLANTILLA%
	
	:: Leer las tres líneas del archivo
		if exist creation.txt (
			set /a i=0
			for /f "usebackq delims=" %%a in ("creation.txt") do (
				set /a i+=1
				if !i! == 1 set "archivo=%%a"
				if !i! == 2 set "directorio=%%a"
				if !i! == 3 (
					set "nombre=%%a"
					set "projectname=%%~na"
					)
			)
			rem del creation.txt
		)

		if "%nombre%" == "" (
			if exist crear_proyecto.py del crear_proyecto.py
			if exist default-GAME.agd del default-GAME.agd	
			if exist creation.txt del creation.txt	
			exit
			)
			
		echo %meiga_dir:\=/%	>> creation.txt

	:: Limpieza
		if exist crear_proyecto.py del crear_proyecto.py
		if exist default-GAME.agd del default-GAME.agd

	:: Rescribe seleccion.txt
		copy creation.txt seleccion.txt
		
	:: Crear Proyecto Tiled
		call ExtractAGD new

	:: reset configuracion
		endlocal
		