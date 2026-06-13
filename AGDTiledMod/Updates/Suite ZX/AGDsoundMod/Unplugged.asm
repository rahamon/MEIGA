; ContainerMod by Ramon Fernandez Ameijeiras
; Ahorro de 1188 bytes EngineZX

; Bancos
; Experimental
MEMOSCHEMA		equ 0
CASSETTEMODEL	equ 0
;----0----,----1----,----2!---,----3----,----4----,----5----,----6!---,----7----,
; sistema ,Levelbank, sistema ,ZERObank ,musica FX,   ---   , screens ,RoomBank ,	MODO BASICO, Sin shadowSCR
; sistema ,Levelbank, sistema ,ZERObank ,musica FX,ULAbuffer, RoomBank,shadowSCR,	MODO shadowSCR A, No usar RAMscreens
; sistema ,Levelbank, ZERObank, RoomBank,musica FX,ULAbuffer, BlockBank,shadowSCR,	MODO shadowSCR B, No usar ZERObank, tampoco RAMscreens

; Variables CONTENEDORES
SOUNDFX			equ 0		; 162 bytes
INVENTARY		equ 1		; 441 bytes
SPECIALISTS		equ 1		; 747 bytes
ULAPLUS			equ 0		; enable on/off
INFRONT			equ 0		; Waterblock inFront
SCROLL			equ 0		; scroll on/off necesita ULABUFFER y MASKAGD modificado
ULABUFFER 		equ 0		; debe ser 1 si scroll = 1 para evitar parpadeos
MASKAGD			equ 1		; Masck, opcion 2 es estable
