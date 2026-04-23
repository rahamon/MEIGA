@echo off
		
	:: configuracion inicial
		setlocal enabledelayedexpansion
		set "model="
		
	:: Obtiene el directorio actual
		set "current_dir=%cd%"
		
	:: Leer las variables de seleccion
		call seleccion

		if "%project_name%" == "" exit
		if not "%current_dir%" == "%project_dir%" exit

	:: Load TiledAGDMod
		:: desde meiga
			cd /d "%meiga_dir%"
			if exist TiledAGDMod\DefineBlock.py copy TiledAGDMod\DefineBlock.py "%project_dir%\DefineBlock.py"
			if exist AGDTiledMod%model%\Create_Blocks.py copy AGDTiledMod%model%\Create_Blocks.py "%project_dir%\Create_Blocks.py"
			if exist AGDTiledMod%model%\Update_Palette.py copy AGDTiledMod%model%\Update_Palette.py "%project_dir%\Update_Palette.py" 
		:: regresa
			cd /d "%project_dir%"		
		
	:: Reordena: Define y vuelve a Crear
	:: Advertencia: Es necesario una paleta standard o la misma que el png
		:: UPDATEPALETTE dudo si es necesario
			python Update_Palette.py Palette.tsx
			
		:: DEFINEBLOCK
			rem python defineblock.py Blocks.tsx DEFINEBLOCKS.agd
			rem use: python defineblock_ulaplus.py Blocks.tsx DEFINEBLOCKS.agd opciones: --palette=ulaplus --palette=zx
			rem python defineblock_ulaplus.py Blocks.tsx DEFINEBLOCKS.agd --palette=zx
			python DefineBlock.py Blocks.tsx DEFINEBLOCKS.agd paleta_rgb_por_atributo.json

		:: CREATEBLOCK
			rem python Create_Blocks.py "%nombre%" Blocks.tsx Blocks.png
			python Create_Blocks.py DEFINEBLOCKS.agd Blocks.tsx Blocks.png --no-duplicates
			pause
:Terminando
	:: limpieza final
		set FILES=Create_Blocks.py DefineBlock.py

		rem Recorrer archivos y borrarlos
		for %%F in (%FILES%) do (
			if exist "%%F" (
				del "%%F"
			) else (
				echo Archivo no encontrado: %%F
			)
		)
		
	GOTO:EOF
	EXIT		
		