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
                    if valor >= 200:
                        new_line = "ERROR ; SOUND: valor muy grande\n"
                        break
                    elif 100 <= valor <= 199:
                        valor -= 100
                        new_line = new_line.replace(f"PLAYFX {crudo}", f"PLAYFX {valor} ; valor modificado")
                    elif valor == 36:
                        new_line = new_line.replace(f"PLAYFX {crudo}", "MONITOR ; valor modificado")
                except ValueError:
                    pass
            prev_token = token
        validated_lines.append(new_line)
    return validated_lines

def validar_playmusic(lines, log_path):
    validated_lines = []
    with log_path.open("a", encoding="utf-8") as log:
        for line in lines:
            tokens = line.strip().split()
            new_line = line
            prev_token = ""
            comentario = False
            hay_numero = False
            for idx, token in enumerate(tokens):
                if prev_token == ";":
                    comentario = True
                if prev_token == "PLAYMUSIC" and not comentario:
                    crudo = token
                    hay_numero = True
                    try:
                        valor = int(crudo.lstrip("0") or "0")
                        if valor >= 100:
                            new_line = f"ERROR ; la pista de PLAYMUSIC: debe ser menor que 100\n"
                            log.write("PLAYMUSIC debe ser menor que 100\n")
                            break
                        elif valor == 0:
                            new_line = f"ERROR ; la pista de PLAYMUSIC: no puede ser 0\n"
                            log.write("PLAYMUSIC no puede ser 0\n")
                            break
                    except ValueError:
                        pass
                prev_token = token
            if not hay_numero and "PLAYMUSIC" in tokens and not comentario:
                new_line = "ERROR ; PLAYMUSIC: no tiene valor\n"
                log.write("PLAYMUSIC no tiene valor\n")
            validated_lines.append(new_line)
    return validated_lines

def validar_sound(lines, log_path):
    validated_lines = []
    with log_path.open("a", encoding="utf-8") as log:
        for line in lines:
            tokens = line.strip().split()
            new_line = line
            prev_token = ""
            comentario = False
            for idx, token in enumerate(tokens):
                if prev_token == ";":
                    comentario = True
                if prev_token == "SOUND" and not comentario:
                    crudo = token
                    try:
                        valor = int(crudo.lstrip("0") or "0")
                        if valor >= 1000:
                            nuevo_valor = valor - 1000 + 100
                            new_line = new_line.replace(f"SOUND {crudo}", f"SOUND {nuevo_valor}")
                        elif valor == 100:
                            new_line = "ERROR ; SOUND: no puede ser 0\n"
                            log.write("SOUND no puede ser 0\n")
                            break
                    except ValueError:
                        pass
                prev_token = token
            validated_lines.append(new_line)
    return validated_lines

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
                        new_line = f"LET A = {valor} CALL 24835\n"
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
    output_log = Path("msgerror.log")

    if not original_file.exists():
        print(f"Archivo no encontrado: {original_file}")
        sys.exit(1)

    if working_file.exists():
        working_file.unlink()
    if output_log.exists():
        output_log.unlink()

    shutil.copy(original_file, working_file)

    with working_file.open("r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()

    # Hacer compatible con SoundMod
    lines = [line.replace(";", "; ") for line in lines]
    lines = [line.replace("SOUND ", "PLAYFX ") for line in lines]
    
    lines = validar_playmusic(lines, output_log)
    lines = [line.replace("PLAYMUSIC ", "SOUND ") for line in lines]
    
    lines = validar_playfx(lines)
    lines = [line.replace("PLAYFX ", "SOUND 10") for line in lines]
    
    lines = validar_sound(lines, output_log)
    
    # Comandos Meiga ScreenMod
    lines = validar_jumpstage(lines)
    lines = validar_printsplash(lines)
    
    # Comandos ScriptMod
    lines = aplicar_reemplazos(lines, "Comandos.json")

    with working_file.open("w", encoding="utf-8") as f:
        f.writelines(lines)

    print("[OK] Script.agd generado correctamente.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python agd_scriptmod.py <nombre_base_sin_extension>")
        sys.exit(1)
    scripter_python(sys.argv[1])
