; Rutinas de usuario para juego en produccion
; propositos varios

		cp 2
		jp z,sspria			; borrame o pintame
		cp 1
		jp z,ALL_sspria		; borranos o pintanos
		cp 3
		jp z,evnt20
		cp 4
		jp z,grav
		cp 5
		jp z,gravHack
		cp 6
		jp z,IXINOther
		cp 7
		jp z,PublishIX
		cp 11
		jp z,BigTile
		cp 12
		jp z,SaveBlockx
		cp 13
		jp z,loadBlockx
		cp 14
		jp z,COLL_any
		cp 15
		jp z,PintarCuadricula4x3
		cp 16
		jp z,RestaurarCuadricula4x3
		cp 17
		jp z,SetAttr2Water
		cp 18
		jp z,GetFx
		
		ret

GetFx	; obtiene el indice del efecto en RND
		ld a,(isOkfx)
		and a
		jr z,GetFx0		; el fx ya termino entonces devuelve RND = 0 
		ld a,(ctrF)
GetFx0	ld (varrnd),a
		ret
		
bufferDeAtributos equ $
			defs 768,0

InitColorCell
	; Obtiene direccion en pantalla HL y en Buffer DE
		ld hl,(charx)
		ld (dispx),hl
		call gaadd		; obtiene la direccion del atributo de color en pantalla en hl

		push hl			; Gardamos a dirección de pantalla na pila
		call GetBufPtr	; DE agora apunta á posición correspondente no buffer
		pop hl			; Recuperamos a dirección de pantalla en HL
		ret
		
SetColorCell
		call InitColorCell
	; pinta una celda
		ld a,(hl)		; A = cor actual da pantalla
		ld (de),a		; Gardamos a cor no buffer
		ld a,(23693)	; carga el valor de nuevo color 
		ld (hl),a		; colorea
		ret

RestColorCell
		call InitColorCell
	; restaura una celda
		ld a,(de)		; A = cor gardada no buffer
		ld (hl),a		; Restaura o cor na pantalla
		ret

GetBufPtr
	; 1. Restamos 22528 (inicio VRAM atributos) para obter o índice (0-767)
	; 2. Sumamos a dirección de inicio do teu buffer
		ld de,-22528    ; Equivale a -$5800
		add hl,de       ; HL agora ten o desprazamento relativo
		ld de,bufferDeAtributos
		add hl,de       ; HL apunta agora á posición correcta do buffer
		ex de,hl		; lo pasamos a DE
		ret

PintarCuadricula4x3
		call InitColorCell
		; (Asume que HL e DE xa veñen inicializados coas direccións base)
		ld b,3             ; B = 3 filas (Alto)
FilaBucleSet
		push bc             ; Gardamos o contador de filas
		ld b,4             ; B = 4 columnas (Ancho)

ColumnaBucleSet
		ld a,(hl)           ; A = cor actual da pantalla
		ld (de),a           ; Gardamos a cor no buffer
		
		ld a,(23693)        ; A = novo cor
		ld (hl),a           ; Pintamos na pantalla
		
		inc hl              ; Seguinte celda na pantalla (horizontal)
		inc de              ; Seguinte celda no buffer (horizontal)
		djnz ColumnaBucleSet ; Repetir ata facer as 4 columnas

		; --- Salto á seguinte liña de atributos (32 - ancho) ---
		; Como avanzamos 4 celdas, sumamos 28 (32 - 4) para baixar á seguinte liña
		push de             ; Protexemos DE temporalmente
		ld de,28           ; Cantidade a sumar
		add hl,de          ; HL apunta á seguinte liña de pantalla
		pop de              ; Recuperamos DE
		
		; Facemos o mesmo salto de liña en DE (Buffer)
		push hl             ; Protexemos HL temporalmente
		ld hl,28           ; Cantidade a sumar
		add hl,de          ; HL = DE + 28
		ex de,hl           ; DE agora ten a nova liña do buffer
		pop hl              ; Recuperamos HL

		pop bc              ; Recuperamos o contador de filas
		djnz FilaBucleSet   ; Repetir ata facer as 3 filas
		ret

RestaurarCuadricula4x3
		call InitColorCell
		; (Asume que HL e DE xa veñen inicializados coas direccións base)
		ld b,3             ; B = 3 filas
FilaBucleRest
		push bc             ; Gardamos o contador de filas
		ld b,4             ; B = 4 columnas

ColumnaBucleRest
		ld a,(de)           ; A = cor gardada no buffer
		ld (hl),a           ; Restauramos o cor na pantalla
		
		inc hl              ; Seguinte celda na pantalla
		inc de              ; Seguinte celda no buffer
		djnz ColumnaBucleRest

		; --- Salto á seguinte liña de atributos ---
		push de
		ld de,28
		add hl,de          ; Salto en pantalla
		pop de
		
		push hl
		ld hl,28
		add hl,de
		ex de,hl           ; Salto en buffer
		pop hl

		pop bc              ; Recuperamos o contador de filas
		djnz FilaBucleRest  ; Repetir ata facer as 3 filas
		ret

CurrentBlockx	defw 0

SaveBlockx
		ld hl,(blockx)
		ld (CurrentBlockx),hl
		ret
		
loadBlockx
		ld hl,(CurrentBlockx)
		ld (charx),hl
		ret

CurrentIX		defw 0

IXINOther
		ld hl,(CurrentIX)
		ld (skptr),hl
		ret
		
PublishIX
		ld (CurrentIX),ix
		ret
		
gravHack
		ld hl,$0318
		ld (gravd0),hl
		ld hl,$0418
		ld (gravu0),hl
		ret

COLL_any
		xor a
		ld (anyIs),a
		push ix
		call skany			; alguien mas?
        jr nc,noCOLL		; Carry=1 si colisiona
		;ld ix,(ckptr)
		;call sspria
		ld a,255
		ld (anyIs),a
		ld (varm),a
noCOLL	pop ix
		ret

anyIs	defb 0

ALL_sspria
		;call sspria
		
		;call skany			; alguien mas?
        ;ret nc				; Carry=1 si colisiona

		;ld a,(anyIs)
		;ret z

		push ix
		ld b,NUMSPR         ; sprites to draw.
		ld ix,sprtab        ; sprite table.
allspr0 ld a,(ix+0)         ; old sprite type.
		inc a               ; is it enabled?
		jr z,allspr1         ; no, find next one.
	; menos la mirilla
		ld a,(ix+0)
		;cp 1
		;jr z,allspr1
		ld a,(ix+3)         ; sprite x.
		cp 177              ; beyond maximum?
		jr nc,allspr1        ; yes, nothing to draw.
		push bc             ; store sprite counter.
		call sspria         ; BORRA
		pop bc              ; retrieve sprite counter.
allspr1 ld de,TABSIZ        ; distance to next odd/even entry.
		add ix,de           ; next sprite.
		djnz allspr0         ; repeat for remaining sprites.
		pop ix              ; retrieve sprite pointer.
		ret

; ------------------------------------------------------------
; skany: CASI
;   IX = sprite actual
;   OUT: Carry=1 si colisiona con alguno, Carry=0 si no
;   SIDE: marca (candidato+67)=1 cuando encuentra colisión
; ------------------------------------------------------------
ckptr  defw 0

skany	ld hl,sprtab
        ld a,NUMSPR
loop	ex af,af'			;'
        ld (ckptr),hl
        ld a,(hl)
        inc a
        jr z,next
        ld a,h
        cp ixh
        jr nz,check
        ld a,l
        cp ixl
        jr z,next
check	ld de,X
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)

        ld a,(ix+X)
        sub e
        jr nc,xpos
        neg
xpos	cp 22
        jr nc,next
        ld c,a

        ld a,(ix+Y)
        sub d
        jr nc,ypos
        neg
ypos	cp 28
        jr nc,next
        add a,c
        cp 49
        jr nc,next
        ; colisión: marcar candidato
       ; ld hl,(ckptr)
       ; ld de,67
       ; add hl,de
       ; ld a,1
       ; ld (hl),a
        scf
        ret
next	ld hl,(ckptr)   ; <-- SIEMPRE volver a base antes de avanzar
        ld de,TABSIZ
        add hl,de
        ex af,af'		;'
        dec a
        jr nz,loop
        or a
        ret
			
SetAttr2Water
	ld a,(vara)
	jp SetAttrBlock

; Meiga UserRutines
			include "PanelRoom2.asm"
			include "SetAttrBlock.asm"
			