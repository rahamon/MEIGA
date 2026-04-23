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
			if exist TiledAGDMod\DefineObjects.py copy TiledAGDMod\DefineObjects.py "%project_dir%\DefineObjects.py"
			if exist AGDTiledMod%model%\Update_Palette.py copy AGDTiledMod%model%\Update_Palette.py "%project_dir%\Update_Palette.py" 
			if exist AGDTiledMod%model%\Create_Blocks.py copy AGDTiledMod%model%\Create_Blocks.py "%project_dir%\Create_Blocks.py" 
			if exist AGDTiledMod%model%\Create_Objects.py copy AGDTiledMod%model%\Create_Objects.py "%project_dir%\Create_Objects.py"
			if exist AGDTiledMod%model%\Create_Object_image.py copy AGDTiledMod%model%\Create_Object_image.py "%project_dir%\Create_Object_image.py"
	
		:: regresa
			cd /d "%project_dir%"		
		
	:: Redefine Paleta y vuelve a Extraer Gráficos
	:: Advertencia: Si no has generado los bloques de antemano puede borrar Blocks.tsx
	:: Advertencia: Es necesario una paleta standard o la misma que el png
		:: UPDATEPALETTE
			python Update_Palette.py Palette.tsx
			
		:: DEFINEBLOCK y DEFINEOBJECTS
			rem python defineblock.py Blocks.tsx DEFINEBLOCKS.agd
			rem use: python defineblock_ulaplus.py Blocks.tsx DEFINEBLOCKS.agd opciones: --palette=ulaplus --palette=zx
			rem python defineblock_ulaplus.py Blocks.tsx DEFINEBLOCKS.agd --palette=zx
			python DefineBlock.py Blocks.tsx DEFINEBLOCKS.agd paleta_rgb_por_atributo.json
			Python DefineObjects.py Objects.tsx Objects.png DEFINEOBJECT.agd paleta_rgb_por_atributo.json
			
		:: ATRIBUTOS ORIGINALES UPDATEBLOCK y UPDATEOBJECTS
			python Create_Blocks.py DEFINEBLOCKS.agd Blocks.tsx Blocks.png
			python Create_Object_image.py DEFINEOBJECT.agd
			
			REM if exist GAME.agd (
				REM python Create_Blocks.py GAME.agd Blocks.tsx Blocks.png
				REM python Create_Object_image.py GAME.agd
			REM ) else (
				REM python Create_Blocks.py %nombre% Blocks.tsx Blocks.png
				REM python Create_Object_image.py %nombre%			
			REM )
			pause
			
:Terminando
	:: limpieza final
		set FILES=Update_Palette.py Create_Blocks.py DefineBlock.py Create_Object_image.py DefineObjects.py Create_Objects.py

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
		