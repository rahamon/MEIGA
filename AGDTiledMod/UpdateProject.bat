:: UpdateProject version 9

	:: Leer version.txt otra manera
		call :GetVersionExtraida

	:: Check versiones extraidas para Tiled-AGD, Actualizando Extensiones y Comandos
		cd /d "%meiga_dir%"
		call VersionMeiga

		if "%version_extraida%"=="0" (
			echo No esxiste control de versiones extraidas
			echo Actualizando Extensiones y Comandos de Proyecto
			call :UpdateScripts >nul
			call :UpdateSeed >nul
			echo Actualizada MEIGA Editor %version_meiga% 
			)
			
		set /a version=%version_extraida%
		if "%version%"=="%version_meiga%" (
			REM echo version Actualizada
			goto Terminado
			) else (
				REM echo version_extraida: Desactualizada
				echo Actualizando Extensiones y Comandos de Proyecto
				call :UpdateScripts >nul
				call :UpdateSeed >nul
				echo Actualizada MEIGA Editor %version_meiga%
				)
:Terminado

	GOTO:EOF

:UpdateScripts
	:: Reinstalacion scripts y comandos
		cd /d "%meiga_dir%"
		
	:: Install Extension Tiled
		xcopy AGDTiledScript "%project_dir%\AGDTiledScript" /I /Y >nul
		
	:: Copiar Paletas
		xcopy AGDTiledMod\Paletas "%project_dir%\Paletas" /I /Y >nul
		
	:: Mueve estos archivos de comandos
		set FILES=GeneraAGD.bat TestAGD.bat ReordenaBlocks.bat ActualizaPalette.bat

		rem Recorrer archivos y copiarlos
		for %%F in (%FILES%) do (
			if exist "AGDTiledMod%model%\%%F" (
				copy "AGDTiledMod%model%\%%F" "%project_dir%\%%F" >nul  
				echo "AGDTiledMod%model%\%%F" "%project_dir%\%%F"  
			) else (
				echo Archivo no encontrado: "AGDTiledMod%model%\%%F"
			)
		)
	
	:: A partir de la version 10
	:: Importa nuevo MPAGDClass en Tiled
		copy "AGDTiledMod%model%\MPAGDClass.json" "%project_dir%\MPAGDClass.json"
		copy "AGDTiledMod%model%\TiledAGD.Default-Project" "%project_dir%\%project_name%.tiled-project"

	:: Crea directorios Mods
		cd /d "%project_dir%"
		if not exist "Sound" mkdir Sound
		if not exist "Screens" mkdir Screens
		if not exist "Stages" mkdir Stages
		if not exist "Realase" mkdir Realase
		cd "Stages"
		if not exist "Backup" mkdir "Backup"

	GOTO:EOF
	
:UpdateSeed	
	:: Rescribe version.txt con nueva version meiga
		cd /d "%meiga_dir%"
		copy "VersionMeiga.bat" "%project_dir%\VersionMeiga.bat"		
	GOTO:EOF

:GetVersionExtraida
	cd /d "%project_dir%"
	:: Leer ultima VERSION (en directorio de proyecto)
		if exist VersionMeiga.bat (
			call VersionMeiga
			set version_extraida=!version_meiga!
		) else (
			set version_extraida=0
		)
	GOTO:EOF
	
	
