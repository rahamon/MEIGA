; *****************************************************************************
; * ROM BEEP Engine
; *
; * By Chris Cowley
; *
; * Produced by Beepola v1.08.01
; ******************************************************************************
 
START:
                          LD   HL,MUSICDATA         ;  <- Pointer to Music Data. Change
                                                    ;     this to play a different song
                          LD   A,(HL)                         ; Get the loop start pointer
                          LD   (PATTERN_LOOP_BEGIN),A
                          INC  HL
                          LD   A,(HL)                         ; Get the song end pointer
                          LD   (PATTERN_LOOP_END),A
                          INC  HL
                          LD   (PATTERNDATA1),HL
                          LD   (PATTERNDATA2),HL
                          LD   A,254
                          LD   (PATTERN_PTR),A                ; Set the pattern pointer to zero
                          CALL  NEXT_PATTERN
                          EI
                          RET
NEXTNOTE:
                          EI
                          CALL  PLAYNOTE

                          EI
                          RET                                 ; Return from playing tune

PATTERN_PTR:              DEFB 0
NOTE_PTR:                 DEFB 0


; ********************************************************************************************************
; * NEXT_PATTERN
; *
; * Select the next pattern in sequence (and handle looping if we've reached PATTERN_LOOP_END
; * Execution falls through to PLAYNOTE to play the first note from our next pattern
; ********************************************************************************************************
NEXT_PATTERN:
                          LD   A,(PATTERN_PTR)
                          INC  A
                          INC  A
                          DEFB $FE                           ; CP n
PATTERN_LOOP_END:         DEFB 0
                          JR   NZ,NO_PATTERN_LOOP
                          DEFB $3E                           ; LD A,n
PATTERN_LOOP_BEGIN:       DEFB 0
NO_PATTERN_LOOP:          LD   (PATTERN_PTR),A
			                    DEFB $21                            ; LD HL,nn
PATTERNDATA1:             DEFW $0000
                          LD   E,A                            ; (this is the first byte of the pattern)
                          LD   D,0                            ; and store it at TEMPO
                          ADD  HL,DE
                          LD   E,(HL)
                          INC  HL
                          LD   D,(HL)
                          LD   A,(DE)                         ; Pattern Tempo -> A
	                	      LD   (TEMPO),A                      ; Store it at TEMPO

                          LD   A,1
                          LD   (NOTE_PTR),A

PLAYNOTE: 
			                    DEFB $21                            ; LD HL,nn
PATTERNDATA2:             DEFW $0000
                          LD   A,(PATTERN_PTR)
                          LD   E,A
                          LD   D,0
                          ADD  HL,DE
                          LD   E,(HL)
                          INC  HL
                          LD   D,(HL)                         ; Now DE = Start of Pattern data
                          LD   A,(NOTE_PTR)
                          LD   L,A
                          LD   H,0
                          ADD  HL,DE                          ; Now HL = address of note data
                          LD   D,(HL)

                          ; IF D = $0 then we are at the end of the pattern so set next pattern
                          LD   A,D
                          AND  A                              ; Optimised CP 0
                          JR   Z,NEXT_PATTERN

                          INC  HL
                          LD   E,(HL)

                          LD   A,(NOTE_PTR)
                          INC  A
                          INC  A
                          LD   (NOTE_PTR),A                   ; Increment the note pointer by 2 (one note per chan)

                          ; D = Note1 Value 0-255 (1=rest)
                          ; E = Note2 Value 0-255 (1=rest)

OUTPUT_NOTE:              LD   A,(TEMPO)
                          LD   B,A
OUTPUT_NOTE_LOOP:         PUSH BC
                          PUSH DE
                          LD   A,D
                          CALL BEEP_REST_A
OUTPUT_CH2:               POP  DE
                          PUSH DE
                          LD   A,E
                          CALL BEEP_REST_A
                          POP  DE
                          POP  BC
                          DJNZ OUTPUT_NOTE_LOOP
                          RET

BEEP_REST_A:              DEC  A
                          JR   Z,REST
                          ; Push duration onto calc stack
                          PUSH AF 
                          RST  $28 
                          DEFB $34
                          DEFB $EB,$23,$D7,$0A,$3D
                          DEFB $38
                          POP  AF
                          ; Push note value onto calc stacl
                          INC  A
                          CALL $2D28
                          LD   A,60
                          CALL $2D28
                          RST  $28 
                          DEFB $03,$38   ; SUBTRACT, END
                          CALL $03F8
                          RET
REST:                     HALT
                          HALT
                          LD   B,$FF
REST_LOOP:                LD   A,(BC)    ; Waste 7 Ts each iteration
                          DJNZ REST_LOOP
                          RET


; *** DATA ***
TEMPO:                    DEFB 2

MUSICDATA:
                          DEFB 0   ; Loop start point * 2
                          DEFB 14   ; Song Length * 2
PATTERNDATA:              DEFW PAT0
                          DEFW PAT1
                          DEFW PAT2
                          DEFW PAT3
                          DEFW PAT4
                          DEFW PAT5
                          DEFW PAT6

; *** Pattern data consists of pairs of note values CH1,CH2 with a single $0 to
; *** mark the end of the pattern, and $01 for a rest
PAT0:
                          DEFB 2  ; Pattern tempo
                          DEFB 1,102
                          DEFB 1,101
                          DEFB 1,104
                          DEFB 1,102
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 1,90
                          DEFB 1,89
                          DEFB 1,92
                          DEFB 1,90
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 102,102
                          DEFB 1,1
                          DEFB 102,102
                          DEFB 104,104
                          DEFB 1,104
                          DEFB 105,105
                          DEFB 106,106
                          DEFB 106,106
                          DEFB 106,106
                          DEFB 90,78
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 71,90
                          DEFB 89,89
                          DEFB 92,92
                          DEFB 71,90
                          DEFB 88,88
                          DEFB 1,87
                          DEFB 71,87
                          DEFB 85,85
                          DEFB 88,88
                          DEFB 71,87
                          DEFB 85,85
                          DEFB 83,83
                          DEFB 66,82
                          DEFB 82,82
                          DEFB 81,81
                          DEFB 66,82
                          DEFB 82,82
                          DEFB 81,81
                          DEFB 66,82
                          DEFB 66,66
                          DEFB 68,68
                          DEFB 70,70
                          DEFB 70,70
                          DEFB 68,68
                          DEFB 92,66
                          DEFB 91,91
                          DEFB 94,94
                          DEFB 66,92
                          DEFB 90,90
                          DEFB 88,88
                          DEFB 66,100
                          DEFB 87,99
                          DEFB 90,102
                          DEFB 66,100
                          DEFB 85,97
                          DEFB 82,94
                          DEFB 71,83
                          DEFB 83,83
                          DEFB 82,82
                          DEFB 71,83
                          DEFB $0
PAT1:
                          DEFB 2  ; Pattern tempo
                          DEFB 83,83
                          DEFB 82,92
                          DEFB 71,90
                          DEFB 71,90
                          DEFB 73,90
                          DEFB 75,68
                          DEFB 75,68
                          DEFB 73,66
                          DEFB 71,90
                          DEFB 1,89
                          DEFB 1,92
                          DEFB 71,90
                          DEFB 1,88
                          DEFB 1,87
                          DEFB 71,87
                          DEFB 1,85
                          DEFB 1,88
                          DEFB 71,87
                          DEFB 1,85
                          DEFB 1,83
                          DEFB 66,82
                          DEFB 1,82
                          DEFB 1,81
                          DEFB 66,82
                          DEFB 1,82
                          DEFB 1,81
                          DEFB 66,82
                          DEFB 66,66
                          DEFB 68,68
                          DEFB 70,70
                          DEFB 70,70
                          DEFB 68,68
                          DEFB 73,85
                          DEFB 1,85
                          DEFB 1,87
                          DEFB 73,89
                          DEFB 1,89
                          DEFB 1,87
                          DEFB 73,85
                          DEFB 1,85
                          DEFB 1,87
                          DEFB 73,89
                          DEFB 1,89
                          DEFB 1,87
                          DEFB 73,85
                          DEFB 1,85
                          DEFB 1,95
                          DEFB 70,94
                          DEFB 1,94
                          DEFB 1,92
                          DEFB 66,90
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 66,90
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 66,78
                          DEFB 1,78
                          DEFB 1,78
                          DEFB 66,82
                          DEFB 1,82
                          DEFB 1,85
                          DEFB 66,92
                          DEFB 1,92
                          DEFB $0
PAT2:
                          DEFB 2  ; Pattern tempo
                          DEFB 1,1
                          DEFB 66,92
                          DEFB 1,92
                          DEFB 1,1
                          DEFB 71,92
                          DEFB 92,92
                          DEFB 92,92
                          DEFB 71,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 71,92
                          DEFB 1,90
                          DEFB 1,90
                          DEFB 71,90
                          DEFB 1,87
                          DEFB 1,90
                          DEFB 73,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 66,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 73,92
                          DEFB 1,90
                          DEFB 1,90
                          DEFB 66,90
                          DEFB 1,87
                          DEFB 1,90
                          DEFB 71,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 71,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 71,92
                          DEFB 1,92
                          DEFB 1,90
                          DEFB 71,87
                          DEFB 1,87
                          DEFB 1,83
                          DEFB 66,78
                          DEFB 1,78
                          DEFB 1,78
                          DEFB 66,82
                          DEFB 1,82
                          DEFB 1,85
                          DEFB 66,92
                          DEFB 1,92
                          DEFB 1,1
                          DEFB 66,92
                          DEFB 1,92
                          DEFB 1,1
                          DEFB 71,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 71,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 71,92
                          DEFB 1,92
                          DEFB 1,90
                          DEFB 71,90
                          DEFB 1,87
                          DEFB 1,90
                          DEFB $0
PAT3:
                          DEFB 2  ; Pattern tempo
                          DEFB 71,95
                          DEFB 1,1
                          DEFB 83,83
                          DEFB 1,83
                          DEFB 1,85
                          DEFB 1,87
                          DEFB 76,88
                          DEFB 1,1
                          DEFB 1,88
                          DEFB 1,88
                          DEFB 1,92
                          DEFB 1,90
                          DEFB 75,87
                          DEFB 1,87
                          DEFB 1,87
                          DEFB 73,85
                          DEFB 1,85
                          DEFB 1,85
                          DEFB 71,83
                          DEFB 1,1
                          DEFB 90,90
                          DEFB 90,90
                          DEFB 89,89
                          DEFB 90,90
                          DEFB 73,92
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 73,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 66,94
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 66,94
                          DEFB 1,94
                          DEFB 1,94
                          DEFB 71,97
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 71,95
                          DEFB 1,95
                          DEFB 1,95
                          DEFB 71,95
                          DEFB 1,1
                          DEFB 1,95
                          DEFB 71,95
                          DEFB 1,94
                          DEFB 1,92
                          DEFB 66,90
                          DEFB 1,90
                          DEFB 1,91
                          DEFB 66,92
                          DEFB 1,92
                          DEFB 1,91
                          DEFB 66,90
                          DEFB 1,1
                          DEFB 1,95
                          DEFB 66,95
                          DEFB 1,94
                          DEFB 1,92
                          DEFB 71,90
                          DEFB 1,90
                          DEFB 1,91
                          DEFB 71,92
                          DEFB $0
PAT4:
                          DEFB 2  ; Pattern tempo
                          DEFB 1,92
                          DEFB 1,91
                          DEFB 71,90
                          DEFB 1,1
                          DEFB 1,90
                          DEFB 71,90
                          DEFB 1,89
                          DEFB 1,90
                          DEFB 73,92
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 73,92
                          DEFB 1,92
                          DEFB 1,92
                          DEFB 66,94
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 66,94
                          DEFB 1,94
                          DEFB 1,94
                          DEFB 71,97
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 71,95
                          DEFB 1,95
                          DEFB 1,95
                          DEFB 71,95
                          DEFB 1,1
                          DEFB 1,95
                          DEFB 71,95
                          DEFB 1,94
                          DEFB 1,95
                          DEFB 106,94
                          DEFB 1,1
                          DEFB 1,94
                          DEFB 1,94
                          DEFB 1,95
                          DEFB 1,96
                          DEFB 85,97
                          DEFB 1,1
                          DEFB 1,97
                          DEFB 1,97
                          DEFB 1,99
                          DEFB 1,101
                          DEFB 78,102
                          DEFB 1,106
                          DEFB 1,104
                          DEFB 78,102
                          DEFB 1,106
                          DEFB 1,104
                          DEFB 78,102
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 78,102
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 78,90
                          DEFB 1,90
                          DEFB 1,90
                          DEFB 78,94
                          DEFB 1,94
                          DEFB 1,97
                          DEFB 78,104
                          DEFB 1,104
                          DEFB $0
PAT5:
                          DEFB 2  ; Pattern tempo
                          DEFB 1,1
                          DEFB 78,104
                          DEFB 1,104
                          DEFB 1,1
                          DEFB 83,104
                          DEFB 1,104
                          DEFB 1,104
                          DEFB 83,104
                          DEFB 1,104
                          DEFB 1,104
                          DEFB 83,104
                          DEFB 1,102
                          DEFB 1,102
                          DEFB 83,102
                          DEFB 1,99
                          DEFB 1,102
                          DEFB 85,104
                          DEFB 1,104
                          DEFB 1,104
                          DEFB 85,104
                          DEFB 1,104
                          DEFB 1,104
                          DEFB 78,104
                          DEFB 1,104
                          DEFB 1,102
                          DEFB 78,102
                          DEFB 1,99
                          DEFB 1,102
                          DEFB 83,104
                          DEFB 1,104
                          DEFB 1,104
                          DEFB 83,104
                          DEFB 1,104
                          DEFB 1,104
                          DEFB 78,104
                          DEFB 1,104
                          DEFB 1,102
                          DEFB 78,99
                          DEFB 1,99
                          DEFB 1,95
                          DEFB 66,90
                          DEFB 1,90
                          DEFB 1,90
                          DEFB 66,94
                          DEFB 1,94
                          DEFB 1,97
                          DEFB 66,104
                          DEFB 1,104
                          DEFB 1,1
                          DEFB 66,104
                          DEFB 1,104
                          DEFB 1,1
                          DEFB 71,104
                          DEFB 1,104
                          DEFB 1,104
                          DEFB 71,104
                          DEFB 1,104
                          DEFB 1,104
                          DEFB 71,104
                          DEFB 1,104
                          DEFB 1,102
                          DEFB 71,102
                          DEFB 1,99
                          DEFB 1,102
                          DEFB $0
PAT6:
                          DEFB 2  ; Pattern tempo
                          DEFB 71,107
                          DEFB 1,1
                          DEFB 107,95
                          DEFB 107,95
                          DEFB 109,97
                          DEFB 111,99
                          DEFB 112,100
                          DEFB 1,1
                          DEFB 100,100
                          DEFB 100,100
                          DEFB 104,104
                          DEFB 102,102
                          DEFB 75,99
                          DEFB 1,99
                          DEFB 1,99
                          DEFB 73,97
                          DEFB 1,97
                          DEFB 1,97
                          DEFB 71,95
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 1,1
                          DEFB 1,1
                          DEFB $0
