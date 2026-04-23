import sys
import numpy as np
import xml.etree.ElementTree as ET
from PIL import Image
import json
import os

VALID_BLOCK_TYPES = {
    "PLATFORMBLOCK", "WALLBLOCK", "LADDERBLOCK", "FODDERBLOCK",
    "DEADLYBLOCK", "CUSTOMBLOCK", "WATERBLOCK", "COLLECTABLE", "EMPTYBLOCK"
}

EXCLUDED_TYPES = {"NO DATA (DELETEME)", "NULL"}

def load_palette_from_json(json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    # Ordenar por índice de atributo para asegurar consistencia
    palette = [(entry["R"], entry["G"], entry["B"]) for entry in sorted(data, key=lambda x: x["Indice atributo"])]
    return palette

def find_nearest_color(rgb, palette):
    rgb = tuple(rgb)
    TOLERANCIA = 16
    for i, color in enumerate(palette):
        if np.linalg.norm(np.array(rgb) - np.array(color)) <= TOLERANCIA:
            return i
    distances = [np.linalg.norm(np.array(color) - np.array(rgb)) for color in palette]
    return int(np.argmin(distances))

def parse_tsx(tsx_file):
    tree = ET.parse(tsx_file)
    root = tree.getroot()
    tiles = {}

    image_elem = root.find("image")
    if image_elem is None or "source" not in image_elem.attrib:
        raise ValueError("No se ha encontrado la imagen en el archivo .tsx")
    png_file = image_elem.attrib["source"]

    for tile in root.findall("tile"):
        tile_id = int(tile.attrib["id"])
        tile_type = tile.attrib.get("type", "")
        if tile_type != "MPAGD.Block":
            continue

        for prop in tile.findall("properties/property"):
            if prop.attrib.get("name") == "Type":
                value = prop.attrib.get("value", "").strip().upper()
                if value in EXCLUDED_TYPES:
                    break
                if value in VALID_BLOCK_TYPES:
                    tiles[tile_id] = value
    return tiles, png_file

def extract_blocks_from_png(png_file, tile_ids, palette):
    img = Image.open(png_file).convert("RGB")
    pixels = np.array(img)
    height, width, _ = pixels.shape
    tile_w, tile_h = 8, 8
    tiles_per_row = width // tile_w

    blocks = []
    for tid in sorted(tile_ids):
        x0 = (tid % tiles_per_row) * tile_w
        y0 = (tid // tiles_per_row) * tile_h

        paper_rgb = tuple(img.getpixel((x0, y0)))
        paper_index = find_nearest_color(paper_rgb, palette)

        color_count = {}
        for y in range(tile_h):
            for x in range(tile_w):
                color = tuple(img.getpixel((x0 + x, y0 + y)))
                index = find_nearest_color(color, palette)
                color_count[index] = color_count.get(index, 0) + 1

        ink_index = None
        if len(color_count) == 1:
            ink_index = next(iter(color_count))
        else:
            non_paper_colors = {k: v for k, v in color_count.items() if k != paper_index}
            if non_paper_colors:
                ink_index = max(non_paper_colors, key=non_paper_colors.get)
            else:
                ink_index = paper_index

        rows = []
        for y in range(tile_h):
            row_val = 0
            for x in range(tile_w):
                color = tuple(img.getpixel((x0 + x, y0 + y)))
                index = find_nearest_color(color, palette)
                if index != paper_index:
                    row_val |= (1 << (7 - x))
            rows.append(row_val)

        bright = 64 if ink_index >= 8 or paper_index >= 8 else 0
        ink = ink_index % 8
        paper = paper_index % 8
        attribute = (paper << 3) | ink | bright

        blocks.append((tid, rows, attribute))
    return blocks

def generate_agd(agd_file, blocks, block_types):
    with open(agd_file, "w") as f:
        for tile_id, binary_block, attribute in blocks:
            # Si todos los bytes de datos son 0 y el atributo es 0, forzar el atributo a 7
            if all(val == 0 for val in binary_block) and attribute == 0:
                attribute = 7
            block_type = block_types.get(tile_id, "EMPTYBLOCK")
            f.write(f"DEFINEBLOCK     {block_type}\n")
            f.write(f"{' ' * 16}" + " ".join(map(str, binary_block)) + f" {attribute}\n\n")
    print(f"Archivo AGD generado: {agd_file}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python defineblock.py input.tsx output.agd [paleta.json]")
        sys.exit(1)

    tsx_file, agd_file = sys.argv[1], sys.argv[2]

    if len(sys.argv) >= 4:
        palette_path = sys.argv[3]
        palette = load_palette_from_json(palette_path)
    else:
        print("No se proporcionó paleta. Usa paleta por defecto (ZX Spectrum clásico).")
        palette = [(0, 0, 0)] * 16  # Dummy palette para evitar errores

    block_types, png_file = parse_tsx(tsx_file)
    blocks = extract_blocks_from_png(png_file, list(block_types.keys()), palette)
    generate_agd(agd_file, blocks, block_types)
