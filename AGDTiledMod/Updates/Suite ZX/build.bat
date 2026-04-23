@echo off
	REM Uso: build <nombre_base_sin_extension>
		if "%1"=="" (
			echo.
			echo ERROR:
			echo Este script no debe ejecutarse manualmente.
			pause
			exit /b 1
		)
	
:: Ejecutar manager nombre del juego como parametro y le quita las comillas si tiene ("%~1" en vez de %1)
	call manager "%~1" || echo End of manager
			
:: Cerrar al finalizar
	GOTO :EOF
	rem EXIT
