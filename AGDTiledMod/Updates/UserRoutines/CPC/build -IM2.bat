@echo off
cls
rem Compile AGD file
	copy AGDsource\%1.agd agd
	cd AGD
	AGD %1
	copy %1.asm ..\Rasm
	copy ..\..\user.asm ..\Rasm\
	del %1.*

rem Assemble game
	cd ..\Rasm
	REM fart %1.asm "plsnd  ret" "	   include \"plsnd.asm\""
	REM fart %1.asm "call plsnd          ; time to play sound." ";call plsnd          ; time to play sound."
	fart %1.asm "eop    equ $" "	   include \"trailer_rasm.asm\""		>nul
	fart %1.asm "start0 call game           ; start the game." "	   include \"header.asm\""		>nul
	rasm.exe %1.asm -o AGDgame
	if errorlevel 1 goto error
	copy AGDgame.bin ..\CPCDiskXP
	copy %1.asm ..\Realase
	del %1.asm
	del AGDgame.bin

rem Create CPC diskimage
	cd ..\CPCDiskXP
	CPCDiskXP -File AGDgame.bin -AddAmsdosHeader 7D0 -AddToNewDsk AGDgames.dsk 
	copy AGDgames.dsk ..\WinAPE
	del AGDgame.bin
	del AGDgames.dsk

rem Start emulator
	cd ..\winape
	winape "%cd%\AGDgames.dsk" /A:AGDgame.bin
	cd ..
	goto end

:error
	echo %1.agd not found .....
 
:end
