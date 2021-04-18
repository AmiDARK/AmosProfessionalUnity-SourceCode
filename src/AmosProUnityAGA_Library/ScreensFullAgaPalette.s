
D_BplCon3      Equ 0                   ; $0000 - Original $106
D_Color00      Equ 122                 ; $007A - Original $180 
D_Color31      Equ 262                 ; $0106 - Original $1BE

; D_MemSize = Memory Required for the whole color palette in a format compatible to direct blitting in registers
D_MemSize      equ D_Color31*14        ; 7 Colors palette ( 32-63, 64-95, 96-127, 128-159, 160-191, 192-223, 224-225 ) * 2 (High & Low Bits) = Source 1
D_Filter       equ D_Color31*1         ; Block for the color palette filter ( to not write registers between BplCon3 & ) = Source 2
