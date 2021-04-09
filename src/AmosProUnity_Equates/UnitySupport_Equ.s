; ************************************************************
UpdateLayeredSpriteInCopperList equ 0
; ************************************************************
; Function to use to call the methods.
UnitySupportCallR   MACRO
    movem.l    \2,-(sp)
    move.l     T_UnityVct(a5),\2
    jsr        \1*4(\2)
    movem.l    (sp)+,\2
    ENDM
