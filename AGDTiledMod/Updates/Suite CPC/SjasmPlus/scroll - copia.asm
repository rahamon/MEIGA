;----------------------------
;             .              
;   ZONA B    .   ZONA A     
;             .              
;----------------------------
;
; LIMITACIONES: No puede mover objetos y no puede usar adventure mode
; SCROLL
; Comprobaciones iniciales:
; Dirección
; Reset DESPLAZAMIENTO
; test limites de rooms 
; borrado sprites en límites de pantalla
; DESPLAZAMIENTO de sprites en pantalla 
; cambio de pantalla
; USER DIRECTION
; cambio de sentido!!!
; Setups

; Scroll Control
; 0 SCROLL para la DERECHA
; 1 Scroll para la izquierda
; 128 monitor: devuelve valor x DESPLAZAMIENTO en la variable A
; 64 Reset DESPLAZAMIENTO: usar en RESTARTSCREEN
; 32 Play one Step
; 16 Set Sprite in map position: Necesario para localizar Sprite en mapa para scroller
; 8 Hack Killed SCNO location

Sccrl
chkcrl	cp 3
		jr nc,sccom			; User n > 3 entonces es comando
		
; Cambió de dirección?
chkspin	ld hl,scdir
		cp (hl)
		jp z,spined

; Check directions
chkdir	;ld a,(scdir)
		cp 0
		jp z,scrolld		; player a la izquierda
		cp 1
		jp z,scrolli		; player a la derecha
		; cp 2
		; jp z,scrollarr
		; cp 3
		; jp z,scrollaba	
		; ret

; check command
sccom	cp 128
		jp z,demonitor		; Devuelve parametros
		cp 64
		jp z,resde01		; Restablece DESPLAZAMIENTO y carga screen
		cp 32
		jp z,Play_one_step	; Da un paso
		CP 16
		JP z,saveXPlayerin	; Localiza al jugador en mapa
		cp 8
		jp z,gtsSCNO		; kill player hack
		ret
		
scdir		defb 255		; ultima DIRECTION conocida 
scrollx		defb 0			; desp-counter DESPLAZAMIENTO
scrolling	defb 0			; flag

; Control direccion----------------------------------------------------------------------------
scrolli
		ld (scdir),a		; nueva DIRECTION PLAYER

		ld a,$3D			; scroll to left $3D <--- scroll0_OPERADOR dec a DESPLAZAMIENTO--
		ld (operand),a
		ld a,$DE			; sbc a,n ($DE) sprites a izq
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

		ld a,$3C			; scroll to right $3C <---scroll0_OPERADOR inc a DESPLAZAMIENTO++
		ld (operand),a
		ld a,$C6			; add a,n ($C6) Sprites a der
		ld (sprmov),a
		
		ld a,1				; desde
		ld (rolfrom),a
		ld a,WINDOWWID		; hasta
		ld (roledge),a
		
		ld a,(wnrgtx)
		ld (chkedge),a		; sprites limite visible
		ld a,$30
		ld (eraside),a		; sprites condicion para borrado fiera del limite
		
; Orientado
spined
		; version SYNC	***	play one step flag
		ld a,1
		ld (rolstep),a	
		ret

; Player Seccion----------------------------------------------------------

Scroll_player
chkling	ld a,(scrolling)
		cp 1
		jp z,rolmove		; MUEVE
		jp setuprooms		; salta a SETUPS para rooms
		
rolmove
		ld a,(scrollx)
operand	defb $3C			; $3C inc a, $3D dec a. $3C scroll to right $3C
		ld (scrollx),a		; LET DESPLAZAMIENTO (scrollx) = DESPLAZAMIENTO + Operando
		
checkroom
		ld a,(scrollx)
		defb $FE			; cp n
roledge	defb WINDOWWID
		jp z,nextmroom		; IF DESPLAZAMIENTO, cambia de habitacion
		
		call mroom			; pinta. asyncronica ***
		
		call movdrw			; pinta sprites de nuevo, excepto objetos, tampoco adventure blocks.
								; versión asyncronica ***							
		ret
; end of program

; Rutinas--------------------------------------------------------------------------

; Player Candidate Original version SYNC	***
Play_one_step					; SYNC candidate ***		
		ld a,(rolstep)
		cp 1
		jp z,nextep
		RET
nextep	xor a
		ld (rolstep),a
		jp Scroll_player

rolstep	defb 0							; play step flag

; Redraw patch for ZXEngine:
;Sustituye call droom por call modroom para redibujar correctamente.
modroom
; rolling?		
		ld a,(scrolling)
		cp 1
		jp z,mroom
		jp droom

; Devuelve DESPLAZAMIENTO en A (GAME VAR)
demonitor
		ld a,(scrollx)
		ld (vara),a			; monitoring!!!							LET A (GAME VAR) = DESPLAZAMIENTO
		ld a,(oscno)
		ld (varb),a			; B = OSCNO desde
		ld a,(scno)
		ld (varc),a			; C = SCNO hasta
		ret

; Resetea posicion y estado del scroll: usar en RestartScreen.
resde01
		ld a,(rolfrom)
		ld (scrollx),a		; reset scrollx	(OK)					RESET DESPLAZAMIENTO
		xor a
		ld (scrolling),a	; skip setups flag OFF
		ret
		
; Reserva Posicion X del Player
saveXPlayerin
		ld a,(ix+9)			; get X of current Sprite
		ld (Xlocimap),a		; save in Xlocimap
		ret
		
; Return SCNO player location in variable A: Usar en SceenUp,Down,Left,Right
gtsSCNO		
		; B = OSCNO desde oroomtb
		; C = SCNO hasta roomtb
		ld a,(Xlocimap)		; get last sprite saved X
		rra
		rra
		rra
		and 31
		ld (Xlocimap),a		; Xlocimap = X / 8
		
		ld a,(roomtb)
		ld hl,oroomtb
		cp (hl)
		jp nc,gts01	;IF not B > C -> gts01
		
		ld a,(scrollx)
		ld hl,Xlocimap
		cp (hl)
		jp nc,gts02	;IF not desplazamiento > Xlocimap -> gts02
		
		ld a,(oroomtb)
		ld (vara),a			;LET A = B ORIGEN
		call prevmroom
		jp gts03		;ENDIF
gts02	ld a,(roomtb)
		ld (vara),a			;LET A = C DESTINO
gts03	jp gts04		;ENDIF

gts01	ld a,(roomtb)
		ld hl,oroomtb
		cp (hl)
		jp c,gts05		;IF B > C -> gts05
		jp z,gts05		;IF B = C -> gts05
		
		ld a,(scrollx)
		ld hl,Xlocimap
		cp (hl)
		jp nc,gts06	;IF NOT desplazamiento > Xlocimap -> gts06
		
		ld a,(roomtb)
		ld (vara),a			;LET A = C DESTINO
		jp gts07		;ENDIF
gts06	ld a,(oroomtb)
		ld (vara),a			;LET A = B ORIGEN
		call prevmroom
gts07	jp gts04		;ENDIF
gts05	ld a,(oroomtb)
		ld (vara),a			;LET A = B ORIGEN = C DESTINO
		call prevmroom
gts04	ret

Xlocimap defb 0
Xloc defb 0

; LET D = X
; DIVIDE D BY 8

; USER 128		 devuelve DESPLAZAMIENTO en A

; IF B > C			 DESDE > HASTA : 1 A 0
	; IF D > A
		; LET D = B
	; ELSE
		; LET D = C
	; ENDIF	
; ELSE
	; IF B < C			 DE 0 A 1
		; IF D > A
			; LET D = C
		; ELSE
			; LET D = B
		; ENDIF
	; ELSE				 B = C
		; LET D = B
	; ENDIF
; ENDIF
		
; main scroll loop------------------------------------------------------------------------
mroom
		xor a               ; zero in accumulator.	   
		ld (comcnt),a       ; reset compression counter.			COMCOUNTER=0
		ld (mcomcnt),a		; reserve compression counter.			MCOMCOUNTER=0
		call readirooms		; Load irooms
		
		;init cursor x  
		ld a,(wintop)       ; window top.
		ld (dispx),a        ; set x coordinate.						X=wintop
		;init row counter
		ld a,(winhgt)       ; height of window.						ROWCOUNTER=winhgt
		
;row loop: desde x -> wintop hasta winght, counter -1 desde winhgt
mroom0	push af             ; store row counter.   
; ZONA A
		ld a,(winlft)
		ld e,a
		ld a,(scrollx)
		add a,e				; desplaza a WINDOWLFT + despcounter
		ld (dispy),a        ; set cursor position.					Y=WINDOWLFT+DESPLAZAMIENTO
		ld a,(scrollx)
		ld e,a
		ld a,(winwid)
		sub e				; cuenta desde (WINDOWWID - despcounter) COLCOUNTER=WINDOWWID-DESPLAZAMIENTO

;collumn loop: desde y -> (winlft + scrollx) hasta winwid, counter -1 desde (winwid - scrollx)
mroom1	push af             ; store column counter.

		ld hl,(roomB)
		call mflbyt          ; decompress next DATA byte on the fly.  READ DATA B
		ld (roomB),hl					

		ld hl,(roomA)
		call flbyt          ; decompress next DATA byte on the fly.  READ DATA A
		ld (roomA),hl	

		push hl             ; store address of cell.
		call pattr
		pop hl              ; restore cell address.
		pop af              ; restore loop counter.
		dec a               ; one less column.						 COLCOUNTER--
		jr nz,mroom1        ; repeat for entire line.				 REPEAT

; ZONA B
		ld a,(winlft)
		ld (dispy),a        ; set cursor position.					 Y=WINDOWLFT
		ld a,(scrollx)		;										 COLCOUNTER=DESPLAZAMIENTO

;collumn loop: desde y -> winlft hasta scrollx, counter -1 desde scrollx	
flbend	push af				; store skip counter

		ld hl,(roomA)
		call flbyt          ; decompress next DATA byte on the fly.  READ DATA A
		ld (roomA),hl	

		ld hl,(roomB)
		call mflbyt          ; decompress next DATA byte on the fly.  READ DATA B
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
		ld (dispx),a        ; set new position.							X++
		pop af              ; restore row counter.
		dec a               ; one less row.								ROWCOUNTER--
		jr nz,mroom0		; repeat for all rows.						REPEAT
		
;end row loop
		;call movdrw		 	 pinta todos los sprites, objetos de nuevo
		ret
;end scroll loop
		

; Map navigation---------------------------------------------------------------------
prevmroom
		ld a,(oroomtb)
		ld (roomtb),a
		ld a,(oscno)			;(1) SCNO ORIGEN ***
		ld (scno),a				;***
		ret						;***
		
nextmroom
		call gtsSCNO
		
		ld hl,restfl		; Set SCNO DESTINO
		ld (hl),2			; RESTARTSCREEN flag ON
		
		xor a
		ld (scrolling),a	; skip setups flag OFF
		ret
		
;Setups-------------------------------------------------------------------------------------------
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

		jp checkroom					;

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
	
; Redibuja, mueve sprites y borra sprites fuera de pantalla.-----------------------------------------------
movdrw
		push ix             ; place sprite pointer on stack.
		;call mroom
		;call shwob           Cannot move object, LIMITACION
		ld b,NUMSPR         ; sprites to draw.
		ld ix,sprtab        ; sprite table.
movdrw0 ld a,(ix+0)         ; old sprite type.
		inc a               ; is it enabled?
		jr z,movdrw1         ; no, find next one.

		;jp prints			; descomenta esta línea si NO QUIERES mover sprites automaticamente
							; puede que quieras controlarlos tu mism@
							
;move sprites script
		ld a,(ix+9)
sprmov	defb $C6			;<---scroll0_MOVESPRITES add a,n ($C6) Sprites a der, sbc a,n ($DE)sprites a izq
		defb 8
		ld (ix+9),a
		
;delete sprites from edges	
checs0	equ $
		defb $3E			;ld a,n	 <---scroll0_CHECK_EDGE?(-4)
chkedge	defb ((WINDOWLFT * 8) + (WINDOWWID * 8) - 16)	;(wnrgtx)
		;add a,4
		cp (ix+9)
		jr z,$+4			; salta a borra sprite
eraside	jr nc,$+6			; ($30 $06) no desaparece por la derecha<--- CASE: Check edge
							; jr c,$+6 ($38 $06) no desaparece por la izq<--- CASE: Check edge
		;defb $06			
		ld (ix+5),255		; desaparece sprites a derecho o izquierda 
checs1
		;ld a,(ix+3)          sprite x.
		;cp 177				 beyond maximum?
		;jp nc,movdrw1        yes, nothing to draw.

prints
		push bc             ; store sprite counter.
		call sspria         ; show single sprite.
		pop bc              ; retrieve sprite counter.

movdrw1 ld de,TABSIZ        ; distance to next odd/even entry.
		add ix,de           ; next sprite.
		djnz movdrw0         ; repeat for remaining sprites.
		;call rbloc           redraw blocks if in adventure mode. LIMITACION
		call dshrp          ; redraw shrapnel.
		pop ix              ; retrieve sprite pointer.
		ret

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

		

