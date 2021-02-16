
modeRgb12      equ     $00000000
modeRgb24      equ     $01000000
modeRgb15      equ     $02000000

; ************************************************************
; 2020.12.05 List of methods that can be called from a lib
CSSeparateRGBComponents        equ 0
CSMergeRGBComponents           equ 1
CSForceToRGB24                 equ 2
; ************************************************************
; Function to use to call the methods.

ColSupCallR:   MACRO
    move.l     T_ColorSupport(a5),\2
    jsr        \1*4(\2)
    ENDM

ForceToRGB12   MACRO
    move.l     \1,T_rgbInput(a5)       ; Load Parameter 1 (RGB12/RGB15/RGB24) into rgbInput memory slot
    movem.l    a0,-(sp)                ; Save A0
    ColSupCallR CSSeparateRGBComponents,a0 ; Call method
    movem.l    (sp)+,a0                ; Load A0
    moveq      #0,\2
    move.w     T_rgb12High(a5),\2      ; Load RGB12 High bits into parameter 2
    ENDM

ForceToRGB24:  MACRO
    move.l     \1,T_rgbInput(a5)       ; Send value to rgbInput for conversion
    movem.l    a0,-(sp)                ; Save A0
    ColSupCallR CSForceToRGB24,a0      ; Call method
    move.l     (sp)+,a0                ; Load A0
    move.l     T_rgbOutput(a5),\2      ; Load RGB24 color data into Parameter 3
    ENDM

PushToRGB24:   MACRO
    move.w     \1,T_rgb12High(a5)      ; Push Parameter 1 RGB12 High bits to memory slot
    move.w     \2,T_rgb12Low(a5)       ; Push Parameter 2 RGB12 Low bits to memory slot
    move.l     #modeRgb24,T_rgbOutput(a5) ; Request RGB24 output from RGB12High & RGB12Low color datas
    movem.l    a0,-(sp)                ; Save A0
    ColSupCallR CSMergeRGBComponents,a0 ; Call method
    move.l     (sp)+,a0                ; Load A0
    move.l     T_rgbOutput(a5),\3      ; Load RGB24 color data into Parameter 3
    ENDM

getRGB12Datas  MACRO
    move.l     \1,T_rgbInput(a5)       ; Load Parameter 1 (RGB12/RGB15/RGB24) into rgbInput memory slot
    movem.l    a0,-(sp)                ; Save A0
    ColSupCallR CSSeparateRGBComponents,a0 ; Call method
    movem.l    (sp)+,a0                ; Load A0
    moveq      #0,\2
    moveq      #0,\3
    move.w     T_rgb12High(a5),\2      ; Load RGB12 High bits into parameter 2
    move.w     T_rgb12Low(a5),\3       ; Load RGB12 Low bits into parameter 3
    ENDM

