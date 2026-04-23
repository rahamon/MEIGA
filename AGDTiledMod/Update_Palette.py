import xml.etree.ElementTree as ET
from PIL import Image, ImageDraw
import json
import sys
import os

if len(sys.argv) < 2:
    print("Uso: python Update_Palette.py Palette.tsx")
    sys.exit(1)

tsx_path = sys.argv[1]

# Cargar el archivo TSX
tree = ET.parse(tsx_path)
root = tree.getroot()

# Leer atributos del tileset
image_element = root.find("image")
image_source = image_element.attrib["source"]
tile_width = int(root.attrib["tilewidth"])
tile_height = int(root.attrib["tileheight"])
tile_count = int(root.attrib["tilecount"])
columns = int(root.attrib["columns"])

# Cargar la imagen
if not os.path.exists(image_source):
    print(f"No se encuentra la imagen referenciada: {image_source}")
    sys.exit(1)

image = Image.open(image_source)
pixels = image.load()

# Leer el primer píxel de cada tile
palette_rgb = []
for i in range(tile_count):
    x = (i % columns) * tile_width
    y = (i // columns) * tile_height
    r, g, b = pixels[x, y]
    palette_rgb.append((r, g, b))

# Generar JSON con los 16 primeros colores
attribute_rgb = []
for i, color in enumerate(palette_rgb[:16]):
    attribute_rgb.append({
        "Indice atributo": i,
        "Bright": 1 if i >= 8 else 0,
        "Paleta indice": i,
        "RGB": color,
        "R": color[0],
        "G": color[1],
        "B": color[2]
    })

with open("paleta_rgb_por_atributo.json", "w", encoding="utf-8") as json_file:
    json.dump(attribute_rgb, json_file, indent=4)

print("Archivo paleta_rgb_por_atributo.json generado correctamente.")

# Guardar .gpl (GIMP)
def guardar_como_gpl(palette_rgb, nombre_archivo="paleta.gpl"):
    with open(nombre_archivo, "w", encoding="utf-8") as f:
        f.write("GIMP Palette\n")
        f.write("Name: ZX Palette\n")
        f.write("Columns: 8\n")
        f.write("#\n")
        for r, g, b in palette_rgb:
            f.write(f"{r:3} {g:3} {b:3} Color\n")

# Guardar .act (Photoshop)
def guardar_como_act(palette_rgb, nombre_archivo="paleta.act"):
    with open(nombre_archivo, "wb") as f:
        for r, g, b in palette_rgb:
            f.write(bytes([r, g, b]))
        for _ in range(256 - len(palette_rgb)):
            f.write(b'\x00\x00\x00')  # Relleno

guardar_como_gpl(palette_rgb)
guardar_como_act(palette_rgb)
print("Archivos paleta.gpl y paleta.act generados correctamente.")

# Crear imagen de vista previa (igual que en Create_Palette.py)
block_size = 8
cols = 16
rows = 1
img_width = cols * block_size
img_height = rows * block_size

vista_previa = Image.new("RGB", (img_width, img_height))
draw = ImageDraw.Draw(vista_previa)

for idx, color in enumerate(palette_rgb[:16]):
    x = idx * block_size
    draw.rectangle([x, 0, x + block_size, block_size], fill=color)

vista_previa.save("paleta_extraida_16cols.png")
print("Imagen paleta_extraida_16cols.png generada correctamente.")
