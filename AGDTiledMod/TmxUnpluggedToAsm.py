import os
import sys
import xml.etree.ElementTree as ET


EXPECTED_UNPLUGGED = [
    "SOUNDFX",
    "INVENTARY",
    "SPECIALISTS",
    "ULAPLUS",
    "INFRONT",
    "SCROLL",
    "ULABUFFER",
    "MASKAGD",
]


def normalize_asm_value(prop: ET.Element) -> str:
    value = prop.get("value")
    if value is None:
        value = prop.text or ""

    value = value.strip()
    prop_type = (prop.get("type") or "").lower()

    if prop_type == "bool":
        return "1" if value.lower() == "true" else "0"

    if prop_type in ("int", "float"):
        return value

    if value.lower() == "true":
        return "1"
    if value.lower() == "false":
        return "0"

    try:
        int(value)
        return value
    except ValueError:
        pass

    try:
        float(value)
        return value
    except ValueError:
        pass

    return value


def get_unplugged_properties(tmx_path: str):
    tree = ET.parse(tmx_path)
    root = tree.getroot()

    for og in root.findall("objectgroup"):
        if og.get("name") == "UNPLUGGED" and og.get("class") == "MEIGA.Plugins":

            props_node = og.find("properties")
            if props_node is None:
                return []

            props = []

            for prop in props_node.findall("property"):
                name = prop.get("name")
                if not name:
                    continue

                value = normalize_asm_value(prop)
                props.append((name, value))

            return props

    print("ERROR: No se encontró el objectgroup UNPLUGGED con clase MEIGA.Plugins")
    return []


def generate_unplugged_asm(props):

    found_props = dict(props)

    lines = []
    lines.append("; Archivo generado automáticamente desde TMX")
    lines.append("; Objectgroup: UNPLUGGED")
    lines.append("; Clase: MEIGA.Plugins")
    lines.append("")

    max_len = max(len(name) for name in EXPECTED_UNPLUGGED)

    for asm_name in EXPECTED_UNPLUGGED:
        value = found_props.get(asm_name, "0")
        lines.append(f"{asm_name.ljust(max_len)}    equ {value}")

    lines.append("")
    return "\n".join(lines)


def main():

    if len(sys.argv) != 3:
        print("Uso:")
        print("  python TmxUnpluggedToAsm.py ENVIROMENT.tmx Unplugged.asm")
        sys.exit(1)

    tmx_file = sys.argv[1]
    output_file = sys.argv[2]

    if not os.path.exists(tmx_file):
        print(f"ERROR: No existe {tmx_file}")
        return

    props = get_unplugged_properties(tmx_file)
    if not props:
        return
        
    asm_text = generate_unplugged_asm(props)

    with open(output_file, "w", encoding="utf-8", newline="\n") as f:
        f.write(asm_text)

    print(f"{output_file} generado correctamente.")


if __name__ == "__main__":
    main()
    