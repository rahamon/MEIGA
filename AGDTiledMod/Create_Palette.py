import sys
import re
import json
from PIL import Image, ImageDraw

# Si quieres ajustar el nivel de oscuridad, podrías probar con otros valores 
# (por ejemplo, 0.5 para más contraste, o 0.75 para que los colores oscuros no sean tan apagados).
BRIGHT_FACTOR = 0.75  # Factor de reducción de brillo si bright = 0

if len(sys.argv) < 2:
    print("Uso: python Create_Palette.py <archivo.agd> o --standard")
    sys.exit(1)

# Opción alternativa: paleta estándar ZX Spectrum
use_standard = "--standard" in sys.argv

# Función para convertir byte GGGRRRBB a RGB con simulación de brillo
def ulaplus_byte_to_rgb(byte, bright=None):
    blue_raw = byte & 0b00000011
    red = (byte >> 2) & 0b00000111
    green = (byte >> 5) & 0b00000111
    b_high = (blue_raw >> 1) & 1
    b_low = blue_raw & 1
    blue = (b_high << 2) | (b_low << 1) | b_high

    # Escalar canales
    r = int((red / 7) * 255)
    g = int((green / 7) * 255)
    b = int((blue / 7) * 255)

    # Aplicar brillo artificial
    if bright == 0:
        r = int(r * BRIGHT_FACTOR)
        g = int(g * BRIGHT_FACTOR)
        b = int(b * BRIGHT_FACTOR)

    return (r, g, b)

# Leer archivos AGD probando varias codificaciones
def read_agd(filename):
    encodings = ("utf-8-sig", "utf-8", "cp1252")

    for encoding in encodings:
        try:
            with open(filename, "r", encoding=encoding) as f:
                lines = f.readlines()

            print(f"AGD leído usando {encoding}")
            return lines

        except UnicodeDecodeError:
            pass

    raise UnicodeError(
        f"No se pudo decodificar el archivo '{filename}'"
    )


# Si usamos la paleta estándar
if use_standard:
    print("Usando paleta estándar del ZX Spectrum...")
    palette_values = [
        0, 3, 28, 31, 224, 227, 252, 255,
        0, 3, 28, 31, 224, 227, 252, 255
    ]
else:
    agd_path = sys.argv[1]

    secciones = [
        "EVENT", "DEFINEBLOCK", "DEFINEWINDOW", "DEFINESPRITE",
        "DEFINESCREEN", "SPRITEPOSITION", "DEFINEOBJECT", "MAP",
        "STARTSCREEN", "WIDTH", "ENDMAP", "DEFINEPALETTE",
        "DEFINEMESSAGES", "DEFINEFONT", "DEFINEJUMP", "DEFINECONTROLS"
    ]

    # Antes:
    # with open(agd_path, "r", encoding="utf-8") as file:
    #     lines = file.readlines()

    # Ahora:
    lines = read_agd(agd_path)


    palette_section = []
    in_palette = False
    for line in lines:
        linea_limpia = line.strip()
        if linea_limpia.startswith("DEFINEPALETTE"):
            in_palette = True
        elif in_palette:
            if any(linea_limpia.startswith(s) for s in secciones if s != "DEFINEPALETTE"):
                break
        if in_palette:
            palette_section.append(line)
    
    # Ya no guardamos DEFINEPALETTE.agd
    # with open("DEFINEPALETTE.agd", "w", encoding="utf-8") as out_file:
        # out_file.writelines(palette_section)

    # print("Sección DEFINEPALETTE guardada correctamente en: DEFINEPALETTE.agd")

    # Extraer hasta 64 colores
    palette_values = []
    for line in palette_section:
        numbers = re.findall(r'\d+', line)
        palette_values.extend([int(n) for n in numbers])
        if len(palette_values) >= 64:
            palette_values = palette_values[:64]
            break

# Convertir todos los bytes a RGB, aplicando brillo real
palette_rgb = [ulaplus_byte_to_rgb(byte, 0 if i < 8 else 1) for i, byte in enumerate(palette_values[:16])]

# Crear imagen de 16 colores en 1 fila (índice visual = orden de definición)
block_size = 8
cols = 16
rows = 1
img_width = cols * block_size
img_height = rows * block_size

image = Image.new("RGB", (img_width, img_height))
draw = ImageDraw.Draw(image)

for idx, color in enumerate(palette_rgb):
    x = (idx % cols) * block_size
    y = 0
    draw.rectangle([x, y, x + block_size, y + block_size], fill=color)

image.save("paleta_extraida_16cols.png")

# Crear JSON con los 16 primeros colores y su información
attribute_rgb = []
for i in range(16):
    color = palette_rgb[i]
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

# Exportar todo
guardar_como_gpl(palette_rgb)
guardar_como_act(palette_rgb)
print("Archivos GIMP.gpl y Photoshop.act generados correctamente.")

print("Imagen y JSON generados correctamente.")

# Crear archivo TSX correspondiente a la imagen PNG sin propiedades, con nombre "Armony"
def crear_tsx(nombre_imagen, nombre_tsx, ancho_tile, alto_tile, num_tiles):
    tsx = f'''<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.11.2" name="Armony" tilewidth="{ancho_tile}" tileheight="{alto_tile}" tilecount="{num_tiles}" columns="{num_tiles}">
 <image source="{nombre_imagen}" width="{ancho_tile * num_tiles}" height="{alto_tile}"/>\n'''
    
    for i in range(num_tiles):
        tsx += f' <tile id="{i}"/>\n'
    
    tsx += '</tileset>\n'
    with open(nombre_tsx, "w", encoding="utf-8") as f:
        f.write(tsx)

# Llamada a la función de creación del TSX con nombre Palette.tsx
crear_tsx("paleta_extraida_16cols.png", "Palette.tsx", block_size, block_size, len(palette_rgb))
print("Archivo TSX generado correctamente.")
