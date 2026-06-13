@echo off
rem Mide y Crea Slots
set /a MAXSize=0

rem Si el modelo es de 48k usa org en cada sección del volumen ZERO. El modelo lo pasamos en parametro Uno
rem Primero cargar LevelZero y después el resto si queremos eliminar org de la edicion, DEPRECATED
	set ForzeORG=%1

rem distinguir modelo ordenador
	rem Para 48k usar org en nivel Zero, o bien 3 cargas: Loader, Zero y Game. EN DISCUSION
	
Rem Cabecera informe
	echo+		>> StagesBank.txt
	echo Tamaño de Slots para ZERO Bank	(SlotBuilder)	>> StagesBank.txt
	echo ;included in Slots ZERO Player						>> Setupsections.asm
		
rem Primero compila TODAS las secciones.
	rem Necesita symbol.asm para compilar SEC_ZERO_Eve.asm
	echo Precompilacion para Slots
	for %%a in ( "..\Stages\Bank\Sec*.asm" ) do (
				set nombre_Stage=%%~nxa
				set nombre=%%~na
				call :Compila
				)
				
rem Mide y Crea Carrier Slots
	set oldtipo=STAGES
	set oldorg=orgSlotDataCode
rem por cada tipo ( Spr Scr Blk Msg Ene Obj Eve)
	for %%t in (Spr Scr Blk Msg Ene Map Obj Eve) do (
				set "tipo=%%t"
				set /a MAXSize=0
				rem mide 
					call :midetipo
				rem edita ZERO slot de ese tipo
					call :EditaSlot
				rem edita LPlayer Pointers
					call :EditLPointer
				)
rem Primero cargar LevelZero y después el resto si queremos eliminar org de la edicion, DEPRECATED	
	echo orgCOMMONDataCode	equ %oldorg% 	>> SlotOrgs.asm
		
	echo Size of the ZERO memory base %TotalSize% bites (*)		>> StagesBank.txt
	
	REM if %TotalSize% gtr 16384 (
		REM echo warning: it will be truncated to 16bit value by the compiller 	>> StagesBank.txt
		REM echo Bank memory chip capacity exceeded 	>> StagesBank.txt
		REM echo+ 		>> StagesBank.txt
		REM move StagesBank.txt ..\Realase
		REM goto error
		REM )
		
	move StagesBank.txt ..\Realase
	
	GOTO:EOF
	
:error
	echo warning: it will be truncated to 16bit value by the compiller
	echo Bank memory chip capacity exceeded
	pause
	echo end of program
	exit

:Compila
	rem caso Eventos debemos adjutar Symbolos de EngineZX
	if "%nombre_Stage%" == "SEC_ZERO_Eve.asm" (
		rem reserva original
		copy ..\Stages\Bank\SEC_ZERO_Eve.asm ..\Stages\Bank\SEC_ZERO_Eve_temp.asm
		copy Symbol.asm ..\Stages\Bank\
		echo 		include "Symbol.asm" >> ..\Stages\Bank\SEC_ZERO_Eve_temp.asm
		..\tools\Pasmo.exe --bin ..\Stages\Bank\SEC_ZERO_Eve_temp.asm ..\Stages\Bank\SEC_ZERO_Eve.bin
		del ..\Stages\Bank\Symbol.asm
		del ..\Stages\Bank\SEC_ZERO_Eve_temp.asm
	) else (
		if "%nombre:~-3%" == "Eve" (
			rem reserva original
			copy ..\Stages\Bank\%nombre_Stage% ..\Stages\Bank\%nombre%_temp.asm
			copy Symbol.asm ..\Stages\Bank\
			echo 		include "Symbol.asm" >> ..\Stages\Bank\%nombre%_temp.asm
			..\tools\Pasmo.exe ..\Stages\Bank\%nombre%_temp.asm ..\Stages\Bank\%nombre%.bin
			..\tools\zx7 ..\Stages\Bank\%nombre%.bin		>nul
			del ..\Stages\Bank\Symbol.asm
			del ..\Stages\Bank\%nombre%_temp.asm
		) else (
			..\tools\Pasmo.exe --bin ..\Stages\Bank\%nombre_Stage% ..\Stages\Bank\%nombre%.bin			
		)
	)
	GOTO:EOF

:midetipo
rem Por cada seccion de ese tipo Mide los binarios
	for %%a in ( "..\Stages\Bank\*%tipo%.bin" ) do (
				set nombre_Stage=%%~nxa
				set nombre=%%~na
				set size=%%~za
				rem echo %%~na mide: %%~za
				call :Mide
				)
		set /a TotalSize=%TotalSize%+%MAXSize%

	GOTO:EOF

:EditaSlot
	rem Editar Slots.asm ZERO
		if %ForzeORG% == 1 (
			rem echo 		org ^(%tipo%DataCode + %MAXSize%^) 	>> Slots.asm
			echo 		org ^(org%tipo%DataCode^) 	>> Slots.asm
		)
		echo ; %tipo%Slot									>> Slots.asm
		echo %tipo%DataCode	equ $							>> Slots.asm
	rem Primero cargar LevelZero y después el resto si queremos eliminar org de la edicion, DEPRECATED
		rem echo %tipo%DataCode	equ org%tipo%DataCode 			>> Slots.asm
		echo 		include "SEC_ZERO_%tipo%.asm"			>> Slots.asm
		echo+												>> Slots.asm
	rem Primero cargar LevelZero y después el resto si queremos eliminar org de la edicion, DEPRECATED
		if %ForzeORG% gtr 1 (
			echo 		org ^(%tipo%DataCode + %MAXSize%^)		>> Slots.asm
		)
		echo+												>> Slots.asm

		echo 	Slot %tipo% %MAXSize% bites		>> StagesBank.txt
	
:EditaZeroLoader
	rem if "%nombre:~4,-4%" == "ZERO" (		
	rem ;AGD ZeroBankGeneration
		echo ; %nombre:~4,-4%					>> ZEROBank.asm
		echo ; %tipo%Slot					>> ZEROBank.asm
		echo 			ld hl,%tipo%DataCode	>> ZEROBank.asm
		echo 			ld bc,%MAXSize%			>> ZEROBank.asm
		echo 			ld de,%oldtipo%		>> ZEROBank.asm
		echo 			call installZEROBank			>> ZEROBank.asm
		echo+				>> ZEROBank.asm
	rem  	)
		
	rem ;AGD Setup Sections
		echo %nombre%:							>> Old_ZSetupsections.asm
		echo ;%tipo%:								>> Old_ZSetupsections.asm
		echo 			ld hl,%oldtipo%		>> Old_ZSetupsections.asm
		echo 			ld bc,%MAXSize%				>> Old_ZSetupsections.asm
		rem echo 			;ld de,%tipo%DataCode		>> Old_ZSetupsections.asm
		echo 			jp setup%tipo%						>> Old_ZSetupsections.asm
		echo 			;ret									>> Old_ZSetupsections.asm

		set oldtipo=%oldtipo% + %MAXSize%

	rem Primero cargar LevelZero y después el resto si queremos eliminar org de la edicion, DEPRECATED		
	rem Crear origen Slots en SlotOrgs.asm
		echo org%tipo%DataCode	equ %oldorg% 	>> SlotOrgs.asm		
		set oldorg=%oldorg% + %MAXSize%
		
	GOTO:EOF


:Mide	
	if %size% GTR %MAXSize% (
		set /a MAXSize=%size%
		)
	GOTO:EOF

:EditLPointer
rem Por cada archivo en Stage\Mapper
	for %%f in ( "..\Stages\Mapper\map_%tipo%.asm" ) do (
			type "%%f"									>> Pointers.asm
		)
	GOTO:EOF

	