import tkinter as tk
from tkinter import filedialog
import os
import shutil

DEFAULT_TEMPLATE = "TiledAGDMod/default-GAME.agd"

def crear_proyecto():
    root = tk.Tk()
    root.withdraw()

    ruta_destino = filedialog.asksaveasfilename(
        title="Crear nuevo proyecto AGD",
        defaultextension=".agd",
        filetypes=[("Archivos AGD", "*.agd")],
        initialfile="NuevoProyecto"
    )

    if ruta_destino:
        try:
            if os.path.exists(DEFAULT_TEMPLATE):
                shutil.copy(DEFAULT_TEMPLATE, ruta_destino)
                print(f"Proyecto creado: {ruta_destino}")
            else:
                print(f"Archivo {DEFAULT_TEMPLATE} no encontrado.")
                return

            with open("creation.txt", 'w') as f:
                f.write(ruta_destino + "\n")
                f.write(os.path.dirname(ruta_destino) + "\n")
                f.write(os.path.basename(ruta_destino) + "\n")

        except Exception as e:
            print(f"Error al crear el proyecto: {e}")
    else:
        print("Operación cancelada.")

if __name__ == "__main__":
    crear_proyecto()
