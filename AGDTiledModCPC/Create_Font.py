import sys
import xml.etree.ElementTree as ET
from PIL import Image

def parse_definefont(agd_file):
    with open(agd_file, encoding='utf-8') as f:
        lines = f.readlines()

    font_data = []
    in_font = False

    for line in lines:
        line = line.strip()
        if line.startswith("DEFINEFONT"):
            in_font = True
            parts = line.split()
            if len(parts) > 1:
                try:
                    font_data.append(list(map(int, parts[1:])))
                except ValueError:
                    print(f"Error en línea DEFINEFONT: '{line}'")
            continue
        if in_font:
            if line == "" or line.startswith("DEFINE"):
                break
            try:
                values = list(map(int, line.split()))
                font_data.append(values)
            except ValueError:
                print(f"Error en línea: '{line}'")
                continue

    return font_data


def generate_font_png(font_data, png_file, per_row=16):
    rows = (len(font_data) + per_row - 1) // per_row
    image = Image.new("RGB", (per_row * 8, rows * 8), "black")
    pixels = image.load()

    for index, char_data in enumerate(font_data):
        cx = index % per_row
        cy = index // per_row
        x0 = cx * 8
        y0 = cy * 8

        for y, byte in enumerate(char_data):
            for x in range(8):
                if byte & (1 << (7 - x)):
                    pixels[x0 + x, y0 + y] = (255, 255, 255)

    image.save(png_file)

def generate_font_tsx(tsx_file, png_filename, num_chars, per_row=16):
    tileset = ET.Element("tileset", version="1.10", tiledversion="1.10.2",
                         name="Font", tilewidth="8", tileheight="8",
                         tilecount=str(num_chars), columns=str(per_row))
    ET.SubElement(tileset, "image", source=png_filename,
                  width=str(per_row * 8), height=str((num_chars + per_row - 1) // per_row * 8))

    for i in range(num_chars):
        ET.SubElement(tileset, "tile", id=str(i), type="MPAGD.Font")

    tree = ET.ElementTree(tileset)
    tree.write(tsx_file, encoding="UTF-8", xml_declaration=True)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Uso: python AgdFontToTsx.py archivo.agd Font.tsx Font.png")
        sys.exit(1)

    agd_file, tsx_file, png_file = sys.argv[1], sys.argv[2], sys.argv[3]
    font = parse_definefont(agd_file)
    generate_font_png(font, png_file)
    generate_font_tsx(tsx_file, png_file, len(font))
    print("Conversión completa.")
