@echo off
rem Escribe ensamblado de Escenarios
set "orgsize=24832 + 9"
set /a slotsize=0

rem Primero compila TODAS las secciones de este juego, localizadas en Bank para hacer mediciones de binarios
	echo compilando TODAS las secciones
	for %%a in ( "..\Stages\Bank\SEC*.asm" ) do (
		set nombre=%%~na
		if "%%~nxa" == "SEC_ZERO_Eve.asm" (
			rem reserva original
			copy ..\Stages\Bank\SEC_ZERO_Eve.asm ..\Stages\Bank\SEC_ZERO_Eve_temp.asm
			copy Symbol.asm ..\Stages\Bank\
			echo 		include "Symbol.asm" >> ..\Stages\Bank\SEC_ZERO_Eve_temp.asm
			..\tools\Pasmo.exe --bin ..\Stages\Bank\SEC_ZERO_Eve_temp.asm ..\Stages\Bank\SEC_ZERO_Eve.bin
			REM ..\tools\zx7 ..\Stages\Bank\SEC_ZERO_Eve.bin		>nul
			del ..\Stages\Bank\Symbol.asm
			del ..\Stages\Bank\SEC_ZERO_Eve_temp.asm
		) else (
			if "!nombre:~-3!" == "Eve" (
				rem reserva original
				copy ..\Stages\Bank\%%~nxa ..\Stages\Bank\%%~na_temp.asm
				copy Symbol.asm ..\Stages\Bank\
				echo 		include "Symbol.asm" >> ..\Stages\Bank\%%~na_temp.asm
				..\tools\Pasmo.exe ..\Stages\Bank\%%~na_temp.asm ..\Stages\Bank\%%~na.bin
				rem ..\tools\zx7 ..\Stages\Bank\%%~na.bin		>nul
				del ..\Stages\Bank\Symbol.asm
				del ..\Stages\Bank\%%~na_temp.asm
			) else (		
				..\tools\Pasmo.exe --bin ..\Stages\Bank\%%~nxa ..\Stages\Bank\%%~na.bin
				REM ..\tools\zx7 ..\Stages\Bank\%%~na.bin		>nul
			)
		)
	)
	echo ok
	
:writeTapeStage
	set Stage=%1
	rem Mide y Edita Carrier Slots
		set Taps=
		set /a Slots=0
		set "oldslot=SlotsDataCode"
	rem por cada tipo ( Spr Scr Blk Msg Ene )
		for %%t in (Spr Scr Blk Msg Ene Map Obj Eve) do (
			set match=0
			set "slot=%%t"
			rem edita slot de ese tipo
				call :CreaSlotTipo
			rem mide 
				set slotsize=0
				call :midetipo
			)
			
rem Por ultimo trae todos los TapStage.asm a ..\Stages
	copy Tap*.asm ..\Stages\		>nul
	
	GOTO:EOF
	exit

:CreaSlotTipo
	rem si existe asm tipo en Selected entonces Añade Slot
		IF exist ..\Stages\Selected\*%slot%.asm (
			if "%slot%" == "Eve" (
				rem añade eventos en una pagina aparte y cuenta pagina
					set /a Taps+=1
					call :addSlot
			) else (
				rem añade normalmente
					call :addSlot
					set /a Slots+=1
					set match=1
			)
		) else (
			rem si no existe en Selected empieza otro tipo en otro Tap
				call :newTap
				rem cuenta las paginas
					if %Slots% gtr 0 (
						set /a Taps+=1
						)
		)
	GOTO:EOF

:addSlot
	for %%a in ( "..\Stages\Selected\*%slot%.asm" ) do (
		set file=%%~nxa
		)
	set "head=Spr"
	if %slot% == %head% (
		call :Tap
	) else (
		call :slotTap
	)
	echo ; %slot%Slot									>> Tap%Stage%%Taps%.asm
	echo %slot%DataCode	equ $							>> Tap%Stage%%Taps%.asm
	echo 		include "%file%"						>> Tap%Stage%%Taps%.asm
	set "oldslot=%slot%DataCode"
	set "orgsize=%orgsize% + %slotsize%"
	GOTO:EOF
	
:newTap
rem nueva pagina
	set "oldslot=%slot%DataCode"
	set "orgsize=%orgsize% + %slotsize%"
	GOTO:EOF
	
:Tap
rem head Tap
	echo ;Stage %Stage% bin Code to be loaded from cinta	>> Tap%Stage%%Taps%.asm
    echo+                                                   >> Tap%Stage%%Taps%.asm
	echo 		org ( 24832 + 0 + 9 )						>> Tap%Stage%%Taps%.asm
    echo+                                                   >> Tap%Stage%%Taps%.asm	
	echo ; ZEROStageData                                    >> Tap%Stage%%Taps%.asm
	echo SlotsDataCode	equ $                               >> Tap%Stage%%Taps%.asm
	GOTO:EOF

:slotTap
rem slot Tap
	echo+													>> Tap%Stage%%Taps%.asm
	echo 		org ( %orgsize% + %slotsize% )				>> Tap%Stage%%Taps%.asm
	REM echo 		org ( %orgsize% + %oldslot% + %slotsize% )				>> Tap%Stage%%Taps%.asm
	echo+													>> Tap%Stage%%Taps%.asm
GOTO:EOF

:midetipo
rem Por cada seccion de ese tipo Mide los binarios del Banco y compara el tamaño, asigna el mayor al tipo
	for %%a in ( "..\Stages\Bank\*%slot%.bin" ) do (
				set size=%%~za
				call :Mide
				)
	GOTO:EOF

:Mide	
	if %size% gtr %slotsize% (
		set slotsize=%size%
		)
	GOTO:EOF
	