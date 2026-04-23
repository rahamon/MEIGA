@echo off

	:: Configuracion
		setlocal enabledelayedexpansion
		set PLANTILLA=default-GAME.agd

	:: rem limpieza inicial creation
		if exist creation.bat del creation.bat	
				
	:: Load Script forms
		if exist TiledAGDMod\crear_proyecto.py copy TiledAGDMod\crear_proyecto.py crear_proyecto.py >nul
	
	python crear_proyecto.py %PLANTILLA%

	:: Obtiene variables de creacion
		call creation

		if "%project_name%" == "" (
			if exist crear_proyecto.py del crear_proyecto.py
			if exist default-GAME.agd del default-GAME.agd	
			if exist creation.bat del creation.bat	
			exit
			)

	:: Limpieza
		if exist crear_proyecto.py del crear_proyecto.py
		if exist default-GAME.agd del default-GAME.agd

	:: Replica en seleccion.txt
		copy creation.bat seleccion.bat >nul
		
	:: Crear Proyecto Tiled
		call ExtractAGD new

	:: reset configuracion
		endlocal
	
	
		