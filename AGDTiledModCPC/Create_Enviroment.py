import sys
import xml.etree.ElementTree as ET

def parse_data_file(data_file):
    window_values = None
    control_keys = None

    try:
        # <- CAMBIO AQUÍ: codificación cp1252 para evitar errores de decodificación
        with open(data_file, 'r', encoding='utf-8') as f:
            for line in f:
                parts = line.strip().split()
                if len(parts) < 2:
                    continue
                if parts[0] == 'DEFINEWINDOW':
                    window_values = tuple(map(int, parts[1:]))
                elif parts[0] == 'DEFINECONTROLS':
                    control_keys = [eval(c) for c in parts[1:]]
    except FileNotFoundError:
        print(f"Error: El archivo '{data_file}' no se encontró.")
        return None, None
    except Exception as e:
        print(f"Error al procesar el archivo '{data_file}': {e}")
        return None, None

    if not window_values or not control_keys:
        print("Error: No se encontraron datos válidos en el archivo para DEFINEWINDOW o DEFINECONTROLS.")
        return None, None

    window_values = tuple(v * 8 for v in window_values)  # convertir a píxeles
    return window_values, control_keys

def update_xml_values(xml_file, data_file):
    window_values, control_keys = parse_data_file(data_file)
    if not window_values or not control_keys:
        return

    tree = ET.parse(xml_file)
    root = tree.getroot()

    # Actualizar ventana
    for obj in root.findall(".//objectgroup[@name='DEFINEWINDOW']/object"):
        if obj.attrib.get('name') == 'WINDOW':
            obj.set('x', str(window_values[1]))
            obj.set('y', str(window_values[0]))
            obj.set('width', str(window_values[3]))
            obj.set('height', str(window_values[2]))

    # Actualizar controles
    control_names = ["UP", "DOWN", "LEFT", "RIGHT", "FIRE 1", "FIRE 2", "FIRE 3", "OPTION 1", "OPTION 2", "OPTION 3", "OPTION 4"]
    for prop_name, new_value in zip(control_names, control_keys):
        for prop in root.findall(".//objectgroup[@name='DEFINECONTROLS']/properties/property"):
            if prop.attrib.get('name') == prop_name:
                prop.set('value', str(new_value))

    # Leer STARTSCREEN del archivo .agd
    start_screen = None
    with open(data_file, 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip().startswith("STARTSCREEN"):
                parts = line.strip().split()
                if len(parts) == 2:
                    try:
                        start_screen = int(parts[1])
                    except ValueError:
                        print("Error: STARTSCREEN no tiene un número válido.")
                break

    # Actualizar propiedad 'Nombre' en STARTSCREEN
    if start_screen is not None:
        screen_name = f"SCREEN{start_screen:04}.tmx"
        group = root.find(".//objectgroup[@name='STARTSCREEN']")
        if group is not None:
            for prop in group.findall("./properties/property"):
                if prop.attrib.get("name") == "Nombre":
                    prop.set("value", screen_name)
                    print(f"Propiedad 'Nombre' en STARTSCREEN actualizada a: {screen_name}")
                    break
        else:
            print("Aviso: no se encontró el grupo STARTSCREEN en el archivo TMX.")

    tree.write(xml_file, encoding='utf-8', xml_declaration=True)
    print(f"ENVIROMENT.tmx actualizado correctamente desde {data_file}")


# -------------------------
# Uso desde línea de comandos
# -------------------------
if __name__ == "__main__":
    print("Ejecutando script corregido con encoding cp1252")

    if len(sys.argv) != 2:
        print("Uso: python Genera_Enviroment_tmx_from_AGD.py archivo.agd")
        sys.exit(1)

    agd_filename = sys.argv[1]
    xml_file = "ENVIROMENT.tmx"
    update_xml_values(xml_file, agd_filename)
