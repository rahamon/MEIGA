; Objects
UpdeteObjetsRooms
			IF TAPEMODE = 1
				ld bc,0
			ELSE
				ld bc,ObjDataCode
			
				; ld hl,Lbank
				; ld a,ZERObank
				; cp (hl)				; estamos mirando al banco ZERO?
				; jp nz,UpdateLevelBankformatObjects
				; ld bc,0				; si. No ajustes valores
			ENDIF
			
UpdateLevelBankformatObjects			
	; Objects
		; Variables
			; NUMOBJ
				ld a,(ObjDataCode + 2)
				ld (numob),a
		; Adress pointers
			; objdta
				ld hl,(ObjDataCode + 4)
				add hl,bc
				ld (ObjDataCode + 4),hl
				ld (iniob+2),hl
				ld (shwob+1),hl
				ld (findob+1),hl
				ld (skobj+1),hl
				
				ret
			