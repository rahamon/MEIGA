import sys
import os
from Create_Objects import (
    parse_agd_defineobjects,
    load_palette_from_json,
    create_tileset_image
)

def main():
    if len(sys.argv) < 2:
        print("Uso: python create_Object_image.py DEFINEOBJECT.agd")
        return

    agd_file = sys.argv[1]
    output_png = "Objects.png"
    palette_file = os.path.join(os.path.dirname(__file__), "paleta_rgb_por_atributo.json")

    print(f"[+] Leyendo objetos desde {agd_file}")
    objects = parse_agd_defineobjects(agd_file)
    print(f"[ok] {len(objects)} objetos leídos.")

    if not objects:
        print("[*] No se han encontrado objetos. No se generará la imagen.")
        return

    print("[+] Cargando paleta de colores...")
    palette = load_palette_from_json(palette_file)

    print(f"[+] Generando imagen en {output_png}...")
    create_tileset_image(objects, output_png, palette)

    print("[✓] Imagen generada correctamente.")

if __name__ == "__main__":
    main()