@echo off
setlocal enabledelayedexpansion

:: Load Script form
	if exist AGDTiledMod\seleccionar_archivo.py copy AGDTiledMod\seleccionar_archivo.py seleccionar_archivo.py

:: Ejecutar el script Python
	python seleccionar_archivo.py agd
	
:: Limpieza
	if exist seleccionar_archivo.py del seleccionar_archivo.py
	
:: reset configuracion
	endlocal
	
echo+
