@echo off

	:: configuracion inicial
		setlocal enabledelayedexpansion
		set "model="
		
	:: Check nuevo Proyecto
		set "nombre=%1"
		if "%nombre%" == "" (
			:: Load proyect form
				call OpenAGD
		) else (
			echo Creando nuevo proyecto
			copy creation.txt seleccion.txt
		)
		
	:: Obtiene el directorio actual
		set "meiga_dir=%cd%"
		
	:: Comprobar el directorio termina en /
		REM if "%world_dir:~-1%"=="/" (
			REM set "world_dir=%world_dir:~0,-1%"
		REM )
		
	:: Leer las tres líneas del archivo
		if exist seleccion.txt (
			set /a i=0
			for /f "usebackq delims=" %%a in ("seleccion.txt") do (
				set /a i+=1
				if !i! == 1 set "archivo=%%a"
				if !i! == 2 (
					set "world_dir=%%a"
					set "project_dir=!world_dir:/=\!"							
					)
				if !i! == 3 (
					set "nombre=%%a"
					set "project_name=%%~na"
					)
			)
			rem del seleccion.txt
		)

		if "%nombre%" == "" exit
		
		echo. >> seleccion.txt
		echo %meiga_dir%	>> seleccion.txt	
		
		echo meiga_dir: %meiga_dir%
		echo nombre: %nombre%       
		echo project_dir: %project_dir%       
		echo project_name: %project_name%.agd
		echo world_dir: %world_dir%
			
	:: limpieza inicial
		cd %project_dir%
		
		if exist *.tsx del *.tsx
		if exist *.json del *.json
		if exist *.png del *.png
		if exist SCREEN*.tmx del SCREEN*.tmx
		if exist MAP.world del MAP.world
		if exist *.tiled-project del *.tiled-project
		if exist *.tiled-session del *.tiled-session
		if exist DEFINEPALETTE.agd del DEFINEPALETTE.agd
		if exist DEFINEMESSAGE.agd del DEFINEMESSAGE.agd
		if exist *.event del *.event
		
		cd %meiga_dir%
		
	:: Install Extension Tiled
		xcopy AGDTiledScript "%project_dir%\AGDTiledScript" /I /Y
	
	:: Load AGDTiledMod
		call :LoadMod >nul
		
	:: Copiar seleccion.txt
		copy seleccion.txt "%project_dir%"
		
	:: Copiar Paletas
		xcopy Paletas "%project_dir%\Paletas" /I /Y

	:: Cascada de Extracciones
		cd %project_dir%
		
		:: DEFINEWINDOW
		:: DEFINECONTROLS
			if not exist ENVIROMENT.tmx copy DEFAULTENVIROMENT.tmx ENVIROMENT.tmx
			python Create_Enviroment.py "%nombre%"
		:: MAP
			python Create_world.py "%nombre%"
		
		:: Crea DEFINEPALETTE.agd y extrae la paletaULA+ o la paleta standard (ExtraerPalette.py "%nombre%" --standard)
			python Create_Palette.py "%nombre%" 
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
		pause
	:: Crear Proyecto Tiled
		Copy TiledAGD.Default-Project %project_name%.tiled-project
		
	:: Crear world access en el editor tiled
		echo	{											>> %project_name%.tiled-session
		echo		"activeFile": "SCREEN000.tmx",			>> %project_name%.tiled-session
		echo		"expandedProjectPaths": [				>> %project_name%.tiled-session
		echo			"."									>> %project_name%.tiled-session					
		echo		],										>> %project_name%.tiled-session					
		echo		"fileStates": {							>> %project_name%.tiled-session					
		echo			"Blocks.tsx": {						>> %project_name%.tiled-session					
		echo				"scaleInDock": 2,				>> %project_name%.tiled-session					
		echo				"scaleInEditor": 1				>> %project_name%.tiled-session					
		echo			},									>> %project_name%.tiled-session							
		echo			"ENVIROMENT.tmx": {					>> %project_name%.tiled-session
		echo				"scale": 1,                     >> %project_name%.tiled-session
		echo				"selectedLayer": 3,             >> %project_name%.tiled-session
		echo				"viewCenter": {                 >> %project_name%.tiled-session
		echo					"x": 128,                   >> %project_name%.tiled-session
		echo					"y": 95                     >> %project_name%.tiled-session
		echo				}                               >> %project_name%.tiled-session
		echo			},		                            >> %project_name%.tiled-session
		echo			"Objects.tsx": {					>> %project_name%.tiled-session
		echo				"scaleInDock": 2				>> %project_name%.tiled-session
		echo			},									>> %project_name%.tiled-session
		echo			"SCREEN000.tmx": {					>> %project_name%.tiled-session
		echo				"scale": 2,						>> %project_name%.tiled-session
		echo				"selectedLayer": 0,				>> %project_name%.tiled-session
		echo				"viewCenter": {					>> %project_name%.tiled-session
		echo					"x": 128,                   >> %project_name%.tiled-session
		echo					"y": 88                     >> %project_name%.tiled-session
		echo				}                               >> %project_name%.tiled-session
		echo			},									>> %project_name%.tiled-session
		echo			"Sprites.tsx": {					>> %project_name%.tiled-session
		echo				"scaleInDock": 2,				>> %project_name%.tiled-session
		echo				"scaleInEditor": 1				>> %project_name%.tiled-session
		echo			}									>> %project_name%.tiled-session
		echo		},										>> %project_name%.tiled-session
		echo		"openFiles": [							>> %project_name%.tiled-session
		echo			"ENVIROMENT.tmx",					>> %project_name%.tiled-session
		echo			"SCREEN000.tmx",					>> %project_name%.tiled-session
		echo			"Blocks.tsx"                        >> %project_name%.tiled-session
		echo		],										>> %project_name%.tiled-session
		echo		"last.worldFilePath": "%world_dir%", 	>> %project_name%.tiled-session
		echo		"loadedWorlds": [						>> %project_name%.tiled-session
		echo			"%world_dir%/MAP.world"				>> %project_name%.tiled-session
		echo		],										>> %project_name%.tiled-session
		echo		"project": "%project_name%.tiled-project"	>> %project_name%.tiled-session
		echo	}											>> %project_name%.tiled-session

	:: Limpieza final
		set FILES=Create_Maps.py Create_world.py Create_Font.py Create_Objects.py Create_Sprites.py Create_Blocks.py Create_Palette.py Create_ScriptsMessages.py Create_Enviroment.py seleccionar_archivo.py MPAGDClass.json TiledAGD.Default-Project DEFAULTENVIROMENT.tmx

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist "%%F" (
				del %%F
			) else (
				echo Archivo no encontrado: %%F
			)
		)
		
:Terminado
	:: reset configuracion
		endlocal
	:: regresa a MEIGA
		cd %meiga_dir%
		
	GOTO:EOF
	EXIT

:LoadMod
	:: Mueve estos archivos
		set FILES=Create_Maps.py Create_world.py Create_Font.py Create_Objects.py Create_Sprites.py Create_Blocks.py Create_Palette.py Create_ScriptsMessages.py seleccionar_archivo.py Create_Enviroment.py MPAGDClass.json TiledAGD.Default-Project DEFAULTENVIROMENT.tmx GeneraAGD.bat TestAGD.bat ReordenaBlocks.bat ActualizaPalette.bat Update_Palette.py

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist AGDTiledMod%model%\"%%F" (
				copy AGDTiledMod%model%\%%F "%project_dir%\%%F"  
				echo AGDTiledMod%model%\%%F %project_dir%\%%F  
			) else (
				echo Archivo no encontrado: AGDTiledMod%model%\%%F
			)
		)
		
	GOTO:EOF