*************** AMOS Screen library

BitHide:       equ 7
BitClone:      equ 6
BitDble:       equ 5


*********************************************** Structure ECRAN
        RsReset
* Bitmap address
EcLogic:       rs.l 8                  ; Define the non displayed bitmaps of the screen (double buffer) or a copy of EcPhysic (single buffer)
EcPhysic       rs.l 8                  ; Define the visible bitmaps of the screen
EcCurrent:     rs.l 8                  ; Define the current bitmaps of the screen

* Datas!
EcNPlan:       rs.w 1                  ; Define the amount of bitplanes available in the Screen 
AGAPMode:      rs.l 1                  ; Must contains "AGAP"
EcNbCol        rs.w 1
EcPal          rs.w 32                 ;            Define the screen color palette
EcScreenAGAPal rs.w 224                ;            Define the start of AGA color indexes 32-255 High Bits
EcPalSeparator rs.w 1                  ; Separateur.
EcPalL         rs.w 32                 ; 2020.08.13 Define the lower bits for RGB24 bits colors color palette 000-031
EcScreenAGAPalL rs.w 224               ; 2020.08.13 Define the start of AGA color indexes 32-255 Low bits
EcPalSepL      rs.w 1                  ; Separateur.
EcColorMap     rs.w 1
EcDEcran:      rs.l 1        * 

EcTPlan:    rs.l 1        * 
EcWindow:    rs.l 1        * 
EcTxM:        rs.w 1        * 
EcTyM:        rs.w 1        * 
EcTLigne:    rs.w 1        * 
EcFlags:    rs.w 1        * 
EcDual:        rs.w 1        * 
EcWXr:        rs.w 1        * 
EcWTxr:        rs.w 1        * 
EcNumber:    rs.w 1        * 
EcAuto:        rs.w 1        * 

* Link with AMAL
EcAW:        rs.w 1
EcAWX:        rs.w 1      ; Define the X coordinate of the Screen in the current copper list display
EcAWY:        rs.w 1      ; Define the Y coordinate of the Screen in the current copper list display
EcAWT:        rs.w 1      ; Define the 'Width' in pixels, ot the screen view in the current copper list display
EcAWTX:        rs.w 1     ; Define the 'Height' in pixels, ot the screen view in the current copper list display
EcAWTY:        rs.w 1
EcAV:        rs.w 1       ; Bit #1 -> Force refresh screen X offset /  Bit #2 -> Force refresh screen Y offset
EcAVX:        rs.w 1      ; Define X Screen offset (in pixels) from the Left coordinate on X axis
EcAVY:        rs.w 1      ; Define Y screen offset (in pixels) from the top coordinate on Y axis
* Zone table
EcAZones:    rs.l 1
EcNZones:    rs.w 1
* Save the background for window
EcWiDec:    rs.w 1
* Graphic functions
EcInkA:        rs.b 1
EcInkB:        rs.b 1
EcMode:        rs.b 1
EcOutL:        rs.b 1
EcLine:        rs.w 1
EcCont:        rs.w 1
EcX:        rs.w 1
EcY:        rs.w 1
EcPat:        rs.l 1
EcPatL:        rs.w 1
EcPatY:        rs.w 1
EcClipX0:    rs.w 1
EcClipY0:    rs.w 1
EcClipX1:    rs.w 1
EcClipY1:    rs.w 1
EcFontFlag:    rs.w 1
EcText:        rs.b 14 
EcFInkA:    rs.b 1
EcFInkB:    rs.b 1
EcFInkC:    rs.b 1
EcIInkA:    rs.b 1
EcIInkB:    rs.b 1
EcIInkC:    rs.b 1
EcFPat:        rs.w 1
EcIPat:        rs.w 1
* Cursor saving
EcCurS:        rs.b 8*8 ; Default was 8*6 ...

;        Donnees ecran intuition
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ec_LayerInfo    rs.l    1
Ec_Layer    rs.l    1
Ec_RastPort    rs.l    1
Ec_Region    rs.l    1
Ec_BitMap    rs.l    1

; 2019.11.13 Moved data at the end to check if some datas may cause issue
EcCon0:        rs.w 1        ; Define BplCon0 for this screen
EcCon2:        rs.w 1        ; Define BplCon2 for this screen
EcTx:        rs.w 1        ; Define screen Width in pixels
EcTy:        rs.w 1        ; Define screen Height in pixels.
EcWx:        rs.w 1        * 
EcWy:        rs.w 1        * 
EcWTx:        rs.w 1        * 
EcWTy:        rs.w 1        * 
EcVX:        rs.w 1        * 
EcVY:        rs.w 1        * 

; 2019.11.05 Added support for DualPlayfield 2x16colors
EcCon3:        rs.w 1                  ; BplCon3 for Dual Playfield color shifting
dpf2cshift:    rs.w 1                  ; Value used for the Color shifting of 2nd DPF screen.
EcFMode        rs.w 1                  ; Value for the FetchMode defined for the screen display.
EcOriginalBPL  rs.l 8                  ; 2019.11.18 Original Bitplanes Memory Allocation
EcDBOriginalBPL rs.l 8                 ; 2019.11.18 Original Bitplanes Memory Allocation for double buffer
Ham8Mode       rs.w 1                  ; 2020.07.31 Flag to check if current screen uses HAM8 mode
EcH8Logic:     rs.l 8                  ; Define the non displayed bitmaps for IFF/ILBM operations, support HAM8 Mode.
True64Color    rs.b 1                  ; 2021.03.16 To allow tru 64 colors
SpritesFX      rs.b 1                  ; 2021.04.08 If set, then use sprite 0 as Background Layer
SpritesFXDatas rs.w 8                  ; 2021.05.10 Datas for SpritesFX

sprFX_Spr0     equ  0
sprFX_YStart   equ  2
sprFX_Height   equ  4

; Length of a screen
EcLong        equ __RS

; Y Screen base
EcYBase:    equ $1000
EcYStrt:    equ EcYBase+26
PalMax:     equ 16

***********************************************************
*        FUNCTIONS
***********************************************************

Raz:        equ 0
CopMake:    equ 1
*        equ 2
Cree:        equ 3
Del:        equ 4
First:        equ 5
Last:        equ 6
Active:        equ 7
CopForce:    equ 8
AView:        equ 9
OffSet:        equ 10
Visible:    equ 11
DelAll:        equ 12
GCol:        equ 13
SCol:        equ 14
SPal:        equ 15
SColB:        equ 16
FlRaz:        equ 17
Flash:        equ 18
ShRaz:        equ 19
Shift:        equ 20
EHide:        equ 21
CBlGet:        equ 22
CBlPut:        equ 23
CBlDel:        equ 24
CBlRaz:        equ 25
Libre:        equ 26
CCloEc:        equ 27
Current:    equ 28
Double:        equ 29
SwapSc:        equ 30
SwapScS:    equ 31
AdrEc:        equ 32
SetDual:    equ 33
PriDual:    equ 34
ClsEc:        equ 35
Pattern:    equ 36
GFonts:        equ 37
FFonts:        equ 38
GFont:        equ 39
SFont:        equ 40
SetClip:    equ 41
BlGet:        equ 42
BlDel:        equ 43
BlRaz:        equ 44
BlPut:        equ 45
VerSli:        equ 46
HorSli:        equ 47
SetSli:        equ 48
MnStart:    equ 49
MnStop:        equ 50
RainDel:    equ 51
RainSet:    equ 52
RainDo:        equ 53
RainHide:    equ 54
RainVar:    equ 55
FadeOn:        equ 56
FadeOf:        equ 57
CopOnOff:    equ 58
CopReset:    equ 59
CopSwap:    equ 60
CopWait:    equ 61
CopMove:    equ 62
CopMoveL:    equ 63
CopBase:    equ 64
AutoBack1:    equ 65
AutoBack2:    equ 66
AutoBack3:    equ 67
AutoBack4:    equ 68
SuPaint:    equ 69
BlRev:        equ 70
DoRev:        equ 71
AMOS_WB        equ 72
ScCpyW        equ 73
MaxRaw        equ 74
NTSC        equ 75
PourSli        equ 76
GetEc          equ 77       ; 2021.03.10 Restored for PersonalUnity.lib
GetCurrentScreen equ 78

EcCall:        MACRO
        move.l    T_EcVect(a5),a0
        jsr    \1*4(a0)
        ENDM

; **************** 2020.10.12 Added EcCallA1
EcCallA1:      MACRO
        move.l    T_EcVect(a5),a1
        jsr    \1*4(a1)
        ENDM
; **************** 2020.10.12 Added EcCallA1

EcCalA:        MACRO
        lea    \2,a1
        move.l    T_EcVect(a5),a0
        jsr    \1*4(a0)
        ENDM
EcCalD:        MACRO
        moveq    #\2,d1
        move.l    T_EcVect(a5),a0
        jsr    \1*4(a0)
        ENDM
EcCal2:        MACRO
        moveq    #\2,d1
        move.l    #\3,a1
        move.l    T_EcVect(a5),a0
        jsr    \1*4(a0)
        ENDM
