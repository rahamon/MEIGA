rem @echo off
cls

:: Compile AGD file
	copy AGDsource\%1.agd agd		>nul
	cd AGD
	
	AGD %1
	copy %1.asm ..\Rasm		>nul
	copy Unplugged.asm ..\Rasm		>nul
	copy ..\..\user.asm ..\Rasm\		>nul
	copy ..\Tools\Rasm.exe ..\Rasm
	
	rem limpieza
		del %1.*

:: Compilar Screens
	echo Screen CPC Mod MEIGA 2024 por Ramon Fernandez Ameijeiras
	copy ..\AGDscreenMod\screener.bat ..\Assembly		>nul
	copy ..\AGDscreenMod\header.asm ..\Rasm		>nul
	copy ..\AGDscreenMod\ScreenPlayer.asm ..\Rasm		>nul
	copy ..\AGDscreenMod\routines.asm ..\Rasm		>nul
	copy ..\AGDscreenMod\zx0.asm ..\Rasm		>nul
	
	cd ..\Assembly
	
	call screener

	if exist screens.bin copy screens.bin ..\Rasm
	copy ScreenSelector.asm ..\Rasm		>nul
	copy swappingS.asm ..\Rasm		>nul

	rem limpieza de Assembly
		if exist *.asm del *.asm		>nul
		if exist *.bin del *.bin		>nul
		if exist *.bat del *.bat		>nul

	rem cd ..\Assembly
	cd ..\Rasm

:: SoundModArkos
	rem Actualizar fuentes para Arkos Traker 2
		copy ..\AGDsoundMod\Arkos\*.asm ..\Rasm		>nul
		if not exist ..\Sound\AK*.asm (
			echo CAREFUL! You don't have compiled music: remove CALL 8198 from your scripts the music will break the game"
			..\Tools\fart header.asm "include \"UserPlayerAkgWithSoundEffect_CPC.asm\" "		ret"
			pause
			) else (
				copy ..\sound\AK*.asm ..\Rasm		>nul
				rem Compilation ZX Spectrum 128/+2/+3 AY-3-8912 Arkos Traker
					..\tools\Rasm PLAY4BANK.asm -o PLAY4BANK
					..\tools\zx7 PLAY4BANK.bin
					..\tools\Rasm bank4driver.asm sound
					call :printlist bank4driver		>nul
				..\CPCDiskXP\CPCDiskXP -File sound.bin -AddAmsdosHeader 2000 -AddToExistingDsk ..\Basic\AGDgame.dsk
				echo 70 LOAD "sound.bin",^&2000		>> ..\Basic\body.bas
				echo 80 CALL ^&2000		>> ..\Basic\body.bas
				..\Tools\fart %1.asm "plsnd  ret" "	   include \"plsnd.asm\""
				..\Tools\fart %1.asm "call plsnd          ; time to play sound." ";call plsnd          ; time to play sound."
			)
:: Assemble game
	rem ..\Tools\fart %1.asm "org 2000" "org 24832"
	..\Tools\fart %1.asm "org 2000" "org $2000"
	..\Tools\fart %1.asm "start  equ $" "		include \"header.asm\""
	
	..\tools\Rasm %1.asm -o AGDgame
	
	call :printlist %1		>nul
	if errorlevel 1 goto error
	copy AGDgame.bin ..\CPCDiskXP
	if exist screens.bin copy screens.bin ..\CPCDiskXP
	
	rem limpieza de Rasm
		del %1.asm
		del AGDgame.bin
		if exist screens.bin del screens.bin
		del *.asm
		del *.scr
		del *.bin*
		del *.exe
		
	rem guarda cassette
		move *.cdt	..\Realase

rem Create CPC diskimage
	cd ..\CPCDiskXP
	
rem Cargador
	rem patron: leader.txt+%1.asm+trailer.txt agdcode.asm
	copy ..\Basic\head.bas+..\Basic\body.bas+..\Basic\lbody_agd.bas+..\Basic\foot.bas ..\Basic\loader.bas
	copy ..\Basic\loader.bas ..\CPCDiskXP
	copy ..\Basic\loader.bas  ..\Realase
	copy ..\Basic\AGDgame.dsk AGDgame.dsk

	rem limpieza de Basic
		if exist ..\Basic\ibody_scr.bas del ..\Basic\ibody_scr.bas
		if exist ..\Basic\body.bas del ..\Basic\body.bas
		if exist ..\Basic\foot.bas del ..\Basic\foot.bas
		if exist ..\Basic\loader.bas del ..\Basic\loader.bas

	CPCDiskXP -File AGDgame.bin -AddAmsdosHeader 2000 -AddToExistingDsk AGDgame.dsk
	CPCDiskXP -File loader.bas -AddToExistingDsk AGDgame.dsk
	copy AGDgame.dsk ..\WinAPE
	rem copy ..\Basic\loader.bas ..\WinAPE\loader.atp

	rem limpieza
		del AGDgame.bin
		if exist screens.bin del screens.bin
		del AGDgame.dsk

rem Start emulator
	cd ..\winape
	rem winape "%cd%\AGDgame.dsk" /t:loader.atp
	winape "%cd%\AGDgame.dsk" /a:loader.bas
	
	cd ..
	goto end
	
:printlist
	copy %1.asm ..\sjasmplus\		>nul
	copy ..\..\user.asm ..\sjasmplus\		>nul
	if exist ..\..\UserRoutines\*.asm copy ..\..\UserRoutines\*.asm ..\sjasmplus\		>nul
	copy ..\SjasmPlus\leader.txt+..\SjasmPlus\%1.asm+..\SjasmPlus\trailer.txt agdcode.asm
	..\SjasmPlus\sjasmplus.exe agdcode.asm		>nul
	..\SjasmPlus\sjasmplus.exe %1.asm --lst=list.txt		>nul
	move list.txt ..\Realase\%1.txt.asm	>nul
	GOTO:EOF

:error
	echo %1.agd not found .....
	
:end
	