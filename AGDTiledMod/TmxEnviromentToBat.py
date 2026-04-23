import os
import xml.etree.ElementTree as ET


# Mapeo EXACTO según MPAGDClass.json
SOUND_MAP = {
    "Standard": 0,
    "Beeper": 1,
    "AY-3-8912 Vortex Tracker II": 2,
    "AY-3-8912 Arkos Traker": 3,
}


def get_manager_properties(tmx_path: str) -> dict[str, str]:
    tree = ET.parse(tmx_path)
    root = tree.getroot()

    for og in root.findall("objectgroup"):
        if og.get("name") == "MANAGER" and og.get("class") == "MEIGA.Mods":
            props_node = og.find("properties")
            if props_node is None:
                return {}

            props = {}
            for p in props_node.findall("property"):
                name = p.get("name")
                value = p.get("value")
                if name and value is not None:
                    props[name] = value
            return props

    print("ERROR: No se encontró el objectgroup MANAGER clase MEIGA.Mods")
    return {}


def normalize_bool(value: str) -> bool:
    return value.strip().lower() == "true"


def generate_enviroment_bat(props: dict[str, str]) -> str:

    lines = []
    lines.append("@echo off")

    # --- STAGES -> LevelEnabled
    if "Stages" in props:
        if normalize_bool(props["Stages"]):
            lines.append("rem (en vez de set STAGES=true)")
            lines.append("\tset LevelEnabled=1")
        else:
            lines.append("rem (en lugar de set STAGES=false)")
            lines.append("\tset LevelEnabled=0")

    # --- ConvertMode
    if "Compilador Stages" in props:
        lines.append("rem  en lugar de set COMPILADOR_STAGES=ConvertGame")
        lines.append(f'\tset "ConvertMode={props["Compilador Stages"]}"')

    # --- SoundMod
    if "Sound" in props:
        sound_value = props["Sound"]
        modsnd = SOUND_MAP.get(sound_value, 0)

        lines.append("\t:: Sound Mod")
        lines.append("\t\trem 0 = Standard")
        lines.append("\t\trem 1 = ZX Spectrum 48k Beeper")
        lines.append("\t\trem 2 = ZX Spectrum 128/+2/+3 AY-3-8912 Vortex Tracker II PT3")
        lines.append("\t\trem 3 = ZX Spectrum 128/+2/+3 AY-3-8912 Arkos Traker")
        lines.append(f"\tset modsnd={modsnd}")

    lines.append("GOTO:EOF")
    lines.append("")

    return "\n".join(lines)


def main():
    tmx_file = "ENVIROMENT.tmx"
    output_file = "Enviroment.bat"

    if not os.path.exists(tmx_file):
        print(f"ERROR: No existe {tmx_file}")
        return

    props = get_manager_properties(tmx_file)
    bat_text = generate_enviroment_bat(props)

    with open(output_file, "w", encoding="utf-8", newline="\n") as f:
        f.write(bat_text)

    print("Enviroment.bat generado correctamente.")
    

if __name__ == "__main__":
    main()
