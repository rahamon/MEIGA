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

with open("seleccion.txt", "w", encoding="utf-8") as f:
    if archivo:
        archivo = archivo.strip()
        ruta = os.path.dirname(archivo).strip()
        base = os.path.splitext(os.path.basename(archivo))[0].strip()
        archivo = os.path.join(ruta, base + ".agd").replace("\\", "/")  # Fuerza barras /
        ruta = ruta.replace("\\", "/")                                  # También en ruta
        nombre = base + ".agd"
        f.write(f"{archivo}\n{ruta}\n{nombre}")
    else:
        f.write("")
