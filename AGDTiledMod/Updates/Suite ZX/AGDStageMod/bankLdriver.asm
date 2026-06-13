; Installer BankL
; Cargador en banco para proposito general

			org 24832
			
STAGES	 	equ 49152
Levelbank	equ 7
RoomBank	equ 1
BlockBank	equ 3


			; Level Data sections sizes
			; include "SECsizes.asm"
			; include "SECsizesZ.asm"

			jp InstallBankL

InstallBankL: 	
			;ld a,16					; for Divmmc
			;ld (23388),a 
			;push iy
			;di
			
			;include "LoadWorldData.asm"
			
			; bank 7			
			;defb 06					;ld b,Levelbank
			;defb Levelbank
			;call bankb	
			
			; descomprime y carga Niveles de Secciones de Datos in Bank7
			di 	
			include "SECdepack.asm"

			;call bank0

exit:
			;pop iy					; for Divmmc
			
			ei
			ret 
			; rutinas para mover memoria entre bloques del modelo 128k
			; rutinas para cambiar de páginado de bloques
			include	"routines.asm"
			; des-compresor
			include	"zx7.asm"
Datos:
			include "SECtions.asm"
			;defs 4,0
			
			
			
