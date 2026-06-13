@echo off
rem Compila un volumen de cinta con los Escenarios
rem +++ obligar a 6 caracteres por nombre
rem CARA B
	set /a indice=0
	set indZERO=
rem Cabecera Selector

rem Volumen Cabecera
	echo ;World										>> Taps.asm
	echo Cassette tape volume:						>> Taps.txt
rem Setup cabecera
	echo ;setup nombres de pista en cinta			>> SetupTaps.asm
	
:main	
rem Por cada Stage ***
	for %%f in ("..\Stages\Stage_*.asm") do (
		set Stagename=%%~nf
		echo Stage: %%~nf
		set /a pages=0
		call :pagescount
		call :AddTap
		)
	echo+ 		>> Taps.txt
	echo		Use in your scripts:		>> Taps.txt
	echo			LET A = n			; n = Stage to Select 		>> Taps.txt
	echo			CALL 24835			; para LOAD""CODE		>> Taps.txt
	move Taps.txt ..\Realase		>nul
	echo 		ret		>> Tapselector.asm
	
	echo lastStage defb %indZERO%	; TapZERO by default	>> Taps.asm
	goto:eof
exit

:AddTap	
		call :ListSelection
		call :setupname
rem Por cada Tap del Stage ***
	for %%a in ("..\Stages\Tap%Stagename:~6%*.asm") do (
		set archivo=%%a
		set nombre_archivo=%%~nxa
		rem nombre sin extension
		set Tapename=%%~na
		set size=%%~za
		rem
		rem
		set /a pages-=1
		call :Tapename
		call :Compilepage
	)
	
:pagescount
	for %%a in ("..\Stages\Tap%Stagename:~6%*.asm") do (
		set /a pages+=1
	)
	goto:eof

:ListSelection
	set /a indice+=1
	rem ;AGD Stage Selector
		echo 		cp %indice%		>> Tapselector.asm
		echo 		jp z,Tape%indice%		>> Tapselector.asm
	goto:eof

:setupname
		set Tapename=%Stagename:~6%
		echo %indice%: Tap %Stagename:~6%		>> Taps.txt
		if "%Tapename%" == "ZERO" (
			set indZERO=%indice%
			)
	rem Por cada Tap Generada en Stages
		echo Tape%indice%		>> SetupTaps.asm
	rem prepara firstGame si TapeZERO para cargar juego desde inicio jp game
		if "%Tapename%" == "ZERO" (
			echo 		;xor a 				>> SetupTaps.asm
			echo 		;ld ^(FirstGame^),a  >> SetupTaps.asm
			)
		echo 		ld hl,Tap%Tapename%		>> SetupTaps.asm
		echo 		jp setupStageTape		>> SetupTaps.asm
	goto:eof

:Tapename
	rem Por cada Tap Generada en Stages
		echo Tap%Tapename:~3%		>> Taps.asm
		set "Tapename=%Tapename%000000000"
		echo 		defb %pages%,"%Tapename:~3,9%"	>> Taps.asm
		echo			#%Tapename:~3,9%		>> Taps.txt
	goto:eof

:Compilepage
	rem trae tap (ejemplo TapInicio1.asm) a ..\AssemblyStage\
		copy ..\Stages\%nombre_archivo% ..\AssemblyStage\		>nul
		rem echo Pasmo --tap --name %Tapename:~3,9% ..\Stages\%nombre_archivo% %Tapename:~3,9%.tap
		if not "%nombre_archivo%" == "Symbol*.asm" (
			rem echo %nombre_archivo% y Tapename:%Tapename:~3,9%
			rem echo ..\Tools\Pasmo --tap --name %Tapename:~3,9% %nombre_archivo% Tap%Tapename:~3,9%.tap
			..\Tools\Pasmo --tap --name %Tapename:~3,9% %nombre_archivo% %Tapename:~3,9%.tap
			rem debug task
				rem ..\SjasmPlus\sjasmplus.exe %nombre_archivo% --lst=%Tapename:~3,9%.txt
				rem copy %Tapename:~3,9%.txt ..\Realase\
		)
		
	goto:eof
	

