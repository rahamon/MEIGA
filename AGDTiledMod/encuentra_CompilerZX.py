import os
import sys

TARGET_RC = "WinAGD.rc"

def parents(path, max_levels=10):
    """Genera path, su padre, su abuelo... hasta max_levels."""
    path = os.path.abspath(path)
    yield path
    for _ in range(max_levels):
        parent = os.path.dirname(path)
        if parent == path:
            break
        path = parent
        yield path

def walk_find_file(start_dir, filename, max_depth=3):
    """
    Busca filename con os.walk pero limitando profundidad para no volverse loco.
    Devuelve el directorio donde aparece o None.
    """
    start_dir = os.path.abspath(start_dir)

    for root, dirs, files in os.walk(start_dir):
        rel = os.path.relpath(root, start_dir)
        depth = 0 if rel == "." else rel.count(os.sep) + 1
        if depth > max_depth:
            dirs[:] = []
            continue
        if filename in files:
            return root
    return None

def find_winagd_rc_dir():
    script_dir = os.path.abspath(os.path.dirname(__file__))
    cwd = os.path.abspath(os.getcwd())

    # 0) Si el usuario da rutas “ancla” por entorno, comprobar primero (rápido)
    env_dirs = os.environ.get("WINAGD_DIRS", "")
    for base in [p.strip() for p in env_dirs.split(";") if p.strip()]:
        # Directo
        direct = os.path.join(base, TARGET_RC)
        if os.path.isfile(direct):
            return os.path.abspath(base)
        # Recursivo desde esa base
        found = walk_find_file(base, TARGET_RC, max_depth=16)
        if found:
            return found

    # 1) Comprobación directa en script_dir y cwd
    for base in (script_dir, cwd):
        direct = os.path.join(base, TARGET_RC)
        if os.path.isfile(direct):
            return base

    # 2) Buscar hacia arriba: en cada padre, intentar walk (esto suele encontrarlo en repos)
    #    Aumentamos la profundidad del walk porque ya estamos anclados en un padre “razonable”.
    for anchor in (script_dir, cwd):
        for p in parents(anchor, max_levels=12):
            found = walk_find_file(p, TARGET_RC, max_depth=14)
            if found:
                return found

    return None

def write_compiler_bat(rc_dir, out_bat="Compiler.bat"):
    # según tu estructura: <rc_dir>\Suite ZX\AGD\CompilerZX.exe
    compiler_exe = os.path.join(rc_dir, "Suite ZX", "AGD", "CompilerZX.exe")

    if not os.path.isfile(compiler_exe):
        raise FileNotFoundError(
            "Se encontró WinAGD.rc, pero NO CompilerZX.exe en la ruta esperada:\n"
            f"{compiler_exe}\n\n"
            "Si la carpeta base no es la correcta (por ejemplo WinAGD.rc está en un subdirectorio),\n"
            "habría que subir niveles antes de añadir 'Suite ZX\\AGD'."
        )

    if os.path.basename(compiler_exe).lower() != "compilerzx.exe":
        raise ValueError("El ejecutable localizado no se llama exactamente CompilerZX.exe")

    compiler_exe_win = compiler_exe.replace("/", "\\")
    compiler_dir_win = os.path.dirname(compiler_exe).replace("/", "\\")

    with open(out_bat, "w", encoding="utf-8") as f:
        f.write("@echo off\n")
        f.write(f'set "compiler_exe={compiler_exe_win}"\n')
        f.write(f'set "compiler_dir={compiler_dir_win}"\n')
        f.write("GOTO:EOF\n")

if __name__ == "__main__":
    rc_dir = find_winagd_rc_dir()
    if not rc_dir:
        print(
            "ERROR: No se encontró WinAGD.rc.\n"
            "Sugerencias:\n"
            "  - Ejecuta el script desde la carpeta del proyecto (raíz del repo) o una cercana.\n"
            "  - O define WINAGD_DIRS con una o varias rutas base separadas por ';'.\n"
            "    Ejemplo: set WINAGD_DIRS=C:\\MiRepo\\WinAGD;D:\\OtroRepo\\WinAGD\n"
        )
        sys.exit(1)

    try:
        write_compiler_bat(rc_dir, out_bat="Compiler.bat")
        print(f"OK: WinAGD.rc encontrado en: {rc_dir}")
        print("OK: Generado Compiler.bat")
    except Exception as e:
        print(f"ERROR: {e}")
        sys.exit(1)
