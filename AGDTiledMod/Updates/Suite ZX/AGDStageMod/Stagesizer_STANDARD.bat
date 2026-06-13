@echo off
rem setlocal enabledelayedexpansion
rem set "folder_path=%~dp0"
set /a indice=0
set /a indiceZ=0
set /a desplazamiento=0
set /a desplazamientoZ=0
set /a desplazamientoRbank=0
set /a desplazamientoZbank=0
set /a Nuevodesplazamiento=0
set "offset="
rem /f "tokens=*"

rem Cabeceras
	echo ;included in Player/bank7driver			>> SECsizes.asm
	echo ;included in Player						>> Setupsections.asm
	echo ;included in bank7driver					>> SECdepack.asm
	echo ;included in bank7driver					>> SECtions.asm
	if %mmodel% gtr 1 (
		echo Uso de memoria en Bancos		>> StagesBank.txt
		)
rem Por cada Seccion bin en Stages\Bank
	for %%a in ("..\Stages\Bank\*.bin") do (
		set archivo=%%a
		set nombre_archivo=%%~nxa
		rem nombre sin extension
		set nombre=%%~na
		set size=%%~za
		rem Mejor NO DISTINGUIR ZERO de los demás
			rem	if "!nombre:~4,-4!" neq "ZERO" (
			rem		call :writeasm
			rem	) else (
			rem		call :writeasmZ
			rem		)
			
		call :writeasm
	)

:medicion_limite
rem medicion limite
	if %mmodel% gtr 1 (
		echo Total datos en Banco de niveles: %desplazamiento%		>> StagesBank.txt
		echo Total datos en Banco de Rooms: %desplazamientoRbank%		>> StagesBank.txt
		echo Total datos en Banco ZERO: %desplazamientoZ%		>> StagesBank.txt
		)
		
	if %mmodel% gtr 1 (
		if %desplazamiento% gtr 16384 (
			echo Bank memory chip capacity exceeded for model %mmodel%		>> StagesBank.txt
			echo+ 		>> StagesBank.txt
			echo Try another Compilation, Bank memory chip capacity exceeded for model %mmodel%
			)
		)
	if %mmodel% gtr 1 (
		if %desplazamientoZ% gtr 16384 (
			echo Bank ZERO memory chip capacity exceeded for model %mmodel%		>> StagesBank.txt
			echo+ 		>> StagesBank.txt
			echo Try another Compilation, Bank ZERO memory chip capacity exceeded for model %mmodel%
			)
		)
		
goto fin

rem pie

:fin
	goto:eof

:writeasm
	set /a oldindice=indice
	set /a indice+=1
	rem set etiqueta=%nombre:~0,-4%
	set etiqueta=%nombre%
	set tipo=%nombre:~-3%
			
	if %indice% gtr 1 ( set "offset=%offset% + SECLEN%oldindice%" )

rem calculo desplazamiento en banco
	for %%m in ( "%archivo%.zx7" ) do (
		set /a Nuevodesplazamiento=%%~zm
			if %mmodel% gtr 1 (
			echo 	%nombre%		%%~zm bites		>> StagesBank.txt
			)
		)

	rem ;AGD Selected Sections Sizes
		echo ;%nombre%  			>> SECsizes.asm
		echo SECLEN%indice% equ !size!  			>> SECsizes.asm

	rem ; SECdepack Y Setupsections por Bancos
		set "LbankTipo=Levelbank"
		
	rem ;AGD SECdepack.asm included to de stracted
		echo 		ld hl,secbin%indice%			;%nombre%		>> SECdepack.asm
		if %indice% == 1 (
			echo 		ld de,STAGES					>> SECdepack.asm
			) else (
				if "%tipo%" == "Scr" (
					echo 		ld de,STAGES + %desplazamientoRbank%			>> SECdepack.asm
					set "LbankTipo=RoomBank"
				) else (
					echo 		ld de,STAGES + %desplazamiento%			>> SECdepack.asm
				)
			)
		echo 		;call zx7bin							>> SECdepack.asm	
		echo 		ld bc,%Nuevodesplazamiento%						;LONGSCREENS equ 2796 aprox			>> SECdepack.asm
		echo 		ld a,%LbankTipo%			>> SECdepack.asm
		echo 		call SaveToBank					; swap y vuelve a bank0			>> SECdepack.asm
		echo+		>> SECdepack.asm
	
	rem ;AGD Setup Sections
		echo %etiqueta%:							>> Setupsections.asm
		echo ;%tipo%:								>> Setupsections.asm
		if %indice% == 1 (
			echo 		ld hl,STAGES					>> Setupsections.asm
			) else (
				if "%tipo%" == "Scr" (
					echo 		ld hl,STAGES + %desplazamientoRbank%			>> Setupsections.asm
					echo 		ld a,RoomBank			>> Setupsections.asm
					echo 		ld ^(Lbank^),a			>> Setupsections.asm		
				) else (
					echo 		ld hl,STAGES + %desplazamiento%			>> Setupsections.asm
				)
			)
		echo 		;ld bc,SECLEN%indice%				>> Setupsections.asm
		echo 		jp setup%tipo%						>> Setupsections.asm
		echo 		;ret									>> Setupsections.asm

	rem ;AGD SECtions.asm included to be stracted
		echo secbin%indice%							>> SECtions.asm
		echo 		incbin "%nombre_archivo%.zx7"		>> SECtions.asm
		
	if "%tipo%" == "Scr" (
		set /a desplazamientoRbank=%desplazamientoRbank% + %Nuevodesplazamiento%
	) else (
		set /a desplazamiento=%desplazamiento% + %Nuevodesplazamiento%
	)
	goto:eof
	
:writeasmZ
	set /a oldindiceZ=indiceZ
	set /a indiceZ+=1
	rem set etiqueta=%nombre:~0,-4%
	set etiqueta=%nombre%
	set tipo=%nombre:~-3%
			
	if %indiceZ% gtr 1 ( set "offset=%offset% + SECLEN%oldindiceZ%" )

rem calculo desplazamiento en bancoZ
	for %%m in ( "%archivo%.zx7" ) do (
		set /a Nuevodesplazamiento=%%~zm
			if %mmodel% gtr 1 (
			echo 	%nombre%		%%~zm bites		>> StagesBank.txt
			)
		)

	rem ;AGD Selected Sections Sizes
		echo ;%nombre%  			>> ZSECsizes.asm
		echo SECLEN%indiceZ% equ !size!  			>> ZSECsizes.asm

	rem ; SECdepack Y Setupsections por Bancos
		set "LbankTipo=ZERObank"
		
	rem ;AGD SECdepack.asm included to de stracted
		echo 		ld hl,secbin%indiceZ%			;%nombre%		>> ZSECdepack.asm
		if %indiceZ% == 1 (
			echo 		ld de,STAGES					>> ZSECdepack.asm
		) else (
			echo 		ld de,STAGES + %desplazamientoZ%			>> ZSECdepack.asm
			)
		echo 		;call zx7bin							>> ZSECdepack.asm	
		echo 		ld bc,%Nuevodesplazamiento%						;LONGSCREENS equ 2796 aprox			>> ZSECdepack.asm
		echo 		ld a,%LbankTipo%			>> ZSECdepack.asm
		echo 		call SaveToBank					; swap y vuelve a bank0			>> ZSECdepack.asm
		echo+		>> ZSECdepack.asm
	
	rem ;AGD Setup Sections
		echo %etiqueta%:							>> Setupsections.asm
		echo ;%tipo%:								>> Setupsections.asm
		if %indiceZ% == 1 (
			echo 		ld hl,STAGES					>> Setupsections.asm
		) else (
			echo 		ld hl,STAGES + %desplazamientoZ%			>> Setupsections.asm
			)
		echo 		;ld bc,SECLEN%indiceZ%				>> Setupsections.asm
		echo 		jp setup%tipo%						>> Setupsections.asm
		echo 		;ret									>> Setupsections.asm

	rem ;AGD SECtions.asm included to be stracted
		echo secbin%indiceZ%							>> ZSECtions.asm
		echo 		incbin "%nombre_archivo%.zx7"		>> ZSECtions.asm
		

	set /a desplazamientoZ=%desplazamientoZ% + %Nuevodesplazamiento%

	goto:eof
	
exit

