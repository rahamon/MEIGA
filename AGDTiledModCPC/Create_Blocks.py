import xml.etree.ElementTree as ET
from PIL import Image
import json

def load_palette_from_json(json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    palette = []
    for entry in data:
        rgb = tuple(entry["RGB"])
        palette.append(rgb)
    return palette

def decode_mode0_byte(byte):
    a = ((byte >> 7) & 1) << 3 | ((byte >> 5) & 1) << 2 | ((byte >> 3) & 1) << 1 | ((byte >> 1) & 1)
    b = ((byte >> 6) & 1) << 3 | ((byte >> 4) & 1) << 2 | ((byte >> 2) & 1) << 1 | ((byte >> 0) & 1)
    return a, b

def extract_definepalette_and_blocks(file_path):
    blocks = []
    block_types = []
    with open(file_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    i = 0
    while i < len(lines):
        line = lines[i].strip()
        if line.startswith("DEFINEBLOCK"):
            parts = line.split()
            block_type = parts[1] if len(parts) > 1 else "EMPTYBLOCK"
            block_types.append(block_type)
            data = []
            for j in range(1, 4):
                if i + j < len(lines):
                    data += list(map(int, lines[i + j].strip().split()))
            blocks.append((data, 0))
            i += 3
        i += 1
    return blocks, block_types

def generate_png(png_file, blocks, palette, blocks_per_row=32):
    width = blocks_per_row * 5
    rows = (len(blocks) + blocks_per_row - 1) // blocks_per_row
    height = rows * 8
    img = Image.new("RGB", (width, height), "black")
    pixels = img.load()

    for idx, (binary_block, _) in enumerate(blocks):
        if len(binary_block) != 24:
            continue
        col = idx % blocks_per_row
        row = idx // blocks_per_row
        x_offset = col * 5
        y_offset = row * 8
        for y in range(8):
            fila = []
            for x in range(3):  # 3 bytes por fila → 6 píxeles, usamos solo 5
                byte = binary_block[y * 3 + x]
                a, b = decode_mode0_byte(byte)
                fila.extend([a, b])
            fila = fila[:5]  # nos quedamos con los primeros 5
            for x in range(5):
                color_index = fila[x]

                # Corrección de índices:
                if color_index > 7 and color_index % 2 == 0:
                    color_index -= 7
                elif color_index < 8 and color_index % 2 == 1:
                    color_index += 7

                if 0 <= color_index < len(palette):
                    pixels[x_offset + x, y_offset + y] = palette[color_index]

    img.save(png_file)


def generate_tsx(tsx_file, png_source, blocks, block_types):
    tileset = ET.Element("tileset", version="1.10", tiledversion="1.10.2",
                         name="BlocksCPC", tilewidth="5", tileheight="8",
                         tilecount=str(len(blocks)), columns=str(len(blocks)), tilerendersize="grid")
    image = ET.SubElement(tileset, "image", source=png_source,
                          width=str(len(blocks) * 5), height="8")
    for i, block_type in enumerate(block_types):
        tile = ET.SubElement(tileset, "tile", id=str(i), type="MPAGD.Block")
        props = ET.SubElement(tile, "properties")
        ET.SubElement(props, "property", name="Type", value=block_type)
    tree = ET.ElementTree(tileset)
    tree.write(tsx_file, encoding="UTF-8", xml_declaration=True)

if __name__ == "__main__":
    import sys
    PALETA_JSON_DEFECTO = "paleta_cpc_por_indice.json"  # Ruta fija

    if len(sys.argv) != 4:
        print("Uso: python Create_BlocksCPC.py entrada.agd salida.tsx salida.png")
        sys.exit(1)

    agd_file, tsx_file, png_file = sys.argv[1], sys.argv[2], sys.argv[3]
    palette = load_palette_from_json(PALETA_JSON_DEFECTO)
    blocks, types = extract_definepalette_and_blocks(agd_file)
    generate_png(png_file, blocks, palette)
    generate_tsx(tsx_file, png_file.split("/")[-1], blocks, types)

