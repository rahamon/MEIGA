rem Procesos: Separa Secciones de Datos del archivo deleteme.asm. (Selector)
rem Organiza Secciones en Slots primero y Comunes despues.

@echo off
	rem Nombre del Stage de juego (ejemplo:game)
		set Stage=%1
:main
	rem prepara archivo fuente para seccionar		
		rem Archivo fuente MEIGA patch
			set source_file=deleteme.asm
			rem set source_file=GAME.asm

		rem Crea archivo temporal
			set "objfile=%Stage%"
			rem crea archivo temporal (ejemplo: game.asm)
				copy %source_file% %objfile%.asm		>nul
	goto Stage

:All		
	REM Separa TODO el Stage
		set "desde=WINDOW"
		set "hasta=SIMASK"
		set tipo=All
		rem Preparativos Cabecera
			rem echo include "Ptr_%Stage%.asm" >> SEC_%Stage%_%tipo%.asm
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%) >> SEC_%Stage%_%tipo%.asm
			rem echo %tipo%_%Stage%_Instaler   equ $ >> SEC_%Stage%_%tipo%.asm
			rem echo include "%tipo%_%Stage%_installer.asm" >> SEC_%Stage%_%tipo%.asm
		rem Extrae
			call :Selector
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm		
		
:Stage
	REM Stage definido solo por Sprites
		call :SecSPR
	rem Retoques de codigo	
		rem ..\tools\fart %tipo%_%Stage%.asm "defb" "	defb"
		rem ..\tools\fart %tipo%_%Stage%.asm "defw" "	defw"
	rem Crear Stage0.asm Seleccionar al fin y al cabo aquí...
		rem Copy %tipo%_%Stage%.asm Stage0.asm
		rem del %tipo%_%Stage%.asm
		rem ..\tools\fart --remove --c-style Stage0.asm "\xA0"

:CommonData	
	rem Montaje de Common Data secciones: SOLO UNA VEZ
		rem Por cada archivo en Stage\Common, de Stage
		call :SecMAP
		call :SecEVE
		call :Arcade
		call :SecMSG
		call :SecSCR
		call :SecBLK
		call :SecENE
		call :SecOBJ
		call :Enviroment
		call :Engine

rem Por cada archivo en Stage\Common, de Stage
	rem del %Stage%.asm
	REM for %%f in (
		REM Map_%Stage%.asm 
		REM Eve_%Stage%.asm 
		REM Arc_%Stage%.asm
		REM Msg_%Stage%.asm 
		REM Scr_%Stage%.asm 
		REM Blk_%Stage%.asm
		REM Ene_%Stage%.asm			
		REM Obj_%Stage%.asm 
		REM Env_%Stage%.asm 
		REM ) do (
			REM echo %%f
			REM type "%%f" >> CommonData.asm
		REM )
	REM ..\tools\fart --remove --c-style CommonData.asm "\xA0"
	rem ..\tools\fart CommonData.asm "defb" "	defb"
	rem ..\tools\fart CommonData.asm "defw" "	defw"
Rem fin de Stage
	rem del *_%Stage%.asm
	goto Fin
		
:StageZero
:SecSPR
	REM Separa seccion Sprites
		set desde=sprgfx
		set hasta=nmedat
		rem Seccion
			set tipo=Spr
		rem Preparativos Cabecera
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_%tipo%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%)	;org+0 >> SEC_%Stage%_%tipo%.asm
			echo prgfx_ptr			defw sprgfx		;org+2 >> SEC_%Stage%_%tipo%.asm
			echo frmlst_ptr			defw frmlst		;org+4 >> SEC_%Stage%_%tipo%.asm
			echo %tipo%_of	defb 1 			;Sprites org+6 >> SEC_%Stage%_%tipo%.asm
		rem Extrae
			call :Selector
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm	
	GOTO:EOF

:CommonA
:SecMAP
	rem *** Añadir formato aqui map ***
	REM Separa seccion Game-Map
		set desde=MAPWID
		set hasta=evnt00
		rem Seccion
			set tipo=Map
		rem Preparativos Cabecera
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_%tipo%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%)	;org+0 >> SEC_%Stage%_%tipo%.asm
			echo MAPWID_ptr	defb MAPWID		;org+2 >> SEC_%Stage%_%tipo%.asm
			echo 		defb 0			;org+3 >> SEC_%Stage%_%tipo%.asm
			echo mapdat_ptr	defw mapdat		;org+4 >> SEC_%Stage%_%tipo%.asm
			echo %tipo%_of	defb 6 				;Map org+6 >> SEC_%Stage%_%tipo%.asm
			echo 		defb 0			;org+7 >> SEC_%Stage%_%tipo%.asm
			echo stmap_ptr	defw stmap		;org+8 >> SEC_%Stage%_%tipo%.asm
			echo mapdat_menos_MAPWID_cal_ptr defw mapdata_addr	;org+10 >> SEC_%Stage%_%tipo%.asm
			echo mapdata_addr equ $	>> SEC_%Stage%_%tipo%.asm
		rem Extrae
			call :Selector
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm	
	GOTO:EOF
	
:Engine
	REM Separa Engine
		set desde=SIMASK
		set "hasta=eop   "
		rem Seccion
			set tipo=Eng
		rem Preparativos Cabecera
		rem Extrae
			call :Selector
		rem Preparativos Pie
		rem Crea Engine0
			Copy SEC_%Stage%_%tipo%.asm Engine0.asm		>nul
			if exist SEC_%Stage%_%tipo%.asm del SEC_%Stage%_%tipo%.asm		>nul
			REM ..\tools\fart -C Engine0.asm "\xA0" ","
			..\tools\fart --remove --c-style Engine0.asm "\xA0"		>nul
			..\tools\fart --remove --c-style Engine0.asm "ECHO est\xA0 desactivado."		>nul
			..\tools\fart --remove --c-style Engine0.asm "ECHO est desactivado."		>nul
			rem ..\tools\fart --remove Engine0.asm "ECHO est desactivado."
			
	GOTO:EOF

:SecBLK	
	REM Separa seccion Blocks
		set "desde=chgfx "
		set "hasta=sprgfx"
		rem Seccion
			set tipo=Blk
		rem Preparativos Cabecera
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_%tipo%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%)	;org+0 >> SEC_%Stage%_%tipo%.asm
			echo chgfx_ptr			defw chgfx		;org+2 >> SEC_%Stage%_%tipo%.asm
			echo bcol_ptr			defw bcol		;org+4 >> SEC_%Stage%_%tipo%.asm
			echo %tipo%_of	defb 3 			;blocks org+6 >> SEC_%Stage%_%tipo%.asm
			echo 			defb 0							>> SEC_%Stage%_%tipo%.asm
			echo bprop_ptr			defw bprop		;org+8 >> SEC_%Stage%_%tipo%.asm
		rem Extrae
			call :Selector
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm
	GOTO:EOF
	
:SecSCR
	REM Separa seccion Screens
		set "desde=scdat "
		set "hasta=chgfx "
		rem Seccion
			set tipo=Scr
		rem Preparativos Cabecera
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_%tipo%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%)	;org+0 >> SEC_%Stage%_%tipo%.asm
			echo scdat_ptr			defw scdat		;org+2 >> SEC_%Stage%_%tipo%.asm
			echo numsc_ptr			defw numsc		;org+4 >> SEC_%Stage%_%tipo%.asm
			echo %tipo%_of	defb 2 			;screens org+6 >> SEC_%Stage%_%tipo%.asm
			echo 			defb 0					;org+7 >> SEC_%Stage%_%tipo%.asm
			
			echo wntopx_cal_ptr 	defb (8 * WINDOWTOP)	;org+8 >> SEC_%Stage%_%tipo%.asm
			echo wnlftx_cal_ptr 	defb (8 * WINDOWLFT)	;org+9 >> SEC_%Stage%_%tipo%.asm
			echo wnbotx_cal_ptr 	defb ((WINDOWTOP * 8) + (WINDOWHGT * 8) - 16)	;org+10 >> SEC_%Stage%_%tipo%.asm
			echo wnrgtx_cal_ptr 	defb ((WINDOWLFT * 8) + (WINDOWWID * 8) - 16)	;org+11 >> SEC_%Stage%_%tipo%.asm	
			
 			echo wintop_ptr			defb WINDOWTOP		;org+12 >> SEC_%Stage%_%tipo%.asm	
			echo winlft_ptr			defb WINDOWLFT		;org+13 >> SEC_%Stage%_%tipo%.asm	
			echo winhgt_ptr			defb WINDOWHGT		;org+14 >> SEC_%Stage%_%tipo%.asm	
			echo winwid_ptr			defb WINDOWWID		;org+15 >> SEC_%Stage%_%tipo%.asm	
		rem Extrae
			call :Selector
			
		rem añade variables PARRILLA DE juego
			set "desde=WINDOW"
			set "hasta=MAPWID"
			call :Selector			
			
		rem añade Map
		
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm	
	GOTO:EOF

:SecENE		
	REM Separa seccion Sprites position in Screen (nmedat)
		set desde=nmedat
		set hasta=NUMOBJ
		rem Seccion
			set tipo=Ene
		rem Preparativos Cabecera
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_%tipo%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%)	;org+0 >> SEC_%Stage%_%tipo%.asm
			echo nmedat_ptr		defw nmedat			;org+2 >> SEC_%Stage%_%tipo%.asm
			echo 				defs 2,0			;org+4 >> SEC_%Stage%_%tipo%.asm
			echo %tipo%_of		defb 5		;enemies org+6 >> SEC_%Stage%_%tipo%.asm
		rem Extrae
			call :Selector
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm	
	GOTO:EOF

:CommonB
:SecEVE
	REM Separa seccion events
		set desde=evnt00
		set hasta=evnt09
		rem Seccion
			set tipo=Eve
		rem Preparativos Cabecera
			echo 		;include "Symbol.asm" >> SEC_%Stage%_%tipo%.asm
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_%tipo%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%)	;org+0 >> SEC_%Stage%_%tipo%.asm
			echo evnt00_ptr		defw evnt00			;org+2 >> SEC_%Stage%_%tipo%.asm	
			echo evnt01_ptr		defw evnt01			;org+4 >> SEC_%Stage%_%tipo%.asm	
			echo %tipo%_of		defb 7		;events	org+6 >> SEC_%Stage%_%tipo%.asm
			echo 			defb 0					;org+7 >> SEC_%Stage%_%tipo%.asm
			echo evnt02_ptr		defw evnt02			;org+8 >> SEC_%Stage%_%tipo%.asm
			echo evnt03_ptr     defw evnt03			;org+10 >> SEC_%Stage%_%tipo%.asm
			echo evnt04_ptr     defw evnt04			;org+12 >> SEC_%Stage%_%tipo%.asm
			echo evnt05_ptr     defw evnt05			;org+14 >> SEC_%Stage%_%tipo%.asm
			echo evnt06_ptr     defw evnt06			;org+16 >> SEC_%Stage%_%tipo%.asm
			echo evnt07_ptr     defw evnt07			;org+18>> SEC_%Stage%_%tipo%.asm
			echo evnt08_ptr     defw evnt08			;org+20 >> SEC_%Stage%_%tipo%.asm
		rem Extrae
			call :Selector
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm	
	GOTO:EOF
		
:Arcade
	REM Separa seccion Common Arcade
		set desde=evnt09
		set hasta=msgdat
		rem Seccion
			set tipo=Arc
		rem Preparativos Cabecera
		rem Extrae
			call :Selector
		rem Preparativos Pie
	GOTO:EOF
:SecMSG		
	REM Separa seccion Mensajes
		set desde=msgdat
		set "hasta=scdat "
		rem Seccion
			set tipo=Msg
		rem Preparativos Cabecera
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_%tipo%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%)	;org+0 >> SEC_%Stage%_%tipo%.asm
			echo msgdat_ptr		defw msgdat			;org+2 >> SEC_%Stage%_%tipo%.asm
			echo 				defs 2,0			;org+4 >> SEC_%Stage%_%tipo%.asm
			echo %tipo%_of		defb 4		;messages org+6 >> SEC_%Stage%_%tipo%.asm
		rem Extrae
			call :Selector
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm	
	GOTO:EOF

:SecOBJ
	REM Separa seccion Objects
		set desde=NUMOBJ
		set hasta=palett
		rem Seccion
			set tipo=Obj
		rem Preparativos Cabecera
			echo ORG_%Stage%_%tipo% equ $ >> SEC_%Stage%_%tipo%.asm
			echo longofdata_%Stage%_%tipo%_ptr defw (EndofDataCode%Stage%_%tipo% - ORG_%Stage%_%tipo%)	;org+0 >> SEC_%Stage%_%tipo%.asm
			echo NUMOBJ_ptr		defb NUMOBJ			;org+2 >> SEC_%Stage%_%tipo%.asm
			echo 				defb 0				;org+3 >> SEC_%Stage%_%tipo%.asm
			echo objdta_ptr		defw objdta			;org+4 >> SEC_%Stage%_%tipo%.asm
			echo %tipo%_of		defb 6		;messages org+6 >> SEC_%Stage%_%tipo%.asm
		rem Extrae
			call :Selector
		rem Preparativos Pie
			echo EndofDataCode%Stage%_%tipo% >> SEC_%Stage%_%tipo%.asm
	GOTO:EOF

:Enviroment
	REM Separa seccion Common Enviroment
		set desde=palett
		set hasta=SIMASK
		rem Seccion
			set tipo=Env
		rem Preparativos Cabecera
		rem Extrae
			call :Selector
		rem Preparativos Pie
	GOTO:EOF		

:Fin
	rem limpieza archivo temporal
		del %objfile%.asm
		GOTO:EOF
		exit

:Selector
	Rem Selector de datos:
	@echo off
	set sIni=%desde%
	set sFin=%hasta%
	set fListadoCorte=%objfile%.asm
	rem extraer
		@echo off
		rem  "tokens=*" "delims=·"
		setlocal enabledelayedexpansion
		set fichero=
		for /f "delims=·" %%x in (%fListadoCorte%) do (
			set "line=%%x"
			if "!line:~0,6!"=="!sIni!" (
				set "fichero=%tipo%_%Stage%.asm"
				)
			if not "!line:~0,6!"=="!sFin!" (
				if "!fichero!"=="%tipo%_%Stage%.asm" (
					echo !line! >> SEC_%Stage%_%tipo%.asm
					)
				) else ( goto cortado )
			)
			
: cortado
GOTO:EOF


