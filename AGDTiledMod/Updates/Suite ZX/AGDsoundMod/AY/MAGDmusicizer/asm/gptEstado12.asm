En algunos juegos falla el control del jugador con el teclado cuando cambio de Stage, cual es la razon?


rstrt1 ;jp bsortx			; skip screen layout.			*** controll FROM scripts rstrt1
	
	IF ULABUFFER = 1
		call InitULABuffers
	ENDIF
	
	IF ULABUFFER = 2
		call bankP
		call VIDEOToRAM7
;		call bank0
	ENDIF
	
mloop
	IF ULABUFFER = 1
		;call waitIRQ
		;call joykey
	ENDIF

	IF MASKAGD = 1
	; AND routines: incluir con rutina mascara _bucle_estable
		ld a,(MASKAGDopt)
		and a
		jr nz,sistmask
		call vsync
	; A Impresion desprites impares
		ld ix,sprtab        ; address of sprite table, even sprites.
		call dspr           ; display even sprites.
		call vsync
	; B Impresion desprites pares	 
		ld ix,sprtab+TABSIZ ; address of first odd sprite.
		call dspr           ; display odd sprites.
		jr endsistmask
sistmask	
		call vsync
async	ld ix,sprtab
		call PRINT_Sprites_NC			; borra y pinta sprites que no colisionan.
		push ix
		ld ix,sprtab
		call RESTAURA_Fondo_C			; borra sprites que clisionan
		pop ix
		call PRINT_Sprites_C			; pinta sprites que colisionan
		call vsync
endsistmask
	ELSE
	; XOR routines
			call vsync
		; A Impresion desprites impares
			ld ix,sprtab        ; address of sprite table, even sprites.
			call dspr           ; display even sprites.
			call vsync
		; B Impresion desprites pares	 
			ld ix,sprtab+TABSIZ ; address of first odd sprite.
			call dspr           ; display odd sprites.
	ENDIF
	
	IF ULABUFFER = 2
	; Conmuta Screen Buffer debería estar despues de evnt11 despues de In Front Plugin
		call bankP
		call bank0
	ELSE
	ENDIF

	IF ULABUFFER = 1
		; Conmuta Screen Buffer debería estar despues de evnt11 despues de In Front Plugin
		call FlipBufferSafe
	ENDIF
	
;----------------

; subroutines 

bank0:	; swap to bank 0 - original @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or 0 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret

bank4:	; swap to bank 4 @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or 4 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret 

bankb:	; swap to bank asigned in b @ 49152 - 16k
		;di
		ld a,(23388)   
		and 248
		or b 
		ld bc,32765
		ld (23388),a
		out (c),a
		;ei
		ret

	; ===== Espera VBlank comienzo de frame (con ISR player)=====
waitIRQ	halt
		ld a,(TickFlag)
		or a
		jr z,waitIRQ
		xor a
		ld (TickFlag),a
		ret

TickFlag	defb 0
		
banka	;di
		ld (23388),a
		ld bc,32765
		out (c),a
		ld (ULABank),a		; set ULABank
		;ei
		ret

bankP	; flip ULA Buffers
		ld a,(ULABank)
		cp %00001111		; Shadow Buffer is on?...
		jr z,ConectA
BufferOn
		ld a,%00001111		; ...no, Set it On BufferB 0000 1111(Shadow-Bank7)
		call banka			; MUESTRA la pantalla de RAM 7
		ret
ConectA
		call VIDEOToRAM7	; COPIA en buffer
		ld a,%00001101
		call banka			; ULABank = BufferA (screen) 0000 1101(normal-bank5)
		ret

VIDEOToRAM7
		ld a,%00001111
		call banka
		di
		;jp VIDEOToRAM7DOS
		ld     hl, $4000			; desde 5
		ld     de, $c000			; hasta 7on
		ld     bc, 6912
		ldir
		ei
		ret
		
InitULABuffers:
        ld a,(23388)
        push af
			;call bankP
			call VIDEOToRAM7
			;call bank0
        pop af
		call banka
        ret
		
FlipBufferSafe
		;di
			call bankP
			call bank0
		;ei
        ret

ULABank	defb %00001111			; Ultuma ULAScreen, defecto 7 Shadow buffer
								;la ULA muestra la pantalla de RAM 7
								;el banco paginado en 0xC000 es también RAM 7

VIDEOToRAM7DOS
		; Copia 0x4000 -> 0xC000 (banco7)
        ret
	
showSplash
		; Volcado de pantalla
		; desde origen = hl
		; banco origen = a
		ld de,$4000		; destino pantalla
		; ld bc,6912 todos estos bites (automatico): aqui sumamos los tres secciones
		call UnzipB
		ret

SaveToBank
LoadFromBank
showSplashparam
		; volcado datos generico
		; Parámeters:
		; a = banco origen/destino
		; hl = direccion origen
		; de = destino address
		; bc = longitud
		
		push bc
		di				; everyone wait a minute!
		ld b,a			; I want to see this memory bank, variable a introducida para propósito general
		call bankb		; switch to that bank
		pop bc
		ldir			; copy data
		call bank0		; now look at bank 0 (the usual one)
		ei				; you can continue with your things
		ret				; thank you
		
UnzipB
		; descomprime datos en destino (de) longitud datos automático (bc)
		; Parámeters:
		; a = banco origen/destino
		; hl = direccion origen
		; de = destino address

		di				; everyone wait a minute!
		ld b,a			; I want to see this memory bank, variable a introducida para propósito general
		call bankb		; switch to that bank
		call zx7bin		; hl=source (bank org), de=destination (low adress < bank2), bc=longitud automática 
						; -> copy data
		call bank0		; now look at bank 0 (the usual one)
		ei				; you can continue with your things
		ret				; thank you

;----------------

; Joystick and keyboard reading routines.

joykey ld a,(contrl)       ; control flag.
       dec a               ; is it the keyboard?
       jr z,joyjoy         ; no, it's Kempston joystick.
       dec a               ; Sinclair?
       jr z,joysin         ; read Sinclair joystick.

; Keyboard controls.

       ld hl,keys+6        ; address of last key.
       ld e,0              ; zero reading.
       ld d,7              ; keys to read.
joyke0 ld a,(hl)           ; get key from table.
       call ktest          ; being pressed?
       ccf                 ; complement the carry.
       rl e                ; rotate into reading.
       dec hl              ; next key.
       dec d               ; one less to do.
       jp nz,joyke0        ; repeat for all keys.
       jr joyjo1           ; store the value.

; Kempston joystick controls.

joyjoy ld bc,31            ; port for Kempston interface.
       in a,(c)            ; read it.
joyjo3 ld e,a              ; copy to e register.
       ld a,(keys+5)       ; key six.
       call ktest          ; being pressed?
       jr c,joyjo0         ; not pressed.
       set 5,e             ; set bit d5.
joyjo0 ld a,(keys+6)       ; key seven.
       call ktest          ; being pressed?
       jr c,joyjo1         ; not pressed.
       set 6,e             ; set bit d6.
joyjo1 ld a,e              ; copy e register to accumulator.
joyjo2 ld (joyval),a       ; remember value.
       ret

; Sinclair joystick controls.

joysin ld bc,61438         ; port for Sinclair 2.
       in a,(c)            ; read joystick.
       ld d,a              ; clear values.
       xor a               ; clear accumulator.
       ld e,16             ; Kempston fire bit value.
       bit 0,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       ld e,1              ; Kempston bit value.
       bit 3,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       ld e,2              ; Kempston bit value.
       bit 4,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       ld e,8              ; Kempston bit value.
       bit 1,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       ld e,4              ; Kempston bit value.
       bit 2,d             ; fire bit pressed?
       call z,joysi0       ; add bit.
       jr joyjo3           ; read last 2 keys a la Kempston.

joysi0 add a,e             ; add bit value.
       ret
	   
; Selecciona Stage
; AGD Stageinclude.asm included in (player) to select Stage module to de played
; Codigo en editor AGD:
; let A = n
; Call UserMod + 3
;
STAGES	equ 49152
Levelbank	equ 1
RoomBank	equ 7
ZERObank	equ 3

			;call InitZEROBank
;AGD Stagesselector.asm

			; CHECK Comando FixStartPosition
			ld a,(vara)
			cp 32
			jp z,ResetMapStartPo
			cp 33
			jp z,FixScreen
			cp 34
			jp z,SetFixedDe
			
; LastStage Pattern
			ld hl,lastStage
			ld a,(vara)
			cp (hl)
			jp nz,NewStage	; is NOT the same stage -> Load new Stage
			
			ret			; revisar!
		
; Fix screens in this Stage from OffSetDesplazamiento. Solo para screens, no debería estar aqui*** Deberia estar en AGDScript,
;Obtiene scno-FixedDe
FixScreen
			ld hl,FixedDe
			ld a,(scno)
			sub (hl)				; Resta B a la screen numero para fijar las nuevas screens
			ld (scno),a
			
			; TEST
			;ld hl,roomtb
			;ld a,(hl)
			ld (varn),a
			;call droom
			
			ret

SetFixedDe
			ld a,(varb)
			ld (FixedDe),a			; store B (ofset desplazamiento scno)
			ret
			
ResetMapStartPo
			xor a
			ld (FixedPo),a
			ret		
FixStartPos			
	; Mod
			ld a,(FixedPo)
			and a
			ret nz			; si a <> 0 -> return
		; Fix start position in MAP
			ld hl,(mapst+1)
			ld a,(hl)
			ld (roomtb),a
		; TEST
			;ld (vars),a
			
			ld a,1
			ld (FixedPo),a
			ret
			
NewStage		
			ld (lastStage),a			; last selected screen is this now.

			;call FixScreen
			
			ld a,(vara)
		
;SelectStage:		
		include "Stagesselector.asm" ; Colocar aquí lastStage = ZERO
									; olocar tambien ret

;*** Programa a parte ***
;AGD Stages.asm included in (player) to setup Stage module selected
; por cada seccione en Stage\Selected
		include "Stages.asm"

;AGD Setupections.asm in Player to setup section selected ***
	;Por cada seccion en Stages
	; compila y mide
		include "Setupsections.asm"

;Secplayerroutines.asm to be included
SetupStage
debug jr debug
		push hl
		push bc
		
		ld e,6
		ld d,0
		add hl,de
		ld b,Levelbank
		call bankb	
		ld a,(hl)	
		ld e,a		
		call bank0
		ld a,e

		pop bc
		pop hl
		
		; selecciona destino segun tipo de datos
		cp 1
		jp z,setupSpr
		cp 2
		jp z,setupScr
		cp 3
		jp z,setupBlk
		cp 4
		jp z,setupMsg
		cp 5
		jp z,setupEne
		cp 6
		jp z,setupObj
		cp 7
		jp z,setupEve
		
		; ld a,255
		; ld (vara),a
		ret			; error

dataOrg	defw STAGES
dataLon	defw 0	
dataDes	defw 0
FixedPo defb 0		; fijado nuevo mapa flag
FixedDe	defb 0		; Desplazamiento fijado para cálculo de scno
		
;DESTINO seguntipo de datos
setupSpr
		ld de,SprDataCode
		call SetupStagedata
		call UpdateSprites
		ret
setupScr
		ld de,ScrDataCode
		; ld (dataOrg),hl
		; ld (dataLon),bc
		; ld (dataDes),de	
		call SetupStagedata
		call UpdateScreens
		ret
setupBlk
		ld de,BlkDataCode
		call SetupStagedata
		call UpdateBlocks
		ret
setupMsg
		ld de,MsgDataCode
		call SetupStagedata
		call UpdeteMensajes
		ret
setupEne
		ld de,EneDataCode
		call SetupStagedata
		call UpdeteSpritespositions
		ret
setupMap
		ld de,MapDataCode
		call SetupStagedata
		call UpdeteWolrdMap
		call FixStartPos
		ret
setupObj
		ld de,ObjDataCode
		call SetupStagedata
		call UpdeteObjetsRooms
		ret

setupEve
		ld de,EveDataCode
		call SetupStagedata
		call UpdateEvents
		ret

SetupStagedata
		ld a,(Lbank)
		cp ZERObank
		jp z,ldZero			; Carga Livel ZERO	
		call UnzipB			; Carga Levels
		ld a,Levelbank		; apuntando a levels
swLevel	ld (Lbank),a
		ret		
ldZero	call UnzipB
		ld a,ZERObank		; continuando a Level ZERO
		jr swLevel

		
updatepointers
		; imitar patron 48k	
		;call StageUpdate

		;call redraw									;***test control FROM scripts
		
		;ld hl,restfl        ; restart screen flag.		***test control FROM scripts
		;ld (hl),2           ; set it.					***test control FROM scripts

		; si viene de LevelZERO entonces incluye evnt12 en la ecuación
		; esto esta incluido en WriteStageZERO
			;call evnt12
		
		; test seccion de evnetos
		
		ret					; update and exit
		
		; include "SECsizes.asm"
		;include "ZEROBankInstaller.asm"

;-----------------
; Screen synchronisation.

vsync  call joykey         ; read joystick/keyboard.
       ld a,(sndtyp)       ; sound to play.
       and a               ; any sound?
       jp z,vsync1         ; no.
       ld b,a              ; outer loop.
       ld a,(23624)        ; border colour.
       rra                 ; put border bits into d0, d1 and d2.
       rra
       rra
       ld c,a              ; first value to write to speaker.
       ld a,b              ; sound.
       and a               ; test it.
       jp m,vsync6         ; play white noise.
vsync2 ld a,c              ; get speaker value.
       out (254),a         ; write to speaker.
       xor 248             ; toggle all except the border bits.
       ld c,a              ; store value for next time.
       ld d,b              ; store loop counter.
vsync3 ld hl,clock         ; previous clock setting.
       ld a,(23672)        ; current clock setting.
       cp (hl)             ; subtract last reading.
       jp nz,vsync4        ; yes, no more processing please.
       djnz vsync3         ; loop.
       ld b,d              ; restore loop counter.
       djnz vsync2         ; continue noise.
vsync4 ld a,d              ; where we got to.
vsynca ld (sndtyp),a       ; remember for next time.

vsync1 ld a,(23672)        ; clock low.
       rra                 ; rotate bit into carry.
       call c,vsync5       ; time to play sound and do shrapnel/ticker stuff.
       ld hl,clock         ; last clock reading.
vsync0 ld a,(23672)        ; current clock reading.
       cp (hl)             ; are they the same?
       jr z,vsync0         ; yes, wait until clock changes.
       ld (hl),a           ; set new clock reading.
       ret

vsync5 call plsnd          ; play sound.

       jp proshr           ; shrapnel and stuff.

; Play white noise.

vsync6 ld a,b              ; 128 - 255.
       sub 127
       ld b,a
       ld hl,clock         ; previous clock setting.
vsync7 ld a,r              ; get random speaker value.
       and 248             ; only retain the speaker/earphone bits.
       or c                ; merge with border colour.
       out (254),a         ; write to speaker.
       ld a,(23672)        ; current clock setting.
       cp (hl)             ; subtract last reading.
       jp nz,vsync8        ; yes, no more processing please.
       ld a,b
       and 127
       inc a
vsync9 dec a
       jr nz,vsync9        ; loop.
       djnz vsync7         ; continue noise.
vsync8 xor a
       jr vsynca
sndtyp defb 0
;clock  defb 0              ; last clock reading.
