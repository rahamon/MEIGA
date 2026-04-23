import sys
import re
import json
from PIL import Image, ImageDraw

# Tabla real de colores del CPC (firmware/hardware)
CPC_COLORS = [
    (0, 0, 0),         # 0 Black
    (0, 0, 128),       # 1 Blue
    (0, 0, 255),       # 2 Bright Blue
    (128, 0, 0),       # 3 Red
    (128, 0, 128),     # 4 Magenta
    (128, 0, 255),     # 5 Mauve
    (255, 0, 0),       # 6 Bright Red
    (255, 0, 128),     # 7 Purple
    (255, 0, 255),     # 8 Bright Magenta
    (0, 128, 0),       # 9 Green
    (0, 128, 128),     # 10 Cyan
    (0, 128, 255),     # 11 Sky Blue
    (128, 128, 0),     # 12 Yellow
    (128, 128, 128),   # 13 White
    (128, 128, 255),   # 14 Pastel Blue
    (255, 128, 0),     # 15 Orange
    (255, 128, 128),   # 16 Pink
    (255, 128, 255),   # 17 Pastel Magenta
    (0, 255, 0),       # 18 Bright Green
    (0, 255, 128),     # 19 Sea Green
    (0, 255, 255),     # 20 Bright Cyan
    (128, 255, 0),     # 21 Lime
    (128, 255, 128),   # 22 Pastel Green
    (128, 255, 255),   # 23 Pastel Cyan
    (255, 255, 0),     # 24 Bright Yellow
    (255, 255, 128),   # 25 Pastel Yellow
    (255, 255, 255),   # 26 Bright White
]

COLOR_NAMES = [
    "Black", "Blue", "Bright Blue", "Red", "Magenta", "Mauve", "Bright Red", "Purple",
    "Bright Magenta", "Green", "Cyan", "Sky Blue", "Yellow", "White", "Pastel Blue",
    "Orange", "Pink", "Pastel Magenta", "Bright Green", "Sea Green", "Bright Cyan",
    "Lime", "Pastel Green", "Pastel Cyan", "Bright Yellow", "Pastel Yellow", "Bright White"
]

if len(sys.argv) < 2:
    print("Uso: python Create_Palette.py <archivo.agd>")
    sys.exit(1)

agd_path = sys.argv[1]

# Leer archivo AGD
with open(agd_path, "r", encoding="utf-8") as file:
    lines = file.readlines()

# Buscar DEFINEPALETTE
palette_indices = []
for line in lines:
    if line.strip().startswith("DEFINEPALETTE"):
        numbers = re.findall(r'\d+', line)
        palette_indices = [int(n) for n in numbers]
        break

if len(palette_indices) != 16:
    print("Error: DEFINEPALETTE debe contener exactamente 16 colores.")
    sys.exit(1)

# Crear imagen visual
block_size = 8
img = Image.new("RGB", (16 * block_size, block_size))
draw = ImageDraw.Draw(img)

palette_data = []
for i, index in enumerate(palette_indices):
    if index >= len(CPC_COLORS):
        rgb = (0, 0, 0)
        name = "Unknown"
    else:
        rgb = CPC_COLORS[index]
        name = COLOR_NAMES[index] if index < len(COLOR_NAMES) else "Unknown"

    # Dibujar el bloque
    x = i * block_size
    draw.rectangle([x, 0, x + block_size - 1, block_size - 1], fill=rgb)

    # Guardar datos
    palette_data.append({
        "Pen": i,
        "DEFINEPALETTE valor": index,
        "RGB": list(rgb),
        "Color CPC": name,
    })

# Guardar imagen y JSON
img.save("paleta_cpc_directa.png")

with open("paleta_cpc_por_indice.json", "w", encoding="utf-8") as f:
    json.dump(palette_data, f, indent=4)

print("Imagen 'paleta_cpc_directa.png' y JSON 'paleta_cpc_por_indice.json' generados correctamente.")
