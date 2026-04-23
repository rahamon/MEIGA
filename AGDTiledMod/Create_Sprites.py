import sys
import os
from PIL import Image
import xml.etree.ElementTree as ET
import xml.dom.minidom

TILE_WIDTH = 16
TILE_HEIGHT = 16


def parse_agd_file(filename):
    sprites = []
    with open(filename, 'r', encoding='utf-8', errors='replace') as f:
        lines = f.readlines()

    i = 0
    while i < len(lines):
        line = lines[i].strip()
        if line.startswith("DEFINESPRITE"):
            frames = int(line.split()[1])
            frame_data = []
            for _ in range(frames * 2):  # 2 líneas por frame (32 bytes)
                i += 1
                frame_line = lines[i].strip()
                frame_data.append([int(b) for b in frame_line.split()])
            sprites.append({
                "frames": frames,
                "data": frame_data
            })
        i += 1

    return sprites


def sprite_to_image(frame_data):
    # frame_data: lista de 2 listas de 16 enteros (fila superior y fila inferior)
    combined = frame_data[0] + frame_data[1]  # 32 bytes

    upper_left  = [combined[i * 2]     for i in range(8)]
    upper_right = [combined[i * 2 + 1] for i in range(8)]
    lower_left  = [combined[16 + i * 2]     for i in range(8)]
    lower_right = [combined[16 + i * 2 + 1] for i in range(8)]

    img = Image.new('1', (TILE_WIDTH, TILE_HEIGHT))
    for y in range(8):
        for x in range(8):
            img.putpixel((x, y),         (upper_left[y] >> (7 - x)) & 1)
            img.putpixel((8 + x, y),     (upper_right[y] >> (7 - x)) & 1)
            img.putpixel((x, 8 + y),     (lower_left[y] >> (7 - x)) & 1)
            img.putpixel((8 + x, 8 + y), (lower_right[y] >> (7 - x)) & 1)
    return img


def generate_tileset_image(frames):
    columns = 16
    rows = (len(frames) + columns - 1) // columns
    image = Image.new('1', (columns * TILE_WIDTH, rows * TILE_HEIGHT), color=0)
    for idx, frame in enumerate(frames):
        x = (idx % columns) * TILE_WIDTH
        y = (idx // columns) * TILE_HEIGHT
        image.paste(frame, (x, y))
    return image


def write_tsx(filename, total_frames):
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

    # Pretty print con minidom
    rough_string = ET.tostring(tileset, 'utf-8')
    reparsed = xml.dom.minidom.parseString(rough_string)
    pretty_xml = reparsed.toprettyxml(indent=" ")

    with open(filename, "w", encoding="utf-8") as f:
        f.write(pretty_xml)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: AgdToTsxSprites archivo.agd")
        sys.exit(1)

    agd_file = sys.argv[1]
    sprites = parse_agd_file(agd_file)

    if not sprites:
        print("No se encontraron definiciones de sprites en el archivo.")
        sys.exit(0)  # Finaliza sin errores

    all_frames = []
    last_frame_ids = []

    current_id = 0
    for sprite in sprites:
        for i in range(0, len(sprite['data']), 2):
            frame_data = [sprite['data'][i], sprite['data'][i+1]]
            img = sprite_to_image(frame_data)
            all_frames.append(img)
            if i + 2 == len(sprite['data']):
                last_frame_ids.append(current_id)
            current_id += 1

    image = generate_tileset_image(all_frames)
    image.save("Sprites.png")
    write_tsx("Sprites.tsx", len(all_frames))

    print("Generado: Sprites.tsx y Sprites.png")
