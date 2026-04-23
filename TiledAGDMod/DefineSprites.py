import xml.etree.ElementTree as ET
import os
import numpy as np
from PIL import Image

# Paleta estándar del ZX Spectrum
ZX_SPECTRUM_PALETTE = [
    (0, 0, 0), (0, 0, 192), (192, 0, 0), (192, 0, 192),
    (0, 192, 0), (0, 192, 192), (192, 192, 0), (192, 192, 192),
    (0, 0, 0), (0, 0, 255), (255, 0, 0), (255, 0, 255),
    (0, 255, 0), (0, 255, 255), (255, 255, 0), (255, 255, 255)
]

def buscar_archivos_tsx():
    """Busca archivos .tsx en el directorio actual que tengan class='MPAGD.Sprite'."""
    archivos_encontrados = []

    for archivo in os.listdir("."):
        if archivo.endswith(".tsx"):
            try:
                tree = ET.parse(archivo)
                root = tree.getroot()
                if root.tag == "tileset" and root.get("class") == "MPAGD.Sprite":
                    archivos_encontrados.append(archivo)
            except ET.ParseError:
                print(f"Error al analizar {archivo}, podría no ser un archivo XML válido.")
    
    return archivos_encontrados

def extraer_tileset_image(tsx_path):
    """Extrae la ruta de la imagen del tileset desde un archivo TSX."""
    tsx_tree = ET.parse(tsx_path)
    tsx_root = tsx_tree.getroot()
    image_element = tsx_root.find("image")

    if image_element is not None:
        img_path = os.path.join(os.path.dirname(tsx_path), image_element.get("source"))
        if os.path.exists(img_path):
            return img_path
        else:
            print(f"Error: No se encontró la imagen {img_path}")
    return None

def extraer_sprites_desde_tsx(archivo_tsx):
    """Analiza un archivo TSX y extrae los sprites con sus frames."""
    
    tree = ET.parse(archivo_tsx)
    root = tree.getroot()

    sprites = []
    sprite_actual = []
    frame_contador = 0
    ultimo_id = None

    for tile in sorted(root.findall("tile"), key=lambda t: int(t.get("id"))):
        tile_id = int(tile.get("id"))
        tile_type = tile.get("type")

        if tile_type != "MPAGD.Image":
            continue
        
        propiedades = tile.find("properties")
        es_skip = False
        es_last_frame = False

        if propiedades is not None:
            for prop in propiedades.findall("property"):
                if prop.get("name") == "Item of FRAMES" and prop.get("value") == "Skip":
                    es_skip = True
                elif prop.get("name") == "Item of FRAMES" and prop.get("value") == "Last Frame":
                    es_last_frame = True

        if es_skip:
            continue

        if frame_contador == 0 or (ultimo_id is not None and tile_id != ultimo_id + 1):
            if sprite_actual:
                sprites.append({"sprite_id": len(sprites), "frames": frame_contador, "tiles": sprite_actual})
            
            sprite_actual = []
            frame_contador = 1
        else:
            frame_contador += 1

        sprite_actual.append(tile_id)
        ultimo_id = tile_id

        if es_last_frame:
            sprites.append({"sprite_id": len(sprites), "frames": frame_contador, "tiles": sprite_actual})
            sprite_actual = []
            frame_contador = 0
            ultimo_id = None

    if sprite_actual:
        sprites.append({"sprite_id": len(sprites), "frames": frame_contador, "tiles": sprite_actual})

    return sprites

def extract_sprite_graphics(image_path, tile_id, tile_size=16): 
    """ Extrae los datos gráficos de un sprite en formato ZX Spectrum. """
    img = Image.open(image_path).convert("1")
    tile_x = (tile_id % (img.width // tile_size)) * tile_size
    tile_y = (tile_id // (img.width // tile_size)) * tile_size
    
    sprite_data = []
    for y in range(tile_size):
        byte_left = 0
        byte_right = 0
        for x in range(8):  
            byte_left |= (1 if img.getpixel((tile_x + x, tile_y + y)) != 0 else 0) << (7 - x)
        for x in range(8, 16):  
            byte_right |= (1 if img.getpixel((tile_x + x, tile_y + y)) != 0 else 0) << (7 - (x - 8))
        
        sprite_data.append(byte_left)
        sprite_data.append(byte_right)
    
    return sprite_data

def generar_definesprite(sprites, tileset_image, output_file="DEFINESPRITE.agd"):
    """Genera el archivo DEFINESPRITE.agd con todos los sprites extraídos."""
    with open(output_file, "w") as f:
        for sprite in sprites:
            f.write(f"DEFINESPRITE    {sprite['frames']}\n")
            for tile in sprite["tiles"]:  
                sprite_graphics = extract_sprite_graphics(tileset_image, tile) if tileset_image else [0] * 32
                
                formatted_sprite = (
                    f"                {' '.join(map(str, sprite_graphics[:16]))}\n"
                    f"                {' '.join(map(str, sprite_graphics[16:]))}\n"
                )
                f.write(formatted_sprite)
            f.write("\n")

if __name__ == "__main__":
    archivos = buscar_archivos_tsx()
    if archivos:
        archivo_tsx = archivos[0]
        sprites_extraidos = extraer_sprites_desde_tsx(archivo_tsx)
        tileset_image = extraer_tileset_image(archivo_tsx)
        if sprites_extraidos:
            generar_definesprite(sprites_extraidos, tileset_image)
