@echo off
setlocal enabledelayedexpansion

:: Módulos externos que debes instalar:
:: Pillow (para manejar imágenes PNG en muchos scripts)
:: numpy (para cálculos con matrices de píxeles y colores)
	echo Instalando Pillow para Python...
	pip install pillow
	echo Instalando numpy para Python...
	pip install numpy

:: Carpeta superior
	set "current=%CD%"
	for %%I in ("%current%\..") do set "parent=%%~fI"

:: Ruta completa al acceso directo
	set "shortcut=%parent%\MEIGA.lnk"
	set "icon=%parent%\AGDTiledMod\MEIGA.ICO"
	set "target=%parent%\ExtractAGD.bat"

:: Crear acceso directo usando PowerShell
	powershell ^
	 $WshShell = New-Object -ComObject WScript.Shell; ^
	 $Shortcut = $WshShell.CreateShortcut('%shortcut%'); ^
	 $Shortcut.TargetPath = '%target%'; ^
	 $Shortcut.WorkingDirectory = '%parent%'; ^
	 $Shortcut.IconLocation = '%icon%'; ^
	 $Shortcut.Save()

echo Acceso directo "MEIGA" creado en: %parent%
echo.
echo Instalacion completa.
pause

