import os
import sys
import xml.etree.ElementTree as ET
from PIL import Image
import numpy as np
import json

TILE_SIZE = 16
TILES_PER_ROW = 16
PALETTE = []

def load_palette_from_json(json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    return [(entry["R"], entry["G"], entry["B"]) for entry in sorted(data, key=lambda x: x["Indice atributo"])]

def find_nearest_color(rgb):
    return min(range(len(PALETTE)),
               key=lambda i: np.linalg.norm(np.array(PALETTE[i]) - np.array(rgb)))

def get_offset():
    tree = ET.parse("ENVIROMENT.tmx")
    obj = tree.find(".//objectgroup[@name='DEFINEWINDOW']/object[@name='WINDOW']")
    return int(obj.attrib['x']), int(obj.attrib['y'])

def extract_sprite_and_attr(image, index, paper_color_index):
    col = index % TILES_PER_ROW
    row = index // TILES_PER_ROW
    x0 = col * TILE_SIZE
    y0 = row * TILE_SIZE
    sprite = []
    color_count = {}

    for y in range(16):
        byte1 = 0
        byte2 = 0
        for x in range(8):
            color = image.getpixel((x0 + x, y0 + y))
            color_index = find_nearest_color(color)
            if color_index != paper_color_index:
                byte1 |= (1 << (7 - x))
                color_count[color_index] = color_count.get(color_index, 0) + 1
        for x in range(8):
            color = image.getpixel((x0 + 8 + x, y0 + y))
            color_index = find_nearest_color(color)
            if color_index != paper_color_index:
                byte2 |= (1 << (7 - x))
                color_count[color_index] = color_count.get(color_index, 0) + 1
        sprite.extend([byte1, byte2])

    ink_index = max(color_count, key=color_count.get, default=7)
    bright = 1 if ink_index >= 8 or paper_color_index >= 8 else 0
    ink = ink_index % 8
    paper = paper_color_index % 8
    attr = (paper << 3) | ink | (bright << 6)

    return sprite, attr

def load_positions_from_defineobject():
    win_x, win_y = get_offset()
    positions = {}
    for fname in os.listdir():
        if not fname.startswith("SCREEN") or not fname.endswith(".tmx"):
            continue
        room = int(fname[6:9])
        tree = ET.parse(fname)
        for obj in tree.findall(".//objectgroup[@name='DEFINEOBJECT']/object"):
            gid = int(obj.attrib["gid"]) - 1
            x = int(float(obj.attrib["x"])) + win_x
            y = int(float(obj.attrib["y"])) - 16 + win_y
            if gid not in positions:
                positions[gid] = {"room": room, "x": x, "y": y}
    return positions

def load_startrooms_from_tsx(tsx_file):
    tree = ET.parse(tsx_file)
    result = {}
    for tile in tree.findall("tile"):
        tid = int(tile.attrib["id"])
        room = 254
        props = tile.find("properties")
        if props is not None:
            for prop in props.findall("property"):
                if prop.attrib["name"] == "StartRoom":
                    val = prop.attrib["value"]
                    if val == "Carrying":
                        room = 255
                    elif val.isdigit():
                        room = int(val)
        result[tid] = room
    return result

def generate_defineobject(attr, room, x, y, sprite):
    line1 = f"DEFINEOBJECT    {attr} {room} {y} {x}\n"
    line2 = " " * 16 + " ".join(str(b) for b in sprite[:16]) + "\n"
    line3 = " " * 16 + " ".join(str(b) for b in sprite[16:]) + "\n"
    return line1 + line2 + line3 + "\n"

def get_tile_count_from_tsx(tsx_file):
    tree = ET.parse(tsx_file)
    return int(tree.getroot().attrib.get("tilecount", 0))

def main():
    global PALETTE

    if len(sys.argv) < 4:
        print("Uso: python TmxObjectsToAgd.py Objects.tsx Objects.png DEFINEOBJECT.agd [paleta.json]")
        return

    tsx_file = sys.argv[1]
    png_file = sys.argv[2]
    output_agd = sys.argv[3]

    if len(sys.argv) >= 5:
        palette_path = sys.argv[4]
        PALETTE = load_palette_from_json(palette_path)
    else:
        print("No se proporcionó paleta. Usando ZX Spectrum clásico.")
        PALETTE = [
            (0, 0, 0), (0, 0, 192), (192, 0, 0), (192, 0, 192),
            (0, 192, 0), (0, 192, 192), (192, 192, 0), (192, 192, 192),
            (0, 0, 0), (0, 0, 255), (255, 0, 0), (255, 0, 255),
            (0, 255, 0), (0, 255, 255), (255, 255, 0), (255, 255, 255)
        ]

    print("[*] Cargando posiciones desde DEFINEOBJECT...")
    sprite_positions = load_positions_from_defineobject()

    print("[*] Cargando StartRoom desde TSX...")
    startrooms = load_startrooms_from_tsx(tsx_file)

    print("[*] Leyendo gráficos y atributos desde imagen...")
    image = Image.open(png_file).convert("RGB")
    paper_rgb = image.getpixel((0, 0))
    paper_color_index = find_nearest_color(paper_rgb)

    total_tiles = get_tile_count_from_tsx(tsx_file)

    define_lines = []
    for i in range(total_tiles):
        sprite, attr = extract_sprite_and_attr(image, i, paper_color_index)
        if i in sprite_positions:
            data = sprite_positions[i]
            room, x, y = data["room"], data["x"], data["y"]
        else:
            room = startrooms.get(i, 254)
            x = 0
            y = 0
        block = generate_defineobject(attr, room, x, y, sprite)
        define_lines.append(block)

    with open(output_agd, "w", encoding="utf-8") as f:
        f.writelines(define_lines)

    print(f"[ok] Archivo '{output_agd}' generado con {len(define_lines)} objetos.")

if __name__ == "__main__":
    main()
