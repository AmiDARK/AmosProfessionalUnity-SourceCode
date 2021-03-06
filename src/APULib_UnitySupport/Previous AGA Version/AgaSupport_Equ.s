; ***************************** agaSupport.lib call
AgaLibCall: MACRO
    move.l     T_AgaVect(a5),a0    ; This pointer is populated when the AgaSupport.lib is started
    jsr        \1*4(a0)
            ENDM
; ***************************** agaSupport.lib call

agaFade:               equ 0
agaFadeToPalette:      equ 1
