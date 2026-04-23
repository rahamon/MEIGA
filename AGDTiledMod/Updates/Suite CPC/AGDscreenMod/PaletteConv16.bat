@echo off
setlocal enabledelayedexpansion

:: Definir el nombre del archivo de entrada y salida
set input_file=TestJoda.asm
set output_file=TestJoda_Modificado.asm

:: Verificar si el archivo de entrada existe
if not exist "%input_file%" (
    echo El archivo de entrada no existe.
    exit /b
)

:: Inicializar variables
set "last_line="
set "total_lines=0"

:: Leer el archivo línea por línea y contar las líneas
for /f "usebackq delims=" %%A in ("%input_file%") do (
    set "line=%%A"
    set "last_line=!line!"
    set /a total_lines+=1
)

:: Crear o vaciar el archivo de salida
> "%output_file%" echo.

:: Leer el archivo nuevamente y escribir todas las líneas excepto la última
set "current_line=0"
for /f "usebackq delims=" %%A in ("%input_file%") do (
    set /a current_line+=1
    if !current_line! lss !total_lines! (
        echo %%A >> "%output_file%"
    )
)

:: Procesar la última línea
if defined last_line (
    echo !last_line! | findstr "DB" >nul
    if !errorlevel! == 0 (
        set "count=0"
        for %%B in (!last_line!) do (
            if "%%B" == "DB" (
                set /a skip=1
            ) else (
                set /a count+=1
            )
        )

        :: Si hay más de 16 datos, recortar la línea
        if !count! gtr 17 (
            set "new_line=   "
            set "data_count=0"
            for %%B in (!last_line!) do (
                if !data_count! lss 17 (
                    set "new_line=!new_line! %%B"
                    set /a data_count+=1
                )
            )
            echo !new_line! >> "%output_file%"
        ) else (
            echo !last_line! >> "%output_file%"
        )
    ) else (
        echo !last_line! >> "%output_file%"
    )
)

endlocal
echo Modificación completada. Archivo guardado como %output_file%.
