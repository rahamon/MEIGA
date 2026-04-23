SwapS0				; TestJoda					
		ld hl,ScrBuffer	+ 0						
		ld (PackedImgpointer),hl						
		ld hl,ScrBuffer	+ 0 - 17	
		ld (Palettepoiter),hl						
		ld a,Screenbank		; Banco Origen						
		call showSplash						
		ret						
						
