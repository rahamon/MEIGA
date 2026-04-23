@echo off
Rem Compresor de musica

setlocal enabledelayedexpansion
set "folder_path=%~dp0"

for %%a in ("%folder_path%\*.pt3") do (
	set archivo=%%a
	set nombre_archivo=%%~nxa
	rem nombre sin extension
		set nombre=%%~na
	set size=%%~za
	call :Compress
	)
	
goto:eof
exit
	
:Compress
	echo "%nombre_archivo%"
	..\Tools\zx7 "%nombre_archivo%"

goto:eof
