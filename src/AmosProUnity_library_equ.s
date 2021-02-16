*********************************************************************
*        EQUATES GRAPHIC FUNCTIONS AMOS
*********************************************************************
RwReset        MACRO
Count        SET    0
        ENDM
Rl        MACRO    
Count        SET    Count-4*(\2)
T_\1        equ    Count
        ENDM
Rw        MACRO
Count        SET    Count-2*(\2)
T_\1        equ    Count
        ENDM
Rb        MACRO
Count        SET    Count-(\2)
T_\1        equ    Count
        ENDM
GfxA5        MACRO
        movem.l    d0-d1/a0-a1/a6,-(sp)
        move.l    T_GfxBase(a5),a6
        jsr    \1(a6)
        movem.l    (sp)+,d0-d1/a0-a1/a6
        ENDM

***************************************************************

        RwReset

***************************************************************
*        VECTEURS
***************************************************************
        Rl    SyVect,1
        Rl    EcVect,1
        Rl    WiVect,1
        Rl    AmpLVect,1               ; 2020.12    Added for methods (graphics dependant) extracted from AmosPro.lib
        Rl    ColorSupport,1           ; 2020.12.05 Added for advanced color support (conversions)

***************************************************************
*        ADRESSES AMOS / COMPILER
***************************************************************
        Rl    JError,1
        Rl    CompJmp,1
        Rw    AMOState,1
        Rb    WFlags,1
        Rb    Future,1

***************************************************************
*        Gestions AMOS Multiples
***************************************************************
        Rl    MyTask,1
        Rw    Inhibit,1
        Rw    OldDma,1

***************************************************************
*        FENETRES
***************************************************************
* Jeu de caracteres par defaut
        Rl    JeuDefo,1
* Fonction REPETER
WiRepL        equ    80
        Rw    WiRep,1
        Rl    WiRepAd,2
        Rb    WiRepBuf,WiRepL
* Fonction ENCADRER
        Rw    WiEncDX,1
        Rw    WiEncDY,1


***************************************************************
*        INTER VBL
***************************************************************
        Rl    VblCount,1
        Rl    VblTimer,1
        Rw    EveCpt,1

***************************************************************
*        FLAG AMOS/WORKBENCH
***************************************************************
        Rw    AMOSHere,1
        Rw    NoFlip,1
        Rw    DevHere,1
        Rw    DiscIn,1

***************************************************************
*        GESTION ECRANS
***************************************************************

*************** Variables gestion
EcMax:        equ     12    
        Rw    DefWX,1
        Rw    DefWY,1
        Rw    DefWX2,1
        Rw    DefWY2,1
        Rl    EcCourant,1
        Rw    EcFond,1
        Rw    EcYAct,1
        Rw    EcYMax,1
        Rw    Actualise,1
        Rl    ChipBuf,1

***************    Buffer de calculs des ecrans
        Rw    EcBuf,128

*************** Table des NUMEROS ---> ADRESSES
        Rl    EcAdr,EcMax

*************** Table de priorite
        Rl    EcPri,EcMax+1

*************** FLASHEUR
FlMax:        equ     16    
LFlash:        equ     2+2+4+2+16*4+2
        Rw    NbFlash,1
        Rb    TFlash,LFlash*FlMax

*************** SHIFTER
LShift:        equ     2+2+4+2+2+2
        Rb    TShift,LShift

*************** FADER
        Rw    FadeFlag,1
        Rw    FadeNb,1
        Rw    FadeCpt,1
        Rw    FadeVit,1
        Rl    FadePal,1
        Rl    FadeCop,1
        Rb    FadeCol,8*32

***********************************************************************************************************
*        2020.12.05 AMOS PROFESSIONAL UNITY - SUPPORT FOR COLOR CONVERTION RGB24 / RGB12
***********************************************************************************************************
        Rl    rgbInput,1
        Rl    rgbOutput,1
        Rw    rgb12High,1
        Rw    rgb12Low,1
***************************************************************
*        GESTION COPPER
***************************************************************
EcTCop        equ      1024
        Rl    EcCop,1
        Rw    Cop255,1
        Rl    CopLogic,1
        Rl    CopPhysic,1
        Rw    CopON,1
        Rl    CopPos,1
        Rl    CopLong,1

***************************************************************
*        GESTION RAINBOWS
***************************************************************
NbRain: equ   4
        RsReset
RnDY    rs.w  1
RnFY    rs.w  1
RnTY    rs.w  1
RnBase  rs.w  1
RnColor rs.w  1
RnLong  rs.l  1
RnBuf   rs.l  1
RnAct   rs.w  1
RnX     rs.w  1
RnY     rs.w  1
RnI     rs.w  1
RainLong rs.w  1
        Rb    RainTable,RainLong*NbRain
        Rw    RainBow,1
        Rw    OldRain,1

* Marques copper liste
CopL1:        equ     16*4*2
CopL2:        equ     16*4
CopML:        equ     (EcMax*CopL1)+10*CopL2
        Rb    CopMark,CopML+4

* Liste screen swaps
SwapL:        equ     32
        Rl    SwapList,SwapL*8+4

* Interlaced!
        Rw    InterInter,1
        Rw    InterBit,1
        Rl    InterList,EcMax*2
    
***************************************************************
*        SPRITES HARD
***************************************************************
HsNb        equ     64
* Limites souris
        Rw    MouYMax,1
        Rw    MouXMax,1
        Rw    MouYMin,1
        Rw    MouXMin,1

* Gestion souris
        Rw    MouYOld,1
        Rw    MouXOld,1
        Rw    MouHotY,1
        Rw    MouHotX,1
        Rw    MouseY,1
        Rw    MouseX,1
        Rw    MouseDY,1
        Rw    MouseDX,1
        Rw    YMouse,1
        Rw    XMouse,1
        Rw    OldMk,1

        Rw    MouShow,1
        Rw    MouSpr,1
        Rw    OMouShow,1
        Rw    OMouSpr,1
        Rl    MouBank,1
        Rl    MouDes,1
        Rw    MouTy,1

        Rl    SprBank,1
        Rl    HsTBuf,1
        Rl    HsBuffer,1
        Rl    HsLogic,1
        Rl    HsPhysic,1
        Rl    HsInter,1
        Rl    HsChange,1
        Rl    HsTable,1
        Rw    HsPMax,1
        Rw    HsTCol,1
        Rw    HsNLine,1
        Rl    HsPosition,2*8+1

* Actualisation sprites
HsYAct:        equ     4
HsPAct:        equ     6
        Rw    HsTAct,4*HsNb

* Structure SPrites
HsPrev:        equ     0
HsNext:        equ     2
HsX:        equ     4
HsY:        equ     6
HsYr:        equ     8
HsLien:        equ     10
HsImage:    equ     12
HsControl:    equ     16
HsLong:        equ     20        
        Rb    SpBase,HsLong+4

***************************************************************
*        BOBS
***************************************************************
        Rw    BbMax,1
        Rl    BbDeb,1
        Rl    BbPrio,1
        Rl    BbPrio2,1
        Rl    Priorite,1
        Rw    PriRev,1
*        Rb    TRetour,256

***************************************************************
*        AMAL!
***************************************************************
        Rl    AmDeb,1
        Rl    AmFreeze,1
        Rl    AmChaine,1
        Rl    AmBank,1
        Rw    AmRegs,26
        Rw    SyncOff,1
        Rl    AMALSp,1
        Rw    AmSeed,1

***************************************************************
*        COLLISIONS
***************************************************************
        Rl    TColl,8

***************************************************************
*        BLOCS
***************************************************************
        Rl    AdCBlocs,1
        Rl    AdBlocs,1

***************************************************************
*        SYSTEME
***************************************************************
        Rl    GPile,1
        Rl    IntBase,1
        Rl    ViewPort,1
        Rl    GfxBase,1
        Rl    LayBase,1
        Rl    FntBase,1
        Rl    DefaultFont,1
        Rl    Stopped,1
        Rl    OldName,1
        Rl    WVersion,1
        Rl    RastPort,1
        Rl    Libre3,1        Libre!
        Rl    FontInfos,1
        Rw    FontILong,1
        Rw    PaPeek,1
        Rl    SaveZo,1
        Rw    SaveNZo,1
* Sauvegarde du BitMap
        Rb    Libre4,40        Libre!
* Sauvegarde de la fonte systeme
        Rb    Libre5,14+4        Libre!
* Interrupt VBL
Lis:    equ   $16
Lio:    equ   $30
Lmsg:   equ   $20
        Rb    VBL_Is,Lis
* Interrupt clavier
        Rb    IoDevice,Lio+Lmsg+8
        Rb    Interrupt,Lis
* Buffer clavier
ClLong        equ     32*3
FFkLong        equ     24
        Rl    ClAsc,1
        Rw    ClFlag,1
        Rw    ClQueue,1
        Rw    ClTete,1
        Rb    ClShift,4
        Rb    ClTable,12
        Rb    ClBuffer,ClLong
        Rl    ClLast,1
        Rb    TFF2,10*FFkLong
        Rb    TFF1,10*FFkLong

*************** Memory check
        Rl    MemList,1
        Rl    MemFlush,1

*************** Custom AMIGA-A
        Rb    AmigA_Rien,1
        Rb    AmigA_Shifts,1
        Rb    AmigA_Ascii2,1
        Rb    AmigA_Ascii1,1

*************** Compteur FakeEvent
        Rw    FakeEventCpt,1

*************** Sauvegarde de l''ecran
        Rb    EcSave,64

*************** REQUESTER
        Rl    ScAdr,1
        Rl    Datas,1
        Rl    PrevAuto,1
        Rl    PrevEasy,1

        Rw    Req_Sx,1
        Rw    Req_Sy,1
        Rl    Req_Pos,1
        Rl    Req_Neg,1

        Rl    Req_IDCMP,1
        Rw    ReqFlag,1
        Rw    ReqOld,1
        Rw    DOld,1
        Rw    TxtCx,1
        Rw    TxtMaxCx,1
        Rw    TxtCy,1
        Rw    ReqOldScreen,1
        Rw    Req_On,1

**************** 2021.01.18 Support for UnitySupport.lib
        Rl     UnityVct,1              ; Vectors for UnitySupport.lib methods lists
        Rw     gfxChipsetID,1          ; 0 = ECS/OCS , 1 = AGA, 2 = SAGA
        Rw     audioChipsetID,1        ; 0 = ECS/OCS/AGA, 2 = SAGA


; Previous Amos Pro Aga version color palettes datas :
;*************** Global Aga Palette
PalCnt      equ 8                   ; Define the maximum of Aga color palette that can be created.
        Rw     isAga,1                 ; 2019.11.30 Will be set (<>0) if Aga Chipset is detected
        Rl     ColorPals,PalCnt        ; 2019.12.04 8 registers to store 8 color palettes lists in RGB25 format
        Rl     CMAPColorFile,1         ; 2020.09.17 Added to store (at max) a full IFF/ILBM Color map file.
        Rl     AgaColor1,1             ; 2019.11.24 Saved for AGA Color palette 1 Higher Bits
        Rl     AgaColor2,1             ; 2019.11.24 Saved for AGA Color palette 2 Higher Bits
        Rl     Null1,1
        Rl     AgaColor1L,1            ; 2020.08.13 Saved for AGA Color palette 1 Lower Bits
        Rl     AgaColor2L,1            ; 2020.08.13 Saved for AGA Color palette 2 Lower Bits
        Rl     Null2,1
        Rw     globAgaPal,224          ; 2019.11.16 Adding global AGA Palette colors from 32 to 255
        Rw     Separator,1
        Rw     globAgaPalL,224         ; 2020.08.13 Adding low registers of AGA Palette. Storing 24 bit
        Rw     Separator2,1
        Rb     agaPalLoad,1024         ; 2020.09.17 Load Aga Palette Here
;*************** Global Aga Rainbow systems
agaRainCnt     equ 4                   ; 2020.10.02 Define the maximum of AGA Rainbows that can be created.
        Rl     AgaRainbows,agaRainCnt  ; 2020.10.02 Pointers for the AGA Rainbows buffers


*************** Longueur de la structure W.S
        Rb    L_Trp,4
L_Trappe    equ    -Count
***********************************************************

