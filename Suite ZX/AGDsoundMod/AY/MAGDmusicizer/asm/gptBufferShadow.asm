Perfecto. Vamos a dejarlo en una versión clara y usable.

La idea correcta es separar estas tres cosas:

qué pantalla está visible
qué banco está paginado en 0xC000
cuándo copias una pantalla a otra

Y no mezclarlo todo en una sola variable con nombres ambiguos.

1. Qué hay realmente en el Spectrum 128
Pantallas
RAM 5: pantalla normal en 0x4000
RAM 7: pantalla sombra, accesible por la ULA cuando el bit 3 de 7FFD vale 1
Ventana paginada
0xC000-0xFFFF muestra el banco indicado por los bits 0-2 de 7FFD

Por tanto:

para ver RAM 7 como pantalla: bit 3 = 1
para escribir cómodamente en RAM 7 con la CPU: puedes paginar RAM 7 en 0xC000
2. Objetivo práctico

Te propongo este esquema simple:

dibujas el juego en RAM 5 (0x4000)
cuando el frame está listo, copias RAM 5 -> RAM 7
haces flip de pantalla visible si quieres
o mantienes siempre visible RAM 7 si prefieres ese modelo

Pero mejor aún: te dejo rutinas claras para que puedas decidir.

3. Rutinas básicas correctas
Variable de estado real del puerto 7FFD
Port7FFD    defb 0

Esta variable guardará el valor completo que crees que tiene el puerto.

Escribir el puerto 7FFD de forma segura
Set7FFD:
        ld (23388),a
        ld (Port7FFD),a
        ld bc,32765
        out (c),a
        ret

Esta rutina sustituye a banka.

Leer el estado actual y cambiar solo el banco alto 0xC000
PageBankC000:
        ; Entrada: A = banco 0..7
        ; Conserva el resto de bits de 7FFD
        ld b,a
        ld a,(Port7FFD)
        and %11111000
        or b
        jp Set7FFD
Mostrar pantalla normal (RAM 5)
ShowScreen5:
        ld a,(Port7FFD)
        and %11110111      ; bit 3 = 0
        jp Set7FFD
Mostrar pantalla sombra (RAM 7)
ShowScreen7:
        ld a,(Port7FFD)
        or %00001000       ; bit 3 = 1
        jp Set7FFD
Poner RAM 5 en 0xC000
PageRAM5AtC000:
        ld a,5
        jp PageBankC000
Poner RAM 7 en 0xC000
PageRAM7AtC000:
        ld a,7
        jp PageBankC000
4. Copias de pantalla correctas
Copiar RAM 5 -> RAM 7

Esto copia la pantalla normal a la sombra.

CopyScreen5To7:
        di
        push af
        push bc
        push de
        push hl

        ld a,(Port7FFD)
        push af

        call PageRAM7AtC000

        ld hl,$4000
        ld de,$C000
        ld bc,6912
        ldir

        pop af
        call Set7FFD

        pop hl
        pop de
        pop bc
        pop af
        ei
        ret
Copiar RAM 7 -> RAM 5

Útil si alguna vez dibujas en RAM 7 y quieres volcar a la normal.

CopyScreen7To5:
        di
        push af
        push bc
        push de
        push hl

        ld a,(Port7FFD)
        push af

        call PageRAM7AtC000

        ld hl,$C000
        ld de,$4000
        ld bc,6912
        ldir

        pop af
        call Set7FFD

        pop hl
        pop de
        pop bc
        pop af
        ei
        ret
5. Inicialización limpia
InitVideo128:
        xor a
        call Set7FFD        ; estado base conservador: banco 0, pantalla normal

        call CopyScreen5To7 ; RAM7 = copia de la pantalla actual
        call ShowScreen5    ; empezamos mostrando RAM5
        ret

Aquí arrancas con todo bien definido.

6. Flip real entre pantallas

Ahora sí, una rutina de flip de verdad:

FlipVisibleScreen:
        ld a,(Port7FFD)
        xor %00001000       ; alterna bit 3
        jp Set7FFD

Esto sí cambia entre:

visible RAM 5
visible RAM 7
7. Saber qué pantalla está visible
IsScreen7Visible:
        ld a,(Port7FFD)
        and %00001000
        ret

Si Z=0, está visible RAM 7.
Si Z=1, está visible RAM 5.

8. Dos modelos de uso recomendados
Modelo A: sencillo y estable

Dibujas siempre en RAM 5.

Bucle
MainLoop:
        ; dibujar frame en RAM5 ($4000)
        call DrawFrameOnRAM5

        ; copiar a RAM7
        call CopyScreen5To7

        ; mostrar RAM7
        call ShowScreen7

        ; esperar frame
        call waitIRQ

        ; seguir lógica
        call UpdateGame

        jr MainLoop

Este modelo no es doble buffer real puro, pero es sencillo.

Modelo B: flip de verdad entre RAM5 y RAM7

Uno visible, otro oculto.

Variante simple
cuando se ve RAM 5, dibujas en RAM 7 paginada en 0xC000
cuando se ve RAM 7, dibujas en RAM 5 en 0x4000
al final haces flip

Eso requiere que tus rutinas de sprite sepan dibujar unas veces en 0x4000 y otras en 0xC000.

Como tu motor actual está pensado para dibujar en 0x4000, ahora mismo te conviene más el modelo A.

9. Qué sustituye a tu código actual

Tu bloque actual:

banka
bankP
VIDEOToRAM7
InitULABuffers
FlipBufferSafe

yo lo sustituiría por este conjunto:

Port7FFD    defb 0

Set7FFD:
        ld (23388),a
        ld (Port7FFD),a
        ld bc,32765
        out (c),a
        ret

PageBankC000:
        ld b,a
        ld a,(Port7FFD)
        and %11111000
        or b
        jp Set7FFD

ShowScreen5:
        ld a,(Port7FFD)
        and %11110111
        jp Set7FFD

ShowScreen7:
        ld a,(Port7FFD)
        or %00001000
        jp Set7FFD

PageRAM5AtC000:
        ld a,5
        jp PageBankC000

PageRAM7AtC000:
        ld a,7
        jp PageBankC000

CopyScreen5To7:
        di
        push af
        push bc
        push de
        push hl

        ld a,(Port7FFD)
        push af

        call PageRAM7AtC000

        ld hl,$4000
        ld de,$C000
        ld bc,6912
        ldir

        pop af
        call Set7FFD

        pop hl
        pop de
        pop bc
        pop af
        ei
        ret

CopyScreen7To5:
        di
        push af
        push bc
        push de
        push hl

        ld a,(Port7FFD)
        push af

        call PageRAM7AtC000

        ld hl,$C000
        ld de,$4000
        ld bc,6912
        ldir

        pop af
        call Set7FFD

        pop hl
        pop de
        pop bc
        pop af
        ei
        ret

FlipVisibleScreen:
        ld a,(Port7FFD)
        xor %00001000
        jp Set7FFD

InitVideo128:
        xor a
        call Set7FFD
        call CopyScreen5To7
        call ShowScreen5
        ret
10. Muy importante: tu ISR

Si mantienes música por interrupción, la ISR debe restaurar el 7FFD exacto con el que entró.

Algo así:

Saved7FFD_ISR  defb 0

Al entrar en la ISR:

        ld a,(Port7FFD)
        ld (Saved7FFD_ISR),a

Y antes de salir:

        ld a,(Saved7FFD_ISR)
        call Set7FFD

No pongas bank0, bank4 o similares al final “por defecto”.

11. Conclusión práctica

Tu código original intentaba hacer tres cosas a la vez:

mostrar pantalla sombra
copiar RAM5 a RAM7
usar ULABank como estado global

pero lo hacía de forma ambigua.

La versión que te propongo separa todo en rutinas con significado claro:

ShowScreen5
ShowScreen7
PageRAM5AtC000
PageRAM7AtC000
CopyScreen5To7
CopyScreen7To5
FlipVisibleScreen

Así ya puedes construir encima sin volverte loco.

El siguiente paso lógico es este:
adaptar tu bucle principal y tu ISR a este modelo