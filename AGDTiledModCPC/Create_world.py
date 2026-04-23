import sys
import json
import re
import xml.etree.ElementTree as ET

ENVIROMENT_FILE = "ENVIROMENT.tmx"
DEFAULT_WIDTH = 32 * 8
DEFAULT_HEIGHT = 24 * 8


def get_screen_dimensions_from_tmx(filename):
    tree = ET.parse(filename)
    root = tree.getroot()
    for obj in root.findall(".//object"):
        if obj.attrib.get("name") == "WINDOW" and obj.attrib.get("type") == "MPAGD.window":
            width = int(float(obj.attrib.get("width", DEFAULT_WIDTH)))
            height = int(float(obj.attrib.get("height", DEFAULT_HEIGHT)))
            return width, height
    return DEFAULT_WIDTH, DEFAULT_HEIGHT


def parse_map_block(agd_lines):
    in_map = False
    map_matrix = []
    width = 0
    start_screen = None

    for line in agd_lines:
        stripped = line.strip()
        if stripped.startswith("MAP"):
            in_map = True
        elif stripped.startswith("ENDMAP"):
            break
        elif in_map:
            if "WIDTH" in stripped:
                width = int(re.search(r"WIDTH\s+(\d+)", stripped).group(1))
            elif "STARTSCREEN" in stripped:
                start_screen = int(re.search(r"STARTSCREEN\s+(\d+)", stripped).group(1))
            elif re.match(r"^\d", stripped):
                row = [int(num) for num in stripped.strip().split()]
                map_matrix.append(row)

    return map_matrix, width, start_screen


def generate_world_json(map_matrix, screen_width, screen_height):
    maps = []
    horizontal_step = screen_width
    vertical_step = screen_height

    for row_idx, row in enumerate(map_matrix):
        for col_idx, screen_num in enumerate(row):
            x_offset = col_idx * horizontal_step
            y_offset = row_idx * vertical_step

            if screen_num == 255:
                continue  # espacio vacío, pero respetamos la posición

            maps.append({
                "fileName": f"SCREEN{screen_num:03}.tmx",
                "x": x_offset,
                "y": y_offset,
                "width": screen_width,
                "height": screen_height
            })

    return {
        "type": "world",
        "name": "MPAGD World",
        "infinite": False,
        "orientation": "orthogonal",
        "maps": maps
    }


def main(input_agd):
    screen_width, screen_height = get_screen_dimensions_from_tmx(ENVIROMENT_FILE)

    with open(input_agd, encoding="utf-8") as f:
        lines = f.readlines()

    map_matrix, width, start_screen = parse_map_block(lines)
    if not map_matrix:
        print("No se encontró un bloque MAP válido.")
        return

    world_data = generate_world_json(map_matrix, screen_width, screen_height)

    with open("MAP.world", "w", encoding="utf-8") as f:
        json.dump(world_data, f, indent=2)
    print("Archivo MAP.world generado correctamente.")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python agd_to_world.py archivo.agd")
    else:
        main(sys.argv[1])