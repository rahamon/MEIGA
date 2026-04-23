import tkinter as tk
from tkinter import filedialog
import os
import shutil

DEFAULT_TEMPLATE = "TiledAGDMod/default-GAME.agd"


def escribir_creation_bat(ruta_destino: str, out_file: str = "creation.bat") -> None:
    """
    Genera un .bat con variables de entorno, al estilo de seleccion.bat:
      - archivo_agd
      - world_dir
      - project_dir
      - project_name
      - meiga_dir
    """
    ruta_destino = ruta_destino.strip()
    if not ruta_destino:
        raise ValueError("ruta_destino vacía")

    # Directorio del proyecto y nombre base
    ruta = os.path.dirname(ruta_destino).strip()
    base = os.path.splitext(os.path.basename(ruta_destino))[0].strip()

    if not ruta or not base:
        raise ValueError(f"Datos inválidos para generar {out_file}: ruta='{ruta}', base='{base}'")

    # Normalizaciones igual que en seleccionar_archivo.py
    archivo_agd = os.path.join(ruta, base + ".agd").replace("/", "\\")
    world_dir = ruta.replace("\\", "/")
    project_dir = ruta.replace("/", "\\")
    meiga_dir = os.getcwd()

    with open(out_file, "w", encoding="utf-8", newline="\n") as f:
        f.write("@echo off\n")
        f.write(f'set "archivo_agd={archivo_agd}"\n')
        f.write(f'set "world_dir={world_dir}"\n')
        f.write(f'set "project_dir={project_dir}"\n')
        f.write(f'set "project_name={base}"\n')
        f.write(f'set "meiga_dir={meiga_dir}"\n')
        f.write("GOTO:EOF\n")


def crear_proyecto() -> None:
    root = tk.Tk()
    root.withdraw()

    ruta_destino = filedialog.asksaveasfilename(
        title="Crear nuevo proyecto AGD",
        defaultextension=".agd",
        filetypes=[("Archivos AGD", "*.agd")],
        initialfile="NuevoProyecto"
    )

    if not ruta_destino:
        print("Operación cancelada.")
        return

    try:
        if not os.path.exists(DEFAULT_TEMPLATE):
            print(f"Archivo plantilla no encontrado: {DEFAULT_TEMPLATE}")
            return

        # Copia la plantilla al destino elegido
        shutil.copy(DEFAULT_TEMPLATE, ruta_destino)

        # Genera creation.bat (en vez de creation.txt)
        escribir_creation_bat(ruta_destino, "creation.bat")

        print(f"Proyecto creado: {ruta_destino}")
        print("Archivo generado: creation.bat")

    except Exception as e:
        print(f"Error al crear el proyecto: {e}")


if __name__ == "__main__":
    crear_proyecto()
