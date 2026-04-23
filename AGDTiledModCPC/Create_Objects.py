import os
import json
import xml.etree.ElementTree as ET
from PIL import Image
import sys

TILE_SIZE = 16
TILES_PER_ROW = 16
TILE_WIDTH = 8
TILE_HEIGHT = 16

# Corrección personalizada de índice de color:
def corregir_indice(idx):
    if idx < 8:
        return idx + 1 if idx % 2 == 0 else idx + 8
    else:
        return idx - 8 if idx % 2 == 0 else idx - 1

def load_palette_from_json(json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    palette = [None] * 16
    for color in data:
        pen = color["Pen"]
        rgb = tuple(color["RGB"])
        palette[pen] = rgb
    return palette

def decode_mode0_byte(byte):
    a = ((byte >> 7) & 1) << 3 | ((byte >> 5) & 1) << 2 | ((byte >> 3) & 1) << 1 | ((byte >> 1) & 1)
    b = ((byte >> 6) & 1) << 3 | ((byte >> 4) & 1) << 2 | ((byte >> 2) & 1) << 1 | ((byte >> 0) & 1)
    return a, b

def sprite_to_image(frame_data, palette):
    img = Image.new('RGB', (TILE_WIDTH, TILE_HEIGHT))
    pixels = img.load()
    for y in range(TILE_HEIGHT):
        for x in range(TILE_WIDTH // 2):
            byte = frame_data[y * (TILE_WIDTH // 2) + x]
            a, b = decode_mode0_byte(byte)
            px = x * 2
            if px < TILE_WIDTH:
                pixels[px, y] = palette[corregir_indice(a)]
            if px + 1 < TILE_WIDTH:
                pixels[px + 1, y] = palette[corregir_indice(b)]
    return img

def generate_tileset_image(frames):
    columns = TILES_PER_ROW
    rows = (len(frames) + columns - 1) // columns
    image = Image.new('RGB', (columns * TILE_WIDTH, rows * TILE_HEIGHT))
    for idx, frame in enumerate(frames):
        x = (idx % columns) * TILE_WIDTH
        y = (idx // columns) * TILE_HEIGHT
        image.paste(frame, (x, y))
    return image

def create_tileset_image(objects, output_png, palette):
    frames = [sprite_to_image(obj["sprite"], palette) for obj in objects]
    image = generate_tileset_image(frames)
    image.save(output_png)

def parse_agd_defineobjects(agd_file):
    with open(agd_file, encoding="utf-8") as f:
        lines = [line.strip() for line in f if line.strip()]

    objects = []
    i = 0
    while i < len(lines):
        if lines[i].startswith("DEFINEOBJECT"):
            header = lines[i].split()
            room = int(header[1])
            y = int(header[2])
            x = int(header[3])

            sprite = []
            i += 1
            while i < len(lines) and not lines[i].startswith("DEFINE") and len(sprite) < 64:
                sprite.extend(map(int, lines[i].split()))
                i += 1

            sprite = sprite[:64]
            objects.append({
                "room": room,
                "x": x,
                "y": y,
                "sprite": sprite
            })
        else:
            i += 1
    return objects

def create_tsx_file(output_tsx, image_file, count, objects):
    tsx = ET.Element("tileset", {
        "version": "1.10",
        "tiledversion": "1.10.2",
        "name": "Objects",
        "tilewidth": str(TILE_WIDTH),
        "tileheight": str(TILE_HEIGHT),
        "tilecount": str(count),
        "columns": str(TILES_PER_ROW),
        "class": "MPAGD.Inventary"
    })
    ET.SubElement(tsx, "image", {
        "source": image_file,
        "width": str(TILES_PER_ROW * TILE_WIDTH),
        "height": str(((count + TILES_PER_ROW - 1) // TILES_PER_ROW) * TILE_HEIGHT)
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
        print("⚠ No se encontró MAP.world")
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
            print(f"➕ Añadido tileset '{tsx_file}' a {filename}")

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
            print(f"⚠ Pantalla no encontrada: {screen_file}")
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
        y = obj["y"] - win_y + TILE_HEIGHT
        ET.SubElement(objectgroup, "object", {
            "id": str(1000 + obj_id),
            "gid": str(gid),
            "x": str(x),
            "y": str(y),
            "width": str(TILE_WIDTH),
            "height": str(TILE_HEIGHT),
            "type": "MPAGD.Location"
        })
        tree.write(screen_file, encoding="utf-8", xml_declaration=True)
        print(f"✔ Insertado objeto en {screen_file} (x={x}, y={y})")

def main():
    if len(sys.argv) < 2:
        print("Uso: python Create_Objects.py archivo.agd")
        return
    agd_file = sys.argv[1]
    palette_file = "paleta_cpc_por_indice.json"  # Paleta fija por defecto
    cpc_palette = load_palette_from_json(palette_file)
    png_file = "Objects.png"
    tsx_file = "Objects.tsx"
    print("Leyendo objetos desde", agd_file)
    objects = parse_agd_defineobjects(agd_file)
    print(f"Se han leído {len(objects)} objetos.")
    if not objects:
        print("⚠ No hay objetos definidos. No se generará imagen, TSX ni se insertarán objetos.")
        return
    print("Generando imagen del tileset...")
    create_tileset_image(objects, png_file, cpc_palette)
    print("Generando archivo TSX...")
    create_tsx_file(tsx_file, png_file, len(objects), objects)
    print("Asegurando que las pantallas del mundo tengan el tileset...")
    ensure_tileset_in_tmx_from_world(tsx_file)
    print("Insertando objetos en pantallas existentes...")
    insert_objects_into_tmx(objects, tsx_file)
    print("✅ Proceso completo.")

if __name__ == "__main__":
    main()
