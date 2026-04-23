@echo off
:: No funciona con nombres de Temas con espacios
setlocal enabledelayedexpansion
set "folder_path=%~dp0"
set/A indice=0

rem /f "tokens=*" 
	echo		Lista de Canciones:			>> SelectTunes.txt
	echo+			>> SelectTunes.txt

for %%a in ("%folder_path%\Tune_*.asm") do (
	set archivo=%%a
	set "nombre_archivo=%%~nxa"
	rem nombre sin extension
	set "nombre=%%~na"
	rem nombre seguro para etiquetas asm
	set "nombre_id=!nombre: =_!"
	set size=%%~za
	call :writeasm
)

if %indice% == 0 (
		echo Ninguna 			>> SelectTunes.txt
		)

	echo+			>> SelectTunes.txt
	echo		Use PLAYMUSIC n to PLAY song n			>> SelectTunes.txt
	echo		Use PLAYFX n to PLAY effect n		>> SelectTunes.txt
	echo		Use LOOPOFF	to DISABLE infinite loop	>> SelectTunes.txt
	echo+		>> SelectTunes.txt
	echo		Use the following code to wait for a topic to finish without moving the game:		>> SelectTunes.txt
	echo+		>> SelectTunes.txt
	echo		MONITOR			; monitor		>> SelectTunes.txt
	echo		WHILE A = 1			; repeat while the Pac-man theme plays		>> SelectTunes.txt
	echo			DELAY 2		; reproduce siguiente nota		>> SelectTunes.txt
	echo			MONITOR		; monitor		>> SelectTunes.txt
	echo		ENDWHILE		>> SelectTunes.txt
	echo+		>> SelectTunes.txt
	echo		In the home menu: use DELAY 2 to set the TEMPO of the song: Example:			>> SelectTunes.txt
	echo+			>> SelectTunes.txt
	echo		PLAYMUSIC 2			>> SelectTunes.txt
	echo		LOOPOFF			>> SelectTunes.txt
	echo		WHILE CONTROL = 99	; as long as it does not change, do not exit the loop.			>> SelectTunes.txt
	echo			IF KEY OPTION1			>> SelectTunes.txt
	echo				LET CONTROL = 0			>> SelectTunes.txt
	echo			ENDIF			>> SelectTunes.txt
	echo			IF KEY OPTION2			>> SelectTunes.txt
	echo				LET CONTROL = 1			>> SelectTunes.txt
	echo			ENDIF			>> SelectTunes.txt
	echo			IF KEY OPTION3			>> SelectTunes.txt
	echo				LET CONTROL = 2			>> SelectTunes.txt
	echo			ENDIF			>> SelectTunes.txt
	echo			DELAY 2			; sync and play next note>> SelectTunes.txt
	echo		ENDWHILE			>> SelectTunes.txt
	echo+			>> SelectTunes.txt
	echo		Solve your doubts in https://arcadegamedesigner.proboards.com/		>> SelectTunes.txt
	echo+		>> SelectTunes.txt
	move ..\Assembly\SelectTunes.txt ..\Realase		>nul

goto:eof
endlocal
exit

:writeasm
REM set /a oldindice=indice
	set /a indice+=1

rem ;AGD SelectTunes.asm
	echo 		cp %indice%					>> SelectTunes.asm
	echo 		jp z,Init_!nombre_id!		>> SelectTunes.asm
	echo		%indice%: %nombre%			>> SelectTunes.txt
	rem echo+  >> SelectTunes.asm

rem ;AGD music.asm
	echo ;Tema %indice%						>> music.asm
	echo !nombre_id!_Tune						>> music.asm
	echo 		include "%nombre_archivo%"	>> music.asm
	echo Init_!nombre_id!						>> music.asm
	echo 		ld hl,!nombre_id!_Tune			>> music.asm
	echo 		jp initplayer					>> music.asm
	echo+									>> music.asm

rem editar codigo beepola MUSICDATA
	..\tools\fart "%nombre_archivo%" "ORG " ";ORG "		>nul
	..\tools\fart "%nombre_archivo%" "MUSICDATA" "!nombre_id!_MUSICDATA"		>nul
	..\tools\fart "%nombre_archivo%" "PAT" "!nombre_id!_PAT"		>nul
	
goto:eof
