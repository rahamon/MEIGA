;
;; posicion X PLAYER, Necesita consultar IX!! REVISAR MEIGA
;
;----------------------------
;             .              
;   ZONA B    .   ZONA A     
;             .              
;----------------------------
;
; SCROLL
; Comprobaciones iniciales
; Cambio de scroll derecha-izquierda
; Reset DESPLAZAMIENTO
; Test limites de rooms 
; Borrado sprites en límites de pantalla
; DESPLAZAMIENTO de sprites en pantalla 
; Cambio de pantalla y calculo nueva posicion Player
; Setups
; LIMITACIONES: No puede mover objetos, no uses NEXTLEVEL y no puede usar adventure mode
;
; Scroll Control:
; AGD Scripts USER n
; USER 0 SCROLL para la DERECHA
; USER 1 Scroll para la izquierda
; USER 128 monitor: devuelve valor DESPLAZAMIENTO en la variable A
; USER 64 Reset DESPLAZAMIENTO: usar en RESTARTSCREEN
; USER 32 Play one Step, usar en MAINLOOP2
; USER 16 Set Sprite in map position: Necesario para localizar Sprite en mapa para scroller, usar en PLAYER EVENT
; USER 8 Update SCNO: Hack Killed location, usar en KILLED EVENT y hack para SCREEN MAP NAVIGATION: SCREENUP, SCREENDOWN,...
; USER 4 procesa Sprites con el desplazamiento
; USER 2 reset ECHO que impide borrado de sprite old 

Sccrl

chkcrl	cp 3
		jr nc,sccom			; User n > 3 entonces es comando
		
; Cambió de dirección?
chkspin	ld hl,scdir
		cp (hl)
		jp z,spined

; Check new directions

chkdir	;ld a,(scdir)
		cp 0
		jp z,scrolld		; player a la izquierda, scroll a la derecha
		cp 1
		jp z,scrolli		; player a la derecha
		; cp 2
		; jp z,scrollarr
		; cp 3
		; jp z,scrollaba	
		; ret

; check COMAMND
sccom	cp 128
		jp z,demonitor		; Devuelve DESPLAZAMIENTO en variable A del AGD
		cp 64
		jp z,resde01		; Restablece DESPLAZAMIENTO: usar en RESTARTSCREEN AGD
		cp 32
		jp z,Play_one_step	; Da un paso: usar en MAINLOOP2 AGD
		CP 16
		JP z,saveXYPlayer	; Conserva X del jugador en mapa: Usar in EVENT PLAYER AGD
		cp 8
		jp z,NavtoSCNO		; kill player and ScreenNav. hack: Usar before SceenUp,...Down,...Left,...Right AGD
		cp 4
		jp z,EchoMonitor		; deslocalizacion de sprites monitor
		cp 2
		jp z,EchoReset			; deslocalizacion de sprites set off
		
		jp user0
		ret
		
scdir		defb 255		; ultima DIRECTION conocida 
scrollx		defb 0			; desp-counter DESPLAZAMIENTO
scrolling	defb 0			; running flag

; Control de sprites monitor ----------------------------------
; devuelve direccion del scroll en B
; devuelve echo en A
; Si echo activo entonces mueve Sprites
EchoMonitor
		ld a,(scdir)		; en esta direccion
		ld (varb),a
		ld a,(echo)			; activado el desplazamiento con el fondo de sprites (scrolling!)
		ld (vara),a
		and a
		jp nz,SingleSpriteScrollingProcess		; sipi
		ret

; reset echo sprites
EchoReset
		xor a
		ld (echo),a
		ret
		
; Control scroll direccion PREPARA RUTINA -------------------------------------------------------------
scrolli
		ld (scdir),a		; nueva DIRECTION PLAYER

		ld a,$3D			; scroll to left $3D <---scroll0_OPERADOR DEC a DESPLAZAMIENTO--
		ld (operand),a
		ld a,$DE			; SBC a,n ($DE) sprites a izq
		ld (sprmov),a
		
		ld a,WINDOWWID - 1	; desde
		ld (rolfrom),a
		ld a,0				; hasta
		ld (roledge),a
		
		ld a,(wnlftx)
		ld (chkedge),a		; sprites limite visible
		ld a,$38
		ld (eraside),a		; sprites condicion para borrado fiera del limite
		
		jp spined
		
scrolld
		ld (scdir),a		; nueva DIRECTION PLAYER

		ld a,$3C			; scroll to right $3C <---scroll0_OPERADOR INC a DESPLAZAMIENTO++
		ld (operand),a
		ld a,$C6			; ADD a,n ($C6) Sprites a der
		ld (sprmov),a
		
		ld a,1				; desde
		ld (rolfrom),a
		ld a,WINDOWWID		; hasta
		ld (roledge),a
		
		ld a,(wnrgtx)
		ld (chkedge),a		; sprites limite visible
		ld a,$30
		ld (eraside),a		; sprites condicion para borrado fiera del limite
		
spined
	; Orientado para desplazarse, CAMINA
	; version SYNC play one step flag
		ld a,1
		ld (rolstep),a		; STEP_FLAG = 1
		ret

; Scroll Player Section----------------------------------------------------------

Scroll_player
; Check DESPLAZANDO o SCREEN
chkling	ld a,(scrolling)
		cp 1
		jp z,rolmove		; MUEVE
		jp setuprooms		; SETUP rooms

rolmove
		ld a,(scrollx)
operand	defb $3C			; $3C inc a, $3D dec a. $3C scroll to right $3C
		ld (scrollx),a		; LET DESPLAZAMIENTO (scrollx) = DESPLAZAMIENTO + Operando
		
checkroom
		ld a,(scrollx)
		defb $FE			; CP n
roledge	defb WINDOWWID
		jp z,nextsroom		; IF DESPLAZAMIENTO = hasta, cambia de habitacion

printro	call sroom			; PINTA	

	; activa el movimiento de Sprites
movdrw	ld a,1
		ld (echo),a
	IF MASKAGD = 1
		call renuevafondos
	ENDIF
	
; end of program
		ret

; PLAY
Play_one_step
		defb $3E			;ld a,n
rolstep	defb 0				; TICKER STEP play step flag
		cp 1
		jp z,nextep
		ret
nextep	xor a
		ld (rolstep),a
		jp Scroll_player

; Rutinas AUXILIARES -------------------------------------------------------------------

; Redraw patch for ZXEngine: Sustituye call droom por call modroom para redibujar correctamente.
modroom
; rolling?		
		ld a,(scrolling)
		cp 1
		jp z,sroom
		jp droom

; DEVUELVE DESPLAZAMIENTO en A (GAME VAR)
demonitor
		ld a,(scrollx)
		;ld a,(oscno)
		ld (vara),a			; monitoring!!!							LET A (GAME VAR) = DESPLAZAMIENTO
		ret

; RESTAURA posicion y estado del scroll: usar en RestartScreen.
resde01
		ld a,(rolfrom)
		ld (scrollx),a		; reset scrollx	(OK)					RESET DESPLAZAMIENTO
		call presentsroom

		xor a
		ld (scrolling),a	; skip setups flag OFF
		ret
		
; Rutinas AUXILIARES PLAYER -------------------------------------------------------------------
		
; RESERVA Posicion X del Player, LLAMAR DESDE EL PLAYER EVENT	
saveXYPlayer
		ld a,(ix+9)					; get X of current Sprite
		ld (XPlayer),a				; save in XPlayer
		ret

; NAVEGA A Screen Works, LLAMAR DESDE EL PLAYER EVENT	
NavtoSCNO
		; check orilla
		ld a,(scrolling)	; skip setups flag OFF
		cp 0
		ret z
	;  X offset before navigation
		ld a,(scrollx)
		add a,a
		add a,a
		add a,a
		ld c,a				; guarda desplazamiento*8 en c
		ld a,(ix+9)
		sub c				; resta X - (desplazamiento*8) ajuste...

		jp nc,navlado		; IF X > (desplazamiento*8) -> navlado
		; orilla izquierda
		ld b,a				; guarda resultado en b
		ld a,(winwid)
		add a,a
		add a,a
		add a,a
		add a,b				; suma (ancho*8) ajuste...
		; orilla derecha		
navlado	ld (ix+9),a			; X = X + ...estos ajustes
	; Navegar
		call gtsSCNO
		ret

; Return SCNO PLAYER location asi si funciona
gtsSCNO		
		; B = OSCNO desde oroomtb
		; C = SCNO hasta roomtb
	; Get last sprite X saved
		ld a,(XPlayer)
		rra
		rra
		rra
		and 31
		ld (XPlayer),a			; XPlayer = X / 8 - 1?
		
		ld a,(roomtb)
		ld hl,oroomtb
		cp (hl)
		jp nc,gts01				;IF not B > C -> gts01
		
		ld a,(scrollx)
		ld hl,XPlayer
		cp (hl)
		jp nc,gts02				;IF not desplazamiento > XPlayer -> gts02
		
		;A ORIGEN
		call prevsroom
		ret						;jp gts03		ENDIF	
gts02	;A DESTINO
		ret						;gts03	jp gts04		;ENDIF

gts01	ld a,(roomtb)
		ld hl,oroomtb
		cp (hl)
		jp c,gts06				;IF B > C -> gts05
		jp z,gts06				;IF B = C -> gts05
		
		ld a,(scrollx)
		ld hl,XPlayer
		cp (hl)
		jp nc,gts06				;IF NOT desplazamiento > XPlayer -> gts06
		
		;A DESTINO
		ret
gts06	;A ORIGEN
		call prevsroom
		ret

XPlayer		defb 0					; posicion X PLAYER, Necesita actualizarse desde PLAYER Automatizado!!
YPlayer		defb 0
Playerptr	defw sprtab

; SCROLL LOOP ------------------------------------------------------------------------
sroom
		xor a               ; zero in accumulator.	   
		ld (comcnt),a       ; reset compression counter.			LET COMCOUNTER=0
		ld (mcomcnt),a		; reserve compression counter.			LET MCOMCOUNTER=0
		call readirooms		; Load irooms
		
		;init cursor x  
		ld a,(wintop)       ; window top.
		ld (dispx),a        ; set x coordinate.						LET X=wintop
		;init row counter
		ld a,(winhgt)       ; height of window.						LET ROWCOUNTER=winhgt
	
;row loop: desde x -> wintop hasta winght, counter -1 desde winhgt
; FROM X = WINGHT TO WINTOP STEP -1
sroom0	push af             ; store row counter.   
; ZONA A
		ld a,(winlft)
		ld e,a
		ld a,(scrollx)
		add a,e				; desplaza a WINDOWLFT + despcounter
		ld (dispy),a        ; set cursor position.			LET Y=WINDOWLFT+DESPLAZAMIENTO
		ld a,(scrollx)
		ld e,a
		ld a,(winwid)
		sub e				; cuenta desde (WINDOWWID - despcounter)
							; LET COLCOUNTER=WINDOWWID-DESPLAZAMIENTO

;collumn loop: desde y -> (winlft + scrollx) hasta winwid, counter -1 desde (winwid - scrollx)
; FROM Y = (winwid - scrollx) TO (winlft + scrollx) STEP -1
sroom1	push af             ; store column counter.

		ld hl,(roomB)
		call mflbyt         ; decompress next DATA byte on the fly.  READ DATA B
		ld (roomB),hl					

		ld hl,(roomA)
		call flbyt          ; decompress next DATA byte on the fly.  READ DATA A
		ld (roomA),hl	

		push hl             ; store address of cell.
		call pattr
		pop hl              ; restore cell address.
		pop af              ; restore loop counter.
		dec a               ; one less column.						 LET COLCOUNTER--
		jr nz,sroom1        ; repeat for entire line.				 REPEAT

; ZONA B
		ld a,(winlft)
		ld (dispy),a        ; set cursor position.					 LET Y=WINDOWLFT
		ld a,(scrollx)		;										 LET COLCOUNTER=DESPLAZAMIENTO

;collumn loop: desde y -> winlft hasta scrollx, counter -1 desde scrollx
; FROM Y = scrollx TO winlft STEP -1
flbend	push af				; store skip counter

		ld hl,(roomA)
		call flbyt          ; decompress next DATA byte on the fly.  READ DATA A
		ld (roomA),hl	

		ld hl,(roomB)
		call mflbyt			; decompress next DATA byte on the fly.  READ DATA B
		ld (roomB),hl					

		push hl             ; store address of cell.
		call pattr          ; show attributes and block.				PRINT CELL B
		pop hl              ; restore cell address.
		pop af              ; restore skip counter.
		dec a               ; one less row.
		jr nz,flbend        ; skip rest all rows.

;end of collumn loops
		ld a,(dispx)        ; x coord.
		inc a               ; move down one line.
		ld (dispx),a        ; set new position.							LET X++
		pop af              ; restore row counter.
		dec a               ; one less row.								LET ROWCOUNTER--
		jr nz,sroom0		; repeat for all rows.						REPEAT
		
;end row loop
		;call movdrw		 	; pinta todos los sprites, objetos de nuevo

		ret
;end scroll loop
		

; Map NAVIGATION ---------------------------------------------------------------------
prevsroom
		ld a,(oroomtb)
		ld (roomtb),a
		ld a,(oscno)		;(1) SCNO ORIGEN ***
		ld (scno),a			;***
		ret					;***
		
presentsroom
		ld a,(scno)			; (1) SCNO ORIGEN
		ld (oscno),a		; Reservala
		ld a,(roomtb)		; Map-position ORIGEN
		ld (oroomtb),a		; Reservalaç
		ret
		
nextsroom
		call gtsSCNO
		
		; load nextroom
		ld hl,restfl		; Set SCNO DESTINO
		ld (hl),2			; RESTARTSCREEN flag ON
		
		xor a
		ld (scrolling),a	; skip setups flag OFF
		ret
		
; Setups PREPARA ROOM -------------------------------------------------------------------
setuprooms
		ld a,(scdir)
		cp 0
		jp z,swrolld
		cp 1
		jp z,swrolli

swrolli
		ld a,$3C			; pre-room at the right $3C (inc a)
		ld (prerol),a
		ld hl,rolromb
		ld (zonaa),hl
		ld hl,rolroma
		ld (zonab),hl
		
		jp rollini
		
swrolld
		ld a,$3D			; pre-room at the left $3D (dec a)
		ld (prerol),a		
		ld hl,rolromb
		ld (zonab),hl
		ld hl,rolroma
		ld (zonaa),hl

rollini	ld a,(scno)			; (1) SCNO ORIGEN
		ld (oscno),a		; Reservala

		defb $CD			; call nn (CD XX XX)
zonaa	defw rolroma		;<--- scroll0_zona_origen-room
		
mappos	ld a,(roomtb)		; Map-position ORIGEN
		ld (oroomtb),a		; Reservala
		
prerol	defb $3D			; Pre-order To Left Map-position dec a ($3D)
		
		call tstsc			; Test it
		inc a
		jp z,skipsetups
		ld a,b
		ld (roomtb),a       ; Actualizala, Pre-ordered map position.

		call tstsc          ; find displacement.
		cp 255              ; is it valid?
		jp z,skipsetups		; no, it's rubbish. fail
		;
		ld (vara),a			; monitoring!!!							LET A (GAME VAR) = ROOM

		defb $CD			; call nn (CD XX XX)
zonab	defw rolromb		;<--- scroll0_zona_destino-room

		ld a,1		
		ld (scrolling),a	; skip setups flag ON					SETUP ROOM COMPLETED

		defb $3E			;ld a,n	 <-- scroll0_FROM
rolfrom	defb 1
		ld (scrollx),a		;init scrollx							INIT DESPLAZAMIENTO

		jp checkroom		; FIN DE PREPARACION ROOM regresa al SCROLL PLAYER

;-------------------------------------------------------------------------------------
rolroma	call setuproom
		ld (roomA),hl		; TO zona A	
		ld (iroomA),hl
		ret
		
rolromb	call setuproom
		ld (roomB),hl		; TO zona B
		ld (iroomB),hl
		ret

skipsetups
		xor a
		ld (vara),a			; monitoring!!!							LET A (GAME VAR) = 0
		ld (scrolling),a	; skip setups flag OFF
		ret

readirooms
		ld hl,(blkptr)      ; blocks.
		ld (grbase),hl      ; set graphics base.					GRBASE=BLKPTR		
		ld hl,(iroomA)
		ld (roomA),hl		; ORIGEN								ROOMA=IROOMA	
		ld hl,(iroomB)
		ld (roomB),hl		; DESTINO								ROOMB=IROOMB
		ret
		
setuproom
		ld hl,(blkptr)      ; blocks.
		ld (grbase),hl      ; set graphics base.					GRBASE=BLKPTR
		ld (scno),a
		call groom          ; get address of current room. 			POINT CELL TABLE
		ret

roomA	defw 0				; original
roomB	defw 0				; next room
iroomA	defw 0
iroomB	defw 0
oroomtb	defb 0
oscno	defb 0
echo	defb 0				; 255,0,1
	
; PROCESA SPRITES desplazamiento sprites y borra sprites fuera de pantalla -------------------
		
SpriteScrollingProcess
		push ix             ; place sprite pointer on stack.
		;call shwob           Cannot move object, LIMITACION por ahora
		ld b,NUMSPR         ; sprites to draw.
		ld ix,sprtab        ; sprite table.
movdrw0 ld a,(ix+0)         ; old sprite type.
		inc a               ; is it enabled?
		jr z,movdrw1         ; no, find next one.
	; Procesa
		call SingleSpriteScrollingProcess

	; limpia (sspria) old sprites and special effects
prints	push bc             ; store sprite counter.
		;call sspria         ; show single sprite. *borra*
		pop bc              ; retrieve sprite counter.
		
movdrw1 ld de,TABSIZ        ; distance to next odd/even entry.
		add ix,de           ; next sprite.
		djnz movdrw0         ; repeat for remaining sprites.
	; redraw blocks if in adventure mode. LIMITACION
		;call rbloc
	; redraw shrapnel. LIMITACION
		;call dshrp
		pop ix              ; retrieve sprite pointer.		
movdrw2	ret

	IF MASKAGD = 1
renuevafondos
		push ix             ; place sprite pointer on stack.
		ld b,NUMSPR         ; sprites to draw.
		ld ix,sprtab        ; sprite table.

renueva0
		push bc
	; guarda fondo desplazado
		call GUARDA_Nuevo_fondo
		pop bc

		ld de,TABSIZ        ; distance to next odd/even entry.
		add ix,de           ; next sprite.
		djnz renueva0        ; repeat for remaining sprites.
		pop ix
		ret
	ENDIF
	
; Necesita ix del Sprite -> debe llamarse desde EVENT PLAYER, o EVENT TYPE <n>, (otra idea es sktype)
SingleSpriteScrollingProcess
		ld a,(ix+9)
sprmov	defb $C6			;<---scroll0_MOVESPRITES add a,n ($C6) Sprites a der, sbc a,n ($DE)sprites a izq
		defb 8
		ld (ix+9),a
	; DESPLAZA con el fondo	
checs0	equ $
		defb $3E			;ld a,n	 <---scroll0_CHECK_EDGE?(-4)
chkedge	defb ((WINDOWLFT * 8) + (WINDOWWID * 8) - 16)	;(wnrgtx)
		;add a,4
		
	; BORRA sprites from edges: TODO: Oculta mejor: FALLA con MASK
		cp (ix+9)
		jr z,checs2			;$+4 salta a borra sprite
eraside	jr nc,checs1		;$+6 ($30 $06) no desaparece por la derecha<--- CASE: Check edge
							; jr c,$+6 ($38 $06) no desaparece por la izq<--- CASE: Check edge			
checs2	ld (ix+0),255		; delete sprite.
		ld (ix+5),255		; remove next type
checs1	ret
		
;-----------------------------------------------------------------------------
mflbyt
		ld a,(mcomcnt)       ; compression counter.
		and a               ; any more to decompress?
		jr nz,mflbyt1        ; yes.
		ld a,(hl)           ; fetch next byte.
		inc hl              ; point to next cell.
		cp 255              ; is this byte a control code?
		ret nz              ; no, this byte is uncompressed.
		ld a,(hl)           ; fetch byte type.
		ld (mcombyt),a       ; set up the type.
		inc hl              ; point to quantity.
		ld a,(hl)           ; get quantity.
		inc hl              ; point to next byte.
mflbyt1 dec a               ; one less.
		ld (mcomcnt),a       ; store new quantity.
		ld a,(mcombyt)       ; byte to expand.
		ret

mcombyt defb 0              ; byte type compressed.
mcomcnt defb 0              ; compression counter.

