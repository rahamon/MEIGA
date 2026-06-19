@echo off

rem limpieza ..\Screens
	if exist *.zx7 del *.zx7		>nul
	if exist *.asm del *.asm		>nul
	if exist mocscreen.scr del mocscreen.scr		>nul
		
set orgmod=%1
set machinmod=%2
set screendos=""
set screenuno=""

rem cabeceras
	echo Lista de pantallas:		>> screenhelp.txt
	echo ; Seccion de datos				>> screens.asm
	echo ; Carga banco Screens			>> LoadDataScreens.asm
	echo ; Screen selector				>> ScreenSelector.asm

rem cuenta screens
	set /a screens=0
	set /a desplazamiento=0
	set /a Nuevodesplazamiento=0
	set screenname=""
	
	for %%f in ("..\Screens\*.scr") do (
		set screenname=%%~nf
		rem por defecto coge el ultimo nombre para scrtap
			set "screenuno=%%f"
		set /a screens+=1
		call :renamescreens		>nul
		if !screens! == 1 (
			call :scrtap		>nul
			pause
			)
		)

rem pie
	echo 			ret				>> ScreenSelector.asm
rem montaje
:main
	rem echo screens:%screens% para mod:%machinmod%
		
	rem if not exist screen.scr
	if %screens% == 0 (
		call :scempty		>nul
		set /a screens=1
		)
	if %machinmod% == 1 (
		rem echo scrtap
		call :scrtap		>nul
		)
	if %machinmod% gtr 1 (
		rem echo modelos 128k:
		rem echo
		call :scrbanks		>nul
		)
	
	rem edita helper
		echo+		>> screenhelp.txt
		echo Invoke screens with the following instruction:		>> screenhelp.txt
		echo+		>> screenhelp.txt
		echo 			LET RND = 1		>> screenhelp.txt
		echo 			CALL 24838		>> screenhelp.txt
		echo+		>> screenhelp.txt
		echo Includes five screens (.scr) (if you need) in the screens directory >> screenhelp.txt
		echo Advanced: You can section into 3 parts to incorporate them	>> screenhelp.txt
		echo then in 3 different positions according to the included diagram		>> screenhelp.txt
		echo in the VIDEO DATA.xlsx schema in the Release directory		>> screenhelp.txt
		echo+
		
	
	rem incluye helper text in Realase
		move screenhelp.txt ..\Realase\		>nul
		if not exist "..\Realase\VIDEO DATA.xlsx" (
			copy "..\AGDscreenMod\VIDEO DATA.xlsx" ..\Realase\		>nul
			)
rem fin
:fin
	rem añadir a loader: LOAD "SCB"CODE 32000: RANDOMIZE USR 32000
	GOTO:EOF
	exit
	
:scrtap
	rem Crea SC.tap
		..\tools\bin2tap -a 16384 "%screenuno%" -o SC.tap		>nul
	rem limpia mocscreen
		if exist mocscreen.scr del mocscreen.scr		>nul
		echo SC.bat generada
	GOTO:EOF
	
:scempty
	rem crea screen fantasma
		copy ..\AGDscreenMod\mocscreen0.scr ..\Screens\mocscreen.scr	>nul
		set "screenuno=mocscreen.scr"
		echo ;empty	swappingS					>> swappingS.asm
		echo 1.- screen vacio		>> screenhelp.txt
	GOTO:EOF

:scrbanks
	rem crea bankS
		copy ..\AGDscreenMod\bankS.asm ..\Screens\		>nul
		copy ..\AGDscreenMod\routines.asm ..\Screens\		>nul
		copy ..\AGDscreenMod\zx7.asm ..\Screens\		>nul
		if %orgmod% == 1 (
			rem ..\tools\fart bankSdriver.asm 24832 32000
			..\tools\fart bankS.asm 24832 32000		>nul
			)
		..\tools\Pasmo.exe --tap --name screens bankS.asm SCB.tap		>nul
		call :printlist bankS		>nul
	rem informe tamano banco
		echo Tamaño del banco de screens %desplazamiento%		>> screenhelp.txt
		if %desplazamiento% gtr 16384 (
			echo Tamaño del banco de screens %desplazamiento%
			echo Limite de Banco de Screens superado!
			echo Limite de Banco de Screens superado!		>> screenhelp.txt
			)
	GOTO:EOF

:printlist
	copy "%1.asm" ..\sjasmplus\		>nul
	copy ..\..\user.asm ..\sjasmplus\		>nul
	if exist ..\..\UserRoutines\*.asm copy ..\..\UserRoutines\*.asm ..\sjasmplus\		>nul
	rem copy leader.txt+%1.asm+trailer.txt agdcode.asm
	..\SjasmPlus\sjasmplus.exe "%1.asm" --lst=list.txt		>nul
	move list.txt "..\Realase\%1.txt.asm"	>nul
	GOTO:EOF

:renamescreens
	rem Pre-Compilation...
	..\tools\zx7 "%screenname%.scr"		>nul
	
	for %%m in ( "%screenname%.scr.zx7" ) do (
		set /a Nuevodesplazamiento=%%~zm
		echo screen %screens%:		pantalla %screenname%. %%~zm bite	>> screenhelp.txt
		)
		
	echo screeninc%screens%:		; presentacion pantalla %screenname%.		>> screens.asm
	echo 			incbin	"%screenname%.scr.zx7"							>> screens.asm
	echo+		>> screens.asm

	echo 			; carga presentación pantalla %screens%.			>> LoadDataScreens.asm
	echo 			; por cada pantalla en screens directory:			>> LoadDataScreens.asm
	echo 			; carga presentación pantalla %screenname%.			>> LoadDataScreens.asm
	echo 			ld hl,screeninc%screens%			>> LoadDataScreens.asm
	echo 			ld de,$c000 + %desplazamiento%			>> LoadDataScreens.asm
	rem echo 			ld de,$c000 + (%screens%-1)*2800				; org %desplazamiento%			>> LoadDataScreens.asm
	echo 			ld bc,%Nuevodesplazamiento%						;LONGSCREENS equ 2796 aprox			>> LoadDataScreens.asm
	echo 			ld a,Databank			>> LoadDataScreens.asm
	echo 			call SaveToBank					; swap y vuelve a bank0			>> LoadDataScreens.asm
	echo+		>> LoadDataScreens.asm
	
	echo 			cp %screens%		; Volcado de pantalla				>> ScreenSelector.asm
	echo 			jp z,SwapS%screens%			; %screenname%		>> ScreenSelector.asm
	echo+ 				>> ScreenSelector.asm

	echo	SwapS%screens%				; %screenname%					>> swappingS.asm
	echo			ld hl,$c000	+ %desplazamiento%						>> swappingS.asm
	rem echo			ld hl,$c000	+ (%screens%-1)*2800	; desde origen screen2						>> swappingS.asm
	echo			ld a,Screenbank		; Banco Origen						>> swappingS.asm
	echo			call showSplash						>> swappingS.asm
	echo			ret						>> swappingS.asm
	echo+						>> swappingS.asm

	set /a desplazamiento=%desplazamiento% + %Nuevodesplazamiento%
	
	GOTO:EOF
