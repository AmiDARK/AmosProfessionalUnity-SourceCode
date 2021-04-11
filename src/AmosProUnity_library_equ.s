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
        Rl    ErrorVectCall,1          ; 2021.02.22 To call RJmp L_Error from everywhere in AMOS Professional Unity.
**************** 2021.01.18 Support for UnitySupport.lib
        Rl    UnityVct,1               ; Vectors for UnitySupport.lib methods lists

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
EcMax:  equ   12    
        Rw    DefWX,1
        Rw    DefWY,1
        Rw    DefWX2,1
        Rw    DefWY2,1
        Rl    EcCourant,1
        Rl    cScreen,1                ; 2020.08.11 Used for the Bitmap update
        Rw    EcFond,1
        Rw    EcYAct,1
        Rw    EcYMax,1
        Rw    Actualise,1
        Rl    ChipBuf,1
        Rw    Save64c,1

***************    Buffer de calculs des ecrans
        Rw    EcBuf,128

*************** Table des NUMEROS ---> ADRESSES
        Rl    EcAdr,EcMax

*************** Table de priorite
        Rl    EcPri,EcMax+1                 ; Screen priorities list.

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
        Rw    FadeVit,1                ; The speed which is used to fade the color palette
        Rl    FadePal,1                ; Source palette from where colors are taken to calculate the Colors fading effect
        Rl    FadeCop,1                ; Where does the screen color palette is located in the Copper list. Pointer to : T_CopMark + ( ScreenNumber * 128 )
        Rb    FadeCol,8*256            ; 2020.09.15 Updated from 8 * 32 to 8 * 256 ; Use 8 bytes per color .w = Color Index ; .b RedSource,RedTarget,GreenSource,GreenTarget,BlueSource,BlueTarget
        Rw    SeparatorFadeCol,1       ; 2020.09.16 Separator added to mark the end of color list with a #$$$$
        Rw    isFadeAGA,1              ; 2020.09.16 Added to separate the call from the original commands to new commands handling 256 RGB24 colors.
        Rl    FadeScreen,1             ; 2020.09.06 Added to memorize the screen pointer for better convenience
        Rl    CurScreen,1              ; 2020.09.16 Added to optimise color palette updates
        Rw    FadeStep,1               ; 2020.09.16 Added to create faste fade color system.
        Rl    NewPalette,1             ; 2020.09.29 Added for fading to specific AGA color palette

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
        Rl    EcCop,1             ; Screens for copper list.
        Rw    Cop255,1
        Rl    CopLogic,1
        Rl    CopPhysic,1
        Rw    CopON,1             ; data to handle enabling/disabling AMOS auto copper list support
        Rl    CopPos,1
        Rl    CopLong,1
        Rl    EcStartEdit,1            ; 2020.10.13 Added for auto-calculation of the position to populate Copper Lists
        Rl    CopLogicTrue,1
        Rl    CopPhysicTrue,1
        Rl    lastScreenAdded,1        ; 2021.04.08 Added to handle Layered/Playfield Sprites
        Rw    lastYLinePosition,1      ; 2021.04.08 Last Y line copper position called by WaitD2
        Rl    YTest,1

***************************************************************
*        GESTION RAINBOWS
***************************************************************
NbRain        equ    4
        RsReset
RnDY        rs.w    1
RnFY        rs.w    1
RnTY        rs.w    1
RnBase        rs.w    1
RnColor        rs.w    1
RnLong        rs.w    1
RnBuf        rs.l    1
RnAct        rs.w    1
RnX        rs.w    1
RnY        rs.w    1
RnI        rs.w    1
RainLong    rs.w    1
        Rb    RainTable,RainLong*NbRain
        Rw    RainBow,1
        Rw    OldRain,1

***************************************************************
* Marques copper liste
CopL1   equ    16*4*2                  ; CopL1 = 128
CopL2   equ    16*4                    ; CopL2 = 64
CopML   equ    (EcMax*CopL1)+10*CopL2  ; (12*128)+10*64 = 2176
        Rb     CopMark,CopML+4         ; T_CopMark = Count 2176


; Method AmosProAGA_Library/Screen.s/ScSwap stores screen to swap in the SwapList
SwapL        equ     32+4+4            ; 2020.09.11 Updated to handle BPLCount(1x.w)+Bitplanes(8x.l)=34

        Rl    SwapList,SwapL*8+4       ; SwapList Allow 8 Screen to swap at one ( + 4 long )

* Interlaced!
        Rw    InterInter,1
        Rw    InterBit,1
        Rl    InterList,EcMax*2

        Rl    CopEditStartShift,1        
    
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

        Rl    SprBank,1            ; Amos Bank containing sprites
        Rl    HsTBuf,1
        Rl    HsBuffer,1           ; Buffer containing all sprites data used to being displayed (3 buffers in)
        Rl    HsLogic,1            ; Buffer containing all sprites Logic (non displayed)
        Rl    HsPhysic,1           ; Buffer containing all sprites Physic (to be displayed)
        Rl    HsInter,1            ; Buffer containing all sprites (intermediate ?)
        Rl    HsChange,1           ; HsSBuf makes it point to T_CopLong(a5)-4 (last copper line with $FFFFFFFE updated to $00000000)
        Rl    HsTable,1            ; Hardware Sprites table (Pointer)
        Rw    HsPMax,1             ; Sprite buffer size -2 (=Last position offset in each buffer)
        Rw    HsTCol,1             ; 1 Sprite data buffer size.
        Rw    HsNLine,1
        Rl    HsPosition,2*8+1     ; Sprites Pointers inside HsLogic copper
        Rw    AgaSprWidth,1        ; 2021.03.25 Aga Sprites Width 0 = 16 pixels, 1 = 32 Pixels, 2 = 64 Pixels.
        Rw    AgaSprWordsWidth,1   ; 2021.03.30 Aga Sprites Words width (for faster calculations in sprites rendering)
        Rw    AgaSprBytesWidth,1   ; 2021.03.30 Aga Sprites Bytes width (for faster calculations in sprites rendering)
        Rw    AgaSprResol,1        ; 2021.03.30 AGA Sprites Resolutions.
        Rl    HsTableLen,1         ; 2021.04.01 Save the bytes len of the HsTable for releasing it without recalculating size
        Rl    SprAttach,1          ; 2021.04.02 Sprites attachment for AGA chipset
        Rw    RefreshForce,1       ; 2021.04.02 Force refresh of sprite buffer when changing the Sprite Width
        Rw    AgaSprColorPal,1     ; 2021.04.03 Define which color palette will be used for sprites.

; ******** 2021.03.31 Bits set for FMODE AGA Sprites Width - START
aga16pixSprites equ    0
aga32pixSprites equ    1
aga64pixSprites equ    3
; ******** 2021.03.31 Bits set for FMODE AGA Sprites Width - END

; ******** 2021.04.07 Relative adress of sprites data inside the copper lists, from start - START
CopSprFMODE     equ    4
CopSprPAL       equ    8
CopSprSTART     equ   12
; ******** 2021.04.07 Relative adress of sprites data inside the copper lists, from start - END


* Actualisation sprites
HsXAct:        equ     2
HsYAct:        equ     4
HsPAct:        equ     6
HsActSize:     equ     8
        Rw    HsTAct,4*HsNb        ; HsTAct = 4*2(Rw=.w)*HsNb(64) = 512

* Structure SPrites
HsPrev:        equ     0           ; Previous Sprite in the list
HsNext:        equ     2           ; Next Sprite in the list
HsX:           equ     4           ; Sprite X Pos
HsY:           equ     6           ; Sprite Y Pos
HsYr:          equ     8           ; Hardware Sprite Y Reverse mode
HsLien:        equ     10          ; Linked with previous sprite for 16 colors mode ?
HsImage:       equ     12          ; Sprite Image ID
HsControl:     equ     16          ; Sprite Control Word 1 (.w) and Word 2 (.w)
HsLong:        equ     20          ; Length of the structure.
        Rb     SpBase,HsLong+4     ; Length of 8 sprites structures

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
        Rl    IntScreen,1              ; 2021.02.19 Reinserted
        Rl    SaveReg,1                ; 2021.03.14 Inserted for some special calls.
        Rl    SaveReg2,1               ; 2021.03.15 Inserted for some special calls.
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
Lis        equ    $16
Lio        equ    $30
Lmsg        equ    $20
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

*************** Global Aga Palette
agaPalCnt      equ 8                   ; Define the maximum of Aga color palette that can be created.
        Rw     isAga,1                 ; 2019.11.30 Will be set (<>0) if Aga Chipset is detected
        Rl     AgaColorPals,agaPalCnt  ; 2019.12.04 8 registers to store 8 color palettes lists in RGB25 format
        Rl     AgaCMAPColorFile,1      ; 2020.09.17 Added to store (at max) a full IFF/ILBM Color map file.
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
*************** Longueur de la structure W.S
        Rb     L_Trp,4
L_Trappe    equ    -Count
***********************************************************

