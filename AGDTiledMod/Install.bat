@echo off
setlocal enabledelayedexpansion

:: Módulos externos que debes instalar:
:: Pillow (para manejar imágenes PNG en muchos scripts)
:: numpy (para cálculos con matrices de píxeles y colores)
:: Compilador de MPAGD 10.7

	:: Titulo
		echo.
		call VersionMeiga
		echo	INSTALACION MEIGA %version_meiga%
		echo.

	:: Verificar si Tiled disponible
		where tiled.exe >nul 2>nul
		if %errorlevel% neq 0 (
			echo Tiled no instalado o no en el PATH. Abortando...
			echo Procede a instalarlo en tu sisitema
			echo Disponible en https://www.mapeditor.org/
			exit /b 1
		)		
		
	:: Verificar si Python disponible
	echo Verificando si Python es instalado...
		where python >nul 2>nul
		if %errorlevel% neq 0 (
			echo Python no instalado o no en el PATH. Abortando...
			echo Procede a instalarlo en tu sisitema
			echo Disponible en https://apps.microsoft.com/
			exit /b 1
		)

	echo Verificando si Pillow es instalado...
		python -c "import PIL" >nul 2>nul
		if %errorlevel% neq 0 (
			echo Pillow no encontrado. Instalando Pillow...
			python -m pip install pillow >nul
		) else (
			echo Pillow ya instalado.
		)

	echo Verificando si numpy es instalado...
		python -c "import numpy" >nul 2>nul
		if %errorlevel% neq 0 (
			echo numpy no encontrado. Instalando numpy...
			python -m pip install numpy >nul
		) else (
			echo numpy ya instalado.
		)

	echo Comprobaciones completadas.

:: Carpeta superior
	set "current=%CD%"
	for %%I in ("%current%\..") do set "parent=%%~fI"
	REM echo current: %current%
	REM echo parent: %parent%
	REM pause
	
:: Copia Comandos
	if exist ExtractAGD.bat copy ExtractAGD.bat ..\ExtractAGD.bat >nul
	if exist RunAGD.bat copy RunAGD.bat ..\RunAGD.bat >nul
	if exist NuevoAGD.bat copy NuevoAGD.bat ..\NuevoAGD.bat >nul
	if exist OpenProject.bat copy OpenProject.bat ..\OpenProject.bat >nul
	if exist Debugger.bat copy Debugger.bat ..\Debugger.bat >nul
:: Copia programas
	if exist OpenAGD.bat copy OpenAGD.bat ..\OpenAGD.bat >nul
	if exist UpdateAGD.bat copy UpdateAGD.bat ..\UpdateAGD.bat >nul
	if exist VersionMeiga.bat copy VersionMeiga.bat ..\VersionMeiga.bat >nul
	if exist UpdateProject.bat copy UpdateProject.bat ..\UpdateProject.bat >nul
	if exist GeneraProject.bat copy GeneraProject.bat ..\GeneraProject.bat >nul
	
:: MEIGA EXTRACTOR
		if exist "%parent%\*.lnk" del "%parent%\*.lnk"
	:: Ruta completa al acceso directo
		set "shortcut=%parent%\MEIGA EXTRACTOR.lnk"
		set "icon=%parent%\AGDTiledMod\MEIGA.ICO"
		set "target=%parent%\ExtractAGD.bat"

	call :CrearLink

:: MEIGA AGD COMPILADOR
	:: Ruta completa al acceso directo
		set "shortcut=%parent%\RUN AGD.lnk"
		set "icon=%parent%\AGDTiledMod\MEIGA_bn.ICO"
		set "target=%parent%\RunAGD.bat"

	call :CrearLink

:: MEIGA CREADOR
	:: Ruta completa al acceso directo
		set "shortcut=%parent%\MEIGA CREADOR.lnk"
		set "icon=%parent%\AGDTiledMod\MEIGA_bn.ICO"
		set "target=%parent%\NuevoAGD.bat"

	call :CrearLink

:: MEIGA EDITOR
	:: Ruta completa al acceso directo
		set "shortcut=%parent%\MEIGA EDITOR.lnk"
		set "icon=%parent%\AGDTiledMod\MEIGA_bn.ICO"
		set "target=%parent%\OpenProject.bat"

	call :CrearLink

:: MEIGA PROYECTO COMPILADOR
	:: Ruta completa al acceso directo
		set "shortcut=%parent%\MEIGA COMPILADOR.lnk"
		set "icon=%parent%\AGDTiledMod\MEIGA_bn.ICO"
		set "target=%parent%\GeneraProject.bat"

	call :CrearLink

:: MEIGA PROYECTO DEPURADOR
	:: Ruta completa al acceso directo
		set "shortcut=%parent%\MEIGA DEPURADOR.lnk"
		set "icon=%parent%\AGDTiledMod\MEIGA_bn.ICO"
		set "target=%parent%\Debugger.bat"

	call :CrearLink

:: MEIGA TEST CINTA
	:: Ruta completa al acceso directo
		REM set "shortcut=%parent%\TEST CINTA.lnk"
		REM set "icon=%parent%\AGDTiledMod\MEIGA_bn.ICO"
		REM set "target=%parent%\Suite ZX\Realase\Test128.tap"

	REM call :CrearLink

:: Check Core
:: MEIGA usa el Compilador de MPAGD 10.7 es necesario isntalarlo previamente
	echo MEIGA usa el Compilador de MPAGD 10.7 es necesario isntalarlo previamente
	echo Disponible en https://jonathan-cauldwell.itch.io/multi-platform-arcade-game-designer
	if not exist "..\Suite ZX\AGD\CompilerZX.exe" (
		:: Load form
			rem python seleccionar_archivo.py compiler
		:: Load Automático
			python encuentra_CompilerZX.py
		:: Instala Core
			call Compiler
			xcopy "!compiler_exe!" "..\Suite ZX\AGD\" /Y
			xcopy "!compiler_dir!\*.asm" "..\Suite ZX\AGD\" /Y
		:: Istala Suite
			xcopy "Updates\Suite ZX" "..\Suite ZX" /E /I /Y >nul
			xcopy "Updates\UserRoutines" "..\UserRoutines" /E /I /Y >nul
	)
	
:Terminando
	echo.
	echo Instalacion en %parent% completa.
	echo Prueba ahora a ejecutar la nueva version
	echo Editor Recomendado NOTEPAD++ para editar tus scripts
	echo Disoonible en https://notepad-plus-plus.org/
	pause
	GOTO:EOF
	EXIT

:CrearLink
	:: Crear acceso directo usando PowerShell
		powershell ^
		 $WshShell = New-Object -ComObject WScript.Shell; ^
		 $Shortcut = $WshShell.CreateShortcut('%shortcut%'); ^
		 $Shortcut.TargetPath = '%target%'; ^
		 $Shortcut.WorkingDirectory = '%parent%'; ^
		 $Shortcut.IconLocation = '%icon%'; ^
	 $Shortcut.Save()

GOTO:EOF

