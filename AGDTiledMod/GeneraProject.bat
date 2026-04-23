@echo off

:: Genera AGD y compila Proyecto		
		echo Generando proyecto
		call OpenProject genera
		rem start "COMPILADOR PROYECTO" cmd /c OpenProject.bat genera
	EXIT
		