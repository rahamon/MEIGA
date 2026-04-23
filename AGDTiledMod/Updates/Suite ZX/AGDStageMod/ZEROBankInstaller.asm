; Inicia Stage Zero en banko ZERo

InitZEROBank
			DEFB $3E        	    ; LD A,n
Iniciadflag defb 0			
			cp 1
			ret z
			ld a,1
			ld (Iniciadflag),a		; ahora si
			
			include "ZEROBank.asm"
			ret

installZEROBank						
			ld a,ZERObank
			;call LoadFromBank		
			call SaveToBank		
			ret						
			; a = banco origen/destino
			; hl = direccion origen			
			; de = destino address			
			; bc = longitud
						



			