@echo OFF
	REM MEIGA 2025 por Ramón Fernández Ameijeiras
	REM Uso: ReloadZX <compilacion> <adventure> <LevelEnabled> <gamename> <modsnd> <records> <ConvertMode>

	if "%7"=="" (
		echo.
		echo ERROR: ReloadZX
		echo Este script no debe ejecutarse manualmente.
		pause
		exit /b 1
	)
	
cls
	set compilacion=%1
	set adventure=%2
	set LevelEnabled=%3
	set "gamename=%~4"
	set "gamename=%gamename:"=%"
	set modsnd=%5
	set mscore=%6
	set "ConvertMode=%7"

	echo compilacion:	%1
	echo adventure:		%2
	echo LevelEnabled:	%3
	echo "gamename:		%~4"
	echo "gamename:		%gamename:"=%"
	echo modsnd:		%5
	echo mscore:		%6
	echo "ConvertMode:	%7"


rem Limpieza de Realase desde Dominio AGD
	if exist Realase\*.txt del /q Realase\*.txt
	if exist Realase\*.asm del /q Realase\*.asm
	if exist Realase\*.tap del /q Realase\*.tap

rem standard packaging en Dominio AGD
	if %mscore% == 1 (
		if %LevelEnabled% == 1 (
			echo+
			echo 	The Scores and Capacity screen is not integrated
			echo of levels at the same time. I'm sorry. Choose other options.
			goto error
			)
		)
	if %modsnd% == 0 (
		echo Standard Mod 2024 by Ramon Fernandez Ameijeiras
		rem Compile AGD file
			if exist AGDsource\%1.agd (
				copy AGDsource\%1.agd AGD
				) else (
					echo Compilation AGD file does not exist: error
					echo Export or save a Compilation with the MPAGD editor first
					rem pause
					goto error
					)
			cd AGD
			rem modo adventure 0 recomendado en favor de user Panels
			if %adventure% == 1 (
				..\AGD\CompilerZX %1 -a
			) else (
				..\AGD\CompilerZX %1
			)
		rem copia y limpia Assemble
			copy %1.asm ..\sjasmplus\
			if exist ..\..\UserRoutines\*.asm copy ..\..\UserRoutines\*.asm ..\sjasmplus\		>nul
			copy ..\..\user.asm ..\sjasmplus\
			if exist %1.* del %1.*
			cd ..\sjasmplus
		rem Renombra user0 a user MEIGA 2026
			..\Tools\fart user.asm "user0" "user"
		rem Compila en Dominio sjasmplus
			copy leader.txt+%1.asm+trailer.txt agdcode.asm
			sjasmplus.exe agdcode.asm --sym=%1_map.asm --lst=%1.txt
		rem mueve realase
			move %1.txt ..\Realase\%1.txt.asm
			move %1_map.asm ..\Realase\%1_map_standard.asm
			copy test.tap ..\speccy
		rem limpieza en sjasmplus
			if exist *.asm del *.asm
			if exist test.tap del test.tap
		rem Start emulator
			cd ..\speccy
			speccy test.tap
		rem guarda cinta en Realase
			if exist test.tap copy Test.tap ..\Realase\%gamename%.tap
		rem limpieza en speccy
			if exist test.tap del test.tap
		rem limpieza en Meiga
			if exist "..\..\user.asm" del "..\..\user.asm"
			goto fin
	)
	
rem MEIGA AGD Source agd compilation en Dominio AGDsoundMod
	if %modsnd% gtr 0 (
		rem Compilar AGD file Modificado
			echo MEIGA 2025 escrito por Ramon Fernandez Ameijeiras
			if exist AGDsource\%1.agd (
				copy AGDsource\%1.agd AGDsoundMod		>nul
				) else (
					echo Compilation %1.agd does not exist: error
					echo Export or save a Compilation with the MPAGD editor first
					rem pause
					goto error
					)
		REM En AGDsoundMod 2025 
			cd AGDsoundMod
		
		rem goto SkipParser
		
		rem AGDScriptMod 2025 prepara comandos
			call ..\AGDScriptMod\Scripter %1
			if exist Script.agd (
				copy Script.agd %1.agd
				del Script.agd
				)
				
:SkipParser				
		rem CompilerZX
			if %adventure% == 1 (
				..\AGD\CompilerZX %1 -a
			) else (
				..\AGD\CompilerZX %1
			)
		)

rem text-log del Compilador AGD
	echo+
	if %ERRORLEVEL% neq 0 (
		rem Detener para leer errores
			type msgerror.log
			echo Fin del informe del compilador de SCRIPTS
			goto error
	)

rem limpieza de Assembly
	if exist ..\Assembly\*.* del /q ..\Assembly\*.*
	
:: Stage Mod MEIGA 2025 por Ramon Fernandez Ameijeiras
		if %LevelEnabled% == 0 (
	rem En Dominio AGDsoundMod copia %1.asm hacia Assembly sin mas edicion
				echo Trayendo %1.asm para Assembly
				copy ..\AGDsoundMod\%1.asm ..\Assembly	
		)
		if %LevelEnabled% == 1 (
	rem En Dominio AssemblyStage procede a la edicion
			rem limpieza de AssemblyStage
				if exist ..\AssemblyStage\*.* del /q ..\AssemblyStage\*.*	>nul
			rem En Dominio AssemblyStage Actualizar Assemble game
				cd ..\AssemblyStage
			rem carga fuentes
				copy ..\AGDsoundMod\%1.asm ..\AssemblyStage\	>nul
				copy ..\AGDStageMod\*.* ..\AssemblyStage\	>nul
			rem Construye Stages. Candidato a implementar volumenes en 128k ConvertGame se salta el menu
				call make %modsnd% %ConvertMode%
			rem trae Stage Realase to assembly todo menos %1.asm
				del %1.asm		>nul
				copy ..\AssemblyStage\*.asm ..\Assembly\		>nul
				copy ..\AssemblyStage\*.zx7 ..\Assembly\		>nul
				copy ..\AssemblyStage\VT.tap ..\Assembly\		>nul
			rem Candidato a convertir carrier en Head-body-game aqui
			rem Trnsforma %1.asm para carrier.asm 
				copy ..\AssemblyStage\carrier.asm ..\Assembly\%1.asm		>nul
			rem guarda documentacion en Realase
				copy ..\AssemblyStage\*.txt ..\Realase		>nul
			rem limpieza final
				if exist ..\AssemblyStage\*.* del /q ..\AssemblyStage\*.*	>nul		
		)
		
rem desde Dominios AGDsoundMod o AssemblyStage copia User y UserRoutines hacia Assembly
	if exist ..\..\UserRoutines\*.asm copy ..\..\UserRoutines\*.asm ..\Assembly\		>nul
	copy ..\..\user.asm ..\Assembly\		>nul

rem mover a dominio Assembly
	cd ..\Assembly
	echo en Assembly
	
rem Trae Unplugged.asm para ahorro de memoria
rem Idea IMPLEMENTAR patron variables multicarga aqui
rem Idea IMPLEMENTAR parametros MEIGA manager aqui
	if exist ..\AGDsoundMod\Unplugged.asm copy ..\AGDsoundMod\Unplugged.asm ..\Assembly\		>nul
	if exist ..\Unplugged.asm copy ..\Unplugged.asm ..\Assembly\		>nul

rem editar macro ZEROMOD para activar FixScreen y navegar entre Niveles o Stages del mapa
	if %LevelEnabled% == 0 (
		echo ZEROMOD	equ 0 >> Unplugged.asm
	)
	if %LevelEnabled% == 1 (
		echo ZEROMOD	equ 1 >> Unplugged.asm
	)

:: Actualizar Stages en Proyecto si ConvertMode = ""
	rem Trae Stages desde Proyecto
		if not %ConvertMode% == "ConvertGame" (
			rem Leer las variables de seleccion
				call ..\..\seleccion
			rem Actualiza proyecto
				if not "%project_dir%" == "" (
					if exist "..\Stages\Stage_*.asm" copy "..\Stages\Stage_*.asm" "%project_dir%\Stages" > nul
					if exist "..\Stages\SEC_*.asm" copy "..\Stages\SEC_*.asm" "%project_dir%\Stages" > nul
					rem ZERO no es necesario en proyecto
						if exist "%project_dir%\Stages\SEC_ZERO_*.asm" del "%project_dir%\Stages\SEC_ZERO_*.asm" > nul
				)
		)
	rem ... Version 9
			
:: Sound Mod MEIGA 2025 por Ramon Fernandez Ameijeiras

	rem Actualizar fuentes
		if %modsnd% == 1 (
			rem ZX Spectrum 48k Beeper
			rem actualizar fuenter para Beeper
				copy ..\AGDsoundMod\Beeper\*.* ..\Assembly		>nul
				if exist ..\sound\Tune_*.asm copy ..\sound\Tune_*.asm ..\Assembly		>nul
				if exist ..\sound\fx.asm copy ..\sound\fx.asm ..\Assembly		>nul
				call archivosizer
		) else (
			rem ZX Spectrum 128/+2/+3 AY-3-8912 Vortex Tracker II
			if %modsnd% == 2 (
				rem Actualizar fuentes a través de MAGDmusicizer para VT
					copy ..\AGDsoundMod\AY\MAGDmusicizer\asm ..\assembly\	>nul
					echo+
					echo Loading sound sources
					if not exist ..\Sound\sfxBank.afb (
						rem echo empty sfxBank
						rem copy ..\AGDsoundMod\AY\MAGDmusicizer\asm\mocs\sfxBank.afb ..\assembly\
					) else (
						rem echo full sfxBank
						copy ..\Sound\sfxBank.afb ..\assembly\		>nul
					)
					if not exist "..\Sound\*.pt3" (
						rem echo empty pt3 music
						copy ..\AGDsoundMod\AY\MAGDmusicizer\asm\mocs\musicempty.pt3 ..\assembly\		>nul
					) else (
						rem echo full pt3 music
						copy "..\Sound\*.pt3" ..\assembly\		>nul
						set /a musicsize=0
						for %%m in ( "..\assembly\*.pt3" ) do (
							set sizem=%%~zm
							call :checkmemo
							)
					)
				rem editar codigo	
					call archivosizer
				rem separar las dos llamadas call (no se soporta)
				rem Comprime musicas
					call MCompresor
				rem limpiar
				) else (
					rem ZX Spectrum 128/+2/+3 AY-3-8912 Arkos Traker
					if %modsnd% == 3 (
						rem Actualizar fuentes para Arkos Traker 2
							copy ..\AGDsoundMod\AY\Arkos\*.asm ..\assembly		>nul
							if not exist ..\Sound\AK*.asm (
								echo CAREFUL! You don't have compiled music: "SOUND n>1 will break the game"
								pause
								exit
							) else (
								copy ..\sound\AK*.asm ..\assembly		>nul
							)
						)
				)
			)
			
	rem construir Cargadores
		if %mscore% == 0 (
			rem ZX Spectrum 48k Beeper
			if %modsnd% LEQ 1 (
				if %LevelEnabled% == 1 (
					copy ..\Basic\LoadStage.bas ..\assembly\		>nul
					..\Tools\bas2tap -e -a1 -s%gamename% LoadStage.bas loader.tap
					..\Tools\fart Engine0.asm "jp gamelp" "		include \"cassette.asm\""		>nul
					..\Tools\fart Engine0.asm ";include \"cassettePlay.asm\"" "include \"cassettePlay.asm\""		>nul
					..\Tools\fart Engine0.asm "ld bc,score         ; return pointing to score." "ld bc,(TapeNamePointer)         ; return pointing to TapNames."		>nul
				) else (
					echo+
					echo Minimalist Standard Loader
					copy ..\Basic\loader.bas ..\Assembly\		>nul
					..\Tools\bas2tap -e -a1 -s%gamename% loader.bas loader.tap
				)
			) else (
				if %LevelEnabled% == 1 (
				rem Candidato a convertir carrier en Head-body-game aqui 
					rem ..\Tools\fart Engine0.asm "jp gamelp" "		include \"chipBASE.asm\""		>nul
					echo+		>nul
					echo DataWorld Loader
					copy ..\Basic\loader128kdataZ.bas ..\assembly\		>nul
					..\Tools\bas2tap -e -a1 -s%gamename% loader128kdataZ.bas loader.tap
				) else (
					echo+
					echo Standard AY-3-8912 Loader
					copy ..\Basic\loader128k.bas ..\assembly\		>nul
					..\Tools\bas2tap -e -a1 -s%gamename% loader128k.bas loader.tap
				REM copy ..\Basic\loader128k*.bas ..\assembly\ ***
				REM ..\Tools\bas2tap -e -a1 -s%gamename% loader128kdata.bas loader.tap ***			
				)		
			)
		)
		if %mscore% == 1 (
			rem ZX Spectrum 48k Beeper
			if %modsnd% LEQ 1 (
				echo+
				echo Loader with Score
				copy ..\Basic\marcadores48k.bas ..\assembly\		>nul
				..\Tools\bas2tap -e -a1 -s%gamename% marcadores48k.bas loader.tap
			) else (
				echo+
				echo AY-3-8912 Loader with Score 
				copy ..\Basic\marcadores128k.bas ..\assembly\		>nul
				..\Tools\bas2tap -e -a1 -s%gamename% marcadores128k.bas loader.tap
			)
			..\Tools\fart %1.asm 24832 32000		>nul
			..\Tools\fart %1.asm "jp gamelp " "jp game"		>nul
		)

rem Medir Engine y CommonData del mundo
	if %LevelEnabled% == 1 (
		setlocal enabledelayedexpansion
		Rem Midiendo Peso del Engine
			echo Midiendo Peso del Engine
			rem copy ..\AGDsoundMod\Unplugged.asm ..\Assembly\
			copy ..\AGDsoundMod\Metro_Engine0.asm ..\assembly\
			copy ..\AGDsoundMod\Mapa_Engine0.asm ..\assembly\
			..\tools\Pasmo --bin Metro_Engine0.asm Metro_Engine0.bin
			for %%a in ( "Metro_Engine0.bin" ) do (
				set EngineSize=%%~za
				echo+	>> ..\Realase\StagesBank.txt
				echo Size of the Engine !EngineSize!				>> ..\Realase\StagesBank.txt
				)
		Rem Peso de CommonData Scripts y enviroment
			echo Midiendo Peso de CommonData Scripts y enviroment
			copy ..\AGDsoundMod\Metro_CommonData.asm ..\assembly\
			copy ..\AGDsoundMod\Mapa_UnCommon.asm ..\assembly\
			..\tools\Pasmo --bin Metro_CommonData.asm Metro_CommonData.bin
			for %%a in ( "Metro_CommonData.bin" ) do (
				set CommonSize=%%~za
				echo+	>> ..\Realase\StagesBank.txt
				)
		set /a SizeDifference=!CommonSize!-!EngineSize!
		echo Size of the Scripts y enviroment !SizeDifference!		>> ..\Realase\StagesBank.txt
		endlocal
	)
	
	
rem medir Player Sound
	rem ZX Spectrum 48k Beeper
	if %modsnd% == 1 (
		..\tools\Pasmo --tap Metro.asm Metro.tap
		for %%a in ( "Metro.tap" ) do set size128kAYEngine=%%~za
	) else (
		rem ZX Spectrum 128/+2/+3 AY-3-8912 Vortex Tracker II
		echo Midiendo ZX Spectrum 128/+2/+3 AY-3-8912 Vortex Tracker II
		if %modsnd% == 2 (
			..\tools\Pasmo --tap Metro.asm Metro.tap
			for %%a in ( "Metro.tap" ) do set size128kAYEngine=%%~za
		) else (
			rem ZX Spectrum 128/+2/+3 AY-3-8912 Arkos Traker
			if %modsnd% == 3 (
			..\tools\Pasmo --tap Metro.asm Metro.tap
			rem echo y con rasm
			rem ..\tools\rasm Metro.asm -o Metro
			for %%a in ( "Metro.tap" ) do set size128kAYEngine=%%~za
			)
		)
	)
	
	rem informar longitud Player en archivo Stages.txt
		echo+	>> ..\Realase\StagesBank.txt
		echo Size of the Sound Engine included %size128kAYEngine%		>> ..\Realase\StagesBank.txt

rem modificaciones de código
	rem Hack gravity. Si se activa los sprites asociados se mueven a la par, si no se persiguen asincronicamente MEIGA 2024
		REM set hackgravity=0
		REM echo Hack gravity enabled
		echo Hack gravity disabled
		REM ..\tools\fart %1.asm "jp grav" "ret"		>nul
	rem ZX Spectrum 48k Beeper
	if %modsnd% == 1 (
		..\tools\fart %1.asm "jp start" "include \"headerLoff.asm\""		>nul
		rem editar %1.asm
		..\tools\fart %1.asm "Sound48kBeeperMod" "		include \"48k.asm\""		>nul
		..\tools\fart %1.asm "vsync5 call plsnd" "vsync5 call plsnd48"		>nul
		rem editar fx.asm
			..\tools\fart fx.asm "org " ";org "		>nul
			
		rem crear un carrier para 48k
		if %LevelEnabled% == 1 (
			..\tools\fart %1.asm "jp start" "include \"header.asm\""		>nul
			rem echo ..\tools\fart Engine0.asm "vsync5 call plsnd" "vsync5 call plsnd48"
			..\tools\fart Engine0.asm "vsync5 call plsnd" "vsync5 call plsnd48"		>nul
			rem ..\tools\fart %1.asm "LONGPLAYER" "%size128kAYEngine%"
			..\tools\fart %1.asm "LONGPLAYER" "0"		>nul
			..\tools\fart %1.asm "include \"ScreenPlayer.asm\"" ";include \"ScreenPlayer.asm\""		>nul
			rem call :ResetLONGPLAYER		
			)
		rem patch aventure mode
		if %adventure% == 1 (
			copy ..\AGDsoundMod\Adventurepatch.asm ..\Assembly\		>nul
			..\tools\fart %1.asm "wbloc  ld hl,(pbptr)" "		include \"Adventurepatch.asm\""	>nul
		)
	)
	rem ZX Spectrum 128/+2/+3 AY-3-8912 Vortex Tracker II
	if %modsnd% == 2 (
		copy ..\AGDscreenMod\ScreenPlayer.asm ..\Assembly\		>nul
		rem ..\tools\fart %1.asm "jp start" "include \"128kAYEngine.asm\""
		rem ..\tools\fart %1.asm "vsync5 call plsnd" "vsync5 call PlayFxsnd"		>nul
		..\tools\fart %1.asm "LONGPLAYER" "%size128kAYEngine%"		>nul
		rem call :SetLONGPLAYER
		if %LevelEnabled% == 1 (
			..\tools\fart %1.asm "jp start" "include \"header.asm\""		>nul
			..\tools\fart LPlayer.asm "include \"StageUser48k.asm\"" "include \"StagesPlayer.asm\""		>nul
			) else (
				..\tools\fart %1.asm "jp start" "include \"headerLoff.asm\""		>nul
				..\tools\fart %1.asm "include \"LPlayer.asm\"" ";include \"LPlayer.asm\""		>nul
				)
		..\tools\fart %1.asm "eop    equ $" "	   include \"trailer.asm\""		>nul
		if %adventure% == 1 (
			..\tools\fart trailer.asm ";defs 256,0" "defs 256,0"	>nul
		)
		rem patch aventure mode
		if %adventure% == 1 (
			copy ..\AGDsoundMod\Adventurepatch.asm ..\Assembly\	>nul
			..\tools\fart %1.asm "wbloc  ld hl,(pbptr)" "		include \"Adventurepatch.asm\""	>nul
			..\tools\fart Engine0.asm "wbloc  ld hl,(pbptr)" "		include \"Adventurepatch.asm\""	>nul
		)		
		if %mscore% == 1 (
			..\tools\fart bank4driver.asm 24832 32000		>nul
		)

	)
	rem ZX Spectrum 128/+2/+3 AY-3-8912 Arkos Traker
	if %modsnd% == 3 (
		copy ..\AGDscreenMod\ScreenPlayer.asm ..\Assembly\				
		if %LevelEnabled% == 1 (
			..\tools\fart %1.asm "jp start" "include \"header.asm\""		>nul
			..\tools\fart LPlayer.asm "include \"StageUser48k.asm\"" "include \"StagesPlayer.asm\""		>nul
			) else (
				..\tools\fart %1.asm "jp start" "include \"headerLoff.asm\""		>nul
				..\tools\fart %1.asm "include \"LPlayer.asm\"" ";include \"LPlayer.asm\""				>nul
				)
		..\tools\fart %1.asm "jp start" "include \"128k.asm\""		>nul
		..\tools\fart %1.asm "LONGPLAYER" "%size128kAYEngine%"		>nul
		rem call :SetLONGPLAYER
		rem ..\tools\fart %1.asm "jp start" "include \"header.asm\""
		..\tools\fart %1.asm "eop    equ $" "	   include \"trailer.asm\""		>nul
		if %adventure% == 1 (
			..\tools\fart trailer.asm ";defs 256,0" "defs 256,0"	>nul
		)
		rem patch aventure mode
		if %adventure% == 1 (
			copy ..\AGDsoundMod\Adventurepatch.asm ..\Assembly\		>nul
			..\tools\fart %1.asm "wbloc  ld hl,(pbptr)" "		include \"Adventurepatch.asm\""	>nul
			..\tools\fart Engine0.asm "wbloc  ld hl,(pbptr)" "		include \"Adventurepatch.asm\""	>nul
		)
		if %mscore% == 1 (
			..\tools\fart bank4driver.asm 24832 32000		>nul
		)
	)

rem Screens Mod MEIGA 2025 por Ramon Fernandez Ameijeiras
	rem Compilar Screens
		echo Screen Mod MEIGA 2024 por Ramon Fernandez Ameijeiras
		copy ..\AGDscreenMod\screener.bat ..\Screens\		>nul
		cd ..\Screens

		call screener %mscore% %modsnd%
		copy *.tap ..\assembly\		>nul
		copy ScreenSelector.asm ..\assembly\		>nul
		copy swappingS.asm ..\assembly\		>nul
		rem limpieza
			if exist *.zx7 del *.zx7		>nul
			if exist *.asm del *.asm		>nul
			if exist *.tap del *.tap		>nul
			if exist *.bat del *.bat		>nul
		cd ..\Assembly
	
rem Compilar

	if %modsnd% == 1 (	
		echo Compilando: ZX Spectrum 48k Beeper
		..\tools\Pasmo.exe --tap --name AG %1.asm AG.tap
		rem debuging
		call :printlist %1
	) else (
		rem ZX Spectrum 128/+2/+3 AY-3-8912 Vortex Tracker II
		if %modsnd% == 2 (
			echo+
			echo Compilation ZX Spectrum 128/+2/+3 AY-3-8912 Vortex Tracker II
			..\tools\rasm FX4BANK.asm -o FX4BANK
			call :printlist FX4BANK
			..\tools\zx7 FX4BANK.bin
			echo+
			echo Compiling Music...
			..\tools\Pasmo.exe --tap --name MUD bank4driver.asm MUD.tap
			rem debuging
			rem call :printlist bank4driver
			echo+
			echo Compiling Game...
			..\tools\Pasmo.exe --tap --name AG %1.asm AG.tap
			rem debuging
			call :printlist %1
		) else (
			rem ZX Spectrum 128/+2/+3 AY-3-8912 Arkos Traker
			if %modsnd% == 3 (
				echo+
				echo Compilation ZX Spectrum 128/+2/+3 AY-3-8912 Arkos Traker
				..\tools\rasm PLAY4BANK.asm -o PLAY4BANK
				..\tools\zx7 PLAY4BANK.bin
				rem ..\tools\rasm %1.asm -o source
				rem ..\tools\bin2tap source.bin -o AG.tap
				..\tools\Pasmo.exe --tap --name AG %1.asm AG.tap
				..\tools\Pasmo.exe --tap --name MUD bank4driver.asm MUD.tap
				rem debuging
				rem call :printlist bank4driver
				rem ..\tools\rasm bank4driver.asm -o mpack
				rem ..\tools\bin2tap mpack.bin -o MUD.tap
				echo+
				echo Compiling Game...
				rem debuging
				call :printlist %1
			)
		)
	)

	rem text-log del Compilador
		echo+
		if %ERRORLEVEL% neq 0 (
			rem Detener para leer errores
				type msgerror.log
				echo Fin del informe del Compilador
				pause
				goto error
		)

:ModificarPointersEventos
	rem Modificar pointers de secciones eventos y arcade para escribir Symbol_Eve.asm
		if %LevelEnabled% == 1 (
			call :printSymbol %1
			:: volver a compilar eventos con las nuevas etiquetas 128k
				rem ReCompila SEC_ZERO_Eve
					rem prepara Symbol.asm
						if exist SEC_ZERO_Eve.bin.zx7 del SEC_ZERO_Eve.bin.zx7
						rem if exist SEC_ZERO_Eve.bin del SEC_ZERO_Eve.bin
						..\Tools\fart SEC_ZERO_Eve.asm ";include \"Symbol.asm\"" "include \"Symbol_Eve.asm\""		>nul
						..\SjasmPlus\sjasmplus --lst=SEC_ZERO_Eve.txt --raw=SEC_ZERO_Eve.bin SEC_ZERO_Eve.asm
						..\tools\zx7 SEC_ZERO_Eve.bin		>nul
					rem test debug
						call :printlist SEC_ZERO_Eve
					rem restaura Symbol.asm en Eventos
						..\Tools\fart SEC*Eve.asm "include \"Symbol_Eve.asm\"" ";include \"Symbol.asm\""		>nul
						
			:: volver a compilar eventos con las nuevas etiquetas 48k
				rem Compila TODO Data in Bank, bin para 48k y para el 128k los zx7
					for %%a in ( "SEC*Eve.asm" ) do (
						REM echo %%~na
						rem ReCompila SEC_*_Eve
						rem prepara Symbol.asm
							if exist %%~na.bin.zx7 del %%~na.bin.zx7
							echo if exist %%~na.bin del %%~na.bin
							..\Tools\fart %%~na.asm ";include \"Symbol.asm\"" "include \"Symbol_Eve.asm\""		>nul
							..\SjasmPlus\sjasmplus --lst=%%~na.txt --raw=%%~na.bin %%~na.asm
							..\tools\zx7 %%~na.bin		>nul
						rem test debug
							call :printlist %%~na
						rem restaura Symbol.asm en Eventos
							..\Tools\fart %%~na.asm "include \"Symbol_Eve.asm\"" ";include \"Symbol.asm\""		>nul
						)
						
			rem Segunda pasada 48k ahora
				echo EveVolumer Pass2
			rem limpieza inicial
				if exist VT.tap del VT.tap
			rem prepara Symbol.asm
				..\Tools\fart SEC*Eve.asm ";include \"Symbol.asm\"" "include \"Symbol_Eve_48k.asm\""		>nul
				setlocal EnableDelayedExpansion
				for %%a in ( "Tap*.asm" ) do (
					set "Tapename=%%~na000000"
					if /I not "%%~nxa"=="Taps.asm" if /I not "%%~nxa"=="Tapselector.asm" (
						echo !Tapename! y !Tapename:~3,9!
						..\Tools\Pasmo --tap --name !Tapename:~3,9! %%~nxa !Tapename:~3,9!.tap
						rem debugg task
							rem ..\SjasmPlus\sjasmplus.exe %%~nxa --lst=!Tapename:~3,9!.txt
							rem move !Tapename:~3,9!.txt ..\Realase\
					)
				)
			rem restaura Symbol.asm en Eventos
				..\Tools\fart SEC*Eve.asm "include \"Symbol_Eve_48k.asm\"" ";include \"Symbol.asm\""		>nul
			rem Construye CARA B
				rem move *.tap ..\AssemblyStage\		>nul
				for %%a in ( "*00.tap" ) do (
					type "%%a" >> VT.tap
					rem echo %%a
					)
			)
		
	rem Datos en Banco propósito general (Stages) (esta parte antes estaba en la linea 404)
		if %modsnd% gtr 1 (
			if %LevelEnabled% == 1 (
				echo+
				echo Compiling Stages...
				..\tools\Pasmo.exe --tap --name Data bankLdriver.asm DAT.tap
				..\tools\Pasmo.exe --tap --name ZERO bankZdriver.asm ZERO.tap
				rem debuging
				rem call :printlist bankLdriver
				rem call :printlist bankZdriver
				)
			)
	
rem inspeccionar error en Assembler: VERSION 2
	for /f "tokens=2" %%e in (..\Realase\%1.txt.asm) do (
		if "%%e"=="error:" (
			echo+
			echo Check out CompilerZX's early bug reports
			rem echo Revisa el archivo Realase\%1.txt.asm
			
			rem error de position player
				for /f "tokens=6" %%e in (..\Realase\%1.txt.asm) do (
					if "%%e"=="nmedat" (
						echo+
						echo You must define one player respawn position in screen0
						echo Check out Screens positions in your preyect to fix the compilation.
						rem echo Revisa el archivo Realase\%1.txt.asm
						rem goto error
						)
					)
			rem goto error
			)
		)
		
	for /f "tokens=8" %%e in (..\Realase\%1.txt.asm) do (
		if "%%e"=="16bit" (
			echo+
			echo Memory addres or longitude exceded.
			echo Check out Stages Compilation for low performance early bug reports
			rem echo Revisa el archivo Realase\%1.txt.asm
			goto error
			)
		)

	Rem Peso del Game
		rem pause
		..\tools\Pasmo.exe --bin %1.asm Metro_%1.bin
		for %%a in ( "Metro_%1.bin" ) do (
		rem echo Size of the Engine %%~za
		echo+			>> ..\Realase\StagesBank.txt
		echo Size of the Game %%~za			>> ..\Realase\StagesBank.txt
		if %%~za gtr 39200 (
			echo+
			echo Es demasiado para la Integridad del juego		>> ..\Realase\StagesBank.txt
			echo La Compilacion no es posible por encima de 39k aproximadamente.		>> ..\Realase\StagesBank.txt
			echo Size of the Game %%~za es demasiado para la Integridad del juego
			echo La Compilacion no es posible por encima de 39k aproximadamente.
			goto error
			)
		)
		echo metro Engine
		rem pause

	rem Pie de Informe
		echo Nota*: La suma de estas mediciones:		>> ..\Realase\StagesBank.txt
		echo 	ZERO Bank, Engine, CommonData y Sound Engine no deben superar 48k :)		>> ..\Realase\StagesBank.txt
		echo+		>> ..\Realase\StagesBank.txt
		echo Informe generado por MEIGA 2025 by Ramon Fernandez Ameijeiras		>> ..\Realase\StagesBank.txt

rem montaje
	if %modsnd% leq 1 (
		if %LevelEnabled% == 1 (
			copy /b loader.tap + SC.tap + AG.tap + VT.tap %gamename%.tap		>nul
		) else (
			copy /b loader.tap + SC.tap + AG.tap %gamename%.tap		>nul
		)
	) else (
		if %LevelEnabled% == 1 (
			rem copy /b loader.tap + SCB.tap + MUD.tap + DAT.tap + AG.tap %gamename%128.tap		>nul
			copy /b loader.tap + SCB.tap + MUD.tap + DAT.tap + ZERO.tap + AG.tap %gamename%128.tap		>nul
		) else (
			copy /b loader.tap + SCB.tap + MUD.tap + AG.tap %gamename%128.tap		>nul
		)
	)

rem save realase
	copy %gamename%*.tap ..\Realase\		>nul

rem Start emulator
	if %modsnd% LEQ 1 (
		start "GoGo" "..\speccy\speccy" "..\Realase\%gamename%.tap"
		rem ..\speccy\speccy ..\Realase\%gamename%.tap
	) else (
		start "GoGo" "..\speccy\speccy.exe" -128 "..\Realase\%gamename%128.tap"
		rem ..\speccy\speccy -128 ..\Realase\%gamename%128.tap
	)
	timeout /t 2 >nul
	
rem limpieza en Meiga
	del ..\..\user.asm
rem limpieza en assembly
	del /q *.*
rem limpieza en SuiteZX
	if exist ..\Unplugged.asm del ..\Unplugged.asm >nul
	if exist ..\Enviroment.bat del ..\Enviroment.bat >nul

:fin
	echo end of program.
	GOTO:EOF
	
:error
	echo+
	echo ha ocurrido un ERROR
	pause
	goto fin
	
:printlist
	copy %1.asm ..\sjasmplus\		>nul
	copy ..\..\user.asm ..\sjasmplus\		>nul
	if exist ..\..\UserRoutines\*.asm copy ..\..\UserRoutines\*.asm ..\sjasmplus\		>nul
	..\SjasmPlus\sjasmplus.exe %1.asm --lst=list.txt
	move list.txt ..\Realase\%1.txt.asm		>nul
	GOTO:EOF
	
:printSymbol
	copy %1.asm ..\sjasmplus\		>nul
	copy ..\..\user.asm ..\sjasmplus\		>nul
	if exist ..\..\UserRoutines\*.asm copy ..\..\UserRoutines\*.asm ..\sjasmplus\		>nul
	rem secciona Symbol_Eve.asm para eliminar symbolos antes de Start pointer. En orden --lstlab=sort 
	..\SjasmPlus\sjasmplus.exe %1.asm --sym=Symbol_Eve_all.asm
	copy Symbol_Eve_all.asm ..\Realase\Symbol_Eve_all.asm
	rem ordenar primero por direccion de memoria
		setlocal enabledelayedexpansion

		rem Archivo de entrada
		set "input=Symbol_Eve_all.asm"
		set "output=Symbol_Eve_temp.asm"

		rem Crear un archivo temporal con los valores reordenados
		(for /f "tokens=1,2,3 delims=: " %%A in (%input%) do (
			rem Removemos "0x" para evitar problemas con sort
			set "hex=%%C"
			set "hex=!hex:0x=!"
			echo !hex!:%%A:%%B:%%C
		)) > temp.txt

		rem Ordenar numéricamente y reconstruir el formato original
		(for /f "tokens=1,2,3,4 delims=:" %%A in ('sort temp.txt') do (
			echo %%B %%C %%D
		)) > %output%

		rem Eliminar archivo temporal
		del temp.txt
		rem Archivo ordenado guardado en %output% Correcto 2025

	rem separando Symbolos del Engine... font EQU -> IJUMPA
		set fListadoCorte=Symbol_Eve_temp.asm
		rem extraer
			rem  "tokens=*" "delims=·"
			set fichero=
			for /f "delims=." %%x in (%fListadoCorte%) do (
				set "line=%%x"
				if "!line:~0,6!"=="font E" (
					set "fichero=located"
					)
				if not "!line:~0,6!"=="IJUMPA" (
					if "!fichero!"=="located" (
						echo !line! >> Symbol_Eve_Engine.asm
						)
					) else ( goto cortado1 )
				)
: cortado1
	rem separando EveDataCode Symbol
		set fListadoCorte=Symbol_Eve_temp.asm
		rem extraer
			rem  "tokens=*" "delims=·"
			set fichero=
			for /f "delims=." %%x in (%fListadoCorte%) do (
				set "line=%%x"
				if "!line:~0,11!"=="EveDataCode" (
					set "fichero=located"
					)
				if not "!line:~0,19!"=="longofdata_ZERO_Eve" (
					if "!fichero!"=="located" (
						echo !line! >> Symbol_Eve_Defs_org.asm
						)
					) else ( goto cortado2 )
				)
: cortado2
	rem separando Symbolos de variables... TAPEMODE -> longofdata_ZERO_Spr
		set fListadoCorte=Symbol_Eve_temp.asm
		rem extraer
			rem  "tokens=*" "delims=·"
			set fichero=
			for /f "delims=." %%x in (%fListadoCorte%) do (
				set "line=%%x"
				if "!line:~0,8!"=="TAPEMODE" (
					set "fichero=located"
					)
				if not "!line:~0,19!"=="longofdata_ZERO_Spr" (
					if "!fichero!"=="located" (
						echo !line! >> Symbol_Eve_Defs.asm
						)
					) else ( goto cortado3 )
				)				
: cortado3
	rem separando chgfx Symbol...
		set fListadoCorte=Symbol_Eve_temp.asm
		rem extraer
			rem  "tokens=*" "delims=·"
			set fichero=
			for /f "delims=." %%x in (%fListadoCorte%) do (
				set "line=%%x"
				if "!line:~0,9!"=="chgfx EQU" (
					set "fichero=located"
					)
				if not "!line:~0,8!"=="bcol EQU" (
					if "!fichero!"=="located" (
						echo !line! >> Symbol_Eve_Defs_chgfx.asm
						)
					) else ( goto cortado4 )
				)				
: cortado4
	REM rem separando chgfx Symbol...
		REM set fListadoCorte=Symbol_Eve_temp.asm
		REM rem extraer
			REM rem  "tokens=*" "delims=·"
			REM set fichero=
			REM for /f "delims=." %%x in (%fListadoCorte%) do (
				REM set "line=%%x"
				REM if "!line:~0,5!"=="loopa" (
					REM set "fichero=located"
					REM )
				REM if not "!line:~0,6!"=="Offset" (
					REM if "!fichero!"=="located" (
						REM echo !line! >> Symbol_Eve_Defs_48k.asm
						REM )
					REM ) else ( goto cortado5 )
				REM )				
REM : cortado5
	rem prepara variables tambien para 48k
		if exist Symbol_Eve_Defs.asm copy Symbol_Eve_Defs.asm Symbol_Eve_Defs_48k.asm
	rem Edita todo para Symbol_Eve.asm
		echo 		org EveDataCode >> Symbol_Eve.asm
		type Symbol_Eve_Defs_org.asm >>		Symbol_Eve_Defs.asm
		type Symbol_Eve_Defs_chgfx.asm >>	Symbol_Eve_Defs.asm
		type Symbol_Eve_Engine.asm >>		Symbol_Eve_Defs.asm
		type Symbol_Eve_Defs.asm >>		Symbol_Eve.asm
		copy Symbol_Eve.asm ..\Realase\last_Symbol_Eve.asm
	rem Edita todo para Symbol_Eve_48k.asm
		type Symbol_Eve_Defs_chgfx.asm >> 	Symbol_Eve_Defs_48k.asm
		type Symbol_Eve_Engine.asm >> 		Symbol_Eve_Defs_48k.asm
		type Symbol_Eve_Defs_48k.asm >> Symbol_Eve_48k.asm
		copy Symbol_Eve_48k.asm ..\Realase\last_Symbol_Eve_48k.asm
		if exist Symbol_Eve_D*.asm del Symbol_Eve_D*.asm
		if exist Symbol_Eve_En*.asm del Symbol_Eve_En*.asm
	GOTO:EOF
	
:SetLONGPLAYER
	rem patron para cambiar todas las etiquetas AQUI
	for %%f in ( "*carrier*.asm" ) do (
		rem echo cambiar variable en %%~nxf
		..\tools\fart %%~nxf "LONGPLAYER" "%size128kAYEngine%"		>nul
				)
	GOTO:EOF
	
:ResetLONGPLAYER
	for %%f in ( "*carrier*.asm" ) do (
		rem echo cambio variable en %%~nxf
		..\tools\fart %%~nxf "LONGPLAYER" "0"		>nul
				)
	GOTO:EOF

:checkmemo
	set /a musicsize=%musicsize%+%sizem%
	if %musicsize% gtr 11264 (
		echo The music takes up %musicsize%k, too much memory, it won't work.
		goto error
		)
	GOTO:EOF
						
						
						
						