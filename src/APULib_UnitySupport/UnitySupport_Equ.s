; ***************************** agaSupport.lib call
AgaLibCallsr MACRO
    move.l     T_AgaVect(a5),\2    ; This pointer is populated when the AgaSupport.lib is started
    jsr        \1*4(\2)
            ENDM

AgaLibCall   MACRO
    AgaLibCallsr \1,a2
            ENDM

AgaLibCallA0 MACRO
    AgaLibCallsr \1,a0
            ENDM

AgaLibSecureSR MACRO
    move.l     T_AgaVect(a5),\2    ; This pointer is populated when the AgaSupport.lib is started
    cmp.l      #0,a2               ; was the Plugin initialized ?
    beq.s      .er\@               ; No -> Jump .erXX
    add.l      \1*4,\2             ; Point to the chosen method to call 
    tst.l     (\2)                 ; is the method defined ?
    beq.s      .er\@               ; No -> Jump .erXX
    jsr        (\2)                ; Yes -> Jsr chosen Method.
.er\@:
            ENDM

AgaLibSecure   MACRO
    AgaLibSecureSR \1,a2
            ENDM

AgaLibSecureA0 MACRO
    AgaLibSecureSR \1,a0
            ENDM

AgaLibNotInitialized MACRO
    tst.l     T_AgaVect(a5)
    beq       \1
            ENDM

; ***************************** agaSupport.lib call

agaFade:                  equ  0
agaFadeToPalette:         equ  1
agaHam8BPLS               equ  2
EcSPalAGA_ScreenA4        equ  3 ; Force full AGA Palette from Screen structure in A4
EcSPalAGA_CurrentScreen   equ  4 ; Force full AGA Palette from current Screen
EcSPalAGA_ScreenA0        equ  5 ; Force full AGA Palette from Screen structure in A0
EcSColAga24Bits           equ  6 : Set 24 Bits Aga Color
EcUpdateAGAColorsInCopper equ  7 ; Update the whole AGA Color palette (push to copper list)
getRGB12AgaColor          equ  8 ; Get RGB12 AGA color palette 032-255
UpdateAGAColorsInCopper   equ  9 ; Push AGA Color palette 032-255 inside the 2 Copper lists Logic/Physic
InsertSpritesInCopperList equ 10 ; Amos.library HsCop

ZsReset    MACRO
zCount         SET    0
           ENDM
Zl         MACRO    
zCount         SET    zCount-4*(\2)
R_\1           equ    zCount
           ENDM
Zw         MACRO
zCount         SET    zCount-2*(\2)
R_\1           equ    zCount
           ENDM
Zb         MACRO
zCount         SET    zCount-(\2)
R_\1           equ    zCount
           ENDM

; ***************************** AGA Rainbows structure definition.
    ZsReset
    Zl       AMRBHeader,1              ; "AMRB" header
    Zl       bufferSize,1              ; BufferSize
    Zb       IsActive,1                ; = 1 if Rainbow is active; otherwise = 0
    Zb       empty,1                   ; For word alignment values
    Zw       rainColor,1               ; ID Of the color where the rainbow must be applied (from 0 to 255)
    Zw       rainHeight,1              ; The height in pixels of the rainbow
    Zw       rainYPos,1                ; Y Position of the Rainbow
    Zw       rainYShift,1              ; Y Shifting of the rainbow
    Zl       rainData,1                ; RGB datas for the rainbow
rainMinStructSize equ zCount
