import os
import sys
import tkinter as tk
from tkinter import filedialog

if len(sys.argv) != 2 or sys.argv[1].lower() not in ("agd", "tiled"):
    print("Error: Debes indicar 'agd' o 'tiled' como único parámetro.")
    sys.exit(1)

tipo = sys.argv[1].lower()

filetypes = (
    [("Archivos AGD", "*.agd")] if tipo == "agd" else
    [("Proyectos Tiled", "*.tiled-project")]
)

root = tk.Tk()
root.withdraw()

archivo = filedialog.askopenfilename(
    title=f"Selecciona un archivo .{tipo}",
    filetypes=filetypes
)

with open("seleccion.bat", "w", encoding="utf-8") as f:
    f.write("@echo off\n")

    if archivo:
        archivo = archivo.strip()
        ruta = os.path.dirname(archivo).strip()
        base = os.path.splitext(os.path.basename(archivo))[0].strip()

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
        
        f.write(f'GOTO:EOF')
