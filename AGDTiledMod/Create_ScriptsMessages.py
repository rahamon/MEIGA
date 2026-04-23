import sys

if len(sys.argv) < 2:
    print("Uso: python extraer_eventos.py <archivo.agd>")
    sys.exit(1)

agd_path = sys.argv[1]

# Lista de secciones que se deben extraer
secciones = [
    "DEFINEMESSAGES",
    "EVENT PLAYER",
    "EVENT SPRITETYPE1",
    "EVENT SPRITETYPE2",
    "EVENT SPRITETYPE3",
    "EVENT SPRITETYPE4",
    "EVENT SPRITETYPE5",
    "EVENT SPRITETYPE6",
    "EVENT SPRITETYPE7",
    "EVENT SPRITETYPE8",
    "EVENT INITSPRITE",
    "EVENT MAINLOOP1",
    "EVENT MAINLOOP2",
    "EVENT INTROMENU",
    "EVENT GAMEINIT",
    "EVENT RESTARTSCREEN",
    "EVENT FELLTOOFAR",
    "EVENT KILLPLAYER",
    "EVENT LOSTGAME",
    "EVENT COMPLETEDGAME",
    "EVENT NEWHIGHSCORE",
    "EVENT COLLECTBLOCK"
]

# Diccionario para hacer la comparación insensible a mayúsculas y más robusta
secciones_normalizadas = {s.lower(): s for s in secciones}
secciones_extraidas = {s: [] for s in secciones}

with open(agd_path, "r", encoding="utf-8") as file:
    lines = file.readlines()

seccion_actual = None

for line in lines:
    linea_limpia = line.strip().lower()
    encontrada = False
    for clave in secciones_normalizadas:
        if linea_limpia.startswith(clave):
            seccion_actual = secciones_normalizadas[clave]
            secciones_extraidas[seccion_actual].append(line)
            encontrada = True
            break
    if not encontrada and seccion_actual:
        secciones_extraidas[seccion_actual].append(line)

# Guardar cada sección
for seccion in secciones:
    contenido = secciones_extraidas[seccion]
    if not contenido:
        contenido = [seccion + "\n", "\n"]
    elif not contenido[-1].strip():
        pass
    else:
        contenido.append("\n")

    nombre_limpio = seccion.replace(" ", "")
    ext = ".agd" if seccion == "DEFINEMESSAGES" else ".event"
    nombre_archivo = f"{nombre_limpio}{ext}"

    with open(nombre_archivo, "w", encoding="utf-8") as out_file:
        out_file.writelines(contenido)

    print(f"Sección {seccion} guardada en: {nombre_archivo}")
