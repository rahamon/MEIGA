# MEIGA 2025

Entorno de desarrollo, conversión y compilación para proyectos AGD, con integración en Tiled y ampliación del motor original.

MEIGA permite transformar, editar y compilar proyectos AGD utilizando un flujo de trabajo moderno, manteniendo compatibilidad con el formato original y extendiendo sus capacidades.

---

## Descripción

MEIGA es un conjunto de herramientas que permite:

* Convertir archivos `.agd` a formatos editables (`.tmx`, `.tsx`, `.png`)
* Editar los recursos en herramientas externas como Tiled
* Reconstruir el archivo `.agd` a partir de los datos editados
* Compilar el proyecto final sin depender del entorno original

El objetivo es proporcionar un sistema completo, modular y controlable para el desarrollo de juegos basados en AGD.

---

## Características principales

* Conversión bidireccional AGD ↔ TMX
* Compilación completa del proyecto desde MEIGA
* Generación automática de tilesets y mapas
* Procesamiento de:

  * bloques (`DEFINEBLOCK`)
  * sprites (`DEFINESPRITE`)
  * objetos (`DEFINEOBJECT`)
  * fuentes (`DEFINEFONT`)
  * mensajes y eventos
* Reconstrucción completa del archivo `.agd`
* Separación de datos en recursos editables

---

## Extensiones del motor AGD

MEIGA no solo trabaja con el formato original, sino que amplía sus capacidades mediante múltiples sistemas desarrollados durante los últimos años:

* **SoundMod**
  Sistema de gestión y reproducción de sonido avanzado.

* **ScreenMod**
  Control ampliado de pantallas y renderizado.

* **StageMod**
  Gestión estructurada de niveles y flujo de juego.

* **ScriptMod**
  Sistema extendido de scripting.

* **Gestión de paletas**
  Soporte para paletas clásicas y ULA+, con control directo de color.

* **Motor de Sprites**
  Renderizado mediante técnicas AND/OR con restauración de fondo.

* **Gestión de pantalla**
  Sistemas avanzados de desplazamiento y actualización gráfica.

Estas extensiones permiten superar las limitaciones del AGD original manteniendo compatibilidad.

---

## Flujo de trabajo

1. Archivo original `.agd`
2. Conversión a recursos editables:

   * Mapas (`.tmx`)
   * Tilesets (`.tsx`, `.png`)
3. Edición en Tiled
4. Reconstrucción del `.agd`
5. Compilación final desde MEIGA

---

## Enfoque del proyecto

MEIGA es una implementación independiente que:

* Reinterpreta el flujo de desarrollo de AGD
* Integra herramientas modernas
* Permite compilación autónoma
* Amplía las capacidades del motor original

---

## Relación con MPAGD

MEIGA es compatible con proyectos basados en MPAGD:

* Utiliza el formato `.agd` como base
* Implementa su propio sistema de procesamiento y compilación
* No reutiliza código del proyecto original.

---

## Requisitos

* Python 3.x
* Tiled
* Herramientas de ensamblado (Pasmo, sjasmplus, etc.)

---

## Estructura del proyecto

El sistema está compuesto por múltiples módulos especializados:

* Conversión AGD → TMX
* Reconstrucción TMX → AGD
* Generación de recursos gráficos
* Sistema de compilación
* Extensiones del motor (Mods)

---

## Estado del proyecto

En desarrollo activo.

---

## Licencia

(Pendiente de definir)

---

## Autor

Proyecto desarrollado por Ramón Fernández Ameijeiras

---
