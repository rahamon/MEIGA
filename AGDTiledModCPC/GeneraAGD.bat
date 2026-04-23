@echo off
		
	:: configuracion inicial
		setlocal enabledelayedexpansion
		
	:: Obtiene el directorio actual
		set "current_dir=%cd%"
		
	:: Leer las tres líneas del archivo
		if exist seleccion.txt (
			set /a i=0
			for /f "usebackq delims=" %%a in ("seleccion.txt") do (
				set /a i+=1
				rem Elimina espacios iniciales y finales de cada línea
				for /f "tokens=* delims=" %%b in ("%%a") do (
					if !i! == 1 set "archivo=%%b"
					if !i! == 2 (
						set "world_dir=%%b"
						set "project_dir=!world_dir:/=\!"
					)
					if !i! == 3 (
						set "nombre=%%b"
						set "project_name=%%~nb"
					)
					if !i! == 4 set "meiga_dir=%%b"
				)
			)
			rem del seleccion.txt
		)

		if "%nombre%" == "" exit
		if not "%current_dir%" == "%project_dir%" exit

	
	:: Load TiledAGDMod
		call :LoadMod
				
	:: Cascada Tiled XML to AGD
		:: DEFINEWINDOW
		:: DEFINECONTROLS
			if not exist ENVIROMENT.tmx copy DEFAULTENVIROMENT.tmx ENVIROMENT.tmx
			python DefineEnviroment.py ENVIROMENT.tmx
		:: MAP
			python DefineMap.py MAP.world ENVIROMENT.tmx
		:: Crea DEFINEPALETTE.agd
			rem if not exist DEFINEPALETTE.agd copy DEFAULTPALETE.agd DEFINEPALETTE.agd
			if not exist paleta_rgb_por_atributo.json goto skip
			python DefinePalette.py paleta_rgb_por_atributo.json
		:: DEFINEBLOCK
			python DefineBlock.py Blocks.tsx DEFINEBLOCKS.agd paleta_rgb_por_atributo.json
		:: DEFINESPRITE
			Python DefineSprites.py
		:: DEFINESCREEN
			python DefineScreen.py MAP.world MPAGDClass.json DEFINESCREEN.agd
		:: DEFINEOBJECT
			Python DefineObjects.py Objects.tsx Objects.png DEFINEOBJECT.agd
		:: DEFINEFONT
			python DefineFont.py Font.tsx
			
		:: DEFINEMESSAGES
			if not exist DEFINEMESSAGES.agd copy EMPTYMESSAGES.agd DEFINEMESSAGES.agd
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
			if exist *.event (
				REM setlocal enabledelayedexpansion
				set FILES=EVENTPLAYER.event EVENTSPRITETYPE1.event EVENTSPRITETYPE2.event EVENTSPRITETYPE3.event EVENTSPRITETYPE4.event EVENTSPRITETYPE5.event EVENTSPRITETYPE6.event EVENTSPRITETYPE7.event EVENTSPRITETYPE8.event EVENTINITSPRITE.event EVENTMAINLOOP1.event EVENTMAINLOOP2.event EVENTINTROMENU.event EVENTGAMEINIT.event EVENTRESTARTSCREEN.event EVENTFELLTOOFAR.event EVENTKILLPLAYER.event EVENTLOSTGAME.event EVENTCOMPLETEDGAME.event EVENTNEWHIGHSCORE.event EVENTCOLLECTBLOCK.event
				set OUTPUT=DEFINESCRIPTS.agd
				call :Montaje
			) else (
				copy EMPTYCRIPTS.agd DEFINESCRIPTS.agd
			)

	:: Unir agd
		set FILES=ENVIROMENT.agd DEFINEBLOCKS.agd DEFINESPRITE.agd DEFINEOBJECT.agd DEFINESCREEN.agd MAP.agd DEFINEFONT.agd DEFINEPALETTE.agd DEFINEJUMP.agd DEFINEMESSAGES.agd DEFINESCRIPTS.agd
		set OUTPUT=GAME.agd
		call :Montaje
		
:Terminando
	:: limpieza final
		set FILES=ENVIROMENT.agd DEFINEBLOCKS.agd DEFINESPRITE.agd DEFINEOBJECT.agd DEFINESCREEN.agd MAP.agd DEFINEFONT.agd DEFINEPALETTE.agd DEFINEJUMP.agd MESSAGEEVENTGAME.agd DEFINESCRIPTS.agd DEFAULTENVIROMENT.tmx DEFAULTPALETE.agd DefineObjects.py DefineScreen.py DefineSprites.py EMPTYMESSAGES.agd EMPTYCRIPTS.agd DEFINEMESSAGES.agd DefineEnviroment.py DefineMap.py MPAGDClass.json DefineFont.py validation_status.json DefinePalette.py DefineBlock.py

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist "%%F" (
				del "%%F"
			) else (
				echo Archivo no encontrado: %%F
			)
		)

	:: Test
		call TestAGD

	:: reset configuracion
		endlocal

	GOTO:EOF
	EXIT

:Montaje
	echo Uniendo archivos en orden...
	rem Eliminar archivo final si ya existe
	if exist "%OUTPUT%" del "%OUTPUT%"

	rem Recorrer archivos y unirlos
	for %%F in (%FILES%) do (
		if exist "%%F" (
			rem echo Agregando: %%F
			type "%%F" >> "%OUTPUT%"
			echo+ >> "%OUTPUT%"
		) else (
			echo Archivo no encontrado: %%F
		)
	)

	echo+
	echo Proceso completado. Archivo creado: %OUTPUT%
	GOTO:EOF
	
:LoadMod
	:: desde meiga
		cd %meiga_dir%
		
	:: Mueve estos archivos
		set FILES=DEFAULTENVIROMENT.tmx DEFAULTPALETE.agd DefineObjects.py DefineScreen.py DefineSprites.py EMPTYMESSAGES.agd EMPTYCRIPTS.agd DefineEnviroment.py DefineMap.py MPAGDClass.json DefineFont.py validation_status.json DefinePalette.py DefineBlock.py

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist TiledAGDMod\"%%F" (
				copy TiledAGDMod\%%F %project_dir%\%%F
			) else (
				echo Archivo no encontrado: TiledAGDMod\%%F
			)
		)
		
	:: regresa
		cd %project_dir%
		
	GOTO:EOF

	
	