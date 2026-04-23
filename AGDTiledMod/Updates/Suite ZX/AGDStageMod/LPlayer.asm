;
;Levelbank	equ 1
;RoomBank	equ 2
;ZERObank	equ 3
		
;Load Stages User Routines
Stageload
		include "StageUser48k.asm"
		
;Install pointers
StageUpdate
		;(Spr Scr Blk Msg Ene Map Obj Eve)
		call UpdateSprites
		call UpdateScreens
		call UpdateBlocks
		call UpdeteMensajes
		call UpdeteSpritespositions
		call UpdeteObjetsRooms
		call UpdeteWolrdMap
		call UpdateEvents

		ret
		
		include "Pointers.asm"

	IF TAPEMODE = 0
Lbank	defb Levelbank
	ENDIF
	
