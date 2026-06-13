
; Idea uasar para colocar objetos o sprites en modo adventure

; modificar rutina para interruptor on-off putblock in front
; infront on usa adventure mode asm modificada.
; infront off usa la rutina standard.
; Desarrollar conjuntamaente con PanelRoom
; Sin documentar

; define máximo numero de datos y reserva espacio.
BlockDataLongitud equ 128*3	; reserva todos estos bits para datos
							; podemos ahorrar 1*linea si no comprobamos scno
							
INFRONTopt	equ INFRONT

mpattr ld b,a              ; store cell in b register for now.
       ld e,a              ; displacement in e.
       ld d,0              ; no high byte.
       ld hl,(proptr)      ; pointer to properties.
       add hl,de           ; property cell address.
       ld c,(hl)           ; fetch byte.
       ld a,c              ; put into accumulator.
       cp WATER           ; is it a CUSTOM/WATER?
       jp z,mpattr1        ; SI, PASAR AL FRENTE.
	   ld a,b				;
	   ret
	   
mpattr1
	; write block in-front
	; check PanelRoom Transparency
		ld a,(mroom2+2)
		dec a
		ld a,b
		ret z
		
; WRITE block
wrbloc
        ld hl,(dispx)
        ld (charx),hl
		
		; PUT/WRITE PUTBLOCK C
		ld hl,chgfx
		ld (grbase),hl
		ld hl,(charx)
		ld (dispx),hl				; dispx = charx
		ld a,b						; type = a
		
		; WRITE DATA
		ld hl,(bDatptr)
		push af
		ld de,(dispx)
		;ld a,(scno)
		;ld (hl),a			
		;inc hl
		ld (hl),e			; dispx
		inc hl
		ld (hl),d			; dispy
		inc hl
		pop af
		ld (hl),a			; type
		inc hl
		ld (bDatptr),hl
	
	; test
        ;ld hl,varz
        ;inc (hl)
		
		; END
		ld hl,(dispx)
		ld (charx),hl
		ret
		
; INIT Block Data	
inibloc	ld hl,BlData
		ld (bDatptr),hl
	; test	
		;xor a
		;ld (varz),a
		
		ret

; REDRAW Blocks
drawb	ld hl,(blkptr)
		ld (grbase),hl
		ld hl,BlData
drawb2	ld bc,3
		ld de,(bDatptr)
		and a
drawb1	push hl
		sbc hl,de
		pop hl
		ret nc
		;ld a,(scno)
		;cp (hl)
		;jr z,drawb0
		;add hl,bc
		;jr drawb1
drawb0	;inc hl
		ld e,(hl)
		inc hl
		ld d,(hl)
		ld (dispx),de
		inc hl
		ld a,(hl)
		inc hl
		push hl
		call pattr
		pop hl
		jr drawb2

; Pointers and Data
bDatptr	defw BlData
infront	defb 0

BlData	equ $
		defs BlockDataLongitud,0
		

; ---------------------- PARA COLOCAR BLOQUES EN FRENTE: -------------------------

; 1.- Escribe esto en EVENT RESTARTSCREEN:

; EVENT RESTARTSCREEN

; USER 4

; 2.- Diseña tus screens con los bloques tipo WATER para que se coloquen en primer plano.

; 3.- Inserta la instruccion call mpattr en EngineZX.asm para quedar así: (busca la etiqueta droom1 para localizar el lugar)

; droom1 push af             ; store column counter.
       ; call flbyt          ; decompress next byte on the fly.
       ; push hl             ; store address of cell.
	   ; call mpattr			; write in front block <-------------
       ; call pattr          ; show attributes and block.
	   
	   
; 4.- Por último falta insertar este código en el EngineZX.asm para que quede así: (busca la etiqueta dspr7 para localizar el lugar)
		
; dspr7  call sspric         ; delete old sprite, draw new one simultaneously.
       ; ; tiles in front by adventure modification <-------------
		 ; call drawb <-------------
       ; jp dspr2

;---fin instrucciones-------------------------------------------

