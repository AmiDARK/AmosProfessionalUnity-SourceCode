
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
;        LIBRAIRIE GRAPHIQUE AMOS
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        OPT    P+
; Docs       : http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_3._guide/node0000.html
; Fetch Mode : http://jvaltane.kapsi.fi/amiga/howtocode/aga.html
; Detect Aga : http://www.stashofcode.fr/code/afficher-sprites-et-bobs-sur-amiga/AGAByRandyOfComax.txt

; 10004 ~ Zone de données centrales.
; 7700 ~ AllocMems...

EcMaxPlans    equ 8
***************************************************************************
        IFND    EZFlag
EZFlag        equ     0
        ENDC
***************************************************************************

        IncDir  "includes/"
        Include "exec/types.i"
        Include "exec/interrupts.i"
        Include "graphics/gfx.i"
        Include "graphics/layers.i"
        Include "graphics/clip.i"
        Include "hardware/intbits.i"
        Include "devices/input.i"
        Include "devices/inputevent.i"

        Include "src/AmosProUnity_Debug.s"
        Include "src/AMOS_Includes.s"


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Version    MACRO
    dc.b    0,"$VER: 0.1",0
    even
    ENDM
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

WDebut:
    bra        Startall                ; (Line=9535) Start from Cold [1st start]
    bra        Endall                  ; Close Everything End
    dc.l       L_Trappe                ; Length of data zone
    bra        IceStart                ; Access of System functions
    bra        IceEnd                  ; Stop access of system functions
    dc.b       "P300"                  ; Version Pro 3.00 // Updated as new commands will appear with development.

BugBug:
    movem.l    d0-d2/a0-a2,-(sp)
.Ll:
    move.w     #$FF0,$DFF180
     btst      #6,$BFE001
    bne.s      .Ll
    move.w     #20,d0
.L0:
    move.w     #10000,d1
.L1:
    move.w     d0,$DFF180
    dbra       d1,.L1
    dbra       d0,.L0    
    btst       #6,$BFE001
    beq.s      .Ill
    movem.l    (sp)+,d0-d2/a0-a2
    rts
.Ill:
    moveq      #0,d1
    bsr        TAMOSWb
    movem.l    (sp)+,d0-d2/a0-a2
    illegal
    rts

        Version

    include    "src/AmosProUnityCommon_Library/Collision.s"

    include    "src/AmosProUnitySAGA_library/BlitterObjects.s"

    include    "src/AmosProUnityCommon_Library/SpritesBobsFlipping.s"


***********************************************************
*    Calcul de PEN/PAPER
***********************************************************
AdColorT:
    move.w    WiNPlan(a5),d1

    move.w    WiPaper(a5),d2
    move.w    WiPen(a5),d3
    move.w    d2,d4
    move.w    d3,d5
    lea    TAdCol(pc),a0
    lea    WiColor(a5),a1
    lea    WiColFl(a5),a2

ACol:    moveq    #16,d0
    btst    d1,WiSys+1(a5)
    bne.s    ACol1
    clr.w    d0
    lsr.w    #1,d2
    roxl.w    #1,d0
    lsr.w    #1,d3
    roxl.w    #1,d0
    lsl.w    #2,d0
ACol1    move.l    0(a0,d0.w),d0
    add.l    a0,d0
    move.l    d0,(a1)+

    lsr.w    #1,d4
    subx.w    d0,d0
    move.w    d0,(a2)+
    lsr.w    #1,d5
    subx.w    d0,d0
    move.w    d0,(a2)+

    dbra    d1,ACol

    rts

    include "src/AmosProUnitySAGA_library/Screens_Init.s"

    include "src/AmosProUnityCommon_library/BraList_Screens.s"



***********************************************************
*    Instructions de gestion des ecrans
***********************************************************

******* MAX RAW
TMaxRaw    move.w    T_EcYMax(a5),d1
    sub.w    #EcYBase,d1
    ext.l    d1
    moveq    #0,d0
    rts
******* NTSC?
TNTSC    moveq    #0,d0
    moveq    #0,d1            PAL
    move.l    $4.w,a0            
    cmp.b    #50,530(a0)        VBlankFrequency=50?
    beq.s    .NoNTSC
    moveq    #-1,d1            NTSC!
.NoNTSC    rts


    include "src/AmosProUnitySAGA_library/Screens.s"

    include "src/AmosProUnitySAGA_library/Autoback.s"

    include "src/AmosProUnityCommon_Library/Drawing2D.s"

    include "src/AmosProUnitySAGA_library/RainbowsSystem.s"

    include "src/AmosProUnityCommon_Library/Clipping.s"

    include "src/AmosProUnityCommon_Library/PatternsPainting.s"

    include "src/AmosProUnityCommon_Library/Fonts.s"

    include "src/AmosProUnityCommon_Library/Menus.s"

    include "src/AmosProUnityCommon_Library/Sliders2D.s"

    include "src/AmosProUnityCommon_Library/Flash.s"

    include "src/AmosProUnityCommon_Library/Shifter2D.s"

    include "src/AmosProUnitySAGA_library/FadingSystem.s"

    include "src/AmosProUnitySAGA_library/CopperListSystem.s"


;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * DIVERS
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------
;-----> Wait mouse key
WaitMK:    bsr    MBout
    cmp.w    #2,d1
    bne.s    WaitMk
Att:    bsr    MBout
    cmp.w    #0,d1
    bne.s    Att
    rts

    include    "src/AmosProUnitySAGA_library/Blitter.s"
    
    include    "src/AmosProUnityCommon_Library/Vbl.s"


******* RESERVATION MEMOIRE

    include    "src/AmosProUnityCommon_Library/MemoryHandler.s"

    include    "src/AmosProUnityCommon_Library/ChrStr.s"

    include    "src/AmosProUnityCommon_Library/AmalSystem.s"

    include    "src/AmosProUnitySAGA_library/AmosProLibrary_Start.s"

    include    "src/AmosProUnitySAGA_library/AmosProLibrary_End.s"

    include    "src/AmosProUnityCommon_Library/InternalsSystem.s"

    include    "src/AmosProUnityCommon_Library/BraList_System.s"

    include    "src/AmosProUnitySAGA_library/InternalMouseHandler.s"

**********************************************************
*    JOYSTICK / d1= # de port 
**********************************************************
ClJoy:    tst.b    T_AMOSHere(a5)
    beq.s    JoyNo
    moveq    #6,d0            ;# du bit de FEU
    add.w    d1,d0
    lea    Circuits,a0
    lsl.w    #1,d1
    move.w    10(a0,d1.w),d2
; Prend le bouton
    clr.w    d1
    btst    d0,CiaAPrA
    bne.s    Joy1
    bset    #4,d1
; Teste les directions
Joy1:    lea    JoyTab(pc),a0
    lsl.b    #6,d2
    lsr.w     #6,d2
    and.w    #$000F,d2
    or.b    0(a0,d2.w),d1
Joy2    moveq    #0,d0
    rts
JoyNo    moveq    #0,d1
    bra.s    Joy2
JoyTab:    dc.b     %0000,%0010,%1010,%1000,%0001,%0000,%0000,%1001
    dc.b     %0101,%0000,%0000,%0000,%0100,%0110,%0000,%0000

    include "src/AmosProUnityCommon_Library/Zones.s"

    include "src/AmosProUnitySAGA_library/Sprites.s"

    include "src/AmosProUnityCommon_Library/Blocks.s"

    include "src/AmosProUnityCommon_Library/InternalDevicesAndHandlers.s"

    include "src/AmosProUnityCommon_Library/InternalKeyboardHandler.s"



; RETOUR L''ETAT DU FLAG DISC
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TGetDisc
    move.w    T_DiscIn(a5),d0
    ext.l    d0
    rts

;    Gestion cyclique hors interruptions
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WTest_Cyclique

; Verifie AMOS / WB si AA
; ~~~~~~~~~~~~~~~~~~~~~~~
    bclr    #WFlag_AmigaA,T_WFlags(a5)
    beq.s    .NoFlip
    moveq    #0,d1
    tst.b    T_AMOSHere(a5)
    bne.s    .Wb
    moveq    #1,d1
.Wb    bsr    TAMOSWb
.NoFlip
; Envoi des faux messages au WB, en cas de blanker
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l    $4.w,a0
    cmp.w    #36,$14(a0)
    bcs.s    .Noev
    subq.w    #1,T_FakeEventCpt(a5)
    bpl.s    .Noev
    move.w    #50*2,T_FakeEventCpt(a5)
    tst.b    T_AMOSHere(a5)
    beq.s    .Noev
    bsr    WSend_FakeEvent
.Noev
; Verifie l''inhibition
; ~~~~~~~~~~~~~~~~~~~~
    move.l    T_MyTask(a5),a0
    move.l    10(a0),a0
    cmp.b    #"S",(a0)
    bne.s    .Skip
    bsr    AMOS_Stopped
.Skip    rts

;    Cet AMOS est inhibe par un premier!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AMOS_Stopped
    movem.l    a0-a6/d0-d7,-(sp)
    move.l    a0,a4
; Fait revenir le WB / Stoppe les interrupts
    move.w    #-1,T_Inhibit(a5)
    moveq    #-1,d1
    bsr    TAMOSWb
    move.w    d1,d7
    moveq    #0,d1
    bsr    TAMOSWb
; Stoppe les interrupts
    bsr    Rem_VBL
; Arrete le son
    move.w    #$000F,$Dff096
; Change le "S"top en "W"
    move.b    #"W",(a4)
; Attend qu''il se retransforme en " "
.Wait    move.l    T_GfxBase(a5),a6
    jsr    -270(a6)
    cmp.b    #"W",(a4)
    beq.s    .Wait
; Ramene le programme..
    bsr    Add_VBL
    tst.w    d7
    beq.s    .Skip
    moveq    #1,d1
    bsr    TAMOSWb
.Skip    clr.w    T_Inhibit(a5)
    movem.l    (sp)+,a0-a6/d0-d7
    rts    

; 2021.02.23 Added as link because Windows is too far from AdColor method.
AdColor:
    bra    AdColorT

    include "src/AmosProUnityCommon_Library/BraList_Windows.s"

    include "src/AmosProUnityCommon_Library/Windows.s"

    include "src/AmosProUnitySAGA_library/Text.s"

***********************************************************
*    MESSAGES D''ERREUR
***********************************************************
PErr7:    moveq    #16,d0
    rts
WErr1:    moveq    #10,d0
    bra.s    WErr
WErr2:    moveq    #11,d0
    bra.s    WErr
WErr3:    moveq    #12,d0
    bra.s    WErr
WErr4:    moveq    #13,d0
    bra.s    WErr
WErr5:    moveq    #14,d0
    bra.s    WErr
WErr6:    moveq    #15,d0
    bra.s    WErr
WErr7:    moveq    #16,d0
    bra.s    WErr
WErr8:    moveq    #1,d0
    bra.s    WErr
WErr10:    moveq    #19,d0

* Erreurs generales
WErr:    move.l    d0,-(sp)
    cmp.l    EcWindow(a4),a5
    beq.s    WErF
    cmp.l    #0,a5
    beq.s    WErF
    move.l    a5,a1
    move.l    #WiLong,d0
    bsr    FreeMm
WErF:    move.l    (sp)+,d0
    movem.l    (sp)+,d1-d7/a1-a6
    rts

    include "src/AmosProUnityCommon_Library/Requesters.s"

    include "src/AmosProUnitySAGA_library/ExtractedFromAmosPro_lib.s"

***********************************************************

    include "src/AmosProUnityCommon_Library/BraList_Controls.s"

    include "src/AmosProUnityCommon_Library/BraList_Escapes.s"


***********************************************************
*        Bordures
***********************************************************

Brd:        dc.w Bor0-Brd,Bor1-Brd,Bor2-Brd,Bor3-Brd
        dc.w Bor4-Brd,Bor5-Brd,Bor0-Brd,Bor0-Brd
        dc.w Bor0-Brd,Bor0-Brd,Bor0-Brd,Bor0-Brd
        dc.w Bor0-Brd,Bor0-Brd,Bor0-Brd,Bor15-Brd
        dc.b 0
Bor0:        dc.b 136,0        * Haut G
        dc.b 138,0        * Haut D
        dc.b 137,0        * Haut
        dc.b 139,0        * Droite
        dc.b 140,0        * Bas G
        dc.b 141,0        * Bas D
        dc.b 137,0        * Bas
        dc.b 139,0        * Gauche
Bor1:        dc.b 128,0        * Haut G
        dc.b 130,0        * Haut D
        dc.b 129,0        * Haut
        dc.b 132,0        * Droite
        dc.b 133,0        * Bas G
        dc.b 135,0        * Bas D
        dc.b 134,0        * Bas
        dc.b 131,0        * Gauche
Bor2:        dc.b 157,0        * Haut G
        dc.b 2,0        * Haut D
        dc.b 1,0        * Haut
        dc.b 3,0        * Droite
        dc.b 6,0        * Bas G
        dc.b 4,0        * Bas D
        dc.b 5,0        * Bas
        dc.b 7,0        * Gauche
Bor3:        dc.b 8,0        * Haut G
        dc.b 10,0        * Haut D
        dc.b 9,0        * Haut
        dc.b 11,0        * Droite
        dc.b 14,0        * Bas G
        dc.b 12,0        * Bas D
        dc.b 13,0        * Bas
        dc.b 15,0        * Gauche
Bor4:        dc.b 16,0        * Haut G
        dc.b 18,0        * Haut D
        dc.b 17,0        * Haut
        dc.b 19,0        * Droite
        dc.b 22,0        * Bas G
        dc.b 20,0        * Bas D
        dc.b 21,0        * Bas
        dc.b 23,0        * Gauche
Bor5:        dc.b 24,0        * Haut G
        dc.b 26,0        * Haut D
        dc.b 25,0        * Haut
        dc.b 158,0        * Droite
        dc.b 30,0        * Bas G
        dc.b 28,0        * Bas D
        dc.b 29,0        * Bas
        dc.b 31,0        * Gauche
Bor15        dc.b " ",0
        dc.b " ",0
        dc.b " ",0
        dc.b " ",0
        dc.b " ",0
        dc.b " ",0
        dc.b " ",0
        dc.b " ",0
        even        

***********************************************************
*        CODE AMOS HERE?
BufCode        dc.w    0
        dc.b    "I"+$60
        dc.b    "S"+$60
        dc.b    " "+$60
        dc.b    "A"+$60
        dc.b    "M"+$60
        dc.b    "O"+$60
        dc.b    "S"+$60
        dc.b    " "+$60
        dc.b    "H"+$60
        dc.b    "E"+$60
        dc.b    "R"+$60
        dc.b    "E"+$60
        dc.b     0

***********************************************************
*        FONCTIONS ESCAPES
***********************************************************

        dc.b 32,32,32,32,32,32,32,32
TEncadre:    dc.b 136,137,138,139,141,137,140,139
        dc.b 128,129,130,132,135,134,133,131
        dc.b 157,1,2,3,4,5,6,7
        dc.b 8,9,10,11,12,13,14,15
        dc.b 16,17,18,19,20,21,22,23
        dc.b 24,25,26,158,28,29,30,31
        dc.b 32,32,32,32,32,32,32,32

***********************************************************
*        CURSEUR TEXTE
***********************************************************
DefCurs:    dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %00000000
        dc.b %11111111
        dc.b %11111111
        dc.w 0

    IFNE    EZFlag
TokAMAL        
CreAMAL        
MvOAMAL        
DAllAMAL    
Animeur        
RegAMAL        
ClrAMAL        
FrzAMAL        
UFrzAMAL    
SpColl        
SyncO        
Sync        
SetPlay        
HColSet        
HColGet        
TMovon        
TChanA        
TChanM        

ShStop
ShStart
MakeCBloc
DrawCBloc
FreeCBloc
RazCBloc
Duale
DualP
StaMn        
StoMn        
TCopOn        
TCopRes        
TCopSw        
TCopWt        
TCopMv        
TCopMl        
TCopBs        

DAdAMAL
AMALInit
AMALEnd
ShInit
    rts

    ENDC

;        Banque MOUSE.ABK par defaut
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        SECTION    "m",DATA_C
        IncBin    "src/bin/AMOSPro_Mouse.abk"

        even


