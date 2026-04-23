rem limpia la instalacion de archivos de trabajo.
@echo off
cls
	echo+
	echo WARNING! You will erase all the work done so far!
	echo This will clean up the working directories. Better do not do it
	echo if you are not sure
	pause
	echo You still have time to close the window!
	pause
	echo last chance! close the window!
	pause

	rem if exist  del 
rem borra Stages
	if exist Stages\SEC*.asm del Stages\SEC*.asm
	if exist Stages\Sta*.asm del Stages\Sta*.asm
	if exist Stages\Tap*.asm del Stages\Tap*.asm
	if exist Stages\SEC*.bin del Stages\*.bin
rem borra Bank
	if exist Stages\Bank\SEC*.asm del Stages\Bank\SEC*.asm
	if exist Stages\Bank\SEC*.bin del Stages\Bank\SEC*.bin
rem borra Common
	if exist Stages\Common\SEC*.asm del Stages\Common\SEC*.asm
rem borra Sound
	if exist Sound\Tune_*.asm del Sound\Tune_*.asm
	if exist Sound\*.pt3 del Sound\*.pt3
	if exist Sound\AK*.asm del Sound\AK*.asm
	if exist Sound\fx.asm del Sound\fx.asm
	if exist Sound\sfxBank.afb del Sound\sfxBank.afb
	if exist Sound\*.txt del Sound\*.txt
rem borra Screens
	if exist Screens\*.scr del Screens\*.scr
rem borra Realase
	if exist Realase\*.asm del Realase\*.asm
	if exist Realase\*.txt del Realase\*.txt
	if exist Realase\*.tap del Realase\*.tap
	if exist Realase\*.xlsx del Realase\*.xlsx
rem borra AGDsource
	if exist AGDsource\deleteme.agd del AGDsource\deleteme.agd
rem borra AGDsoundMod\AGDsource
	if exist AGDsoundMod\deleteme.agd del AGDsoundMod\deleteme.agd
	if exist AGDsoundMod\deleteme.asm del AGDsoundMod\deleteme.asm
exit
	