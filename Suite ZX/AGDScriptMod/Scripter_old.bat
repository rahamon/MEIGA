@echo off
:: MEIGA ScriptMod Source agd 2025 por Ramón Fernández Ameijeiras
	echo AGDScriptMod 2025 Traductor de comandos
	echo 			by Ramon Fernandez Ameijeiras
	echo			running...
	rem limpieza inicial
	rem chcp 65001 >nul caracteres especiales
		if exist Script.agd del Script.agd >nul
		copy %1.agd Script.agd >nul
	
:AGDParser
	set "outfile=Script.agd"
	if exist msgerror.log del msgerror.log >nul

	:: Preparar comentarios
			..\Tools\fart %outfile% ";" "; " >nul
	
	:: Traducir SOUND de manera ordenada
		rem Reserva SOUND to PLAYFX
			..\Tools\fart %outfile% "SOUND " "PLAYFX " >nul

		rem PLAYMUSIC
			call :validar_PLAYMUSIC
			..\Tools\fart %outfile% "PLAYMUSIC " "SOUND " >nul

		rem LET COMMAND = numero
			..\Tools\fart %outfile% "LET COMMAND" "COMMAND" >nul
			..\Tools\fart %outfile% "COMMAND = " "COMMAND=" >nul
			..\Tools\fart %outfile% "COMMAND=" "MYCOMMAND " >nul

		rem Restaura SOUND from FXSOUND
			call :validar_PLAYFX
			..\Tools\fart %outfile% "PLAYFX " "SOUND 10" >nul
			call :validar_SOUND
			
		rem LOOPOFF
			..\Tools\fart %outfile% "LOOPOFF" "SOUND 0" >nul
			
		rem STOPMUSIC
			..\Tools\fart %outfile% "STOPMUSIC" "SOUND 31" >nul
			
		rem MONITOR
			..\Tools\fart %outfile% "MONITOR" "SOUND 36" >nul
			
		rem PAUSEMUSIC
			..\Tools\fart %outfile% "PAUSEMUSIC" "SILENCE" >nul
		
	:: Stage command
		call :validar_JUMPSTAGE
		
	:: Splash command
		call :validar_PRINTSPLASH

:fin
	goto :eof
		
:validar_PLAYFX
	setlocal enabledelayedexpansion
	for /f "tokens=* delims=" %%a in (%outfile%) do (
		set "linea=%%a"
		set "prev="
		set "comentario=0"
		rem Recorrer Y VALIDAR cada palabra de la línea
			for %%b in (!linea!) do (
				rem omite comentarios
				if "!prev!"==";" set "comentario=1"
				rem VALIDAR PLAYFX
				if "!prev!"=="PLAYFX" if "!comentario!"=="0" (
					set "crudo=%%b"
					call :limpiar_valor
					if !valor! geq 200 (
						..\Tools\fart %outfile% "!prev! %%b" "ERROR ; SOUND: valor muy grande" >nul
					) else if !valor! geq 99 if !valor! leq 199 (
						set /a "valor-=100"
						..\Tools\fart %outfile% "!prev! %%b" "!prev! !valor! ; valor modificado" >nul
					) 
					if !valor! equ 36 (
						..\Tools\fart %outfile% "!prev! %%b" "MONITOR  ;  valor modificado" >nul
					)
				)
				set "prev=%%b"
			)
	)
	endlocal
	goto :eof

:validar_SOUND
	setlocal enabledelayedexpansion
	for /f "tokens=* delims=" %%a in (%outfile%) do (
		set "linea=%%a"
		set "prev="
		set "comentario=0"
		rem Recorrer Y VALIDAR cada palabra de la línea
			for %%b in (!linea!) do (
				rem omite comentarios
				if "!prev!"==";" set "comentario=1"
				rem VALIDAR SOUND
				if "!prev!"=="SOUND" if "!comentario!"=="0" (
					set "crudo=%%b"
					call :limpiar_valor
					if !valor! geq 1000 (
						set /a "valor-=1000"
						set /a "valor+=100"
						..\Tools\fart %outfile% "!prev! %%b" "!prev! !valor!" >nul
					) else if !valor! equ 100 (
						..\Tools\fart %outfile% "!prev! %%b" "ERROR ; SOUND: no puede ser 0"
						echo SOUND no puede ser 0 >> msgerror.log
					)
				)
				set "prev=%%b"
			)
	)
	endlocal
	goto :eof

:validar_PLAYMUSIC
	setlocal enabledelayedexpansion
	for /f "tokens=* delims=" %%a in (%outfile%) do (
		set "linea=%%a"
		set "prev="
		set "hayNumero=0"
		set "comentario=0"
		rem Recorrer Y VALIDAR cada palabra de la línea
			for %%b in (!linea!) do (
				rem omite comentarios
				if "!prev!"==";" set "comentario=1"
				rem VALIDAR PLAYMUSIC
				if "!prev!"=="PLAYMUSIC" if "!comentario!"=="0" (
					set "crudo=%%b"
					call :limpiar_valor
					set "hayNumero=1"
					if !valor! geq 100 (
						..\Tools\fart %outfile% "PLAYMUSIC %%b" "ERROR ; la pista de PLAYMUSIC: debe ser menor que 100" >nul
						echo PLAYMUSIC debe ser menor que 100 >> msgerror.log
					) else if !valor! equ 0 (
						..\Tools\fart %outfile% "PLAYMUSIC %%b" "ERROR ; la pista de PLAYMUSIC: no puede ser 0" >nul
						echo PLAYMUSIC no puede ser 0 >> msgerror.log
					)
				)
				set "prev=%%b"
			)
		rem Si se encontró PLAYMUSIC pero no se estableció un número
			if "!prev!"=="PLAYMUSIC" if "!hayNumero!"=="0" (
				echo Advertencia: PLAYMUSIC no tiene un valor asignado en la línea "!linea!"
				..\Tools\fart %outfile% "PLAYMUSIC" "ERROR ; PLAYMUSIC: no tiene valor" >nul
				echo PLAYMUSIC no tiene valor >> msgerror.log
				)
	)
	endlocal
	goto :eof

:validar_JUMPSTAGE
	setlocal enabledelayedexpansion
	for /f "tokens=* delims=" %%a in (%outfile%) do (
		set "linea=%%a"
		set "prev="
		set "comentario=0"
		rem Recorrer Y VALIDAR cada palabra de la línea
			for %%b in (!linea!) do (
				rem omite comentarios
				if "!prev!"==";" set "comentario=1"
				rem VALIDAR PLAYMUSIC
				if "!prev!"=="JUMPSTAGE" (
					set "numero=%%b"
					:limpia_ceros
					if "!numero:~0,1!"=="0" set "numero=!numero:~1!" & goto limpia_ceros
					if "!numero!"=="" set "numero=0"
					set /a valor=!numero!
					set /a "valor
					if !valor! equ 0 (
						..\Tools\fart %outfile% "JUMPSTAGE %%b" "ERROR ; JUMPSTAGE: %%b el valor no puede ser 0" >nul
					) else (
						..\Tools\fart %outfile% "JUMPSTAGE %%b" "LET A = %%b CALL 24835" >nul
					)
				)
				set "prev=%%b"
			)
	)
	endlocal
	goto :eof
	
:validar_PRINTSPLASH
	setlocal enabledelayedexpansion
	for /f "tokens=* delims=" %%a in (%outfile%) do (
		set "linea=%%a"
		set "prev="
		set "comentario=0"
		rem Recorrer Y VALIDAR cada palabra de la línea
			for %%b in (!linea!) do (
				rem omite comentarios
				if "!prev!"==";" set "comentario=1"
				rem VALIDAR PRINTSPLASH
				if "!prev!"=="PRINTSPLASH" (
					set "crudo=%%b"
					call :limpiar_valor
					if !valor! equ 0 (
						..\Tools\fart %outfile% "PRINTSPLASH %%b" "ERROR ; PRINTSPLASH: %%b el valor no puede ser 0" >nul
					) else (
						..\Tools\fart %outfile% "PRINTSPLASH %%b" "LET A = %%b CALL 24838" >nul
					)
				)
				set "prev=%%b"
			)
	)
	endlocal
	goto :eof

:limpiar_valor
	rem Entrada: !crudo! (con ceros a la izquierda)
	rem Salida: !valor! (limpio y en decimal)
	setlocal enabledelayedexpansion
	set "numero=!crudo!"
	:limpia_ceros
	if "!numero:~0,1!"=="0" (
		set "numero=!numero:~1!"
		goto limpia_ceros
	)
	if "!numero!"=="" set "numero=0"
	endlocal & set "valor=%numero%"
	goto :eof
