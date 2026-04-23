import sys
import xml.etree.ElementTree as ET

def main(tmx_file):
    # Cargar el archivo XML
    tree = ET.parse(tmx_file)
    root = tree.getroot()

    # Extraer los valores del grupo DEFINEWINDOW y dividirlos por 8
    define_window = root.find(".//objectgroup[@name='DEFINEWINDOW']/object[@name='WINDOW']")
    x = int(define_window.attrib['x']) // 8
    y = int(define_window.attrib['y']) // 8
    width = int(define_window.attrib['width']) // 8
    height = int(define_window.attrib['height']) // 8

    # Ordenar en el formato requerido: y, x, height, width
    define_window_values = [y, x, height, width]

    # Ordenar los datos del grupo DEFINECONTROLS según el orden especificado
    order = ["UP", "DOWN", "LEFT", "RIGHT", "FIRE 1", "FIRE 2", "FIRE 3", "OPTION 1", "OPTION 2", "OPTION 3", "OPTION 4"]
    define_controls = root.find(".//objectgroup[@name='DEFINECONTROLS']")
    control_properties = define_controls.findall(".//property")

    # Crear un diccionario para acceder a los valores según su nombre
    control_dict = {prop.attrib['name']: prop.attrib['value'] for prop in control_properties}

    # Extraer los valores en el orden especificado
    control_values = [control_dict.get(key, '') for key in order]

    # Formatear los datos
    define_window_str = f"DEFINEWINDOW    {define_window_values[0]} {define_window_values[1]} {define_window_values[2]} {define_window_values[3]}"
    
    # define_controls_str = f"DEFINECONTROLS  {' '.join(map(lambda v: f'\'{v}\'', control_values))}"
    def format_control_value(v):
        try:
            v_int = int(v)
            if v_int in (32, 13):
                return str(v_int)
        except ValueError:
            pass
        return f"'{v}'"

    define_controls_str = f"DEFINECONTROLS  {' '.join(format_control_value(v) for v in control_values)}"

    # Ruta del archivo de salida
    output_file = 'ENVIROMENT.agd'

    # Guardar los datos formateados en el archivo de salida
    with open(output_file, 'w') as file:
        file.write(define_window_str + '\n\n')
        file.write(define_controls_str + '\n')

    print(f"Datos guardados en {output_file}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python script.py archivo.tmx")
        sys.exit(1)

    tmx_file = sys.argv[1]
    main(tmx_file)
