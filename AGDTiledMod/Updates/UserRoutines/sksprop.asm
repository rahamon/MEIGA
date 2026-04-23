;------------------------------------------------------------
; sksprparam / sksType
;------------------------------------------------------------
; Busca en la tabla de sprites (sprtab) un sprite cuyo campo
; coincida con el valor almacenado en (vara).
;
; Funcionamiento:
; - Recorre todos los sprites definidos en la tabla.
; - Ignora los sprites cuyo tipo sea 9 o superior.
; - Ignora también el sprite actualmente activo si su tipo
;   original coincide con el tipo del sprite examinado.
; - El campo que se compara se selecciona mediante el
;   desplazamiento almacenado en (varopt).
; - Si encuentra coincidencia, guarda el puntero al sprite
;   en (skptr).
; - Si no encuentra ninguno, devuelve 255 en (vara).
;
; Entradas:
; - IX     = puntero al sprite activo
; - (vara) = valor que se desea buscar
; - (varopt) = desplazamiento del campo a comparar dentro
;              de la estructura del sprite
;
; Salidas:
; - (skptr) = puntero al sprite encontrado, si existe
; - (vara)  = 255 si no se encuentra coincidencia
;
; Registros modificados:
; - A, B, DE, HL
;
; Variables usadas:
; - ogptr = guarda temporalmente el puntero al sprite activo
; - skptr = guarda el puntero al sprite encontrado
;------------------------------------------------------------
;
;
;	Esto puede funcionar como un modo "buscar en todos los tipos".
;
;		Ejemplo:
;
;		LET R = TYPE
;		LET TYPE = 255
;
;		LET A = 1
;		LET OPT = 11
;		USER 0
;			OTHER
;				...AQUI EL SPRITE ENCONTRADO
;			ENDSPRITE
;		LET TYPE = R
;
;
;	Tambien para filtrar por tipo "Todos los tipos escepto este (2)"
;
;		Ejemplo:
;
;		LET R = TYPE
;		LET TYPE = 2
;
;		LET A = 1
;		LET OPT = 11
;		USER 0
;			OTHER
;				...AQUI EL SPRITE ENCONTRADO
;			ENDSPRITE
;		LET TYPE = R
;
;	Tambien para filtrar por tipo "Este tipo (2)"
;
;		Ejemplo:
;
;		LET R = TYPE
;		LET TYPE = 255
;
;		LET A = 2
;		LET OPT = 0
;		USER 0
;			OTHER
;				...AQUI EL SPRITE ENCONTRADO
;			ENDSPRITE
;		LET TYPE = R
;
;


sksprparam
sksType
skst0   push ix                 ; guardar el sprite activo
        ld (ogptr),ix           ; almacenar su puntero en ogptr
        ld b,NUMSPR             ; número total de sprites a revisar
        ld ix,sprtab            ; IX apunta al inicio de la tabla
skst1   push bc                 ; guardar contador del bucle
        ld a,(ix+0)             ; leer tipo del sprite actual
        cp 9
        jr nc,skst2             ; si tipo >= 9, ignorarlo
        ld hl,(ogptr)           ; recuperar puntero al sprite activo
        ld de,5
        add hl,de               ; HL = ogptr + 5 -> tipo original
        cp (hl)
        jr z,skst2              ; si el tipo coincide con el original,
                                ; ignorar este sprite
        push ix
        pop hl                  ; HL = IX
        ld a,(varopt)
        ld e,a
        ld d,0
        add hl,de               ; HL apunta al campo seleccionado
        ld a,(hl)               ; leer el valor de ese campo
        ld hl,vara
        cp (hl)
        jr z,skst4              ; si coincide con (vara), encontrado
skst2   ld de,TABSIZ            ; avanzar al siguiente sprite
        add ix,de
        pop bc                  ; restaurar contador
        djnz skst1              ; repetir mientras queden sprites
        ld a,255                ; no encontrado -> valor de fallo
        ld (vara),a
skst3   pop ix                  ; restaurar el sprite activo original
        ret
skst4   ld (skptr),ix           ; guardar puntero al sprite encontrado
        pop bc                  ; restaurar contador
        jr skst3                ; salir restaurando IX
		