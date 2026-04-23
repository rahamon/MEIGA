import os
import tkinter as tk
from tkinter import filedialog

root = tk.Tk()
root.withdraw()

archivo = filedialog.askopenfilename(
    title="Selecciona un archivo .agd",
    filetypes=[("Archivos AGD", "*.agd")]
)

with open("seleccion.txt", "w", encoding="utf-8") as f:
    if archivo:
        ruta = os.path.dirname(archivo)
        nombre = os.path.basename(archivo)
        f.write(f"{archivo}\n{ruta}\n{nombre}")
    else:
        f.write("")
