@echo off
rem Esquema de Bancos MODO A
rem ;----0----,----1----,----2!---,----3----,----4----,----5----,----6!---,----7----,
rem ; sistema ,Levelbank, ZERObank,BlockBank,musica FX,ULAbuffer,SplashScr, RoomBank,	MODO shadowSCR B, No usar ZERObank, tampoco SplashScr
rem -----------------------

rem PARA HACER: Modificar sistema para: "no compilar ZBank, no generar cargador ZERO, no incluir secciones Zero en bancos"
rem										"Manejar una MODESQUEMA para activar o desactivar compilado"
rem -----------------------
rem Para hacer Esquema de Bancos VERSION 14
rem ;----0----,----1----,----2!---,----3----,----4----,----5----,----6----,----7----,
rem ; sistema ,Levelbank, sistema , RoomBank,musica FX,ULAbuffer,BlockBank,shadowSCR,	MODO shadowSCR B, No usar ZERObank, tampoco SplashScr

rem setlocal enabledelayedexpansion
rem set "folder_path=%~dp0"
set /a indice=0
set /a indiceZ=0
set /a desplazamiento=0
set /a desplazamientoZ=0
set /a desplazamientoRbank=0
set /a desplazamientoZbank=0
set /a desplazamientoBbank=0
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
		rem echo Total datos en Banco ZERO: %desplazamientoZ%		>> StagesBank.txt
		echo Total datos en Banco de Blocks: %desplazamientoBbank% >> StagesBank.txt
		)
		
	if %mmodel% gtr 1 (
		if %desplazamiento% gtr 16384 (
			echo ERROR: LevelBank excede 16K: %desplazamiento% bytes >> StagesBank.txt
			echo ERROR: LevelBank excede 16K: %desplazamiento% bytes
			)

		if %desplazamientoRbank% gtr 16384 (
			echo ERROR: RoomBank excede 16K: %desplazamientoRbank% bytes >> StagesBank.txt
			echo ERROR: RoomBank excede 16K: %desplazamientoRbank% bytes
			)

		if %desplazamientoBbank% gtr 16384 (
			echo ERROR: BlockBank excede 16K: %desplazamientoBbank% bytes >> StagesBank.txt
			echo ERROR: BlockBank excede 16K: %desplazamientoBbank% bytes
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
			echo 	%nombre%		%%~zm bitesComp		>> StagesBank.txt
			)
		)

	rem ;AGD Selected Sections Sizes
		echo ;%nombre%  			>> SECsizes.asm
		echo SECLEN%indice% equ !size!  			>> SECsizes.asm

	rem ; SECdepack Y Setupsections por Bancos
		set "LbankTipo=Levelbank"
		
	rem ;AGD SECdepack.asm included to de stracted
		rem echo 		ld hl,secbin%indice%			;%nombre%		>> SECdepack.asm
		if "%tipo%" == "Scr" (
			echo 	;%nombre% 			>> SECdepack.asm
			echo 		ld hl,secbin%indice%					>> SECdepack.asm
			set "LbankTipo=RoomBank"
		) else if "%tipo%" == "Blk" (
			echo 	;%nombre% 			>> SECdepack.asm
			echo 		ld hl,secbin%indice%					>> SECdepack.asm
			set "LbankTipo=BlockBank"
		) else (
			echo 	;%nombre% 			>> ZSECdepack.asm
			echo 		ld hl,secbin%indice%					>> ZSECdepack.asm
		)
		if %indice% == 1 (
			rem echo 		ld de,STAGES					>> SECdepack.asm
				if "%tipo%" == "Scr" (
					echo 		ld de,STAGES					>> SECdepack.asm
					echo 		;call zx7bin					>> SECdepack.asm	
					echo 		ld bc,%Nuevodesplazamiento%						;LONG		>> SECdepack.asm
					echo 		ld a,%LbankTipo%				>> SECdepack.asm
					echo 		call SaveToBank					; swap y vuelve a bank0		>> SECdepack.asm
					echo+		>> SECdepack.asm					
				) else if "%tipo%" == "Blk" (
					echo 		ld de,STAGES					>> SECdepack.asm
					echo 		;call zx7bin					>> SECdepack.asm	
					echo 		ld bc,%Nuevodesplazamiento%						;LONG		>> SECdepack.asm
					echo 		ld a,%LbankTipo%				>> SECdepack.asm
					echo 		call SaveToBank					; swap y vuelve a bank0		>> SECdepack.asm
					echo+		>> SECdepack.asm					
				) else (
					echo 		ld de,STAGES					>> ZSECdepack.asm
					echo 		;call zx7bin					>> ZSECdepack.asm	
					echo 		ld bc,%Nuevodesplazamiento%						;LONG		>> ZSECdepack.asm
					echo 		ld a,%LbankTipo%				>> ZSECdepack.asm
					echo 		call SaveToBank					; swap y vuelve a bank0		>> ZSECdepack.asm
					echo+		>> SECdepack.asm					
				)
			) else (
				if "%tipo%" == "Scr" (
					echo        ld de,STAGES + %desplazamientoRbank% >> SECdepack.asm
					rem set "LbankTipo=RoomBank"
					echo 		;call zx7bin					>> SECdepack.asm	
					echo 		ld bc,%Nuevodesplazamiento%						;LONG		>> SECdepack.asm
					echo 		ld a,%LbankTipo%				>> SECdepack.asm
					echo 		call SaveToBank					; swap y vuelve a bank0		>> SECdepack.asm
					echo+		>> SECdepack.asm
				) else if "%tipo%" == "Blk" (
					echo        ld de,STAGES + %desplazamientoBbank% >> SECdepack.asm
					rem set "LbankTipo=BlockBank"
					echo 		;call zx7bin					>> SECdepack.asm	
					echo 		ld bc,%Nuevodesplazamiento%						;LONG		>> SECdepack.asm
					echo 		ld a,%LbankTipo%				>> SECdepack.asm
					echo 		call SaveToBank					; swap y vuelve a bank0		>> SECdepack.asm
					echo+		>> SECdepack.asm
				) else (
					echo        ld de,STAGES + %desplazamiento% >> ZSECdepack.asm
					REM Cargador Banco niveles a parte para evitar desborde de datos
					REM Deberia existir uno para cada banco: PARA DESARROLLAR
					echo 		;call zx7bin					>> ZSECdepack.asm	
					echo 		ld bc,%Nuevodesplazamiento%						;LONG		>> ZSECdepack.asm
					echo 		ld a,%LbankTipo%				>> ZSECdepack.asm
					echo 		call SaveToBank					; swap y vuelve a bank0		>> ZSECdepack.asm
					echo+		>> SECdepack.asm
				)
			)
	
	rem ;AGD Setup Sections
		echo %etiqueta%:							>> Setupsections.asm
		echo ;%tipo%:								>> Setupsections.asm
		if %indice% == 1 (
			echo 		ld hl,STAGES					>> Setupsections.asm
			) else (
				if "%tipo%" == "Scr" (
					echo        ld hl,STAGES + %desplazamientoRbank% >> Setupsections.asm
					echo        ld a,RoomBank >> Setupsections.asm
					echo        ld ^(Lbank^),a >> Setupsections.asm
				) else if "%tipo%" == "Blk" (
					echo        ld hl,STAGES + %desplazamientoBbank% >> Setupsections.asm
					echo        ld a,BlockBank >> Setupsections.asm
					echo        ld ^(Lbank^),a >> Setupsections.asm
				) else (
					echo        ld hl,STAGES + %desplazamiento% >> Setupsections.asm
					REM if "!nombre:~4,-4!" neq "ZERO" (
						REM echo        ld a,ZERObank >> Setupsections.asm
						REM echo        ld ^(Lbank^),a >> Setupsections.asm
					REM ) else (
						REM echo        ld a,Levelbank >> Setupsections.asm
						REM echo        ld ^(Lbank^),a >> Setupsections.asm
					REM )
				)
			)
		echo 		;ld bc,SECLEN%indice%				>> Setupsections.asm
		echo 		jp setup%tipo%						>> Setupsections.asm
		echo 		;ret									>> Setupsections.asm

	rem ;AGD SECtions.asm included to be stracted
		if "%tipo%" == "Scr" (
			echo secbin%indice%							>> SECtions.asm
			echo 		incbin "%nombre_archivo%.zx7"		>> SECtions.asm
		) else if "%tipo%" == "Blk" (
			echo secbin%indice%							>> SECtions.asm
			echo 		incbin "%nombre_archivo%.zx7"		>> SECtions.asm
		) else (
			echo secbin%indice%							>> ZSECtions.asm
			echo 		incbin "%nombre_archivo%.zx7"		>> ZSECtions.asm
		)
	
	if "%tipo%" == "Scr" (
		set /a desplazamientoRbank=%desplazamientoRbank% + %Nuevodesplazamiento%
	) else if "%tipo%" == "Blk" (
		set /a desplazamientoBbank=%desplazamientoBbank% + %Nuevodesplazamiento%
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

