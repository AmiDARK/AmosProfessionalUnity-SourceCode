
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

 ;       Include "src/AMOSProAGA_Plugins/ScreensReplacement_Equ.s"
 ;       Include "src/Lib_AgaSupport/AgaSupport_Equ.s"

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

    IFEQ    EZFlag
***********************************************************
*    COLLISIONS HARD
    
******* SET HARDCOL
*    D1=     Sprites
*    D2=    Enable
*    D3=    Compare
HColSet    and.w    #$000F,d1
    lsl.w    #8,d1
    lsl.w    #4,d1
    and.w    #$003F,d2
    lsl.w    #6,d2
    and.w    #$003F,d3
    or.w    d2,d1
    or.w    d3,d1
    move.w    d1,Circuits+$98
    moveq    #0,d0
    rts
******* =HARDCOL
*    D1=    #Sprite / -1 Si bitplanes
HColGet    lea    T_TColl(a5),a0
    move.l    a0,a1
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    move.w    Circuits+$0E,d2
    tst.w    d1
    bmi.s    HCol3
* Sprites
    and.w    #$0006,d1
    lsl.w    #2,d1
    lea    HColT(pc),a0
    add.w    d1,a0
    moveq    #0,d3
    moveq    #%00000011,d4
    moveq    #0,d1
    move.b    (a0)+,d0
HCol1    bmi.s    HCol2
    btst    d0,d2
    beq.s    HCol2
    or.w    d4,d3
    cmp.w    #$0100,d3
    bcc.s    HCol2
    moveq    #-1,d1
HCol2    lsl.w    #2,d4
    move.b    (a0)+,d0
    bne.s    HCol1
* Ok!
    ror.w    #8,d3
    move.w    d3,(a1)
    moveq    #0,d0
    rts
******* Playfield / Playfield
HCol3    moveq    #0,d1
    btst    #0,d2
    beq.s    HCol4
    moveq    #-1,d1
HCol4    rts
******* Table des bits a tester!
HColT    dc.b    -1,9,10,11,1,5,0,0
    dc.b    9,-1,12,13,2,6,0,0
    dc.b    10,12,-1,14,3,7,0,0
    dc.b    11,13,14,-1,4,8,0,0
    ENDC

***********************************************************
*    COLLISIONS SOFT

******* Routine collision:
*    A3/A2=     descripteur sprite concerne
*    D0/D1=    bob dest   DX/DY
*    D2=    Image!
*    D4/D5=     bob source DX/DY
*    D6/D7=    bob source FX/FY
*    A4=    banque!
******* RETOUR: BNE-> Pas coll
*******        BEQ-> Coll
ColRout:
* Pointe le descripteur
    and.w    #$3FFF,d2
    beq    ColRF
    cmp.w    (a4),d2
    bhi    ColRF
    lsl.w    #3,d2
    lea    -8+2(a4,d2.w),a0
    move.l    4(a0),d2
    ble    ColRF
    move.l    d2,a1
    move.l    (a0),d2
    beq    ColRF
    move.l    d2,a0
* Prend les coordonnees
    move.w    6(a0),d2
    lsl.w    #2,d2
    asr.w    #2,d2
    sub.w    d2,d0
    sub.w    8(a0),d1
    move.w    (a0),d2
    lsl.w    #4,d2
    move.w    2(a0),d3
    add.w    d0,d2
    add.w    d1,d3
* Croisement?
    cmp.w    d4,d2
    ble    ColRF
    cmp.w    d6,d0
    bge    ColRF
    cmp.w    d5,d3
    ble    ColRF
    cmp.w    d7,d1
    bge    ColRF
* Verifie avec le blitter!
    movem.l    d4-d7/a2/a3,-(sp)
    cmp.w    d0,d4        * Met le plus a gauche en D0
    bge.s    ColR1
    exg.l    d0,d4
    exg.l    d1,d5
    exg.l    d2,d6
    exg.l    d3,d7
    exg.l    a1,a3
    exg.l    a0,a2
ColR1:    cmp.w    d5,d1
    bge.s    ColR5
    move.w    d5,-(sp)
    sub.w    d1,(sp)
    clr.w    -(sp)
ColR2:    cmp.w    d3,d7
    bge.s    ColR3
    move.w    d7,-(sp)
    bra.s    ColR4
ColR3:    move.w    d3,-(sp)
ColR4:    sub.w    d5,(sp)
    bra.s    ColR7a
ColR5:    clr.w    -(sp)
    move.w    d1,-(sp)
    sub.w    d5,(sp)
    cmp.w    d3,d7
    bge.s    ColR6
    move.w    d7,-(sp)
    bra.s    ColR7
ColR6:    move.w    d3,-(sp)
ColR7:    sub.w    d1,(sp)

ColR7a:    move.w    d4,d1
    sub.w    d0,d1
    cmp.w    d2,d6
    bge.s    ColR8
    move.w    d6,d3
    bra.s    ColR9
ColR8:    move.w    d2,d3
ColR9:    sub.w    d4,d3

    move.w    d1,d0
    lsl.w    #8,d0
    lsl.w    #4,d0
    move.w    d0,BltCon1(a6)
    move.w    #%0000110011000000,BltCon0(a6)
    lsr.w    #4,d3
    tst.w    d0
    beq.s    ColRA
    addq.w    #1,d3
ColRA:    move.w    d3,d4
    move.w    (sp)+,d0
    ble.s    ColRF0
    lsl.w    #6,d0
    or.w    d0,d4
    lsl.w    #1,d3
    move.w    (a0),d0
    lsl.w    #1,d0
;    addq.w    #2,d0
    move.w    d0,d6
    sub.w    d3,d0
    move.w    d0,BltModA(a6)
    move.w    (a2),d0
    lsl.w    #1,d0
;    addq.w    #2,d0
    move.w    d0,d5
    sub.w    d3,d0
    move.w    d0,BltModB(a6)

    mulu    (sp)+,d5
    lea    4(a3,d5.w),a3
    move.l    a3,BltAdB(a6)
    move.w    d1,d0
    lsr.w    #4,d0
    lsl.w    #1,d0
    mulu    (sp)+,d6
    add.w    d0,d6
    lea    4(a1,d6.w),a1
    move.l    a1,BltAdA(a6)
    move.w    #-1,BltMaskD(a6)
    and.w    #$000F,d1
    lsl.w    #1,d1
    lea    MCls(pc),a1
    move.w    0(a1,d1.w),BltMaskG(a6)

    move.w    d4,BltSize(a6)
    movem.l    (sp)+,d4-d7/a2/a3

ColRW:    bsr    BlitWait
    btst    #13,DmaConR(a6)
    rts
* Yapa collision!
ColRF:    moveq    #1,d0
    rts
* Yapa special!
ColRF0:    addq.l    #4,sp
ColRF1:    movem.l    (sp)+,d4-d7/a2/a3
    moveq    #1,d0
    rts

***********************************************************
*    BOB COLLIDE
*    D1= Numero du bob
*    D2= Debut a explorer (Bit 31===> TO SPRITE)
*    D3= Fin a explorer
BbColl:    movem.l    a2-a6/d2-d7,-(sp)
    lea    Circuits,a6
    bsr    OwnBlit
    lea    T_TColl(a5),a0
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    moveq    #0,d7
    move.l    T_SprBank(a5),d0
    beq    BbColX
    move.l    d0,a4
    bsr    BobAd
    bne    BbColX

* Coordonnees du bob a tester!
    move.l    a1,a2
    tst.b    BbAct(a2)
    bmi    BbColX
    move.w    d1,a0
    move.l    BbEc(a2),d1
    move.w    BbX(a2),d4
    move.w    BbY(a2),d5
    move.w    BbI(a2),d0
    and.w    #$3FFF,d0
    beq    BbColX
    cmp.w    (a4),d0
    bhi    BbColX
    lsl.w    #3,d0
    lea    -8+2(a4,d0.w),a2
    move.l    4(a2),d0
    ble    BbColX
    move.l    d0,a3
    move.l    (a2),d0
    beq    BbColX
    move.l    d0,a2
    move.w    6(a2),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d4
    sub.w    8(a2),d5
    move.w    d4,d6
    move.w    d5,d7
    move.w    (a2),d0
    lsl.w    #4,d0
    add.w    d0,d6
    add.w    2(a2),d7
    btst    #31,d2
    bne    GoToSp

    exg.l    a0,a5
    move.l    T_BbDeb(a0),d0
    lea    T_TColl(a0),a0
******* Explore la table des bobs!
BbCol1:    move.l    d0,a1
    move.w    BbNb(a1),d0
    cmp.w    d2,d0
    bcs.s    BbColN
    cmp.w    d3,d0
    bhi.s    BbColX
    cmp.w    a5,d0
    beq.s    BbColN
    cmp.l    BbEc(a1),d1
    bne.s    BbColN
    tst.b    BbAct(a1)
    bmi.s    BbColN
    movem.l    d0-d3/a0/a1,-(sp)
    move.w    BbX(a1),d0
    move.w    BbY(a1),d1
    move.w    BbI(a1),d2
    bsr    ColRout
    movem.l    (sp)+,d0-d3/a0/a1
    bne.s    BbColN
    swap    d2
    and.w    #$00FF,d0
    move.w    d0,d2
    lsr.w    #3,d0
    and.w    #$7,d2
    bset    d2,0(a0,d0.w)
    bset    #31,d7
    swap    d2
BbColN:    move.l    BbNext(a1),d0
    bne.s    BbCol1

******* Fini!
BbColX:    bsr    DOwnBlit
    btst    #31,d7
    bne.s    BbColT
    moveq    #0,d0
    bra.s    BbColXx
BbColT    moveq    #-1,d0
BbColXx    movem.l    (sp)+,a2-a6/d2-d7
    rts

******* Conversion---> HARD
GoToSp:    movem.w    d2-d3,-(sp)
    move.l    d1,a0
    sub.w    d4,d6
    sub.w    d5,d7
    move.w    d4,d1
    move.w    d5,d2
    bsr    CXyS
    move.w    d1,d4
    move.w    d2,d5
    add.w    d4,d6
    add.w    d5,d7
    movem.w    (sp)+,d2-d3
    moveq    #-1,d1
    bra    BbToSp

    IFEQ    EZFlag
***********************************************************
*    SPRITE COLLIDE
*    D1= Numero du sprite
*    D2= Debut a explorer
*    D3= Fin a explorer
SpColl:    movem.l    a2-a6/d2-d7,-(sp)
    lea    Circuits,a6
    bsr    OwnBlit
    lea    T_TColl(a5),a0
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    moveq    #0,d7
    move.l    T_SprBank(a5),d0
    beq    BbColX
    move.l    d0,a4

* Coordonnees du sprite a tester!
    cmp.w    #64,d1
    bcc    BbColX
    lea    T_HsTAct(a5),a2
    move.w    d1,d0
    lsl.w    #3,d0
    add.w    d0,a2
    move.w    2(a2),d4
    move.w    4(a2),d5
    move.w    6(a2),d0
    and.w    #$3FFF,d0
    beq    BbColX
    cmp.w    (a4),d0
    bhi    BbColX
    lsl.w    #3,d0
    lea    -8+2(a4,d0.w),a2
    move.l    4(a2),d0
    ble    BbColX
    move.l    d0,a3
    move.l    (a2),d0
    beq    BbColX
    move.l    d0,a2
    move.w    6(a2),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d4
    sub.w    8(a2),d5
    move.w    d4,d6
    move.w    d5,d7
    move.w    (a2),d0
    lsl.w    #4,d0
    add.w    d0,d6
    add.w    2(a2),d7
    btst    #31,d2
    bne    SpToBb
    ENDC

BbToSp:    cmp.w    #64,d3
    bcc    BbColX
    cmp.w    d2,d3
    bcs    BbColX
    lea    T_TColl(a5),a0
    lea    T_HsTAct(a5),a1
    move.w    d2,d0
    lsl.w    #3,d2
    add.w    d2,a1
    move.w    d3,a5
******* Explore la table des sprites!
SpCol1:    cmp.w    d1,d0
    beq.s    SpColN
    tst.w    (a1)
    bmi.s    SpColN
    move.w    6(a1),d2
    ble.s    SpColN
    movem.l    d0/d1/a0/a1,-(sp)
    move.w    2(a1),d0
    move.w    4(a1),d1
    bsr    ColRout
    movem.l    (sp)+,d0/d1/a0/a1
    bne.s    SpColN
    move.w    d0,d2
    move.w    d0,d3
    lsr.w    #3,d2
    and.w    #$7,d3
    bset    d3,0(a0,d2.w)
    bset    #31,d7
SpColN:    addq.w    #1,d0
    addq.l    #8,a1
    cmp.w    a5,d0
    bls.s    SpCol1
    bra    BbColX

******* Fin de SPRITE/BOB
SpToBb:    move.l    T_BbDeb(a5),d0
    lea    T_TColl(a5),a5
SbCol1:    move.l    d0,a1
    move.w    BbNb(a1),d0
    cmp.w    d2,d0
    bcs    SbColN
    cmp.w    d3,d0
    bhi    BbColX
    tst.b    BbAct(a1)
    bmi    SbColN
    movem.l    d0/d2/d3/a1,-(sp)
    move.l    BbEc(a1),a0
    move.w    BbX(a1),d1
    move.w    BbY(a1),d2
    bsr    CXyS
    move.w    d1,d0
    move.w    d2,d1
    move.w    BbI(a1),d2
    bsr    ColRout
    movem.l    (sp)+,d0/d2/d3/a1
    bne.s    SbColN
    and.w    #$00FF,d0
    move.w    d0,d1
    lsr.w    #3,d0
    and.w    #$7,d1
    bset    d1,0(a5,d0.w)
    bset    #31,d7
SbColN:    move.l    BbNext(a1),d0
    bne.s    SbCol1
    bra    BbColX

***********************************************************
*    =COLL(n) ramene la collision d'un bob/sprite
GetCol:    lea    T_TColl(a5),a0
    tst.l    d1
    bmi.s    GetC2
    and.w    #$FF,d1
    move.w    d1,d0
    lsr.w    #3,d0
    and.w    #$7,d1
    btst    d1,0(a0,d0.w)
    bne.s    GetC1
GetC0:    moveq    #0,d0
    rts
GetC1:    moveq    #-1,d0
    rts
* Ramene le premier en collision
GetC2:    neg.l    d1
    cmp.l    #255,d1
    bcc.s    GetC0
    move.w    d1,d0
    lsr.w    #3,d0
    add.w    d0,a0
    move.l    d1,d0
    and.w    #7,d1
.loop    btst    d1,(a0)
    bne.s    .found
    addq.w    #1,d0
    addq.w    #1,d1
    cmp.w    #8,d1
    bcs.s    .loop
    moveq    #0,d1
    addq.l    #1,a0
    cmp.w    #256,d0
    bcs.s    .loop
    bra.s    GetC0
.found    rts

***********************************************************
*    HOT SPOT!
*    A2= descripteur
*    D1= Mode
*    D2= Dx
*    D3= Dy
SpotH:    move.l    (a2),d0
    beq.s    SpoE
    move.l    d0,a1
    tst.w    d1
    beq.s    Spo4
******* Mode FIXE!
    move.w    (a1),d2
    lsl.w    #4,d2
    move.w    2(a1),d3
    subq.w    #1,d1
* En X
    move.w    d1,d0
    lsr.w    #4,d0
    and.w    #3,d0
    subq.w    #1,d0
    bhi.s    Spo2
    beq.s    Spo1
    moveq    #0,d2
Spo1:    lsr.w    #1,d2
* En Y
Spo2:    and.w    #3,d1
    subq.w    #1,d1
    bhi.s    Spo4
    beq.s    Spo3
    moveq    #0,d3
Spo3:    lsr.w    #1,d3
* Poke, en respectant les FLAGS!
Spo4:    and.w    #$C000,6(a1)
    and.w    #$3FFF,d2
    or.w    d2,6(a1)    
    move.w    d3,8(a1)
    moveq    #0,d0
    rts
SpoE:    moveq    #-1,d0
    rts
    
***********************************************************
*    GET BOB/BLOC
*    A1= Ecran
*    A2= descripteur
*    D2/D3= X1/Y1
*    D4/D5= TX/TY
*    D6=    X2
GetBob:
    movem.l    d1-d7/a0-a6,-(sp)       ; Save Regs
    move.l     a1,a5                   ; A5 = A1 = Screen Table

; Check mask for right limits :
    move.w     d4,d6                   ; D6 = D4 = Bob Width
    and.w      #$000F,d6               ; D6 = Bob Width && %$0F
    lsl.w      #1,d6                   ; D6 = ( Bob Width && %$0F ) * 2 = Range( 0-31 )
    move.w     d6,a4                   ; A4 = D6 = Range( 0-31 )

; Calculate the Bob memory size in bytes :
    move.w     EcNPlan(a5),d7          ; D7 = Screen Depth (Amount of bitplanes)
    add.w      #15,d4                  ; D4 = Width + 15 (Used for 16 bits final bob image size alignment)
    lsr.w      #4,d4                   ; D4 = D4 / 16 = Amount of word (16 bits) to use for sprite width
    move.w     d4,d6                   ; D6 = Sprite/Bob Width in word(s) (16 bits)
    lsl.w      #1,d6                   ; D6 = D6 * 2 = Sprite/Bob Width in bytes ( 8 bits )
    move.w     d6,d1                   ; D1 = Sprite/Bob Width in bytes
    mulu       d5,d1                   ; D1 = Sprite/Bob 1 bitplane size in bytes
    mulu       d7,d1                   ; D1 = Full Sprite/Bob D7 (Screen depth) size in bytes

; Delete the previous one ?
******* Efface l''ancien???
    move.l     (a2),d0                 ; Does a previous version of the Sprite/Bob exists ?
    beq.s      GtBb1                   ; NO -> Jump GtBb1
    move.l     d0,a1                   ; A1 = Previous bob table
    move.w     (a1),d0                 ; D0 = Previous Bob Width in bytes
    lsl.w      #1,d0                   ; D0 = D0 * 2 ( Word alignment)
    mulu       2(a1),d0                ; D0 = D0 * Previous Bob Height (in lines)
    mulu       4(a1),d0                ; D0 = D0 * Previous Bob Depth (in bitplanes amount)
    cmp.l      d0,d1                   ; Are both previous and new both the same size (in memory size not pixels)
    beq.s      GtBb1                   ; YES - > Jump GtBb1
    add.l      #10,d0                  ; D0 = D0 + 10 (for headers (width, height, depth, etc.))
    bsr        FreeMm                  ; Free Memory
    clr.l      (a2)                    ; Clear previous bob/sprite pointer to complete release
GtBb1:
    move.l     4(a2),d0                ; D0 = Does a previous version of the sprite/Bob table exists ?
    ble.s      GtBb2                   ; No -> Jump GtBb2
    move.l     d0,a1                   ; Load Previous bob/Sprite table -> A1
    move.l     (a1),d0                 ; D0 = Previous Bob/Sprite table size in bytes
    bsr        FreeMm                  ; Release previous Bob/Sprite table memory allocation.
GtBb2:
    clr.l      4(a2)                   ; Clear previous bob/sprite table pointer to complete release

; Allocate memory for the new one.
    tst.l      (a2)                    ; Does new sprite table allocated (because previous one fit the need and was not deleted)
    bne.s      GtBb3                   ; YES -> Jump GtBb3
    move.l     d1,d0                   ; D1 = Full Sprite/Bob D7 (Screen depth) size in bytes
    add.l      #10,d0                  ; D0 = D0 + 10 bytes (for headers (width, height, depth, etc.))
    bsr        ChipMm2                 ; Allocate memory for Bob/Sprite
    beq        GtBbE                   ; Cannot allocate memory -> Jump GtBbE (error)
    move.l     d0,(a2)                 ; (a2) = New Bob/Sprite memory block

; Save Bob/Sprite information in the Bob/Sprite memory block!
GtBb3:
    move.l     (a2),a2                 ; A2 = Pointer to new Sprite/Bob memory block
    move.w     d4,(a2)+                ; Save (a2,0.w) = Bob Width
    move.w     d5,(a2)+                ; Save (A2,2.w) = Bob Height
    move.w     d7,(a2)+                ; Save (A2,4.w) = Bob Depth
    clr.w      (a2)+                   ; Save (A2,6.w) = 0
    clr.w      (a2)+                   ; Save (A2,8.w) = 0

;

; GET (not translated) :
    lea        Circuits,a6             ; A6 = Chipsets registers base
    bsr        OwnBlit                 ; Wait for blitter ending and get control overt it
    subq.w     #1,d7                   ; D7 = Bitplanes Amount -1 ( to use minus as end loop checking )
    move.w     d2,d0                   ; D0 = Sprite/Bob X Position in screen for capture
    and.w      #$000F,d0               ; Check if X Position is multiple of 16
    bne.s      GtBc                    ; NO -> Jump GtBc

; To word :
    moveq      #-1,d1                  ; D1 = $FFFFFFFF
    move.w     d1,BltMaskG(a6)         ; BltMaskG = $FFFF
    move.w     a4,d0                   ; ( Bob Width && #$0F ) *2 = Range( 0-31 )
    beq.s      GtBbM                   ; =0 -> GtBbM
    lea        MCls(pc),a0
    move.w     0(a0,d0.w),d1
    not.w      d1                      ; D1 = $0000
GtBbM:
    move.w     d1,BltMaskD(a6)         ; BltMaskD = $0000
    move.w     EcTLigne(a5),d1         ; D1 = Screen Line size (bytes)
    mulu       d1,d3                   ; D3 = Current Line position in Screen to grab the Sprite/Bob
    lsr.w      #4,d2                   ; D2 = XPos to grab / 16
    lsl.w      #1,d2                   ; D2 = XPos to grab / 8 (byte position) word aligned.
    ext.l      d2                      ; Extends D2 sign (bit #15) to .l ( Bits #16-#31)
    add.l      d2,d3                   ; D3 = Exact bitplane position to start grab the sprite/bob in screen.
    lea        EcCurrent(a5),a1        ; A1 = Load Bitplane #0
    sub.w      d6,d1                   ; Calculate modulo in D1
    move.w     d1,BltModA(a6)          ; Set Blitter Source A Modul0 ( Screen Width (in bytes) - Bob/Sprite width (in bytes) )
    move.l     a2,BltAdD(a6)           ; Blitter Source D Pointer
    clr.w      BltModD(a6)             ; Blitter Source D modulo = 0
    lsl.w      #6,d5                   ; D5 = Bob Height * 64 ( Bits 15-06 = H9-H0 in BltSize )
    or.w       d5,d4                   ; D4 = Bob Width in bytes ( Bits 05-00 = W5-W0 in BltSize
    move.w     #%0000100111110000,BltCon0(a6) ; BltCon0 Set : USEA USED LF7 LF6 LF5 LF4
    clr.w      BltCon1(a6)             ; BltCon1 Set : Non (Are Mode)
GtBb5:
    move.l     (a1)+,a0                ; A0 = Current BitPlane (to read) Pointer
    add.l      d3,a0                   ; A0 = Exact position inside bitplane to start the copy of the Bob/Sprite
    move.l     a0,BltAdA(a6)           ; Blitter Source A Pointer
    move.w     d4,BltSize(a6)          ; BltSize = D4 = H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 W5 W4 W3 W2 W1 W0 = H9-H0 ->Bob Height, W5-W0 -> Bob Width
GtBb6:
    bsr        BlitWait                ; Wait for blitter to finish the copy
    dbra       d7,GtBB5                ; Next Bitplane, repeat until all planed bitplaes are copied.
    bra        GtBbX                   ; jump to GtBbX

******* Au pixel!
GtBc:
    move.w     #%0000010111001100,BltCon0(a6)
    moveq      #16,d1
    sub.w      d0,d1
    moveq      #12,d0
    lsl.w      d0,d1
    move.w     d1,BltCon1(a6)
    move.w     EcTligne(a5),d1
    ext.l      d1
    mulu       d1,d3
    lsr.w      #4,d2
    lsl.w      #1,d2
    ext.l      d2
    add.l      d2,d3
    lea        EcCurrent(a5),a1
    subq.l     #2,a2
    addq.w     #1,d4
    or.w       #%0000000001000000,d4
    subq.w     #1,d5
    ext.l      d6
    move.w     a4,d2
    lea        MCls(pc),a0
    move.w     0(a0,d2.w),d2
    bmi.s      GtBc1
    not.w      d2
GtBc1:
    move.l     (a1)+,a0
    add.l      d3,a0
    move.w     d5,d0
GtBc2:
    move.l     a0,BltAdB(a6)
    move.w     (a2),a4
    move.l     a2,BltAdD(a6)
    move.w     d4,BltSize(a6)
    move.l     a2,a5
    add.l      d1,a0
    add.l      d6,a2
GtBc3:
    bsr        BlitWait
    move.w     a4,(a5)
    and.w      d2,(a2)
    dbra       d0,GtBc2
    dbra       d7,GtBc1

******* FINI! Pas d''erreur
GtBbX: 
   bsr         DOwnBlit                ; Release Blitter
    movem.l    (sp)+,d1-d7/a0-a6       ; Load Regs
    moveq      #0,d0                   ; No error
    rts

******* Out of mem
GtBbE:
    movem.l    (sp)+,d1-d7/a0-a6
    moveq      #-1,d0
    rts

***********************************************************
*    INITIALISATION BOBS / D0= Nombre de bobs!
BbInit:
********
    clr.l    T_BbDeb(a5)
* Efface ce qui etait reserve
    move.w    d0,-(sp)
    bsr    BbEnd
    move.w    (sp)+,d1
* Reserve la memoire pour les tables priorites
    move.w    d1,T_BbMax(a5)
    ext.l    d1
    lsl.w    #2,d1
    move.l    d1,d0
    bsr    FastMm
    beq    GFatal
    move.l    d0,T_BbPrio(a5)
    move.l    d1,d0
    bsr    FastMm
    beq    GFatal
    move.l    d0,T_BbPrio2(a5)
    moveq    #0,d0
    rts

***********************************************************
*    FIN DES BOBS
BbEnd:
*******
    move.w    T_BbMax(a5),d1
    ext.l    d1
    lsl.l    #2,d1
    move.l    T_BbPrio(a5),d0
    beq.s    BOBE1
    move.l    d0,a1
    move.l    d1,d0
    bsr    FreeMm
BOBE1:    move.l    T_BbPrio2(a5),d0
    beq.s    BOBE2
    move.l    d0,a1
    move.l    d1,d0
    bsr    FreeMm
BOBE2:    moveq    #0,d0
    rts

***********************************************************
*    BOB X/Y
BobXY:    bsr    BobAd
    bne.s    BobxyE
    move.w    BbX(a1),d1
    move.w    BbY(a1),d2
    move.w    BbI(a1),d3
    moveq    #0,d0
BobxyE:    rts

***********************************************************
*    PATCH BOB / ICON
*    Dessine simplement un bob/icon
*    A1-    Buffer de calcul
*    A2-    Descripteur bob/icon
*    D1-    Image retournee???
*    D2/D3-    Coordonnees
*    D4-    Minterms (0 si rien)
*    D5-    APlan
TPatch
    movem.l    d1-d7/a0-a6,-(sp)
    move.l    a1,a4
* Va retourner le bob
    move.l    a2,a0
    move.w    d1,d0
    and.w    #$C000,d0
    bsr    Retourne
* Parametres de l'ecran courant
    move.l    T_EcCourant(a5),a0    * Calculssss
    move.w    EcClipX0(a0),d0
    and.w    #$FFF0,d0
    move.w    d0,BbLimG(a4)
    move.w    EcClipY0(a0),BbLimH(a4)
    move.w    EcClipX1(a0),d0
    add.w    #15,d0
    and.w    #$FFF0,d0
    move.w    d0,BbLimD(a4)
    move.w    EcClipY1(a0),BbLimB(a4)
    tst.w    d4
    beq.s    Patch1
    and.w    #$00FF,d4
    bset    #15,d4
Patch1    move.w    d4,BbACon(a4)
    move.w    d5,BbAPlan(a4)
    move.l    a0,BbEc(a4)
    exg.l    d3,d1
    bset    #31,d3            * Flag PAS POINT CHAUD!
    bsr    BobCalc
    bne.s    PatchO
* Gestion de l'autoback
    move.l    T_EcCourant(a5),a0
    tst.w    EcAuto(a0)
    beq.s    Patch2
    bsr    TAbk1
    bsr    PBobA
    bsr    TAbk2
    bsr    PBobA
    bsr    TAbk3
    bra.s    PatchO
Patch2    bsr    PBobA
* Fini!
PatchO    moveq    #0,d0
    movem.l    (sp)+,d1-d7/a0-a6
    rts
* Appelle la routine d'affichage
PBobA    lea    Circuits,a6
    bsr    OwnBlit
    move.w    BbASize(a4),d2
    move.w    BbTPlan(a4),d4
    ext.l    d4
    move.l    BbAData(a4),a0
    move.l    BbEc(a4),a3
    lea    EcCurrent(a3),a3
    move.w    BbAModD(a4),d0
    move.w    d0,BltModC(a6)
    move.w    d0,BltModD(a6)
    move.l    BbADraw(a4),a2
    move.l    BbAMask(a4),d5
    jsr    (a2)
    bsr    BlitWait
    bra    DOwnBlit

***********************************************************
*    CREATION / CHANGEMENT D'UN BOB
*    D1= Numero du CANAL
*    D2= X
*    D3= Y
*    D4= Image
*    D5= MODE DECOR
*    D6= Plans affiches
*    D7= Minterms
BobSet:
********
    cmp.w    T_BbMax(a5),d1
    bcc    CreBbS

******* Ecris sur l'ancienne - SI PRESENT -
    move.l    a1,a0
    move.l    T_BbDeb(a5),d0
    beq.s    CreBb1
CreBb0:    move.l    d0,a1
    cmp.w    BbNb(a1),d1
    beq.s    CreBb5
    bcs.s    CreBb2
    move.l    BbNext(a1),d0
    bne.s    CreBb0
* Met a la fin!
    bsr    ResBOB
    bne    CreBbE
    move.l    a1,BbPrev(a0)
    move.l    a0,BbNext(a1)
    move.l    a0,a1
    bra.s    CreBb5
* Au tout debut
CreBb1:    bsr    ResBOB
    bne    CreBbE
    move.l    a0,T_BbDeb(a5)
    move.l    a0,a1
    bra.s    CreBb5
* Insere la nouvelle
CreBb2:    bsr    ResBOB
    bne    CreBbE
    move.l    BbPrev(a1),d0
    move.l    a0,BbPrev(a1)
    move.l    d0,BbPrev(a0)
    bne.s    CreBb3
    move.l    T_BbDeb(a5),d1
    move.l    a0,T_BbDeb(a5)
    bra.s    CreBb4
CreBb3:    move.l    d0,a2
    move.l    BbNext(a2),d1
    move.l    a0,BbNext(a2)
CreBb4:    move.l    d1,BbNext(a0)
    move.l    a0,a1
* Poke les coordonnees
CreBb5:    move.l    #EntNul,d7
    move.b    BbAct(a1),d6
    bmi.s    CreBb9
    cmp.l    d7,d2
    beq.s    CreBb6
    move.w    d2,BbX(a1)
    bset    #1,d6
CreBb6:    cmp.l    d7,d3
    beq.s    CreBb7
    move.w    d3,BbY(a1)
    bset    #2,d6
CreBb7:    cmp.l    d7,d4
    beq.s    CreBb8
    move.w    d4,BbI(a1)
    bset    #0,d6
CreBb8:    move.b    d6,BbAct(a1)
* Doit actualiser les bob
CreBb9:    bset    #BitBobs,T_Actualise(a5)
    moveq    #0,d0
    rts
******* Erreur!
CreBbS:    moveq    #1,d0
CreBbE:    tst.w    d0
    rts

******* CREATION DE LA TABLE!
ResBOB:    move.l    #BbLong,d0
    bsr    FastMm
    beq.s    ResBErr
    move.l    d0,a0
    move.w    d1,BbNb(a0)
    move.l    T_EcCourant(a5),a2
    move.l    a2,BbEc(a0)
    move.w    EcTx(a2),BbLimD(a0)
    move.w    EcTy(a2),BbLimB(a0)
    move.w    d6,BbAPlan(a0)
    and.w    #$00FF,d7
    beq.s    ResBb0
    bset    #15,d7
ResBb0    move.w    d7,BbACon(a0)
    move.w    #$01,BbDecor(a0)
    btst    #BitDble,EcFlags(a2)
    beq.s    ResBb1
    addq.w    #1,BbDecor(a0)
    move.w    #Decor,BbDCur2(a0)
ResBb1:    tst.w    d5
    bpl.s    ResBb2
    clr.w    BbDecor(a0)
ResBb2:    move.w    d5,BbEff(a0)
    moveq    #0,d0
    rts
* Erreur memoire!
ResBErr    moveq    #-1,d0
    rts

***********************************************************
*    BOB OFF d1=#
BobOff:
*******
    move.l    T_BbDeb(a5),d0
    beq.s    DBb2
DBb1:    move.l    d0,a1
    cmp.w    BbNb(a1),d1
    beq.s    DBb3
    bcs.s    DBb2
    move.l    BbNext(a1),d0
    bne.s    DBb1
DBb2:    moveq    #1,d0
    rts
DBb3:    move.b    #-1,BbAct(a1)
    bset    #BitBobs,T_Actualise(a5)
    moveq    #0,d0
    rts
***********************************************************
*    ARRET TOUS LES BOBS
BobSOff:
*******
    movem.l    d0/a1/a2,-(sp)
    move.l    T_BbDeb(a5),d0
    beq.s    DBbs2
DBbs1:    move.l    d0,a1
    move.b    #-1,BbAct(a1)
    move.l    BbNext(a1),d0
    bne.s    DBbs1
DBbs2:    bset    #BitBobs,T_Actualise(a5)
    movem.l    (sp)+,d0/a1/a2
    moveq    #0,d0
    rts

***********************************************************
*    LIMIT BOB tous, Ecran courant!
*    D1= # ou -1, D2/D3->D4/D5
BobLim:
*******
    movem.l    d2-d7,-(sp)
    move.l    T_BbDeb(a5),d0
    beq    LBbX
* Verifie les coordonnees
    move.l    T_EcCourant(a5),d6
    move.l    d6,a0
    move.l    #EntNul,d7
    cmp.w    d7,d2
    bne.s    LBba
    clr.w    d2
LBba:    cmp.w    d7,d3
    bne.s    LBbb
    clr.w    d3
LBbb:    cmp.w    d7,d4
    bne.s    LBbc
    move.w    EcTx(a0),d4
LBbc:    cmp.w    d7,d5
    bne.s    LBbd
    move.w    EcTy(a0),d5
LBbd:    and.w    #$FFF0,d2
    and.w    #$FFF0,d4
    cmp.w    d2,d4
    bls.s    LbbE
    cmp.w    d2,d5
    bls.s    LbbE
    cmp.w    EcTx(a0),d4
    bhi.s    LbbE
    cmp.w    EcTy(a0),d5
    bhi.s    LbbE
* Change les bobs!
LBb1:    move.l    d0,a1
    tst.w    BbAct(a1)
    bmi.s    LBb3
    cmp.l    BbEc(a1),d6
    bne.s    LBb3
    tst.w    d1
    bmi.s    LBb2
    cmp.w    BbNb(a1),d1
    bhi.s    LBb3
    bcs.s    LBbX
LBb2:    move.w    d2,BbLimG(a1)
    move.w    d3,BbLimH(a1)
    move.w    d4,BbLimD(a1)
    move.w    d5,BbLimB(a1)
    bset    #0,BbAct(a1)            ***Bug?
    bset    #BitBobs,T_Actualise(a5)
LBb3:    move.l    BbNext(a1),d0
    bne.s    LBb1
LBbX:    moveq    #0,d0
LBbXx    movem.l    (sp)+,d2-d7
    rts
LBbE:    moveq    #-1,d0
    bra.s    LBbXx

***********************************************************
*    PRIORITY ON/OFF
*    D1= on/off - Ecran courant (-1 indet)
*    D2= normal - reversed      (-1 indet)
TPrio    tst.l    d1
    bmi.s    TPri2
    beq.s    TPri1
    move.l    T_EcCourant(a5),d1
TPri1    move.l    d1,T_Priorite(a5)
TPri2    tst.l    d2
    bmi.s    TPri3
    move.w    d2,T_PriRev(a5)
TPri3    moveq    #0,d0
    rts

***********************************************************
*    ENLEVE LES BOBS D'UN ECRAN!
*    A0= Ecran
BbEcOff:
********
    movem.l    d1-d7/a0/a1,-(sp)
    move.l    a0,d7
    move.l    T_BbDeb(a5),d0
    beq.s    BbEO2
BbEO1:    move.l    d0,a1
    cmp.l    BbEc(a1),d7
    beq.s    BbEO3
    move.l    BbNext(a1),d0
    bne.s    BbEO1
BbEO2:    movem.l    (sp)+,d1-d7/a0/a1
    moveq    #0,d0
    rts
******* Enleve le bob!
BbEO3:    move.l    BbNext(a1),d0
    bsr    DelBob
* Encore?
    tst.l    d0
    bne.s    BbEO1
    bra.s    BbEO2

******* Efface la definition du bob (A1)
DelBob:    movem.l    d0-d7/a0-a2,-(sp)
    move.l    a1,a2

* Enleve les buffers de decor, s'il y en a!
    moveq    #0,d0
    move.w    BbDLBuf(a2),d0
    beq.s    DBo1
    lsl.l    #1,d0
    move.l    BbDABuf(a2),a1
    bsr    FreeMm
DBo1:    moveq    #0,d0
    move.w    BbDLBuf+Decor(a2),d0
    beq.s    DBo2
    lsl.l    #1,d0
    move.l    BbDABuf+Decor(a2),a1
    bsr    FreeMm
* Enleve le canal d'animation
DBo2:    lea    BbAct(a2),a0    
    bsr    DAdAMAL
* Enleve le bob
    move.l    BbNext(a2),d3
    move.l    BbPrev(a2),d2
    beq.s    DBo3
    move.l    d2,a0
    move.l    d3,BbNext(a0)
    bra.s    DBo4
DBo3:    move.l    d3,T_BbDeb(a5)
DBo4:    tst.l    d3
    beq.s    DBo5
    move.l    d3,a0
    move.l    d2,BbPrev(a0)
DBo5:    move.l    a2,a1
    move.l    #BbLong,d0
    bsr    FreeMm

    movem.l    (sp)+,d0-d7/a0-a2
    rts

***********************************************************
*    ADRESSE D'UN BOB: D1= Numero!
BobAd:
*******
    move.l    T_BbDeb(a5),d0
    beq.s    AdBb1
AdBb0:    move.l    d0,a1
    cmp.w    BbNb(a1),d1
    beq.s    AdBb2
    bcs.s    AdBb1
    move.l    BbNext(a1),d0
    bne.s    AdBb0
AdBb1    moveq    #1,d0
AdBb2    rts

***********************************************************
*    PUT BOB n
BobPut:    bsr    BobAd
    bne.s    BbPx
    move.w    BbDecor(a1),BbECpt(a1)
    moveq    #0,d0
BbPx:    rts

***********************************************************
*    ACTUALISATION DES BOBS
*******
BobAct:    movem.l    d2-d7/a2-a6,-(sp)
    move.l    T_BbPrio(a5),a3
* Banque de sprites chargee?
    move.l    T_SprBank(a5),d0
    beq    BbSx
    move.l    d0,a6
******* Explore les bobs!
    move.l    T_BbDeb(a5),d0
    beq    BbSx
    clr.w    -(sp)
    move.l    T_Priorite(a5),-(sp)
    move.l    T_BbPrio2(a5),a5
BbS0:    move.l    d0,a4
* Flippe les decors!
    move.w    BbDCur2(a4),d4
    move.w    BbDCur1(a4),BbDCur2(a4)
    move.w    d4,BbDCur1(a4)
* Bob modifie?
    tst.w    BbECpt(a4)        * Si PUT BOB---> Pas d'act!
    bne.s    BbSDec
    tst.b    BbAct(a4)
    beq    BbSDec
    bmi    BbDel
    clr.b    BbAct(a4)
    move.w    BbI(a4),d2        * Pointe l'image
    moveq    #0,d3
    move.w    d2,d3
    and.w    #$C000,d3
    move.w    d3,BbRetour(a4)
    and.w    #$3FFF,d2
    beq    BbSort
    cmp.w    (a6),d2
    bhi    BbSort
    lsl.w    #3,d2
    lea    -8+2(a6,d2.w),a2
    tst.l    (a2)
    beq    BbSort
    move.l    a2,BbARetour(a4)
    move.w    BbX(a4),d2        * Coordonnees
    move.w    BbY(a4),d1
    move.l    BbEc(a4),a0        * Ecran
    bsr    BobCalc
    bne    BbSort

******* Sauvegarde du decor!
BbSDec:    move.w    BbDecor(a4),d0
    beq    BbSN
    move.w    BbESize(a4),d1
    beq    BbSort
* Stocke les parametres
    move.w    d0,BbDCpt(a4)
    move.w    BbDCur1(a4),d0
    lea    0(a4,d0.w),a2
    move.w    d1,BbDASize(a2)
    move.w    BbEMod(a4),BbDMod(a2)
    move.w    BbAPlan(a4),BbDAPlan(a2)
    move.w    BbEAEc(a4),BbDAEc(a2)
    move.w    BbNPlan(a4),d1
    move.w    d1,BbDNPlan(a2)
    tst.w    BbEff(a4)        * Effacement en couleurs?
    bne.s    BbSN
    addq.w    #1,d1
    mulu    BbETPlan(a4),d1        * Taille du buffer
    moveq    #0,d0
    move.w    BbDLBuf(a2),d0
    beq.s    BbD4
    lsl.l    #1,d0
    cmp.l    d0,d1            * Taille suffisante?
    bls.s    BbD5
* Efface l'ancien buffer?
    move.l    BbDABuf(a2),a1
    bsr    FreeMm
    clr.l    BbDABuf(a2)
    clr.w    BbDLbuf(a2)
* Reserve le nouveau!
BbD4:    move.l    d1,d0
    bsr    ChipMm
    beq.s    BbD5
    move.l    d0,BbDABuf(a2)
    lsr.l    #1,d1
    move.w    d1,BbDLBuf(a2)
* Ok!
BbD5:    bra    BbSN

******* BOB ARRETE
BbDel:    subq.w    #1,BbDecor(a4)        * Compte le nombre de REDRAW
    bhi.s    BbSort
* Efface!
    move.l    BbNext(a4),d0
    move.l    a4,a1
    move.l    a5,-(sp)
    move.l    W_Base(pc),a5
    bsr    DelBob
    move.l    (sp)+,a5
    tst.l    d0
    bne    BbS0
    bra.s    BbBug

******* Calcul des priorites
BbSN:    move.l    BbEc(a4),d0
    cmp.l    (sp),d0
    bne.s    BbPrX
* Priorite!
    move.l    a4,(a5)+
    addq.w    #1,4(sp)
    bra.s    BbSort
* Pas de priorite
BbPrX    move.l    a4,(a3)+
******* En dehors!
BbSort:    move.l    BbNext(a4),d0
    bne    BbS0
BbBug
******* Classe les bobs...
    move.l    W_Base(pc),a5
    addq.l    #4,sp
    move.w    (sp)+,d6
    beq.s    BbSx
    subq.w    #1,d6
* Recopie dans la liste
    move.l    a3,a4
    move.l    T_BbPrio2(a5),a0
    move.w    d6,d0
BbPr1    move.l    (a0)+,(a3)+
    dbra    d0,BbPr1
    subq.w    #1,d6
    bmi.s    BbSx
* Classe (a bulle!)
BbPr2    moveq    #0,d1
    move.w    d6,d2
    move.l    a4,a2
    move.l    (a2)+,a0
BbPr3    move.l    (a2)+,a1
    move.w    BbY(a0),d0        * Compare
    cmp.w    BbY(a1),d0
    blt.s    BbPr5
    bne.s    BbPr4
    move.w    BbX(a0),d0
    cmp.w    BbX(a1),d0
    ble.s    BbPr5
BbPr4    exg    a0,a1
    move.l    a0,-8(a2)
    move.l    a1,-4(a2)
    addq.w    #1,d1
BbPr5    move.l    a1,a0
    dbra    d2,BbPr3
    tst.w    d1
    bne.s    BbPr2
* Renverser la table???
BbSx:    clr.l    (a3)
    tst.w    T_PriRev(a5)
    beq.s    BbSxX
* Renverse la table!!!
    move.l    T_BbPrio(a5),a0
    cmp.l    a3,a0
    bcc.s    BbSxX
BbSRv    move.l    (a0),d0
    move.l    -(a3),(a0)+
    move.l    d0,(a3)
    cmp.l    a3,a0
    bcs.s    BbSRv
* Fini!
BbSxX    movem.l    (sp)+,d2-d7/a2-a6
    rts

******* ROUTINE DE CALCUL DES PARAMS AFFICHAGE BOB/BLOC
*    A0->     Ecran
*    A2->     Descripteur image
*    A4->     Buffer calcul
*    D2->     X
*    D1->    Y
*     D3->     Flags retournement
BobCalc    move.l    (a2),a1
    tst.l    4(a2)
    bne.s    BbS1
* Va calculer le masque!
    bsr    Masque
    bne    BbSOut
* Point chaud retourne?
BbS1:    tst.l    d3
    bmi.s    BbHt3
    move.w    6(a1),d0
    move.w    d0,d4
    lsl.w    #2,d4
    asr.w    #2,d4
    move.w    8(a1),d5
    eor.w    d0,d3
* En Y?
    btst    #14,d3
    beq.s    BbHt1
    neg.w    d5
    add.w    2(a1),d5
* En X?
BbHt1    btst    #15,d3
    beq.s    BbHt2
    move.w    (a1),d0
    lsl.w    #4,d0
    sub.w    d4,d0
    move.w    d0,d4
BbHt2    sub.w    d5,d1
    sub.w    d4,d2
* Nombre de plans    
BbHt3    move.w    4(a1),d0
    cmp.w    EcNPlan(a0),d0
    bls.s    BbS1a
    move.w    EcNPlan(a0),d0
BbS1a:    subq.w    #1,d0
    move.w    d0,BbNPlan(a4)
    clr.w    BbESize(a4)
* Mots de controle?
    tst.w    BbACon(a4)
    beq.s    BbS1b
    bpl.s    BbS1d
    move.w    BbACon(a4),d0        * MASQUER le minterm
    bclr    #15,d0
    or.w    #%0000111100000000,d0
    tst.l    4(a2)
    bpl.s    BbS1c
    and.w    #%0000011111111111,d0
    bra.s    BbS1c
BbS1b    move.w    #%0000111111001010,d0    * FAIRE le minterm
    tst.l    4(a2)
    bpl.s    BbS1c
    move.w    #%0000011111001010,d0
BbS1c    move.w    d0,BbACon(a4)
BbS1d    move.w    d2,d0
    and.w    #$F,d2
    beq    BbND

******* DECALES!
    lsl.w    #8,d2            * Registres de controle
    lsl.w    #4,d2
    move.w    d2,BbACon1(a4)
    or.w    BbACon(a4),d2
    move.w    d2,BbACon0(a4)

    move.w    (a1),d4            * Taille en X
    lsl.w    #1,d4
    move.w    d4,d3
    move.w    2(a1),d5        * Taille en Y
    move.w    d4,d2
    mulu    d5,d2
    move.w    d2,BbTPLan(a4)        * Taille plan!
    add.w    d5,d2
    add.w    d5,d2
    move.w    d2,BbETPlan(a4)        * Effacement: prend les bords!

    move.w    d5,d2
    add.w    d1,d2
    cmp.w    BbLimB(a4),d2        * Limite en BAS!
    ble    BbDe2
    sub.w    BbLimB(a4),d2
    sub.w    d2,d5
    bls    BbSOut
BbDe2:    
    moveq    #0,d7
    cmp.w    BbLimH(a4),d1        * Teste la limite en HAUT!
    bge.s    BbDe1
    sub.w    BbLimH(a4),d1
    neg.w    d1
    sub.w    d1,d5
    bls    BbSOut
    move.w    d1,d7
    mulu    d4,d7
    move.w    BbLimH(a4),d1
BbDe1:    
    move.w    EcTLigne(a0),d2
    move.w    d2,d6
    mulu    d1,d6

    lsl.w    #3,d4
    move.w    d4,d1
    add.w    d0,d1
    clr.w    BbAMaskD(a4)
    cmp.w    BbLimD(a4),d1        * Teste la limite a DROITE
    ble.s    BbDe4
    sub.w    BbLimD(a4),d1
    and.w    #$FFF0,d1
    add.w    #16,d1
    sub.w    d1,d4
    bmi    BbSOut
    move.w    d0,d1
    and.w    #$000F,d1
    lsl.w    #1,d1
    lea    MCls2(pc),a0
    move.w    0(a0,d1.w),d1
    not.w    d1
    move.w    d1,BbAMaskD(a4)
BbDe4:    
    moveq    #-1,d1
    cmp.w    BbLimG(a4),d0        * Teste la limite a GAUCHE
    bge.s    BbDe3
    move.w    d0,d1
    sub.w    BbLimG(a4),d0
    neg.w    d0
    sub.w    d0,d4
    bls    BbSOut
    add.w    #16,d4
    lsr.w    #4,d0
    lsl.w    #1,d0
    add.w    d0,d7
    bset    #31,d7
    subq.l    #2,d6
    lea    MCls2(pc),a0        * Masque a gauche
    and.w    #$000F,d1
    lsl.w    #1,d1
    move.w    0(a0,d1.w),d1
    move.w    BbLimG(a4),d0
BbDe3:    move.w    d1,BbAMaskG(a4)
    add.w    #16,d4

    lsr.w    #4,d0            * Adresse ecran
    lsl.w    #1,d0
    ext.l    d0            BUG !
    add.l    d0,d6
    lsr.l    #1,d6
    move.w    d6,BbAAEc(a4)

    lsr.w    #4,d4            * Modulo ecran
    move.w    d4,d0
    lsl.w    #1,d4
    sub.w    d4,d3
    move.w    d3,BbAModO(a4)
    sub.w    d4,d2
    move.w    d2,BbAModD(a4)

    move.w    d0,d1
    lea    BbAP(pc),a0
    tst.l    d7    
    bpl.s    BbDe5
    addq.w    #1,d6            Suite BUG ! 
    subq.w    #1,d1
    addq.w    #2,d2
    bne.s    BbDe5
    lea    BbAL(pc),a0
BbDe5:    lsl.w    #6,d5
    or.w    d5,d1
    move.w    d1,BbESize(a4)
    or.w    d5,d0    
    move.w    d0,BbASize(a4)
    move.w    d2,BbEMod(a4)
    move.w    d6,BbEAEc(a4)
    move.l    a0,BbADraw(a4)

    move.l    4(a2),a2        * Adresses bob
    lea    4(a2,d7.w),a2
    move.l    a2,BbAMask(a4)
    lea    10(a1,d7.w),a2
    move.l    a2,BbAData(a4)

    moveq    #0,d0
    rts

* Sortie
BbSOut    moveq    #-1,d0
    rts

* NON DECALES: Teste limites en H G
BbND:    move.w    d0,d2
    move.w    d1,d3
    moveq    #0,d4
    moveq    #0,d5
    cmp.w    BbLimG(a4),d0
    bge.s    BbS2
    move.w    BbLimG(a4),d4
    sub.w    d0,d4
    lsr.w    #4,d4
    move.w    BbLimG(a4),d0
BbS2:    cmp.w    BbLimH(a4),d1
    bge.s    BbS3
    move.w    BbLimH(a4),d5
    sub.w    d1,d5
    move.w    BbLimH(a4),d1
BbS3:    lsr.w    #4,d0
    lsl.w    #1,d0
    ext.l    d0            BUG !
    mulu    EcTLigne(a0),d1
    add.l    d0,d1
    lsr.l    #1,d1
    move.w    d1,BbAAEc(a4)
    move.w    d1,BbEAEc(a4)
    move.w    (a1),d6
    move.w    2(a1),d7
    move.w    d6,d0
    lsl.w    #1,d0
    move.w    d0,d1
    mulu    d7,d1
    move.w    d1,BbTPlan(a4)
    move.w    d1,BbETPlan(a4)
    mulu    d5,d0
    add.w    d4,d0
    add.w    d4,d0
    move.l    4(a2),a2
    lea    4(a2,d0.w),a2
    move.l    a2,BbAMask(a4)
    lea    10(a1,d0.w),a2
    move.l    a2,BbAData(a4)

    move.w    BbACon(a4),BbACon0(a4)
    clr.w    BbACon1(a4)
    move.w    d6,d0
    lsl.w    #4,d0
    add.w    d0,d2
    add.w    d7,d3
    move.w    d6,d0
    move.w    d7,d1
    cmp.w    BbLimD(a4),d2
    ble.s    BbS4
    sub.w    BbLimD(a4),d2
    lsr.w    #4,d2
    sub.w    d2,d0
BbS4:    cmp.w    BbLimB(a4),d3
    ble.s    BbS5
    sub.w    BbLimB(a4),d3
    sub.w    d3,d1
BbS5:    sub.w    d4,d0
    ble    BbSOut
    sub.w    d5,d1
    ble    BbSout
    sub.w    d0,d6
    lsl.w    #1,d6
    move.w    d6,BbAModO(a4)
    move.w    EcTLigne(a0),d6
    sub.w    d0,d6
    sub.w    d0,d6
    move.w    d6,BbAModD(a4)
    move.w    d6,BbEMod(a4)
    lsl.w    #6,d1
    or.w    d1,d0
     move.w    d0,BbASize(a4)
    move.w    d0,BbESize(a4)
    lea    BbA16(pc),a0
    move.l    a0,BbADraw(a4)
    moveq    #0,d0
    rts

***********************************************************
*    RETOURNEUR DE SPRITES!

******* Initialisation: fabrique la table
RbInit    lea    TRetour(pc),a0
        moveq     #0,d0
IRet1:  moveq     #7,d3
        move.b     d0,d1
IRet2:  lsr.b     #1,d1
        roxl.b     #1,d2
        dbra     d3,IRet2
        move.b     d2,(a0)+
        addq.b     #1,d0
        bne.s     IRet1
    rts
******* Fin, libere la memoire
RbEnd    rts

******* Entree trappe
*    A1/D0
RevTrap    move.l    a1,a0
    move.l    d1,d0
******* Retourne un sprite, s'il faut.
*    A0---> Descripteur
*    D0---> Flags seuls
Retourne
    move.l    (a0),d1
    beq.s    RetBobX
    move.l    d1,a1
    move.w    6(a1),d1
    and.w    #$C000,d1
    eor.w    d0,d1
    beq.s    RetBobX
* En X?
    btst    #15,d1
    beq.s    RetBb1
    bsr    RBobX
* En Y?
RetBb1    btst    #14,d1
    beq.s    RetBb2
    bsr    RBobY    
* Poke les flags
RetBb2    move.w    6(a1),d1
    and.w    #$3FFF,d1
    or.w    d0,d1
    move.w    d1,6(a1)
* Ca y est!
RetBobX    rts

******* Retourne le bob en X
RBobX    movem.l a0-a3/d0-d7,-(sp)
* Retourne le point chaud
    move.w    6(a1),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    move.w    (a1),d6
    move.w    d6,d1
    lsl.w    #4,d1
    sub.w    d0,d1
    move.w    d1,6(a1)
* Retourne le dessin
    moveq    #0,d0
    moveq    #0,d1
    lea    TRetour(pc),a3
    move.w    2(a1),d7
    move.w    4(a1),d3
    lea    10(a1),a1
    move.l    a0,-(sp)
    bsr    RBbX
    move.l    (sp)+,a0
* Retourne le masque
    move.l    4(a0),d2
    ble.s    RBobXx
    move.l    d2,a1
    addq.l    #4,a1
    moveq    #0,d3
    bsr    RBBis
* Fini
RBobXx    movem.l (sp)+,a0-a3/d0-d7
    rts
******* Retourne le bob en Y
RBobY    movem.l a0-a2/d0-d7,-(sp)
* Retourne le point chaud
    move.w    2(a1),d7
    move.w    d7,d0
    sub.w    8(a1),d0
    move.w    d0,8(a1)
* Retourne le dessin
    move.w    (a1),d6
    move.w    4(a1),d5
    lea    10(a1),a1
    move.l    a0,-(sp)
    bsr    RBbY
    move.l    (sp)+,a0
* Retourne le masque
    move.l    4(a0),d0
    ble.s    RBobYx
    move.l    d0,a1
    addq.l    #4,a1
    moveq    #0,d5
    bsr    RBbY1
* Fini
RBobYx    movem.l (sp)+,a0-a2/d0-d7
    rts

************************
* Retourne en X
* A1-> Ad plan
* D7-> Ty
* D6-> Tx
* D3-> Nb plans
RBbX    subq.w    #1,d7        * Base cpt Y
    subq.w    #1,d3        * Cpt nombre de plans
    moveq    #0,d4
    move.w    d6,d4
    lsr.w    #1,d6
    subq.w    #1,d6
    move.w    d6,a2        * Base cpt en X    
RBBis    btst    #0,d4
    bne.s    RBbI0
* Nombre PAIR de plans
RBbx0    move.w    d7,d5        * Cpt Y
RBbx1    add.l    d4,a1
    move.l    a1,a0
    move.w    a2,d6
RBbx2    move.b    -(a0),d0
    move.b     (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    move.b     -(a0),d0
    move.b    (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    dbra    d6,RBbx2
    dbra    d5,RBbX1
    dbra    d3,RBbX0
    rts
* Nombre IMPAIR de plans
RBbI0    move.w    d7,d5        * Cpt Y
RBbI1    add.l    d4,a1
    move.l    a1,a0
    move.b    -(a0),d0
    move.b     (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    move.w    a2,d6
    bmi.s    RBbI3
RBbI2    move.b    -(a0),d0
    move.b     (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    move.b     -(a0),d0
    move.b    (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    dbra    d6,RBbI2
RBbI3    dbra    d5,RBbI1
    dbra    d3,RBbI0
    rts

************************
* Retournement VERTICAL
* D5= NPlan
* D6= TX
* D7= TY
RBbY       move.w  d6,d4
        lsl.w   #1,d4
        ext.l   d4
        move.w  d7,d3
        lsr.w   #1,d3
        mulu    d4,d3
    move.l    d4,d2
        lsr.w   #1,d7
        bcc.s   RBbY0
    add.l    d4,d2
        add.l   d4,d3
RBbY0   neg.l    d2
    subq.w  #1,d7
        move.w  d7,a2
        subq.w  #1,d6
    subq.w    #1,d5
    lsl.w    #1,d4
* Boucle de retournement
RBbY1   add.w   d3,a1
        lea     0(a1,d2.w),a0
        move.w  a2,d7
RBbY2   move.w  d6,d1
RBbY3   move.w  (a1),d0
        move.w  (a0),(a1)+
        move.w  d0,(a0)+
        dbra    d1,RBbY3
        sub.l   d4,a0
        dbra    d7,RBbY2
        dbra    d5,RBbY1
        rts

***********************************************************
*    CALCUL DU MASQUE, 1 MOT BLANC A DROITE!
*    A2= descripteur
Masque:    
*******
    movem.l    d1-d7/a0-a2,-(sp)
    move.l    (a2),a1
    move.w    (a1),d2
    lsl.w    #1,d2
    mulu    2(a1),d2        * D2= Taille plan
    move.l    d2,d3            
    addq.l    #4,d3            * D3= Taille memoire
    move.w    4(a1),d4        
    subq.w    #2,d4            * D4= Nb de plans
    move.w    d2,d5
    lsr.w    #1,d5
    subq.w    #1,d5
* Reserve la memoire pour le masque        
    move.l    4(a2),d0
    bne.s    Mas0
MasM    move.l    d3,d0
    bsr    ChipMm2
    beq.s    MasErr
    move.l    d0,4(a2)
* Calcule le masque
Mas0:    bmi.s    MasM
    move.l    d0,a2            * Adresse du masque
    move.l    d3,(a2)+        * Taille du masque
    lea    10(a1),a1        * Pointe le premier plan
Mas2:    move.l    a1,a0
    move.w    (a0),d0
    move.w    d4,d3
    bmi.s    Mas4
Mas3:    add.l    d2,a0
    or.w    (a0),d0
    dbra    d3,Mas3
Mas4:    move.w    d0,(a2)+
    addq.l    #2,a1
    dbra    d5,Mas2
* Pas d'erreur
    movem.l    (sp)+,d1-d7/a0-a2
    moveq    #0,d0
    rts
* Erreur!
MasErr:    movem.l    (sp)+,d1-d7/a0-a2
    moveq    #-1,d0
    rts
    
******************************************************** 
*    EFFACEMENT DE TOUS LES BOBS DES ECRANS
********
BobEff:    movem.l    d2-d7/a2-a6,-(sp)
    lea    Circuits,a6
    move.l    T_BbDeb(a5),d0
    beq    BbExX

******* Initialise le blitter
    bsr    OwnBlit
    move.w    #0,BltModA(a6)
    move.w    #0,BltCon1(a6)
    moveq    #-1,d1
    move.w    d1,BltMaskG(a6)
    move.w    d1,BltMaskD(a6)

******* Explore la liste des bobs
BbE0:    move.l    d0,a5
    tst.w    BbECpt(a5)            * Compteur PUT BOB
    bne.s    BbE5
    move.l    BbEc(a5),a3
    lea    EcLogic(a3),a3
    move.w    BbDCur2(a5),d4
    lea    0(a5,d4.w),a4

    move.w    BbDASize(a4),d2            * D2= BltSize
    beq.s    BbE4
    move.w    BbDAEc(a4),d3            * D3= Decalage ecran    
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbEff(a5),d4
    bne.s    BbEFc

* Effacement NORMAL
    tst.l    BbDABuf(a4)
    beq.s    BbE4
    move.w    BbDAPlan(a4),d1
    move.w    BbDNPlan(a4),d0
    bsr    BlitWait
    move.w    BbDMod(a4),BltModD(a6)
    move.l    BbDABuf(a4),BltAdA(a6)        * Adresse buffer
    move.w    #%0000100111110000,BltCon0(a6)
BbE1:    lsr.w    #1,d1
    bcc.s    BbE3
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BbE3:    addq.l    #4,a3
    dbra    d0,BbE1
* Un autre?
BbE4:    move.l    BbNext(a5),d0
    bne.s    BbE0
    bra.s    BbEx
BbE5:    subq.w    #1,BbECpt(a5)
    bne.s    BbE4
    bra.s    BbE4

* Effacement COLORE!
BbEfC:    subq.w    #1,d4
    move.w    BbDAPlan(a4),d1
    move.w    BbDNPlan(a4),d0
    bsr    BlitWait
    move.w    BbDMod(a4),BltModD(a6)
    move.w    #%0000000111110000,BltCon0(a6)
    moveq    #0,d5
BbEfc1:
    lsr.w    #1,d4
    subx.w    d5,d5
    lsr.w    #1,d1
    bcc.s    BbEfc4
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.w    d5,BltDatA(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BbEfc4:    addq.l    #4,a3
    moveq    #0,d5
    dbra    d0,BbEfc1
* Un autre?
    move.l    BbNext(a5),d0
    bne    BbE0

* FINI: remet le blitter
BbEx:    bsr    BlitWait
    bsr    DOwnBlit
BbExX:    movem.l    (sp)+,d2-d7/a2-a6
    rts    

******************************************************** 
*    SAISIE  ET DESSIN DE TOUS LES BOBS
********
BobAff    movem.l    d2-d7/a2-a6,-(sp)
    lea    Circuits,a6
    bsr    OwnBlit
    
******* SAISIE
    move.l    T_BbDeb(a5),d0
    beq    BbGx
* Initialise le blitter
    move.w    #0,BltModD(a6)
    move.w    #%0000100111110000,BltCon0(a6)
    move.w    #0,BltCon1(a6)
    moveq    #-1,d1
    move.w    d1,BltMaskG(a6)
    move.w    d1,BltMaskD(a6)

* Explore les bobs
BbG0:    move.l    d0,a5
    tst.w    BbDCpt(a5)            * Nombre de saisies
    beq.s    BbG4
    tst.w    BbEff(a5)            * Decor colore?
    bne.s    BbG4

    move.l    BbEc(a5),a3            * Adresse ecran
    lea    EcLogic(a3),a3
    move.w    BbDCur1(a5),d4
    lea    0(a5,d4.w),a4
    tst.l    BbDABuf(a4)            * Adress buffer 0?
    beq.s    BbG4
    move.w    BbDASize(a4),d2            * D2= BltSize
    beq.s    BbG4
    subq.w    #1,BbDCpt(a5)            * Une saisie de moins

    move.w    BbDAEc(a4),d3            * D3= Decalage ecran    
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbDAPlan(a4),d1
    move.w    BbDNPlan(a4),d0

    bsr    BlitWait
    move.l    BbDABuf(a4),d7
    move.l    d7,BltAdD(a6)            * Adresse buffer
    move.w    BbDMod(a4),BltModA(a6)
BbG1:    lsr.w    #1,d1
    bcc.s    BbG3
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a2,BltAdA(a6)
    move.w    d2,BltSize(a6)
BbG3:    addq.l    #4,a3
    dbra    d0,BbG1

* Un autre?
BbG4:    move.l    BbNext(a5),d0
    bne.s    BbG0
BbGx:

*******    AFFICHAGE
    move.l    W_Base(pc),a5
    move.l    T_BbPrio(a5),a5
* Explore tous les bobs
    move.l    (a5)+,d0
    beq    BbAx
* Valeurs communes au 16 et autre
BbA0:    move.l    d0,a4
    move.w    BbASize(a4),d2
    beq.s    BbAn
* Va retourner le bob???
    move.w    BbRetour(a4),d0
    move.l    BbARetour(a4),a0
    bsr    Retourne
* Va dessiner
    moveq    #0,d4
    move.w    BbTPlan(a4),d4
    move.l    BbAData(a4),a0
    move.l    BbEc(a4),a3
    lea    EcLogic(a3),a3
    move.w    BbAModD(a4),d0
    move.l    BbADraw(a4),a1
    bsr    BlitWait
    move.w    d0,BltModC(a6)
    move.w    d0,BltModD(a6)
    move.l    BbAMask(a4),d5
    jsr    (a1)
* Un autre?
BbAn:    move.l    (a5)+,d0
    bne    BbA0
******* FINI: remet le blitter
BbAx:    bsr    BlitWait
    bsr    DOwnBlit
    movem.l    (sp)+,d2-d7/a2-a6
    rts

******* ROUTINE DESSIN au pixel
BbAp:    bmi    BMAp
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    BbACon1(a4),BltCon1(a6)
    move.w    BbAAEc(a4),d3
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbAModO(a4),d0
    move.w    d0,BltModA(a6)
    move.w    d0,BltModB(a6)
    move.w    BbAMaskG(a4),BltMaskG(a6)
    move.w    BbAMaskD(a4),BltMaskD(a6)
    move.w    #0,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BbAp1:    lsr.w    #1,d1
    bcc.s    BbAp4
BbAp2:
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    d5,BltAdA(a6)
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BbAp4:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BbAp1
    rts

******* ROUTINE DESSIN au pixel trop grand
BbAL:    bmi    BmAp
    move.w    d2,d6
    lsr.w    #6,d6
    and.w    #%0111111,d2
    or.w    #%1000000,d2
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    BbACon1(a4),BltCon1(a6)
    move.w    BbAAEc(a4),d3
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbAModO(a4),d0
    move.w    d0,BltModA(a6)
    move.w    d0,BltModB(a6)
    move.w    BbAMaskG(a4),BltMaskG(a6)
    move.w    BbAMaskD(a4),BltMaskD(a6)
    move.w    #0,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BbAl1:    lsr.w    #1,d1
    bcc.s    BbAl5
BbAl2:
    move.l    (a3),a2
    add.l    d3,a2
    move.w    d6,d7
    bsr    BlitWait
    move.l    d5,BltAdA(a6)
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
BbAl3    bsr    BlitWait
    move.w    #0,BltDatA(a6)
    move.w    d2,BltSize(a6)
    subq.w    #1,d7
    bne.s    BbAl3
BbAl5:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BbAl1
    rts

******* ROUTINE DESSIN: Multiple de 16!
BbA16:    bmi    BMA16
    move.w    BbAAEc(a4),d3        * D3= Decalage ecran    
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbAModO(a4),d0        * Valeur MODULO
    move.w    d0,BltModA(a6)
    move.w    d0,BltModB(a6)
    move.w    BbACon0(a4),BltCon0(a6)    * Registres de controle
    move.w    #0,BltCon1(a6)
    moveq    #-1,d0
    move.w    d0,BltMaskG(a6)
    move.w    d0,BltMaskD(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BbA1:    lsr.w    #1,d1
    bcc.s    BbA4
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    d5,BltAdA(a6)
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BbA4:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BbA1
    rts

******* ROUTINE DESSIN SANS MASQUE, Multiple de 16!
BMA16:    move.w    BbAAEc(a4),d3
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbAModO(a4),BltModB(a6)

    move.w    BbACon0(a4),d0          *If minterm replace use
    cmp.b    #$CA,d0              *fast blit , ideal for
    bne.s    Normal_BMA16          *fast icon pasting in games!
    move.w    BbAModO(a4),BltModA(a6)      *
    move.w    #%100111110000,BltCon0(a6)*
    move.w    #0,BltCon1(a6)          *
    moveq    #-1,d0              *
    move.w    d0,BltMaskG(a6)          *
    move.w    d0,BltMaskD(a6)          *
    move.w    d0,BltDatB(a6)          *
    move.w    d0,BltDatC(a6)          *
    move.w    BbAPlan(a4),d1          *
    move.w    BbNPlan(a4),d0          *
BMA1f:    lsr.w    #1,d1              *
    bcc.s    BMA3f              *
    move.l    (a3),a2              *
    add.l    d3,a2              *
    bsr    BlitWait          *
    move.l    a0,BltAdA(a6)          *
    move.l    a2,BltAdD(a6)          *
    move.w    d2,BltSize(a6)          *
BMA3f:    add.l    d4,a0              *
    addq.l    #4,a3              *
    dbra    d0,BMA1f          *
    rts                  *

Normal_BMA16:
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    #0,BltCon1(a6)
    moveq    #-1,d0
    move.w    d0,BltMaskG(a6)
    move.w    d0,BltMaskD(a6)
    move.w    d0,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BMA1:    lsr.w    #1,d1
    bcc.s    BMA3
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BMA3:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BMA1
    rts

******* ROUTINE DESSIN SANS MASQUE, Pixel!
BMAp:    
    move.w    BbAAEc(a4),d3
    ext.l    d3
    lsl.l    #1,d3

    move.w    BbAModO(a4),BltModB(a6)
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    BbACon1(a4),BltCon1(a6)
    move.w    BbAMaskG(a4),BltMaskG(a6)
    move.w    BbAMaskD(a4),BltMaskD(a6)
    move.w    #-1,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BMAp1:    lsr.w    #1,d1
    bcc.s    BMAp4
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BMAp4:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BMAp1
    rts

******* ROUTINE DESSIN SANS MASQUE au pixel trop grand
BmAL:    move.w    d2,d6
    lsr.w    #6,d6
    and.w    #%0111111,d2
    or.w    #%1000000,d2
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    BbACon1(a4),BltCon1(a6)

    move.w    BbAAEc(a4),d3
    ext.l    d3
    lsl.l    #1,d3

    move.w    BbAModO(a4),BltModB(a6)
    move.w    BbAMaskG(a4),BltMaskG(a6)
    move.w    BbAMaskD(a4),BltMaskD(a6)
    move.w    #0,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BmAl1:    lsr.w    #1,d1
    bcc.s    Bmal7
    move.l    (a3),a2
    add.l    d3,a2
    move.w    d6,d7
    bsr    BlitWait
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
Bmal3:    bsr    BlitWait
    move.w    #-1,BltDatA(a6)
    move.w    d2,BltSize(a6)
    subq.w    #1,d7
    bne.s    Bmal3
Bmal7:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BmAl1
    rts


***********************************************************
*    Calcul de PEN/PAPER
***********************************************************
AdColor:
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

    include "src/AmosProUnityECS_library/Screens_Init.s"

    include "src/AmosProUnityECS_library/BraList_Screens.s"



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

    include "src/AmosProUnityECS_library/Screens.s"

    include "src/AmosProUnityECS_library/Autoback.s"

    include "src/AmosProUnityECS_library/Drawing2D.s"

    include "src/AmosProUnityECS_library/RainbowsSystem.s"

    include "src/AmosProUnityECS_library/Clipping.s"

    include "src/AmosProUnityECS_library/PatternsPainting.s"

    include "src/AmosProUnityECS_library/Fonts.s"

    include "src/AmosProUnityECS_library/Menus.s"

    include "src/AmosProUnityECS_library/Sliders2D.s"

    include "src/AmosProUnityECS_library/Flash.s"

    include "src/AmosProUnityECS_library/Shifter2D.s"

    include "src/AmosProUnityECS_library/FadingSystem.s"

    include "src/AmosProUnityECS_library/CopperListSystem.s"


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

    include    "src/AmosProUnityECS_library/Blitter.s"
    
    include    "src/AmosProUnityECS_library/Vbl.s"


******* RESERVATION MEMOIRE

	include    "src/AmosProUnityECS_library/MemoryHandler.s"

    include    "src/AmosProUnityECS_library/ChrStr.s"

    include    "src/AmosProUnityECS_library/AmalSystem.s"

    include    "src/AmosProUnityECS_library/AmosProLibrary_Start.s"

    include    "src/AmosProUnityECS_library/AmosProLibrary_End.s"



;    Envoie un signal à l''AMOS_Switcher (D3= signal)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Send_Switcher
    lea    Switcher(pc),a1
    move.l    $4.w,a6
    jsr    _LVOFindTask(a6)
    tst.l    d0
    beq.s    .PaSwi
    move.l    d0,a1
    moveq    #0,d0
    bset    d3,d0
    jsr    _LVOSignal(a6)
.PaSwi    rts











;    Fabrique la fonte par defaut
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Wi_MakeFonte
    movem.l    a2/d2-d7,-(sp)
    moveq    #0,d1            Ecran 16x8, 2 couleur
    moveq    #16,d2
    moveq    #8,d3
    moveq    #1,d4
    moveq    #0,d5
    moveq    #2,d6
    lea    Wi_MakeFonte(pc),a1
    bsr    EcCree
    bne    .Error
; Boucle de creation
    move.l    #8*256,d0
    SyCall    MemFastClear
    beq    .Error
    move.l    a0,T_JeuDefo(a5)
    move.l    a0,a2
    lea    32*8(a2),a0
    moveq    #32,d2
    move.w    #128,d3
    bsr    .CreeFont
    lea    160*8(a2),a0
    move.w    #160,d2
    move.w    #256,d3
    bsr    .CreeFont
; Poke les caracteres specifiques
    lea    Def_Font(pc),a0
    move.l    a2,a1
    moveq    #(8*32)/4-1,d0
.Copy1    move.l    (a0)+,(a1)+
    dbra    d0,.Copy1
    lea    128*8(a2),a1
    moveq    #(8*32)/4-1,d0
.Copy2    move.l    (a0)+,(a1)+
    dbra    d0,.Copy2
; A y est!
    moveq    #0,d0
    bra.s    .Out
; Erreur
.Error    moveq    #1,d0
; Sortie!
.Out    move.l    d0,-(sp)
    moveq    #0,d0
    bsr    EcDel
    move.l    (sp)+,d0
    movem.l    (sp)+,a2/d2-d7
    rts
; Saisit les caracteres d2-d3
.CreeFont
    movem.l    d2/d3/a2/a3/a6,-(sp)
    move.l    a0,a2
    move.l    T_EcCourant(a5),a3
.Car    move.l    T_RastPort(a5),a1        Le rastport
    move.w    #0,36(a1)            Curseur en 0,0
    move.w    #6,38(a1)
    moveq    #1,d0                Un caractere
    lea    .COut(pc),a0            
    move.b    d2,(a0)
    move.l    T_GfxBase(a5),a6        La fonction
    jsr    _LVOText(a6)
    move.l    EcLogic(a3),a0            Boucle de recopie
    move.w    EcTligne(a3),d0
    ext.l    d0
    moveq    #7,d1
.Loop    move.b    (a0),(a2)+
    add.l    d0,a0
    dbra    d1,.Loop
    addq.w    #1,d2
    cmp.w    d3,d2
    bcs.s    .Car
    movem.l    (sp)+,d2/d3/a2/a3/a6
    rts
.COut    dc.w    0

;    Effacement du jeu de caracteres
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Wi_DelFonte
    move.l    T_JeuDefo(a5),d0    
    beq.s    .Sip
    move.l    d0,a1
    move.l    #8*256,d0
    SyCall    MemFree
    clr.l    T_JeuDefo(a5)
.Sip    rts

***********************************************************
* Librairies
FntName:	dc.b	"diskfont.library",0
DevName		dc.b	"input.device",0
ConName		dc.b	"console.device",0
LayName		dc.b	"layers.library",0
TopazName	dc.b	"topaz.font",0
Switcher	dc.b	"_Switcher AMOS_",0
TaskName	dc.b	" AMOS",0
		even
***********************************************************

;     Patch sur LOADVIEW si AMOS TO FRONT si AA
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AMOS_LoadView
    tst.b    0.l            T_AMOSHere, modifie lors du patch...
    bne.s    .Wb
    move.l    Old_LoadView(pc),-(sp)
.Wb    rts    
Old_LoadView    dc.l    0        Ici et pas ailleurs...

; AMOS / WORKBENCH
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    D1=0    >     Workbench
;    D1>0    >    AMOS
;    D1<0    >    Rien (trouver valeur)
;    Retour D1= AMOS ici(-1), WB ici (0)
TAMOSWb
    tst.w    d1
    beq    .ToWB
    bmi    .Return

;     Back to AMOS
; ~~~~~~~~~~~~~~~~~~
.ToAMOS    tst.b    T_AMOSHere(a5)
    bne    .Return
    move.b    #-1,T_AMOSHere+1(a5)        Code interdisant les requester

; Load View(0) + WaitTOF si AA
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    btst    #WFlag_LoadView,T_WFlags(a5)
    beq.s    .PaAA0
    movem.l    d0-d3/a0-a2/a6,-(sp)

    move.l    T_IntBase(a5),a6        Ouvre un ecran LOWRES

    btst    #WFlag_WBClosed,T_WFlags(a5)    Si WB ferme, le referme!
    beq.s    .NoWB
    jsr    -78(a6)            
.NoWB
    move.l  T_GfxBase(a5),a6        WaitTOF
    move.l  34(a6),T_ViewPort(a5)
    move.l  #0,a1
    jsr -222(a6)                LoadView
    jsr -$10e(a6)
    jsr -$10e(a6)
    
    move.w     #%0000110000000000,$dff106     Sprite width / DualPF palette
.NoBug

    movem.l    (sp)+,d0-d3/a0-a2/a6
.PaAA0    
    lea    Circuits,a0            Remet les circuits
    move.w    #$8080,JoyTest(a0)
    move.l     T_CopPhysic(a5),$80(a0)
    clr.w     $88(a0)
    move.b    #-1,T_AMOSHere(a5)        AMOS en front!
    clr.b    T_AMOSHere+1(a5)        Flip termine!
    bra.s    .Return

;     Goto workbench
; ~~~~~~~~~~~~~~~~~~~~
.ToWB    tst.b    T_AMOSHere(a5)
    beq.s    .Return
    clr.b    T_AMOSHere(a5)            AMOS en fond!
    move.b    #-1,T_AMOSHere+1(a5)        Code interdisant les requesters

    move.w    T_OldDma(a5),$Dff096        Remet les chips
    move.l  T_GfxBase(a5),a0
    move.l  38(a0),$dff080
    clr.w    $dff088

; Efface l'ecran si AA
; ~~~~~~~~~~~~~~~~~~~~
    btst    #WFlag_LoadView,T_WFlags(a5)
    beq.s    .PaAA1
    movem.l    d0-d3/a0-a2/a6,-(sp)
    move.l    T_IntBase(a5),a6        Close Screen
    btst    #WFlag_WBClosed,T_WFlags(a5)    Si WB ferme, le rouvre!
    beq.s    .NoBW
    jsr    -210(a6)            Reopen workbench
.NoBW    
    move.l  T_ViewPort(a5),a1      Close screen
    move.l  T_GfxBase(a5),a6
    jsr     -222(a6)        load view
    jsr -$10e(a6)            WaitTOF
    jsr -$10e(a6)            WaitTOF
    movem.l    (sp)+,d0-d3/a0-a2/a6
.PaAA1
    clr.b    T_AMOSHere+1(a5)        Flip termine!

; Retourne l'etat actuel
; ~~~~~~~~~~~~~~~~~~~~~~
.Return    move.b    T_AMOSHere(a5),d1
    ext.w    d1
    ext.l    d1
    moveq    #0,d0
    rts

;    Clear CPU Caches
; ~~~~~~~~~~~~~~~~~~~~~~
Sys_ClearCache
    movem.l    a0-a1/a6/d0-d1,-(sp)
    move.l    $4.w,a6
    cmp.w    #37,$14(a6)            A partir de V37
    bcs.s    .Exit
    jsr    -$27c(a6)            CacheClearU
.Exit    movem.l    (sp)+,a0-a1/a6/d0-d1
    rts



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     ZONE DE DONNE CENTRALE (BEARK)
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;     Table des sauts aux affichages texte
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TAdCol        dc.l CZero-TAdCol,CNorm-TAdCol
        dc.l CInv-TAdCol,CUn-TAdCol
        dc.l CNul-TAdCol

;        Zone de donnee externe
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ConIo        ds.b     32+8
LConBuffer    equ    64
ConBuffer    ds.b     LConBuffer
ConEssai    ds.b    32
W_Base        ds.l    1
GfxBase        ds.l    1
WRastPort    ds.l    1
FoPat        dc.w    -1
; Autoback fenetres
WiAuto        ds.b    8*6+WiSAuto+4
        even
; Table de retournement bobs
TRetour        ds.b    256

;        Caracteres speciaux des fontes AMOS
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Def_Font    IncBin    "src/bin/WFont.bin"
        even

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * SYSTEME : SOURIS / CLAVIER / INTER VBL
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------

***********************************************************
*    DEMARRAGE A FROID DU SYSTEME
***********************************************************
SyInit:    
    bsr    AMALInit
    moveq    #0,d0
    rts
***********************************************************
*    ARRET FINAL DU SYSTEME
***********************************************************
SyEnd:    bsr    AMALEnd
    moveq    #0,d0
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     Initialisation / Fin du requester
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;    Demarrage du requester (a0)= default palette
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WRequest_Start
; Copy default palette    
    lea    8*2(a0),a0
    lea    Req_Pal+8*2(pc),a1
    moveq    #24-1,d0
CPal    move.w    (a0)+,(a1)+
    dbra    d0,CPal
; Branch the requester
    lea    AutoReq(pc),a2
    lea    EasyReq(pc),a3
    bsr.s    SetJump
    move.l    a2,T_PrevAuto(a5)
    move.l    a3,T_PrevEasy(a5)
    move.w    #-1,T_ReqFlag(a5)            * Default is AMOS request
    rts

;    Arret du requester
; ~~~~~~~~~~~~~~~~~~~~~~~~
WRequest_Stop
    tst.l    T_PrevAuto(a5)
    beq.s    .Skip
    move.l    T_PrevAuto(a5),a2
    move.l    T_PrevEasy(a5),a3
    bsr.s    SetJump
.Skip    rts

; Branche A2/a3 sur easy/auto request
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SetJump    movem.l    a0/a1/a6,-(sp)
    move.l    $4.w,a6
; AutoRequest
    move.l    a2,d0
    lea    -$15c,a0
    move.l    T_IntBase(a5),a1
    jsr    SetFunction(a6)
    move.l    d0,a2
; EasyRequest, seulement si wb>=2.0
    move.l    $4.w,a0
    cmp.w    #36,$14(a0)
    bcs.s    .skip
    move.l    a3,d0
    lea    -$1d4-(20*6),a0
    move.l    T_IntBase(a5),a1
    jsr    SetFunction(a6)
    move.l    d0,a3
.skip    movem.l    (sp)+,a0/a1/a6
    rts

    include "src/AmosProUnityECS_library/BraList_System.s"

***********************************************************
*    Gestion de la souris
***********************************************************

******* Branche les interruptions
VblInit:
* Init couleurs
    bsr    FlInit
    bsr    ShInit
* Init souris
    move.l    T_MouBank(a5),a0
    move.l    a0,T_MouDes(a5)
    move.w    2(a0),T_MouTY(a5)
    clr.w    T_MouXOld(a5)
    clr.w    T_MouYOld(a5)
    move.w    #-1,T_MouShow(a5)
* Branche les interruptions!
    bsr    Add_VBL
    rts

******* Branche PROPREMENT les interruptions VBL...
Add_VBL
    move.l    a6,-(sp)
    lea    T_VBL_Is(a5),a1
    move.b    #NT_INTERRUPT,Ln_Type(a1)
    move.b    #100,Ln_Pri(a1)
    clr.l    Ln_Name(a1)
    move.l    a5,IS_DATA(a1)
    lea    VBLIn(pc),a0
    move.l    a0,IS_CODE(a1)
    move.l    $4.w,a6
    move.l    #INTB_VERTB,d0
    jsr    _LVOAddIntServer(a6)
    move.l    (sp)+,a6
    rts
******* Debranche PROPREMENT les interruptions VBL...
Rem_VBL
VBLEnd
    move.l    a6,-(sp)
    lea    T_VBL_Is(a5),a1
    tst.l    IS_CODE(a1)
    beq.s    .skip
    move.l    $4.w,a6
    move.l    #INTB_VERTB,d0
    jsr    _LVORemIntServer(a6)
.skip    move.l    (sp)+,a6
    rts

******* Entree des interruptions
VblIn:    movem.l    d2-d7/a2-a4,-(sp)
    lea    Circuits,a6
    move.l    a1,a5
* Fait les switch entrelaces
    tst.w    T_InterBit(a5)
    beq.s    SIntX2
    lea    T_InterList(a5),a5
    move.l    (a5)+,d0
    beq.s    SIntX
    move.w    $4(a6),d6
SInt0    move.l    d0,a4            * Adresse ecran
    move.l    (a5)+,a3        * Adresse marqueur
    move.w    EcNPlan(a4),d5        * D5 Nb de plans
    subq.w    #1,d5
    move.l    (a3)+,d2
    beq.s    SInt4
SInt1    move.l    (a3)+,a0
    tst.w    d6
    bmi.s    SInt2
    move.w    EcTx(a4),d0
    lsr.w    #3,d0
    add.w    d0,a0
SInt2    move.w    d5,d1    
    move.l    d2,a2    
    lea    EcPhysic(a4),a1
SInt3    move.l    (a1)+,d0
    add.l    a0,d0
    move.w    d0,6(a2)
    swap    d0
    move.w    d0,2(a2)
    addq.l    #8,a2
    dbra    d1,SInt3
    move.l    (a3)+,d2
    bne.s    SInt1
SInt4    move.l    (a5)+,d0
    bne.s    SInt0
SIntX    move.l    W_Base(pc),a5
SIntX2

* Fait les screen swaps
    lea    T_SwapList(a5),a0
    move.l    (a0),d0
    beq.s    SSwpX
    clr.l    (a0)+
SSwp1:    move.l    a0,a1
    move.l    d0,a4
    move.w    (a1)+,d1        * Nb de plans
    move.l    (a4)+,d0
    beq.s    SSwp4
SSwp2:    move.l    (a4)+,d3        * Decalage
    move.l    d0,a3
    move.l    a1,a2
    move.w    d1,d2
SSwp3:    move.l    (a2)+,d0
    add.l    d3,d0
    move.w    d0,6(a3)
    swap    d0
    move.w    d0,2(a3)
    addq.l    #8,a3
    dbra    d2,SSwp3
    move.l    (a4)+,d0
    bne.s    SSwp2
SSwp4:    lea    SwapL-4(a0),a0
    move.l    (a0)+,d0
    bne.s    SSwp1    
SSwpX:

* Change l'adresses des sprites hard
    move.l    T_HsChange(a5),d0
    beq.s    VblPaHs
    clr.l    T_HsChange(a5)
    bsr    HsPCop
VblPaHs:

* Marque le VBL
    addq.l    #1,T_VBLCount(a5)
    addq.l    #1,T_VBLTimer(a5)
    subq.w    #1,T_EveCpt(a5)
    bset    #BitVBL,T_Actualise(a5)

* Appelle les autres routines
    lea    VblRout(a5),a4
    move.l    (a4)+,d0
    beq.s    VblPaCa
VblCall    move.l    d0,a0
    jsr    (a0)
    move.l    (a4)+,d0
    bne.s    VblCall
VblPaCa
* Affiche la souris 
    bsr    MousInt
* Couleurs
    lea    T_CopMark(a5),a3

    IFEQ    EZFlag
    bsr    Shifter
    ENDC

    bsr    FlInt
    bsr    FadeI

    IFEQ    EZFlag
* Animations
    move.w    T_SyncOff(a5),d0
    bne.s    PaSync
    bsr    Animeur
PaSync:
    ENDC

    movem.l    (sp)+,d2-d7/a2-a4
    lea    $DFF000,a0
    moveq    #0,d0
    rts

WVbl
    moveq   #1,d0
******* WAIT VBL D0, multitache
WVbl_D0    movem.l    d0-d1/a0-a1/a6,-(sp)
    move.w    d0,-(sp)
.Lp    move.l    T_GfxBase(a5),a6
    jsr    _LVOWaitTOF(a6)
    subq.w    #1,(sp)
    bne.s    .Lp
    addq.l    #2,sp
    movem.l    (sp)+,d0-d1/a0-a1/a6
    rts    

******* Traitement de la souris
MousInt:tst.b    T_AMOSHere(a5)
    beq    MouF

    move.w    T_MouseX(a5),d0
    move.w    T_MouseY(a5),d1

; Limite la souris
MouV7    cmp.w    T_MouXMin(a5),d0
    bge.s    Mou5
    move.w    T_MouXMin(a5),d0
Mou5:    cmp.w    T_MouXMax(a5),d0
    ble.s    Mou6
    move.w    T_MouXMax(a5),d0
Mou6:    cmp.w    T_MouYMin(a5),d1
    bge.s    Mou7
    move.w    T_MouYMin(a5),d1
Mou7:    cmp.w    T_MouYMax(a5),d1
    ble.s    Mou8
    move.w    T_MouYMax(a5),d1
Mou8:    move.w    d0,T_MouseX(a5)
    move.w    d1,T_MouseY(a5)
    lsr.w    #1,d0
    lsr.w    #1,d1
    move.w    d0,T_XMouse(a5)
    move.w    d1,T_YMouse(a5)

; Poke les mots de control, si SHOW
    move.w    T_MouShow(a5),d2
    bmi.s    MouF
    sub.w    T_MouHotX(a5),d0
    sub.w    T_MouHotY(a5),d1
    move.l    T_HsPhysic(a5),a0        ;Adresse du dessin
    move.l    T_HsLogic(a5),a1
    move.l    T_HsInter(a5),a2
    ror.w    #1,d0
    move.b    d1,d2
    lsl.w    #8,d2
    move.b    d0,d2
    move.w    d2,(a0)
    move.w    d2,(a1)
    move.w    d2,(a2)
    clr.w    d2
    btst    #8,d1
    beq.s    Mou10
    bset    #8+2,d2
Mou10:    add.w    T_MouTy(a5),d1
    move.b    d1,d2
    ror.w    #8,d2
    btst    #8,d1
    beq.s    Mou11
    bset    #1,d2
Mou11:    btst    #15,d0
    beq.s    Mou12
    bset    #0,d2
Mou12:    move.w    d2,2(a0)
    move.w    d2,2(a1)
    move.w    d2,2(a2)
MouF:    rts

***********************************************************
*    BOUTONS DE LA SOURIS
***********************************************************
MBout:    clr.w    d1
    tst.b    T_AMOSHere(a5)
    beq.s    MouB3
    move.w    T_MouXOld(a5),d0
    btst    #IEQUALIFIERB_LEFTBUTTON,d0
    beq.s    MouB1
    bset    #0,d1
MouB1:    btst    #IEQUALIFIERB_RBUTTON,d0
    beq.s    MouB2
    bset    #1,d1
MouB2:    btst    #IEQUALIFIERB_MIDBUTTON,d0
    beq.s    MouB3
    bset    #2,d1
MouB3:    moveq    #0,d0
    rts
******* Bouton relache?
MRout:    clr.w    d1
    clr.w    d2
    clr.w    d3
    tst.b    T_AMOSHere(a5)
    beq.s    MouB3
    move.w    T_OldMk(a5),d2
    move.w    T_MouXOld(a5),d0
    btst    #IEQUALIFIERB_LEFTBUTTON,d0
    beq.s    MouR1
    bset    #0,d3
    btst    #0,d2
    bne.s    MouR1
    bset    #0,d1
MouR1:    btst    #IEQUALIFIERB_RBUTTON,d0
    beq.s    MouR2
    bset    #1,d3
    btst    #1,d2
    bne.s    MouR2
    bset    #1,d1
MouR2:    btst    #IEQUALIFIERB_MIDBUTTON,d0
    beq.s    MouR3
    bset    #2,d3
    btst    #2,d2
    bne.s    MouR3
    bset    #2,d1
MouR3:    move.w    d3,T_OldMk(a5)
    moveq    #0,d0
    rts

**********************************************************
*    Remember MOUSE
MRecall:move.w    T_OMouShow(a5),T_MouShow(a5)
    move.w    T_OMouSpr(a5),d1
    bra.s    MChange
**********************************************************
*    Store MOUSE/SHOW ON
MStore:    move.w    T_MouShow(a5),T_OMouShow(a5)
    move.w    T_MouSpr(a5),T_OMouSpr(a5)
    clr.w    T_MouShow(a5)
    moveq    #0,d1
**********************************************************
*    CHANGE MOUSE D1
MChange:
*******
    move.w    T_MouShow(a5),-(sp)
    move.w    #-1,T_MouShow(a5)
MCh0:    move.w    d1,d2
    cmp.w    #3,d1
    bcc.s    MCh3
* Pointe dans la banque de la souris
    move.l    T_MouBank(a5),a0
    bra.s    MCh2
MCh1:    move.w    (a0)+,d0
    mulu    (a0)+,d0
    mulu    (a0)+,d0
    lsl.w    #1,d0
    lea    4(a0,d0.w),a0
MCh2:    subq.w    #1,d1
    bpl.s    MCh1
    bra.s    MCh4
* Pointe dans la banque de sprites
MCh3:    move.l    T_SprBank(a5),d0
    beq.s    MChE
    move.l    d0,a0
    subq.w    #3,d1
    cmp.w    (a0)+,d1
    bcc.s    MChE
    lsl.w    #3,d1
    move.l    0(a0,d1.w),a0
    cmp.w    #1,(a0)            * Verifie ke le sprite est bon!
    bne.s    MChE
    cmp.w    #2,4(a0)
    bne.s    MChE    
* Change!
MCh4:    move.w    d2,T_MouSpr(a5)
    move.l    a0,T_MouDes(a5)
    move.w    2(a0),T_MouTY(a5)
    move.w    6(a0),T_MouHotX(a5)
    move.w    8(a0),T_MouHotY(a5)
* Re-Affiche la souris???
    tst.w    (sp)
    bmi.s    MCh5
    bsr    HiSho1
    bra.s    MChX
MCh5:    bsr    HiHi
* Cbon
MChX:    move.w    (sp)+,T_MouShow(a5)
    moveq    #0,d0
    rts
* Erreur--> met la souris 1!
MChE:    moveq    #0,d1
    bra    MCh0

**********************************************************
*    HIDE / HIDE ON: D1= off/on
**********************************************************
MHide:    tst.w    T_CopON(a5)
    beq.s    HiSho0
    move.w    T_MouShow(a5),d0
    tst.w    d1
    bne.s    Hid1
    subq.w    #1,d0
    bra.s    HiSho
Hid1:    moveq    #-1,d0
    bra.s    HiSho

**********************************************************
*    SHOW / SHOW ON: D1= off/on
**********************************************************
MShow:    tst.w    T_CopON(a5)        * Si COPPER OFF -> NON!!!
    beq.s    HiSho0
    move.w    T_MouShow(a5),d0
    tst.w    d1
    bne.s    Sho1
    addq.w    #1,d0
    bra.s    HiSho
Sho1:    moveq    #0,d0

******* Routine commune / affiche - eteint
HiSho:    move.w    d0,T_MouShow(a5)
    beq.s    HiSho1
    cmp.w    #-1,d0
    bne.s    HiSho0
; HIDE
HiHi:    moveq    #0,d1
    bsr    HsUSet
    bsr    HAa3
HiSho0:    moveq    #0,d0
    rts
; SHOW
HiSho1:    move.w    #-1,T_MouShow(a5)
    moveq    #0,d1
    move.w    T_XMouse(a5),d2
    move.w    T_YMouse(a5),d3
    move.l    T_MouDes(a5),a1
    bsr    HsSet
    bsr    HAa3
    clr.w    T_MouShow(a5)
    moveq    #0,d0
    rts
* Appele TROIS fois HsAff!
HAa3:    move.w    #3,-(sp)
HA3a:    tst.l    T_HsChange(a5)
    bne.s    HA3a
    bsr    HsAff
    subq.w    #1,(sp)
    bne.s    HA3a
    addq.l    #2,sp
    rts

**********************************************************
*    COORDONNEES
**********************************************************
******* Ecrans D3
*    <0    => Rien du tout
*    0    => Ecran courant
*    >0    => Ecran+1
EcToD1:    tst.w    d3
    bmi.s    EcToD4
    bne.s    EcToD2
    move.l    T_EcCourant(a5),a0
    rts
EcToD2:    lsl.w    #2,d3
    lea    T_EcAdr(a5),a0
    move.l    -4(a0,d3.w),d3
    beq.s    EcToD3
    move.l    d3,a0
    rts
EcToD3:    addq.l    #4,sp
    moveq    #3,d0
    rts
EcToD4:    addq.l    #4,sp
    move.l    #EntNul,d1
    move.l    d1,d2
    moveq    #0,d0
    rts

*******    XYMOUSE 
MXy:    moveq    #0,d1
    moveq    #0,d2
    move.w    T_XMouse(a5),d1
    move.w    T_YMouse(a5),d2
    moveq    #0,d3
    rts

******* XYSCREEN: conversion HARD-> SCREEN
*    D3-> Ecran
*    D1-> X
*    D2-> Y
CXyScr    bsr    EcToD1
* Coordonnee en Y
    add.w    #EcYBase,d2
    sub.w    EcWy(a0),d2
    btst    #2,EcCon0+1(a0)
    beq.s    XyH0
    asl.w    #1,d2
XyH0    add.w    EcVy(a0),d2
    ext.l    d2
* Coordonnee en X
XyH1:    sub.w    EcWx(a0),d1
    btst    #7,EcCon0(a0)
    beq.s    XyH2
    asl.w    #1,d1
XyH2:    add.w    EcVx(a0),d1
    ext.l    d1
    moveq    #0,d0
    rts

******* XYHARD : conversion SCREEN -> HARD
*    D3= ecran
*    D1/D2= x/y
CXyHard    bsr    EcToD1
* Coordonnee en X
CXyS:    tst.w    EcCon0(a0)
    bpl.s    CXyS0
    asr.w    #1,d1
CXyS0:    add.w    EcWX(a0),d1
    ext.l    d1
* Coordonnee en Y
CXyS2:    btst    #2,EcCon0+1(a0)
    beq.s    CXyS3
    asr.w    #1,d2
CXyS3    add.w    EcWY(a0),d2
    sub.w    #EcYBase,d2
    ext.l    d2
    moveq    #0,d0
    rts
    
******* XY WINDOW : conversion XY screen -> XY window
*    D1/D2= X/Y
CXyWi:    move.l    T_EcCourant(a5),a0
    move.l    EcWindow(a0),a0
* En X
    sub.w    WiDyI(a0),d2
    bmi.s    CXyw0
    divu    WiTyCar(a0),d2
    cmp.w    WiTyI(a0),d2
    bcc.s    CXyw0
    ext.l    d2
    bra.s    CXyw1
CXyw0:    move.l    #EntNul,d2
* En Y
CXyw1:    lsr.w    #3,d1
    sub.w    WiDxI(a0),d1
    bmi.s    CXyw3
    cmp.w    WiTxI(a0),d1
    bcc.s    CXyW3
    ext.l    d1
CXyw2:    move.l    d2,d0            D0= Signe
    or.l    d1,d0
    rts
CXyw3:    move.l    #EntNul,d1
    bra.s    CXyw2

******* Retourne la souris dans l'ecran de devant
WMouScrFront    
    move.l    d4,-(sp)
    move.w    T_XMouse(a5),d1
    move.w    T_YMouse(a5),d2
    moveq    #0,d3
    moveq    #16,d4
    bsr    GetSIn
    move.l    d1,d3
    bmi.s    .Out
    move.l    d1,-(sp)
    addq.w    #1,d3
    move.w    T_XMouse(a5),d1
    move.w    T_YMouse(a5),d2
    bsr    CXYScr
    move.l    (sp)+,d0
.Out    movem.l    (sp)+,d4
    rts
.Hors    moveq    #-1,d0
    bra.s    .Out

******* Recherche l'ecran contenant X/Y
*    D1/D2= X/Y HARD
*    D3= 1er ecran
*    D4= Ecran MAX
GetSIn:    lea    T_EcPri(a5),a1
    add.w    #EcYBase,d2
    tst.w    d3
    beq.s    GSin1
    bmi.s    GSin1
    bsr    EcToD1
    move.l    a1,a2
GSin0:    tst.l    (a2)
    bmi.s    GSin1
    cmp.l    (a2)+,a0
    bne.s    GSin0
    lea    -4(a2),a1
* Cherche l'ecran dans l'ordre des priorites
GSin1:    move.l    (a1)+,d0
    bmi.s    GSinX
    move.l    d0,a0
    cmp.w    EcNumber(a0),d4
    bls.s    GSin1
    btst    #BitHide,EcFlags(a0)
    bne.s    GSin1
* Coordonnee en X
    move.w    d1,d3
    sub.w    EcWx(a0),d3
    bcs.s    GSin1
    cmp.w    EcWTx(a0),d3
    bcc.s    GSin1
* Coordonnee en Y
    move.w    d2,d3
    sub.w    EcWy(a0),d3
    bcs.s    GSin1
    cmp.w    EcWTy(a0),d3
    bcc.s    GSin1
* Trouve!
    moveq    #0,d1
    move.w    EcNumber(a0),d1
    moveq    #0,d0
    rts
* Pas trouve!
GSinX:    move.l    #EntNul,d1
    moveq    #0,d0
    rts

**********************************************************
*    SET MOUSE
**********************************************************

******* Set mouse ABSOLU
MSetAb:    move.l    #EntNul,d0

    cmp.l    d0,d1
    beq.s    MSaX
    lsl.w    #1,d1
    cmp.w    T_MouXMin(a5),d1
    bcc.s    MSa1
    move.w    T_MouXMin(a5),d1
MSa1:    cmp.w    T_MouXMax(a5),d1
    bcs.s    MSa2
    move.w    T_MouXMax(a5),d1
MSa2:    move.w    d1,T_MouseX(a5)
    lsr.w    #1,d1
    move.w    d1,T_XMouse(a5)

MSaX    cmp.l    d0,d2
    beq.s    MSaXx
    lsl.w    #1,d2
    cmp.w    T_MouYMin(a5),d2
    bcc.s    MSa3
    move.w    T_MouYMin(a5),d2
MSa3:    cmp.w    T_MouYMax(a5),d2
    bcs.s    MSa4
    move.w    T_MouYMax(a5),d2
MSa4:    move.w    d2,T_MouseY(a5)
    lsr.w    #1,d2
    move.w    d2,T_YMouse(a5)

MSaXx:    moveq    #0,d0
    rts

**********************************************************
*    LIMIT MOUSE D1/D2/D3/D4
**********************************************************
******* LIMIT MOUSE ECRAN
*    D1= 0-> ecran courant
*    D1>0 -> ecran
MLimEc    move.w    d1,d3
    move.w    d1,d4
    clr.w    d1
    clr.w    d2
    bsr    CXyHard
    movem.w    d1/d2,-(sp)    
    move.w    EcTx(a0),d1
    move.w    EcTy(a0),d2
    subq.w    #1,d1
    subq.w    #1,d2 
    move.w    d4,d3
    bsr    CXyHard
    move.w    d1,d3
    move.w    d2,d4
    movem.w    (sp)+,d1-d2
******* Absolu
MLimA:    cmp.w    #458,d3
    bls.s    MLima1
    move.w    #458,d3
MLima1    cmp.w    #312,d4
    bls.s    MLima2
    move.w    #312,d4
MLima2    tst.w    d1
    bpl.s    MLima3
    clr.w    d1
MLima3    tst.w    d2
    bpl.s    MLima4
    clr.w    d2
MLima4    cmp.w    d3,d1
    bls.s    MLima5
    exg    d1,d3
MLima5    cmp.w    d4,d2
    bls.s    MLima6
    exg    d2,d4
MLima6    lsl.w    #1,d1
    lsl.w    #1,d2
    lsl.w    #1,d3
    lsl.w    #1,d4
    move.w    d1,T_MouXMin(a5)
    move.w    d3,T_MouXMax(a5)
    move.w    d2,T_MouYMin(a5)
    move.w    d4,T_MouYMax(a5)
    moveq    #0,d0
    rts

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

    include "src/AmosProUnityECS_library/Zones.s"

    include "src/AmosProUnityECS_library/Sprites.s"

    include "src/AmosProUnityECS_library/Blocks.s"

;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * TRAPPE FENETRES
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------


; OPEN CONSOLE.DEVICE
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OpConsole
    lea    ConIo(pc),a1
    moveq    #(Lio+Lmsg)/2-1,d0
.Clean    clr.w    (a1)+
    dbra    d0,.Clean
    move.l    $4.w,a6
    lea    ConName(pc),a0
    lea    ConIo(pc),a1
    moveq    #-1,d0            Console #= -1
    moveq    #0,d1
    jsr    OpenDev(a6)
    rts

; OPEN INPUT.DEVICE
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A1->     pointeur sur zone libre!!!
OpInput
    move.l    a1,-(sp)
* Clean
    moveq    #(Lio+Lmsg)/2-1,d0
OpInp1    clr.w    (a1)+
    dbra    d0,OpInp1
* Creates port
    sub.l    a1,a1
    move.l    $4.w,a6
    jsr    FindTask(a6)
    move.l    (sp),a1
    lea    Lio(a1),a1
    move.l    d0,$10(a1)
    jsr    AddPort(a6)
* Open device
    lea    DevName(pc),a0
    move.l    (sp),a1
    moveq    #0,d0
    moveq    #0,d1
    jsr    OpenDev(a6)
    move.l    (sp)+,a1
    lea    Lio(a1),a0
    move.l    a0,14(a1)
    rts

; CLOSE input.device
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClInput    move.l    a1,-(sp)
; Close device
    move.l    $4.w,a6
    jsr    CloseDev(a6)
; Close port
    move.l    (sp)+,a1
    lea    Lio(a1),a1
    jsr    RemPort(a6)
    rts    

; Input handler, branche sur la chaine des inputs.
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IoHandler
    move.l    a5,-(sp)
    move.l    W_Base(pc),a5
; Si inhibe, laisse TOUT passer!
    tst.w    T_Inhibit(a5)
    bne.s    I_Inhibit
; Continue...
    move.b    T_AMOSHere(a5),d4        Si AMOS pas la,
    ext.w    d4
    bne.s    .Skip
    bset    #WFlag_Event,T_WFlags(a5)    Marque des faux events!
.Skip    move.l    a0,d0
    move.l    a0,d2
    moveq    #0,d3
IeLoop    move.b    Ie_Class(a0),d1
    cmp.b    #IeClass_RawMouse,d1
    beq.s    IeMous
    cmp.b    #IeClass_Rawkey,d1
    beq    IeKey
    cmp.b    #IeClass_DiskInserted,d1
    beq.s    IeDIn
    cmp.b    #IeClass_DiskRemoved,d1
    beq.s    IeDOut
IeLp1    move.l    d2,d3
    move.l    (a0),d2
IeLp2    move.l    d2,a0
    bne.s    IeLoop
IeLpX    move.l    (sp)+,a5
    rts
I_Inhibit    
    move.l    (sp)+,a5
    move.l    a0,d0
    rts    
; Disc inserted
IeDIn    bset    #WFlag_Event,T_WFlags(a5)
    move.w    #-1,T_DiscIn(a5)
    bra.s    IeLp1
; Disc removed
IeDOut    bset    #WFlag_Event,T_WFlags(a5)
    clr.w    T_DiscIn(a5)
    bra.s    IeLp1    
; Evenement Mouse, fait le mouvement!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IeMous    tst.w    d4
    beq.s    IeLp1
    bset    #WFlag_Event,T_WFlags(a5)        Flag: un event!
    cmp.l    #Fake_Code,ie_X(a0)    Un faux evenement?
    beq.s    IeFake
IeNof    move.w    T_MouYOld(a5),d1    * Devenir des MOUSERAW
    and.w    #$0003,d1        * 0-> Normal
    beq.s    .norm            * 1-> Trash
    subq.w    #2,d1            * 2-> Tout passe
    bmi.s    IeTrash            * 3-> Mouvements seuls
    beq.s    IeLp1
; Mode key only>>> prend les touches, laisse passer les mouvements
    move.w    ie_Qualifier(a0),T_MouXOld(a5)
    and.w    #%1000111111111111,ie_Qualifier(a0)
    move.w    ie_Code(a0),d1
    and.w    #$7f,d1
    cmp.w    #IECODE_LBUTTON,d1
    beq.s    .ski1
    cmp.w    #IECODE_RBUTTON,d1
    bne.s    IeLp1
.ski1    move.w    #IECODE_NOBUTTON,ie_Code(a0)
    bra.s    IeLp1
; Mode normal>>> prend et met a la poubelle
.norm    move.w    ie_Qualifier(a0),d1
    move.w    d1,T_MouXOld(a5)
    btst    #IEQUALIFIERB_RELATIVEMOUSE,d1
    beq.s    IeTrash
    move.w    ie_X(a0),d1
    add.w    d1,T_MouseX(a5)
    move.w    ie_Y(a0),d1
    add.w    d1,T_MouseY(a5)
; Event to trash!
IeTrash    tst.l    d3
    beq.s    IeTr1
    move.l    d3,a1
    move.l    (a0),d2
    move.l    d2,(a1)
    bra    IeLp2
IeTr1    move.l    (a0),d0
    move.l    d0,a0
    bne    IeLoop
    move.l    (sp)+,a5
    rts
; Faux evenement clavier...
; ~~~~~~~~~~~~~~~~~~~~~~~~~
IeFake    cmp.w    #IEQUALIFIER_RELATIVEMOUSE,ie_Qualifier(a0)
    bne    IeNof
    clr.l    ie_X(a0)            Plus de decalage
    bra    IeLp1                On laisse passer
; Event clavier: prend le caractere au vol
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IeKey    bset    #WFlag_Event,T_WFlags(a5)
    bsr    Cla_Event
    bne.s    .IeKy1
.IeKy0    tst.w    d4        Event to trash ou non
    bne.s    IeTrash
    bra    IeLp1
; AMIGA-A pressed
; ~~~~~~~~~~~~~~~
.IeKy1    tst.w    T_NoFlip(a5)
    bne.s    .IeKy0
    btst    #WFlag_LoadView,T_WFlags(a5)
    bne.s    .AA    
; Appel de TAMOSWb, rapide...
    movem.l    a0-a1/d0-d1,-(sp)
    moveq    #0,d1
    tst.w    d4
    bne.s    .Ska
    moveq    #1,d1
.Ska    bsr    TAMOSWb
    movem.l    (sp)+,a0-a1/d0-d1
    bra    IeTrash
; Marque pour TESTS CYCLIQUES
.AA    bset    #WFlag_AmigaA,T_WFlags(a5)
    bra    IeTrash

;     Gestion des evenements clavier
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A0=    EVENT KEY
;    D4=    Flag AMOS / WB
Cla_Event
    movem.l    a0-a1/d0-d3,-(sp)
    move.w    Ie_Code(a0),d0
    bclr    #7,d0
    bne    .ClaI2
; Appui sur une touche
; ~~~~~~~~~~~~~~~~~~~~
    cmp.b    #$68,d0                Shifts>>> pas stockes
    bcc.s    .RawK
    cmp.b    #$40,d0
    bcs.s    .RawK
    cmp.b    #$60,d0
    bcc    .Cont
; Conversion a la main des codes speciaux
    lea    Cla_Special-$40(pc),a1
    move.b    0(a1,d0.w),d1
    bpl    .Rien
    cmp.b    #$FF,d1
    beq.s    .RawK
; Une touche de fonction AMOS?
    moveq    #0,d1                Ascii nul
    move.b    Ie_Qualifier+1(a0),d2        Les shifts
    btst    #6,d2
    beq.s    .FFk1
    lea    T_TFF1(a5),a1            Touches 1-10
    bra.s    .FFk2
.FFk1    btst    #7,d2                Pas AMIGA>>> Touche normale
    beq.s    .Rien
    lea    T_TFF2(a5),a1            Touches 11-20
.FFk2    move.w    d0,d2
    sub.w    #$50,d2
    mulu    #FFkLong,d2
    lea    0(a1,d2.w),a1
    tst.b    (a1)
    beq.s    .Rien
    bsr    ClPutK
    moveq    #0,d2
    bra    .ClaIX
; Appel de RAWKEYCONVERT et stockage si AMOS present
.RawK    move.b    Ie_Qualifier+1(a0),d2        Prend CONTROL
    and.b    #%11110111,Ie_Qualifier+1(a0)    Plus de CONTROL
    movem.l    a0/a2/a6,-(sp)    
    lea    ConIo(pc),a6            Structure IO
    move.l    20(a6),a6            io_device
    lea    ConBuffer(pc),a1            Buffer de sortie
    sub.l    a2,a2                Current Keymap
    moveq    #LConBuffer,d1            Longueur du buffer
    jsr    -$30(a6)            RawKeyConvert
    move.w    d0,d3
    movem.l    (sp)+,a0/a2/a6
    move.b    d2,Ie_Qualifier+1(a0)        Remet CONTROL
    move.w    Ie_Code(a0),d0
    moveq    #0,d1
    subq.w    #1,d3
    bmi.s    .Rien
    lea    ConBuffer(pc),a1            Une seule touche
    move.b    (a1),d1
.Rien    move.b    Ie_Qualifier+1(a0),d2        Les shifts!
; Amiga-A?
.A    move.b    d2,d3
    and.b    T_AmigA_Shifts(a5),d3        
    cmp.b    T_AmigA_Shifts(a5),d3
    bne.s    .AAA
    cmp.b    T_AmigA_Ascii1(a5),d1
    beq.s    .AA
    cmp.b    T_AmigA_Ascii2(a5),d1
    bne.s    .AAA
.AA    moveq    #-1,d2
    bra.s    .ClaI1    
; AMOS Not here: stop!
.AAA    tst.w    d4
    beq.s    .Cont
; Est-ce un CONTROL-C?
    btst    #3,d2
    beq.s    .Sto
    cmp.b    #"C",d1
    beq.s    .C
    cmp.b    #"c",d1
    bne.s    .Sto
.C    bset    #BitControl,T_Actualise(a5)
    bra.s    .Cont
; Stocke dans le buffer
.Sto    bsr    Cla_Stocke            On stocke!
; Change la table
.Cont    moveq    #0,d2
.ClaI1    move.w    d0,d1
    and.w    #$0007,d0
    lsr.w    #3,d1
    lea    T_ClTable(a5),a0
    bset    d0,0(a0,d1.w)
.ClaIX    tst.w    d2
    movem.l    (sp)+,a0-a1/d0-d3
    rts
; Relachement d'une touche
; ~~~~~~~~~~~~~~~~~~~~~~~~
.ClaI2    move.w    d0,d1
    and.w    #$0007,d0
    lsr.w    #3,d1
    lea    T_ClTable(a5),a1
    bclr    d0,0(a1,d1.w)
.ClaIF    moveq    #0,d0
    movem.l    (sp)+,a0-a1/d0-d3
    rts

; Table des touches $40->$5f
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
Cla_Special
    dc.b    $ff,$08,$09,$0d,$0d,$1b,$00,$00        $40>$47
    dc.b    $00,$00,$ff,$00,$1e,$1f,$1c,$1d        $48>$4f
    dc.b    $fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe        $50>$57
    dc.b    $fe,$fe,$ff,$ff,$ff,$ff,$ff,$00        $58>$5f
    
; Stocke D0/D1/D2 dans le buffer clavier
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    D0    Rawkey
;    D1    Ascii
;    D2    Shifts
Cla_Stocke
    movem.l    a0/d3,-(sp)
    lea    T_ClBuffer(a5),a0
    move.w    T_ClTete(a5),d3
    addq.w    #3,d3
    cmp.w    #ClLong,d3
    bcs.s    .ClS11
    clr.w    d3
.ClS11    cmp.w    T_ClQueue(a5),d3
    beq.s    .ClS12
    move.w    d3,T_ClTete(a5)
    move.b    d2,0(a0,d3.w)
    move.b    d0,1(a0,d3.w)
    move.b    d1,2(a0,d3.w)
.ClS12    move.b    d2,-4(a0)
    move.b    d0,-3(a0)
    move.b    d1,-1(a0)
.ClSFin    movem.l    (sp)+,a0/d3
    rts

; Envoi d'un faux event souris au systeme
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WSend_FakeEvent
    movem.l    d0-d1/a1/a6,-(sp)
    lea    Fake_Event(pc),a0
    move.b    #IECLASS_RAWMOUSE,ie_Class(a0)
    clr.b    ie_SubClass(a0)    
    move.w    #IECODE_NOBUTTON,ie_Code(a0)
    move.w    #IEQUALIFIER_RELATIVEMOUSE,ie_Qualifier(a0)
    move.l    #Fake_Code,ie_X(a0)
    lea    T_IoDevice(a5),a1
    move.l    a0,io_Data(a1)
    move.w    #IND_WRITEEVENT,io_Command(a1)
    move.l    #22,io_Length(a1)
    move.l    $4.w,a6
    jsr    _LVODoIO(a6)
    movem.l    (sp)+,d0-d1/a1/a6
    rts
Fake_Code    equ    $789A789A        
; Faux evenement souris
Fake_Event    dc.l    0                0
        dc.b    IeClass_RawMouse        4
        dc.b    0                5
        dc.w    IECODE_NOBUTTON            6
        dc.w    0                8
        dc.w    0                10
        dc.w    0                12
        dc.l    0                14 Time Stamp
        dc.l    0                18   "    "

; Initialisation / Vide du buffer clavier
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClInit    
ClVide    move.w    T_ClTete(a5),T_ClQueue(a5)
    clr.b    T_ClFlag(a5)
    moveq    #0,d0
    rts

; KEY WAIT, retourne BNE si des touches en attente
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClKWait    moveq    #0,d0
    move.w    T_ClQueue(a5),d1
    cmp.w    T_ClTete(a5),d1
    rts
    
; INKEY: D1 haut: SHIFTS/SCANCODE - D1 bas: ASCII 
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClInky    moveq    #0,d1
    move.w    T_ClQueue(a5),d2
    cmp.w    T_ClTete(a5),d2
    beq.s    Ink2
    lea    T_ClBuffer(a5),a0
    addq.w    #3,d2
    cmp.w    #ClLong,d2
    bcs.s    Ink1
    moveq    #0,d2
Ink1:    move.b    0(a0,d2.w),d1
    lsl.w    #8,d1
    move.b    1(a0,d2.w),d1
    swap    d1
    move.b    2(a0,d2.w),d1
    move.w    d2,T_ClQueue(a5)
Ink2:    moveq    #0,d0
    rts

; Change KEY MAP A1
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClKeyM    rts

***********************************************************
*    Set key speed D1,d2
*    A1---> Buffer libre!!!
***********************************************************
TKSpeed    movem.l    a3-a6,-(sp)
    move.l    a1,-(sp)
    movem.l    d1/d2,-(sp)
    bsr    OpInput
    move.l    (sp),d0
    bsr    CalRep
    move.w    #IND_SETTHRESH,io_command(a1)
    move.l    $4.w,a6
    jsr    DoIO(a6)
    move.l    4(sp),d0
    move.l    8(sp),a1
    bsr    CalRep
    move.w    #IND_SETPERIOD,io_command(a1)
    move.l    $4.w,a6
    jsr    DoIO(a6)
    move.l    8(sp),a1
    bsr    ClInput
    lea    12(sp),sp
    movem.l    (sp)+,a3-a6
    moveq    #0,d0
    rts
CalRep    ext.l    d0
    divu    #50,d0
    move.w    d0,d1
    swap    d0
    ext.l    d0
    mulu    #20000,d0
    move.l    d1,$20(a1)        tv_secs
    move.l    d0,$24(a1)        tv_micro
    rts

; Get shifts
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClSh:    moveq    #0,d1
    move.b    T_ClShift(a5),d1
    moveq    #0,d0
    rts

; Instant key D1: 0=relache / -1= enfonce
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClInst:    and.w    #$7F,d1
    move.w    d1,d0
    and.w    #$0007,d0
    lsr.w    #3,d1
    lea    T_ClTable(a5),a0
    lea    0(a0,d1.w),a0
    moveq    #0,d1
    btst    d0,(a0)
    beq.s    Inst
    moveq    #-1,d1
Inst:    moveq    #0,d0
    rts

; PUT KEY: stocke la chaine (A1) dans le buffer
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClPutK:    move.l    a0,-(sp)
    movem.w    d0-d3,-(sp)
    lea    T_ClBuffer(a5),a0
ClPk0:    clr.b    d0
    clr.b    d1
    move.b    (a1)+,d2
    beq.s    ClPk4
    cmp.b    #"'",d2            * REM
    beq.s    ClPk5
    cmp.b    #1,d2            * ESC
    bne.s    ClPk1
    move.b    (a1)+,d0        * Puis SHF/SCAN/ASCI
    move.b    (a1)+,d1
    move.b    (a1)+,d2
; Stocke!
ClPk1:    move.w    T_ClTete(a5),d3
    addq.w    #3,d3
    cmp.w    #ClLong,d3
    bcs.s    ClPk2
    clr.w    d3
ClPk2:    cmp.w    T_ClQueue(a5),d3
    beq.s    ClPk4
    move.b    d0,0(a0,d3.w)
    move.b    d1,1(a0,d3.w)
    move.b    d2,2(a0,d3.w)
    move.w    d3,T_ClTete(a5)
ClPk3:    bra.s    ClPk0
ClPk5:    move.b    (a1)+,d2
    beq.s    ClPk4
    cmp.b    #"'",d2
    bne.s    ClPk5
    bra.s    ClPk0
ClPk4:    movem.w    (sp)+,d0-d3
    move.l    (sp)+,a0
    rts

; FUNC KEY: stocke la chaine (A1) en fonc D1
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClFFk:    movem.l    d1-d2,-(sp)
    lea    T_TFF1(a5),a0
    mulu    #FFkLong,d1
    add.w    d1,a0
    clr.w    d0
ClF1:    clr.b    (a0)
    move.b    (a1)+,d2
    beq.s    ClFx
    cmp.b    #1,d2
    beq.s    ClF2
    cmp.b    #"`",d2
    beq.s    ClF3
    addq.w    #1,d0
    cmp.w    #FFkLong-1,d0
    bcc.s    ClF1
    move.b    d2,(a0)+
    bra.s    ClF1
ClFx:    movem.l    (sp)+,d1-d2
    move.l    a1,a0
    moveq    #0,d0
    rts
ClF2:    addq.w    #4,d0
    addq.l    #3,a1
    cmp.w    #FFkLong-1,d0
    bcc.s    ClF1
    move.b    d2,(a0)+
    move.b    -3(a1),(a0)+
    move.b    -2(a1),(a0)+
    move.b    -1(a1),(a0)+
    bra.s    ClF1
ClF3:    addq.w    #2,d0
    cmp.w    #FFkLong-1,d0
    bcc.s    ClF1
    move.b    #13,(a0)+
    move.b    #10,(a0)+
    bra.s    ClF1

; GET KEY: ramene la touche de fonction
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClGFFk:    lea    T_TFF1(a5),a0
    move.w    d1,d0
    mulu    #FFkLong,d0
    add.w    d0,a0
    moveq    #0,d0
    rts

; RETOUR L'ETAT DU FLAG DISC
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
; Verifie l'inhibition
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
; Attend qu'il se retransforme en " "
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

    include "src/AmosProUnityECS_library/BraList_Windows.s"

    include "src/AmosProUnityECS_library/Windows.s"

    include "src/AmosProUnityECS_library/Text.s"

***********************************************************
*    MESSAGES D'ERREUR
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

    include "src/AmosProUnityAGA_library/Requesters.s"

***********************************************************

    include "src/AmosProUnityAGA_library/BraList_Controls.s"

    include "src/AmosProUnityAGA_library/BraList_Escapes.s"

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

    IFNE    EzFlag
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


