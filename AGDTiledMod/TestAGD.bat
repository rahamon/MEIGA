@echo off
	:: Check parametro vacio
		if "%1"=="" (
			echo.
			echo ERROR:
			echo Este script no debe ejecutarse manualmente
			pause
			exit /b 1
		)
		
	:: Chequea Comando Generar AGD
		if "%1"=="generame" (
			:: Este Archivo AGD
				set "juego=GAME"
		) else (
			set "juego=%~1"
			goto EjecutaTestAGD
		)
		
	:: configuracion inicial
		setlocal enabledelayedexpansion
		
	:: Obtiene el directorio actual
		set "current_dir=%cd%"
		
	:: Leer las variables de seleccion
		call seleccion

		if "%project_name%" == "" exit
		if not "%current_dir%" == "%project_dir%" exit

	:: Load TiledAGDMod
		call :LoadMod >nul
				
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
			rem python defineblock.py Blocks.tsx DEFINEBLOCKS.agd
			rem use: python defineblock_ulaplus.py Blocks.tsx DEFINEBLOCKS.agd opciones: --palette=ulaplus --palette=zx
			rem python defineblock_ulaplus.py Blocks.tsx DEFINEBLOCKS.agd --palette=zx
			python DefineBlock.py Blocks.tsx DEFINEBLOCKS.agd paleta_rgb_por_atributo.json
			if exist DEFINEBLOCKS.agd copy DEFINEBLOCKS.agd DEFINEBLOCKS_last.agd
			
		:: DEFINESPRITE
			Python DefineSprites.py
		:: DEFINESCREEN
			python DefineScreen.py MAP.world MPAGDClass.json DEFINESCREEN.agd
		:: DEFINEOBJECT
			Python DefineObjects.py Objects.tsx Objects.png DEFINEOBJECT.agd paleta_rgb_por_atributo.json
			if exist DEFINEOBJECT.agd copy DEFINEOBJECT.agd DEFINEOBJECT_last.agd
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
		set FILES=ENVIROMENT.agd DEFINEBLOCKS.agd DEFINESPRITE.agd DEFINEOBJECT.agd DEFINESCREEN.agd MAP.agd DEFINEFONT.agd DEFINEPALETTE.agd DEFINEJUMP.agd MESSAGEEVENTGAME.agd DEFINESCRIPTS.agd DEFAULTENVIROMENT.tmx DEFAULTPALETE.agd DefineObjects.py DefineScreen.py DefineSprites.py EMPTYMESSAGES.agd EMPTYCRIPTS.agd DefineEnviroment.py DefineMap.py MPAGDClass.json DefineFont.py validation_status.json DefinePalette.py DefineBlock.py paleta_rgb_por_atributo.json

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist "%%F" (
				del "%%F"
			) else (
				echo Archivo no encontrado: %%F
			)
		)

:EjecutaTestAGD
	:: Test
		if exist Resultado.txt del Resultado.txt
		
		call :TestMEIGA "%juego%" 2> "%project_dir%\log.txt"
		rem call TestAGD > "%project_dir%\log.txt" 2>&1
		rem start "COMPILADOR ZX" cmd /c TestAGD.bat GAME 2> "%project_dir%\log.txt"
		
		cd "%project_dir%"
		if not exist ParserLog.py (
			cd /d "%meiga_dir%"		
			copy TiledAGDMod\ParserLog.py "%project_dir%\ParserLog.py"
			echo copy TiledAGDMod\ParserLog.py "%project_dir%\ParserLog.py"
		)

		cd "%project_dir%"
		python ParserLog.py
		
		if exist Resultado.txt notepad Resultado.txt
				
	:: Limpieza Resto
		if exist ParserLog.py del ParserLog.py
		
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
		cd /d "%meiga_dir%"
		
	:: Mueve estos archivos
		set FILES=DEFAULTENVIROMENT.tmx DEFAULTPALETE.agd DefineObjects.py DefineScreen.py DefineSprites.py EMPTYMESSAGES.agd EMPTYCRIPTS.agd DefineEnviroment.py DefineMap.py MPAGDClass.json paleta_rgb_por_atributo.json DefineFont.py validation_status.json DefinePalette.py DefineBlock.py ParserLog.py

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist "TiledAGDMod\%%F" (
				copy TiledAGDMod\%%F "%project_dir%\%%F" >nul
			) else (
				echo Archivo no encontrado: TiledAGDMod\%%F
			)
		)
		
	:: regresa
		cd /d "%project_dir%"
		
	GOTO:EOF

:TestMEIGA
	:: Este directorio
		set "current_dir=%cd%"
		set "juego=%~1"

	:: Crear rutina de usuario User0 en user-temp.asm
		rem Limpieza Inicial
			if exist user-temp.asm del user-temp.asm
			
			echo user0 >> user-temp.asm
			if exist "%project_name%.asm" (
				type "%project_name%.asm" >> user-temp.asm
			) else if exist user.asm (
				type user.asm >> user-temp.asm
				) else if not exist user.asm (
					echo ret >> user-temp.asm
					)
			
	:: Test
		if exist "%juego%.agd" (
			cd /d "%meiga_dir%"
			rem Setup Inicial
				if exist "UserRoutines\user.asm" del "UserRoutines\user.asm"
				copy /Y "%current_dir%\%juego%.agd" "Suite ZX\AGDsource\deleteme.agd"
				copy /Y "%current_dir%\user-temp.asm" "user.asm"
				if exist "%current_dir%\user-temp.asm" del "%current_dir%\user-temp.asm"
				if exist "%current_dir%\*.asm" copy /Y "%current_dir%\*.asm" "UserRoutines\" >nul

			:: ReloadZX Opciones de Sonido y Levels
				cd /d "%meiga_dir%"
				rem instalacion de opciones
				if exist "AGDTiledMod\TmxEnviromentToBat.py" (
					rem limpieza inicial
						if exist Enviroment.bat del Enviroment.bat
					copy "AGDTiledMod\TmxEnviromentToBat.py" "%project_dir%"
					cd /d "%project_dir%"
					Python TmxEnviromentToBat.py
					if exist Enviroment.bat copy Enviroment.bat "%meiga_dir%\Suite ZX"
					if exist TmxEnviromentToBat.py del TmxEnviromentToBat.py
					)
					
			:: ReloadZX Opciones de Plugins
				cd /d "%meiga_dir%"
				rem instalacion de opciones
				if exist "AGDTiledMod\TmxUnpluggedToAsm.py" (
					rem limpieza inicial
						if exist Unplugged.asm del Unplugged.asm
					copy "AGDTiledMod\TmxUnpluggedToAsm.py" "%project_dir%"
					cd /d "%project_dir%"
					python TmxUnpluggedToAsm.py ENVIROMENT.tmx Unplugged.asm
					if exist Unplugged.asm copy Unplugged.asm "%meiga_dir%\Suite ZX"
					if exist TmxUnpluggedToAsm.py del TmxUnpluggedToAsm.py
					)
					
			cd /d "%meiga_dir%"
			cd "Suite ZX"
			:: Traer fuentes de sonido, pantallas, Escenarios
				call :Copiador
			
			REM Build deleteme
			Build "%juego%"

			cd /d "%meiga_dir%"
			
			:: Recoger Realizacion
				call :Conseguidor		
				
			cd /d "%meiga_dir%"

			:: Mensaje
				powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Fin de Compilado. Revisa el resultado.','Aviso',0,'Warning')"
			)

	GOTO:EOF

:Copiador
	:: Sound a MEIGA\Suite ZX\Sound debemos estar en meiga_dir
		rem Limpiezas en Suite ZX
			if exist "Sound\Tune_*.asm" del "Sound\Tune_*.asm" >nul
			if exist "Sound\fx.asm" del "Sound\fx.asm" >nul
			if exist "Sound\*.pt3" del "Sound\*.pt3" >nul
			if exist "Sound\sfxBank.afb" del "Sound\sfxBank.afb" >nul
			if exist "Sound\AK*.asm" del "Sound\AK*.asm" >nul
		rem Copias desde proyecto
			if exist "%project_dir%\Sound\Tune_*.asm" copy "%project_dir%\Sound\Tune_*.asm" "Sound" >nul
			if exist "%project_dir%\Sound\fx.asm" copy "%project_dir%\Sound\fx.asm" "Sound" >nul
			if exist "%project_dir%\Sound\*.pt3" copy "%project_dir%\Sound\*.pt3" "Sound" >nul
			if exist "%project_dir%\Sound\sfxBank.afb" copy "%project_dir%\Sound\sfxBank.afb" "Sound" >nul
			if exist "%project_dir%\Sound\AK*.asm" copy "%project_dir%\Sound\AK*.asm" "Sound" >nul

	:: Screens
		rem Limpiezas en Suite ZX
			if exist "Screens\*.scr" del "Screens\*.scr" >nul
		rem Copias desde proyecto
			if exist "%project_dir%\Screens\*.scr" copy "%project_dir%\Screens\*.scr" "Screens" >nul

	:: Stages
		rem Limpiezas en Suite ZX
			if exist "Stages\Stage_*.asm" del "Stages\Stage_*.asm" >nul
			if exist "Stages\SEC_*.asm" del "Stages\SEC_*.asm" >nul
			if exist "Stages\Common\SEC_*.asm" del "Stages\Common\SEC_*.asm" >nul
			if exist "Stages\Bank\SEC_*.asm" del "Stages\Bank\SEC_*.asm"
		rem Copias desde proyecto
			if exist "%project_dir%\Stages\Stage_*.asm" copy "%project_dir%\Stages\Stage_*.asm" "%project_dir%\Stages\Backup\Stage_*.asm" >nul
			if exist "%project_dir%\Stages\SEC_*.asm" copy "%project_dir%\Stages\SEC_*.asm" "%project_dir%\Stages\Backup\SEC_*.asm" >nul
			if exist "%project_dir%\Stages\Stage_*.asm" copy "%project_dir%\Stages\Stage_*.asm" "Stages" >nul
			if exist "%project_dir%\Stages\SEC_*.asm" copy "%project_dir%\Stages\SEC_*.asm" "Stages" >nul
	:: Realase
		rem nada que hacer
	
	GOTO:EOF
	
:Conseguidor
	:: Recoger Realase
		cd "Suite ZX"
		rem Copias desde MEIGA
			if exist "Realase\screenhelp.txt" copy "Realase\screenhelp.txt" "%project_dir%\Realase\ListaPantallas.txt" >nul
			if exist "Realase\SelectTunes.txt" copy "Realase\SelectTunes.txt" "%project_dir%\Realase\ListaMusica.txt" >nul
			if exist "Realase\StagesBank.txt" copy "Realase\StagesBank.txt" "%project_dir%\Realase\ListaEscenarios.txt" >nul
			if exist "Realase\deleteme.txt.asm" copy "Realase\deleteme.txt.asm" "%project_dir%\Realase\ListadoCompilado.asm" >nul
			if exist "Realase\%juego%*.tap" copy "Realase\%juego%*.tap" "%project_dir%\Realase\%juego%*.tap" >nul
	GOTO:EOF
	
:Guardador

	GOTO:EOF


