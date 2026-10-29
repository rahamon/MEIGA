import os
import sys
import tkinter as tk
from tkinter import filedialog, messagebox

# Parámetros admitidos
if len(sys.argv) != 2 or sys.argv[1].lower() not in ("agd", "tiled", "compiler"):
    print("Error: Debes indicar 'agd', 'tiled' o 'compiler' como único parámetro.")
    sys.exit(1)

tipo = sys.argv[1].lower()

# Filtros del selector
if tipo == "agd":
    filetypes = [("Archivos AGD", "*.agd")]
    title = "Selecciona un archivo .agd"
elif tipo == "tiled":
    filetypes = [("Proyectos Tiled", "*.tiled-project")]
    title = "Selecciona un archivo .tiled-project"
else:  # compiler
    filetypes = [("CompilerZX.exe", "CompilerZX.exe"), ("Ejecutables", "*.exe")]
    title = "Selecciona CompilerZX.exe"

root = tk.Tk()
root.withdraw()

def seleccionar_archivo():
    return filedialog.askopenfilename(
        title=title,
        filetypes=filetypes
    )

archivo = ""

if tipo != "compiler":
    archivo = seleccionar_archivo()
else:
    # Modo compiler: exigir nombre exacto CompilerZX.exe
    while True:
        archivo = seleccionar_archivo()
        if not archivo:
            break  # cancelado

        nombre = os.path.basename(archivo).strip()
        if nombre.lower() == "compilerzx.exe":
            break

        messagebox.showerror(
            "Archivo incorrecto",
            "Debes seleccionar estrictamente el archivo 'CompilerZX.exe'."
        )

# Nombre del BAT de salida
salida_bat = "Compiler.bat" if tipo == "compiler" else "seleccion.bat"

with open(salida_bat, "w", encoding="utf-8") as f:
    f.write("@echo off\n")

    if archivo:
        archivo = archivo.strip()
        ruta = os.path.dirname(archivo).strip()
        base = os.path.splitext(os.path.basename(archivo))[0].strip()

        if tipo in ("agd", "tiled"):
            archivo_agd = os.path.join(ruta, base + ".agd").replace("/", "\\")
            world = ruta.replace("\\", "/")
            project_dir = ruta.replace("/", "\\")
            nombre = base + ".agd"

            f.write(f'set "archivo_agd={archivo_agd}"\n')
            f.write(f'set "world_dir={world}"\n')
            f.write(f'set "project_dir={project_dir}"\n')
            f.write(f'set "project_name={base}"\n')

            meiga_dir = os.getcwd()
            f.write(f'set "meiga_dir={meiga_dir}"\n')

        else:
            # compiler: guardar ruta completa y directorio
            compiler_exe = archivo.replace("/", "\\")
            compiler_dir = ruta.replace("/", "\\")

            f.write(f'set "compiler_exe={compiler_exe}"\n')
            f.write(f'set "compiler_dir={compiler_dir}"\n')

        f.write('GOTO:EOF')
