@echo off

:: MEIGA ScriptMod Source agd 2025 por Ramón Fernández Ameijeiras
	echo MEIGA ScriptMod Source agd 2025 por Ramón Fernández Ameijeiras
	echo estamos en...%cd%
	
:: Load program
	if exist ..\AGDScriptMod\agd_scriptmod.py copy ..\AGDScriptMod\agd_scriptmod.py agd_scriptmod.py
	REM if exist ..\AGDScriptMod\Comandos.json copy ..\AGDScriptMod\Comandos.json Comandos.json
	if exist ..\AGDScriptMod\CommandRules.json copy ..\AGDScriptMod\CommandRules.json CommandRules.json
	
	python agd_scriptmod.py "%1"
	
:: Limpieza
	if exist agd_scriptmod.py del agd_scriptmod.py
	if exist CommandRules.json del CommandRules.json
	


