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
skst0   push ix				; reserva Sprite activo
		ld (ogptr),ix		; reserva Sprite activo en (ogptr)
        ld b,NUMSPR
        ld ix,sprtab
skst1   push bc
        ld a,(ix+0)
        cp 9
        jr nc,skst2			; si tipo >= 9, ignorar
		
		ld hl,(ogptr)
		ld de,5
		add hl,de			; (ogptr+5) -> original type
		cp (hl)
		jr z,skst2			; si tipo encontrado = original, ignorar
		
        push ix
        pop hl
        ld a,(varopt)
        ld e,a
        ld d,0
        add hl,de
        ld a,(hl)			; leer campo seleccionado
        ld hl,vara
        cp (hl)
        jr z,skst4			; encontrado
skst2   ld de,TABSIZ
        add ix,de
        pop bc
        djnz skst1
		ld a,255			; falla
        ld (vara),a
skst3	pop ix				; recupera Sprite activo
        ret
skst4   ld (skptr),ix		; SPRITE ENCONTRADO en (skptr)
        pop bc
		jr skst3

		