; http://amiga-dev.wikidot.com/information:hardware

        IFND    EZFlag
EZFlag        set    0
        ENDC
*
Switcher_Signal    equ    24
Except_Signal    equ    26
*
***********************************************************
*
*        AMOSPro EQUATES DEFINITION
*
*        By Francois Lionet
*        AMOS (c) 1990-1992 Europress Software Ltd.
*
*        Last change 23/09/1992
*
***********************************************************
*    This file contains all the equates of the AMOSPro
* programs and extension.
* Be patient, we will soon (I hope) publish informations
* about the functions of the amos.library.
***********************************************************
*     Only for multi-lingual readers: half english
* half french. That''s Europe!
***********************************************************

BFORM_ILBM    equ    %00000001
BFORM_ACBM    equ    %00000010
BFORM_ANIM    equ    %00000100
BCHUNK_BMHD    equ    0
BCHUNK_CAMG    equ    1
BCHUNK_CMAP    equ    2
BCHUNK_CCRT    equ    3
BCHUNK_BODY    equ    4
BCHUNK_AMSC    equ    5
BCHUNK_ABIT    equ    6

EntNul:        equ $80000000

; List of $DFFxxx registers : http://amiga-dev.wikidot.com/information:hardware
Circuits:    equ $dff000

IntReq:        equ $9c
IntEna:        equ $9a
DmaCon:        equ $96
DmaConR:    equ $02

Color00:    equ $180
Color31     equ $1BE                 ; 2019.11.13 Added for AGA Palette copy
VhPosR:        equ $6

; Copper
Cop1lc:        equ $80
Cop2lc:        equ $84
CopJmp1:    equ $88
CopJmp2:    equ $8a

; Souris
CiaAprA:    equ $bfe001
Joy0Dat:    equ $a
Joy1Dat:    equ $c
JoyTest:    equ $36
PotGo:        equ $34
PotGoR:        equ $16
Pot0Dat:    equ $12
Pot1Dat:    equ $14

; Bitplanes
BplCon0:    equ $100
BplCon1:    equ $102
BplCon2:    equ $104
BplCon3:    equ $106 ; // 2019.11.04 Added for Dual Playfield 2nd field color palette shifting + Sprites Res + Color palette
BplCon4:    equ $10C ; // 2021.04.07 Added for AGA Sprites Color Palette Selection.
Bpl1PtH:    equ $0e0
Bpl1PtL:    equ $0e2
Bpl1Mod:    equ $108
Bpl2Mod:    equ $10a
DiwStrt:    equ $08e
DiwStop:    equ $090
DdfStrt:    equ $092
DdfStop:    equ $094
FMode:      equ $1FC

; Blitter
BltSize:    equ $058
BltAdA:     equ $050 ; BLTAPTH
BltAdB:     equ $04c ; BLTBPTH
BltAdC:     equ $048 ; BLTCPTH
BltAdD:     equ $054 ; BLTDPTH
BltModA:    equ $064
BltModB:    equ $062
BltModC:    equ $060
BltModD:    equ $066
BltCon0:    equ $040
BltCon1:    equ $042
BltDatA:    equ $074
BltDatB:    equ $072
BltDatC:    equ $070
BltDatD:    equ $000

; Sprites
Spr0Pos     equ $140
Spr1Pos     equ $148
Spr2Pos     equ $150
Spr3Pos     equ $158
Spr4Pos     equ $160
Spr5Pos     equ $168
Spr6Pos     equ $170
Spr7Pos     equ $178

; From Aga.Guide : The patterns in these two registers are "anded" with the first and last words of each line of data from Source A into the Blitter.
;                  A zero in any bit overrides data from Source A. These registers should be set to all "ones" for fill mode or for line drawing mode
BltMaskG:    equ $044 ; BLTAFWM = Blitter first word mask for source A
BltMaskD:    equ $046 ; BltALWM = Blitter last word mask for source A

;-------------> WFlags
WFlag_AA    equ     0
WFlag_Event    equ    1
WFlag_AmigaA    equ    2
WFlag_WBClosed    equ    3
WFlag_LoadView    equ    4

;-------------> Systeme
        IFND    ExecBase
ExecBase:    equ 4
        ENDC
StartList:    equ 38
Forbid:        equ -132
Permit:        equ -138
OwnBlitter:    equ -30-426
DisOwnBlitter:    equ -30-432
WaitBlit:    equ -228
OpenLib:    equ -552
CloseLib:    equ -414
AllocMem:    equ -198
AvailMem:    equ -216
FreeMem:    equ -210
Chip:        equ $02
Fast:        equ $04
Clear:        equ $10000
Public:        equ $01
Total        equ $80000
SetFunction:    equ -420
CloseWB:    equ -78
FindTask:    equ -294
AddPort:    equ -354
RemPort:    equ -360
OpenDev:    equ -444
CloseDev:    equ -450
DoIO:        equ -456
SendIO:        equ -462

;-------------> Intuition
OpenScreen:    equ -198
CloseScreen:    equ -66
ScreenToBack:    equ -$F6
OpenWindow:    equ -204
CloseWindow:    equ -72
LoadView:    equ -$DE
CUFLayer:    equ -36
DelLayer:    equ -90

;-------------> Graphic library
InitRastPort:    equ -198
InitTmpRas:    equ -$1d4
TextLength:    equ -54
Text:        equ -60
SetFont:    equ -66
OpenFont:    equ -72
CloseFont:    equ -78
AskSoftStyle:    equ -84
SetSoftStyle:    equ -90
RMove:        equ -240
RDraw:        equ -246
DrawEllipse:    equ -$b4
AreaEllipse:    equ -$ba
AreaMove:    equ -252
AreaDraw:    equ -258
AreaEnd:    equ -264
InitArea:    equ -282
RectFill:    equ -306
ReadPixel:    equ -318
WritePixel:    equ -324
Flood:        equ -330
PolyDraw:    equ -336
ScrollRaster:    equ -396
AskFont:    equ -474
AddFont:    equ -480
RemFont:    equ -486
ClipBlit:    equ -552
BltBitMap:    equ -30
SetAPen:    equ -342
SetBPen:    equ -348
SetDrMd:    equ -354
AvailFonts:    equ -$24
OpenDiskFont    equ -$1e

;-------------> Dos
Input:        equ -54
WaitChar:    equ -204
Read:        equ -42

Execall:    MACRO
        move.l    $4.w,a6
        jsr    \1(a6)
        ENDM
GfxCa5        MACRO
        movem.l    d0/d1/a0/a1/a6,-(sp)
        move.l    T_GfxBase(a5),a6
        jsr    \1(a6)
        movem.l    (sp)+,d0/d1/a0/a1/a6
        ENDM

*************** COPIE
CoCopy        MACRO
.Loop\@        move.b    (a0)+,(a1)+
        bne.s    .Loop\@
        ENDM
*************** DOS
DosCall MACRO
        move.l    a6,-(sp)
        move.l    DosBase(a5),a6
        jsr       \1(a6)
        move.l    (sp)+,a6
        ENDM
DosOpen:    equ -30
DosClose:    equ -36
DosRead:    equ -42
DosWrite:    equ -48
DosSeek:    equ -66
DosDel:        equ -72
DosRen:        equ -78
DosLock:    equ -84
DosUnLock:    equ -90
DosDupLock:    equ -96
DosExam:    equ -102
DosExNext:    equ -108
Dosinfo:    equ -114
DosMkDir:    equ -120
DosCuDir:    equ -126
DosIOErr:    equ -132
DosDProc:    equ -174
DosParent:    equ -210
DosLoadSeg:    equ -150
DosULoadSeg:    equ -156
DosWChar:    equ -204

*************** FLOAT
SPFix:        equ -30
SPFlt:        equ -36
SPCmp:        equ -42
SPTst:        equ -48
SPAbs:        equ -54
SPNeg:        equ -60
SPAdd:        equ -66
SPSub:        equ -72
SPMul:        equ -78
SPDiv:        equ -84
SPFloor:    equ -90
SPCeil:        equ -96

SPATan:        equ -30
SPSin:        equ -36
SPCos:        equ -42
SPTan:        equ -48
SPSinCos:    equ -54
SPSinH:        equ -60
SPCosH:        equ -66
SPTanH:        equ -72
SPExp:        equ -78
SPLog:        equ -84
SPPow:        equ -90
SPSqrt:        equ -96
SPTIeee:    equ -102
SPFIeee:    equ -108
SPASin:        equ -114
SPACos:        equ -120
SPLog10:    equ -126

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_System.s"

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Bobs.s"

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Screens.s"

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Windows.s"

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Basic.s"

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_MenuDefine.s"

* Flags
MnFlat:        equ     0
MnFixed:    equ     1
MnSep:        equ     2
MnBar:        equ     3
MnOff:        equ     4
MnTotal:    equ     5
MnTBouge:    equ     6
MnBouge:    equ     7

*************** Test control bits 
BitControl:    equ     8
BitMenu:    equ     9
BitJump:    equ     10
BitEvery:    equ     11
BitEcrans:    equ     12
BitBobs:    equ     13
BitSprites:    equ     14
BitVBL:        equ     15

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Sliders.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_ButtonDefine.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_PackUPack.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_EditorLine.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Dialogs.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Heading.s"


;        Longueur maxi d''une chaine
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
String_Max    equ    $FFC0

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_InterpreterDataZone.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_RunTimeVariables.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_InterpreterConfigDatas.s"


; Ici et pas ailleurs!
; ~~~~~~~~~~~~~~~~~~~~
ValPi:        rs.l     2
Val180:        rs.l     2
Equ_Base    rs.l    1

; __________________________
;
;         Mode Escape
; __________________________
;
Esc_TFonc    rs.l     1
Esc_Buf        rs.l     1        
Esc_KMem    rs.l    1
Esc_KMemPos    rs.l    1
Direct        rs.w     1
DirFlag        rs.w     1
EsFlag        rs.w     1
Es_LEd        rs.b    LEd_Size

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Editor.s"


********************************* Total data length
DataLong:    equ __RS

;    Flags banques
; ~~~~~~~~~~~~~~~~~~~
Bnk_BitData      equ    0        Banque de data
Bnk_BitChip      equ    1        Banque en chip
Bnk_BitBob       equ    2        Banque de Bobs
Bnk_BitIcon      equ    3        Banque d''icons
Bnk_BitReserved0 equ    4        2021.03.01 Bits for Newer Banks DataTypes
Bnk_BitReserved1 equ    5        2021.03.06 Bits for Newer Banks DataTypes
Bnk_BitReserved2 equ    6        2021.03.10 Bits for Newer Banks DataTypes
Bnk_BitReserved3 equ    7        2021.03.10 Bits for newer Banks DataTypes
Bnk_BitReserved4 equ    8        2021.03.10 Bits for newer Banks DataTypes
Bnk_BitReserved5 equ    9        2021.03.10 Bits for newer Banks DataTypes

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_ProgramDefine.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_EditingDefine.s"

;                        Flags de la ligne d''etat
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EtA_Caps    equ    0
EtA_Ins        equ    1
EtA_X        equ    2
EtA_Y        equ    3
EtA_Nom        equ    4
EtA_Free    equ    5
EtA_Clw        equ    6
EtA_Alert    equ    7
EtA_BXY        equ    %00001100
EtA_BAll    equ    %01111111

;            AREXX
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
RC_OK            equ    0
RC_WARN            equ    5
RC_ERROR        equ    10
RC_FATAL        equ    20
RXCODEMASK        equ     $FF000000
RXCOMM            equ    $01000000
RXFUNC            equ    $02000000
RXFF_RESULT        equ    $00020000
ra_Length        equ    4
ra_Buff            equ    8
rm_Result1        equ    $20
rm_Result2        equ    $24
rm_Sdtin        equ    $74
rm_Sdout        equ    $78
rm_Args            equ    $28
rm_Action        equ    $1c

    include "src/AmosProUnity_Equates/AmosProUnity_Equ_SpecialTokens.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_FileSelectorSpecial.s"
    include "src/AmosProUnity_Equates/AmosProUnity_Equ_Libraries.s"


;         For internal branch from AMOSPro to library (where A4= AdTokens)
;        Or Library to internal AMOSPro: changed to BSR under compiled!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ijsr        MACRO
        IFEQ    NARG=1
        FAIL
        ENDC
        IFD    Lib_Includes
        FAIL
        ENDC
        move.l    -LB_Size-4-\1*4(a4),a0
        jsr    (a0)    
        ENDM
Ijmp        MACRO
        IFEQ    NARG=1
        FAIL
        ENDC
        IFD    Lib_Includes
        FAIL
        ENDC
        move.l    -LB_Size-4-\1*4(a4),a0
        jmp    (a0)    
        ENDM
IjsrR        MACRO
        IFEQ    NARG=2
        FAIL
        ENDC
        IFD    Lib_Includes
        FAIL
        ENDC
        move.l    -LB_Size-4-\1*4(a4),\2
        jsr    (\2)
        ENDM
IjmpR        MACRO
        IFEQ    NARG=2
        FAIL
        ENDC
        IFD    Lib_Includes
        FAIL
        ENDC
        move.l    -LB_Size-4-\1*4(a4),\2
        jmp    (\2)
        ENDM
    
Pair        MACRO
        addq.l    #1,\1
        and.w    #$FFFE,\1
        ENDM
IDia_Errors    equ    120-1

;        Taille des boucles
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TForNxt    equ     24        24 octets pour une FOR/NEXT
TRptUnt    equ     10
TWhlWnd    equ     10
TDoLoop    equ     10

;        Token table flags
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
L_Nul        equ    1 
L_NoFlag    equ    %1000000000000000
L_Entier    equ    %0000000000000000
L_FFloat    equ    %0001000000000000
L_FAngle    equ    %0010000000000000
L_FMath        equ    %0011000000000000
L_VRes        equ    %0100000000000000

