@echo off
setlocal enabledelayedexpansion
set "folder_path=%~dp0"
set/A indice=0
set "offset="
rem /f "tokens=*"
	echo		Lista de Canciones:			>> SelectTunes.txt
	
for %%a in ("%folder_path%\*.pt3") do (
	set archivo=%%a
	set nombre_archivo=%%~nxa
	rem nombre sin extension
	set nombre=%%~na
	set size=%%~za
	call :writeasm
)
	echo		Use PLAYMUSIC n to PLAY song n			>> SelectTunes.txt
	echo		Use PLAYFX n 	to PLAY effect n		>> SelectTunes.txt
	echo		Use LOOPOFF		to DISABLE infinite loop	>> SelectTunes.txt
	echo+		>> SelectTunes.txt
	echo		Use the following code to wait for a topic to finish without moving the game:		>> SelectTunes.txt
	echo+		>> SelectTunes.txt
	echo		MONITOR				; monitor		>> SelectTunes.txt
	echo		WHILE A = 1			; repeat while the music theme plays		>> SelectTunes.txt
	echo			MONITOR			; monitor		>> SelectTunes.txt
	echo		ENDWHILE		>> SelectTunes.txt
	echo+		>> SelectTunes.txt
	echo		Solve your doubts in https://arcadegamedesigner.proboards.com/		>> SelectTunes.txt
	echo+		>> SelectTunes.txt
	
	
	move ..\Assembly\SelectTunes.txt ..\Realase
goto:eof

:writeasm
set /a oldindice=indice
set /a indice+=1
if %indice% gtr 1 ( set "offset=%offset% + MUSLEN%oldindice%" )

rem ;AGD irinclude.asm
echo 		cp %indice%								>> irinclude.asm
echo 		call z,mus%indice%						>> irinclude.asm
echo			%indice%: %nombre% !size! bytes		>> SelectTunes.txt
rem echo+  >> irinclude.asm

rem ;AGD musicsizes.asm
echo MUSLEN%indice% equ !size!					>> musicsizes.asm

rem ;AGD music.asm
echo musicbin%indice%:							>> music.asm
echo 		incbin "%nombre_archivo%.zx7"			>> music.asm
			rem ..\Tools\zx7 %nombre_archivo%

rem ;AGD musicdepacks.asm
echo depacktheme%indice%: 						>> musicdepacks.asm
echo 		ld hl,musicbin%indice% 					>> musicdepacks.asm
if %indice% == 1 (
	echo 		ld de,MUSICSTART					>> musicdepacks.asm
	) else (
	rem MUSICSTART + MUSLEN%oldindice%
	echo 		ld de,MUSICSTART%offset%			>> musicdepacks.asm
	)
echo 		call zx7bin								>> musicdepacks.asm

rem ;AGD musicplayback.asm
echo mus%indice%:								>> musicplayback.asm
echo 		DI										>> musicplayback.asm
echo 		call msetup								>> musicplayback.asm
if %indice% == 1 (
	echo 		ld hl,MUSICSTART					>> musicplayback.asm
	) else (
	echo 		ld hl,MUSICSTART%offset%			>> musicplayback.asm
	)
echo 		ld (49153),hl							>> musicplayback.asm
echo 		call 49152								>> musicplayback.asm
echo 		EI										>> musicplayback.asm
echo 		ret										>> musicplayback.asm

goto:eof