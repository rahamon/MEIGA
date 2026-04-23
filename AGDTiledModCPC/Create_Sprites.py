import sys
import os
import json
from PIL import Image
import xml.etree.ElementTree as ET
import xml.dom.minidom

TILE_WIDTH = 10
TILE_HEIGHT = 16

# Corrección personalizada de índice de color según reglas definidas
def corregir_indice(idx):
    if idx % 2 == 0:
        idx = idx + 8 if idx < 8 else idx + 1
    else:
        idx = idx - 1 if idx < 8 else idx + 8
    return idx % 16  # asegura que el índice esté entre 0 y 15


def decode_mode0_byte(byte):
    a = ((byte >> 7) & 1) << 3 | ((byte >> 5) & 1) << 2 | ((byte >> 3) & 1) << 1 | ((byte >> 1) & 1)
    b = ((byte >> 6) & 1) << 3 | ((byte >> 4) & 1) << 2 | ((byte >> 2) & 1) << 1 | ((byte >> 0) & 1)
    return a, b

def load_palette_from_json(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        palette_data = json.load(f)
    palette = [None] * 16
    for color in palette_data:
        pen = color["Pen"]
        rgb = tuple(color["RGB"])
        palette[pen] = rgb
    return palette

def parse_agd_file(filename):
    sprites = []
    with open(filename, 'r', encoding='utf-8', errors='replace') as f:
        lines = [line.strip() for line in f if line.strip()]

    i = 0
    while i < len(lines):
        if lines[i].startswith("DEFINESPRITE"):
            frames = int(lines[i].split()[1])
            i += 1
            frame_data = []
            while i < len(lines) and not lines[i].startswith("DEFINESPRITE"):
                frame_data.extend([int(x) for x in lines[i].split() if x.isdigit()])
                i += 1
            sprites.append({"frames": frames, "data": frame_data})
        else:
            i += 1
    return sprites

def sprite_to_image(frame_data):
    img = Image.new('RGB', (TILE_WIDTH, TILE_HEIGHT))
    pixels = img.load()
    for y in range(TILE_HEIGHT):
        for x in range(TILE_WIDTH // 2):
            byte = frame_data[y * (TILE_WIDTH // 2) + x]
            a, b = decode_mode0_byte(byte)
            pixels[px := x * 2, y] = cpc_palette[corregir_indice(a)]
            pixels[px + 1, y] = cpc_palette[corregir_indice(b)]
    return img

def generate_tileset_image(frames):
    columns = 16
    rows = (len(frames) + columns - 1) // columns
    image = Image.new('RGB', (columns * TILE_WIDTH, rows * TILE_HEIGHT))
    for idx, frame in enumerate(frames):
        x = (idx % columns) * TILE_WIDTH
        y = (idx // columns) * TILE_HEIGHT
        image.paste(frame, (x, y))
    return image

def write_tsx(filename, total_frames, last_frame_ids):
    tileset = ET.Element('tileset', {
        "version": "1.10",
        "tiledversion": "1.11.2",
        "name": "Sprites",
        "class": "MPAGD.Sprite",
        "tilewidth": str(TILE_WIDTH),
        "tileheight": str(TILE_HEIGHT),
        "tilecount": str(total_frames),
        "columns": "16"
    })

    ET.SubElement(tileset, "image", {
        "source": "Sprites.png",
        "width": str(16 * TILE_WIDTH),
        "height": str(((total_frames + 15) // 16) * TILE_HEIGHT)
    })

    for tile_id in range(total_frames):
        tile = ET.SubElement(tileset, "tile", {
            "id": str(tile_id),
            "type": "MPAGD.Image"
        })
        if tile_id in last_frame_ids:
            props = ET.SubElement(tile, "properties")
            ET.SubElement(props, "property", {
                "name": "Item of FRAMES",
                "propertytype": "Frame",
                "value": "Last Frame"
            })

    rough_string = ET.tostring(tileset, 'utf-8')
    reparsed = xml.dom.minidom.parseString(rough_string)
    pretty_xml = reparsed.toprettyxml(indent=" ")

    with open(filename, "w", encoding="utf-8") as f:
        f.write(pretty_xml)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: Create_Sprites archivo.agd")
        sys.exit(1)

    agd_file = sys.argv[1]
    palette_file = "paleta_cpc_por_indice.json"  # Paleta fija

    cpc_palette = load_palette_from_json(palette_file)
    sprites = parse_agd_file(agd_file)

    all_frames = []
    last_frame_ids = []
    current_id = 0

    for sprite in sprites:
        frame_count = sprite['frames']
        for f in range(frame_count):
            start = f * 80
            frame_data = sprite['data'][start:start + 80]
            if len(frame_data) == 80:
                img = sprite_to_image(frame_data)
                all_frames.append(img)
                if f == frame_count - 1:
                    last_frame_ids.append(current_id)
                current_id += 1

    image = generate_tileset_image(all_frames)
    image.save("Sprites.png")
    write_tsx("Sprites.tsx", len(all_frames), last_frame_ids)

    print("Generado: Sprites.tsx y Sprites.png")
