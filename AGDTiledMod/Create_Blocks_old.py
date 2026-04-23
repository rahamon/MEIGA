import sys
import xml.etree.ElementTree as ET
import numpy as np
from PIL import Image
import json
import os

def decode_attribute(attribute):
    flash = (attribute >> 7) & 1
    bright = (attribute >> 6) & 1
    paper_index = (attribute >> 3) & 0b111
    ink_index = attribute & 0b111

    if bright:
        paper_index += 8
        ink_index += 8
    
    return flash, bright, paper_index, ink_index

def parse_agd(agd_file):
    """Lee un archivo AGD y extrae la información de bloques."""
    blocks = []
    block_types = []
    with open(agd_file, "r", encoding="utf-8") as file:
        lines = file.readlines()

    i = 0
    while i < len(lines):
        line = lines[i].strip()
        if line.startswith("DEFINEBLOCK"):
            parts = line.split()
            block_type = parts[1] if len(parts) > 1 else "EMPTYBLOCK"
            block_types.append(block_type)
            i += 1

            if i < len(lines):
                data = list(map(int, lines[i].strip().split()))
                binary_block, attribute = data[:-1], data[-1]
                blocks.append((binary_block, attribute))
        i += 1

    return blocks, block_types

def load_palette_from_json(json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    palette = [(entry["R"], entry["G"], entry["B"]) for entry in sorted(data, key=lambda x: x["Indice atributo"])]
    return palette

def generate_tsx(tsx_file, png_file, blocks, block_types):
    tileset = ET.Element("tileset", version="1.10", tiledversion="1.10.2", 
                         name="Generated", tilewidth="8", tileheight="8", 
                         tilecount=str(len(blocks)), columns=str(len(blocks)))
    image = ET.SubElement(tileset, "image", source=png_file, width=str(len(blocks) * 8), height="8")
    
    for i, block_type in enumerate(block_types):
        tile = ET.SubElement(tileset, "tile", id=str(i), type="MPAGD.Block")
        properties = ET.SubElement(tile, "properties")
        ET.SubElement(properties, "property", name="Type", value=block_type, attrib={"propertytype": "Block"})
    
    tree = ET.ElementTree(tileset)
    tree.write(tsx_file, encoding="UTF-8", xml_declaration=True)
    print(f"Archivo TSX generado: {tsx_file}")

def generate_png(png_file, blocks, blocks_per_row=32, palette=None):
    if palette is None:
        raise ValueError("Se requiere una paleta para generar la imagen.")

    rows = (len(blocks) + blocks_per_row - 1) // blocks_per_row
    width = blocks_per_row * 8
    height = rows * 8
    img = Image.new("RGB", (width, height), "black")
    pixels = img.load()

    for idx, (binary_block, attribute) in enumerate(blocks):
        col = idx % blocks_per_row
        row = idx // blocks_per_row
        x_offset = col * 8
        y_offset = row * 8

        _, _, paper_index, ink_index = decode_attribute(attribute)
        paper_color = palette[paper_index]
        ink_color = palette[ink_index]

        for y, row_bits in enumerate(binary_block):
            for x in range(8):
                color = ink_color if row_bits & (1 << (7 - x)) else paper_color
                pixels[x_offset + x, y_offset + y] = color

    img.save(png_file)
    print(f"Imagen PNG generada: {png_file}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Uso: python defineTileBlocks.py input.agd output.tsx output.png")
        sys.exit(1)

    agd_file, tsx_file, png_file = sys.argv[1], sys.argv[2], sys.argv[3]
    blocks, block_types = parse_agd(agd_file)

    if not blocks:
        print("No se encontraron bloques definidos en el archivo AGD. No se generará ningún archivo.")
        sys.exit(0)

    palette_path = os.path.join(os.path.dirname(__file__), "paleta_rgb_por_atributo.json")
    palette = load_palette_from_json(palette_path)

    generate_tsx(tsx_file, png_file, blocks, block_types)
    generate_png(png_file, blocks, palette=palette)


