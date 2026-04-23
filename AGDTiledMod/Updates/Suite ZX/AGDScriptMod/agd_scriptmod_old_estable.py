import sys
from pathlib import Path
import shutil
import json

def aplicar_reemplazos(lines, json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        reemplazos = json.load(f)
    for clave, valor in reemplazos.items():
        lines = [line.replace(clave, valor) for line in lines]
    return lines

def validar_jumpstage(lines):
    validated_lines = []
    for line in lines:
        tokens = line.strip().split()
        new_line = line
        prev_token = ""
        comentario = False
        for idx, token in enumerate(tokens):
            if prev_token == ";":
                comentario = True
            if prev_token == "JUMPSTAGE" and not comentario:
                crudo = token
                try:
                    valor = int(crudo.lstrip("0") or "0")
                    if valor == 0:
                        new_line = f"ERROR ; JUMPSTAGE: {crudo} el valor no puede ser 0\n"
                    else:
                        new_line = f"LET RND = {valor} CALL 24835\n"
                except ValueError:
                    pass
                break
            prev_token = token
        validated_lines.append(new_line)
    return validated_lines

def validar_playmusic(lines):
    validated_lines = []
    for line in lines:
        tokens = line.strip().split()
        new_line = line
        prev_token = ""
        comentario = False
        for idx, token in enumerate(tokens):
            if prev_token == ";":
                comentario = True
            if prev_token == "PLAYMUSIC" and not comentario:
                crudo = token
                try:
                    valor = int(crudo.lstrip("0") or "0")
                    if valor == 0:
                        new_line = f"ERROR ; PLAYMUSIC: {crudo} no es un valor válido\n"
                    else:
                        new_line = f"LET RND = {valor} USER 100\n"
                except ValueError:
                    pass
                break
            prev_token = token
        validated_lines.append(new_line)
    return validated_lines

def validar_playfx(lines):
    validated_lines = []
    for line in lines:
        tokens = line.strip().split()
        new_line = line
        prev_token = ""
        comentario = False
        for idx, token in enumerate(tokens):
            if prev_token == ";":
                comentario = True
            if prev_token == "PLAYFX" and not comentario:
                crudo = token
                try:
                    valor = int(crudo.lstrip("0") or "0")
                    if valor == 0:
                        new_line = f"ERROR ; PLAYFX: {crudo} no es un valor válido\n"
                    else:
                        new_line = f"LET RND = {valor} USER 101\n"
                except ValueError:
                    pass
                break
            prev_token = token
        validated_lines.append(new_line)
    return validated_lines

def validar_printsplash(lines):
    validated_lines = []
    for line in lines:
        tokens = line.strip().split()
        new_line = line
        prev_token = ""
        comentario = False
        for idx, token in enumerate(tokens):
            if prev_token == ";":
                comentario = True
            if prev_token == "PRINTSPLASH" and not comentario:
                crudo = token
                try:
                    valor = int(crudo.lstrip("0") or "0")
                    if valor == 0:
                        new_line = f"ERROR ; PRINTSPLASH: {crudo} el valor no puede ser 0\n"
                    else:
                        new_line = f"LET A = {valor} CALL 24838\n"
                except ValueError:
                    pass
                break
            prev_token = token
        validated_lines.append(new_line)
    return validated_lines

def scripter_python(base_name):
    original_file = Path(f"{base_name}.agd")
    working_file = Path("Script.agd")

    if not original_file.exists():
        print(f"Archivo no encontrado: {original_file}")
        sys.exit(1)

    if working_file.exists():
        working_file.unlink()

    shutil.copy(original_file, working_file)

    with working_file.open("r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    # Comandos personalizados Meiga
    lines = validar_jumpstage(lines)
    lines = validar_printsplash(lines)
    lines = validar_playfx(lines)  # <--- nueva función integrada
    lines = validar_playmusic(lines)  # <--- nueva función integrada

    # Reemplazos personalizados (etapa 5)
    lines = aplicar_reemplazos(lines, "Comandos.json")

    with working_file.open("w", encoding="utf-8") as f:
        f.writelines(lines)

    print("[OK] Script.agd generado correctamente.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python agd_scriptmod.py <nombre_base_sin_extension>")
        sys.exit(1)
    scripter_python(sys.argv[1])
