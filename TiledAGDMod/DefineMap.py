import json
import sys
import re
import xml.etree.ElementTree as ET

def read_json(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)

def extract_number_from_filename(file_name):
    match = re.search(r"(\d{3})", file_name)  # Buscar exactamente tres dígitos en el nombre del archivo
    return int(match.group(1)) if match else 255  # Si no se encuentra, devolver 255 como valor predeterminado

def get_start_screen_from_tmx(tmx_file):
    tree = ET.parse(tmx_file)
    root = tree.getroot()
    
    for objgroup in root.findall(".//objectgroup[@class='MPAGD.StartScreen']"):
        for prop in objgroup.findall("properties/property[@name='Nombre']"):
            match = re.search(r"(\d{3})", prop.attrib.get("value", ""))
            if match:
                return int(match.group(1))
    
    return 0  # Valor por defecto si no se encuentra el número

def create_matrix(maps):
    # Determinar los valores mínimos y máximos de x y de y
    min_x = min(map['x'] for map in maps)
    min_y = min(map['y'] for map in maps)
    max_x = max(map['x'] for map in maps)
    max_y = max(map['y'] for map in maps)

    width, height = maps[0]['width'], maps[0]['height']
    rows = ((max_y - min_y) // height) + 1
    cols = ((max_x - min_x) // width) + 1

    # Inicializar la matriz con 255
    matrix = [[255 for _ in range(cols)] for _ in range(rows)]
    
    # Obtener los números de los archivos TMX
    file_numbers = {m['fileName']: extract_number_from_filename(m['fileName']) for m in maps}
    
    # Colocar los números en la matriz
    for map_data in maps:
        x = (map_data['x'] - min_x) // width
        y = (map_data['y'] - min_y) // height
        number = file_numbers[map_data['fileName']]
        matrix[y][x] = number
    
    return matrix

def save_map_to_file(matrix, start_screen, output_file="MAP.agd"):
    with open(output_file, "w") as file:
        width_with_padding = len(matrix[0]) + 2  # Se añaden dos columnas
        file.write(f"MAP" + " " * 13 + f"WIDTH {width_with_padding}\n")
        file.write(f" " * 16 + f"STARTSCREEN {start_screen}\n")

        for row in matrix:
            padded_row = [255] + row + [255]
            file.write(" " * 13 + "".join(str(num).rjust(4) for num in padded_row) + "\n")

        file.write(f"ENDMAP\n\n")
    print(f"MAP saved to {output_file}")


def main(json_file, tmx_file):
    data = read_json(json_file)
    maps = data.get('maps', [])
    
    if not maps:
        print("No maps found in the provided JSON file.")
        return
    
    matrix = create_matrix(maps)
    start_screen = get_start_screen_from_tmx(tmx_file)
    save_map_to_file(matrix, start_screen)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <path_to_json_file> <path_to_tmx_file>")
        sys.exit(1)
    
    main(sys.argv[1], sys.argv[2])
