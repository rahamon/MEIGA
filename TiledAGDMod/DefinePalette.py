import json
import sys

# Si quieres ajustar el nivel de oscuridad, podrías probar con otros valores 
# (por ejemplo, 0.5 para más contraste, o 0.75 para que los colores oscuros no sean tan apagados).
# Constante para simular/deshacer el brillo artificial
BRIGHT_FACTOR = 0.75

if len(sys.argv) < 2:
    print("Uso: python GenerarDefinePalette.py <archivo_json>")
    sys.exit(1)

json_path = sys.argv[1]
agd_output_path = "DEFINEPALETTE.agd"

def rgb_to_ulaplus_byte(entry):
    r, g, b = entry["R"], entry["G"], entry["B"]
    if entry["Bright"] == 0:
        r = min(round(r / BRIGHT_FACTOR), 255)
        g = min(round(g / BRIGHT_FACTOR), 255)
        b = min(round(b / BRIGHT_FACTOR), 255)

    red = round((r / 255) * 7)
    green = round((g / 255) * 7)

    def calc_blue_code(b):
        posibles = []
        for b_raw in range(4):
            b_high = (b_raw >> 1) & 1
            b_low = b_raw & 1
            blue_val = (b_high << 2) | (b_low << 1) | b_high
            blue = int((blue_val / 7) * 255)
            posibles.append((abs(b - blue), b_raw))
        return min(posibles)[1]

    blue_code = calc_blue_code(b)
    return (green << 5) | (red << 2) | blue_code

# Leer JSON
with open(json_path, "r", encoding="utf-8") as f:
    colores = json.load(f)

# Convertir colores a bytes ULAplus
bytes_palette = [rgb_to_ulaplus_byte(c) for c in colores]

# Estructura esperada por ZXEngine.asm
bloques = [
    bytes_palette[:8],
    bytes_palette[:8],
    bytes_palette[8:],
    bytes_palette[8:],
    [0] * 8,
    [0] * 8,
    [0] * 8,
    [0] * 8
]

# Guardar archivo DEFINEPALETTE limpio
with open(agd_output_path, "w", encoding="utf-8") as f:
    f.write("DEFINEPALETTE\n")
    for bloque in bloques:
        f.write(" "*16 + " ".join(str(b) for b in bloque) + "\n")

print(f"{agd_output_path} generado correctamente.")
