; Notas: variables temporales candidatas:
; Cursor: chary, charx
; Comandos: varrnd, varobj, varopt
;
; Indices de las rutinas plugin [user]: 100+n
; Indices de las rutinas de usuario [user0]: n

PluginUserSelector
user
; Seleccion de Plugin
	; Search Sprite program
		cp 100
		jp z,sksprparam
		cp 101
		jp z,PRINTinFRONTadventureMOD

; fin Seleccion	
		jp user0

; Rutinas Plugin
	; Search Sprite program
	; Search for OTHER sprite with the same parameter (var RND) than mine
	; Por ejemplo: para buscar OTHER sprite con parametro SETTINGA (ix+11) igual al mio hacemos LET RND = 11: USER 100
	; Encuentra OTHER sprite y devuelve RND = 1 si tiene exito.
	;
	;
		include "sksprparam.asm"
		
	; Tiles in front program
PRINTinFRONTadventureMOD
	; le pasamos el parametro por varrnd
		include "PRINTinFRONTadventureMOD.asm"

; Para hacer: definir comandos.json para cada rutina plUgin

