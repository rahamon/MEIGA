import os
import sys
import xml.etree.ElementTree as ET
import json
from xml.dom import minidom

TILE_WIDTH = 8
TILE_HEIGHT = 8
TILESET_SOURCE_BLOCKS = "Blocks.tsx"
TILESET_SOURCE_SPRITES = "Sprites.tsx"
FIRST_GID = 1
SPRITE_GID_OFFSET = 256

def read_agd(filename):
    """Lee un archivo AGD probando varias codificaciones."""
    encodings = ("utf-8-sig", "utf-8", "cp1252")

    for encoding in encodings:
        try:
            with open(filename, "r", encoding=encoding) as f:
                lines = f.readlines()

            print(f"✅ AGD leído usando codificación: {encoding}")
            return lines

        except UnicodeDecodeError:
            continue

    raise UnicodeError(
        f"No se pudo decodificar el archivo '{filename}' "
        f"usando: {', '.join(encodings)}"
    )

def load_type_names(json_path):
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        for entry in data:
            if entry.get("name") == "Type" and entry.get("type") == "enum":
                return entry["values"]
    return []

def parse_definewindow(agd_lines):
    for line in agd_lines:
        if line.strip().startswith("DEFINEWINDOW"):
            parts = line.strip().split()
            if len(parts) >= 5:
                win_y, win_x, height, width = map(int, parts[1:5])
                return width, height, win_x, win_y
    print("⚠️  DEFINEWINDOW no encontrado. Se usará 32x24 desde (0,0) por defecto.")
    return 32, 24, 0, 0

def get_start_screen_index(agd_lines):
    for line in agd_lines:
        if line.strip().startswith("STARTSCREEN"):
            parts = line.strip().split()
            if len(parts) > 1 and parts[1].isdigit():
                return int(parts[1])
    print("⚠️  STARTSCREEN no encontrado en el archivo .agd. Se asumirá pantalla 0.")
    return 0

def parse_agd_screens(agd_lines, map_width, map_height):
    screens = []
    screen_count = 0
    i = 0
    total_tiles = map_width * map_height

    while i < len(agd_lines):
        line = agd_lines[i].strip()
        if line.startswith("DEFINESCREEN"):
            flat_values = []
            current_sprites = []

            parts = line.split()
            if len(parts) > 1:
                extras = [int(val) for val in parts[1:] if val.isdigit()]
                flat_values.extend(extras)

            i += 1
            while i < len(agd_lines):
                l = agd_lines[i].strip()
                if not l:
                    i += 1
                    continue

                if l.startswith("SPRITEPOSITION"):
                    try:
                        parts = l.split()
                        sprite = tuple(map(int, parts[1:5]))
                        current_sprites.append(sprite)
                    except Exception as e:
                        print(f"⚠️  SPRITEPOSITION inválido en línea {i}: {e}")
                    i += 1
                    continue

                if l.startswith("DEFINESCREEN"):
                    break

                valores = [int(val) for val in l.replace('\t', ' ').split() if val.isdigit()]
                flat_values.extend(valores)
                i += 1

            if len(flat_values) < total_tiles:
                print(f"⚠️  Pantalla {screen_count:03} incompleta. Se omitirá.")
            else:
                flat_values = flat_values[:total_tiles]
                screen_matrix = [flat_values[j:j + map_width] for j in range(0, total_tiles, map_width)]
                screens.append((screen_matrix, current_sprites))
                screen_count += 1
        else:
            i += 1

    return screens

def parse_sprite_last_frame_ids(agd_lines):
    last_frame_ids = []
    frame_idx = 0
    i = 0
    while i < len(agd_lines):
        line = agd_lines[i].strip()
        if line.startswith("DEFINESPRITE"):
            parts = line.split()
            if len(parts) > 1 and parts[1].isdigit():
                nframes = int(parts[1])
                last_frame_ids.append(frame_idx + (nframes - 1))
                frame_idx += nframes
                i += nframes * 2  # saltar datos del sprite
        i += 1
    return last_frame_ids

def generate_tmx(screen_data, sprite_list, screen_number, map_width, map_height, type_names, sprite_gid_table, win_x, win_y, is_start_screen):

    filename = f"SCREEN{screen_number:03}.tmx"
    map_elem = map_elem = ET.Element("map", {
        "version": "1.10",
        "tiledversion": "1.10.2",
        "class": "MPAGD.Screen",
        "orientation": "orthogonal",
        "renderorder": "right-down",
        "width": str(map_width),
        "height": str(map_height),
        "tilewidth": str(TILE_WIDTH),
        "tileheight": str(TILE_HEIGHT),
        "infinite": "0",
        "nextlayerid": "3",
        "nextobjectid": "1"
    })

    properties = ET.SubElement(map_elem, "properties")
    ET.SubElement(properties, "property", name="Nombre", type="string", value=f"Screen{screen_number:03}")
    ET.SubElement(properties, "property", name="StartRoom", type="bool", value=str(is_start_screen).lower())

    ET.SubElement(map_elem, "tileset", firstgid=str(FIRST_GID), source=TILESET_SOURCE_BLOCKS)
    ET.SubElement(map_elem, "tileset", firstgid=str(FIRST_GID + SPRITE_GID_OFFSET), source=TILESET_SOURCE_SPRITES)

    layer = ET.SubElement(map_elem, "layer", id="1", name="DEFINETILES",
                          width=str(map_width), height=str(map_height))
    data = ET.SubElement(layer, "data", encoding="csv")
    flat_tiles = [str(tile + FIRST_GID) for row in screen_data for tile in row]
    data.text = ",".join(flat_tiles)

    objectgroup = ET.SubElement(map_elem, "objectgroup", id="2", name="SPRITEPOSITION")
    for obj_id, (type_id, sprite_num, y, x) in enumerate(sprite_list, start=1):
        if sprite_num < 0 or sprite_num >= len(sprite_gid_table):
            continue
        gid_value = sprite_gid_table[sprite_num] + FIRST_GID + SPRITE_GID_OFFSET
        sprite_x = x - win_x * 8
        sprite_y = y - win_y * 8 + 16
        obj = ET.SubElement(objectgroup, "object", id=str(obj_id), type="MPAGD.Position",
                            gid=str(gid_value), x=str(sprite_x), y=str(sprite_y),
                            width="16", height="16")
        props = ET.SubElement(obj, "properties")
        type_name = type_names[type_id] if 0 <= type_id < len(type_names) else "NULL"
        ET.SubElement(props, "property", name="Type", propertytype="Type", value=type_name)

    xml_str = ET.tostring(map_elem, encoding='utf-8')
    pretty_xml = minidom.parseString(xml_str).toprettyxml(indent="  ")
    with open(filename, "w", encoding="utf-8") as f:
        f.write(pretty_xml)
    print(f"✅ Generado correctamente: {filename}")

def main():
    if len(sys.argv) != 3:
        print("Uso: python agd_to_tmx.py archivo.agd MPAGDClass.json")
        return

    agd_path = sys.argv[1]
    json_path = sys.argv[2]

    if not os.path.exists(agd_path) or not os.path.exists(json_path):
        print("❌ Archivos no encontrados.")
        return

    # with open(agd_path, encoding="utf-8") as f:
    #    agd_lines = f.readlines()
    
    # Leer AGD probando varias codificaciones
    agd_lines = read_agd(agd_path)

    map_width, map_height, win_x, win_y = parse_definewindow(agd_lines)
    screens = parse_agd_screens(agd_lines, map_width, map_height)
    type_names = load_type_names(json_path)
    sprite_gid_table = parse_sprite_last_frame_ids(agd_lines)

    start_screen_index = get_start_screen_index(agd_lines)

    for i, (tiles, sprites) in enumerate(screens):
        is_start_screen = (i == start_screen_index)
        generate_tmx(tiles, sprites, i, map_width, map_height, type_names, sprite_gid_table, win_x, win_y, is_start_screen)

if __name__ == "__main__":
    main()
