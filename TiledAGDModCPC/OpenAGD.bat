@echo off
setlocal enabledelayedexpansion

:: Load Script form
	if exist AGDTiledMod\seleccionar_archivo.py copy AGDTiledMod\seleccionar_archivo.py seleccionar_archivo.py

:: Ejecutar el script Python
	python seleccionar_archivo.py

:: Inicializar variables
	set "archivo="
	set "ruta="
	set "nombre="

:: Leer las tres líneas del archivo
	if exist seleccion.txt (
		set /a i=0
		for /f "usebackq delims=" %%a in ("seleccion.txt") do (
			set /a i+=1
			if !i! == 1 set "archivo=%%a"
			if !i! == 2 set "ruta=%%a"
			if !i! == 3 set "nombre=%%a"
		)
		rem del seleccion.txt
	)

:: Mostrar resultados
	echo.
	if defined archivo (
		echo Ruta completa: !archivo!
		echo Directorio:       !ruta!
		echo Proyecto:        !nombre!
	) else (
		echo No se selecciono ningun archivo.
	)
	
:: Limpieza
	if exist seleccionar_archivo.py del seleccionar_archivo.py
	
:: reset configuracion
	endlocal
	
echo+
