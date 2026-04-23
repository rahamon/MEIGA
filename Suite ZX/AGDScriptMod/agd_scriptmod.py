import sys
from pathlib import Path
import shutil
import json


def cargar_reglas(json_path: str) -> dict:
    path = Path(json_path)
    if not path.exists():
        print(f"Archivo de reglas no encontrado: {path}")
        sys.exit(1)

    with path.open("r", encoding="utf-8") as f:
        rules = json.load(f)

    if not isinstance(rules, dict):
        print(f"Formato inválido en {json_path}: se esperaba un objeto JSON (dict).")
        sys.exit(1)

    # Validación mínima
    for cmd, spec in rules.items():
        if not isinstance(spec, dict) or "type" not in spec:
            print(f"Regla inválida para '{cmd}': falta 'type'.")
            sys.exit(1)

        t = spec["type"]
        if t == "macro":
            if "replace" not in spec:
                print(f"Regla macro inválida para '{cmd}': falta 'replace'.")
                sys.exit(1)
        elif t == "int_arg_line":
            if "on_ok" not in spec or "on_zero" not in spec:
                print(f"Regla int_arg_line inválida para '{cmd}': faltan 'on_ok' y/o 'on_zero'.")
                sys.exit(1)
        else:
            print(f"Tipo de regla desconocido para '{cmd}': {t}")
            sys.exit(1)

    return rules


def _parse_int_no_leading_zeroes(raw: str) -> int:
    # Replica: int(crudo.lstrip("0") or "0")
    return int(raw.lstrip("0") or "0")


def _leading_indent(s: str) -> str:
    i = 0
    while i < len(s) and s[i] in (" ", "\t"):
        i += 1
    return s[:i]

def aplicar_comandos(lines: list[str], rules: dict) -> list[str]:
    """
    Reglas:
    - No toca el comentario: analiza solo lo antes de ';' y luego reengancha el comentario intacto.
    - int_arg_line: reemplaza SOLO el par (COMANDO ARG) en cualquier posición, conservando tokens previos/posteriores y comentario.
    - macro: reemplaza el token exacto allí donde esté en la línea, conservando comentario.
    """
    out: list[str] = []

    for line in lines:
        has_nl = line.endswith("\n")
        line_wo_nl = line[:-1] if has_nl else line

        # Separar comentario sin tocarlo
        code_part, sep, comment_part = line_wo_nl.partition(";")
        comment = (sep + comment_part) if sep else ""

        indent = _leading_indent(code_part)
        code = code_part.strip()

        if not code:
            out.append(line)
            continue

        tokens = code.split()

        new_tokens: list[str] = []
        changed = False
        i = 0

        while i < len(tokens):
            tok = tokens[i]
            spec = rules.get(tok)

            # 1) int_arg_line: sustituye (tok, arg) en cualquier posición
            if spec and spec.get("type") == "int_arg_line":
                if i + 1 >= len(tokens):
                    # Sin argumento -> no tocar ese token
                    new_tokens.append(tok)
                    i += 1
                    continue

                raw = tokens[i + 1]
                try:
                    n = _parse_int_no_leading_zeroes(raw)
                except ValueError:
                    # Argumento no entero -> no tocar (tok y arg se quedan tal cual)
                    new_tokens.append(tok)
                    new_tokens.append(raw)
                    i += 2
                    continue

                if n == 0:
                    repl = spec["on_zero"].format(raw=raw, n=n)
                else:
                    repl = spec["on_ok"].format(raw=raw, n=n)

                new_tokens.extend(str(repl).strip().split())
                changed = True
                i += 2
                continue

            # 2) macro: sustituye token exacto
            if spec and spec.get("type") == "macro":
                repl = str(spec["replace"]).strip()
                new_tokens.extend(repl.split())
                changed = True
                i += 1
                continue

            # 3) token normal
            new_tokens.append(tok)
            i += 1

        if changed:
            rebuilt_code = indent + " ".join(new_tokens)
            if comment:
                if not rebuilt_code.endswith(" "):
                    rebuilt_code += " "
                rebuilt_code += comment
            out.append(rebuilt_code + ("\n" if has_nl else ""))
        else:
            out.append(line)

    return out

def scripter_python(base_name: str, rules_path: str = "CommandRules.json"):
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

    rules = cargar_reglas(rules_path)
    lines = aplicar_comandos(lines, rules)

    with working_file.open("w", encoding="utf-8") as f:
        f.writelines(lines)

    print("[OK] Script.agd generado correctamente.")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python agd_scriptmod.py <nombre_base_sin_extension>")
        print("Opcional: python agd_scriptmod.py <base> <CommandRules.json>")
        sys.exit(1)

    base = sys.argv[1]
    rules_path = sys.argv[2] if len(sys.argv) >= 3 else "CommandRules.json"
    scripter_python(base, rules_path)
