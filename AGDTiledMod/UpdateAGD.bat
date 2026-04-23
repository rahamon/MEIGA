@echo off
	REM Uso: UpdateAGD <version MEIGA>
	
	echo Actualizando version %1
	if "%1" == "" exit

:: Leer ultima VERSION (en EMIGA)
	if exist VersionMeiga.bat (
		call VersionMeiga
		set last_version=!version_meiga!
	) else (
		set last_version=0
	)
:: Chequear Actualizacion MEIGA AGD
	REM Convertir a números
	set /a lv=%last_version%
	set /a vm=%1

	REM Comparación exacta
	if !lv! EQU !vm! (
		set instalando=0
		echo La version ya esta actualizada a %1.
	) else (
		goto :ActualizaAGD
	)

:: Saliendo
	GOTO:EOF

:ActualizaAGD
	echo Version diferente detectada: actual !lv! , nueva !vm!
	echo Ejecutando actualizaciones
	:: programa de actualizacion 8
		if !lv! leq 7 (
			echo Actualizando para MEIGA AGD 8
			cd /d "%meiga_dir%"
			xcopy "AGDTiledMod\Updates\Suite ZX" "Suite ZX" /E /I /Y >nul
			xcopy "AGDTiledMod\Updates\UserRoutines" "UserRoutines" /E /I /Y >nul
			pause
			if errorlevel 1 exit /b 1
		)
		
	:: programa de actualizacion Superior
		echo Necesaria Instalacion de MEIGA !vm!
		:: Instala
			set instalando=1
			cd AGDTiledMod
			start "MEIGA INSTALADOR" cmd /c Install.bat
			cd /d "%meiga_dir%"
		
	GOTO:EOF
	