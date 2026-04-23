import tkinter as tk
from tkinter import filedialog
import os
import shutil

DEFAULT_TEMPLATE = "TiledAGDMod/default-GAME.agd"


def escribir_creation_txt(ruta_destino: str, out_file: str = "creation.txt") -> None:
    """
    Escribe 3 líneas (sin líneas vacías):
    1) Ruta completa del .agd
    2) Carpeta contenedora
    3) Nombre del archivo (.agd)
    """
    # Limpia espacios/tabuladores y normaliza separadores
    ruta_destino = ruta_destino.strip().replace("\\", "/")
    carpeta = os.path.dirname(ruta_destino).strip().replace("\\", "/")
    nombre = os.path.basename(ruta_destino).strip()

    # Si por algún motivo alguna parte quedara vacía, evita escribir líneas vacías
    lineas = [ruta_destino, carpeta, nombre]
    if any(not linea for linea in lineas):
        raise ValueError(f"Datos inválidos para escribir {out_file}: {lineas}")

    # Escribe exactamente 3 líneas, sin salto de línea extra al final
    with open(out_file, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lineas))


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

        # Genera el archivo creation.txt SIN líneas vacías
        escribir_creation_txt(ruta_destino, "creation.txt")

        print(f"Proyecto creado: {ruta_destino}")

    except Exception as e:
        print(f"Error al crear el proyecto: {e}")


if __name__ == "__main__":
    crear_proyecto()
