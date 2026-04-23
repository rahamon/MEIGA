def limpiar_linea(linea):
    # Eliminar caracteres no deseados
    linea = linea.replace('\x00', '')   # Caracteres nulos
    linea = linea.replace('\r', '')     # Retorno de carro
    linea = linea.replace('|', '')      # Barras verticales

    # Separar la línea por espacios
    palabras = linea.split(' ')
    palabras_limpias = []
    buffer = ''

    # Reconstruir palabras separadas por error (letras sueltas)
    for palabra in palabras:
        if len(palabra) == 1:
            buffer += palabra
        else:
            if buffer:
                palabras_limpias.append(buffer)
                buffer = ''
            palabras_limpias.append(palabra)
    if buffer:
        palabras_limpias.append(buffer)

    # Unir y devolver la línea limpia
    return ' '.join(palabras_limpias).strip()

def procesar_log(archivo_entrada, archivo_salida):
    with open(archivo_entrada, "r", encoding="utf-8") as entrada:
        lineas = entrada.readlines()

    # Limpiar líneas y eliminar vacías
    resultado = [
        limpiar_linea(linea)
        for linea in lineas
        if linea.strip()  # Descarta líneas vacías originales
    ]
    resultado = [linea for linea in resultado if linea]  # Elimina líneas vacías resultantes

    # Guardar resultado en UTF-8 con BOM
    with open(archivo_salida, "w", encoding="utf-8-sig") as salida:
        for linea in resultado:
            salida.write(linea + "\n")

    print(f"{len(resultado)} líneas limpias escritas en '{archivo_salida}'.")

if __name__ == "__main__":
    procesar_log("log.txt", "Resultado.txt")
