;
; Rutina de visualización de una imagen en overscan (versión CPC OLD)
; Se posiciona la memoria de video a partir de la dirección #200
; La zona #800 a #9FF está libre y puede ser utilizada
; para el almacenamiento del modo, los colores y la rutina de visualización.
;
        ORG    #800
Mode:
        DB      0
Couleurs:
        DS      16

        LD      HL,Overscan
        CALL    SetCrtc
        LD      A,(Mode)
        CALL    #BD1C
        LD      HL,Couleurs
        XOR     A
SetCol:
        LD      C,(HL)
        LD      B,C
        PUSH    AF
        PUSH    HL
        CALL    #BC32
        POP     HL
        POP     AF
        INC     HL
        INC     A
        CP      16
        JR      NZ,SetCol
        CALL    #BB18
        LD      HL,NoOverscan
SetCrtc:
        LD      BC,#BC
Bcl:
        LD      A,(HL)
        AND     A
        RET     Z
        OUT     (C),A
        INC     B
        INC     HL
        LD      A,(HL)
        OUT     (C),A
        INC     HL
        DEC     B
        JR      Bcl

Overscan:
        DB      1,48,2,50,3,#89,6,34,7,35,12,13,13,0,0,0
NoOverscan:
        DB      1,40,2,46,3,#8E,6,25,7,30,12,48,0,0
