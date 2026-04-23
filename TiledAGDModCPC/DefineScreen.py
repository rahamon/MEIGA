import os
import sys
import json
import xml.etree.ElementTree as ET
from PIL import Image
import numpy as np
import re
from DefineSprites import extraer_sprites_desde_tsx

def load_sprite_types(json_file):
    """Carga los tipos de sprites desde MPAGDClass.json correctamente."""
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    for entry in data:
        if entry["name"] == "Type" and entry.get("type") == "enum":
            return {name: index for index, name in enumerate(entry["values"])}

    return {}  # Devuelve un diccionario vacío si no encuentra la información

def parse_tmx_layer(tmx_file):
    """Parsea la capa de tiles del archivo TMX y devuelve una matriz de IDs ajustados para AGD"""
    tree = ET.parse(tmx_file)
    root = tree.getroot()
    
    layer = root.find("layer")
    if layer is None:
        return []

    width = int(layer.get("width"))
    height = int(layer.get("height"))
    tile_data = layer.find("data").text.strip().split(",")
    
    return [[int(tile) - 1 for tile in tile_data[y * width:(y + 1) * width]] for y in range(height)]

def get_tileset_image(tmx_file, gid):
    """ Obtiene la ruta de la imagen del tileset que contiene el GID. """
    tree = ET.parse(tmx_file)
    root = tree.getroot()
    
    tilesets = []
    for tileset in root.findall("tileset"):
        firstgid = int(tileset.get("firstgid", "0"))
        source = tileset.get("source")  # Archivo TSX
        if source:
            tilesets.append((firstgid, source))

    tilesets.sort(reverse=True, key=lambda x: x[0])

    tsx_path = None
    for firstgid, tsx_file in tilesets:
        if gid >= firstgid:
            tsx_path = os.path.join(os.path.dirname(tmx_file), tsx_file)
            break

    if not tsx_path or not os.path.exists(tsx_path):
        return None

    tsx_tree = ET.parse(tsx_path)
    tsx_root = tsx_tree.getroot()
    image_element = tsx_root.find("image")
    if image_element is not None:
        return os.path.join(os.path.dirname(tsx_path), image_element.get("source"))

    return None

def extract_screen_number(tmx_file):
    """ Extrae el número de pantalla desde la propiedad 'Nombre' en el archivo TMX. """
    tree = ET.parse(tmx_file)
    root = tree.getroot()

    for properties in root.findall("properties"):
        for prop in properties.findall("property"):
            if prop.get("name") == "Nombre":
                screen_name = prop.get("value", "")
                if screen_name.startswith("Screen"):
                    return int(screen_name[6:])  # Extrae el número después de "Screen"
    return 0  # Valor por defecto si no se encuentra la propiedad

def extract_Sprite_number(tsx_file):
    """ Extrae el valor del atributo 'name' del elemento 'tileset' en un archivo TSX. """
    try:
        tree = ET.parse(tsx_file)
        root = tree.getroot()
        sprite_name = root.get("name")
        if sprite_name and sprite_name.startswith("Sprite"):
            num_part = sprite_name[6:]
            if num_part.isdigit():
                return int(num_part)
            else:
                print(f"Advertencia: El nombre '{sprite_name}' no contiene un número válido. Se ignorará.")
                return None
    except ET.ParseError:
        print("Error al analizar el archivo XML.")
    except FileNotFoundError:
        print("Archivo no encontrado.")
    return None


def archive_number(tsx_file):
    """Obtiene el número de sprite desde el nombre del archivo .tsx."""
    match = re.search(r"(\d+)\.tsx$", tsx_file, re.IGNORECASE)
    
    if match:
        return int(match.group(1))  # Extrae el número antes de ".tsx"
    
    print(f"Error: Nombre de archivo incorrecto '{tsx_file}'")
    return None  # Retorna None en caso de error

def extract_object_graphics(image_path, obj_gid, tile_size=16):
    """ Extrae los datos gráficos de un objeto en formato ZX Spectrum para DEFINEOBJECT. """
    img = Image.open(image_path).convert("1")  # Convertir a blanco y negro
    tile_x = (obj_gid % (img.width // tile_size)) * tile_size
    tile_y = (obj_gid // (img.width // tile_size)) * tile_size
    
    # Extraer el bitmap de 16x16 píxeles en bloques de 8 bits
    sprite_data = []
    for y in range(tile_size):
        byte_left = 0
        byte_right = 0
        for x in range(8):  # Mitad izquierda (8 píxeles)
            byte_left |= (1 if img.getpixel((tile_x + x, tile_y + y)) != 0 else 0) << (7 - x)
        for x in range(8, 16):  # Mitad derecha (8 píxeles)
            byte_right |= (1 if img.getpixel((tile_x + x, tile_y + y)) != 0 else 0) << (7 - (x - 8))
        
        sprite_data.append(byte_left)
        sprite_data.append(byte_right)
    
    return sprite_data

def adjust_gid(gid, firstgid_list):
    """ Ajusta el GID restando el firstgid correcto. """
    adjusted_gid = gid
    for firstgid in reversed(firstgid_list):
        if gid >= firstgid:
            adjusted_gid = gid - firstgid
            break
    return adjusted_gid

def get_tileset_firstgid(tmx_file):
    """ Obtiene los valores de firstgid de cada tileset en orden ascendente. """
    tree = ET.parse(tmx_file)
    root = tree.getroot()
    
    firstgid_list = [int(tileset.get("firstgid", "0")) for tileset in root.findall("tileset")]
    return sorted(firstgid_list)

def get_tileset_by_gid(tmx_file, gid):
    """ Obtiene la ruta del tileset que contiene el GID correspondiente. """
    tree = ET.parse(tmx_file)
    root = tree.getroot()
    
    tilesets = []
    for tileset in root.findall("tileset"):
        firstgid = int(tileset.get("firstgid", "0"))
        source = tileset.get("source")  # Nombre del archivo TSX
        if source:
            tilesets.append((firstgid, source))

    # Ordenamos en orden descendente para encontrar el tileset correcto
    tilesets.sort(reverse=True, key=lambda x: x[0])

    # Buscar el tileset correcto para el GID
    for firstgid, tsx_file in tilesets:
        if gid >= firstgid:
            tsx_path = os.path.join(os.path.dirname(tmx_file), tsx_file)
            
            # Verificamos si el archivo realmente existe
            if os.path.exists(tsx_path):
                return tsx_path
            
            print(f"Advertencia: El archivo TSX '{tsx_path}' no existe.")
            return None

    print(f"Error: No se encontró un tileset válido para GID {gid} en {tmx_file}")
    return None

def ExtractOffset_Enviroment():
    # Cargar el archivo ENVIROMENT.tmx
    tree = ET.parse("ENVIROMENT.tmx")
    root = tree.getroot()

    # Extraer los valores del grupo DEFINEWINDOW y dividirlos por 8
    define_window = root.find(".//objectgroup[@name='DEFINEWINDOW']/object[@name='WINDOW']")
    window_x = int(define_window.attrib['x'])
    window_y = int(define_window.attrib['y'])   # en pixels
    
    return window_x, window_y

def extract_sprite_positions(tmx_file, sprite_types_enum):
    """Extrae la información de los sprites desde la capa SPRITEPOSITION del archivo TMX"""
    # Cargar la lista de grupos de sprites desde Sprites.tsx
    sprite_groups = extraer_sprites_desde_tsx("Sprites.tsx")

    tree = ET.parse(tmx_file)
    root = tree.getroot()
    
    firstgid_list = get_tileset_firstgid(tmx_file)
    print("Diccionario de tipos de sprites:", sprite_types_enum)

    sprites = []
    for obj_group in root.findall("objectgroup"):
        if obj_group.get("name", "").upper() == "SPRITEPOSITION":
            for obj in obj_group.findall("object"):
                gid = int(obj.get("gid", "0"))
                tsx_file = get_tileset_by_gid(tmx_file, gid)
                if tsx_file is None:
                    print(f"Error: No se encontró un archivo TSX para GID {gid}")
                    continue  # Saltar este objeto y evitar el error
                    
                # DefineOffset_values
                win_x, win_y = ExtractOffset_Enviroment()
                
                # Sprite_number = archive_number(tsx_file) # numero obtenido del nombre del archivo tsx
                # numero obtenido de la propiedad name del archivo tsx
                Image_frame = adjust_gid(gid, firstgid_list)  # ID del tile ajustado

                # Buscar a qué sprite pertenece este tile_id
                Sprite_number = None
                for group in sprite_groups:
                    if Image_frame in group["tiles"]:
                        Sprite_number = group["sprite_id"]
                        break

                if Sprite_number is None:
                    print(f"⚠️  No se encontró sprite lógico para el frame {Image_frame} (GID {gid})")
                    continue  # Saltar este sprite si no se puede identificar

                # Coordenadas corregidas
                x = int(float(obj.get("x", "0")))
                y = int(float(obj.get("y", "0")))
                sprite_x = x + win_x
                sprite_y = y + win_y - 16

                # Obtener el tipo de sprite
                sprite_type = "NULL"
                for prop in obj.findall("properties/property"):
                    if prop.get("name") == "Type":
                        sprite_type = prop.get("value", "NULL")
                        break

                type_index = sprite_types_enum.get(sprite_type, sprite_types_enum.get("NULL", 9))
                sprites.append((type_index, Sprite_number, sprite_y, sprite_x))

    return sprites

def generate_agd_screen(screen_data, sprite_positions, output_file):
    """ Genera un archivo AGD en base a los datos extraídos. """
    with open(output_file, "w", encoding="utf-8") as f:
        f.write("DEFINESCREEN    ")
        f.write("".join(f"{num:>4}" for num in screen_data[0]) + "\n")
        
        for row in screen_data[1:]:
            f.write(" " * 16 + "".join(f"{num:>4}" for num in row) + "\n")
        
        f.write("\n")
        for sprite in sprite_positions:
            f.write(f"SPRITEPOSITION  {' '.join(map(str, sprite))}\n")
            
        f.write("\n")
        
def main():
    if len(sys.argv) < 4:
        print("Uso: python DefineScreen.py MAP.world MPAGDClass.json archivo_salida.agd")
        return

    world_file = sys.argv[1]
    json_file = sys.argv[2]
    output_file = sys.argv[3]

    # Leer el archivo .world como JSON
    with open(world_file, "r", encoding="utf-8") as f:
        world_data = json.load(f)

    sprite_types_enum = load_sprite_types(json_file)

    # Función auxiliar para extraer el número del nombre de pantalla
    def extract_screen_number_from_filename(filename):
        match = re.search(r"SCREEN(\d+)", filename, re.IGNORECASE)
        return int(match.group(1)) if match else float('inf')  # para que quede al final si no hay número

    # Ordenar las entradas por número de pantalla
    maps_sorted = sorted(
        world_data.get("maps", []),
        key=lambda entry: extract_screen_number_from_filename(entry.get("fileName", ""))
    )

    with open(output_file, "w", encoding="utf-8") as f_out:
        for map_entry in maps_sorted:
            tmx_path = map_entry.get("fileName")
            if not tmx_path or not os.path.exists(tmx_path):
                print(f"⚠️  Archivo TMX no encontrado o inválido: {tmx_path}")
                continue

            screen_data = parse_tmx_layer(tmx_path)
            sprite_positions = extract_sprite_positions(tmx_path, sprite_types_enum)

            f_out.write("DEFINESCREEN    ")
            f_out.write("".join(f"{num:>4}" for num in screen_data[0]) + "\n")
            for row in screen_data[1:]:
                f_out.write(" " * 16 + "".join(f"{num:>4}" for num in row) + "\n")
            f_out.write("\n")

            for sprite in sprite_positions:
                f_out.write(f"SPRITEPOSITION  {' '.join(map(str, sprite))}\n")
            f_out.write("\n")

            print(f"[OK] Añadido: {tmx_path}")

    print(f"[OK] Archivo generado: {output_file}")



    
if __name__ == "__main__":
    main()
