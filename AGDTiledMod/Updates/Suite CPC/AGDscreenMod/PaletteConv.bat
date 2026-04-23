@echo off
setlocal EnableDelayedExpansion

:: Archivo de entrada y salida
set "input_file=TestJoda.asm"
set "output_file=firmware_data.asm"
set "temp_file=temp.asm"

:: Definir la tabla de conversión de hardware a firmware
:: Formato: set "HW_XX=YY" donde XX es el hardware y YY es el firmware correspondiente
set "HW_54=0"
set "HW_44=1"
set "HW_50=1"
set "HW_55=2"
set "HW_5C=3"
set "HW_58=4"
set "HW_5D=5"
set "HW_4C=6"
set "HW_45=7"
set "HW_48=7"
set "HW_4D=8"
set "HW_56=9"
set "HW_46=10"
set "HW_57=11"
set "HW_5E=12"
set "HW_40=13"
set "HW_41=13"
set "HW_5F=14"
set "HW_4E=15"
set "HW_47=16"
set "HW_4F=17"
set "HW_52=18"
set "HW_42=19"
set "HW_51=19"
set "HW_53=20"
set "HW_5A=21"
set "HW_59=22"
set "HW_5B=23"
set "HW_4A=24"
set "HW_43=25"
set "HW_49=25"
set "HW_4B=26"

:: Leer la última línea del archivo de entrada (que contiene los valores de hardware)
for /f "tokens=*" %%a in ('type "%input_file%" ^| findstr /r /c:"DB"') do set "last_line=%%a"

:: Extraer los primeros 16 valores de hardware (eliminando la parte "DB")
set "last_line=%last_line:DB=%"
rem set "last_line=%last_line:,#8C=%"

:: Procesar los valores y reemplazarlos con los valores de firmware correspondientes
set "new_line=DATA "
set count=0
for %%H in (%last_line%) do (
    set /a count+=1
    if !count! leq 16 (
        set "hardware_code=%%H"
        set "hardware_code=!hardware_code:#=!" :: Eliminar el prefijo #
        set "firmware_item=HW_!hardware_code!"

        :: Escribir aqui el código necesario para obtener el valor del firmware
        for %%F in (!firmware_item!) do (
		call set "firmware_code=%%%%F%%"
		echo !firmware_code!
        set "new_line=!new_line!!firmware_code!,"  :: Añadir el firmware code a la nueva línea
		)
    )
)
pause

:: Eliminar la coma final y escribir la nueva línea en el archivo de salida
set "new_line=!new_line:~0,-1!"

:: Crear el archivo de salida y escribir la nueva línea
echo %new_line% > "%output_file%"

echo La línea modificada se ha escrito en %output_file%.
pause
