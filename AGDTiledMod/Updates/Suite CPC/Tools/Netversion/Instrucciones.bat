REM usando desde la línea de comando
REM ConvImgCpc también se puede utilizar desde la línea de comandos, por ejemplo para realizar procesamiento por lotes.
REM En este caso, hay argumentos a especificar para el lanzamiento:
REM -Archivo: donde el archivo contiene el nombre completo (con ruta) de uno o una lista de archivos (usando un patrón de búsqueda, por ejemplo xxx*.jpg).
REM -S: Mantenga las proporciones utilizando el área más grande posible (equivalente a la opción “mantener más grande”).
REM -I: Mantener las proporciones sin pérdida de elementos gráficos (equivale a la opción “mantener más pequeño”).
REM -Mmod e: elige el modo correspondiente para la conversión de imágenes. El modo puede variar de 0 a 10.
REM -L: Congela la paleta en el primer fotograma. Por lo tanto, en el caso de procesar varias imágenes, la paleta se calculará para la primera imagen y luego se congelará para aplicarla a las siguientes.
REM -Kpack: Utilice el método “pack” para compactar. (paquete=0 => sin compactación, paquete=1 => compactación “estándar”, paquete=2 => compactación ZX0, paquete=3 => compactación ZX1).
REM -CfichPalette: lee el archivo .PAL fichPalette y úsalo para la conversión de imágenes.
REM -Tframe: utiliza el método de tramado “cuadro” para la conversión (cuadro=0 => sin tramado)
REM -X: utiliza difusión de errores al hacer difuminado.
REM -PpctFrame: porcentaje de encuadre durante la conversión.
REM -Ucpc: si cpc=0 => use la paleta ANTIGUA, si cpc=1 => use la paleta PLUS.
REM -Zreso: si reso=0 => resolución “estándar”, si reso=1 => resolución “sobrebarrido”.
REM -BpctBlue: porcentaje de azul a usar durante la conversión (predeterminado = 100%)
REM -RpctRed: porcentaje de rojo a usar durante la conversión (predeterminado = 100%)
REM -VpctVert: porcentaje de verde a utilizar durante la conversión (predeterminado = 100%)

REM Compresión REM utilizada en ConvImgCpc
REM ConvImgCpc ahora utiliza 3 métodos de compresión:
REM • Un método llamado “estándar”, que utiliza un algoritmo para buscar cadenas idénticas. Con una velocidad de compresión
REM muy rápida, una velocidad de descompresión muy buena y la denominada tasa de compresión "media",
REM • Un método llamado “ZX0”, que utiliza el algoritmo de compresión ZX0 de Einar Saukas. Este algoritmo tiene una buena
REM velocidad de descompresión y una muy buena tasa de compresión, pero utiliza un algoritmo de compresión muy lento
REM (varios segundos para compactar una imagen). Puede ser interesante de utilizar, pero cuidado con las animaciones: puede llevar mucho tiempo,
REM porque en una animación compactamos las diferencias entre imágenes.
REM • Un método llamado “ZX1”, que utiliza el algoritmo de compresión ZX0 de Einar Saukas. Este algoritmo es un poco más rápido en
REM compresión/descompresión que ZX0, con una relación de compresión ligeramente menor.
REM Durante la compresión ZX0/ZX1, para mostrar el tiempo restante, aparece un “gráfico de barras” con el progreso de la compresión:

REM La progresión del gráfico de barras es del tipo “logarítmica”, es decir que los primeros pasos de progresión aparecerán más rápido
REM que los últimos pasos.
REM Al guardar imágenes, si la casilla de verificación "incluir código de visualización en la imagen" está marcada, la rutina de descompresión
REM adecuada se incluirá en la imagen, independientemente del método de compresión elegido.

ConvImgCpc test.bmp -s test.scr
pause