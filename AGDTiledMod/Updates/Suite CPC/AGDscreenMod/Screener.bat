rem @echo off
rem estamos en Assembly

:: limpieza ..\Assembly
	if exist *.asm del *.asm		>nul
	if exist *.bin del *.bin		>nul

set screenuno=""

:: cabeceras
	echo Lista de pantallas:		>> screenhelp.txt
	echo ; Seccion de datos				>> screens.asm
	echo ; Carga banco Screens			>> LoadDataScreens.asm
	echo ; Screen selector				>> ScreenSelector.asm

:: cuenta screens
	set /a screens=0
	set /a PackedImages=0
	set /a desplazamiento=0
	set /a Nuevodesplazamiento=0
	set screenname=""
	set packedname=""


	for %%f in ("..\Screens\*.scr") do (
		set screenname=%%~nf
		:: por defecto coge el ultimo nombre para scrtap
			set "screenuno=%%f"
		set /a screens+=1
		)

	for %%f in ("..\Screens\*.asm") do (
		set packedname=%%~nf
		set /a PackedImages+=1
		call :renamescreens
		)

:: pie
	echo 			ret				>> ScreenSelector.asm
	
:: montajes
:main
		
	:: if not exist screen.scr
	if %screens% == 0 (
		rem set /a screens=1
		call :scempty2		>nul
		)
		
	if %screens% == 1 (
		rem echo scrtap
		call :scrtap
		)
		
	if %PackedImages% == 0 (
		call :scempty		>nul
	) else (
		rem echo modelos 128k:
		rem echo
		call :scrbanks
		)
	
	:: edita helper
		echo+		>> screenhelp.txt
		echo Invoke screens with the following instruction:		>> screenhelp.txt
		echo+		>> screenhelp.txt
		echo 			LET A = 1		>> screenhelp.txt
		echo 			CALL 8195		>> screenhelp.txt
		echo+		>> screenhelp.txt
		echo Includes five screens (.scr) (if you need) in the screens directory >> screenhelp.txt
		echo Advanced: You can section into 3 parts to incorporate them	>> screenhelp.txt
		echo then in 3 different positions according to the included diagram		>> screenhelp.txt
		echo in the VIDEO DATA.xlsx schema in the Release directory		>> screenhelp.txt
		echo+
		
	
	:: incluye helper text in Realase
		move screenhelp.txt ..\Realase\		>nul
		if not exist "..\Realase\VIDEO DATA.xlsx" (
			copy "..\AGDscreenMod\VIDEO DATA.xlsx" ..\Realase\		>nul
			)
:: fin
:fin
	:: añadir a loader: DATA Firmware
	GOTO:EOF
	exit
	
:scrtap
	:: Pre-Compilation...
		copy ..\Screens\%screenname%.scr ..\Assembly
		rem limpieza inicial
			if exist ..\Basic\ibody_scr.bas del ..\Basic\ibody_scr.bas
			if exist ..\Basic\body.bas del ..\Basic\body.bas
			if exist ..\Basic\foot.bas del ..\Basic\foot.bas
			
		rem write ibody_scr
			echo 15 GOSUB 300		>> ..\Basic\ibody_scr.bas
			echo 20 LOAD"!%screenname%.scr",^&C000		>> ..\Basic\ibody_scr.bas
			echo 30 LET p=^&D7D1: GOSUB 200			>> ..\Basic\ibody_scr.bas
			
		rem add scr BASIC lines
			copy ..\Basic\ibody_scr.bas ..\Basic\body.bas
			copy ..\Basic\ifoot.bas ..\Basic\foot.bas
			
		rem add screen
		..\CPCDiskXP\CPCDiskXP -File %screenname%.scr -AddToExistingDsk ..\Basic\AGDgame.dsk 
	GOTO:EOF
	
:scempty
	:: crea screen fantasma
		REM copy ..\AGDscreenMod\mocscreen0.scr ..\Screens\mocscreen.scr	>nul
		REM set "screenuno=mocscreen.scr"
	:: mocscreen.bin TODO aqui
		echo ;empty	swappingS					>> swappingS.asm
		echo Packed Screen vacio		>> screenhelp.txt
	GOTO:EOF
	
:scempty2
	:: crea screen fantasma
		REM copy ..\AGDscreenMod\mocscreen0.scr ..\Screens\mocscreen.scr	>nul
		REM set "screenuno=mocscreen.scr"
		echo Screen vacio		>> screenhelp.txt
	GOTO:EOF

:scrbanks
	:: Crea bankS
		copy ..\AGDscreenMod\bankS.asm ..\Assembly
		copy ..\AGDscreenMod\routines.asm ..\Assembly
		copy ..\AGDscreenMod\zx0.asm ..\Assembly
		copy ..\AGDscreenMod\UpdateFirmware.asm ..\Assembly

	:: Ediciones
	:: Desactiva Default Screens setting para no deshacer paleta de colores de screens
		rem ..\Tools\fart  1%.asm "call 48127" ";call 48127"

	:: patch CPC memory desplazamiento
		..\Tools\fart bankS.asm "org 24832" "org $2000"

	:: Crea Screens binario (screens.bin) para CPC disco
		..\Rasm\rasm bankS.asm -o screens
		..\CPCDiskXP\CPCDiskXP -File screens.bin -AddAmsdosHeader 2000 -AddToExistingDsk ..\Basic\AGDgame.dsk

		
	:: Add scr BASIC lines
		echo 50 LOAD "screens.bin",^&2000		>> ..\Basic\body.bas
		echo 60 CALL ^&2000			>> ..\Basic\body.bas
			
	:: Texto de compilacion
		call :printlist bankS
		rem call :printlist zx0
	:: Informe tamano banco
		echo Tamaño del banco de screens %desplazamiento%		>> screenhelp.txt
		if %desplazamiento% gtr 16384 (
			echo Tamaño del banco de screens %desplazamiento%
			echo Limite de Banco de Screens superado!
			echo Limite de Banco de Screens superado!		>> screenhelp.txt
			)
	GOTO:EOF

:printlist
	copy %1.asm ..\sjasmplus\		>nul
	copy ..\..\user.asm ..\sjasmplus\		>nul
	if exist ..\..\UserRoutines\*.asm copy ..\..\UserRoutines\*.asm ..\sjasmplus\		>nul
	rem copy leader.txt+%1.asm+trailer.txt agdcode.asm
	..\SjasmPlus\sjasmplus.exe %1.asm --lst=list.txt		>nul
	move list.txt ..\Realase\%1.txt.asm	>nul
	GOTO:EOF

:renamescreens
	:: Pre-Compilation...
		copy ..\Screens\%packedname%.asm ..\Assembly
		..\Rasm\rasm %packedname%.asm -o %packedname%
		rem aqui: firmware_DATA_basic conversion
	
	for %%m in ( "%packedname%.bin" ) do (
		set /a Nuevodesplazamiento=%%~zm
		echo screen %PackedImages%:		pantalla %packedname%. %%~zm bite	>> screenhelp.txt
		)

	echo screeninc%PackedImages%:		; presentacion pantalla %packedname%.		>> screens.asm
	echo 			incbin	"%packedname%.bin"							>> screens.asm
	echo+		>> screens.asm

	echo 			; carga presentación pantalla %PackedImages%.			>> LoadDataScreens.asm
	echo 			; por cada pantalla en screens directory:			>> LoadDataScreens.asm
	echo 			; carga presentación pantalla %packedname%.			>> LoadDataScreens.asm
	echo 			ld hl,ScrBuffer + %desplazamiento% + %Nuevodesplazamiento% - 16			>> LoadDataScreens.asm
	echo 			ld (Palettepoiter),hl					>> LoadDataScreens.asm
	echo 			ld hl,screeninc%PackedImages%			>> LoadDataScreens.asm
	echo 			ld bc,%Nuevodesplazamiento%						;LONGSCREENS equ 2796 aprox			>> LoadDataScreens.asm
	echo 			ld de,ScrBuffer + %desplazamiento%			>> LoadDataScreens.asm
	echo 			call SaveToTemp					; swap y vuelve a bank0			>> LoadDataScreens.asm
	echo 			ld a,$C7			>> LoadDataScreens.asm
	echo 			call SaveToBank					; swap y vuelve a bank0			>> LoadDataScreens.asm
	echo 			call ConvertPalette								>> LoadDataScreens.asm
	echo+		>> LoadDataScreens.asm
	
	echo 			cp %PackedImages%		; Volcado de pantalla				>> ScreenSelector.asm
	echo 			jp z,SwapS%PackedImages%			; %packedname%		>> ScreenSelector.asm
	echo+ 				>> ScreenSelector.asm

	echo	SwapS%PackedImages%				; %packedname%					>> swappingS.asm
	echo			ld hl,ScrBuffer	+ %desplazamiento%						>> swappingS.asm
	echo			ld (PackedImgpointer),hl						>> swappingS.asm
	echo			ld hl,ScrBuffer + %desplazamiento% + %Nuevodesplazamiento% - 16	>> swappingS.asm
	echo			ld (Palettepoiter),hl						>> swappingS.asm
	echo			ld a,$C7		; Banco Origen						>> swappingS.asm
	echo			call showSplash						>> swappingS.asm
	echo			ret	>> swappingS.asm
	echo+						>> swappingS.asm

	if %PackedImages% == 1 (
		if %screens% == 0 (
			call :ShowPackedUno
		) else (
				echo			; No muestra screen uno >> PackedUno.asm
			)
	)	

	set /a desplazamiento=%desplazamiento% + %Nuevodesplazamiento%

	GOTO:EOF

:ShowPackedUno
	echo			; Muestra primera Screen %packedname%	>> PackedUno.asm
	echo			ld hl,ScrBuffer	+ %desplazamiento%						>> PackedUno.asm
	echo			ld (PackedImgpointer),hl	>> PackedUno.asm
	echo			ld hl,ScrBuffer + %desplazamiento% + %Nuevodesplazamiento% - 16	>> PackedUno.asm
	echo			ld (Palettepoiter),hl	>> PackedUno.asm
	echo			call showSplash	>> PackedUno.asm
	echo		;lights on	>> PackedUno.asm
	echo			call ShowPalette	>> PackedUno.asm
	echo+	>> PackedUno.asm
	GOTO:EOF
