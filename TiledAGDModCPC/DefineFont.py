import sys
import os
import xml.etree.ElementTree as ET
from PIL import Image

def extract_font_data(png_file):
    image = Image.open(png_file).convert("L")
    width, height = image.size
    tiles_x = width // 8
    tiles_y = height // 8
    data = []

    for ty in range(tiles_y):
        for tx in range(tiles_x):
            x0 = tx * 8
            y0 = ty * 8
            char_bytes = []

            for y in range(8):
                byte = 0
                for x in range(8):
                    pixel = image.getpixel((x0 + x, y0 + y))
                    if pixel > 128:
                        byte |= (1 << (7 - x))
                char_bytes.append(byte)

            data.append(char_bytes)

    return data

def save_definefont_formatted(font_data, output_file):
    with open(output_file, "w", encoding="utf-8") as f:
        f.write("DEFINEFONT      " + " ".join(f"{b}" for b in font_data[0]) + "\n")
        for char in font_data[1:]:
            f.write("                " + " ".join(f"{b}" for b in char) + "\n")
    print(f"Archivo generado: {output_file}")

def get_image_source_from_tsx(tsx_file):
    tree = ET.parse(tsx_file)
    root = tree.getroot()
    image = root.find("image")
    if image is not None:
        return image.get("source")
    else:
        raise ValueError("No se encontró la etiqueta <image> en el archivo .tsx")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python TsxToAgdFont.py Font.tsx")
        sys.exit(1)

    tsx_file = sys.argv[1]
    try:
        image_path = get_image_source_from_tsx(tsx_file)
        base_path = os.path.dirname(tsx_file)
        full_image_path = os.path.join(base_path, image_path)
        font = extract_font_data(full_image_path)
        save_definefont_formatted(font, "DEFINEFONT.agd")
    except Exception as e:
        print("Error:", e)
        sys.exit(1)
