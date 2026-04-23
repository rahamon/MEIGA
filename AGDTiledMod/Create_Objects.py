import os
import json
import xml.etree.ElementTree as ET
from PIL import Image
import sys
import math  # Añade esto al principio del archivo, si no está

TILE_SIZE = 16
TILES_PER_ROW = 16

def decode_attribute(attribute):
    flash = (attribute >> 7) & 1
    bright = (attribute >> 6) & 1
    paper_index = (attribute >> 3) & 0b111
    ink_index = attribute & 0b111

    if bright:
        paper_index += 8
        ink_index += 8

    return paper_index, ink_index

def load_palette_from_json(json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    palette = [(entry["R"], entry["G"], entry["B"]) for entry in sorted(data, key=lambda x: x["Indice atributo"])]
    return palette

def parse_agd_defineobjects(agd_file):
    with open(agd_file, encoding="utf-8") as f:
        lines = [line.strip() for line in f if line.strip()]

    objects = []
    i = 0
    while i < len(lines):
        if lines[i].startswith("DEFINEOBJECT"):
            header = lines[i].split()
            attr = int(header[1])
            room = int(header[2])
            y = int(header[3])
            x = int(header[4])
            data1 = list(map(int, lines[i + 1].split()))
            data2 = list(map(int, lines[i + 2].split()))
            sprite = data1 + data2
            objects.append({"attr": attr, "room": room, "x": x, "y": y, "sprite": sprite})
            i += 3
        else:
            i += 1
    return objects

def create_monochrome_image(objects, objects_per_row=TILES_PER_ROW):
    rows = (len(objects) + objects_per_row - 1) // objects_per_row
    width = objects_per_row * TILE_SIZE
    height = rows * TILE_SIZE

    img = Image.new("1", (width, height), 0)  # Modo 1-bit
    pixels = img.load()

    for idx, obj in enumerate(objects):
        col = idx % objects_per_row
        row = idx // objects_per_row
        x_offset = col * TILE_SIZE
        y_offset = row * TILE_SIZE

        for y in range(16):
            byte1 = obj["sprite"][y * 2]
            byte2 = obj["sprite"][y * 2 + 1]
            for x in range(8):
                pixels[x_offset + x, y_offset + y] = (byte1 >> (7 - x)) & 1
            for x in range(8):
                pixels[x_offset + 8 + x, y_offset + y] = (byte2 >> (7 - x)) & 1

    return img


def color_distance(c1, c2):
    """Calcula la distancia euclídea entre dos colores RGB"""
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1, c2)))

def apply_palette_to_monochrome(monochrome_img, objects, palette, objects_per_row=TILES_PER_ROW):
    width, height = monochrome_img.size
    color_img = Image.new("RGB", (width, height), (0, 0, 0))
    mono_pixels = monochrome_img.load()
    color_pixels = color_img.load()

    THRESHOLD = 80  # Distancia mínima entre tinta y papel (ajustable)

    for idx, obj in enumerate(objects):
        col = idx % objects_per_row
        row = idx // objects_per_row
        x_offset = col * TILE_SIZE
        y_offset = row * TILE_SIZE

        paper_index, ink_index = decode_attribute(obj["attr"])
        paper_color = palette[paper_index]
        ink_color = palette[ink_index]

        if color_distance(paper_color, ink_color) < THRESHOLD:
            found = False
            for color in palette:
                if color_distance(color, paper_color) >= THRESHOLD:
                    ink_color = color
                    found = True
                    break
            if not found:
                print(f"⚠️ Objeto {idx}: tinta y papel visualmente iguales. Usando color alternativo.")
                ink_color = (255, 0, 255)  # Rosa fuerte como color visible de emergencia


        for y in range(TILE_SIZE):
            for x in range(TILE_SIZE):
                bit = mono_pixels[x_offset + x, y_offset + y]
                color_pixels[x_offset + x, y_offset + y] = ink_color if bit else paper_color

    return color_img

def create_tileset_image(objects, output_png, palette):
    mono = create_monochrome_image(objects)
    color = apply_palette_to_monochrome(mono, objects, palette)
    color.save(output_png)
    print(f"[✓] Imagen PNG generada: {output_png}")

def create_tsx_file(output_tsx, image_file, count, objects):
    tsx = ET.Element("tileset", {
        "version": "1.10",
        "tiledversion": "1.10.2",
        "name": "Objects",
        "tilewidth": "16",
        "tileheight": "16",
        "tilecount": str(count),
        "columns": str(TILES_PER_ROW),
        "class": "MPAGD.Inventary"
    })
    image = ET.SubElement(tsx, "image", {
        "source": image_file,
        "width": str(TILES_PER_ROW * TILE_SIZE),
        "height": str(((count + TILES_PER_ROW - 1) // TILES_PER_ROW) * TILE_SIZE)
    })

    for i, obj in enumerate(objects):
        tile = ET.SubElement(tsx, "tile", {"id": str(i), "type": "MPAGD.Object"})
        if obj["room"] == 254:
            prop_val = "Hidden"
        elif obj["room"] == 255:
            prop_val = "Carrying"
        else:
            prop_val = None

        if prop_val:
            props = ET.SubElement(tile, "properties")
            ET.SubElement(props, "property", {
                "name": "StartRoom",
                "propertytype": "Handling",
                "value": prop_val
            })

    tree = ET.ElementTree(tsx)
    ET.indent(tree, space="  ", level=0)
    tree.write(output_tsx, encoding="utf-8", xml_declaration=True)

def ensure_tileset_in_tmx_from_world(tsx_file, world_file="MAP.world"):
    if not os.path.exists(world_file):
        print("\u26a0 No se encontr\u00f3 MAP.world")
        return
    with open(world_file, "r", encoding="utf-8") as f:
        data = json.load(f)
    for entry in data.get("maps", []):
        filename = entry.get("fileName")
        if not filename or not os.path.exists(filename):
            continue
        tree = ET.parse(filename)
        root = tree.getroot()
        already_has = any(ts.get("source") == tsx_file for ts in root.findall("tileset"))
        if not already_has:
            ET.SubElement(root, "tileset", {"firstgid": "1", "source": tsx_file})
            tree.write(filename, encoding="utf-8", xml_declaration=True)
            print(f"\u2795 A\u00f1adido tileset '{tsx_file}' a {filename}")

def ExtractOffset_Enviroment():
    tree = ET.parse("ENVIROMENT.tmx")
    root = tree.getroot()
    define_window = root.find(".//objectgroup[@name='DEFINEWINDOW']/object[@name='WINDOW']")
    window_x = int(define_window.attrib['x'])
    window_y = int(define_window.attrib['y'])
    return window_x, window_y

def insert_objects_into_tmx(objects, tsx_source):
    for obj_id, obj in enumerate(objects):
        if obj["room"] >= 254:
            continue

        screen_file = f"SCREEN{obj['room']:03}.tmx"
        if not os.path.exists(screen_file):
            print(f"\u26a0 Pantalla no encontrada: {screen_file}")
            continue

        tree = ET.parse(screen_file)
        root = tree.getroot()
        objectgroup = None

        for layer in root.findall("objectgroup"):
            if layer.get("name") == "DEFINEOBJECT":
                objectgroup = layer
                break

        if objectgroup is None:
            objectgroup = ET.SubElement(root, "objectgroup", {"name": "DEFINEOBJECT"})

        win_x, win_y = ExtractOffset_Enviroment()

        gid = obj_id + 1
        x = obj["x"] - win_x
        y = obj["y"] - win_y + 16
        ET.SubElement(objectgroup, "object", {
            "id": str(1000 + obj_id),
            "gid": str(gid),
            "x": str(x),
            "y": str(y),
            "width": "16",
            "height": "16",
            "type": "MPAGD.Location"
        })

        tree.write(screen_file, encoding="utf-8", xml_declaration=True)
        print(f"\u2714 Insertado objeto en {screen_file} (x={x}, y={y})")

def main():
    if len(sys.argv) < 2:
        print("Uso: python agd_to_tmx.py DEFINEOBJECT.agd")
        return

    agd_file = sys.argv[1]
    png_file = "Objects.png"
    tsx_file = "Objects.tsx"
    palette_path = os.path.join(os.path.dirname(__file__), "paleta_rgb_por_atributo.json")

    print("Leyendo objetos desde", agd_file)
    objects = parse_agd_defineobjects(agd_file)
    print(f"Se han leído {len(objects)} objetos.")

    if not objects:
        print("\u26a0 No hay objetos definidos. No se generará imagen, TSX ni se insertarán objetos.")
        return

    palette = load_palette_from_json(palette_path)

    print("Generando imagen del tileset...")
    create_tileset_image(objects, png_file, palette)

    print("Generando archivo TSX...")
    create_tsx_file(tsx_file, png_file, len(objects), objects)

    print("Asegurando que las pantallas del mundo tengan el tileset...")
    ensure_tileset_in_tmx_from_world(tsx_file)

    print("Insertando objetos en pantallas existentes...")
    insert_objects_into_tmx(objects, tsx_file)

    print("\u2705 Proceso completo.")

if __name__ == "__main__":
    main()
