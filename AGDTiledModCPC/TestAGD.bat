@echo off
		
	:: Test
		if exist GAME.agd (
			cd "%meiga_dir%
			copy /Y "%current_dir%\GAME.agd" "Suite ZX\AGDsource\GAME.agd"
			cd "Suite ZX"
			rem ReloadZX GAME 0 0 test 0 0
			Build GAME
			)