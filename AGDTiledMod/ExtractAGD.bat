@echo off

	cd /d "%cd%"

	:: configuracion inicial
		setlocal enabledelayedexpansion
		set "model="
		
	:: VERSION MEIGA de PRODUCCION
		rem set "version_meiga=8"
		call AGDTiledMod\VersionMeiga
		echo MEIGA version %version_meiga% 2026
		
	:: Check ExtractAGD Command ("") o NuevoAGD Command ("new")
		set "nombre=%1"
		if "%nombre%" == "" (
			:: Load proyect form
				call OpenAGD
		) else (
			if "%nombre%" == "new" (
				echo Creando nuevo proyecto
				copy creation.bat seleccion.bat
			)
		)
		
	:: Obtiene datos de seleccion
		call seleccion

		if "%project_name%" == "" exit

	:: Check Updates para AGD
		call UpdateAGD %version_meiga%
		if %instalando% == 1 (
			echo ejecutando Instalador
			exit
			)
		
		set "nombre=%project_name%.agd"    
		
		REM echo meiga_dir: %meiga_dir%
		REM echo nombre: %nombre%      
		REM echo project_dir: %project_dir%       
		REM echo project_name: %project_name%
		REM echo world_dir: %world_dir%
			
	:: limpieza inicial
		cd /d "%project_dir%"
		:: Chequea seguridad para no borrar proyecto antiguo
		if exist "%project_name%.tiled-project" (
			cls
			echo.
			echo Operacion no permitida:
			echo Borrarás el proyecto existente con ese nombre
			echo Guarda una copia de seguridad
			echo O bien, crea el proyecto en otro sitio
			pause
			exit
		)
		
		if exist *.tsx del *.tsx
		if exist *.json del *.json
		if exist *.png del *.png
		if exist *.tmx del *.tmx
		if exist MAP.world del MAP.world
		if exist *.tiled-project del *.tiled-project
		if exist *.tiled-session del *.tiled-session
		if exist DEFINEPALETTE.agd del DEFINEPALETTE.agd
		if exist DEFINEMESSAGE.agd del DEFINEMESSAGE.agd
		if exist GAME.agd del GAME.agd
		if exist *.event del *.event
		if exist Limpiar_proyectoAGD.bat del Limpiar_proyectoAGD.bat
		
		
		cd /d "%meiga_dir%"
		
	:: Install Extension Tiled
		xcopy AGDTiledScript "%project_dir%\AGDTiledScript" /I /Y >nul
	
	:: Load AGDTiledMod
		call :LoadMod >nul
		
	:: Copiar seleccion.txt
		copy seleccion.txt "%project_dir%" >nul
		copy version.txt "%project_dir%" >nul
		
	:: Copiar Paletas
		xcopy AGDTiledMod%model%\Paletas "%project_dir%\Paletas" /I /Y >nul

	:: Cascada de Extracciones
		cd /d "%project_dir%"
		
		:: DEFINEWINDOW
		:: DEFINECONTROLS
			if not exist ENVIROMENT.tmx copy DEFAULTENVIROMENT.tmx ENVIROMENT.tmx
			python Create_Enviroment.py "%nombre%"
		:: MAP
			python Create_world.py "%nombre%"
		
		:: Crea DEFINEPALETTE.agd y extrae la paletaULA+ o la paleta standard (ExtraerPalette.py "%nombre%" --standard)
			python Create_Palette.py "%nombre%" --standard
		:: DEFINEBLOCK
			rem python Create_Blocks.py "%nombre%" Blocks.tsx Blocks.png
			python Create_Blocks.py "%nombre%" Blocks.tsx Blocks.png

		:: DEFINESCREEN
			python Create_Maps.py "%nombre%" MPAGDClass.json
		:: DEFINESPRITE
			python Create_Sprites.py "%nombre%"
		:: DEFINEOBJECT
			python Create_Objects.py "%nombre%"
		:: DEFINEFONT
			python Create_Font.py "%nombre%" Font.tsx Font.png
			
		:: DEFINEMESSAGES
		:: EVENT PLAYER
		:: EVENT SPRITETYPE1
		:: EVENT SPRITETYPE2
		:: EVENT SPRITETYPE3
		:: EVENT SPRITETYPE4
		:: EVENT SPRITETYPE5
		:: EVENT SPRITETYPE6
		:: EVENT SPRITETYPE7
		:: EVENT SPRITETYPE8
		:: EVENT INITSPRITE
		:: EVENT MAINLOOP1
		:: EVENT MAINLOOP2
		:: EVENT INTROMENU
		:: EVENT GAMEINIT
		:: EVENT RESTARTSCREEN
		:: EVENT FELLTOOFAR
		:: EVENT KILLPLAYER
		:: EVENT LOSTGAME
		:: EVENT COMPLETEDGAME
		:: EVENT NEWHIGHSCORE
		:: EVENT COLLECTBLOCK
			python Create_ScriptsMessages.py "%nombre%"
		
	:: Crear Proyecto Tiled
		Copy "TiledAGD.Default-Project" "%project_name%.tiled-project" >nul
	:: Importa nuevo MPAGDClass en Tiled, ya hecho en LoadMod
		REM copy "MPAGDClass_prototipo.json" "%project_dir%\MPAGDClass.json"

		
	:: Crear world access en el editor tiled
		echo	{											>> "%project_name%.tiled-session"
		echo		"activeFile": "SCREEN000.tmx",			>> "%project_name%.tiled-session"
		echo		"expandedProjectPaths": [				>> "%project_name%.tiled-session"
		echo			"."									>> "%project_name%.tiled-session"					
		echo		],										>> "%project_name%.tiled-session"					
		echo		"fileStates": {							>> "%project_name%.tiled-session"					
		echo			"Blocks.tsx": {						>> "%project_name%.tiled-session"					
		echo				"scaleInDock": 2,				>> "%project_name%.tiled-session"					
		echo				"scaleInEditor": 1				>> "%project_name%.tiled-session"					
		echo			},									>> "%project_name%.tiled-session"							
		echo			"ENVIROMENT.tmx": {					>> "%project_name%.tiled-session"
		echo				"scale": 1,                     >> "%project_name%.tiled-session"
		echo				"selectedLayer": 3,             >> "%project_name%.tiled-session"
		echo				"viewCenter": {                 >> "%project_name%.tiled-session"
		echo					"x": 128,                   >> "%project_name%.tiled-session"
		echo					"y": 95                     >> "%project_name%.tiled-session"
		echo				}                               >> "%project_name%.tiled-session"
		echo			},		                            >> "%project_name%.tiled-session"
		echo			"Objects.tsx": {					>> "%project_name%.tiled-session"
		echo				"scaleInDock": 2				>> "%project_name%.tiled-session"
		echo			},									>> "%project_name%.tiled-session"
		echo			"SCREEN000.tmx": {					>> "%project_name%.tiled-session"
		echo				"scale": 2,						>> "%project_name%.tiled-session"
		echo				"selectedLayer": 0,				>> "%project_name%.tiled-session"
		echo				"viewCenter": {					>> "%project_name%.tiled-session"
		echo					"x": 128,                   >> "%project_name%.tiled-session"
		echo					"y": 88                     >> "%project_name%.tiled-session"
		echo				}                               >> "%project_name%.tiled-session"
		echo			},									>> "%project_name%.tiled-session"
		echo			"Sprites.tsx": {					>> "%project_name%.tiled-session"
		echo				"scaleInDock": 2,				>> "%project_name%.tiled-session"
		echo				"scaleInEditor": 1				>> "%project_name%.tiled-session"
		echo			}									>> "%project_name%.tiled-session"
		echo		},										>> "%project_name%.tiled-session"
		echo		"openFiles": [							>> "%project_name%.tiled-session"
		echo			"ENVIROMENT.tmx",					>> "%project_name%.tiled-session"
		echo			"SCREEN000.tmx",					>> "%project_name%.tiled-session"
		echo			"Blocks.tsx"                        >> "%project_name%.tiled-session"
		echo		],										>> "%project_name%.tiled-session"
		echo		"last.worldFilePath": "%world_dir%", 	>> "%project_name%.tiled-session"
		echo		"loadedWorlds": [						>> "%project_name%.tiled-session"
		echo			"%world_dir%/MAP.world"				>> "%project_name%.tiled-session"
		echo		],										>> "%project_name%.tiled-session"
		echo		"project": "%project_name%.tiled-project"	>> "%project_name%.tiled-session"
		echo	}											>> "%project_name%.tiled-session"

	:: Limpieza final
		set FILES=Create_Maps.py Create_world.py Create_Font.py Create_Objects.py Create_Sprites.py Create_Blocks.py Create_Palette.py Create_ScriptsMessages.py Create_Enviroment.py seleccionar_archivo.py MPAGDClass.json TiledAGD.Default-Project DEFAULTENVIROMENT.tmx

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist "%%F" (
				del "%%F"
			) else (
				echo Archivo no encontrado: %%F
			)
		)
		
:Terminado
	
	:: Crea directorios Mods
		cd /d "%project_dir%"
		if not exist "Sound" mkdir Sound
		if not exist "Screens" mkdir Screens
		if not exist "Stages" mkdir Stages
		if not exist "Realase" mkdir Realase

	:: Abre Proyecto
		start "MEIGA" "%project_name%.tiled-project"
		
	:: regresa a MEIGA
		cd /d "%meiga_dir%"
		
	:: reset configuracion
		endlocal
		
	EXIT
	GOTO:EOF

:LoadMod
	:: Mueve estos archivos
		set FILES=Create_Maps.py Create_world.py Create_Font.py Create_Objects.py Create_Sprites.py Create_Blocks.py Create_Palette.py Create_ScriptsMessages.py seleccionar_archivo.py Create_Enviroment.py MPAGDClass.json TiledAGD.Default-Project DEFAULTENVIROMENT.tmx GeneraAGD.bat TestAGD.bat ReordenaBlocks.bat ActualizaPalette.bat ActualizaMeiga.bat

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist "AGDTiledMod%model%\%%F" (
				copy "AGDTiledMod%model%\%%F" "%project_dir%\%%F" >nul  
				echo "AGDTiledMod%model%\%%F" "%project_dir%\%%F"
			) else (
				echo Archivo no encontrado: AGDTiledMod%model%\%%F
			)
		)
		
	GOTO:EOF