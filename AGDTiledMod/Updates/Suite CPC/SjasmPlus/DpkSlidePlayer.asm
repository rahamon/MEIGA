; BASIC
; MEMORY &1FFF:LOAD"dpkslide.bin,&A400: REM este player
; MODE 2:BORDER 0:INK 0,0: REM fondo
; LOAD"SCREEN.scr",&2000: REM generada con ConvImgCPC ya comprimida
; CALL &A400: REM play screen

; MEMORY &1FFF: $2000:scr <------17408.scr------> $6400:zx7bin <--16384--> $A400:Player.bin <------> $c000:video.
; MEMORY 8191: 8192:scr <------17408.scr------> 25600:zx7bin <--16384--> 41984:Player.bin <--------> 49132

; --------------------------------------> 24832 en ZX spectrum <------------------GAME-------------------------> 65535

; Modificacion para Volcado de pantalla desde origen = hl, banco origen = a

		ld		(BuffCmp),hl			; Apunta a la nueva direccion de datos
		jr		DpkSlidePlayer
		
BuffTmp equ		$8000                   ; Búfer de desembalaje temporal, 17408 bytes en memoria base.
BuffCmp defw	$4000                   ; Imagen comprimida en buffer, aproximadamente 8400 bytes, en memoria extendida.
; 
DpkSlidePlayer       
        ; Compruebe que el archivo tenga una imagen bien comprimida.
        jp skipCompChecking
		;LD      HL,BuffCmp
        LD      A,(HL)                  ; +0 comprobar el encabezado del archivo
        CP      'P'
        RET     NZ
        INC     HL
        LD      A,(HL)                  ; +1
        CP      'K'
        RET     NZ
        INC     HL
        LD      A,(HL)					; +2 Debe comenzar con "PKS"
        CP      'S'
        RET     NZ
        INC     HL
        LD      A,(HL)                  ; +3 Entonces, 4to byte = tipo de imagen
        CP      'L'                     ; 'L' = image "normale"
        JR      Z,ImgType1
        CP      'P'                     ; 'P' = image CPC+
        JR      Z,ImgType2
        CP      '3'                     ; '3' = image "mode 3"
        JR      Z,ImgType3
        ;RET		; Si no se identifica, regresar...
		
skipCompChecking
;
; Image type 1 - CPC "OLD" en mode 0, 1 ou 2
;
ImgType1:
        ; Cargar Datos de imagen en $2015 = BuffCmp+21
		;LD      HL,BuffCmp+21            Datos de imagen en $2015
        LD      HL,(BuffCmp)
		ld 		de,21
		add		hl,de		; Suma el valor de DE (21) a HL
		
        CALL    DecompImage
		
        EI
        ;LD      A,(BuffCmp+4)            Mode en $2004
        LD      HL,(BuffCmp)
		ld 		de,4
		add		hl,de		; Suma el valor de DE (4) a HL
        LD      A,(hl)           		; Mode en $2004
		
        CALL    $BD1C                   ; Cambiar modo sin borrar la pantalla
        ;LD      HL,BuffCmp+5             Palette en $2005
        LD      HL,(BuffCmp)
		ld 		de,5
		add		hl,de		; Suma el valor de DE (5) a HL
        XOR     A
SetCol:
        PUSH    AF
        PUSH    HL
        LD      B,(HL)
        LD      C,B
        CALL    $BC32                   ; Initialisation palette de couleurs
        POP     HL
        POP     AF
        INC     HL
        INC     A
        CP      16
        JR      C,SetCol
        ;JP      $BB18                    Espere a que se presione una tecla
		RET
		
;
; Image type 2 - CPC + en mode 0, 1 ou 2
;
ImgType2:
        ;LD      HL,BuffCmp+37            Datos image en $2025
        LD      HL,(BuffCmp)
		ld 		de,37
		add		hl,de		; Suma el valor de DE (37) a HL
        CALL    DecompImage
        LD      BC,$BC11
        LD      HL,UnlockAsic           ; Secuencia de desbloqueo ASIC para CPC+
SetSeq:
        LD      A,(HL)
        OUT     (C),A                   ; Enviando datos
        INC     HL
        DEC     C
        JR      NZ,SetSeq
		
        ;LD      A,(BuffCmp+4)            Modo de pantalla en $2004
        LD      HL,(BuffCmp)
		ld 		de,4
		add		hl,de		; Suma el valor de DE (4) a HL
        LD      A,(hl)           		; Mode en $2004
        LD      BC,$7FB8
        OUT     (C),C
        OUT     (C),A
        ;LD      HL,BuffCmp+5             Palette CPC+ en $2005
        LD      HL,(BuffCmp)
		ld 		de,5
		add		hl,de		; Suma el valor de DE (5) a HL
        LD      de,BuffTmp
        LD      BC,17*2
        LDIR
		
; Saliendo		
        LD      BC,$7FA0
        OUT     (C),C
        EI
        RET

;
; Image type 3 - CPC old en mode "3" (Mode 1 avec 6 couleurs/lignes)
;
ImgType3:
        ;LD      HL,BuffCmp+1206         Datos image en $24B6
        LD      HL,(BuffCmp)
		ld 		de,1206
		add		hl,de		; Suma el valor de DE (1206) a HL
        CALL    DecompImage
        LD      HL,($38)
        LD      (RestoreIRQ+1),HL       ; Vector antiguo de copia de seguridad $38
        LD      HL,$C9FB
        LD      ($38),HL                ; EI et RET en $38
        LD      BC,$7F8D
        OUT     (C),C                   ; Interrupcion en Mode 1
        XOR     A
        OUT     (C),A                   ; Sélectionner couleur 0
        ;LD      HL,BuffCmp+4             Adresse de la valeur de la couleur 0
        LD      HL,(BuffCmp)
		ld 		de,4
		add		hl,de		; Suma el valor de DE (4) a HL
        OUTI                            ; Et affecter
BoucleImg3:
        LD      B,$F5
WaitVBL:
        IN      A,(C)                   ; Espera el VBL
        RRA
        JR      NC,WaitVBL
        CALL    TstEspace               ; test touche espace appuyée
        JR      NC,Fin                  ; si oui, fini
        EI
        HALT                            ; Attendre 2 interruptions
        HALT
        DI
        LD      B,158
Wait1:
        LD      HL,0                    ; Pause pour se synchroniser au début
        DJNZ    Wait1                   ; de l'écran visible
        XOR     A                       ; A = 0 pour tester fin des couleurs
        LD      BC,$7F01                ; C = ink 1
        ;LD      HL,BuffCmp+5             Palette en $2005
        LD      HL,(BuffCmp)
		ld 		de,5
		add		hl,de		; Suma el valor de DE (5) a HL
        LD      DE,$203                 ; D = ink 2, E = ink 3
SetCoul:
        OUT     (C),C                   ; ink 1
        OUTI
        OUT     (C),D                   ; ink 2
        OUTI
        OUT     (C),E                   ; ink 3
        OUTI
        NOP
        NOP                             ; Temps d'attente
        LD      BC,$7F01                ; Repositionner registre B
        OUT     (C),C                   ; ink 1
        OUTI
        OUT     (C),D                   ; ink 2
        OUTI
        OUT     (C),E                   ; ink 3
        OUTI
        CP      (HL)                    ; Valeur = 0 ?
        JR      NZ,SetCoul              ; Si non, on continue
        JR      BoucleImg3              ; Boucle attente touche

Fin:
        DI
RestoreIRQ:
        LD      HL,0
        LD      ($38),HL                ; Restaurer ancien vecteur $38
        EI
        RET

        ;
        ; Décompacter l'image dans un buffer temporaire
        ;
DecompImage:
        DI
        LD      DE,BuffTmp
        CALL    zx7bin

        ;
        ; Limpia la pantalla (todos los colores a 0)
        ;
        LD      BC,$7F54
        LD      A,$11
ClearLinesScreen:
        DEC     A
        OUT     (C),A
        OUT     (C),C
        JR      NZ,ClearLinesScreen

        ;
        ; Muestra la nueva imagen
        ;
        LD      DE,BuffTmp
        LD      HL,$C000
Draw1:
        LD      A,200
Draw2:
        EX      DE,HL
        LDI
        EX      DE,HL
        LD      BC,$7FF
        ADD     HL,BC
        JR      NC,Draw3
        LD      BC,$C050
        ADD     HL,BC
Draw3:
        DEC     A
        JR      NZ,Draw2
        LD      BC,$7CF
        SBC     HL,BC
        LD      A,L
        CP      $50
        JR      C,Draw1
        RET
;
; Lectura del teclado (y en particular de la tecla espacio...)
;
TstEspace:
        XOR     A
        LD      BC,$F40E                ; Registre 14 du PSG
        OUT     (C),C
        LD      BC,$F6C0                ; Ecriture numéro registre
        OUT     (C),C
        OUT     (C),A
        LD      BC,$F792                ; Port A PPI en lecture
        OUT     (C),C
        LD      BC,$F645                ; ligne = 5 (pour touche espace)
        OUT     (C),C
        LD      B,$F4                   ; Lecture registre
        IN      A,(C)
        LD      BC,$F782                ; Repasse port A PPI en écriture
        OUT     (C),C
        RLA                             ; Bit 7 dans Flag C
        RET
		
UnlockAsic:
        DB      $FF, $00, $FF, $77, $B3, $51, $A8, $D4
        DB      $62, $39, $9C, $46, $2B, $15, $8A, $CD, $EE

		; des-compresor
			include	"zx7.asm"
